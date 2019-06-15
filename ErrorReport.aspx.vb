Imports System.Data.SqlClient
Imports System.IO
Imports System.Web.Configuration

Public Class ErrorReport
    Inherits System.Web.UI.Page
    Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)
    Public Const ADMIN As Integer = 1
    Public Const AUDITOR_ID As Integer = 2
    Public Const HOUSING_SPECALIST As Integer = 3

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'If auditee only display files that they are the staff
        Dim sessionUserID As String = GetSessionUserID()
        Dim sessionUserRoleID As Integer = GetUserRoleID(sessionUserID)

        If sessionUserRoleID = HOUSING_SPECALIST Then
            DisplayListingsBasedOnHousingSpecialist(sessionUserID)
        End If

        If Not IsPostBack Then
            If Not Request.QueryString("FileID") Is Nothing And Not Request.QueryString("ReviewTypeID") Is Nothing And Not Request.QueryString("ProcessTypeID") Is Nothing Then
                'Review Type and Process based on Review List
                SetReportBasedOnReviewAndProcess(Request.QueryString("FileID"), Request.QueryString("ReviewTypeID"), Request.QueryString("ProcessTypeID"))
                SetFiltersToAll()
            ElseIf Not Request.QueryString("FileID") Is Nothing Then
                'All Errors based on Review List
                SetReportBasedOnFile(Request.QueryString("FileID"))
                SetFiltersToAll()
            Else
                SetFiltersToAll()
            End If
        End If
    End Sub

    Private Sub BindGridWithFilters()
        Dim sessionUserID As String = GetSessionUserID()
        Dim sessionUserRoleID As Integer = GetUserRoleID(sessionUserID)

        Select Case sessionUserRoleID
            Case ADMIN To AUDITOR_ID
                Dim sql As String = "SELECT FileErrors.fk_FileID, FileErrors.ErrorID, Files.ClientFirstName + ' ' + Files.ClientLastName AS Client, Files.IsFileDisable, " &
                                    "       Files.EliteID, Files.fk_CaseManagerID, FileStaff.FirstName + ' ' + FileStaff.LastName AS FileStaffName,  FileStaff.fk_GroupID, FileStaffGroup.[Group]," &
                                    "        FileErrors.fk_ErrorStaffID, ErrorStaff.FirstName + ' ' + ErrorStaff.LastName AS ErrorStaffName, " &
                                    "       Auditor.UserID, Auditor.FirstName + ' ' + Auditor.LastName AS AuditorName, ReviewTypes.ReviewTypeID, ReviewTypes.Review, " &
                                    "       CONVERT (varchar(MAX), CAST(Files.ReviewDate AS date), 101) AS ReviewDate, " &
                                    "       CONVERT (varchar(MAX), CAST(Files.EffectiveDate AS date), 101) AS EffectiveDate, " &
                                    "       ProcessTypes.ProcessTypeID, ProcessTypes.Process, ProcessTypes.Process + ' - ' + NoticeTypes.Notice AS EntireError, " &
                                    "       DocumentErrorType =  (SELECT DocumentTypes.DocumentType " &
                                    "       FROM FileErrorsDocumentTypes " &
                                    "       INNER JOIN DocumentTypes ON FileErrorsDocumentTypes.fk_DocumentTypeID = DocumentTypes.DocumentTypeID " &
                                    "       WHERE FileErrorsDocumentTypes.fk_ErrorID = FileErrors.ErrorID), " &
                                    "      FileErrors.Details AS ErrorComments, FileErrors.Status," &
                                    "      CONVERT (varchar(MAX), CAST(FileErrors.CompletionDate AS date), 101) AS CompletionDate, " &
                                    "      CASE WHEN CompletionDate IS NULL THEN DATEDIFF(DAY , ReviewDate , GETDATE()) ELSE '0' END AS DaysInProcess, " &
                                    "      FileErrors.Notes, FileErrors.fk_ReviewTypeID, FileErrors.fk_AuditorSubmittedID, fk_ProcessTypeID " &
                                    "FROM FileErrors " &
                                    "       INNER JOIN Files ON FileErrors.fk_FileID = Files.FileID " &
                                    "       INNER JOIN Users AS FileStaff ON Files.fk_CaseManagerID = FileStaff.UserID " &
                                    "       INNER JOIN Groups As FileStaffGroup ON FileStaff.fk_GroupID = FileStaffGroup.GroupID " &
                                    "       INNER JOIN Users AS ErrorStaff ON FileErrors.fk_ErrorStaffID = ErrorStaff.UserID " &
                                    "       INNER JOIN Users AS Auditor ON FileErrors.fk_AuditorSubmittedID = Auditor.UserID " &
                                    "       INNER JOIN ReviewTypes ON FileErrors.fk_ReviewTypeID = ReviewTypes.ReviewTypeID " &
                                    "       INNER JOIN ProcessTypes ON FileErrors.fk_ProcessTypeID = ProcessTypes.ProcessTypeID " &
                                    "       INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID " &
                                    "WHERE FileErrors.fk_FileID != '0'"

                Dim errorID As Integer = Process.SelectedValue
                Dim fileStaffID As Integer = FileStaff.SelectedValue
                Dim errorStaffID As Integer = ErrorStaff.SelectedValue
                Dim auditorID As Integer = Auditor.SelectedValue
                Dim reviewTypeID As Integer = ReviewType.SelectedValue
                Dim groupID As Integer = Group.SelectedValue
                Dim firstName As String = ClientFirstName.Text
                Dim lastname As String = ClientLastName.Text
                Dim reviewDateBeginUnconverted As String = ReviewDateBegin.Text
                Dim reviewDateEndUnconverted As String = ReviewDateEnd.Text
                Dim errorStatusName As String = ErrorStatus.SelectedValue

                If (errorID > 0) Then
                    sql += " AND ProcessTypes.ProcessTypeID = " + errorID.ToString()
                End If

                If (fileStaffID > 0) Then
                    sql += " AND Files.fk_CaseManagerID = " + fileStaffID.ToString()
                End If

                If (errorStaffID > 0) Then
                    sql += " AND FileErrors.fk_ErrorStaffID = " + errorStaffID.ToString()
                End If

                If (auditorID > 0) Then
                    sql += " AND Auditor.UserID = " + auditorID.ToString()
                End If

                If (groupID > 0) Then
                    sql += " AND FileStaffGroup.GroupID = " + groupID.ToString()
                End If

                If (reviewTypeID > 0) Then
                    sql += " AND ReviewTypes.ReviewTypeID = " + reviewTypeID.ToString()
                End If

                If Not errorStatusName = "All" Then
                    sql += " AND FileErrors.Status = '" + errorStatusName.ToString() + "'"
                End If

                If Not String.IsNullOrEmpty(firstName) Then
                    sql += " AND Files.ClientFirstName LIKE '" + firstName.ToString() + "%'"
                End If

                If Not String.IsNullOrEmpty(lastname) Then
                    sql += " AND Files.ClientLastName LIKE '" + lastname.ToString() + "%'"
                End If

                If Not String.IsNullOrEmpty(reviewDateBeginUnconverted) And Not String.IsNullOrEmpty(reviewDateEndUnconverted) Then
                    Dim reviewDateBeginConverted As String = ConvertStringFormatDatetoSqlDate(reviewDateBeginUnconverted)
                    Dim reviewDateEndConverted As String = ConvertStringFormatDatetoSqlDate(reviewDateEndUnconverted)
                    Response.Write(reviewDateBeginConverted)
                    sql += " AND ReviewDate BETWEEN '" + reviewDateBeginConverted + "' AND '" + reviewDateEndConverted + "' "
                End If

                SqlDataSource1.SelectCommand = sql
                SqlDataSource1.DataBind()
                GridView1.DataBind()

            Case HOUSING_SPECALIST
                Dim sql As String = "SELECT FileErrors.fk_FileID, FileErrors.ErrorID, Files.ClientFirstName + ' ' + Files.ClientLastName AS Client, Files.IsFileDisable, " &
                    "       Files.EliteID, Files.fk_CaseManagerID, FileStaff.FirstName + ' ' + FileStaff.LastName AS FileStaffName, " &
                    "        FileErrors.fk_ErrorStaffID, ErrorStaff.FirstName + ' ' + ErrorStaff.LastName AS ErrorStaffName, " &
                    "       Auditor.UserID, Auditor.FirstName + ' ' + Auditor.LastName AS AuditorName, ReviewTypes.ReviewTypeID, ReviewTypes.Review, " &
                    "       CONVERT (varchar(MAX), CAST(Files.ReviewDate AS date), 101) AS ReviewDate, " &
                    "       CONVERT (varchar(MAX), CAST(Files.EffectiveDate AS date), 101) AS EffectiveDate, " &
                    "       ProcessTypes.ProcessTypeID, ProcessTypes.Process, ProcessTypes.Process + ' - ' + NoticeTypes.Notice AS EntireError, " &
                    "       DocumentErrorType =  (SELECT DocumentTypes.DocumentType " &
                    "       FROM FileErrorsDocumentTypes " &
                    "       INNER JOIN DocumentTypes ON FileErrorsDocumentTypes.fk_DocumentTypeID = DocumentTypes.DocumentTypeID " &
                    "       WHERE FileErrorsDocumentTypes.fk_ErrorID = FileErrors.ErrorID), " &
                    "      FileErrors.Details AS ErrorComments, FileErrors.Status," &
                    "      CONVERT (varchar(MAX), CAST(FileErrors.CompletionDate AS date), 101) AS CompletionDate, " &
                    "      CASE WHEN CompletionDate IS NULL THEN DATEDIFF(DAY , ReviewDate , GETDATE()) ELSE '0' END AS DaysInProcess, " &
                    "      FileErrors.Notes, FileErrors.fk_ReviewTypeID, FileErrors.fk_AuditorSubmittedID, fk_ProcessTypeID " &
                    "FROM FileErrors " &
                    "       INNER JOIN Files ON FileErrors.fk_FileID = Files.FileID " &
                    "       INNER JOIN Users AS FileStaff ON Files.fk_CaseManagerID = FileStaff.UserID " &
                    "       INNER JOIN Users AS ErrorStaff ON FileErrors.fk_ErrorStaffID = ErrorStaff.UserID " &
                    "       INNER JOIN Users AS Auditor ON FileErrors.fk_AuditorSubmittedID = Auditor.UserID " &
                    "       INNER JOIN ReviewTypes ON FileErrors.fk_ReviewTypeID = ReviewTypes.ReviewTypeID " &
                    "       INNER JOIN ProcessTypes ON FileErrors.fk_ProcessTypeID = ProcessTypes.ProcessTypeID " &
                    "       INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID " &
                    "WHERE FileStaff.UserID = '" & sessionUserID & "'"

                Dim errorID As Integer = Process.SelectedValue
                Dim fileStaffID As Integer = FileStaff.SelectedValue
                Dim errorStaffID As Integer = ErrorStaff.SelectedValue
                Dim auditorID As Integer = Auditor.SelectedValue
                Dim reviewTypeID As Integer = ReviewType.SelectedValue
                Dim firstName As String = ClientFirstName.Text
                Dim lastname As String = ClientLastName.Text
                Dim reviewDateBeginUnconverted As String = ReviewDateBegin.Text
                Dim reviewDateEndUnconverted As String = ReviewDateEnd.Text
                Dim errorStatusName As String = ErrorStatus.SelectedValue

                If (errorID > 0) Then
                    sql += " AND ProcessTypes.ProcessTypeID = " + errorID.ToString()
                End If

                If (fileStaffID > 0) Then
                    sql += " AND Files.fk_CaseManagerID = " + fileStaffID.ToString()
                End If

                If (errorStaffID > 0) Then
                    sql += " AND FileErrors.fk_ErrorStaffID = " + errorStaffID.ToString()
                End If

                If (auditorID > 0) Then
                    sql += " AND Auditor.UserID = " + auditorID.ToString()
                End If

                If (reviewTypeID > 0) Then
                    sql += " AND ReviewTypes.ReviewTypeID = " + reviewTypeID.ToString()
                End If

                If Not String.IsNullOrEmpty(firstName) Then
                    sql += " AND Files.ClientFirstName LIKE '" + firstName.ToString() + "%'"
                End If

                If Not String.IsNullOrEmpty(lastname) Then
                    sql += " AND Files.ClientLastName LIKE '" + lastname.ToString() + "%'"
                End If

                If Not errorStatusName = "All" Then
                    sql += " AND FileErrors.Status = '" + errorStatusName.ToString() + "'"
                End If

                If Not String.IsNullOrEmpty(reviewDateBeginUnconverted) And Not String.IsNullOrEmpty(reviewDateEndUnconverted) Then
                    Dim reviewDateBeginConverted As String = ConvertStringFormatDatetoSqlDate(reviewDateBeginUnconverted)
                    Dim reviewDateEndConverted As String = ConvertStringFormatDatetoSqlDate(reviewDateEndUnconverted)

                    sql += " AND ReviewDate BETWEEN '" + reviewDateBeginConverted + "' AND '" + reviewDateEndConverted + "' "
                End If

                SqlDataSource1.SelectCommand = sql
                SqlDataSource1.DataBind()
                GridView1.DataBind()
        End Select
    End Sub

    Private Function ConvertStringFormatDatetoSqlDate(ByVal dateToConvert As String) As String
        Dim dateParsedArray() As String = ParseDate(dateToConvert)
        Dim month As Integer = Integer.Parse(dateParsedArray(0))
        Dim day As String = dateParsedArray(1)
        Dim year As String = dateParsedArray(2)
        Dim monthAbbrevName As String = MonthName(month, True)

        day = " " + day.Trim()
        year = " " + year.Trim()

        Return String.Concat(monthAbbrevName, day, year)
    End Function

    Private Function DeleteErrorLink(ByVal sessionUserID As Integer, ByVal fileID As Integer, ByVal errorID As Integer, ByVal reviewTypeID As Integer, ByVal processTypeID As Integer) As String
        Return "<a href=DeleteFileError.ashx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & "&ErrorID=" & errorID & "&ReviewTypeID=" & reviewTypeID & "&ProcessTypeID=" & processTypeID & "><i class='fa fa-trash' aria-hidden='true'></i></a>"
    End Function

    Public Function DisplayClientNameLink(ByVal reviewTypeID As Integer, ByVal clientName As String, ByVal fileID As Integer, ByVal sessionUserID As Integer) As String
        Const ANNUAL_REEXAMINATION As Integer = 1
        Const ELIGIBILITY_SCREENING As Integer = 2
        Const INTERIM_REEXAMINATION As Integer = 3
        Const MOVES As Integer = 4
        Const PORT_IN As Integer = 5
        Const REASONABLE_RENT As Integer = 6
        Const SELECTION_FROM_WAITLIST As Integer = 7
        Const LEASING As Integer = 8

        Dim link As String = ""

        Select Case reviewTypeID
            Case ANNUAL_REEXAMINATION
                link = "<a href=CreateAnnualReexamination.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & ">" & clientName & "</a>"
            Case ELIGIBILITY_SCREENING
                link = "<a href=CreateEligibilityScreening.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & ">" & clientName & "</a>"
            Case INTERIM_REEXAMINATION
                link = "<a href=CreateInterimReexamination.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & ">" & clientName & "</a>"
            Case MOVES
                link = "<a href=CreateMoves.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & ">" & clientName & "</a>"
            Case PORT_IN
                link = "<a href=CreatePortIn.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & ">" & clientName & "</a>"
            Case REASONABLE_RENT
                link = "<a href=CreateReasonableRent.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & ">" & clientName & "</a>"
            Case SELECTION_FROM_WAITLIST
                link = "<a href=CreateSelectionFromWaitlist.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & ">" & clientName & "</a>"
            Case LEASING
                link = "<a href=CreateLeasing.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & ">" & clientName & "</a>"
        End Select

        Return link
    End Function

    Protected Function DisplayFileLink(ByVal reviewTypeID As Integer, ByVal clientName As String, ByVal fileID As Integer, ByVal sessionUserID As Integer) As String
        Dim link As String = ""

        Dim roleID As Integer = GetUserRoleID(sessionUserID)
        Select Case roleID
            Case ADMIN
                link = DisplayClientNameLink(reviewTypeID, clientName, fileID, sessionUserID)
            Case AUDITOR_ID To HOUSING_SPECALIST
                link = clientName
        End Select

        Return link
    End Function

    Public Function DisplayDecodedText(ByVal encodedHtmlText As String) As String
        Return Server.HtmlDecode(encodedHtmlText)
    End Function

    Public Function DisplayDeleteErrorLink(ByVal sessionUserID As Integer, ByVal fileID As Integer, ByVal errorID As Integer, ByVal reviewTypeID As Integer, ByVal processTypeID As Integer) As String
        Const ADMIN As Integer = 1
        Const AUDITOR_ID As Integer = 2

        Dim link As String = ""

        Dim roleID As Integer = GetUserRoleID(sessionUserID)
        Select Case roleID
            Case ADMIN
                link = DeleteErrorLink(sessionUserID, fileID, errorID, reviewTypeID, processTypeID)
            Case AUDITOR_ID
                Dim auditorID As Integer = GetAuditorIDForFile(fileID)

                If sessionUserID = auditorID Then
                    link = DeleteErrorLink(sessionUserID, fileID, errorID, reviewTypeID, processTypeID)
                End If
        End Select

        Return link
    End Function

    Public Function DisplayEditErrorLink(ByVal sessionUserID As Integer, ByVal fileID As Integer, ByVal errorID As Integer, ByVal reviewTypeID As Integer, ByVal processTypeID As Integer) As String
        Return "<a href=EditError.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & "&ErrorID=" & errorID & "&ReviewTypeID=" & reviewTypeID & "&ProcessTypeID=" & processTypeID & "><i class='fa fa-pencil' aria-hidden='true'></i></a>"
    End Function

    Public Sub DisplayListingsBasedOnHousingSpecialist(ByVal userID As Integer)
        Dim sql As String = "SELECT FileErrors.fk_FileID, FileErrors.ErrorID, Files.ClientFirstName + ' ' + Files.ClientLastName AS Client, Files.IsFileDisable, " &
                         "       Files.EliteID, Files.fk_CaseManagerID, FileStaff.FirstName + ' ' + FileStaff.LastName AS FileStaffName, " &
                         "        FileErrors.fk_ErrorStaffID, ErrorStaff.FirstName + ' ' + ErrorStaff.LastName AS ErrorStaffName, " &
                         "       Auditor.UserID, Auditor.FirstName + ' ' + Auditor.LastName AS AuditorName, ReviewTypes.ReviewTypeID, ReviewTypes.Review, " &
                         "       CONVERT (varchar(MAX), CAST(Files.ReviewDate AS date), 101) AS ReviewDate, " &
                         "       CONVERT (varchar(MAX), CAST(Files.EffectiveDate AS date), 101) AS EffectiveDate, " &
                         "       ProcessTypes.ProcessTypeID, ProcessTypes.Process, ProcessTypes.Process + ' - ' + NoticeTypes.Notice AS EntireError, " &
                         "       DocumentErrorType =  (SELECT DocumentTypes.DocumentType " &
                         "       FROM FileErrorsDocumentTypes " &
                         "       INNER JOIN DocumentTypes ON FileErrorsDocumentTypes.fk_DocumentTypeID = DocumentTypes.DocumentTypeID " &
                         "       WHERE FileErrorsDocumentTypes.fk_ErrorID = FileErrors.ErrorID), " &
                         "      FileErrors.Details AS ErrorComments, FileErrors.Status," &
                         "      CONVERT (varchar(MAX), CAST(FileErrors.CompletionDate AS date), 101) AS CompletionDate, " &
                         "      CASE WHEN CompletionDate IS NULL THEN DATEDIFF(DAY , ReviewDate , GETDATE()) ELSE '0' END AS DaysInProcess, " &
                         "      FileErrors.Notes, FileErrors.fk_ReviewTypeID, FileErrors.fk_AuditorSubmittedID, fk_ProcessTypeID " &
                         "FROM FileErrors " &
                         "       INNER JOIN Files ON FileErrors.fk_FileID = Files.FileID " &
                         "       INNER JOIN Users AS FileStaff ON Files.fk_CaseManagerID = FileStaff.UserID " &
                         "       INNER JOIN Users AS ErrorStaff ON FileErrors.fk_ErrorStaffID = ErrorStaff.UserID " &
                         "       INNER JOIN Users AS Auditor ON FileErrors.fk_AuditorSubmittedID = Auditor.UserID " &
                         "       INNER JOIN ReviewTypes ON FileErrors.fk_ReviewTypeID = ReviewTypes.ReviewTypeID " &
                         "       INNER JOIN ProcessTypes ON FileErrors.fk_ProcessTypeID = ProcessTypes.ProcessTypeID " &
                         "       INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID " &
                         "WHERE FileStaff.UserID = '" & userID & "'"

        SqlDataSource1.SelectCommand = sql
        SqlDataSource1.DataBind()
        GridView1.DataBind()
    End Sub

    Protected Sub ExportToExcel(ByVal sender As Object, ByVal e As EventArgs) Handles btnExportToExcel.Click
        Response.Clear()
        Response.Buffer = True
        Response.AddHeader("content-disposition", "attachment;filename=ErrorReportExport.xls")
        Response.Charset = ""
        Response.ContentType = "application/vnd.ms-excel"
        Using writeContent As New StringWriter()
            Dim writeHtmlContent As New HtmlTextWriter(writeContent)
            Me.BindGridWithFilters()

            GridView1.RenderControl(writeHtmlContent)
            Response.Output.Write(writeContent.ToString())
            Response.Flush()
            Response.[End]()
        End Using
    End Sub

    Public Sub FilterReport(ByVal sender As Object, ByVal e As EventArgs) Handles btnFilterReport.Click
        Me.BindGridWithFilters()
    End Sub

    Private Function GetAuditorIDForFile(ByVal fileID As Integer) As Integer
        conn.Open()
        Dim auditorID As Integer
        Dim query As New SqlCommand("SELECT fk_AudtitorID FROM Files WHERE FileID  = '" & fileID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()

        While reader.Read
            auditorID = CStr(reader("fk_AudtitorID"))
        End While
        conn.Close()

        Return auditorID
    End Function

    Private Function GetUserRoleID(ByVal userID As Integer) As Integer
        conn.Open()
        Dim query As New SqlCommand("SELECT fk_RoleID FROM Users WHERE UserID  = '" & userID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()
        Dim roleID As Integer

        While reader.Read
            roleID = CStr(reader("fk_RoleID"))
        End While
        conn.Close()

        Return roleID
    End Function

    Private Function GetUserGroupID(ByVal userID As Integer) As Integer
        conn.Open()
        Dim query As New SqlCommand("SELECT fk_GroupID FROM Users WHERE UserID  = '" & userID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()
        Dim groupID As Integer

        While reader.Read
            groupID = CStr(reader("fk_GroupID"))
        End While
        conn.Close()

        Return groupID
    End Function

    Public Function GetSessionUserID() As Integer
        Dim sessionUserID As String
        If Not Web.HttpContext.Current.Session("SessionUserID") Is Nothing Then
            sessionUserID = Web.HttpContext.Current.Session("SessionUserID").ToString()
        End If

        If sessionUserID = Nothing Then
            sessionUserID = Request.QueryString("SessionUserID")
            Web.HttpContext.Current.Session("SessionUserID") = sessionUserID
        End If

        Return Convert.ToInt32(sessionUserID)
    End Function

    Private Function ParseDate(ByVal dateToParse As String) As String()
        Return dateToParse.Split("/")
    End Function

    Private Sub SetFiltersToAll()
        Group.AppendDataBoundItems = True
        Group.Items.Insert(0, New ListItem("ALL", 0))

        Process.AppendDataBoundItems = True
        Process.Items.Insert(0, New ListItem("ALL", 0))

        FileStaff.AppendDataBoundItems = True
        FileStaff.Items.Insert(0, New ListItem("ALL", 0))

        Auditor.AppendDataBoundItems = True
        Auditor.Items.Insert(0, New ListItem("ALL", 0))

        ErrorStaff.AppendDataBoundItems = True
        ErrorStaff.Items.Insert(0, New ListItem("ALL", 0))

        ReviewType.AppendDataBoundItems = True
        ReviewType.Items.Insert(0, New ListItem("ALL", 0))
    End Sub

    Public Sub SetReportBasedOnFile(ByVal fileID As Integer)
        Dim sql As String = "SELECT FileErrors.fk_FileID, FileErrors.ErrorID, Files.ClientFirstName + ' ' + Files.ClientLastName AS Client, Files.IsFileDisable, " &
                    "       Files.EliteID, Files.fk_CaseManagerID, FileStaff.FirstName + ' ' + FileStaff.LastName AS FileStaffName, " &
                    "        FileErrors.fk_ErrorStaffID, ErrorStaff.FirstName + ' ' + ErrorStaff.LastName AS ErrorStaffName, " &
                    "       Auditor.UserID, Auditor.FirstName + ' ' + Auditor.LastName AS AuditorName, ReviewTypes.ReviewTypeID, ReviewTypes.Review, " &
                    "       CONVERT (varchar(MAX), CAST(Files.ReviewDate AS date), 101) AS ReviewDate, " &
                    "       CONVERT (varchar(MAX), CAST(Files.EffectiveDate AS date), 101) AS EffectiveDate, " &
                    "       ProcessTypes.ProcessTypeID, ProcessTypes.Process, ProcessTypes.Process + ' - ' + NoticeTypes.Notice AS EntireError, " &
                    "       DocumentErrorType =  (SELECT DocumentTypes.DocumentType " &
                    "       FROM FileErrorsDocumentTypes " &
                    "       INNER JOIN DocumentTypes ON FileErrorsDocumentTypes.fk_DocumentTypeID = DocumentTypes.DocumentTypeID " &
                    "       WHERE FileErrorsDocumentTypes.fk_ErrorID = FileErrors.ErrorID), " &
                    "      FileErrors.Details AS ErrorComments, FileErrors.Status," &
                    "      CONVERT (varchar(MAX), CAST(FileErrors.CompletionDate AS date), 101) AS CompletionDate, " &
                    "      CASE WHEN CompletionDate IS NULL THEN DATEDIFF(DAY , ReviewDate , GETDATE()) ELSE '0' END AS DaysInProcess, " &
                    "      FileErrors.Notes, FileErrors.fk_ReviewTypeID, FileErrors.fk_AuditorSubmittedID, fk_ProcessTypeID " &
                    "FROM FileErrors " &
                    "       INNER JOIN Files ON FileErrors.fk_FileID = Files.FileID " &
                    "       INNER JOIN Users AS FileStaff ON Files.fk_CaseManagerID = FileStaff.UserID " &
                    "       INNER JOIN Users AS ErrorStaff ON FileErrors.fk_ErrorStaffID = ErrorStaff.UserID " &
                    "       INNER JOIN Users AS Auditor ON FileErrors.fk_AuditorSubmittedID = Auditor.UserID " &
                    "       INNER JOIN ReviewTypes ON FileErrors.fk_ReviewTypeID = ReviewTypes.ReviewTypeID " &
                    "       INNER JOIN ProcessTypes ON FileErrors.fk_ProcessTypeID = ProcessTypes.ProcessTypeID " &
                    "       INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID " &
                    "WHERE FileErrors.fk_FileID = '" & fileID & "'"

        SqlDataSource1.SelectCommand = sql
        SqlDataSource1.DataBind()
        GridView1.DataBind()
    End Sub

    Public Sub SetReportBasedOnReviewAndProcess(ByVal fileID As Integer, ByVal reviewTypeID As Integer, ByVal processTypeID As Integer)
        Dim sql As String = "SELECT FileErrors.fk_FileID, FileErrors.ErrorID, Files.ClientFirstName + ' ' + Files.ClientLastName AS Client, Files.IsFileDisable, " &
                    "       Files.EliteID, Files.fk_CaseManagerID, FileStaff.FirstName + ' ' + FileStaff.LastName AS FileStaffName, " &
                    "        FileErrors.fk_ErrorStaffID, ErrorStaff.FirstName + ' ' + ErrorStaff.LastName AS ErrorStaffName, " &
                    "       Auditor.UserID, Auditor.FirstName + ' ' + Auditor.LastName AS AuditorName, ReviewTypes.ReviewTypeID, ReviewTypes.Review, " &
                    "       CONVERT (varchar(MAX), CAST(Files.ReviewDate AS date), 101) AS ReviewDate, " &
                    "       CONVERT (varchar(MAX), CAST(Files.EffectiveDate AS date), 101) AS EffectiveDate, " &
                    "       ProcessTypes.ProcessTypeID, ProcessTypes.Process, ProcessTypes.Process + ' - ' + NoticeTypes.Notice AS EntireError, " &
                    "       DocumentErrorType =  (SELECT DocumentTypes.DocumentType " &
                    "       FROM FileErrorsDocumentTypes " &
                    "       INNER JOIN DocumentTypes ON FileErrorsDocumentTypes.fk_DocumentTypeID = DocumentTypes.DocumentTypeID " &
                    "       WHERE FileErrorsDocumentTypes.fk_ErrorID = FileErrors.ErrorID), " &
                    "      FileErrors.Details AS ErrorComments, FileErrors.Status," &
                    "      CONVERT (varchar(MAX), CAST(FileErrors.CompletionDate AS date), 101) AS CompletionDate, " &
                    "      CASE WHEN CompletionDate IS NULL THEN DATEDIFF(DAY , ReviewDate , GETDATE()) ELSE '0' END AS DaysInProcess, " &
                    "      FileErrors.Notes, FileErrors.fk_ReviewTypeID, FileErrors.fk_AuditorSubmittedID, fk_ProcessTypeID " &
                    "FROM FileErrors " &
                    "       INNER JOIN Files ON FileErrors.fk_FileID = Files.FileID " &
                    "       INNER JOIN Users AS FileStaff ON Files.fk_CaseManagerID = FileStaff.UserID " &
                    "       INNER JOIN Users AS ErrorStaff ON FileErrors.fk_ErrorStaffID = ErrorStaff.UserID " &
                    "       INNER JOIN Users AS Auditor ON FileErrors.fk_AuditorSubmittedID = Auditor.UserID " &
                    "       INNER JOIN ReviewTypes ON FileErrors.fk_ReviewTypeID = ReviewTypes.ReviewTypeID " &
                    "       INNER JOIN ProcessTypes ON FileErrors.fk_ProcessTypeID = ProcessTypes.ProcessTypeID " &
                    "       INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID " &
                    "WHERE FileErrors.fk_FileID = '" & fileID & "' AND FileErrors.fk_ReviewTypeID = '" & reviewTypeID & "' AND FileErrors.fk_ProcessTypeID = '" & processTypeID & "'"

        SqlDataSource1.SelectCommand = sql
        SqlDataSource1.DataBind()
        GridView1.DataBind()
    End Sub

    Public Overrides Sub VerifyRenderingInServerForm(ByVal control As Control)
        ' Confirms that an HtmlForm control is rendered for the specified ASP.NET
        '     server control at run time. 
    End Sub
End Class
Imports System.Data.SqlClient
Imports System.Globalization
Imports System.Web.Configuration

Public Class EditError
    Inherits System.Web.UI.Page
    Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)

    Private Const DOCUMENT_TYPE_ID = 18
    Private Const ERROR_PENDING = "Pending"
    Private Const ERROR_COMPLETE = "Complete"
    Private Const HOUSING_SPECALIST As Integer = 3
    Private Shared prevPage As String = String.Empty

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim errorID As Integer = Request.QueryString("ErrorID")

        If Request.QueryString("LotteryNumberID") Is Nothing And Request.QueryString("SpecialCaseID") Is Nothing Then
            'Basic Error
            GetStaffNameForDropdownList(errorID)

            If GetProcessTypeID(errorID) = DOCUMENT_TYPE_ID Then
                GetDocumentTypeNameForDropdownList(errorID)
            Else
                GetProcessTypeNameForDropdownList(errorID)
            End If

            GetNoticeTypeNameForDropList(errorID)

            Dim sessionUserID As Integer = GetUserSessionID()
            Dim sessionUserRoleID As Integer = GetUserRoleID(sessionUserID)

            If sessionUserRoleID = HOUSING_SPECALIST Then
                Dim status As String = GetStatus(errorID)
                If Not IsPostBack Then
                    StatusHousingSpecialistDropdownList.DataBind()
                    StatusHousingSpecialistDropdownList.Items.FindByValue(status).Selected = True
                End If
            Else
                Dim status As String = GetStatus(errorID)
                If Not IsPostBack Then
                    StatusDropDownList.DataBind()
                    StatusDropDownList.Items.FindByValue(status).Selected = True
                End If

                If StatusDropDownList.SelectedValue = ERROR_PENDING Then
                    statusComplete.Visible = False
                End If

                If StatusDropDownList.SelectedValue = ERROR_COMPLETE Then
                    statusComplete.Visible = True
                End If

                If IsErrorInfoFilledOut(errorID) Then
                    SetErrorCompletionInfo(errorID)
                End If
            End If
        End If

        If (Not IsPostBack) Then
            prevPage = Request.UrlReferrer.ToString()
        End If
    End Sub

    Protected Sub BtnEditBasicBack_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEditBasicBack.Click, btnEditLotteryNumberBack.Click, btnEditPortInBack.Click, btnEditSpecialAdmissionBack.Click
        Response.Redirect(prevPage)
    End Sub

    Public Function ConvertStringToDate(ByVal dateInput As String) As Date
        Dim provider As CultureInfo = CultureInfo.InvariantCulture
        Dim format As String = "d"
        Return Date.ParseExact(dateInput, format, provider)
    End Function

    Protected Sub DisplayStatusCompeleteSelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        If StatusDropDownList.SelectedValue = ERROR_PENDING Then
            statusComplete.Visible = False
        End If

        If StatusDropDownList.SelectedValue = ERROR_COMPLETE Then
            statusComplete.Visible = True
        End If
    End Sub

    Public Sub EditBasicError(ByVal sender As Object, ByVal e As EventArgs) Handles btnEditBasicError.Click
        Dim errorID As Integer = Request.QueryString("ErrorID")
        Dim processTypeID As Integer = Request.QueryString("ProcessTypeID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Dim sessionUserRoleID As Integer = GetUserRoleID(sessionUserID)

        If Not sessionUserRoleID = HOUSING_SPECALIST Then
            'Error Type
            If processTypeID = DOCUMENT_TYPE_ID Then
                conn.Open()
                Dim queryDocument As New SqlCommand("UPDATE FileErrorsDocumentTypes SET fk_DocumentTypeID = '" & Document.SelectedValue & "' WHERE fk_ErrorID = '" & errorID & "'", conn)
                queryDocument.ExecuteReader()
                conn.Close()
            Else
                conn.Open()
                Dim queryProcess As New SqlCommand("UPDATE FileErrors SET fk_ProcessTypeID = '" & ProcessType.SelectedValue & "'  WHERE ErrorID = '" & errorID & "'", conn)
                queryProcess.ExecuteReader()
                conn.Close()
            End If

            'Error Catergory 
            If processTypeID = DOCUMENT_TYPE_ID Then
                conn.Open()
                Dim queryNoticeTypeDocument As New SqlCommand("UPDATE FileErrors SET fk_NoticeTypeID = '" & NoticeTypeDocument.SelectedValue & "' WHERE ErrorID = '" & errorID & "'", conn)
                queryNoticeTypeDocument.ExecuteReader()
                conn.Close()
            Else
                conn.Open()
                Dim queryNoticeTypeProcess As New SqlCommand("UPDATE FileErrors SET fk_NoticeTypeID = '" & NoticeTypeProcess.SelectedValue & "' WHERE ErrorID = '" & errorID & "'", conn)
                queryNoticeTypeProcess.ExecuteReader()
                conn.Close()
            End If

            Dim details As String = Request.Form("Details")
            details = Server.HtmlEncode(details)
            Dim housingSpecialist As Integer = HousingSpecialistDropdownList.SelectedValue
            Dim statusCompletion As String = StatusDropDownList.SelectedValue

            conn.Open()
            Dim queryInfo As String = "UPDATE FileErrors SET Details = '" & details & "',  fk_ErrorStaffID = '" & housingSpecialist & "',  Status =  '" & statusCompletion & "'  WHERE ErrorID = '" & errorID & "'"
            Dim cmd As New SqlCommand
            cmd.CommandText = queryInfo
            cmd.CommandType = CommandType.Text
            cmd.Connection = conn
            cmd.ExecuteReader()
            conn.Close()

            If Not CompletionApproved.SelectedValue = "Completion Approved" Then
                Dim completionDateConverted As Date = ConvertStringToDate(CompletionDate.Text)
                Dim notesResponse As String = Request.Form("Notes")
                notesResponse = notesResponse.Replace("'", "''")
                Dim approved As Integer = CompletionApproved.SelectedValue
                conn.Open()
                Dim queryErrorUpdate As New SqlCommand("UPDATE FileErrors SET CompletionDate = '" & completionDateConverted & "', IsCompletionApproved = '" & approved & "', Notes =  '" & notesResponse & "' WHERE ErrorID = '" & errorID & "'", conn)
                queryErrorUpdate.ExecuteReader()
                conn.Close()
            End If
        Else
            Dim statusComplete As String = StatusHousingSpecialistDropdownList.SelectedValue
            conn.Open()
            Dim queryErrorUpdate As New SqlCommand("UPDATE FileErrors SET Status = '" & statusComplete & "' WHERE ErrorID = '" & errorID & "'", conn)
            queryErrorUpdate.ExecuteReader()
            conn.Close()
        End If
    End Sub

    Protected Sub EditLotteryNumber(ByVal sender As Object, ByVal e As EventArgs) Handles btnEditLotteryNumber.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim lotteryNumberID As Integer = Request.QueryString("LotteryNumberID")
        Dim sessionUserID As Integer = GetUserSessionID()

        conn.Open()
        Dim doClientHaveNumber As Integer = Request.Form("islotteryNumber14")
        Dim number As String = Request.Form("lotteryNumber14")
        Dim comments As String = Request.Form("Comment14")
        Dim query As New SqlCommand("UPDATE LotteryNumberErrors SET doClientHaveNumber = '" & doClientHaveNumber & "', Number = '" & number & "', Comments = '" & comments & "' WHERE LotteryNumberID = '" & lotteryNumberID & "'", conn)
        query.ExecuteNonQuery()
        conn.Close()
    End Sub

    Protected Sub EditPortIn(ByVal sender As Object, ByVal e As EventArgs) Handles btnEditPortIn.Click
        Dim specialCaseID As Integer = Request.QueryString("SpecialCaseID")
        conn.Open()
        Dim isExists As Integer = Request.Form("isPortIn20")
        Dim comments As String = Request.Form("comment20")
        Dim query As New SqlCommand("UPDATE SpecialCaseErrors SET isExists = '" & isExists & "', Comments = '" & comments & "' WHERE SpecialCaseID = '" & specialCaseID & "'", conn)
        query.ExecuteNonQuery()
        conn.Close()
    End Sub

    Protected Sub EditSpecialAdmission(ByVal sender As Object, ByVal e As EventArgs) Handles btnEditSpecialAdmission.Click
        '  Dim fileID As Integer = Request.QueryString("FileID")
        Dim specialCaseID As Integer = Request.QueryString("SpecialCaseID")

        conn.Open()
        Dim isExists As Integer = Request.Form("isSpecialAdmission19")
        Dim comments As String = Request.Form("Comment19")
        Dim query As New SqlCommand("UPDATE SpecialCaseErrors SET isExists = '" & isExists & "', Comments = '" & comments & "' WHERE SpecialCaseID = '" & specialCaseID & "'", conn)
        query.ExecuteNonQuery()
        conn.Close()
    End Sub

    Public Function GetDocumentTypeID(ByVal errorID As Integer) As Integer
        Dim documentTypeID As Integer
        conn.Open()
        Dim query As New SqlCommand("SELECT fk_DocumentTypeID FROM FileErrorsDocumentTypes WHERE fk_ErrorID ='" & errorID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()
        While reader.Read
            documentTypeID = CStr(reader("fk_DocumentTypeID"))
        End While
        conn.Close()

        Return documentTypeID
    End Function

    Public Sub GetDocumentTypeNameForDropdownList(ByVal errorID As Integer)
        Dim documentTypeID As Integer = GetDocumentTypeID(errorID)

        If Not IsPostBack Then
            Document.DataBind()
            Document.Items.FindByValue(documentTypeID).Selected = True
        End If
    End Sub

    Public Function GetNoticeTypeID(ByVal errorID As Integer) As Integer
        Dim noticeTypeID As Integer
        conn.Open()
        Dim query As New SqlCommand("SELECT fk_NoticeTypeID FROM FileErrors WHERE ErrorID = '" & errorID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()
        While reader.Read
            noticeTypeID = CStr(reader("fk_NoticeTypeID"))
        End While
        conn.Close()

        Return noticeTypeID
    End Function

    Public Sub GetNoticeTypeNameForDropList(ByVal errorID As Integer)
        Dim noticeTypeID As Integer = GetNoticeTypeID(errorID)
        If Not IsPostBack Then
            If GetProcessTypeID(errorID) = DOCUMENT_TYPE_ID Then
                If noticeTypeID <> 0 Then
                    NoticeTypeDocument.DataBind()
                    NoticeTypeDocument.Items.FindByValue(noticeTypeID).Selected = True
                End If
            Else
                If noticeTypeID <> 0 Then
                    NoticeTypeProcess.DataBind()
                    NoticeTypeProcess.Items.FindByValue(noticeTypeID).Selected = True
                End If
            End If
        End If
    End Sub

    Public Function GetProcessTypeID(ByVal errorID As Integer) As Integer
        Dim processTypeID As Integer
        conn.Open()
        Dim query As New SqlCommand("SELECT fk_ProcessTypeID FROM FileErrors WHERE ErrorID ='" & errorID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()
        While reader.Read
            processTypeID = CStr(reader("fk_ProcessTypeID"))
        End While
        conn.Close()

        Return processTypeID
    End Function

    Public Sub GetProcessTypeNameForDropdownList(ByVal errorID As Integer)
        Dim processTypeID As Integer = GetProcessTypeID(errorID)
        If Not IsPostBack Then
            If processTypeID <> 0 Then
                ProcessType.DataBind()
                ProcessType.Items.FindByValue(processTypeID).Selected = True
            End If
        End If
    End Sub

    Public Function GetErrorStaffID(ByVal errorID As Integer) As Integer
        conn.Open()
        Dim errorStaffID As Integer
        Dim query As New SqlCommand("SELECT fk_ErrorStaffID FROM FileErrors WHERE ErrorID ='" & errorID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()
        While reader.Read
            errorStaffID = CStr(reader("fk_ErrorStaffID"))
        End While
        conn.Close()

        Return errorStaffID
    End Function

    Public Sub GetStaffNameForDropdownList(ByVal errorID As Integer)
        Dim errorStaffID As Integer = GetErrorStaffID(errorID)
        If Not IsPostBack Then
            If errorStaffID <> 0 Then
                HousingSpecialistDropdownList.DataBind()
                HousingSpecialistDropdownList.Items.FindByValue(errorStaffID).Selected = True
            End If
        End If
    End Sub

    Public Function GetStatus(ByVal errorID As Integer) As String
        Dim status As String = ""
        conn.Open()
        Dim query As New SqlCommand("SELECT Status FROM FileErrors WHERE ErrorID ='" & errorID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()
        While reader.Read
            status = CStr(reader("Status"))
        End While
        conn.Close()

        Return status
    End Function

    Private Function GetUserRoleID(ByVal userID As Integer) As Integer
        Dim roleID As Integer
        conn.Open()
        Dim query As New SqlCommand("SELECT fk_RoleID FROM Users WHERE UserID  = '" & userID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()
        While reader.Read
            roleID = CStr(reader("fk_RoleID"))
        End While
        conn.Close()

        Return roleID
    End Function

    Public Function GetUserSessionID() As Integer
        Dim sessionUserID As String
        If Not Web.HttpContext.Current.Session("SessionUserID") Is Nothing Then
            sessionUserID = Web.HttpContext.Current.Session("SessionUserID").ToString()
        End If

        If sessionUserID = Nothing Then
            sessionUserID = Request.QueryString("SessionUserID")
            Web.HttpContext.Current.Session("SessionUserID") = sessionUserID
        End If
        Return sessionUserID
    End Function

    Private Function IsErrorInfoFilledOut(ByVal errorID As Integer) As Boolean
        Dim completionDate, isCompletionApproved As String
        conn.Open()
        Dim query As New SqlCommand("SELECT CompletionDate, IsCompletionApproved FROM FileErrors WHERE ErrorID ='" & errorID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()
        While reader.Read
            completionDate = CStr(reader("CompletionDate").ToString())
            isCompletionApproved = CStr(reader("IsCompletionApproved").ToString())
        End While
        conn.Close()

        If String.IsNullOrEmpty(completionDate) Or String.IsNullOrEmpty(isCompletionApproved) Then
            Return False
        Else
            Return True
        End If
    End Function

    Public Sub SetErrorCompletionInfo(ByVal errorID As Integer)
        Dim completeDate As Date
        Dim isCompletionApproved As Boolean

        conn.Open()
        Dim query As New SqlCommand("SELECT convert(varchar(max), cast([CompletionDate] as date), 101) As CompletionDate, IsCompletionApproved FROM FileErrors WHERE ErrorID ='" & errorID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()
        While reader.Read
            completeDate = CStr(reader("CompletionDate"))
            isCompletionApproved = CStr(reader("IsCompletionApproved"))
        End While
        conn.Close()

        Dim month As String = completeDate.Month.ToString("00")
        Dim day As String = completeDate.Day.ToString("00")
        Dim year As String = completeDate.Year.ToString
        CompletionDate.Text = String.Concat(month, "/", day, "/", year)

        If isCompletionApproved = True Then
            CompletionApproved.SelectedValue = "1"
        Else
            CompletionApproved.SelectedValue = "0"
        End If
    End Sub
End Class
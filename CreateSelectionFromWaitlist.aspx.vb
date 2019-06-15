Imports System.Data.SqlClient
Imports System.Web.Configuration

Public Class CreateSelectionFromWaitlist
    Inherits System.Web.UI.Page
    Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)
    Const REVIEW_TYPE_ID As Integer = 7
    Const PROCESS_DOCUMENT_TYPE As Integer = 18

#Region "For Error Checkboxes (Documents)"
    Const DOCUMENT_OTHER As Integer = 6
    Const DOCUMENT_OTHER_SELECTION_FROM_THE_WAITING_LIST_DOCUMENTS As Integer = 35
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim fileID As Integer = Request.QueryString("FileID")
        DisplayDropDownlistHousingSpecialist(fileID)
        DisplayDropDownlistNotice()
    End Sub

    Public Function AssignSeededReviewDocuments(ByVal data As Dictionary(Of Integer, Boolean)) As Dictionary(Of Integer, Boolean)
        Dim documents As New Dictionary(Of Integer, Boolean)

        'Notes / Portability Billing / Compliance
        If Not Request.Form("documentOther") Is Nothing Or Not Request.Form("documentOther") = "" Then
            data(DOCUMENT_OTHER) = True
        End If

        'Waitlist File 
        If Not Request.Form("documentOtherSelectionFromTheWaitingListDocuments") Is Nothing Or Not Request.Form("documentOtherSelectionFromTheWaitingListDocuments") = "" Then
            data(DOCUMENT_OTHER_SELECTION_FROM_THE_WAITING_LIST_DOCUMENTS) = True
        End If

        For Each item As KeyValuePair(Of Integer, Boolean) In data
            If item.Value = True Then
                documents.Add(item.Key, True)
            End If
        Next

        Return documents
    End Function

    Protected Sub CompleteFile(ByVal sender As Object, ByVal e As EventArgs) Handles btnCompleteReview.Click, btnUpdateReview.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()

        DeleteCheckedItems("FileReviewedDocuments", fileID)
        Dim seededDocuments As Dictionary(Of Integer, Boolean) = SeedReviewDocuments()
        Dim checkedDocuments As Dictionary(Of Integer, Boolean) = AssignSeededReviewDocuments(seededDocuments)
        InsertMulipleCheckedDocuments(checkedDocuments, fileID)

        conn.Open()
        Dim query As New SqlCommand("UPDATE Files SET IsReviewComplete = '1' WHERE FileID = '" & fileID & "'", conn)
        query.ExecuteNonQuery()
        conn.Close()
        Response.Redirect("ErrorReport.aspx?SessionUserID=" & sessionUserID & "")
    End Sub

    Protected Sub CreateOther(ByVal sender As Object, ByVal e As EventArgs) Handles btnDocument6.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_OTHER As Integer = 6
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeOther6.SelectedValue
        Dim details As String = Request.Form("commentOther6")
        Dim staffID As Integer = CaseManagerOther6.SelectedValue
        Dim status As String = StatusOther6.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_OTHER)
    End Sub

    Protected Sub CreateOtherSelectionFromTheWaitingListDocuments(ByVal sender As Object, ByVal e As EventArgs) Handles btnDocument75.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_OTHER As Integer = 75
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeOtherSelectionFromTheWaitingListDocuments75.SelectedValue
        Dim details As String = Request.Form("commentOtherSelectionFromTheWaitingListDocuments75")
        Dim staffID As Integer = CaseManagerOtherSelectionFromTheWaitingListDocuments75.SelectedValue
        Dim status As String = StatusOtherSelectionFromTheWaitingListDocuments75.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_OTHER)
    End Sub

    Public Sub DeleteCheckedItems(ByRef tableName As String, ByVal fileID As Integer)
        conn.Open()
        Dim query As New SqlCommand("DELETE FROM " & tableName & " WHERE fk_FileID = '" & fileID & "'", conn)
        query.ExecuteNonQuery()
        conn.Close()
    End Sub

    Public Sub DisplayDropDownlistHousingSpecialist(ByVal fileID As Integer)
        conn.Open()
        Dim housingSpecialistFullName As String
        Dim housingSpecialistID As Integer

        Dim query As String = String.Empty
        query &= "SELECT Users.UserID, Users.FirstName + ' ' + Users.LastName AS FullName FROM Files "
        query &= "INNER JOIN Users ON Files.fk_CaseManagerID = Users.UserID WHERE FileID = '" & fileID & "'"

        Dim result As New SqlCommand(query, conn)
        Dim reader As SqlDataReader = result.ExecuteReader()
        While reader.Read
            housingSpecialistID = CStr(reader("UserID"))
            housingSpecialistFullName = CStr(reader("FullName"))
        End While

        If Not IsPostBack Then
            If housingSpecialistID <> 0 Then
                'Other
                CaseManagerOther6.DataBind()
                CaseManagerOther6.Items.FindByValue(housingSpecialistID).Selected = True

                'Other Selection from the Waiting List Documents
                CaseManagerOtherSelectionFromTheWaitingListDocuments75.DataBind()
                CaseManagerOtherSelectionFromTheWaitingListDocuments75.Items.FindByValue(housingSpecialistID).Selected = True
            End If
        End If
        conn.Close()
    End Sub

    Public Sub DisplayDropDownlistNotice()
        If Not IsPostBack Then
            'Other
            NoticeTypeOther6.AppendDataBoundItems = True
            NoticeTypeOther6.Items.Insert(0, New ListItem("Notice", "2"))

            'Other Selection From The Waiting List Documents
            NoticeTypeOtherSelectionFromTheWaitingListDocuments75.AppendDataBoundItems = True
            NoticeTypeOtherSelectionFromTheWaitingListDocuments75.Items.Insert(0, New ListItem("Notice", "2"))
        End If
    End Sub

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

    Public Function InsertFileError(ByVal details As String, ByVal status As String, ByVal noticeTypeID As Integer, ByVal errorStaffID As Integer, ByVal processTypeID As Integer,
                                    ByVal fileID As Integer, ByVal reviewTypeID As Integer, ByVal auditorID As Integer) As Integer
        Dim errorID As Integer

        Dim query As String = String.Empty
        query &= "INSERT INTO FileErrors (Details, Status, CompletionDate, IsCompletionApproved, Notes, fk_NoticeTypeID, fk_ErrorStaffID, fk_ProcessTypeID, fk_FileID, fk_ReviewTypeID, fk_AuditorSubmittedID)"
        query &= "VALUES (@Details, @Status, @CompletionDate, @IsCompletionApproved, @Notes, @fk_NoticeTypeID, @fk_ErrorStaffID, @fk_ProcessTypeID, @fk_FileID, @fk_ReviewTypeID, @fk_AuditorSubmittedID)"
        query &= "SELECT @@IDENTITY from FileErrors"

        Using comm As New SqlCommand()
            With comm
                .Connection = conn
                .CommandType = CommandType.Text
                .CommandText = query
                .Parameters.AddWithValue("@Details", details)
                .Parameters.AddWithValue("@Status", status)
                .Parameters.AddWithValue("@CompletionDate", DBNull.Value)
                .Parameters.AddWithValue("@IsCompletionApproved", DBNull.Value)
                .Parameters.AddWithValue("@Notes", DBNull.Value)
                .Parameters.AddWithValue("@fk_NoticeTypeID", noticeTypeID)
                .Parameters.AddWithValue("@fk_ErrorStaffID", errorStaffID)
                .Parameters.AddWithValue("@fk_ProcessTypeID", processTypeID)
                .Parameters.AddWithValue("@fk_FileID", fileID)
                .Parameters.AddWithValue("@fk_ReviewTypeID", reviewTypeID)
                .Parameters.AddWithValue("@fk_AuditorSubmittedID", auditorID)
            End With
            conn.Open()
            errorID = comm.ExecuteScalar()
            conn.Close()
        End Using
        Return errorID
    End Function

    Public Sub InsertFileErrorDocumentType(ByVal errorID As Integer, ByVal fileID As Integer, ByVal documentTypeID As Integer)
        Dim query As String = String.Empty
        query &= "INSERT INTO FileErrorsDocumentTypes (fk_ErrorID, fk_FileID, fk_DocumentTypeID)"
        query &= "VALUES (@fk_ErrorID, @fk_FileID, @fk_DocumentTypeID)"

        Using comm As New SqlCommand()
            With comm
                .Connection = conn
                .CommandType = CommandType.Text
                .CommandText = query
                .Parameters.AddWithValue("@fk_ErrorID", errorID)
                .Parameters.AddWithValue("@fk_FileID", fileID)
                .Parameters.AddWithValue("@fk_DocumentTypeID", documentTypeID)
            End With
            conn.Open()
            comm.ExecuteNonQuery()
            conn.Close()
        End Using
    End Sub

    Public Sub InsertSpecialCaseError(ByVal isExists As Integer, ByVal comment As String, ByVal errorType As Integer, ByVal fileID As Integer, ByVal auditorID As Integer)
        Dim query As String = String.Empty
        query &= "INSERT INTO SpecialCaseErrors (isExists, Comments, fk_ErrorTypeID, fk_FileID, fk_AuditorID)"
        query &= "VALUES (@isExists, @Comments, @fk_ErrorTypeID, @fk_FileID, @fk_AuditorID)"

        Using comm As New SqlCommand()
            With comm
                .Connection = conn
                .CommandType = CommandType.Text
                .CommandText = query
                .Parameters.AddWithValue("@isExists", isExists)
                .Parameters.AddWithValue("@Comments", comment)
                .Parameters.AddWithValue("@fk_ErrorTypeID", errorType)
                .Parameters.AddWithValue("@fk_FileID", fileID)
                .Parameters.AddWithValue("@fk_AuditorID", auditorID)
            End With
            conn.Open()
            comm.ExecuteNonQuery()
            conn.Close()
        End Using
    End Sub

    Protected Sub LotteryNumber(ByVal sender As Object, ByVal e As EventArgs) Handles btnLotteryNumber.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()

        Dim doClientHaveNumber As Integer = Request.Form("islotteryNumber14")
        Dim number As String = Request.Form("lotteryNumber14")
        Dim comments As String = Request.Form("Comment14")

        Dim query As String = String.Empty
        query &= "INSERT INTO LotteryNumberErrors (doClientHaveNumber, Number, Comments, fk_FileID, fk_AuditorID)"
        query &= "VALUES (@doClientHaveNumber, @Number, @Comments, @fk_FileID, @fk_AuditorID)"

        Using comm As New SqlCommand()
            With comm
                .Connection = conn
                .CommandType = CommandType.Text
                .CommandText = query
                .Parameters.AddWithValue("@doClientHaveNumber", doClientHaveNumber)
                .Parameters.AddWithValue("@Number", number)
                .Parameters.AddWithValue("@Comments", comments)
                .Parameters.AddWithValue("@fk_FileID", fileID)
                .Parameters.AddWithValue("@fk_AuditorID", sessionUserID)
            End With
            conn.Open()
            comm.ExecuteNonQuery()
            conn.Close()
        End Using
    End Sub

    Protected Sub PortIn(ByVal sender As Object, ByVal e As EventArgs) Handles btnPortIn.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const ERROR_PORT_IN As Integer = 20

        Dim isPortIn As Integer = Request.Form("isPortIn20")
        Dim comment As String = Request.Form("comment20")

        InsertSpecialCaseError(isPortIn, comment, ERROR_PORT_IN, fileID, sessionUserID)
    End Sub

    Protected Sub SpecialAdmission(ByVal sender As Object, ByVal e As EventArgs) Handles btnSpecialAdmission.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const ERROR_SPECIAL_ADMISSION As Integer = 19

        Dim isSpecialAdmission As Integer = Request.Form("isSpecialAdmission19")
        Dim comment As String = Request.Form("Comment19")

        InsertSpecialCaseError(isSpecialAdmission, comment, ERROR_SPECIAL_ADMISSION, fileID, sessionUserID)
    End Sub

    Public Sub InsertMulipleCheckedDocuments(ByVal data As Dictionary(Of Integer, Boolean), ByVal fileID As Integer)
        For Each item As KeyValuePair(Of Integer, Boolean) In data
            InsertSingleCheckedDocument(item.Key, fileID, item.Value)
        Next
    End Sub

    Public Sub InsertMulipleCheckedProceses(ByVal data As Dictionary(Of Integer, Boolean), ByVal fileID As Integer)
        For Each item As KeyValuePair(Of Integer, Boolean) In data
            InsertSingleCheckedProcess(item.Key, fileID, item.Value)
        Next
    End Sub

    Public Sub InsertSingleCheckedDocument(ByVal documentID As Integer, ByVal fileID As Integer, ByVal isReviewed As Boolean)
        Dim query As String = String.Empty
        query &= "INSERT INTO FileReviewedDocuments (fk_ReviewTypeID, fk_DocumentID, fk_FileID, IsReviewed)"
        query &= "VALUES (@fk_ReviewTypeID, @fk_DocumentID, @fk_FileID, @IsReviewed)"

        Using comm As New SqlCommand()
            With comm
                .Connection = conn
                .CommandType = CommandType.Text
                .CommandText = query
                .Parameters.AddWithValue("@fk_ReviewTypeID", REVIEW_TYPE_ID)
                .Parameters.AddWithValue("@fk_DocumentID", documentID)
                .Parameters.AddWithValue("@fk_FileID", fileID)
                .Parameters.AddWithValue("@IsReviewed", isReviewed)
            End With
            conn.Open()
            comm.ExecuteNonQuery()
            conn.Close()
        End Using
    End Sub

    Public Sub InsertSingleCheckedProcess(ByVal processID As Integer, ByVal fileID As Integer, ByVal isReviewed As Boolean)
        Dim query As String = String.Empty
        query &= "INSERT INTO FileReviewedProcesses (fk_ReviewTypeID, fk_ProcessID, fk_FileID, IsReviewed)"
        query &= "VALUES (@fk_ReviewTypeID, @fk_ProcessID, @fk_FileID, @IsReviewed)"

        Using comm As New SqlCommand()
            With comm
                .Connection = conn
                .CommandType = CommandType.Text
                .CommandText = query
                .Parameters.AddWithValue("@fk_ReviewTypeID", REVIEW_TYPE_ID)
                .Parameters.AddWithValue("@fk_ProcessID", processID)
                .Parameters.AddWithValue("@fk_FileID", fileID)
                .Parameters.AddWithValue("@IsReviewed", isReviewed)
            End With
            conn.Open()
            comm.ExecuteNonQuery()
            conn.Close()
        End Using
    End Sub

    Public Function SeedReviewDocuments() As Dictionary(Of Integer, Boolean)
        Dim seededDocuments As New Dictionary(Of Integer, Boolean)
        conn.Open()
        Dim query As New SqlCommand("SELECT fk_DocumentTypeID FROM ReviewTypesDocuments WHERE fk_ReviewTypeID ='" & REVIEW_TYPE_ID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()
        While reader.Read
            seededDocuments.Add(CStr(reader("fk_DocumentTypeID")), False)
        End While
        conn.Close()

        Return seededDocuments
    End Function

    Public Function SeedReviewProcesses() As Dictionary(Of Integer, Boolean)
        Dim seededProcesses As New Dictionary(Of Integer, Boolean)
        conn.Open()
        Dim query As New SqlCommand("SELECT fk_ProcessTypeID FROM ReviewTypesProcesses WHERE fk_ReviewTypeID ='" & REVIEW_TYPE_ID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()
        While reader.Read
            seededProcesses.Add(CStr(reader("fk_ProcessTypeID")), False)
        End While
        conn.Close()

        Return seededProcesses
    End Function
End Class
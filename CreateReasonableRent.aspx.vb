Imports System.Data.SqlClient
Imports System.Web.Configuration

Public Class CreateReasonableRent
    Inherits System.Web.UI.Page
    Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)
    Const REVIEW_TYPE_ID As Integer = 6
    Const PROCESS_DOCUMENT_TYPE As Integer = 18

#Region "For Error Checkboxes (Processing)"
    Const PROCESS_DATA_ENTRY As Integer = 13
    Const PROCESS_OTHER As Integer = 21
    Const PROCESS_REASONABLE_RENT As Integer = 15
#End Region

#Region "For Error Checkboxes (Documents)"
    Const DOCUMENT_AMENITIES_REPORT As Integer = 1
    Const DOCUMENT_REASONABLE_RENT_DETERMINATION_CERTIFICATION As Integer = 7
    Const DOCUMENT_REASONABLE_RENT_COMPARABLES As Integer = 2
    Const DOCUMENT_RENT_BURDEN_WORKSHEET As Integer = 3
    Const DOCUMENT_RENT_INCREASE_REQUEST_FORM_IF_APPLICABLE As Integer = 4
    Const DOCUMENT_CONTRACTS_EXECUTION_CHECKLIST As Integer = 5
    Const DOCUMENT_OTHER As Integer = 6
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim fileID As Integer = Request.QueryString("FileID")
        DisplayDropDownlistHouseSpecialist(fileID)
        DisplayDropDownlistNotice()
    End Sub

    Public Function AssignSeededReviewDocuments(ByVal data As Dictionary(Of Integer, Boolean)) As Dictionary(Of Integer, Boolean)
        Dim documents As New Dictionary(Of Integer, Boolean)

        'Leasing Documents 
        If Not Request.Form("documentAmenitiesReport") Is Nothing Or Not Request.Form("documentAmenitiesReport") = "" Then
            data(DOCUMENT_AMENITIES_REPORT) = True
        End If

        If Not Request.Form("documentReasonableRentDeterminationCertification") Is Nothing Or Not Request.Form("documentReasonableRentDeterminationCertification") = "" Then
            data(DOCUMENT_REASONABLE_RENT_DETERMINATION_CERTIFICATION) = True
        End If

        If Not Request.Form("documentReasonableRentComparables") Is Nothing Or Not Request.Form("documentReasonableRentComparables") = "" Then
            data(DOCUMENT_REASONABLE_RENT_COMPARABLES) = True
        End If

        If Not Request.Form("documentRentBurdenWorksheet") Is Nothing Or Not Request.Form("documentRentBurdenWorksheet") = "" Then
            data(DOCUMENT_RENT_BURDEN_WORKSHEET) = True
        End If

        If Not Request.Form("documentRentIncreaseRequestFormIfApplicable") Is Nothing Or Not Request.Form("documentRentIncreaseRequestFormIfApplicable") = "" Then
            data(DOCUMENT_RENT_INCREASE_REQUEST_FORM_IF_APPLICABLE) = True
        End If

        If Not Request.Form("documentContractsExecutionChecklist") Is Nothing Or Not Request.Form("documentContractsExecutionChecklist") = "" Then
            data(DOCUMENT_CONTRACTS_EXECUTION_CHECKLIST) = True
        End If

        'Notes / Portability Billing / Compliance
        If Not Request.Form("documentOther") Is Nothing Or Not Request.Form("documentOther") = "" Then
            data(DOCUMENT_OTHER) = True
        End If

        For Each item As KeyValuePair(Of Integer, Boolean) In data
            If item.Value = True Then
                documents.Add(item.Key, True)
            End If
        Next

        Return documents
    End Function

    Public Function AssignSeededReviewProcesses(ByVal data As Dictionary(Of Integer, Boolean)) As Dictionary(Of Integer, Boolean)
        Dim processes As New Dictionary(Of Integer, Boolean)

        If Not Request.Form("processDataEntry") Is Nothing Or Not Request.Form("processDataEntry") = "" Then
            data(PROCESS_DATA_ENTRY) = True
        End If

        If Not Request.Form("processOther") Is Nothing Or Not Request.Form("processOther") = "" Then
            data(PROCESS_OTHER) = True
        End If

        If Not Request.Form("processReasonableRent") Is Nothing Or Not Request.Form("processReasonableRent") = "" Then
            data(PROCESS_REASONABLE_RENT) = True
        End If

        For Each item As KeyValuePair(Of Integer, Boolean) In data
            If item.Value = True Then
                processes.Add(item.Key, True)
            End If
        Next

        Return processes
    End Function

    Protected Sub CompleteFile(ByVal sender As Object, ByVal e As EventArgs) Handles btnCompleteReview.Click, btnUpdateReview.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()

        DeleteCheckedItems("FileReviewedProcesses", fileID)
        Dim seededProcesses As Dictionary(Of Integer, Boolean) = SeedReviewProcesses()
        Dim checkedProcesses As Dictionary(Of Integer, Boolean) = AssignSeededReviewProcesses(seededProcesses)
        InsertMulipleCheckedProceses(checkedProcesses, fileID)

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

    Protected Sub CreateAmenitiesReport(ByVal sender As Object, ByVal e As EventArgs) Handles btnDocument1.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_AMENITIES_REPORT As Integer = 1
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeAmenitiesReport1.SelectedValue
        Dim details As String = Request.Form("commentAmenitiesReport1")
        Dim staffID As Integer = CaseManagerAmenitiesReport1.SelectedValue
        Dim status As String = StatusAmenitiesReport1.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_AMENITIES_REPORT)
    End Sub

    Protected Sub CreateContractsExecutionChecklist(ByVal sender As Object, ByVal e As EventArgs) Handles btnDocument5.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_CONTRACTS_EXECUTION_CHECKLIST As Integer = 5
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeContractsExecutionChecklist5.SelectedValue
        Dim details As String = Request.Form("commentContractsExecutionChecklist5")
        Dim staffID As Integer = CaseManagerContractsExecutionChecklist5.SelectedValue
        Dim status As String = StatusContractsExecutionChecklist5.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_CONTRACTS_EXECUTION_CHECKLIST)
    End Sub

    Protected Sub CreateDataEntryProcess(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProcess13.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const PROCESS_DATA_ENTRY As Integer = 13

        Dim noticeTypeID As Integer = NoticeType13.SelectedValue
        Dim details As String = Request.Form("Comment13")
        Dim staffID As Integer = CaseManager13.SelectedValue
        Dim status As String = Status13.SelectedValue

        InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DATA_ENTRY, fileID, REVIEW_TYPE_ID, sessionUserID)
    End Sub

    Protected Sub CreateOtherProcess(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProcess21.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const PROCESS_OTHER As Integer = 21

        Dim noticeTypeID As Integer = NoticeType21.SelectedValue
        Dim details As String = Request.Form("Comment21")
        Dim staffID As Integer = CaseManager21.SelectedValue
        Dim status As String = Status21.SelectedValue

        InsertFileError(details, status, noticeTypeID, staffID, PROCESS_OTHER, fileID, REVIEW_TYPE_ID, sessionUserID)
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

    Protected Sub CreateReasonableRentComparables(ByVal sender As Object, ByVal e As EventArgs) Handles btnDocument2.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_REASONABLE_RENT_COMPARABLES As Integer = 2
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeReasonableRentComparables2.SelectedValue
        Dim details As String = Request.Form("commentReasonableRentComparables2")
        Dim staffID As Integer = CaseManagerReasonableRentComparables2.SelectedValue
        Dim status As String = StatusReasonableRentComparables2.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_REASONABLE_RENT_COMPARABLES)
    End Sub

    Protected Sub CreateRentIncreaseRequestFormIfApplicable(ByVal sender As Object, ByVal e As EventArgs) Handles btnDocument4.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_RENT_INCREASE_REQUEST_FORM As Integer = 4
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeRentIncreaseRequestFormIfApplicable4.SelectedValue
        Dim details As String = Request.Form("commentRentIncreaseRequestFormIfApplicable4")
        Dim staffID As Integer = CaseManagerRentIncreaseRequestFormIfApplicable4.SelectedValue
        Dim status As String = StatusRentIncreaseRequestFormIfApplicable4.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_RENT_INCREASE_REQUEST_FORM)
    End Sub

    Protected Sub CreateRentBurdenWorksheet(ByVal sender As Object, ByVal e As EventArgs) Handles btnDocument3.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_RENT_BURDEN_WORKSHEET As Integer = 3
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeRentBurdenWorksheet3.SelectedValue
        Dim details As String = Request.Form("commentRentBurdenWorksheet3")
        Dim staffID As Integer = CaseManagerRentBurdenWorksheet3.SelectedValue
        Dim status As String = StatusRentBurdenWorksheet3.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_RENT_BURDEN_WORKSHEET)
    End Sub

    Protected Sub CreateRentDeterminationCertification(ByVal sender As Object, ByVal e As EventArgs) Handles btnDocument7.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_REASONABLE_RENT_DETERMINATION_CERTIFICATION As Integer = 7
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeReasonableRentDeterminationCertification7.SelectedValue
        Dim details As String = Request.Form("commentRentDeterminationCertification7")
        Dim staffID As Integer = CaseManagerRentDeterminationCertification7.SelectedValue
        Dim status As String = StatusRentDeterminationCertification7.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_REASONABLE_RENT_DETERMINATION_CERTIFICATION)
    End Sub

    Protected Sub CreateReasonableRentProcess(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProcess15.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const PROCESS_REASONABLE_RENT As Integer = 15

        Dim noticeTypeID As Integer = NoticeType15.SelectedValue
        Dim details As String = Request.Form("Comment15")
        Dim staffID As Integer = CaseManager15.SelectedValue
        Dim status As String = Status15.SelectedValue

        InsertFileError(details, status, noticeTypeID, staffID, PROCESS_REASONABLE_RENT, fileID, REVIEW_TYPE_ID, sessionUserID)
    End Sub

    Public Sub DeleteCheckedItems(ByRef tableName As String, ByVal fileID As Integer)
        conn.Open()
        Dim query As New SqlCommand("DELETE FROM " & tableName & " WHERE fk_FileID = '" & fileID & "'", conn)
        query.ExecuteNonQuery()
        conn.Close()
    End Sub

    Public Sub DisplayDropDownlistHouseSpecialist(ByVal fileID As Integer)
        conn.Open()
        Dim houseSpecialistFullName As String
        Dim houseSpecialistID As Integer

        Dim query As String = String.Empty
        query &= "SELECT Users.UserID, Users.FirstName + ' ' + Users.LastName AS FullName FROM Files "
        query &= "INNER JOIN Users ON Files.fk_CaseManagerID = Users.UserID WHERE FileID = '" & fileID & "'"

        Dim result As New SqlCommand(query, conn)
        Dim reader As SqlDataReader = result.ExecuteReader()
        While reader.Read
            houseSpecialistID = CStr(reader("UserID"))
            houseSpecialistFullName = CStr(reader("FullName"))
        End While

        If Not IsPostBack Then
            If houseSpecialistID <> 0 Then
                'Data Entry
                CaseManager13.DataBind()
                CaseManager13.Items.FindByValue(houseSpecialistID).Selected = True

                'Other
                CaseManager21.DataBind()
                CaseManager21.Items.FindByValue(houseSpecialistID).Selected = True

                'Reasonable Rent
                CaseManager15.DataBind()
                CaseManager15.Items.FindByValue(houseSpecialistID).Selected = True

                'AmenitiesReport
                CaseManagerAmenitiesReport1.DataBind()
                CaseManagerAmenitiesReport1.Items.FindByValue(houseSpecialistID).Selected = True

                'Reasonable Rent Determination Certification
                CaseManagerRentDeterminationCertification7.DataBind()
                CaseManagerRentDeterminationCertification7.Items.FindByValue(houseSpecialistID).Selected = True

                'Reasonable Rent Comparables
                CaseManagerReasonableRentComparables2.DataBind()
                CaseManagerReasonableRentComparables2.Items.FindByValue(houseSpecialistID).Selected = True

                'Rent Burden Worksheet
                CaseManagerRentBurdenWorksheet3.DataBind()
                CaseManagerRentBurdenWorksheet3.Items.FindByValue(houseSpecialistID).Selected = True

                'Rent Increase Request Form (If Applicable)
                CaseManagerRentIncreaseRequestFormIfApplicable4.DataBind()
                CaseManagerRentIncreaseRequestFormIfApplicable4.Items.FindByValue(houseSpecialistID).Selected = True

                'Contracts Execution Checklist
                CaseManagerContractsExecutionChecklist5.DataBind()
                CaseManagerContractsExecutionChecklist5.Items.FindByValue(houseSpecialistID).Selected = True

                'Other
                CaseManagerOther6.DataBind()
                CaseManagerOther6.Items.FindByValue(houseSpecialistID).Selected = True
            End If
        End If
        conn.Close()
    End Sub

    Public Sub DisplayDropDownlistNotice()
        If Not IsPostBack Then
            'Data Entry
            NoticeType13.AppendDataBoundItems = True
            NoticeType13.Items.Insert(0, New ListItem("Notice", "2"))

            'Other
            NoticeType21.AppendDataBoundItems = True
            NoticeType21.Items.Insert(0, New ListItem("Notice", "2"))

            'Reasonable Rent
            NoticeType15.AppendDataBoundItems = True
            NoticeType15.Items.Insert(0, New ListItem("Notice", "2"))

            'Amenities Report
            NoticeTypeAmenitiesReport1.AppendDataBoundItems = True
            NoticeTypeAmenitiesReport1.Items.Insert(0, New ListItem("Notice", "2"))

            'Reasonable Rent Determination Certification
            NoticeTypeReasonableRentDeterminationCertification7.AppendDataBoundItems = True
            NoticeTypeReasonableRentDeterminationCertification7.Items.Insert(0, New ListItem("Notice", "2"))

            'Reasonable Rent Comparables
            NoticeTypeReasonableRentComparables2.AppendDataBoundItems = True
            NoticeTypeReasonableRentComparables2.Items.Insert(0, New ListItem("Notice", "2"))

            'Rent Burden Worksheet
            NoticeTypeRentBurdenWorksheet3.AppendDataBoundItems = True
            NoticeTypeRentBurdenWorksheet3.Items.Insert(0, New ListItem("Notice", "2"))

            'Rent Increase Request Form (If Applicable)
            NoticeTypeRentIncreaseRequestFormIfApplicable4.AppendDataBoundItems = True
            NoticeTypeRentIncreaseRequestFormIfApplicable4.Items.Insert(0, New ListItem("Notice", "2"))

            'Contracts Execution Checklist
            NoticeTypeContractsExecutionChecklist5.AppendDataBoundItems = True
            NoticeTypeContractsExecutionChecklist5.Items.Insert(0, New ListItem("Notice", "2"))

            'Other
            NoticeTypeOther6.AppendDataBoundItems = True
            NoticeTypeOther6.Items.Insert(0, New ListItem("Notice", "2"))
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
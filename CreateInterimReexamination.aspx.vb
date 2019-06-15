Imports System.Data.SqlClient
Imports System.Web.Configuration

Public Class CreateInterimReexamination
    Inherits System.Web.UI.Page
    Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)
    Const REVIEW_TYPE_ID As Integer = 3
    Const PROCESS_DOCUMENT_TYPE As Integer = 18

#Region "For Error Checkboxes (Processing)"
    Const PROCESS_VERTIFICATION As Integer = 1
    Const PROCESS_CALCULATION As Integer = 2
    Const PROCESS_PAYMENT_STANDARD As Integer = 3
    Const PROCESS_UTILITY_ALLOWANCE As Integer = 4
    Const PROCESS_TENANT_RENT As Integer = 5
    Const PROCESS_OCCUPANCY_STANDARD As Integer = 6
    Const PROCESS_INTERIM_REEXAMINATION As Integer = 7
    Const PROCESS_CHANGE_IN_FAMILY_COMPOSITION As Integer = 10
    Const PROCESS_DATA_ENTRY As Integer = 13
    Const PROCESS_OTHER As Integer = 21
#End Region

#Region "For Error Checkboxes (Documents)"
    Const DOCUMENT_UTILITY_ALLOWANCE_CHECKLIST As Integer = 32
    Const DOCUMENT_NOTES As Integer = 56
    Const DOCUMENT_OTHER As Integer = 6
    Const DOCUMENT_HAP_PROCESSING_ACTION_FORM As Integer = 50
    Const DOCUMENT_RENT_LETTER_TENANT As Integer = 58
    Const DOCUMENT_RENT_LETTER_OWNER As Integer = 59
    Const DOCUMENT_HUD_FORM_50058 As Integer = 60
    Const DOCUMENT_RENT_CALCULATION_SHEET As Integer = 61
    Const DOCUMENT_UA_CALCULATION_WORKSHEET_ELITE As Integer = 51
    Const DOCUMENT_APPLICATION_FOR_CONTINUED_OCCUPANCY As Integer = 62
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim fileID As Integer = Request.QueryString("FileID")
        DisplayDropDownlistCaseManager(fileID)
        DisplayDropDownlistNotice()
    End Sub

    Public Function AssignSeededReviewDocuments(ByVal data As Dictionary(Of Integer, Boolean)) As Dictionary(Of Integer, Boolean)
        Dim documents As New Dictionary(Of Integer, Boolean)

        'Leasing Documents 
        If Not Request.Form("documentUtilityAllowanceChecklist") Is Nothing Or Not Request.Form("documentUtilityAllowanceChecklist") = "" Then
            data(DOCUMENT_UTILITY_ALLOWANCE_CHECKLIST) = True
        End If

        'Notes / Portability Billing / Compliance
        If Not Request.Form("documentNotes") Is Nothing Or Not Request.Form("documentNotes") = "" Then
            data(DOCUMENT_NOTES) = True
        End If

        If Not Request.Form("documentOther") Is Nothing Or Not Request.Form("documentOther") = "" Then
            data(DOCUMENT_OTHER) = True
        End If

        'Recertification Documents
        If Not Request.Form("documentRentLetterTenant") Is Nothing Or Not Request.Form("documentRentLetterTenant") = "" Then
            data(DOCUMENT_RENT_LETTER_TENANT) = True
        End If

        If Not Request.Form("documentRentLetterOwner") Is Nothing Or Not Request.Form("documentRentLetterOwner") = "" Then
            data(DOCUMENT_RENT_LETTER_OWNER) = True
        End If

        If Not Request.Form("documentHudForm50058") Is Nothing Or Not Request.Form("documentHudForm50058") = "" Then
            data(DOCUMENT_HUD_FORM_50058) = True
        End If

        If Not Request.Form("documentRentCalculationSheet") Is Nothing Or Not Request.Form("documentRentCalculationSheet") = "" Then
            data(DOCUMENT_RENT_CALCULATION_SHEET) = True
        End If

        If Not Request.Form("documentUaCalculationWorksheetElite") Is Nothing Or Not Request.Form("documentUaCalculationWorksheetElite") = "" Then
            data(DOCUMENT_UA_CALCULATION_WORKSHEET_ELITE) = True
        End If

        If Not Request.Form("documentApplicationForContinuedOccupancy") Is Nothing Or Not Request.Form("documentApplicationForContinuedOccupancy") = "" Then
            data(DOCUMENT_APPLICATION_FOR_CONTINUED_OCCUPANCY) = True
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

        If Not Request.Form("processVerification") Is Nothing Or Not Request.Form("processVerification") = "" Then
            data(PROCESS_VERTIFICATION) = True
        End If

        If Not Request.Form("processCalculation") Is Nothing Or Not Request.Form("processCalculation") = "" Then
            data(PROCESS_CALCULATION) = True
        End If

        If Not Request.Form("processPaymentStandard") Is Nothing Or Not Request.Form("processPaymentStandard") = "" Then
            data(PROCESS_PAYMENT_STANDARD) = True
        End If

        If Not Request.Form("processUtilityAllowance") Is Nothing Or Not Request.Form("processUtilityAllowance") = "" Then
            data(PROCESS_UTILITY_ALLOWANCE) = True
        End If

        If Not Request.Form("processTenantRent") Is Nothing Or Not Request.Form("processTenantRent") = "" Then
            data(PROCESS_TENANT_RENT) = True
        End If

        If Not Request.Form("processOccupancyStandard") Is Nothing Or Not Request.Form("processOccupancyStandard") = "" Then
            data(PROCESS_OCCUPANCY_STANDARD) = True
        End If

        If Not Request.Form("processInterimReexamination") Is Nothing Or Not Request.Form("processInterimReexamination") = "" Then
            data(PROCESS_INTERIM_REEXAMINATION) = True
        End If

        If Not Request.Form("processChangeInFamilyComposition") Is Nothing Or Not Request.Form("processChangeInFamilyComposition") = "" Then
            data(PROCESS_CHANGE_IN_FAMILY_COMPOSITION) = True
        End If

        If Not Request.Form("processDataEntry") Is Nothing Or Not Request.Form("processDataEntry") = "" Then
            data(PROCESS_DATA_ENTRY) = True
        End If

        If Not Request.Form("processOther") Is Nothing Or Not Request.Form("processOther") = "" Then
            data(PROCESS_OTHER) = True
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

    Protected Sub CreateApplicationForContinuedOccupancy(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateApplicationForContinuedOccupancy.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_APPLICATION_FOR_CONTINUED_OCCUPANCY As Integer = 62
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeApplicationForContinuedOccupancy.SelectedValue
        Dim details As String = Request.Form("commentApplicationForContinuedOccupancy")
        Dim staffID As Integer = CaseManagerApplicationForContinuedOccupancy.SelectedValue
        Dim status As String = StatusApplicationForContinuedOccupancy.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_APPLICATION_FOR_CONTINUED_OCCUPANCY)
    End Sub

    Protected Sub CreateCalculation(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProcessCalculation.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const PROCESS_CALCULATION As Integer = 2

        Dim noticeTypeID As Integer = NoticeTypeCalculation.SelectedValue
        Dim details As String = Request.Form("commentCalculation")
        Dim staffID As Integer = CaseManagerCalculation.SelectedValue
        Dim status As String = StatusCalculation.SelectedValue

        InsertFileError(details, status, noticeTypeID, staffID, PROCESS_CALCULATION, fileID, REVIEW_TYPE_ID, sessionUserID)
    End Sub

    Protected Sub CreateChangeInFamilyComposition(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProcessChangeInFamilyComposition.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const PROCESS_CHANGE_IN_FAMILY_COMPOSITION As Integer = 10

        Dim noticeTypeID As Integer = NoticeTypeChangeInFamilyComposition.SelectedValue
        Dim details As String = Request.Form("commentChangeInFamilyComposition")
        Dim staffID As Integer = CaseManagerChangeInFamilyComposition.SelectedValue
        Dim status As String = StatusChangeInFamilyComposition.SelectedValue

        InsertFileError(details, status, noticeTypeID, staffID, PROCESS_CHANGE_IN_FAMILY_COMPOSITION, fileID, REVIEW_TYPE_ID, sessionUserID)
    End Sub

    Protected Sub CreateDataEntry(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProcessDataEntry.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const PROCESS_DATA_ENTRY As Integer = 13

        Dim noticeTypeID As Integer = NoticeTypeDataEntry.SelectedValue
        Dim details As String = Request.Form("commentDataEntry")
        Dim staffID As Integer = CaseManagerDataEntry.SelectedValue
        Dim status As String = StatusDataEntry.SelectedValue

        InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DATA_ENTRY, fileID, REVIEW_TYPE_ID, sessionUserID)
    End Sub

    Protected Sub CreateDocumentOther(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateDocumentOther.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_OTHER As Integer = 6
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeDocumentOther.SelectedValue
        Dim details As String = Request.Form("commentDocumentOther")
        Dim staffID As Integer = CaseManagerDocumentOther.SelectedValue
        Dim status As String = StatusDocumentOther.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_OTHER)
    End Sub

    Protected Sub CreateHapProcessingActionForm(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateHapProcessingActionForm.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_HAP_PROCESSING_ACTION_FORM As Integer = 50
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeHapProcessingActionForm.SelectedValue
        Dim details As String = Request.Form("commentHapProcessingActionForm")
        Dim staffID As Integer = CaseManagerHapProcessingActionForm.SelectedValue
        Dim status As String = StatusHapProcessingActionForm.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_HAP_PROCESSING_ACTION_FORM)
    End Sub

    Protected Sub CreateHudForm50058(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateHudForm50058.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_HUD_FORM_50058 As Integer = 60
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeHudForm50058.SelectedValue
        Dim details As String = Request.Form("commentHudForm50058")
        Dim staffID As Integer = CaseManagerHudForm50058.SelectedValue
        Dim status As String = StatusHudForm50058.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_HUD_FORM_50058)
    End Sub

    Protected Sub CreateInterimReexamination(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProcessInterimReexamination.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const PROCESS_INTERIM_REEXAMINATION As Integer = 8

        Dim noticeTypeID As Integer = NoticeTypeInterimReexamination.SelectedValue
        Dim details As String = Request.Form("commentInterimReexamination")
        Dim staffID As Integer = CaseManagerInterimReexamination.SelectedValue
        Dim status As String = StatusInterimReexamination.SelectedValue

        InsertFileError(details, status, noticeTypeID, staffID, PROCESS_INTERIM_REEXAMINATION, fileID, REVIEW_TYPE_ID, sessionUserID)
    End Sub

    Protected Sub createOccupancyStandard(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProcessOccupancyStandard.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const PROCESS_OCCUPANCY_STANDARD As Integer = 6

        Dim noticeTypeID As Integer = NoticeTypeOccupancyStandard.SelectedValue
        Dim details As String = Request.Form("commentOccupancyStandard")
        Dim staffID As Integer = CaseManagerOccupancyStandard.SelectedValue
        Dim status As String = StatusOccupancyStandard.SelectedValue

        InsertFileError(details, status, noticeTypeID, staffID, PROCESS_OCCUPANCY_STANDARD, fileID, REVIEW_TYPE_ID, sessionUserID)
    End Sub

    Protected Sub CreateOther(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProcessOther.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const PROCESS_OTHER As Integer = 21

        Dim noticeTypeID As Integer = NoticeTypeProcessOther.SelectedValue
        Dim details As String = Request.Form("commentProcessOther")
        Dim staffID As Integer = CaseManagerProcessOther.SelectedValue
        Dim status As String = StatusProcessOther.SelectedValue

        InsertFileError(details, status, noticeTypeID, staffID, PROCESS_OTHER, fileID, REVIEW_TYPE_ID, sessionUserID)
    End Sub

    Protected Sub CreatePaymentStandard(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProcessPaymentStandard.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const PROCESS_PAYMENT_STANDARD As Integer = 3

        Dim noticeTypeID As Integer = NoticeTypePaymentStandard.SelectedValue
        Dim details As String = Request.Form("commentPaymentStandard")
        Dim staffID As Integer = CaseManagerPaymentStandard.SelectedValue
        Dim status As String = StatusPaymentStandard.SelectedValue

        InsertFileError(details, status, noticeTypeID, staffID, PROCESS_PAYMENT_STANDARD, fileID, REVIEW_TYPE_ID, sessionUserID)
    End Sub

    Protected Sub CreateRentCalculationSheet(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateRentCalculationSheet.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_RENT_CALCULATION_SHEET As Integer = 61
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeRentCalculationSheet.SelectedValue
        Dim details As String = Request.Form("commentRentCalculationSheet")
        Dim staffID As Integer = CaseManagerRentCalculationSheet.SelectedValue
        Dim status As String = StatusRentCalculationSheet.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_RENT_CALCULATION_SHEET)
    End Sub

    Protected Sub CreateRentLetterOwner(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateRentLetterOwner.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_RENT_LETTER_OWNER As Integer = 59
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeRentLetterOwner.SelectedValue
        Dim details As String = Request.Form("commentRentLetterOwner")
        Dim staffID As Integer = CaseManagerRentLetterOwner.SelectedValue
        Dim status As String = StatusRentLetterOwner.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_RENT_LETTER_OWNER)
    End Sub

    Protected Sub CreateRentLetterTenant(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateRentLetterTenant.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_RENT_LETTER_TENANT As Integer = 58
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeRentLetterTenant.SelectedValue
        Dim details As String = Request.Form("commentRentLetterTenant")
        Dim staffID As Integer = CaseManagerRentLetterTenant.SelectedValue
        Dim status As String = StatusRentLetterTenant.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_RENT_LETTER_TENANT)
    End Sub

    Protected Sub CreateUaCalculationWorksheetElite(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateUaCalculationWorksheetElite.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_UA_CALCULATION_WORKSHEET_ELITE As Integer = 51
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeUaCalculationWorksheetElite.SelectedValue
        Dim details As String = Request.Form("commentUaCalculationWorksheetElite")
        Dim staffID As Integer = CaseManagerUaCalculationWorksheetElite.SelectedValue
        Dim status As String = StatusUaCalculationWorksheetElite.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_UA_CALCULATION_WORKSHEET_ELITE)
    End Sub

    Protected Sub CreateUtilityAllowance(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProcessUtilityAllowance.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const PROCESS_UTILITY_ALLOWANCE As Integer = 4

        Dim noticeTypeID As Integer = NoticeTypeUtilityAllowance.SelectedValue
        Dim details As String = Request.Form("commentUtilityAllowance")
        Dim staffID As Integer = CaseManagerUtilityAllowance.SelectedValue
        Dim status As String = StatusUtilityAllowance.SelectedValue

        InsertFileError(details, status, noticeTypeID, staffID, PROCESS_UTILITY_ALLOWANCE, fileID, REVIEW_TYPE_ID, sessionUserID)
    End Sub

    Protected Sub CreateUtilityAllowanceChecklist(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateUtilityAllowanceChecklist.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_UTILITY_ALLOWANCE_CHECKLIST As Integer = 32
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeUtilityAllowanceChecklist.SelectedValue
        Dim details As String = Request.Form("commentUtilityAllowanceChecklist")
        Dim staffID As Integer = CaseManagerUtilityAllowanceChecklist.SelectedValue
        Dim status As String = StatusUtilityAllowanceChecklist.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_UTILITY_ALLOWANCE_CHECKLIST)
    End Sub

    Protected Sub CreateTenantRent(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProcessTenantRent.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const PROCESS_TENANT_RENT As Integer = 5

        Dim noticeTypeID As Integer = NoticeTypeTenantRent.SelectedValue
        Dim details As String = Request.Form("commentTenantRent")
        Dim staffID As Integer = CaseManagerTenantRent.SelectedValue
        Dim status As String = StatusTenantRent.SelectedValue

        InsertFileError(details, status, noticeTypeID, staffID, PROCESS_TENANT_RENT, fileID, REVIEW_TYPE_ID, sessionUserID)
    End Sub

    Protected Sub CreateVerification(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProcessVerification.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const PROCESS_VERIFICATION As Integer = 1

        Dim noticeTypeID As Integer = NoticeTypeVerification.SelectedValue
        Dim details As String = Request.Form("commentVerification")
        Dim staffID As Integer = CaseManagerVerification.SelectedValue
        Dim status As String = StatusVerification.SelectedValue

        InsertFileError(details, status, noticeTypeID, staffID, PROCESS_VERIFICATION, fileID, REVIEW_TYPE_ID, sessionUserID)
    End Sub

    Public Sub DeleteCheckedItems(ByRef tableName As String, ByVal fileID As Integer)
        conn.Open()
        Dim query As New SqlCommand("DELETE FROM " & tableName & " WHERE fk_FileID = '" & fileID & "'", conn)
        query.ExecuteNonQuery()
        conn.Close()
    End Sub

    Public Sub DisplayDropDownlistCaseManager(ByVal fileID As Integer)
        conn.Open()
        Dim caseManagerFullName As String
        Dim caseManagerID As Integer

        Dim query As String = String.Empty
        query &= "SELECT Users.UserID, Users.FirstName + ' ' + Users.LastName AS FullName FROM Files "
        query &= "INNER JOIN Users ON Files.fk_CaseManagerID = Users.UserID WHERE FileID = '" & fileID & "'"

        Dim result As New SqlCommand(query, conn)
        Dim reader As SqlDataReader = result.ExecuteReader()
        While reader.Read
            caseManagerID = CStr(reader("UserID"))
            caseManagerFullName = CStr(reader("FullName"))
        End While

        If Not IsPostBack Then
            If caseManagerID <> 0 Then
                'Verification
                CaseManagerVerification.DataBind()
                CaseManagerVerification.Items.FindByValue(caseManagerID).Selected = True

                'Calculation
                CaseManagerCalculation.DataBind()
                CaseManagerCalculation.Items.FindByValue(caseManagerID).Selected = True

                'Payment Standard
                CaseManagerPaymentStandard.DataBind()
                CaseManagerPaymentStandard.Items.FindByValue(caseManagerID).Selected = True

                'Utility Allowance
                CaseManagerUtilityAllowance.DataBind()
                CaseManagerUtilityAllowance.Items.FindByValue(caseManagerID).Selected = True

                'Tenant Rent
                CaseManagerTenantRent.DataBind()
                CaseManagerTenantRent.Items.FindByValue(caseManagerID).Selected = True

                'Occupancy Standard
                CaseManagerOccupancyStandard.DataBind()
                CaseManagerOccupancyStandard.Items.FindByValue(caseManagerID).Selected = True

                'Interim Reexamination
                CaseManagerInterimReexamination.DataBind()
                CaseManagerInterimReexamination.Items.FindByValue(caseManagerID).Selected = True

                'Change in Family Composition
                CaseManagerChangeInFamilyComposition.DataBind()
                CaseManagerChangeInFamilyComposition.Items.FindByValue(caseManagerID).Selected = True

                'Data Entry
                CaseManagerDataEntry.DataBind()
                CaseManagerDataEntry.Items.FindByValue(caseManagerID).Selected = True

                'Other - Process
                CaseManagerProcessOther.DataBind()
                CaseManagerProcessOther.Items.FindByValue(caseManagerID).Selected = True

                'Utility Allowance Checklist
                CaseManagerUtilityAllowanceChecklist.DataBind()
                CaseManagerUtilityAllowanceChecklist.Items.FindByValue(caseManagerID).Selected = True

                'Notes
                CaseManagerNotes.DataBind()
                CaseManagerNotes.Items.FindByValue(caseManagerID).Selected = True

                'Other - Document
                CaseManagerDocumentOther.DataBind()
                CaseManagerDocumentOther.Items.FindByValue(caseManagerID).Selected = True

                'HAP Processing Action Form
                CaseManagerHapProcessingActionForm.DataBind()
                CaseManagerHapProcessingActionForm.Items.FindByValue(caseManagerID).Selected = True

                'Rent Letter – Tenant
                CaseManagerRentLetterTenant.DataBind()
                CaseManagerRentLetterTenant.Items.FindByValue(caseManagerID).Selected = True

                'Rent Letter – Owner
                CaseManagerRentLetterOwner.DataBind()
                CaseManagerRentLetterOwner.Items.FindByValue(caseManagerID).Selected = True

                'Hud Form 50058
                CaseManagerHudForm50058.DataBind()
                CaseManagerHudForm50058.Items.FindByValue(caseManagerID).Selected = True

                'Rent Calculation Sheet
                CaseManagerRentCalculationSheet.DataBind()
                CaseManagerRentCalculationSheet.Items.FindByValue(caseManagerID).Selected = True

                'UA Calculation Worksheet - Elite
                CaseManagerUaCalculationWorksheetElite.DataBind()
                CaseManagerUaCalculationWorksheetElite.Items.FindByValue(caseManagerID).Selected = True

                'Application For Continued Occupancy
                CaseManagerApplicationForContinuedOccupancy.DataBind()
                CaseManagerApplicationForContinuedOccupancy.Items.FindByValue(caseManagerID).Selected = True
            End If
        End If
        conn.Close()
    End Sub

    Public Sub DisplayDropDownlistNotice()
        If Not IsPostBack Then
            'Verification
            NoticeTypeVerification.AppendDataBoundItems = True
            NoticeTypeVerification.Items.Insert(0, New ListItem("Notice", "2"))

            'Calculation
            NoticeTypeCalculation.AppendDataBoundItems = True
            NoticeTypeCalculation.Items.Insert(0, New ListItem("Notice", "2"))

            'Payment Standard
            NoticeTypePaymentStandard.AppendDataBoundItems = True
            NoticeTypePaymentStandard.Items.Insert(0, New ListItem("Notice", "2"))

            'Utility Allowance
            NoticeTypeUtilityAllowance.AppendDataBoundItems = True
            NoticeTypeUtilityAllowance.Items.Insert(0, New ListItem("Notice", "2"))

            'Tenant Rent
            NoticeTypeTenantRent.AppendDataBoundItems = True
            NoticeTypeTenantRent.Items.Insert(0, New ListItem("Notice", "2"))

            'Occupany Standard
            NoticeTypeOccupancyStandard.AppendDataBoundItems = True
            NoticeTypeOccupancyStandard.Items.Insert(0, New ListItem("Notice", "2"))

            'Interim Reexamination
            NoticeTypeInterimReexamination.AppendDataBoundItems = True
            NoticeTypeInterimReexamination.Items.Insert(0, New ListItem("Notice", "2"))

            'Change in Family Composition
            NoticeTypeChangeInFamilyComposition.AppendDataBoundItems = True
            NoticeTypeChangeInFamilyComposition.Items.Insert(0, New ListItem("Notice", "2"))

            'Data Entry
            NoticeTypeDataEntry.AppendDataBoundItems = True
            NoticeTypeDataEntry.Items.Insert(0, New ListItem("Notice", "2"))

            'Other - Process
            NoticeTypeProcessOther.AppendDataBoundItems = True
            NoticeTypeProcessOther.Items.Insert(0, New ListItem("Notice", "2"))

            'Utility Allowance Checklist
            NoticeTypeUtilityAllowanceChecklist.AppendDataBoundItems = True
            NoticeTypeUtilityAllowanceChecklist.Items.Insert(0, New ListItem("Notice", "2"))

            'Notes
            NoticeTypeNotes.AppendDataBoundItems = True
            NoticeTypeNotes.Items.Insert(0, New ListItem("Notice", "2"))

            'Other - Document
            NoticeTypeDocumentOther.AppendDataBoundItems = True
            NoticeTypeDocumentOther.Items.Insert(0, New ListItem("Notice", "2"))

            'HAP Processing Action Form
            NoticeTypeHapProcessingActionForm.AppendDataBoundItems = True
            NoticeTypeHapProcessingActionForm.Items.Insert(0, New ListItem("Notice", "2"))

            'Rent Letter – Tenant
            NoticeTypeRentLetterTenant.AppendDataBoundItems = True
            NoticeTypeRentLetterTenant.Items.Insert(0, New ListItem("Notice", "2"))

            'Rent Letter – Owner
            NoticeTypeRentLetterOwner.AppendDataBoundItems = True
            NoticeTypeRentLetterOwner.Items.Insert(0, New ListItem("Notice", "2"))

            'Hud Form 50058
            NoticeTypeHudForm50058.AppendDataBoundItems = True
            NoticeTypeHudForm50058.Items.Insert(0, New ListItem("Notice", "2"))

            'Rent Calculation Sheet
            NoticeTypeRentCalculationSheet.AppendDataBoundItems = True
            NoticeTypeRentCalculationSheet.Items.Insert(0, New ListItem("Notice", "2"))

            'UA Calculation Worksheet - Elite
            NoticeTypeUaCalculationWorksheetElite.AppendDataBoundItems = True
            NoticeTypeUaCalculationWorksheetElite.Items.Insert(0, New ListItem("Notice", "2"))

            'Application For Continued Occupancy
            NoticeTypeApplicationForContinuedOccupancy.AppendDataBoundItems = True
            NoticeTypeApplicationForContinuedOccupancy.Items.Insert(0, New ListItem("Notice", "2"))
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
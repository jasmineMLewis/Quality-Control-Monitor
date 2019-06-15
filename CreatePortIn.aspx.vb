Imports System.Data.SqlClient
Imports System.Web.Configuration

Public Class CreatePortIn
    Inherits System.Web.UI.Page
    Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)
    Const REVIEW_TYPE_ID As Integer = 5
    Const PROCESS_DOCUMENT_TYPE As Integer = 18

#Region "For Error Checkboxes (Processing)"
    Const PROCESS_PAYMENT_STANDARD As Integer = 3
    Const PROCESS_UTILITY_ALLOWANCE As Integer = 4
    Const PROCESS_TENANT_RENT As Integer = 5
    Const PROCESS_PORTABILITY As Integer = 16
    Const PROCESS_DATA_ENTRY As Integer = 13
    Const PROCESS_OTHER As Integer = 21
#End Region

#Region "For Error Checkboxes (Documents)"
    Const DOCUMENT_MASTER_LEASING_CHECKLIST As Integer = 29
    Const DOCUMENT_CHECKLIST_LEASING_INSPECTIONS As Integer = 30
    Const DOCUMENT_LEASING_PACKET_CHECKLIST As Integer = 31
    Const DOCUMENT_CONTRACTS_EXECUTION_CHECKLIST As Integer = 5
    Const DOCUMENT_UTILITY_ALLOWANCE_CHECKLIST As Integer = 32
    Const DOCUMENT_LEASE As Integer = 33
    Const DOCUMENT_HAP_CONTRACT As Integer = 53
    Const DOCUMENT_HUD_TENANCY_ADDENDUM As Integer = 34
    Const DOCUMENT_RFTA As Integer = 52
    Const DOCUMENT_SECURITY_DEPOSIT_CONFIRMATION As Integer = 35
    Const DOCUMENT_IMPORTANT_NOTICE_TO_OWNER_AND_TENANT As Integer = 36
    Const DOCUMENT_HQS_INSPECTION_CERTIFICATION_TENANT As Integer = 37
    Const DOCUMENT_HQS_INSPECTION_CERTIFICATION_OWNER As Integer = 38
    Const DOCUMENT_LEAD_BASED_PAINT_DISCLOSURE_AND_CERTIFICATION As Integer = 39
    Const DOCUMENT_HOUSING_SEARCH_LOG As Integer = 40
    Const DOCUMENT_INITIAL_RENT_LETTER As Integer = 41
    Const DOCUMENT_INITIAL_HUD_FORM_50058 As Integer = 42
    Const DOCUMENT_INITIAL_RENT_CALCULATION_SHEET As Integer = 43
    Const DOCUMENT_INITIAL_UA_CALCULATION_WORKSHEE_ELITE As Integer = 44
    Const DOCUMENT_HAP_CONTRACT_INITIAL_UNIT As Integer = 45
    Const DOCUMENT_HUD_TENANCY_ADDENDUM_INITIAL_UNIT As Integer = 46
    Const DOCUMENT_LEASE_INITIAL_UNIT As Integer = 47
    Const DOCUMENT_RFTA_INITIAL_UNIT As Integer = 48
    Const DOCUMENT_UTILITY_ALLOWANCE_CHECKLIST_INITIAL_UNIT As Integer = 49
    Const DOCUMENT_OTHER As Integer = 6
    Const DOCUMENT_HAP_PROCESSING_ACTION_FORM As Integer = 50
    Const DOCUMENT_UA_CALCULATION_WORKSHEET_ELITE As Integer = 51
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim fileID As Integer = Request.QueryString("FileID")
        DisplayDropDownlistHousingSpecialist(fileID)
        DisplayDropDownlistNotice()
    End Sub

    Public Function AssignSeededReviewDocuments(ByVal data As Dictionary(Of Integer, Boolean)) As Dictionary(Of Integer, Boolean)
        Dim documents As New Dictionary(Of Integer, Boolean)

        'Leasing Documents 
        If Not Request.Form("documentMasterLeasingChecklist") Is Nothing Or Not Request.Form("documentMasterLeasingChecklist") = "" Then
            data(DOCUMENT_MASTER_LEASING_CHECKLIST) = True
        End If

        If Not Request.Form("documentChecklistLeasingInspections") Is Nothing Or Not Request.Form("documentChecklistLeasingInspections") = "" Then
            data(DOCUMENT_CHECKLIST_LEASING_INSPECTIONS) = True
        End If

        If Not Request.Form("documentLeasingPacketChecklist") Is Nothing Or Not Request.Form("documentLeasingPacketChecklist") = "" Then
            data(DOCUMENT_LEASING_PACKET_CHECKLIST) = True
        End If

        If Not Request.Form("documentContractsExecutionChecklist") Is Nothing Or Not Request.Form("documentContractsExecutionChecklist") = "" Then
            data(DOCUMENT_CONTRACTS_EXECUTION_CHECKLIST) = True
        End If

        If Not Request.Form("documentUtilityAllowanceChecklist") Is Nothing Or Not Request.Form("documentUtilityAllowanceChecklist") = "" Then
            data(DOCUMENT_UTILITY_ALLOWANCE_CHECKLIST) = True
        End If

        If Not Request.Form("documentLease") Is Nothing Or Not Request.Form("documentLease") = "" Then
            data(DOCUMENT_LEASE) = True
        End If

        If Not Request.Form("documentHapContract") Is Nothing Or Not Request.Form("documentHapContract") = "" Then
            data(DOCUMENT_HAP_CONTRACT) = True
        End If

        If Not Request.Form("documentHudTenancyAddendum") Is Nothing Or Not Request.Form("documentHudTenancyAddendum") = "" Then
            data(DOCUMENT_HUD_TENANCY_ADDENDUM) = True
        End If

        If Not Request.Form("documentRfta") Is Nothing Or Not Request.Form("documentRfta") = "" Then
            data(DOCUMENT_RFTA) = True
        End If

        If Not Request.Form("documentSecurityDepositConfirmation") Is Nothing Or Not Request.Form("documentSecurityDepositConfirmation") = "" Then
            data(DOCUMENT_SECURITY_DEPOSIT_CONFIRMATION) = True
        End If

        If Not Request.Form("documentImportantNoticeToOwnerAndTenant") Is Nothing Or Not Request.Form("documentImportantNoticeToOwnerAndTenant") = "" Then
            data(DOCUMENT_IMPORTANT_NOTICE_TO_OWNER_AND_TENANT) = True
        End If

        If Not Request.Form("documentHqsInspectionCertificationTenant") Is Nothing Or Not Request.Form("documentHqsInspectionCertificationTenant") = "" Then
            data(DOCUMENT_HQS_INSPECTION_CERTIFICATION_TENANT) = True
        End If

        If Not Request.Form("documentHqsInspectionCertificationOwner") Is Nothing Or Not Request.Form("documentHqsInspectionCertificationOwner") = "" Then
            data(DOCUMENT_HQS_INSPECTION_CERTIFICATION_OWNER) = True
        End If

        If Not Request.Form("documentLeadBasedPaintDisclosureAndCertification") Is Nothing Or Not Request.Form("documentLeadBasedPaintDisclosureAndCertification") = "" Then
            data(DOCUMENT_LEAD_BASED_PAINT_DISCLOSURE_AND_CERTIFICATION) = True
        End If

        If Not Request.Form("documentHousingSearchLogIfApplicable") Is Nothing Or Not Request.Form("documentHousingSearchLogIfApplicable") = "" Then
            data(DOCUMENT_HOUSING_SEARCH_LOG) = True
        End If

        ' Master Documents
        If Not Request.Form("documentInitialRentLetter") Is Nothing Or Not Request.Form("documentInitialRentLetter") = "" Then
            data(DOCUMENT_INITIAL_RENT_LETTER) = True
        End If

        If Not Request.Form("documentInitialHudForm50058") Is Nothing Or Not Request.Form("documentInitialHudForm50058") = "" Then
            data(DOCUMENT_INITIAL_HUD_FORM_50058) = True
        End If

        If Not Request.Form("documentInitialRentCalculationSheet") Is Nothing Or Not Request.Form("documentInitialRentCalculationSheet") = "" Then
            data(DOCUMENT_INITIAL_RENT_CALCULATION_SHEET) = True
        End If

        If Not Request.Form("documentInitialUaCalculationWorksheetElite") Is Nothing Or Not Request.Form("documentInitialUaCalculationWorksheetElite") = "" Then
            data(DOCUMENT_INITIAL_UA_CALCULATION_WORKSHEE_ELITE) = True
        End If

        If Not Request.Form("documentHapContractInitialUnit") Is Nothing Or Not Request.Form("documentHapContractInitialUnit") = "" Then
            data(DOCUMENT_HAP_CONTRACT_INITIAL_UNIT) = True
        End If

        If Not Request.Form("documentHudTenancyAddendumInitialUnit") Is Nothing Or Not Request.Form("documentHudTenancyAddendumInitialUnit") = "" Then
            data(DOCUMENT_HUD_TENANCY_ADDENDUM_INITIAL_UNIT) = True
        End If

        If Not Request.Form("documentLeaseInitialUnit") Is Nothing Or Not Request.Form("documentLeaseInitialUnit") = "" Then
            data(DOCUMENT_LEASE_INITIAL_UNIT) = True
        End If

        If Not Request.Form("documentRftaInitialUnit") Is Nothing Or Not Request.Form("documentRftaInitialUnit") = "" Then
            data(DOCUMENT_RFTA_INITIAL_UNIT) = True
        End If

        If Not Request.Form("documentUtilityAllowanceChecklistInitialUnit") Is Nothing Or Not Request.Form("documentUtilityAllowanceChecklistInitialUnit") = "" Then
            data(DOCUMENT_UTILITY_ALLOWANCE_CHECKLIST_INITIAL_UNIT) = True
        End If

        'Notes / Portability Billing / Compliance
        If Not Request.Form("documentOther") Is Nothing Or Not Request.Form("documentOther") = "" Then
            data(DOCUMENT_OTHER) = True
        End If

        'Recertification Documents
        If Not Request.Form("documentHapProcessingActionForm") Is Nothing Or Not Request.Form("documentHapProcessingActionForm") = "" Then
            data(DOCUMENT_HAP_PROCESSING_ACTION_FORM) = True
        End If

        If Not Request.Form("documentUaCalculationWorksheetElite") Is Nothing Or Not Request.Form("documentUaCalculationWorksheetElite") = "" Then
            data(DOCUMENT_UA_CALCULATION_WORKSHEET_ELITE) = True
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

        If Not Request.Form("processPaymentStandard") Is Nothing Or Not Request.Form("processPaymentStandard") = "" Then
            data(PROCESS_PAYMENT_STANDARD) = True
        End If

        If Not Request.Form("processUtilityAllowance") Is Nothing Or Not Request.Form("processUtilityAllowance") = "" Then
            data(PROCESS_UTILITY_ALLOWANCE) = True
        End If

        If Not Request.Form("processTenantRent") Is Nothing Or Not Request.Form("processTenantRent") = "" Then
            data(PROCESS_TENANT_RENT) = True
        End If

        If Not Request.Form("processPortability") Is Nothing Or Not Request.Form("processPortability") = "" Then
            data(PROCESS_PORTABILITY) = True
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

    Protected Sub CreateContractsExecutionChecklist(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateContractsExecutionChecklist.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 5
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeContractsExecutionChecklist.SelectedValue
        Dim details As String = Request.Form("commentContractsExecutionChecklist")
        Dim staffID As Integer = CaseManagerContractsExecutionChecklist.SelectedValue
        Dim status As String = StatusContractsExecutionChecklist.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateChecklistLeasingInspections(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateChecklistLeasingInspections.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 30
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeChecklistLeasingInspections.SelectedValue
        Dim details As String = Request.Form("commentChecklistLeasingInspections")
        Dim staffID As Integer = CaseManagerChecklistLeasingInspections.SelectedValue
        Dim status As String = StatusChecklistLeasingInspections.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
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
        Const DOCUMENT_TYPE As Integer = 6
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeDocumentOther.SelectedValue
        Dim details As String = Request.Form("commentDocumentOther")
        Dim staffID As Integer = CaseManagerDocumentOther.SelectedValue
        Dim status As String = StatusDocumentOther.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateHapContract(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateHapContract.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 53
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeHapContract.SelectedValue
        Dim details As String = Request.Form("commentHapContract")
        Dim staffID As Integer = CaseManagerHapContract.SelectedValue
        Dim status As String = StatusHapContract.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateHapContractInitialUnit(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProcessHapContractInitialUnit.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 45
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeHapContractInitialUnit.SelectedValue
        Dim details As String = Request.Form("commentHapContractInitialUnit")
        Dim staffID As Integer = CaseManagerHapContractInitialUnit.SelectedValue
        Dim status As String = StatusHapContractInitialUnit.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateHapProcessingActionForm(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateHapProcessingActionForm.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 50
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeHapProcessingActionForm.SelectedValue
        Dim details As String = Request.Form("commentHapProcessingActionForm")
        Dim staffID As Integer = CaseManagerHapProcessingActionForm.SelectedValue
        Dim status As String = StatusHapProcessingActionForm.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateHousingSearchLogIfApplicable(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateHousingSearchLogIfApplicable.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 40
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeHousingSearchLogIfApplicable.SelectedValue
        Dim details As String = Request.Form("commentHousingSearchLogIfApplicable")
        Dim staffID As Integer = CaseManagerHousingSearchLogIfApplicable.SelectedValue
        Dim status As String = StatusHousingSearchLogIfApplicable.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateHqsInspectionCertificationOwner(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateHqsInspectionCertificationOwner.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 38
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeHqsInspectionCertificationOwner.SelectedValue
        Dim details As String = Request.Form("commentHqsInspectionCertificationOwner")
        Dim staffID As Integer = CaseManagerHqsInspectionCertificationOwner.SelectedValue
        Dim status As String = StatusHqsInspectionCertificationOwner.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateHqsInspectionCertificationTenant(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateHqsInspectionCertificationTenant.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 37
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeHqsInspectionCertificationTenant.SelectedValue
        Dim details As String = Request.Form("commentHqsInspectionCertificationTenant")
        Dim staffID As Integer = CaseManagerHqsInspectionCertificationTenant.SelectedValue
        Dim status As String = StatusHqsInspectionCertificationTenant.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateHudTenancyAddendum(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateHudTenancyAddendum.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 34
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeHudTenancyAddendum.SelectedValue
        Dim details As String = Request.Form("commentHudTenancyAddendum")
        Dim staffID As Integer = CaseManagerHudTenancyAddendum.SelectedValue
        Dim status As String = StatusHudTenancyAddendum.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateHudTenancyAddendumInitialUnit(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateHudTenancyAddendumInitialUnit.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 46
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeHudTenancyAddendumInitialUnit.SelectedValue
        Dim details As String = Request.Form("commentHudTenancyAddendumInitialUnit")
        Dim staffID As Integer = CaseManagerHudTenancyAddendumInitialUnit.SelectedValue
        Dim status As String = StatusHudTenancyAddendumInitialUnit.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateImportantNoticeToOwnerAndTenant(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateImportantNoticeToOwnerAndTenant.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 36
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeImportantNoticeToOwnerAndTenant.SelectedValue
        Dim details As String = Request.Form("commentImportantNoticeToOwnerAndTenant")
        Dim staffID As Integer = CaseManagerImportantNoticeToOwnerAndTenant.SelectedValue
        Dim status As String = StatusImportantNoticeToOwnerAndTenant.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateInitialHudForm50058(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateInitialHudForm50058.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 42
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeInitialHudForm50058.SelectedValue
        Dim details As String = Request.Form("commentInitialHudForm50058")
        Dim staffID As Integer = CaseManagerInitialHudForm50058.SelectedValue
        Dim status As String = StatusInitialHudForm50058.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateInitialRentCalculationSheet(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProcessInitialRentCalculationSheet.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 43
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeInitialRentCalculationSheet.SelectedValue
        Dim details As String = Request.Form("commentInitialRentCalculationSheet")
        Dim staffID As Integer = CaseManagerInitialRentCalculationSheet.SelectedValue
        Dim status As String = StatusInitialRentCalculationSheet.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateInitialRentLetter(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateInitialRentLetter.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 41
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeInitialRentLetter.SelectedValue
        Dim details As String = Request.Form("commentInitialRentLetter")
        Dim staffID As Integer = CaseManagerInitialRentLetter.SelectedValue
        Dim status As String = StatusInitialRentLetter.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateInitialUaCalculationWorksheetElite(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateInitialUaCalculationWorksheetElite.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 44
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeInitialUaCalculationWorksheetElite.SelectedValue
        Dim details As String = Request.Form("commentInitialUaCalculationWorksheetElite")
        Dim staffID As Integer = CaseManagerInitialUaCalculationWorksheetElite.SelectedValue
        Dim status As String = StatusInitialUaCalculationWorksheetElite.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateLeadBasedPaintDisclosureAndCertification(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateLeadBasedPaintDisclosureAndCertification.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 39
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeLeadBasedPaintDisclosureAndCertification.SelectedValue
        Dim details As String = Request.Form("commentLeadBasedPaintDisclosureAndCertification")
        Dim staffID As Integer = CaseManagerLeadBasedPaintDisclosureAndCertification.SelectedValue
        Dim status As String = StatusLeadBasedPaintDisclosureAndCertification.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateLease(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateLease.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 33
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeLease.SelectedValue
        Dim details As String = Request.Form("commentLease")
        Dim staffID As Integer = CaseManagerLease.SelectedValue
        Dim status As String = StatusLease.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateLeaseInitialUnit(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateLeaseInitialUnit.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 47
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeLeaseInitialUnit.SelectedValue
        Dim details As String = Request.Form("commentLeaseInitialUnit")
        Dim staffID As Integer = CaseManagerLeaseInitialUnit.SelectedValue
        Dim status As String = StatusLeaseInitialUnit.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateLeasingPacketChecklist(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateLeasingPacketChecklist.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 31
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeLeasingPacketChecklist.SelectedValue
        Dim details As String = Request.Form("commentLeasingPacketChecklist")
        Dim staffID As Integer = CaseManagerLeasingPacketChecklist.SelectedValue
        Dim status As String = StatusLeasingPacketChecklist.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateMasterLeasingChecklist(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateMasterLeasingChecklist.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 29
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeMasterLeasingChecklist.SelectedValue
        Dim details As String = Request.Form("commentMasterLeasingChecklist")
        Dim staffID As Integer = CaseManagerMasterLeasingChecklist.SelectedValue
        Dim status As String = StatusMasterLeasingChecklist.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
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

    Protected Sub CreatePortability(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProcessPortability.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const PROCESS_PORTABILITY As Integer = 16

        Dim noticeTypeID As Integer = NoticeTypePortability.SelectedValue
        Dim details As String = Request.Form("commentPortability")
        Dim staffID As Integer = CaseManagerPortability.SelectedValue
        Dim status As String = StatusPortability.SelectedValue

        InsertFileError(details, status, noticeTypeID, staffID, PROCESS_PORTABILITY, fileID, REVIEW_TYPE_ID, sessionUserID)
    End Sub

    Protected Sub CreateProcessOther(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProcessOther.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const PROCESS_OTHER As Integer = 21

        Dim noticeTypeID As Integer = NoticeTypeProcessOther.SelectedValue
        Dim details As String = Request.Form("commentProcessOther")
        Dim staffID As Integer = CaseManagerProcessOther.SelectedValue
        Dim status As String = StatusProcessOther.SelectedValue

        InsertFileError(details, status, noticeTypeID, staffID, PROCESS_OTHER, fileID, REVIEW_TYPE_ID, sessionUserID)
    End Sub

    Protected Sub CreateRfta(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateRfta.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 52
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeRfta.SelectedValue
        Dim details As String = Request.Form("commentRfta")
        Dim staffID As Integer = CaseManagerRfta.SelectedValue
        Dim status As String = StatusRfta.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateRftaInitialUnit(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateRftaInitialUnit.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 48
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeRftaInitialUnit.SelectedValue
        Dim details As String = Request.Form("commentRftaInitialUnit")
        Dim staffID As Integer = CaseManagerRftaInitialUnit.SelectedValue
        Dim status As String = StatusRftaInitialUnit.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateSecurityDepositConfirmation(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateSecurityDepositConfirmation.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 35
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeSecurityDepositConfirmation.SelectedValue
        Dim details As String = Request.Form("commentSecurityDepositConfirmation")
        Dim staffID As Integer = CaseManagerSecurityDepositConfirmation.SelectedValue
        Dim status As String = StatusSecurityDepositConfirmation.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
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

    Protected Sub CreateUaCalculationWorksheetElite(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateUaCalculationWorksheetElite.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 51
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeUaCalculationWorksheetElite.SelectedValue
        Dim details As String = Request.Form("commentUaCalculationWorksheetElite")
        Dim staffID As Integer = CaseManagerUaCalculationWorksheetElite.SelectedValue
        Dim status As String = StatusUaCalculationWorksheetElite.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
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
        Const DOCUMENT_TYPE As Integer = 32
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeUtilityAllowanceChecklist.SelectedValue
        Dim details As String = Request.Form("commentUtilityAllowanceChecklist")
        Dim staffID As Integer = CaseManagerUtilityAllowanceChecklist.SelectedValue
        Dim status As String = StatusUtilityAllowanceChecklist.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateUtilityAllowanceChecklistInitialUnit(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateUtilityAllowanceChecklistInitialUnit.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 49
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeUtilityAllowanceChecklistInitialUnit.SelectedValue
        Dim details As String = Request.Form("commentUtilityAllowanceChecklistInitialUnit")
        Dim staffID As Integer = CaseManagerUtilityAllowanceChecklistInitialUnit.SelectedValue
        Dim status As String = StatusUtilityAllowanceChecklistInitialUnit.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
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
                'Payment Standard
                CaseManagerPaymentStandard.DataBind()
                CaseManagerPaymentStandard.Items.FindByValue(housingSpecialistID).Selected = True

                'Utility Allowance
                CaseManagerUtilityAllowance.DataBind()
                CaseManagerUtilityAllowance.Items.FindByValue(housingSpecialistID).Selected = True

                'Tenant Rent
                CaseManagerTenantRent.DataBind()
                CaseManagerTenantRent.Items.FindByValue(housingSpecialistID).Selected = True

                'Portability
                CaseManagerPortability.DataBind()
                CaseManagerPortability.Items.FindByValue(housingSpecialistID).Selected = True

                'Data Entry
                CaseManagerDataEntry.DataBind()
                CaseManagerDataEntry.Items.FindByValue(housingSpecialistID).Selected = True

                'Other - Process
                CaseManagerProcessOther.DataBind()
                CaseManagerProcessOther.Items.FindByValue(housingSpecialistID).Selected = True

                'Master Leasing Checklist
                CaseManagerMasterLeasingChecklist.DataBind()
                CaseManagerMasterLeasingChecklist.Items.FindByValue(housingSpecialistID).Selected = True

                'Checklist-Leasing/Inspections
                CaseManagerChecklistLeasingInspections.DataBind()
                CaseManagerChecklistLeasingInspections.Items.FindByValue(housingSpecialistID).Selected = True

                'Leasing Packet Checklist
                CaseManagerLeasingPacketChecklist.DataBind()
                CaseManagerLeasingPacketChecklist.Items.FindByValue(housingSpecialistID).Selected = True

                'Contracts Execution Checklist
                CaseManagerContractsExecutionChecklist.DataBind()
                CaseManagerContractsExecutionChecklist.Items.FindByValue(housingSpecialistID).Selected = True

                'Utility Allowance Checklist
                CaseManagerUtilityAllowanceChecklist.DataBind()
                CaseManagerUtilityAllowanceChecklist.Items.FindByValue(housingSpecialistID).Selected = True

                'Lease
                CaseManagerLease.DataBind()
                CaseManagerLease.Items.FindByValue(housingSpecialistID).Selected = True

                'Hap Contract 
                CaseManagerHapContract.DataBind()
                CaseManagerHapContract.Items.FindByValue(housingSpecialistID).Selected = True

                'Hud Tenancy Addendum
                CaseManagerHudTenancyAddendum.DataBind()
                CaseManagerHudTenancyAddendum.Items.FindByValue(housingSpecialistID).Selected = True

                'Rfta
                CaseManagerRfta.DataBind()
                CaseManagerRfta.Items.FindByValue(housingSpecialistID).Selected = True

                'Security Deposit Confirmation
                CaseManagerSecurityDepositConfirmation.DataBind()
                CaseManagerSecurityDepositConfirmation.Items.FindByValue(housingSpecialistID).Selected = True

                'Important Notice To Owner And Tenant
                CaseManagerImportantNoticeToOwnerAndTenant.DataBind()
                CaseManagerImportantNoticeToOwnerAndTenant.Items.FindByValue(housingSpecialistID).Selected = True

                'HQS Inspection Certification - Tenant
                CaseManagerHqsInspectionCertificationTenant.DataBind()
                CaseManagerHqsInspectionCertificationTenant.Items.FindByValue(housingSpecialistID).Selected = True

                'HQS Inspection Certification - Owner
                CaseManagerHqsInspectionCertificationOwner.DataBind()
                CaseManagerHqsInspectionCertificationOwner.Items.FindByValue(housingSpecialistID).Selected = True

                'Lead Based Paint Disclosure And Certification
                CaseManagerLeadBasedPaintDisclosureAndCertification.DataBind()
                CaseManagerLeadBasedPaintDisclosureAndCertification.Items.FindByValue(housingSpecialistID).Selected = True

                'Housing Search Log (If Applicable)
                CaseManagerHousingSearchLogIfApplicable.DataBind()
                CaseManagerHousingSearchLogIfApplicable.Items.FindByValue(housingSpecialistID).Selected = True

                'Initial Rent Letter
                CaseManagerInitialRentLetter.DataBind()
                CaseManagerInitialRentLetter.Items.FindByValue(housingSpecialistID).Selected = True

                'Initial Hud Form 50058
                CaseManagerInitialHudForm50058.DataBind()
                CaseManagerInitialHudForm50058.Items.FindByValue(housingSpecialistID).Selected = True

                'Initial Rent Calculation Sheet
                CaseManagerInitialRentCalculationSheet.DataBind()
                CaseManagerInitialRentCalculationSheet.Items.FindByValue(housingSpecialistID).Selected = True

                'Initial Ua Calculation Worksheet - Elite
                CaseManagerInitialUaCalculationWorksheetElite.DataBind()
                CaseManagerInitialUaCalculationWorksheetElite.Items.FindByValue(housingSpecialistID).Selected = True

                'Hap Contract (Initial Unit)
                CaseManagerHapContractInitialUnit.DataBind()
                CaseManagerHapContractInitialUnit.Items.FindByValue(housingSpecialistID).Selected = True

                'Hud Tenancy Addendum (Initial Unit)
                CaseManagerHudTenancyAddendumInitialUnit.DataBind()
                CaseManagerHudTenancyAddendumInitialUnit.Items.FindByValue(housingSpecialistID).Selected = True

                'Lease (Initial Unit)
                CaseManagerLeaseInitialUnit.DataBind()
                CaseManagerLeaseInitialUnit.Items.FindByValue(housingSpecialistID).Selected = True

                'Rfta (Initial Unit)
                CaseManagerRftaInitialUnit.DataBind()
                CaseManagerRftaInitialUnit.Items.FindByValue(housingSpecialistID).Selected = True

                'Utility Allowance Checklist (Initial Unit)
                CaseManagerUtilityAllowanceChecklistInitialUnit.DataBind()
                CaseManagerUtilityAllowanceChecklistInitialUnit.Items.FindByValue(housingSpecialistID).Selected = True

                'Other - Document
                CaseManagerDocumentOther.DataBind()
                CaseManagerDocumentOther.Items.FindByValue(housingSpecialistID).Selected = True

                'HAP Processing Action Form
                CaseManagerHapProcessingActionForm.DataBind()
                CaseManagerHapProcessingActionForm.Items.FindByValue(housingSpecialistID).Selected = True

                'UA Calculation Worksheet - Elite
                CaseManagerUaCalculationWorksheetElite.DataBind()
                CaseManagerUaCalculationWorksheetElite.Items.FindByValue(housingSpecialistID).Selected = True
            End If
        End If
        conn.Close()
    End Sub

    Public Sub DisplayDropDownlistNotice()
        If Not IsPostBack Then
            'Payment Standard
            NoticeTypePaymentStandard.AppendDataBoundItems = True
            NoticeTypePaymentStandard.Items.Insert(0, New ListItem("Notice", "2"))

            'Utility Allowance
            NoticeTypeUtilityAllowance.AppendDataBoundItems = True
            NoticeTypeUtilityAllowance.Items.Insert(0, New ListItem("Notice", "2"))

            'Tenant Rent
            NoticeTypeTenantRent.AppendDataBoundItems = True
            NoticeTypeTenantRent.Items.Insert(0, New ListItem("Notice", "2"))

            'Portability
            NoticeTypePortability.AppendDataBoundItems = True
            NoticeTypePortability.Items.Insert(0, New ListItem("Notice", "2"))

            'Data Entry
            NoticeTypeDataEntry.AppendDataBoundItems = True
            NoticeTypeDataEntry.Items.Insert(0, New ListItem("Notice", "2"))

            'Other - Process
            NoticeTypeProcessOther.AppendDataBoundItems = True
            NoticeTypeProcessOther.Items.Insert(0, New ListItem("Notice", "2"))

            'Master Leasing Checklist
            NoticeTypeMasterLeasingChecklist.AppendDataBoundItems = True
            NoticeTypeMasterLeasingChecklist.Items.Insert(0, New ListItem("Notice", "2"))

            'Checklist-Leasing/Inspections
            NoticeTypeChecklistLeasingInspections.AppendDataBoundItems = True
            NoticeTypeChecklistLeasingInspections.Items.Insert(0, New ListItem("Notice", "2"))

            'Leasing Packet Checklist
            NoticeTypeLeasingPacketChecklist.AppendDataBoundItems = True
            NoticeTypeLeasingPacketChecklist.Items.Insert(0, New ListItem("Notice", "2"))

            'Contracts Execution Checklist
            NoticeTypeContractsExecutionChecklist.AppendDataBoundItems = True
            NoticeTypeContractsExecutionChecklist.Items.Insert(0, New ListItem("Notice", "2"))

            'Utility Allowance Checklist
            NoticeTypeUtilityAllowanceChecklist.AppendDataBoundItems = True
            NoticeTypeUtilityAllowanceChecklist.Items.Insert(0, New ListItem("Notice", "2"))

            'Leasing
            NoticeTypeLease.AppendDataBoundItems = True
            NoticeTypeLease.Items.Insert(0, New ListItem("Notice", "2"))

            'Hap Contract 
            NoticeTypeHapContract.AppendDataBoundItems = True
            NoticeTypeHapContract.Items.Insert(0, New ListItem("Notice", "2"))

            'Hud Tenancy Addendum
            NoticeTypeHudTenancyAddendum.AppendDataBoundItems = True
            NoticeTypeHudTenancyAddendum.Items.Insert(0, New ListItem("Notice", "2"))

            'Rfta
            NoticeTypeRfta.AppendDataBoundItems = True
            NoticeTypeRfta.Items.Insert(0, New ListItem("Notice", "2"))

            'Security Deposit Confirmation
            NoticeTypeSecurityDepositConfirmation.AppendDataBoundItems = True
            NoticeTypeSecurityDepositConfirmation.Items.Insert(0, New ListItem("Notice", "2"))

            'Important Notice To Owner And Tenant
            NoticeTypeImportantNoticeToOwnerAndTenant.AppendDataBoundItems = True
            NoticeTypeImportantNoticeToOwnerAndTenant.Items.Insert(0, New ListItem("Notice", "2"))

            'HQS Inspection Certification - Tenant
            NoticeTypeHqsInspectionCertificationTenant.AppendDataBoundItems = True
            NoticeTypeHqsInspectionCertificationTenant.Items.Insert(0, New ListItem("Notice", "2"))

            'HQS Inspection Certification - Owner
            NoticeTypeHqsInspectionCertificationOwner.AppendDataBoundItems = True
            NoticeTypeHqsInspectionCertificationOwner.Items.Insert(0, New ListItem("Notice", "2"))

            'Lead Based Paint Disclosure And Certification
            NoticeTypeLeadBasedPaintDisclosureAndCertification.AppendDataBoundItems = True
            NoticeTypeLeadBasedPaintDisclosureAndCertification.Items.Insert(0, New ListItem("Notice", "2"))

            'Housing Search Log (If Applicable)
            NoticeTypeHousingSearchLogIfApplicable.AppendDataBoundItems = True
            NoticeTypeHousingSearchLogIfApplicable.Items.Insert(0, New ListItem("Notice", "2"))

            'Initial Rent Letter
            NoticeTypeInitialRentLetter.AppendDataBoundItems = True
            NoticeTypeInitialRentLetter.Items.Insert(0, New ListItem("Notice", "2"))

            'Initial Hud Form 50058
            NoticeTypeInitialHudForm50058.AppendDataBoundItems = True
            NoticeTypeInitialHudForm50058.Items.Insert(0, New ListItem("Notice", "2"))

            'Initial Rent Calculation Sheet
            NoticeTypeInitialRentCalculationSheet.AppendDataBoundItems = True
            NoticeTypeInitialRentCalculationSheet.Items.Insert(0, New ListItem("Notice", "2"))

            'Initial Ua Calculation Worksheet - Elite
            NoticeTypeInitialUaCalculationWorksheetElite.AppendDataBoundItems = True
            NoticeTypeInitialUaCalculationWorksheetElite.Items.Insert(0, New ListItem("Notice", "2"))

            'Hap Contract (Initial Unit)
            NoticeTypeHapContractInitialUnit.AppendDataBoundItems = True
            NoticeTypeHapContractInitialUnit.Items.Insert(0, New ListItem("Notice", "2"))

            'Hud Tenancy Addendum (Initial Unit)
            NoticeTypeHudTenancyAddendumInitialUnit.AppendDataBoundItems = True
            NoticeTypeHudTenancyAddendumInitialUnit.Items.Insert(0, New ListItem("Notice", "2"))

            'Lease (Initial Unit)
            NoticeTypeLeaseInitialUnit.AppendDataBoundItems = True
            NoticeTypeLeaseInitialUnit.Items.Insert(0, New ListItem("Notice", "2"))

            'Rfta (Initial Unit)
            NoticeTypeRftaInitialUnit.AppendDataBoundItems = True
            NoticeTypeRftaInitialUnit.Items.Insert(0, New ListItem("Notice", "2"))

            'Utility Allowance Checklist (Initial Unit)
            NoticeTypeUtilityAllowanceChecklistInitialUnit.AppendDataBoundItems = True
            NoticeTypeUtilityAllowanceChecklistInitialUnit.Items.Insert(0, New ListItem("Notice", "2"))

            'Other - Document
            NoticeTypeDocumentOther.AppendDataBoundItems = True
            NoticeTypeDocumentOther.Items.Insert(0, New ListItem("Notice", "2"))

            'HAP Processing Action Form
            NoticeTypeHapProcessingActionForm.AppendDataBoundItems = True
            NoticeTypeHapProcessingActionForm.Items.Insert(0, New ListItem("Notice", "2"))

            'UA Calculation Worksheet - Elite
            NoticeTypeUaCalculationWorksheetElite.AppendDataBoundItems = True
            NoticeTypeUaCalculationWorksheetElite.Items.Insert(0, New ListItem("Notice", "2"))
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
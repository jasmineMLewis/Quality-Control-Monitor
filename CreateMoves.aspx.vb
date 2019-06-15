Imports System.Data.SqlClient
Imports System.Web.Configuration

Public Class CreateMoves
    Inherits System.Web.UI.Page
    Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)
    Const REVIEW_TYPE_ID As Integer = 4
    Const PROCESS_DOCUMENT_TYPE As Integer = 18

#Region "For Error Checkboxes (Processing)"
    Const PROCESS_VERTIFICATION As Integer = 1
    Const PROCESS_CALCULATION As Integer = 2
    Const PROCESS_PAYMENT_STANDARD As Integer = 3
    Const PROCESS_UTILITY_ALLOWANCE As Integer = 4
    Const PROCESS_TENANT_RENT As Integer = 5
    Const PROCESS_OCCUPANCY_STANDARD As Integer = 6
    Const PROCESS_MOVES As Integer = 9
    Const PROCESS_CHANGE_IN_FAMILY_COMPOSITION As Integer = 10
    Const PROCESS_LEASING As Integer = 12
    Const PROCESS_DATA_ENTRY As Integer = 13
    Const PROCESS_OTHER As Integer = 21
#End Region

#Region "For Error Checkboxes (Documents)"
    Const DOCUMENT_HUD_INSPECTION_CHECKLIST_FORM_HUD_52580 As Integer = 69
    Const DOCUMENT_HANO_INSPECTION_REPORT As Integer = 70
    Const DOCUMENT_INSPECTION_OUTCOME_LETTER As Integer = 71
    Const DOCUMENT_AMENITIES_REPORT As Integer = 1
    Const DOCUMENT_REASONABLE_RENT_DETERMINATION_CERTIFICATION As Integer = 7
    Const DOCUMENT_REASONABLE_RENT_COMPARABLES As Integer = 2
    Const DOCUMENT_RENT_BURDEN_WORKSHEET As Integer = 3
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
    Const DOCUMENT_SIGNED_ORIGINAL_VOUCHER As Integer = 55
    Const DOCUMENT_OTHER As Integer = 6
    Const DOCUMENT_HAP_PROCESSING_ACTION_FORM As Integer = 50
    Const DOCUMENT_RENT_LETTER_TENANT As Integer = 58
    Const DOCUMENT_RENT_LETTER_OWNER As Integer = 59
    Const DOCUMENT_HUD_FORM_50058 As Integer = 60
    Const DOCUMENT_RENT_CALCULATION_SHEET As Integer = 61
    Const DOCUMENT_UA_CALCULATION_WORKSHEET_ELITE As Integer = 51
    Const DOCUMENT_LETTER_OF_GOOD_STANDING As Integer = 73
    Const DOCUMENT_NOTICE_TO_VACATE_NOTICE_OF_LEASE_TERMINATION As Integer = 74
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim fileID As Integer = Request.QueryString("FileID")
        DisplayDropDownlistCaseManager(fileID)
        DisplayDropDownlistNotice()
    End Sub

    Public Function AssignSeededReviewDocuments(ByVal data As Dictionary(Of Integer, Boolean)) As Dictionary(Of Integer, Boolean)
        Dim documents As New Dictionary(Of Integer, Boolean)

        'Leasing Documents 
        If Not Request.Form("documentHudInspectionChecklistFormHud52580") Is Nothing Or Not Request.Form("documentHudInspectionChecklistFormHud52580") = "" Then
            data(DOCUMENT_HUD_INSPECTION_CHECKLIST_FORM_HUD_52580) = True
        End If

        If Not Request.Form("documentHanoInspectionReport") Is Nothing Or Not Request.Form("documentHanoInspectionReport") = "" Then
            data(DOCUMENT_HANO_INSPECTION_REPORT) = True
        End If

        If Not Request.Form("documentInspectionOutcomeLetter") Is Nothing Or Not Request.Form("documentInspectionOutcomeLetter") = "" Then
            data(DOCUMENT_AMENITIES_REPORT) = True
        End If

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
        If Not Request.Form("documentSignedOriginalVoucher") Is Nothing Or Not Request.Form("documentSignedOriginalVoucher") = "" Then
            data(DOCUMENT_SIGNED_ORIGINAL_VOUCHER) = True
        End If

        'Notes / Portability Billing / Compliance
        If Not Request.Form("documentOther") Is Nothing Or Not Request.Form("documentOther") = "" Then
            data(DOCUMENT_OTHER) = True
        End If

        'Recertification Documents
        If Not Request.Form("documentHapProcessingActionForm") Is Nothing Or Not Request.Form("documentHapProcessingActionForm") = "" Then
            data(DOCUMENT_HAP_PROCESSING_ACTION_FORM) = True
        End If

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

        If Not Request.Form("documentLetterOfGoodStanding") Is Nothing Or Not Request.Form("documentLetterOfGoodStanding") = "" Then
            data(DOCUMENT_LETTER_OF_GOOD_STANDING) = True
        End If

        If Not Request.Form("documentNoticeToVacateNoticeOfLeaseTermination") Is Nothing Or Not Request.Form("documentNoticeToVacateNoticeOfLeaseTermination") = "" Then
            data(DOCUMENT_NOTICE_TO_VACATE_NOTICE_OF_LEASE_TERMINATION) = True
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

        If Not Request.Form("processMoves") Is Nothing Or Not Request.Form("processMoves") = "" Then
            data(PROCESS_MOVES) = True
        End If

        If Not Request.Form("processChangeInFamilyComposition") Is Nothing Or Not Request.Form("processChangeInFamilyComposition") = "" Then
            data(PROCESS_CHANGE_IN_FAMILY_COMPOSITION) = True
        End If

        If Not Request.Form("processLeasing") Is Nothing Or Not Request.Form("processLeasing") = "" Then
            data(PROCESS_LEASING) = True
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

    Protected Sub CreateAmenitiesReport(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateAmenitiesReport.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 1
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeAmenitiesReport.SelectedValue
        Dim details As String = Request.Form("commentAmenitiesReport")
        Dim staffID As Integer = CaseManagerAmenitiesReport.SelectedValue
        Dim status As String = StatusAmenitiesReport.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
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

    Protected Sub CreateHanoInspectionReport(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateHanoInspectionReport.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 70
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeHanoInspectionReport.SelectedValue
        Dim details As String = Request.Form("commentHanoInspectionReport")
        Dim staffID As Integer = CaseManagerHanoInspectionReport.SelectedValue
        Dim status As String = StatusHanoInspectionReport.SelectedValue

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

    Protected Sub CreateHudForm50058(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateHudForm50058.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 60
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeHudForm50058.SelectedValue
        Dim details As String = Request.Form("commentHudForm50058")
        Dim staffID As Integer = CaseManagerHudForm50058.SelectedValue
        Dim status As String = StatusHudForm50058.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateHudInspectionChecklistFormHud52580(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateHudInspectionChecklistFormHud52580.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 69
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeHudInspectionChecklistFormHud52580.SelectedValue
        Dim details As String = Request.Form("commentHudInspectionChecklistFormHud52580")
        Dim staffID As Integer = CaseManagerHudInspectionChecklistFormHud52580.SelectedValue
        Dim status As String = StatusHudInspectionChecklistFormHud52580.SelectedValue

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

    Protected Sub CreateInspectionOutcomeLetter(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateInspectionOutcomeLetter.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 71
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeInspectionOutcomeLetter.SelectedValue
        Dim details As String = Request.Form("commentInspectionOutcomeLetter")
        Dim staffID As Integer = CaseManagerInspectionOutcomeLetter.SelectedValue
        Dim status As String = StatusInspectionOutcomeLetter.SelectedValue

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

    Protected Sub CreateLeasing(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProcessLeasing.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const PROCESS_LEASING As Integer = 12

        Dim noticeTypeID As Integer = NoticeTypeLeasing.SelectedValue
        Dim details As String = Request.Form("commentLeasing")
        Dim staffID As Integer = CaseManagerLeasing.SelectedValue
        Dim status As String = StatusLeasing.SelectedValue

        InsertFileError(details, status, noticeTypeID, staffID, PROCESS_LEASING, fileID, REVIEW_TYPE_ID, sessionUserID)
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

    Protected Sub CreateLetterOfGoodStanding(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateLetterOfGoodStanding.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 73
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeLetterOfGoodStanding.SelectedValue
        Dim details As String = Request.Form("commentLetterOfGoodStanding")
        Dim staffID As Integer = CaseManagerLetterOfGoodStanding.SelectedValue
        Dim status As String = StatusLetterOfGoodStanding.SelectedValue

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

    Protected Sub CreateMoves(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProcessMoves.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const PROCESS_LEASING As Integer = 9

        Dim noticeTypeID As Integer = NoticeTypeMoves.SelectedValue
        Dim details As String = Request.Form("commentMoves")
        Dim staffID As Integer = CaseManagerMoves.SelectedValue
        Dim status As String = StatusMoves.SelectedValue

        InsertFileError(details, status, noticeTypeID, staffID, PROCESS_LEASING, fileID, REVIEW_TYPE_ID, sessionUserID)
    End Sub

    Protected Sub CreateNoticeToVacateNoticeOfLeaseTermination(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateNoticeToVacateNoticeOfLeaseTermination.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 74
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeNoticeToVacateNoticeOfLeaseTermination.SelectedValue
        Dim details As String = Request.Form("commentNoticeToVacateNoticeOfLeaseTermination")
        Dim staffID As Integer = CaseManagerNoticeToVacateNoticeOfLeaseTermination.SelectedValue
        Dim status As String = StatusNoticeToVacateNoticeOfLeaseTermination.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateOccupancyStandard(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProcessOccupancyStandard.Click
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

    Protected Sub CreateReasonableRentComparables(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateReasonableRentComparables.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 2
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeReasonableRentComparables.SelectedValue
        Dim details As String = Request.Form("commentReasonableRentComparables")
        Dim staffID As Integer = CaseManagerReasonableRentComparables.SelectedValue
        Dim status As String = StatusReasonableRentComparables.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateReasonableRentDeterminationCertification(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateReasonableRentDeterminationCertification.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 7
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeReasonableRentDeterminationCertification.SelectedValue
        Dim details As String = Request.Form("commentReasonableRentDeterminationCertification")
        Dim staffID As Integer = CaseManagerReasonableRentDeterminationCertification.SelectedValue
        Dim status As String = StatusReasonableRentDeterminationCertification.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateRentBurdenWorksheet(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateRentBurdenWorksheet.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 3
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeRentBurdenWorksheet.SelectedValue
        Dim details As String = Request.Form("commentRentBurdenWorksheet")
        Dim staffID As Integer = CaseManagerRentBurdenWorksheet.SelectedValue
        Dim status As String = StatusRentBurdenWorksheet.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateRentCalculationSheet(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateRentCalculationSheet.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 61
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeRentCalculationSheet.SelectedValue
        Dim details As String = Request.Form("commentRentCalculationSheet")
        Dim staffID As Integer = CaseManagerRentCalculationSheet.SelectedValue
        Dim status As String = StatusRentCalculationSheet.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateRentLetterOwner(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateRentLetterOwner.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 59
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeRentLetterOwner.SelectedValue
        Dim details As String = Request.Form("commentRentLetterOwner")
        Dim staffID As Integer = CaseManagerRentLetterOwner.SelectedValue
        Dim status As String = StatusRentLetterOwner.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateRentLetterTenant(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateRentLetterTenant.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 58
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeRentLetterTenant.SelectedValue
        Dim details As String = Request.Form("commentRentLetterTenant")
        Dim staffID As Integer = CaseManagerRentLetterTenant.SelectedValue
        Dim status As String = StatusRentLetterTenant.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
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

    Protected Sub CreateSignedOriginalVoucher(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateSignedOriginalVoucher.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 55
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeSignedOriginalVoucher.SelectedValue
        Dim details As String = Request.Form("commentSignedOriginalVoucher")
        Dim staffID As Integer = CaseManagerSignedOriginalVoucher.SelectedValue
        Dim status As String = StatusSignedOriginalVoucher.SelectedValue

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

                'Moves 
                CaseManagerMoves.DataBind()
                CaseManagerMoves.Items.FindByValue(caseManagerID).Selected = True

                'Change in Family Composition
                CaseManagerChangeInFamilyComposition.DataBind()
                CaseManagerChangeInFamilyComposition.Items.FindByValue(caseManagerID).Selected = True

                'Leasing
                CaseManagerLeasing.DataBind()
                CaseManagerLeasing.Items.FindByValue(caseManagerID).Selected = True

                'Data Entry
                CaseManagerDataEntry.DataBind()
                CaseManagerDataEntry.Items.FindByValue(caseManagerID).Selected = True

                'Other - Process
                CaseManagerProcessOther.DataBind()
                CaseManagerProcessOther.Items.FindByValue(caseManagerID).Selected = True

                'HUD Inspection Checklist (Form HUD-52580)
                CaseManagerHudInspectionChecklistFormHud52580.DataBind()
                CaseManagerHudInspectionChecklistFormHud52580.Items.FindByValue(caseManagerID).Selected = True

                'HANO Inspection Report
                CaseManagerHanoInspectionReport.DataBind()
                CaseManagerHanoInspectionReport.Items.FindByValue(caseManagerID).Selected = True

                'Inspection Outcome Letter
                CaseManagerInspectionOutcomeLetter.DataBind()
                CaseManagerInspectionOutcomeLetter.Items.FindByValue(caseManagerID).Selected = True

                'Amenities Report
                CaseManagerAmenitiesReport.DataBind()
                CaseManagerAmenitiesReport.Items.FindByValue(caseManagerID).Selected = True

                'Reasonable Rent Determination Certification
                CaseManagerReasonableRentDeterminationCertification.DataBind()
                CaseManagerReasonableRentDeterminationCertification.Items.FindByValue(caseManagerID).Selected = True

                'Reasonable Rent Comparables
                CaseManagerReasonableRentComparables.DataBind()
                CaseManagerReasonableRentComparables.Items.FindByValue(caseManagerID).Selected = True

                'Rent Burden Worksheet
                CaseManagerRentBurdenWorksheet.DataBind()
                CaseManagerRentBurdenWorksheet.Items.FindByValue(caseManagerID).Selected = True

                'Master Leasing Checklist
                CaseManagerMasterLeasingChecklist.DataBind()
                CaseManagerMasterLeasingChecklist.Items.FindByValue(caseManagerID).Selected = True

                'Checklist-Leasing/Inspections
                CaseManagerChecklistLeasingInspections.DataBind()
                CaseManagerChecklistLeasingInspections.Items.FindByValue(caseManagerID).Selected = True

                'Leasing Packet Checklist
                CaseManagerLeasingPacketChecklist.DataBind()
                CaseManagerLeasingPacketChecklist.Items.FindByValue(caseManagerID).Selected = True

                'Contracts Execution Checklist
                CaseManagerContractsExecutionChecklist.DataBind()
                CaseManagerContractsExecutionChecklist.Items.FindByValue(caseManagerID).Selected = True

                'Utility Allowance Checklist
                CaseManagerUtilityAllowanceChecklist.DataBind()
                CaseManagerUtilityAllowanceChecklist.Items.FindByValue(caseManagerID).Selected = True

                'Lease
                CaseManagerLease.DataBind()
                CaseManagerLease.Items.FindByValue(caseManagerID).Selected = True

                'Hap Contract 
                CaseManagerHapContract.DataBind()
                CaseManagerHapContract.Items.FindByValue(caseManagerID).Selected = True

                'Hud Tenancy Addendum
                CaseManagerHudTenancyAddendum.DataBind()
                CaseManagerHudTenancyAddendum.Items.FindByValue(caseManagerID).Selected = True

                'Rfta
                CaseManagerRfta.DataBind()
                CaseManagerRfta.Items.FindByValue(caseManagerID).Selected = True

                'Security Deposit Confirmation
                CaseManagerSecurityDepositConfirmation.DataBind()
                CaseManagerSecurityDepositConfirmation.Items.FindByValue(caseManagerID).Selected = True

                'Important Notice To Owner And Tenant
                CaseManagerImportantNoticeToOwnerAndTenant.DataBind()
                CaseManagerImportantNoticeToOwnerAndTenant.Items.FindByValue(caseManagerID).Selected = True

                'HQS Inspection Certification - Tenant
                CaseManagerHqsInspectionCertificationTenant.DataBind()
                CaseManagerHqsInspectionCertificationTenant.Items.FindByValue(caseManagerID).Selected = True

                'HQS Inspection Certification - Owner
                CaseManagerHqsInspectionCertificationOwner.DataBind()
                CaseManagerHqsInspectionCertificationOwner.Items.FindByValue(caseManagerID).Selected = True

                'Lead Based Paint Disclosure And Certification
                CaseManagerLeadBasedPaintDisclosureAndCertification.DataBind()
                CaseManagerLeadBasedPaintDisclosureAndCertification.Items.FindByValue(caseManagerID).Selected = True

                'Housing Search Log (If Applicable)
                CaseManagerHousingSearchLogIfApplicable.DataBind()
                CaseManagerHousingSearchLogIfApplicable.Items.FindByValue(caseManagerID).Selected = True

                'Signed Original Voucher
                CaseManagerSignedOriginalVoucher.DataBind()
                CaseManagerSignedOriginalVoucher.Items.FindByValue(caseManagerID).Selected = True

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

                'Letter of Good Standing
                CaseManagerLetterOfGoodStanding.DataBind()
                CaseManagerLetterOfGoodStanding.Items.FindByValue(caseManagerID).Selected = True

                'Notice to Vacate/Notice of Lease Termination
                CaseManagerNoticeToVacateNoticeOfLeaseTermination.DataBind()
                CaseManagerNoticeToVacateNoticeOfLeaseTermination.Items.FindByValue(caseManagerID).Selected = True
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

            'Moves
            NoticeTypeMoves.AppendDataBoundItems = True
            NoticeTypeMoves.Items.Insert(0, New ListItem("Notice", "2"))

            'Change in Family Composition
            NoticeTypeChangeInFamilyComposition.AppendDataBoundItems = True
            NoticeTypeChangeInFamilyComposition.Items.Insert(0, New ListItem("Notice", "2"))

            'Leasing
            NoticeTypeLeasing.AppendDataBoundItems = True
            NoticeTypeLeasing.Items.Insert(0, New ListItem("Notice", "2"))

            'Data Entry
            NoticeTypeDataEntry.AppendDataBoundItems = True
            NoticeTypeDataEntry.Items.Insert(0, New ListItem("Notice", "2"))

            'Other - Process
            NoticeTypeProcessOther.AppendDataBoundItems = True
            NoticeTypeProcessOther.Items.Insert(0, New ListItem("Notice", "2"))

            'HUD Inspection Checklist (Form HUD-52580)
            NoticeTypeHudInspectionChecklistFormHud52580.AppendDataBoundItems = True
            NoticeTypeHudInspectionChecklistFormHud52580.Items.Insert(0, New ListItem("Notice", "2"))

            'HANO Inspection Report
            NoticeTypeHanoInspectionReport.AppendDataBoundItems = True
            NoticeTypeHanoInspectionReport.Items.Insert(0, New ListItem("Notice", "2"))

            'Inspection Outcome Letter
            NoticeTypeInspectionOutcomeLetter.AppendDataBoundItems = True
            NoticeTypeInspectionOutcomeLetter.Items.Insert(0, New ListItem("Notice", "2"))

            'Amenities Report
            NoticeTypeAmenitiesReport.AppendDataBoundItems = True
            NoticeTypeAmenitiesReport.Items.Insert(0, New ListItem("Notice", "2"))

            'Reasonable Rent Determination Certification
            NoticeTypeReasonableRentDeterminationCertification.AppendDataBoundItems = True
            NoticeTypeReasonableRentDeterminationCertification.Items.Insert(0, New ListItem("Notice", "2"))

            'Reasonable Rent Comparables
            NoticeTypeReasonableRentComparables.AppendDataBoundItems = True
            NoticeTypeReasonableRentComparables.Items.Insert(0, New ListItem("Notice", "2"))

            'Rent Burden Worksheet
            NoticeTypeRentBurdenWorksheet.AppendDataBoundItems = True
            NoticeTypeRentBurdenWorksheet.Items.Insert(0, New ListItem("Notice", "2"))

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

            'Lease
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

            'Signed Original Voucher
            NoticeTypeSignedOriginalVoucher.AppendDataBoundItems = True
            NoticeTypeSignedOriginalVoucher.Items.Insert(0, New ListItem("Notice", "2"))

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

            'Letter of Good Standing
            NoticeTypeLetterOfGoodStanding.AppendDataBoundItems = True
            NoticeTypeLetterOfGoodStanding.Items.Insert(0, New ListItem("Notice", "2"))

            'Notice to Vacate/Notice of Lease Termination
            NoticeTypeNoticeToVacateNoticeOfLeaseTermination.AppendDataBoundItems = True
            NoticeTypeNoticeToVacateNoticeOfLeaseTermination.Items.Insert(0, New ListItem("Notice", "2"))
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
Imports System.Data.SqlClient
Imports System.Web.Configuration

Public Class CreateAnnualReexamination
    Inherits System.Web.UI.Page
    Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)
    Const REVIEW_TYPE_ID As Integer = 1
    Const PROCESS_DOCUMENT_TYPE As Integer = 18

#Region "For Error Checkboxes (Processing)"
    Const PROCESS_VERTIFICATION As Integer = 1
    Const PROCESS_CALCULATION As Integer = 2
    Const PROCESS_PAYMENT_STANDARD As Integer = 3
    Const PROCESS_UTILITY_ALLOWANCE As Integer = 4
    Const PROCESS_TENANT_RENT As Integer = 5
    Const PROCESS_OCCUPANCY_STANDARD As Integer = 6
    Const PROCESS_ANNUAL_REEXAMINATION As Integer = 7
    Const PROCESS_CHANGE_IN_FAMILY_COMPOSITION As Integer = 10
    Const PROCESS_DATA_ENTRY As Integer = 13
    Const PROCESS_OTHER As Integer = 21
#End Region

#Region "For Error Checkboxes (Documents"
    Const DOCUMENT_UTILITY_ALLOWANCE_CHECKLIST As Integer = 32
    Const DOCUMENT_LEASE As Integer = 33
    Const DOCUMENT_HAP_CONTRACT As Integer = 53
    Const DOCUMENT_HUD_TENANCY_ADDENDUM As Integer = 34
    Const DOCUMENT_MASTER_FAMILY_DOCUMENTS_CHECKLIST As Integer = 8
    Const DOCUMENT_VALID_PHOTO_IDENTIFICATION As Integer = 10
    Const DOCUMENT_PROOF_OF_SOCIAL_SECURITY_NUMBER As Integer = 11
    Const DOCUMENT_PROOF_OF_BIRTH_DATE As Integer = 12
    Const DOCUMENT_PROOF_OF_NAME_CHANGE_IF_APPLICABLE As Integer = 13
    Const DOCUMENT_PROOF_OF_ELIGIBLE_IMMIGRATION_STATUS As Integer = 14
    Const DOCUMENT_DECLARATION_OF_CITIZENSHIP_OR_ELIGIBLE_IMMIGRATION_STATUS As Integer = 54
    Const DOCUMENT_DEBTS_OWED_TO_PHA_AND_TERMINATIONS_HUD_52675 As Integer = 20
    Const DOCUMENT_HUD_SUPPLEMENT_SHEET_HUD_92006 As Integer = 21
    Const DOCUMENT_VAWA_CLIENT_NOTICE As Integer = 22
    Const DOCUMENT_SIGNED_ORIGINAL_VOUCHER As Integer = 55
    Const DOCUMENT_CRIMINAL_BACKGROUND_SCREENING_DETERMINATION As Integer = 65
    Const DOCUMENT_CRIMINAL_BACKGROUND_SCREENING_REQUEST As Integer = 66
    Const DOCUMENT_NOTES As Integer = 56
    Const DOCUMENT_OTHER As Integer = 6
    Const DOCUMENT_EIV_INCOME_REPORT As Integer = 63
    Const DOCUMENT_UTILITY_BILL_FOR_TENANT_PAID_UTILITIES As Integer = 64
    Const DOCUMENT_AUTHORIZATION_FOR_RELEASE_OF_INFORMATION_PRIVACY_ACT_HUD_9886 As Integer = 27
    Const DOCUMENT_HANO_AUTHORIZATION_FOR_RELEASE_OF_INFORMATION As Integer = 28
    Const DOCUMENT_FAMILY_OBLIGATIONS As Integer = 67
    Const DOCUMENT_RECERTIFICATION_APPOINTMENT_LETTER As Integer = 68
    Const DOCUMENT_RECERTIFICATION_CHECKLIST As Integer = 57
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

        If Not Request.Form("documentLease") Is Nothing Or Not Request.Form("documentLease") = "" Then
            data(DOCUMENT_LEASE) = True
        End If

        If Not Request.Form("documentHapContract") Is Nothing Or Not Request.Form("documentHapContract") = "" Then
            data(DOCUMENT_HAP_CONTRACT) = True
        End If

        If Not Request.Form("documentHudTenancyAddendum") Is Nothing Or Not Request.Form("documentHudTenancyAddendum") = "" Then
            data(DOCUMENT_HUD_TENANCY_ADDENDUM) = True
        End If

        'Master Documents
        If Not Request.Form("documentMasterFamilyDocumentsChecklist") Is Nothing Or Not Request.Form("documentMasterFamilyDocumentsChecklist") = "" Then
            data(DOCUMENT_MASTER_FAMILY_DOCUMENTS_CHECKLIST) = True
        End If

        If Not Request.Form("documentValidPhotoIdentification") Is Nothing Or Not Request.Form("documentValidPhotoIdentification") = "" Then
            data(DOCUMENT_VALID_PHOTO_IDENTIFICATION) = True
        End If

        If Not Request.Form("documentProofOfSocialSecurityNumber") Is Nothing Or Not Request.Form("documentProofOfSocialSecurityNumber") = "" Then
            data(DOCUMENT_PROOF_OF_SOCIAL_SECURITY_NUMBER) = True
        End If

        If Not Request.Form("documentProofOfNameChangeIfApplicable") Is Nothing Or Not Request.Form("documentProofOfNameChangeIfApplicable") = "" Then
            data(DOCUMENT_PROOF_OF_NAME_CHANGE_IF_APPLICABLE) = True
        End If

        If Not Request.Form("documentProofOfEligibleImmigrationStatus") Is Nothing Or Not Request.Form("documentProofOfEligibleImmigrationStatus") = "" Then
            data(DOCUMENT_PROOF_OF_ELIGIBLE_IMMIGRATION_STATUS) = True
        End If

        If Not Request.Form("documentDeclarationOfCitizenshipOrEligibleImmigrationStatus") Is Nothing Or Not Request.Form("documentDeclarationOfCitizenshipOrEligibleImmigrationStatus") = "" Then
            data(DOCUMENT_DECLARATION_OF_CITIZENSHIP_OR_ELIGIBLE_IMMIGRATION_STATUS) = True
        End If

        If Not Request.Form("documentDebtsOwedToPhaAndTerminationsHud52675") Is Nothing Or Not Request.Form("documentDebtsOwedToPhaAndTerminationsHud52675") = "" Then
            data(DOCUMENT_DEBTS_OWED_TO_PHA_AND_TERMINATIONS_HUD_52675) = True
        End If

        If Not Request.Form("documentHudSupplementSheetHud92006") Is Nothing Or Not Request.Form("documentHudSupplementSheetHud92006") = "" Then
            data(DOCUMENT_HUD_SUPPLEMENT_SHEET_HUD_92006) = True
        End If

        If Not Request.Form("documentVawaClientNotice") Is Nothing Or Not Request.Form("documentVawaClientNotice") = "" Then
            data(DOCUMENT_VAWA_CLIENT_NOTICE) = True
        End If

        If Not Request.Form("documentSignedOriginalVoucher") Is Nothing Or Not Request.Form("documentSignedOriginalVoucher") = "" Then
            data(DOCUMENT_SIGNED_ORIGINAL_VOUCHER) = True
        End If

        If Not Request.Form("documentCriminalBackgroundScreeningDetermination") Is Nothing Or Not Request.Form("documentCriminalBackgroundScreeningDetermination") = "" Then
            data(DOCUMENT_CRIMINAL_BACKGROUND_SCREENING_DETERMINATION) = True
        End If

        If Not Request.Form("documentCriminalBackgroundScreeningRequest") Is Nothing Or Not Request.Form("documentCriminalBackgroundScreeningRequest") = "" Then
            data(DOCUMENT_CRIMINAL_BACKGROUND_SCREENING_REQUEST) = True
        End If

        'Notes / Portability Billing / Compliance
        If Not Request.Form("documentNotes") Is Nothing Or Not Request.Form("documentNotes") = "" Then
            data(DOCUMENT_NOTES) = True
        End If

        If Not Request.Form("documentOther") Is Nothing Or Not Request.Form("documentOther") = "" Then
            data(DOCUMENT_OTHER) = True
        End If

        'Recertification Documents
        If Not Request.Form("documentRecertificationChecklist") Is Nothing Or Not Request.Form("documentRecertificationChecklist") = "" Then
            data(DOCUMENT_RECERTIFICATION_CHECKLIST) = True
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

        If Not Request.Form("documentApplicationForContinuedOccupancy") Is Nothing Or Not Request.Form("documentApplicationForContinuedOccupancy") = "" Then
            data(DOCUMENT_APPLICATION_FOR_CONTINUED_OCCUPANCY) = True
        End If

        If Not Request.Form("documentEivIncomeReport") Is Nothing Or Not Request.Form("documentEivIncomeReport") = "" Then
            data(DOCUMENT_EIV_INCOME_REPORT) = True
        End If

        If Not Request.Form("documentUtilityBillForTenantPaidUtilities") Is Nothing Or Not Request.Form("documentUtilityBillForTenantPaidUtilities") = "" Then
            data(DOCUMENT_UTILITY_BILL_FOR_TENANT_PAID_UTILITIES) = True
        End If

        If Not Request.Form("documentAuthorizationForReleaseOfInformationPrivacyActHud9886") Is Nothing Or Not Request.Form("documentAuthorizationForReleaseOfInformationPrivacyActHud9886") = "" Then
            data(DOCUMENT_AUTHORIZATION_FOR_RELEASE_OF_INFORMATION_PRIVACY_ACT_HUD_9886) = True
        End If

        If Not Request.Form("documentHanoAuthorizationForReleaseOfInformation") Is Nothing Or Not Request.Form("documentHanoAuthorizationForReleaseOfInformation") = "" Then
            data(DOCUMENT_HANO_AUTHORIZATION_FOR_RELEASE_OF_INFORMATION) = True
        End If

        If Not Request.Form("documentFamilyObligations") Is Nothing Or Not Request.Form("documentFamilyObligations") = "" Then
            data(DOCUMENT_FAMILY_OBLIGATIONS) = True
        End If

        If Not Request.Form("documentRecertificationAppointmentLetter") Is Nothing Or Not Request.Form("documentRecertificationAppointmentLetter") = "" Then
            data(DOCUMENT_RECERTIFICATION_APPOINTMENT_LETTER) = True
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

        If Not Request.Form("processAnnualReexamination") Is Nothing Or Not Request.Form("processAnnualReexamination") = "" Then
            data(PROCESS_ANNUAL_REEXAMINATION) = True
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

    Protected Sub CreateAnnualReexamination(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProcessAnnualReexamination.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const PROCESS_ANNUAL_REEXAMINATION As Integer = 7

        Dim noticeTypeID As Integer = NoticeTypeAnnualReexamination.SelectedValue
        Dim details As String = Request.Form("commentAnnualReexamination")
        Dim staffID As Integer = CaseManagerAnnualReexamination.SelectedValue
        Dim status As String = StatusAnnualReexamination.SelectedValue

        InsertFileError(details, status, noticeTypeID, staffID, PROCESS_ANNUAL_REEXAMINATION, fileID, REVIEW_TYPE_ID, sessionUserID)
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

    Protected Sub CreateAuthorizationForReleaseOfInformationPrivacyActHud9886(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateAuthorizationForReleaseOfInformationPrivacyActHud9886.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 27
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeAuthorizationForReleaseOfInformationPrivacyActHud9886.SelectedValue
        Dim details As String = Request.Form("commentAuthorizationForReleaseOfInformationPrivacyActHud9886")
        Dim staffID As Integer = CaseManagerAuthorizationForReleaseOfInformationPrivacyActHud9886.SelectedValue
        Dim status As String = StatusAuthorizationForReleaseOfInformationPrivacyActHud9886.SelectedValue

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

    Protected Sub CreateCriminalBackgroundScreeningDetermination(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateCriminalBackgroundScreeningDetermination.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_CRIMINAL_BACKGROUND_SCREENING_DETERMINATION As Integer = 65
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeCriminalBackgroundScreeningDetermination.SelectedValue
        Dim details As String = Request.Form("commentCriminalBackgroundScreeningDetermination")
        Dim staffID As Integer = CaseManagerCriminalBackgroundScreeningDetermination.SelectedValue
        Dim status As String = StatusCriminalBackgroundScreeningDetermination.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_CRIMINAL_BACKGROUND_SCREENING_DETERMINATION)
    End Sub

    Protected Sub CreateCriminalBackgroundScreeningRequest(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateCriminalBackgroundScreeningRequest.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_CRIMINAL_BACKGROUND_SCREENING_REQUEST As Integer = 66
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeCriminalBackgroundScreeningRequest.SelectedValue
        Dim details As String = Request.Form("commentCriminalBackgroundScreeningRequest")
        Dim staffID As Integer = CaseManagerCriminalBackgroundScreeningRequest.SelectedValue
        Dim status As String = StatusCriminalBackgroundScreeningRequest.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_CRIMINAL_BACKGROUND_SCREENING_REQUEST)
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

    Protected Sub CreateDebtsOwedToPhaAndTerminationsHud52675(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateDebtsOwedToPhaAndTerminationsHud52675.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_DEBTS_OWED_TO_PHA_AND_TERMINATIONS_HUD_52675 As Integer = 20
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeDebtsOwedToPhaAndTerminationsHud52675.SelectedValue
        Dim details As String = Request.Form("commentDebtsOwedToPhaAndTerminationsHud52675")
        Dim staffID As Integer = CaseManagerDebtsOwedToPhaAndTerminationsHud52675.SelectedValue
        Dim status As String = StatusDebtsOwedToPhaAndTerminationsHud52675.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_DEBTS_OWED_TO_PHA_AND_TERMINATIONS_HUD_52675)
    End Sub

    Protected Sub CreateDeclarationOfCitizenshipOrEligibleImmigrationStatus(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateDeclarationOfCitizenshipOrEligibleImmigrationStatus.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_DECLARATION_OF_CITIZENSHIP_OR_ELIGIBLE_IMMIGRATION_STATUS As Integer = 54
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeDeclarationOfCitizenshipOrEligibleImmigrationStatus.SelectedValue
        Dim details As String = Request.Form("commentDeclarationOfCitizenshipOrEligibleImmigrationStatus")
        Dim staffID As Integer = CaseManagerDeclarationOfCitizenshipOrEligibleImmigrationStatus.SelectedValue
        Dim status As String = StatusDeclarationOfCitizenshipOrEligibleImmigrationStatus.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_DECLARATION_OF_CITIZENSHIP_OR_ELIGIBLE_IMMIGRATION_STATUS)
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

    Protected Sub CreateEivIncomeReport(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateEivIncomeReport.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 63
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeEivIncomeReport.SelectedValue
        Dim details As String = Request.Form("commentEivIncomeReport")
        Dim staffID As Integer = CaseManagerEivIncomeReport.SelectedValue
        Dim status As String = StatusEivIncomeReport.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateFamilyObligations(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateFamilyObligations.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_FAMILY_OBLIGATIONS As Integer = 67
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeFamilyObligations.SelectedValue
        Dim details As String = Request.Form("commentFamilyObligations")
        Dim staffID As Integer = CaseManagerFamilyObligations.SelectedValue
        Dim status As String = StatusFamilyObligations.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_FAMILY_OBLIGATIONS)
    End Sub

    Protected Sub CreateHanoAuthorizationForReleaseOfInformation(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateHanoAuthorizationForReleaseOfInformation.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 28
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeHanoAuthorizationForReleaseOfInformation.SelectedValue
        Dim details As String = Request.Form("commentHanoAuthorizationForReleaseOfInformation")
        Dim staffID As Integer = CaseManagerHanoAuthorizationForReleaseOfInformation.SelectedValue
        Dim status As String = StatusHanoAuthorizationForReleaseOfInformation.SelectedValue

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

    Protected Sub CreateHudSupplementSheetHud92006(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateHudSupplementSheetHud92006.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_HUD_SUPPLEMENT_SHEET_HUD_92006 As Integer = 21
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeHudSupplementSheetHud92006.SelectedValue
        Dim details As String = Request.Form("commentHudSupplementSheetHud92006")
        Dim staffID As Integer = CaseManagerHudSupplementSheetHud92006.SelectedValue
        Dim status As String = StatusHudSupplementSheetHud92006.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_HUD_SUPPLEMENT_SHEET_HUD_92006)
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

    Protected Sub CreateMasterFamilyDocumentsChecklist(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateMasterFamilyDocumentsChecklist.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_MASTER_FAMILY_DOCUMENTS_CHECKLIST As Integer = 8
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeMasterFamilyDocumentsChecklist.SelectedValue
        Dim details As String = Request.Form("commentMasterFamilyDocumentsChecklist")
        Dim staffID As Integer = CaseManagerMasterFamilyDocumentsChecklist.SelectedValue
        Dim status As String = StatusMasterFamilyDocumentsChecklist.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_MASTER_FAMILY_DOCUMENTS_CHECKLIST)
    End Sub

    Protected Sub CreateNotes(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateNotes.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_NOTES As Integer = 56
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeNotes.SelectedValue
        Dim details As String = Request.Form("commentNotes")
        Dim staffID As Integer = CaseManagerNotes.SelectedValue
        Dim status As String = StatusNotes.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_NOTES)
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

    Protected Sub CreateProofOfBirthDate(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProofOfBirthDate.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_PROOF_OF_BIRTH_DATE As Integer = 12
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeProofOfBirthDate.SelectedValue
        Dim details As String = Request.Form("commentProofOfBirthDate")
        Dim staffID As Integer = CaseManagerProofOfBirthDate.SelectedValue
        Dim status As String = StatusProofOfBirthDate.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_PROOF_OF_BIRTH_DATE)
    End Sub

    Protected Sub CreateProofOfEligibleImmigrationStatus(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProofOfEligibleImmigrationStatus.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_PROOF_OF_ELIGIBLE_IMMIGRATION_STATUS As Integer = 14
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeProofOfEligibleImmigrationStatus.SelectedValue
        Dim details As String = Request.Form("commentProofOfEligibleImmigrationStatus")
        Dim staffID As Integer = CaseManagerProofOfEligibleImmigrationStatus.SelectedValue
        Dim status As String = StatusProofOfEligibleImmigrationStatus.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_PROOF_OF_ELIGIBLE_IMMIGRATION_STATUS)
    End Sub

    Protected Sub CreateProofOfNameChangeIfApplicable(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProofOfNameChangeIfApplicable.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_PROOF_OF_NAME_CHANGE_IF_APPLICABLE As Integer = 13
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeProofOfNameChangeIfApplicable.SelectedValue
        Dim details As String = Request.Form("commentProofOfNameChangeIfApplicable")
        Dim staffID As Integer = CaseManagerProofOfNameChangeIfApplicable.SelectedValue
        Dim status As String = StatusProofOfNameChangeIfApplicable.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_PROOF_OF_NAME_CHANGE_IF_APPLICABLE)
    End Sub

    Protected Sub CreateProofOfSocialSecurityNumber(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProofOfSocialSecurityNumber.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_PROOF_OF_SOCIAL_SECURITY_NUMBER As Integer = 11
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeProofOfSocialSecurityNumber.SelectedValue
        Dim details As String = Request.Form("commentProofOfSocialSecurityNumber")
        Dim staffID As Integer = CaseManagerProofOfSocialSecurityNumber.SelectedValue
        Dim status As String = StatusProofOfSocialSecurityNumber.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_PROOF_OF_SOCIAL_SECURITY_NUMBER)
    End Sub

    Protected Sub CreateRecertificationAppointmentLetter(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateRecertificationAppointmentLetter.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_RECERTIFICATION_APPT_LETTER As Integer = 68
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeRecertificationAppointmentLetter.SelectedValue
        Dim details As String = Request.Form("commentRecertificationAppointmentLetter")
        Dim staffID As Integer = CaseManagerRecertificationAppointmentLetter.SelectedValue
        Dim status As String = StatusRecertificationAppointmentLetter.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_RECERTIFICATION_APPT_LETTER)
    End Sub

    Protected Sub CreateRecertificationChecklist(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateRecertificationChecklist.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_RECERTIFICATION_CHECKLIST As Integer = 57
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeRecertificationChecklist.SelectedValue
        Dim details As String = Request.Form("commentRecertificationChecklist")
        Dim staffID As Integer = CaseManagerRecertificationChecklist.SelectedValue
        Dim status As String = StatusRecertificationChecklist.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_RECERTIFICATION_CHECKLIST)
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

    Protected Sub CreateUtilityBillForTenantPaidUtilities(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateUtilityBillForTenantPaidUtilities.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_TYPE As Integer = 64
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeUtilityBillForTenantPaidUtilities.SelectedValue
        Dim details As String = Request.Form("commentUtilityBillForTenantPaidUtilities")
        Dim staffID As Integer = CaseManagerUtilityBillForTenantPaidUtilities.SelectedValue
        Dim status As String = StatusUtilityBillForTenantPaidUtilities.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_TYPE)
    End Sub

    Protected Sub CreateValidPhotoIdentification(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateValidPhotoIdentification.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_VALID_PHOTO_IDENTIFICATION As Integer = 10
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeValidPhotoIdentification.SelectedValue
        Dim details As String = Request.Form("commentValidPhotoIdentification")
        Dim staffID As Integer = CaseManagerValidPhotoIdentification.SelectedValue
        Dim status As String = StatusValidPhotoIdentification.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_VALID_PHOTO_IDENTIFICATION)
    End Sub

    Protected Sub CreateVawaClientNotice(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateVawaClientNotice.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_VAWA_CLIENT_NOTICE As Integer = 22
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeVawaClientNotice.SelectedValue
        Dim details As String = Request.Form("commentVawaClientNotice")
        Dim staffID As Integer = CaseManagerVawaClientNotice.SelectedValue
        Dim status As String = StatusVawaClientNotice.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_VAWA_CLIENT_NOTICE)
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

                'Annual Reexamination
                CaseManagerAnnualReexamination.DataBind()
                CaseManagerAnnualReexamination.Items.FindByValue(caseManagerID).Selected = True

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

                'Lease
                CaseManagerLease.DataBind()
                CaseManagerLease.Items.FindByValue(caseManagerID).Selected = True

                'Hap Contract 
                CaseManagerHapContract.DataBind()
                CaseManagerHapContract.Items.FindByValue(caseManagerID).Selected = True

                'Hud Tenancy Addendum
                CaseManagerHudTenancyAddendum.DataBind()
                CaseManagerHudTenancyAddendum.Items.FindByValue(caseManagerID).Selected = True

                'Master Family Documents Checklist
                CaseManagerMasterFamilyDocumentsChecklist.DataBind()
                CaseManagerMasterFamilyDocumentsChecklist.Items.FindByValue(caseManagerID).Selected = True

                'Valid Photo Identification
                CaseManagerValidPhotoIdentification.DataBind()
                CaseManagerValidPhotoIdentification.Items.FindByValue(caseManagerID).Selected = True

                'Proof of Social Security Number
                CaseManagerProofOfSocialSecurityNumber.DataBind()
                CaseManagerProofOfSocialSecurityNumber.Items.FindByValue(caseManagerID).Selected = True

                'Proof Of Birth Date
                CaseManagerProofOfBirthDate.DataBind()
                CaseManagerProofOfBirthDate.Items.FindByValue(caseManagerID).Selected = True

                'Proof Of Name Change (If Applicable)
                CaseManagerProofOfNameChangeIfApplicable.DataBind()
                CaseManagerProofOfNameChangeIfApplicable.Items.FindByValue(caseManagerID).Selected = True

                'Proof of Eligible Immigration Status
                CaseManagerProofOfEligibleImmigrationStatus.DataBind()
                CaseManagerProofOfEligibleImmigrationStatus.Items.FindByValue(caseManagerID).Selected = True

                'Declaration of Citizenship or Eligible Immigration Status
                CaseManagerDeclarationOfCitizenshipOrEligibleImmigrationStatus.DataBind()
                CaseManagerDeclarationOfCitizenshipOrEligibleImmigrationStatus.Items.FindByValue(caseManagerID).Selected = True

                'Debts Owed to PHA and Terminations (HUD 52675)
                CaseManagerDebtsOwedToPhaAndTerminationsHud52675.DataBind()
                CaseManagerDebtsOwedToPhaAndTerminationsHud52675.Items.FindByValue(caseManagerID).Selected = True

                'HUD Supplement Sheet (HUD 92006)
                CaseManagerHudSupplementSheetHud92006.DataBind()
                CaseManagerHudSupplementSheetHud92006.Items.FindByValue(caseManagerID).Selected = True

                'VAWA – Client Notice 
                CaseManagerVawaClientNotice.DataBind()
                CaseManagerVawaClientNotice.Items.FindByValue(caseManagerID).Selected = True

                'Signed Original Voucher
                CaseManagerSignedOriginalVoucher.DataBind()
                CaseManagerSignedOriginalVoucher.Items.FindByValue(caseManagerID).Selected = True

                'Notes
                CaseManagerNotes.DataBind()
                CaseManagerNotes.Items.FindByValue(caseManagerID).Selected = True

                'Other - Document
                CaseManagerDocumentOther.DataBind()
                CaseManagerDocumentOther.Items.FindByValue(caseManagerID).Selected = True

                'Recertification Checklist
                CaseManagerRecertificationChecklist.DataBind()
                CaseManagerRecertificationChecklist.Items.FindByValue(caseManagerID).Selected = True

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

                'EIV Income Report
                CaseManagerEivIncomeReport.DataBind()
                CaseManagerEivIncomeReport.Items.FindByValue(caseManagerID).Selected = True

                'Utility Bill (for tenant-paid utilities)
                CaseManagerUtilityBillForTenantPaidUtilities.DataBind()
                CaseManagerUtilityBillForTenantPaidUtilities.Items.FindByValue(caseManagerID).Selected = True

                'Authorization for Release of Information/Privacy Act (HUD-9886)
                CaseManagerAuthorizationForReleaseOfInformationPrivacyActHud9886.DataBind()
                CaseManagerAuthorizationForReleaseOfInformationPrivacyActHud9886.Items.FindByValue(caseManagerID).Selected = True

                'HANO Authorization for Release of Information
                CaseManagerHanoAuthorizationForReleaseOfInformation.DataBind()
                CaseManagerHanoAuthorizationForReleaseOfInformation.Items.FindByValue(caseManagerID).Selected = True

                'Criminal Background Screening Determination
                CaseManagerCriminalBackgroundScreeningDetermination.DataBind()
                CaseManagerCriminalBackgroundScreeningDetermination.Items.FindByValue(caseManagerID).Selected = True

                'Criminal Background Screening Request
                CaseManagerCriminalBackgroundScreeningRequest.DataBind()
                CaseManagerCriminalBackgroundScreeningRequest.Items.FindByValue(caseManagerID).Selected = True

                'Family Obligations
                CaseManagerFamilyObligations.DataBind()
                CaseManagerFamilyObligations.Items.FindByValue(caseManagerID).Selected = True

                'Recertification Appointment Letter
                CaseManagerRecertificationAppointmentLetter.DataBind()
                CaseManagerRecertificationAppointmentLetter.Items.FindByValue(caseManagerID).Selected = True
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

            'Annual Reexamination
            NoticeTypeAnnualReexamination.AppendDataBoundItems = True
            NoticeTypeAnnualReexamination.Items.Insert(0, New ListItem("Notice", "2"))

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

            'Leasing
            NoticeTypeLease.AppendDataBoundItems = True
            NoticeTypeLease.Items.Insert(0, New ListItem("Notice", "2"))

            'Hap Contract 
            NoticeTypeHapContract.AppendDataBoundItems = True
            NoticeTypeHapContract.Items.Insert(0, New ListItem("Notice", "2"))

            'Master Family Documents Checklist
            NoticeTypeMasterFamilyDocumentsChecklist.AppendDataBoundItems = True
            NoticeTypeMasterFamilyDocumentsChecklist.Items.Insert(0, New ListItem("Notice", "2"))

            'Hud Tenancy Addendum
            NoticeTypeHudTenancyAddendum.AppendDataBoundItems = True
            NoticeTypeHudTenancyAddendum.Items.Insert(0, New ListItem("Notice", "2"))

            'Valid Photo Identification
            NoticeTypeValidPhotoIdentification.AppendDataBoundItems = True
            NoticeTypeValidPhotoIdentification.Items.Insert(0, New ListItem("Notice", "2"))

            'Proof of Social Security Number
            NoticeTypeProofOfSocialSecurityNumber.AppendDataBoundItems = True
            NoticeTypeProofOfSocialSecurityNumber.Items.Insert(0, New ListItem("Notice", "2"))

            'Proof Of Birth Date
            NoticeTypeProofOfBirthDate.AppendDataBoundItems = True
            NoticeTypeProofOfBirthDate.Items.Insert(0, New ListItem("Notice", "2"))

            'Proof Of Name Change (If Applicable)
            NoticeTypeProofOfNameChangeIfApplicable.AppendDataBoundItems = True
            NoticeTypeProofOfNameChangeIfApplicable.Items.Insert(0, New ListItem("Notice", "2"))

            'Proof of Eligible Immigration Status
            NoticeTypeProofOfEligibleImmigrationStatus.AppendDataBoundItems = True
            NoticeTypeProofOfEligibleImmigrationStatus.Items.Insert(0, New ListItem("Notice", "2"))

            'Declaration of Citizenship or Eligible Immigration Status
            NoticeTypeDeclarationOfCitizenshipOrEligibleImmigrationStatus.AppendDataBoundItems = True
            NoticeTypeDeclarationOfCitizenshipOrEligibleImmigrationStatus.Items.Insert(0, New ListItem("Notice", "2"))

            'Debts Owed to PHA and Terminations (HUD 52675)
            NoticeTypeDebtsOwedToPhaAndTerminationsHud52675.AppendDataBoundItems = True
            NoticeTypeDebtsOwedToPhaAndTerminationsHud52675.Items.Insert(0, New ListItem("Notice", "2"))

            'HUD Supplement Sheet (HUD 92006)
            NoticeTypeHudSupplementSheetHud92006.AppendDataBoundItems = True
            NoticeTypeHudSupplementSheetHud92006.Items.Insert(0, New ListItem("Notice", "2"))

            'VAWA – Client Notice 
            NoticeTypeVawaClientNotice.AppendDataBoundItems = True
            NoticeTypeVawaClientNotice.Items.Insert(0, New ListItem("Notice", "2"))

            'Signed Original Voucher
            NoticeTypeSignedOriginalVoucher.AppendDataBoundItems = True
            NoticeTypeSignedOriginalVoucher.Items.Insert(0, New ListItem("Notice", "2"))

            'Notes
            NoticeTypeNotes.AppendDataBoundItems = True
            NoticeTypeNotes.Items.Insert(0, New ListItem("Notice", "2"))

            'Other - Document
            NoticeTypeDocumentOther.AppendDataBoundItems = True
            NoticeTypeDocumentOther.Items.Insert(0, New ListItem("Notice", "2"))

            'Recertification Checklist
            NoticeTypeRecertificationChecklist.AppendDataBoundItems = True
            NoticeTypeRecertificationChecklist.Items.Insert(0, New ListItem("Notice", "2"))

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

            'EIV Income Report
            NoticeTypeEivIncomeReport.AppendDataBoundItems = True
            NoticeTypeEivIncomeReport.Items.Insert(0, New ListItem("Notice", "2"))

            'Utility Bill (for tenant-paid utilities)
            NoticeTypeUtilityBillForTenantPaidUtilities.AppendDataBoundItems = True
            NoticeTypeUtilityBillForTenantPaidUtilities.Items.Insert(0, New ListItem("Notice", "2"))

            'Authorization for Release of Information/Privacy Act (HUD-9886)
            NoticeTypeAuthorizationForReleaseOfInformationPrivacyActHud9886.AppendDataBoundItems = True
            NoticeTypeAuthorizationForReleaseOfInformationPrivacyActHud9886.Items.Insert(0, New ListItem("Notice", "2"))

            'HANO Authorization for Release of Information
            NoticeTypeHanoAuthorizationForReleaseOfInformation.AppendDataBoundItems = True
            NoticeTypeHanoAuthorizationForReleaseOfInformation.Items.Insert(0, New ListItem("Notice", "2"))

            'Criminal Background Screening Determination
            NoticeTypeCriminalBackgroundScreeningDetermination.AppendDataBoundItems = True
            NoticeTypeCriminalBackgroundScreeningDetermination.Items.Insert(0, New ListItem("Notice", "2"))

            'Criminal Background Screening Request
            NoticeTypeCriminalBackgroundScreeningRequest.AppendDataBoundItems = True
            NoticeTypeCriminalBackgroundScreeningRequest.Items.Insert(0, New ListItem("Notice", "2"))

            'Family Obligations
            NoticeTypeFamilyObligations.AppendDataBoundItems = True
            NoticeTypeFamilyObligations.Items.Insert(0, New ListItem("Notice", "2"))

            'Recertification Appointment Letter
            NoticeTypeRecertificationAppointmentLetter.AppendDataBoundItems = True
            NoticeTypeRecertificationAppointmentLetter.Items.Insert(0, New ListItem("Notice", "2"))
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
        Dim query As String = "INSERT INTO FileErrorsDocumentTypes (fk_ErrorID, fk_FileID, fk_DocumentTypeID) VALUES (@fk_ErrorID, @fk_FileID, @fk_DocumentTypeID)"

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
        Dim seededDocument As New Dictionary(Of Integer, Boolean)
        conn.Open()
        Dim query As New SqlCommand("SELECT fk_DocumentTypeID FROM ReviewTypesDocuments WHERE fk_ReviewTypeID ='" & REVIEW_TYPE_ID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()
        While reader.Read
            seededDocument.Add(CStr(reader("fk_DocumentTypeID")), False)
        End While
        conn.Close()

        Return seededDocument
    End Function

    Public Function SeedReviewProcesses() As Dictionary(Of Integer, Boolean)
        Dim seededProcess As New Dictionary(Of Integer, Boolean)
        conn.Open()
        Dim query As New SqlCommand("SELECT fk_ProcessTypeID FROM ReviewTypesProcesses WHERE fk_ReviewTypeID ='" & REVIEW_TYPE_ID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()
        While reader.Read
            seededProcess.Add(CStr(reader("fk_ProcessTypeID")), False)
        End While
        conn.Close()

        Return seededProcess
    End Function
End Class
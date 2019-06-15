Imports System.Data.SqlClient
Imports System.Web.Configuration

Public Class CreateEligibilityScreening
    Inherits System.Web.UI.Page
    Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)
    Const REVIEW_TYPE_ID As Integer = 2
    Const PROCESS_DOCUMENT_TYPE As Integer = 18

#Region "For Error Checkboxes (Processing)"
    Const PROCESS_VERTIFICATION As Integer = 1
    Const PROCESS_CALCULATION As Integer = 2
    Const PROCESS_OCCUPANCY_STANDARD As Integer = 6
    Const PROCESS_ELIGIBILITY_AND_SCREENING As Integer = 11
    Const PROCESS_DATA_ENTRY As Integer = 13
    Const PROCESS_OTHER As Integer = 21
#End Region

#Region "For Error Checkboxes (Documents)"
    Const DOCUMENT_MASTER_FAMILY_DOCUMENTS_CHECKLIST As Integer = 8
    Const DOCUMENT_NEW_ADMISSION_CHECKLIST As Integer = 9
    Const DOCUMENT_VALID_PHOTO_IDENTIFICATION As Integer = 10
    Const DOCUMENT_PROOF_OF_SOCIAL_SECURITY_NUMBER As Integer = 11
    Const DOCUMENT_PROOF_OF_BIRTH_DATE As Integer = 12
    Const DOCUMENT_PROOF_OF_NAME_CHANGE_IF_APPLICABLE As Integer = 13
    Const DOCUMENT_PROOF_OF_ELIGIBLE_IMMIGRATION_STATUS As Integer = 14
    Const DOCUMENT_DECLARATION_OF_CITIZENSHIP_OR_ELIGIBLE_IMMIGRATION_STATUS As Integer = 54
    Const DOCUMENT_CRIMINAL_BACKGROUND_SCREENING_DETERMINATION_INITIAL_INTAKE As Integer = 15
    Const DOCUMENT_CRIMINAL_BACKGROUND_SCREENING_REQUEST_INITIAL_INTAKE As Integer = 16
    Const DOCUMENT_EIV_EXISTING_TENANT_SEARCH As Integer = 76
    Const DOCUMENT_EIV_FORMER_TENANT_SEARCH As Integer = 17
    Const DOCUMENT_AUTHORIZATION_FOR_RELEASE_OF_INFORMATION_PRIVACY_ACT_HUD_9886_INITIAL As Integer = 18
    Const DOCUMENT_HANO_AUTHORIZATION_FOR_RELEASE_OF_INFORMATION_INITIAL As Integer = 19
    Const DOCUMENT_DEBTS_OWED_TO_PHA_AND_TERMINATIONS_HUD_52675 As Integer = 20
    Const DOCUMENT_HUD_SUPPLEMENT_SHEET_HUD_92006 As Integer = 21
    Const DOCUMENT_VAWA_CLIENT_NOTICE As Integer = 22
    Const DOCUMENT_SPECIAL_PROGRAM_REFERRAL_FORM_IF_APPLICABLE As Integer = 23
    Const DOCUMENT_HANO_PRE_APPLICATION_INITIAL_APPLICATION As Integer = 24
    Const DOCUMENT_BRIEFING_APPOINTMENT_LETTER As Integer = 25
    Const DOCUMENT_SCREENING_APPOINTMENT_LETTER As Integer = 26
    Const DOCUMENT_OTHER As Integer = 6
    Const DOCUMENT_AUTHORIZATION_FOR_RELEASE_OF_INFORMATION_PRIVACY_ACT_HUD_9886 As Integer = 27
    Const DOCUMENT_HANO_AUTHORIZATION_FOR_RELEASE_OF_INFORMATION As Integer = 28
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim fileID As Integer = Request.QueryString("FileID")
        DisplayDropDownlistCaseManager(fileID)
        DisplayDropDownlistNotice()
    End Sub

    Public Function AssignSeededReviewDocuments(ByVal data As Dictionary(Of Integer, Boolean)) As Dictionary(Of Integer, Boolean)
        Dim documents As New Dictionary(Of Integer, Boolean)

        'Master Documents
        If Not Request.Form("documentMasterFamilyDocumentsChecklist") Is Nothing Or Not Request.Form("documentMasterFamilyDocumentsChecklist") = "" Then
            data(DOCUMENT_MASTER_FAMILY_DOCUMENTS_CHECKLIST) = True
        End If

        If Not Request.Form("documentNewAdmissionChecklist") Is Nothing Or Not Request.Form("documentNewAdmissionChecklist") = "" Then
            data(DOCUMENT_NEW_ADMISSION_CHECKLIST) = True
        End If

        If Not Request.Form("documentValidPhotoIdentification") Is Nothing Or Not Request.Form("documentValidPhotoIdentification") = "" Then
            data(DOCUMENT_VALID_PHOTO_IDENTIFICATION) = True
        End If

        If Not Request.Form("documentProofOfSocialSecurityNumber") Is Nothing Or Not Request.Form("documentProofOfSocialSecurityNumber") = "" Then
            data(DOCUMENT_PROOF_OF_SOCIAL_SECURITY_NUMBER) = True
        End If

        If Not Request.Form("documentProofOfBirthDate") Is Nothing Or Not Request.Form("documentProofOfBirthDate") = "" Then
            data(DOCUMENT_PROOF_OF_BIRTH_DATE) = True
        End If

        If Not Request.Form("documentProofOfNameChangeIfApplicable") Is Nothing Or Not Request.Form("documentProofOfNameChangeIfApplicable") = "" Then
            data(DOCUMENT_PROOF_OF_NAME_CHANGE_IF_APPLICABLE) = True
        End If

        If Not Request.Form("documentDeclarationOfCitizenshipOrEligibleImmigrationStatus") Is Nothing Or Not Request.Form("documentDeclarationOfCitizenshipOrEligibleImmigrationStatus") = "" Then
            data(DOCUMENT_DECLARATION_OF_CITIZENSHIP_OR_ELIGIBLE_IMMIGRATION_STATUS) = True
        End If

        If Not Request.Form("documentCriminalBackgroundScreeningDeterminationInitialIntake") Is Nothing Or Not Request.Form("documentCriminalBackgroundScreeningDeterminationInitialIntake") = "" Then
            data(DOCUMENT_CRIMINAL_BACKGROUND_SCREENING_DETERMINATION_INITIAL_INTAKE) = True
        End If

        If Not Request.Form("documentCriminalBackgroundScreeningRequestInitialIntake") Is Nothing Or Not Request.Form("documentCriminalBackgroundScreeningRequestInitialIntake") = "" Then
            data(DOCUMENT_CRIMINAL_BACKGROUND_SCREENING_REQUEST_INITIAL_INTAKE) = True
        End If

        If Not Request.Form("documentEivExistingTenantSearch") Is Nothing Or Not Request.Form("documentEivExistingTenantSearch") = "" Then
            data(DOCUMENT_EIV_EXISTING_TENANT_SEARCH) = True
        End If

        If Not Request.Form("documentEivFormerTenantSearch") Is Nothing Or Not Request.Form("documentEivFormerTenantSearch") = "" Then
            data(DOCUMENT_EIV_FORMER_TENANT_SEARCH) = True
        End If

        If Not Request.Form("documentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial") Is Nothing Or Not Request.Form("documentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial") = "" Then
            data(DOCUMENT_AUTHORIZATION_FOR_RELEASE_OF_INFORMATION_PRIVACY_ACT_HUD_9886_INITIAL) = True
        End If

        If Not Request.Form("documentHanoAuthorizationForReleaseOfInformationInitial") Is Nothing Or Not Request.Form("documentHanoAuthorizationForReleaseOfInformationInitial") = "" Then
            data(DOCUMENT_HANO_AUTHORIZATION_FOR_RELEASE_OF_INFORMATION_INITIAL) = True
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

        If Not Request.Form("documentSpecialProgramReferralFormIfApplicable") Is Nothing Or Not Request.Form("documentSpecialProgramReferralFormIfApplicable") = "" Then
            data(DOCUMENT_SPECIAL_PROGRAM_REFERRAL_FORM_IF_APPLICABLE) = True
        End If

        If Not Request.Form("documentHanoPreApplicationInitialApplication") Is Nothing Or Not Request.Form("documentHanoPreApplicationInitialApplication") = "" Then
            data(DOCUMENT_HANO_PRE_APPLICATION_INITIAL_APPLICATION) = True
        End If

        If Not Request.Form("documentBriefingAppointmentLetter") Is Nothing Or Not Request.Form("documentBriefingAppointmentLetter") = "" Then
            data(DOCUMENT_BRIEFING_APPOINTMENT_LETTER) = True
        End If

        If Not Request.Form("documentScreeningAppointmentLetter") Is Nothing Or Not Request.Form("documentScreeningAppointmentLetter") = "" Then
            data(DOCUMENT_SCREENING_APPOINTMENT_LETTER) = True
        End If

        'Notes / Portability Billing / Compliance
        If Not Request.Form("documentOther") Is Nothing Or Not Request.Form("documentOther") = "" Then
            data(DOCUMENT_OTHER) = True
        End If

        'Recertification Documents
        If Not Request.Form("documentAuthorizationForReleaseOfInformationPrivacyActHud9886") Is Nothing Or Not Request.Form("documentAuthorizationForReleaseOfInformationPrivacyActHud9886") = "" Then
            data(DOCUMENT_AUTHORIZATION_FOR_RELEASE_OF_INFORMATION_PRIVACY_ACT_HUD_9886) = True
        End If

        If Not Request.Form("documentHanoAuthorizationForReleaseOfInformation") Is Nothing Or Not Request.Form("documentHanoAuthorizationForReleaseOfInformation") = "" Then
            data(DOCUMENT_HANO_AUTHORIZATION_FOR_RELEASE_OF_INFORMATION) = True
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

        If Not Request.Form("processOccupancyStandard") Is Nothing Or Not Request.Form("processOccupancyStandard") = "" Then
            data(PROCESS_OCCUPANCY_STANDARD) = True
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

    Protected Sub CreateAuthorizationForReleaseOfInformationPrivacyActHud9886(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateAuthorizationForReleaseOfInformationPrivacyActHud9886.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_AUTHORIZATION_FOR_RELEASE_OF_INFORMATION_PRIVACY_ACT_HUD_9886 As Integer = 27
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeAuthorizationForReleaseOfInformationPrivacyActHud9886.SelectedValue
        Dim details As String = Request.Form("commentAuthorizationForReleaseOfInformationPrivacyActHud9886")
        Dim staffID As Integer = CaseManagerAuthorizationForReleaseOfInformationPrivacyActHud9886.SelectedValue
        Dim status As String = StatusAuthorizationForReleaseOfInformationPrivacyActHud9886.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_AUTHORIZATION_FOR_RELEASE_OF_INFORMATION_PRIVACY_ACT_HUD_9886)
    End Sub

    Protected Sub CreateAuthorizationForReleaseOfInformationPrivacyActHud9886Initial(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateAuthorizationForReleaseOfInformationPrivacyActHud9886Initial.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_AUTHORIZATION_FOR_RELEASE_OF_INFORMATION_PRIVACY_ACT_HUD_9886_INITIAL As Integer = 18
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeAuthorizationForReleaseOfInformationPrivacyActHud9886Initial.SelectedValue
        Dim details As String = Request.Form("commentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial")
        Dim staffID As Integer = CaseManagerAuthorizationForReleaseOfInformationPrivacyActHud9886Initial.SelectedValue
        Dim status As String = StatusAuthorizationForReleaseOfInformationPrivacyActHud9886Initial.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_AUTHORIZATION_FOR_RELEASE_OF_INFORMATION_PRIVACY_ACT_HUD_9886_INITIAL)
    End Sub

    Protected Sub CreateBriefingAppointmentLetter(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateBriefingAppointmentLetter.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_BRIEFING_APPOINTMENT_LETTER As Integer = 25
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeBriefingAppointmentLetter.SelectedValue
        Dim details As String = Request.Form("commentBriefingAppointmentLetter")
        Dim staffID As Integer = CaseManagerBriefingAppointmentLetter.SelectedValue
        Dim status As String = StatusBriefingAppointmentLetter.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_BRIEFING_APPOINTMENT_LETTER)
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

    Protected Sub CreateCriminalBackgroundScreeningDeterminationInitialIntake(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateCriminalBackgroundScreeningDeterminationInitialIntake.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_CRIMINAL_BACKGROUND_SCREENING_DETERMINATION_INITIAL_INTAKE As Integer = 15
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeCriminalBackgroundScreeningDeterminationInitialIntake.SelectedValue
        Dim details As String = Request.Form("commentCriminalBackgroundScreeningDeterminationInitialIntake")
        Dim staffID As Integer = CaseManagerCriminalBackgroundScreeningDeterminationInitialIntake.SelectedValue
        Dim status As String = StatusCriminalBackgroundScreeningDeterminationInitialIntake.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_CRIMINAL_BACKGROUND_SCREENING_DETERMINATION_INITIAL_INTAKE)
    End Sub

    Protected Sub CreateCriminalBackgroundScreeningRequestIinitialIntake(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateCriminalBackgroundScreeningRequestInitialIntake.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_CRIMINAL_BACKGROUND_SCREENING_REQUEST_INITIAL_INTAKE As Integer = 16
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeCriminalBackgroundScreeningRequestInitialIntake.SelectedValue
        Dim details As String = Request.Form("commentCriminalBackgroundScreeningRequestInitialIntake")
        Dim staffID As Integer = CaseManagerCriminalBackgroundScreeningRequestInitialIntake.SelectedValue
        Dim status As String = StatusCriminalBackgroundScreeningRequestInitialIntake.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_CRIMINAL_BACKGROUND_SCREENING_REQUEST_INITIAL_INTAKE)
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

    Protected Sub CreateEivExistingTenantSearch(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateEivExistingTenantSearch.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_EIV_EXISTING_TENANT_SEARCH As Integer = 76
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeEivExistingTenantSearch.SelectedValue
        Dim details As String = Request.Form("commentEivExistingTenantSearch")
        Dim staffID As Integer = CaseManagerEivExistingTenantSearch.SelectedValue
        Dim status As String = StatusEivExistingTenantSearch.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_EIV_EXISTING_TENANT_SEARCH)
    End Sub

    Protected Sub CreateEivFormerTenantSearch(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateEivFormerTenantSearch.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_EIV_FORMER_TENANT_SEARCH As Integer = 17
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeEivFormerTenantSearch.SelectedValue
        Dim details As String = Request.Form("commentEivFormerTenantSearch")
        Dim staffID As Integer = CaseManagerEivFormerTenantSearch.SelectedValue
        Dim status As String = StatusEivFormerTenantSearch.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_EIV_FORMER_TENANT_SEARCH)
    End Sub

    Protected Sub CreateEligibilityAndScreening(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateProcessEligibilityAndScreening.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const PROCESS_OCCUPANCY_STANDARD As Integer = 11

        Dim noticeTypeID As Integer = NoticeTypeEligibilityAndScreening.SelectedValue
        Dim details As String = Request.Form("commentEligibilityAndScreening")
        Dim staffID As Integer = CaseManagerEligibilityAndScreening.SelectedValue
        Dim status As String = StatusEligibilityAndScreening.SelectedValue

        InsertFileError(details, status, noticeTypeID, staffID, PROCESS_OCCUPANCY_STANDARD, fileID, REVIEW_TYPE_ID, sessionUserID)
    End Sub

    Protected Sub CreateHanoAuthorizationForReleaseOfInformation(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateHanoAuthorizationForReleaseOfInformation.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_HANO_AUTHORIZATION_FOR_RELEASE_OF_INFORMATION As Integer = 28
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeHanoAuthorizationForReleaseOfInformation.SelectedValue
        Dim details As String = Request.Form("commentHanoAuthorizationForReleaseOfInformation")
        Dim staffID As Integer = CaseManagerHanoAuthorizationForReleaseOfInformation.SelectedValue
        Dim status As String = StatusHanoAuthorizationForReleaseOfInformation.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_HANO_AUTHORIZATION_FOR_RELEASE_OF_INFORMATION)
    End Sub

    Protected Sub CreateHanoAuthorizationForReleaseOfInformationInitial(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateHanoAuthorizationForReleaseOfInformationInitial.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_HANO_AUTHORIZATION_FOR_RELEASE_OF_INFORMATION_INITIAL As Integer = 19
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeHanoAuthorizationForReleaseOfInformationInitial.SelectedValue
        Dim details As String = Request.Form("commentHanoAuthorizationForReleaseOfInformationInitial")
        Dim staffID As Integer = CaseManagerHanoAuthorizationForReleaseOfInformationInitial.SelectedValue
        Dim status As String = StatusHanoAuthorizationForReleaseOfInformationInitial.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_HANO_AUTHORIZATION_FOR_RELEASE_OF_INFORMATION_INITIAL)
    End Sub

    Protected Sub CreateHanoPreApplicationInitialApplication(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateHanoPreApplicationInitialApplication.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_HANO_PRE_APPLICATION_INITIAL_APPLICATION As Integer = 24
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeHanoPreApplicationInitialApplication.SelectedValue
        Dim details As String = Request.Form("commentHanoPreApplicationInitialApplication")
        Dim staffID As Integer = CaseManagerHanoPreApplicationInitialApplication.SelectedValue
        Dim status As String = StatusHanoPreApplicationInitialApplication.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_HANO_PRE_APPLICATION_INITIAL_APPLICATION)
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

    Protected Sub CreateNewAdmissionChecklist(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateNewAdmissionChecklist.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_NEW_ADMISSION_CHECKLIST As Integer = 9
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeNewAdmissionChecklist.SelectedValue
        Dim details As String = Request.Form("commentNewAdmissionChecklist")
        Dim staffID As Integer = CaseManagerNewAdmissionChecklist.SelectedValue
        Dim status As String = StatusNewAdmissionChecklist.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_NEW_ADMISSION_CHECKLIST)
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

    Protected Sub CreateScreeningAppointmentLetter(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateScreeningAppointmentLetter.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_SCREENING_APPOINTMENT_LETTER As Integer = 26
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeScreeningAppointmentLetter.SelectedValue
        Dim details As String = Request.Form("commentScreeningAppointmentLetter")
        Dim staffID As Integer = CaseManagerScreeningAppointmentLetter.SelectedValue
        Dim status As String = StatusScreeningAppointmentLetter.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_SCREENING_APPOINTMENT_LETTER)
    End Sub

    Protected Sub CreateSpecialProgramReferralFormIfApplicable(ByVal sender As Object, ByVal e As EventArgs) Handles btnCreateSpecialProgramReferralFormIfApplicable.Click
        Dim fileID As Integer = Request.QueryString("FileID")
        Dim sessionUserID As Integer = GetUserSessionID()
        Const DOCUMENT_SPECIAL_PROGRAM_REFERRAL_FORM As Integer = 23
        Dim errorID As Integer

        Dim noticeTypeID As Integer = NoticeTypeSpecialProgramReferralFormIfApplicable.SelectedValue
        Dim details As String = Request.Form("commentSpecialProgramReferralFormIfApplicable")
        Dim staffID As Integer = CaseManagerSpecialProgramReferralFormIfApplicable.SelectedValue
        Dim status As String = StatusSpecialProgramReferralFormIfApplicable.SelectedValue

        errorID = InsertFileError(details, status, noticeTypeID, staffID, PROCESS_DOCUMENT_TYPE, fileID, REVIEW_TYPE_ID, sessionUserID)
        InsertFileErrorDocumentType(errorID, fileID, DOCUMENT_SPECIAL_PROGRAM_REFERRAL_FORM)
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

                'Occupany Standard
                CaseManagerOccupancyStandard.DataBind()
                CaseManagerOccupancyStandard.Items.FindByValue(caseManagerID).Selected = True

                'Eligibility and Screening
                CaseManagerEligibilityAndScreening.DataBind()
                CaseManagerEligibilityAndScreening.Items.FindByValue(caseManagerID).Selected = True

                'Data Entry
                CaseManagerDataEntry.DataBind()
                CaseManagerDataEntry.Items.FindByValue(caseManagerID).Selected = True

                'Other
                CaseManagerProcessOther.DataBind()
                CaseManagerProcessOther.Items.FindByValue(caseManagerID).Selected = True

                'Master Family Documents Checklist
                CaseManagerMasterFamilyDocumentsChecklist.DataBind()
                CaseManagerMasterFamilyDocumentsChecklist.Items.FindByValue(caseManagerID).Selected = True

                'New Admission Checklist
                CaseManagerNewAdmissionChecklist.DataBind()
                CaseManagerNewAdmissionChecklist.Items.FindByValue(caseManagerID).Selected = True

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

                'Criminal Background Screening Determination (Initial Intake)
                CaseManagerCriminalBackgroundScreeningDeterminationInitialIntake.DataBind()
                CaseManagerCriminalBackgroundScreeningDeterminationInitialIntake.Items.FindByValue(caseManagerID).Selected = True

                'Criminal Background Screening Request (initial intake)
                CaseManagerCriminalBackgroundScreeningRequestInitialIntake.DataBind()
                CaseManagerCriminalBackgroundScreeningRequestInitialIntake.Items.FindByValue(caseManagerID).Selected = True

                'EIV: Existing Tenant Search
                CaseManagerEivExistingTenantSearch.DataBind()
                CaseManagerEivExistingTenantSearch.Items.FindByValue(caseManagerID).Selected = True

                'Eiv: Former Tenant Search
                CaseManagerEivFormerTenantSearch.DataBind()
                CaseManagerEivFormerTenantSearch.Items.FindByValue(caseManagerID).Selected = True

                'Authorization for Release of Information/Privacy Act (HUD-9886) (Initial)
                CaseManagerAuthorizationForReleaseOfInformationPrivacyActHud9886Initial.DataBind()
                CaseManagerAuthorizationForReleaseOfInformationPrivacyActHud9886Initial.Items.FindByValue(caseManagerID).Selected = True

                'HANO Authorization for Release of Information (Initial) 
                CaseManagerHanoAuthorizationForReleaseOfInformationInitial.DataBind()
                CaseManagerHanoAuthorizationForReleaseOfInformationInitial.Items.FindByValue(caseManagerID).Selected = True

                'Debts Owed to PHA and Terminations (HUD 52675)
                CaseManagerDebtsOwedToPhaAndTerminationsHud52675.DataBind()
                CaseManagerDebtsOwedToPhaAndTerminationsHud52675.Items.FindByValue(caseManagerID).Selected = True

                'HUD Supplement Sheet (HUD 92006)
                CaseManagerHudSupplementSheetHud92006.DataBind()
                CaseManagerHudSupplementSheetHud92006.Items.FindByValue(caseManagerID).Selected = True

                'VAWA – Client Notice 
                CaseManagerVawaClientNotice.DataBind()
                CaseManagerVawaClientNotice.Items.FindByValue(caseManagerID).Selected = True

                'Special Program Referral Form (If Applicable)
                CaseManagerSpecialProgramReferralFormIfApplicable.DataBind()
                CaseManagerSpecialProgramReferralFormIfApplicable.Items.FindByValue(caseManagerID).Selected = True

                'Hano Pre-Application/Initial Application
                CaseManagerHanoPreApplicationInitialApplication.DataBind()
                CaseManagerHanoPreApplicationInitialApplication.Items.FindByValue(caseManagerID).Selected = True

                'Briefing Appointment Letter
                CaseManagerBriefingAppointmentLetter.DataBind()
                CaseManagerBriefingAppointmentLetter.Items.FindByValue(caseManagerID).Selected = True

                'Screening Appointment Letter
                CaseManagerScreeningAppointmentLetter.DataBind()
                CaseManagerScreeningAppointmentLetter.Items.FindByValue(caseManagerID).Selected = True

                'Other - Document
                CaseManagerDocumentOther.DataBind()
                CaseManagerDocumentOther.Items.FindByValue(caseManagerID).Selected = True

                'Authorization For Release Of Information/Privacy Act (Hud-9886)
                CaseManagerAuthorizationForReleaseOfInformationPrivacyActHud9886.DataBind()
                CaseManagerAuthorizationForReleaseOfInformationPrivacyActHud9886.Items.FindByValue(caseManagerID).Selected = True

                'Hano Authorization For Release Of Information
                CaseManagerHanoAuthorizationForReleaseOfInformation.DataBind()
                CaseManagerHanoAuthorizationForReleaseOfInformation.Items.FindByValue(caseManagerID).Selected = True
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

            'Occupany Standard
            NoticeTypeOccupancyStandard.AppendDataBoundItems = True
            NoticeTypeOccupancyStandard.Items.Insert(0, New ListItem("Notice", "2"))

            'Eligibility and Screening
            NoticeTypeEligibilityAndScreening.AppendDataBoundItems = True
            NoticeTypeEligibilityAndScreening.Items.Insert(0, New ListItem("Notice", "2"))

            'Data Entry
            NoticeTypeDataEntry.AppendDataBoundItems = True
            NoticeTypeDataEntry.Items.Insert(0, New ListItem("Notice", "2"))

            'Other
            NoticeTypeProcessOther.AppendDataBoundItems = True
            NoticeTypeProcessOther.Items.Insert(0, New ListItem("Notice", "2"))

            'Master Family Documents Checklist
            NoticeTypeMasterFamilyDocumentsChecklist.AppendDataBoundItems = True
            NoticeTypeMasterFamilyDocumentsChecklist.Items.Insert(0, New ListItem("Notice", "2"))

            'New Admission Checklist
            NoticeTypeNewAdmissionChecklist.AppendDataBoundItems = True
            NoticeTypeNewAdmissionChecklist.Items.Insert(0, New ListItem("Notice", "2"))

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

            'Criminal Background Screening Determination (Initial Intake)
            NoticeTypeCriminalBackgroundScreeningDeterminationInitialIntake.AppendDataBoundItems = True
            NoticeTypeCriminalBackgroundScreeningDeterminationInitialIntake.Items.Insert(0, New ListItem("Notice", "2"))

            'Criminal Background Screening Request (initial intake) 
            NoticeTypeCriminalBackgroundScreeningRequestInitialIntake.AppendDataBoundItems = True
            NoticeTypeCriminalBackgroundScreeningRequestInitialIntake.Items.Insert(0, New ListItem("Notice", "2"))

            'EIV: Existing Tenant Search
            NoticeTypeEivExistingTenantSearch.AppendDataBoundItems = True
            NoticeTypeEivExistingTenantSearch.Items.Insert(0, New ListItem("Notice", "2"))

            'Eiv: Former Tenant Search
            NoticeTypeEivFormerTenantSearch.AppendDataBoundItems = True
            NoticeTypeEivFormerTenantSearch.Items.Insert(0, New ListItem("Notice", "2"))

            'Authorization for Release of Information/Privacy Act (HUD-9886) (Initial)
            NoticeTypeAuthorizationForReleaseOfInformationPrivacyActHud9886Initial.AppendDataBoundItems = True
            NoticeTypeAuthorizationForReleaseOfInformationPrivacyActHud9886Initial.Items.Insert(0, New ListItem("Notice", "2"))

            'HANO Authorization for Release of Information (Initial) 
            NoticeTypeHanoAuthorizationForReleaseOfInformationInitial.AppendDataBoundItems = True
            NoticeTypeHanoAuthorizationForReleaseOfInformationInitial.Items.Insert(0, New ListItem("Notice", "2"))

            'Debts Owed to PHA and Terminations (HUD 52675)
            NoticeTypeDebtsOwedToPhaAndTerminationsHud52675.AppendDataBoundItems = True
            NoticeTypeDebtsOwedToPhaAndTerminationsHud52675.Items.Insert(0, New ListItem("Notice", "2"))

            'HUD Supplement Sheet (HUD 92006)
            NoticeTypeHudSupplementSheetHud92006.AppendDataBoundItems = True
            NoticeTypeHudSupplementSheetHud92006.Items.Insert(0, New ListItem("Notice", "2"))

            'VAWA – Client Notice 
            NoticeTypeVawaClientNotice.AppendDataBoundItems = True
            NoticeTypeVawaClientNotice.Items.Insert(0, New ListItem("Notice", "2"))

            'Special Program Referral Form (If Applicable)
            NoticeTypeSpecialProgramReferralFormIfApplicable.AppendDataBoundItems = True
            NoticeTypeSpecialProgramReferralFormIfApplicable.Items.Insert(0, New ListItem("Notice", "2"))

            'Hano Pre-Application/Initial Application
            NoticeTypeHanoPreApplicationInitialApplication.AppendDataBoundItems = True
            NoticeTypeHanoPreApplicationInitialApplication.Items.Insert(0, New ListItem("Notice", "2"))

            'Briefing Appointment Letter
            NoticeTypeBriefingAppointmentLetter.AppendDataBoundItems = True
            NoticeTypeBriefingAppointmentLetter.Items.Insert(0, New ListItem("Notice", "2"))

            'Screening Appointment Letter
            NoticeTypeScreeningAppointmentLetter.AppendDataBoundItems = True
            NoticeTypeScreeningAppointmentLetter.Items.Insert(0, New ListItem("Notice", "2"))

            'Other - Document
            NoticeTypeDocumentOther.AppendDataBoundItems = True
            NoticeTypeDocumentOther.Items.Insert(0, New ListItem("Notice", "2"))

            'Authorization For Release Of Information/Privacy Act (Hud-9886)
            NoticeTypeAuthorizationForReleaseOfInformationPrivacyActHud9886.AppendDataBoundItems = True
            NoticeTypeAuthorizationForReleaseOfInformationPrivacyActHud9886.Items.Insert(0, New ListItem("Notice", "2"))

            'Hano Authorization For Release Of Information
            NoticeTypeHanoAuthorizationForReleaseOfInformation.AppendDataBoundItems = True
            NoticeTypeHanoAuthorizationForReleaseOfInformation.Items.Insert(0, New ListItem("Notice", "2"))
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
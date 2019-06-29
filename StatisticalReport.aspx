<%@ Page Title="QC :: Statistical" Language="vb" AutoEventWireup="false" MasterPageFile="~/User.Master"
    CodeBehind="StatisticalReport.aspx.vb" Inherits="QualityControlMonitor.Statistical_Report" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="header">
                    <h4 class="title"><i class="fa fa-signal" aria-hidden="true"></i> Report :: Statistical</h4>
                    <hr />
                </div>
                <div class="content">
                    <form id="Form1" runat="server">
                     <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
                    <%
                        Dim sessionUserID As String
                        If Not Web.HttpContext.Current.Session("SessionUserID") Is Nothing Then
                            sessionUserID = Web.HttpContext.Current.Session("SessionUserID").ToString()
                        End If

                        If sessionUserID = Nothing Then
                            sessionUserID = Request.QueryString("SessionUserID")
                            Web.HttpContext.Current.Session("SessionUserID") = sessionUserID
                        End If

                        Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)
                        conn.Open()
                        Dim query As New SqlCommand("SELECT fk_RoleID FROM Users WHERE UserID  = '" & sessionUserID & "'", conn)
                        Dim reader As SqlDataReader = query.ExecuteReader()

                        Dim sessionRoleID As Integer

                        While reader.Read
                            sessionRoleID = CStr(reader("fk_RoleID"))
                        End While
                        conn.Close()

                        Const HOUSING_SPECALIST As Integer = 3

                        If Not sessionRoleID = HOUSING_SPECALIST Then
                    %>
                     <div class="row">
                        <div class="col-md-4">
                            <label> File Staff</label>
                            <div class="form-group input-group">
                                <asp:DropDownList ID="FileStaff" runat="server" class="form-control border-input"
                                    DataSourceID="SqlFileStaff" DataValueField="UserID" DataTextField="FullName"
                                    required="required">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlFileStaff" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString  %>"
                                    SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                </asp:SqlDataSource>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <label> Auditor</label>
                            <div class="form-group input-group">
                                <asp:DropDownList ID="Auditor" runat="server" class="form-control border-input" DataSourceID="SqlAuditor"
                                    DataValueField="UserID" DataTextField="FullName" required="required">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlAuditor" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString  %>"
                                    SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '2' OR [fk_RoleID] = '1' ORDER BY [FirstName] ASC">
                                </asp:SqlDataSource>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <label>Group</label>
                            <div class="form-group input-group">
                                <asp:DropDownList ID="Group" runat="server" class="form-control border-input" DataSourceID="SqlGroup"
                                    DataTextField="Group" DataValueField="GroupID" required="required">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlGroup" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                    SelectCommand="SELECT GroupID, [Group] FROM Groups ORDER BY [Group]">
                                </asp:SqlDataSource>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                     </div>
                    <%
                    End If
                    %>
                        <div class="row">
                             <div class="col-md-4">
                                 <label> Review Date Begin</label>
                                  <div class="form-group input-group">
                                    <asp:TextBox ID="ReviewDateBegin" runat="server" class="form-control border-input" required="required" placeholder="Review Begin Date" />
                                    <ajaxToolkit:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="ReviewDateBegin" Format="MM/dd/yyyy" />
                                    <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span> </span>
                                  </div>
                             </div>
                            <div class="col-md-4"></div>
                            <div class="col-md-4">
                             <label>  Review Date End</label>
                             <div class="form-group input-group">
                                 <asp:TextBox ID="ReviewDateEnd" runat="server" class="form-control border-input" required="required" placeholder="Review Date End" />
                                 <ajaxToolkit:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="ReviewDateEnd" Format="MM/dd/yyyy" />
                                 <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span> </span>
                             </div>
                            </div>
                        </div>
                        <hr />
                       <div class="text-center">
                        <asp:Button ID="btnFilterReport" runat="server" class="btn btn-info btn-fill btn-wd" Text="Filter" />

                        <%
                            If Not sessionRoleID = HOUSING_SPECALIST Then
                         %>
                         <asp:Button ID="btnExportToExcel" runat="server" class="btn btn-info btn-fill btn-wd" Text="Export To Excel" />
                         <%
                            End If
                         %>
                       </div>
                     <div class="clearfix"></div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <asp:SqlDataSource ID="SqlStatisticalReview" runat="server" 
        ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
        
        SelectCommand="SELECT COUNT(FileID) AS TotalReviews, 
                    (SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors) AS TotalReviewsWithErrors, 
                    ROUND((SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_42) * 100.0 / ISNULL(NULLIF ((SELECT COUNT(FileID) AS Expr1 FROM Files AS Files_46), 0), 1), 3) AS TotalReviewsWithErrorsPercent, 
                    (SELECT COUNT(FileID) AS Expr1 FROM Files AS Files_45) - (SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_41) AS TotalReviewsWithNoErrors, ROUND(((SELECT COUNT(FileID) AS Expr1 FROM Files AS Files_44) - (SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_40)) * 100.0 / ISNULL(NULLIF ((SELECT COUNT(FileID) AS Expr1 FROM Files AS Files_43), 0), 1), 3) AS TotalReviewsWithNoErrorsPercent, (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_39 WHERE (Status = 'Pending')) AS TotalNumberOfPendingErrors, (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_38 WHERE (Status = 'Complete')) AS TotalNumberOfCompleteErrors, (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_37) AS TotalNumberOfAllErrors, (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_53 WHERE (fk_NoticeTypeID = '1')) AS TotalNumberOfNoticeTypeError, (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_52 WHERE (fk_NoticeTypeID = '2')) AS TotalNumberOfNoticeTypeWarning, (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_51 WHERE (fk_NoticeTypeID = '3')) AS TotalNumberOfNoticeTypeMissing, (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_49 WHERE (fk_NoticeTypeID = '5')) AS TotalNumberOfNoticeTypeOther, (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_48 WHERE (fk_NoticeTypeID = '6')) AS TotalNumberOfNoticeTypeIncome, (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_47 WHERE (fk_NoticeTypeID = '7')) AS TotalNumberOfNoticeTypeAdjustedIncome, (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_46 WHERE (fk_NoticeTypeID = '8')) AS TotalNumberOfNoticeTypePaymentStandard, (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_45 WHERE (fk_NoticeTypeID = '9')) AS TotalNumberOfNoticeTypeUtilityAllowance, (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_44 WHERE (fk_NoticeTypeID = '10')) AS TotalNumberOfNoticeTypeContractRent, (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_43 WHERE (fk_NoticeTypeID = '11')) AS TotalNumberOfNoticeTypeIncomeOrAdjustedRent, (SELECT COUNT(*) AS NumberOfReviewsWithVerificationType FROM (SELECT FileID FROM Files AS Files_42 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses WHERE (fk_ProcessTypeID = '1')))) AS Files) AS TotalNumberOfReviewsWithVerification, (SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_36 WHERE (fk_ProcessTypeID = '1')) AS TotalNumberOfReviewsWithVerificationErrors, ROUND((SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_35 WHERE (fk_ProcessTypeID = '1')) * 100.0 / ISNULL(NULLIF ((SELECT COUNT(*) AS NumberOfReviewsWithVerificationType FROM (SELECT FileID FROM Files AS Files_41 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_33 WHERE (fk_ProcessTypeID = '1')))) AS Files_79), 0), 1), 3) AS PercentOfReviewsWithVerificationErrors, (SELECT COUNT(*) AS NumberOfReviewsWithCalculationType FROM (SELECT FileID FROM Files AS Files_40 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_32 WHERE (fk_ProcessTypeID = '2')))) AS Files_78) AS TotalNumberOfReviewsWithCalculation, (SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_34 WHERE (fk_ProcessTypeID = '2')) AS TotalNumberOfReviewsWithCalculationErrors, ROUND((SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_33 WHERE (fk_ProcessTypeID = '2')) * 100.0 / ISNULL(NULLIF ((SELECT COUNT(*) AS NumberOfReviewsWithCalculationType FROM (SELECT FileID FROM Files AS Files_39 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_31 WHERE (fk_ProcessTypeID = '2')))) AS Files_77), 0), 1), 3) AS PercentOfReviewsWithCalculationErrors, (SELECT COUNT(*) AS NumberOfReviewsWithPaymentStandardType FROM (SELECT FileID FROM Files AS Files_38 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_30 WHERE (fk_ProcessTypeID = '3')))) AS Files_76) AS TotalNumberOfReviewsWithPaymentStandard, (SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_32 WHERE (fk_ProcessTypeID = '3')) AS TotalNumberOfReviewsWithPaymentStandardErrors, ROUND((SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_31 WHERE (fk_ProcessTypeID = '3')) * 100.0 / ISNULL(NULLIF ((SELECT COUNT(*) AS NumberOfReviewsWithPaymentStandardType FROM (SELECT FileID FROM Files AS Files_37 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_29 WHERE (fk_ProcessTypeID = '3')))) AS Files_75), 0), 1), 3) AS PercentOfReviewsWithPaymentStandardErrors, (SELECT COUNT(*) AS NumberOfReviewsWithUtilityAllowance FROM (SELECT FileID FROM Files AS Files_36 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_28 WHERE (fk_ProcessTypeID = '4')))) AS Files_74) AS TotalNumberOfReviewsWithUtilityAllowance, (SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_30 WHERE (fk_ProcessTypeID = '4')) AS TotalNumberOfReviewsWithUtilityAllowanceErrors, ROUND((SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_29 WHERE (fk_ProcessTypeID = '4')) * 100.0 / ISNULL(NULLIF ((SELECT COUNT(*) AS NumberOfReviewsWithUtilityAllowanceType FROM (SELECT FileID FROM Files AS Files_35 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_27 WHERE (fk_ProcessTypeID = '4')))) AS Files_73), 0), 1), 3) AS PercentOfReviewsWithUtilityAllowanceErrors, (SELECT COUNT(*) AS NumberOfReviewsWithTenantRent FROM (SELECT FileID FROM Files AS Files_34 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_26 WHERE (fk_ProcessTypeID = '5')))) AS Files_72) AS TotalNumberOfReviewsWithTenantRent, (SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_28 WHERE (fk_ProcessTypeID = '5')) AS TotalNumberOfReviewsWithTenantRentErrors, ROUND((SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_27 WHERE (fk_ProcessTypeID = '5')) * 100.0 / ISNULL(NULLIF ((SELECT COUNT(*) AS NumberOfReviewsWithTenantRentType FROM (SELECT FileID FROM Files AS Files_33 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_25 WHERE (fk_ProcessTypeID = '5')))) AS Files_71), 0), 1), 3) AS PercentOfReviewsWithTenantRentErrors, (SELECT COUNT(*) AS NumberOfReviewsWithOccupanyStandard FROM (SELECT FileID FROM Files AS Files_32 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_24 WHERE (fk_ProcessTypeID = '6')))) AS Files_70) AS TotalNumberOfReviewsWithOccupanyStandard, (SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_26 WHERE (fk_ProcessTypeID = '6')) AS TotalNumberOfReviewsWithOccupanyStandardErrors, ROUND((SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_25 WHERE (fk_ProcessTypeID = '6')) * 100.0 / ISNULL(NULLIF ((SELECT COUNT(*) AS NumberOfReviewsWithOccupanyStandardType FROM (SELECT FileID FROM Files AS Files_31 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_23 WHERE (fk_ProcessTypeID = '6')))) AS Files_69), 0), 1), 3) AS PercentOfReviewsWithOccupanyStandardErrors, (SELECT COUNT(*) AS NumberOfReviewsWithAnnualReexamination FROM (SELECT FileID FROM Files AS Files_30 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_22 WHERE (fk_ProcessTypeID = '7')))) AS Files_68) AS TotalNumberOfReviewsWithAnnualReexamination, (SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_24 WHERE (fk_ProcessTypeID = '7')) AS TotalNumberOfReviewsWithAnnualReexaminationErrors, ROUND((SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_23 WHERE (fk_ProcessTypeID = '7')) * 100.0 / ISNULL(NULLIF ((SELECT COUNT(*) AS NumberOfReviewsWithAnnualReexaminationType FROM (SELECT FileID FROM Files AS Files_29 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_21 WHERE (fk_ProcessTypeID = '7')))) AS Files_67), 0), 1), 3) AS PercentOfReviewsWithAnnualReexaminationErrors, (SELECT COUNT(*) AS NumberOfReviewsWithInterimReexamination FROM (SELECT FileID FROM Files AS Files_28 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_20 WHERE (fk_ProcessTypeID = '8')))) AS Files_66) AS TotalNumberOfReviewsWithInterimReexamination, (SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_22 WHERE (fk_ProcessTypeID = '8')) AS TotalNumberOfReviewsWithInterimReexaminationErrors, ROUND((SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_21 WHERE (fk_ProcessTypeID = '8')) * 100.0 / ISNULL(NULLIF ((SELECT COUNT(*) AS NumberOfReviewsWithInterimReexaminationType FROM (SELECT FileID FROM Files AS Files_27 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_19 WHERE (fk_ProcessTypeID = '8')))) AS Files_65), 0), 1), 3) AS PercentOfReviewsWithInterimReexaminationErrors, (SELECT COUNT(*) AS NumberOfReviewsWithMoves FROM (SELECT FileID FROM Files AS Files_26 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_18 WHERE (fk_ProcessTypeID = '9')))) AS Files_64) AS TotalNumberOfReviewsWithMoves, (SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_20 WHERE (fk_ProcessTypeID = '9')) AS TotalNumberOfReviewsWithMovesErrors, ROUND((SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_19 WHERE (fk_ProcessTypeID = '9')) * 100.0 / ISNULL(NULLIF ((SELECT COUNT(*) AS NumberOfReviewsWithMovesType FROM (SELECT FileID FROM Files AS Files_25 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_17 WHERE (fk_ProcessTypeID = '9')))) AS Files_63), 0), 1), 3) AS PercentOfReviewsWithMovesErrors, (SELECT COUNT(*) AS NumberOfReviewsWithChangeInFamilyComposition FROM (SELECT FileID FROM Files AS Files_24 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_16 WHERE (fk_ProcessTypeID = '10')))) AS Files_62) AS TotalNumberOfReviewsWithChangeInFamilyComposition, (SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_18 WHERE (fk_ProcessTypeID = '10')) AS TotalNumberOfReviewsWithChangeInFamilyCompositionErrors, ROUND((SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_17 WHERE (fk_ProcessTypeID = '10')) * 100.0 / ISNULL(NULLIF ((SELECT COUNT(*) AS NumberOfReviewsWithChangeInFamilyCompositionType FROM (SELECT FileID FROM Files AS Files_23 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_15 WHERE (fk_ProcessTypeID = '10')))) AS Files_61), 0), 1), 3) AS PercentOfReviewsWithChangeInFamilyCompositionErrors, (SELECT COUNT(*) AS NumberOfReviewsWithEligibilityAndScreening FROM (SELECT FileID FROM Files AS Files_22 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_14 WHERE (fk_ProcessTypeID = '11')))) AS Files_60) AS TotalNumberOfReviewsWithEligibilityAndScreening, (SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_16 WHERE (fk_ProcessTypeID = '11')) AS TotalNumberOfReviewsWithEligibilityAndScreeningErrors, ROUND((SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_15 WHERE (fk_ProcessTypeID = '11')) * 100.0 / ISNULL(NULLIF ((SELECT COUNT(*) AS NumberOfReviewsWithEligibilityAndScreeningType FROM (SELECT FileID FROM Files AS Files_21 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_13 WHERE (fk_ProcessTypeID = '11')))) AS Files_59), 0), 1), 3) AS PercentOfReviewsWithEligibilityAndScreeningErrors, (SELECT COUNT(*) AS NumberOfReviewsWithLeasing FROM (SELECT FileID FROM Files AS Files_20 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_12 WHERE (fk_ProcessTypeID = '12')))) AS Files_58) AS TotalNumberOfReviewsWithLeasing, (SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_14 WHERE (fk_ProcessTypeID = '12')) AS TotalNumberOfReviewsWithLeasingErrors, ROUND((SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_13 WHERE (fk_ProcessTypeID = '12')) * 100.0 / ISNULL(NULLIF ((SELECT COUNT(*) AS NumberOfReviewsWithLeasingType FROM (SELECT FileID FROM Files AS Files_19 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_11 WHERE (fk_ProcessTypeID = '12')))) AS Files_57), 0), 1), 3) AS PercentOfReviewsWithLeasingErrors, (SELECT COUNT(*) AS NumberOfReviewsWithDataEntry FROM (SELECT FileID FROM Files AS Files_18 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_10 WHERE (fk_ProcessTypeID = '13')))) AS Files_56) AS TotalNumberOfReviewsWithDataEntry, (SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_12 WHERE (fk_ProcessTypeID = '13')) AS TotalNumberOfReviewsWithDataEntryErrors, ROUND((SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_11 WHERE (fk_ProcessTypeID = '13')) * 100.0 / ISNULL(NULLIF ((SELECT COUNT(*) AS NumberOfReviewsWithDataEntryType FROM (SELECT FileID FROM Files AS Files_17 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_9 WHERE (fk_ProcessTypeID = '13')))) AS Files_55), 0), 1), 3) AS PercentOfReviewsWithDataEntryErrors, (SELECT COUNT(*) AS NumberOfReviewsWithOther FROM (SELECT FileID FROM Files AS Files_16 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_8 WHERE (fk_ProcessTypeID = '21')))) AS Files_54) AS TotalNumberOfReviewsWithOther, (SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_10 WHERE (fk_ProcessTypeID = '21')) AS TotalNumberOfReviewsWithOtherErrors, ROUND((SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_9 WHERE (fk_ProcessTypeID = '21')) * 100.0 / ISNULL(NULLIF ((SELECT COUNT(*) AS NumberOfReviewsWithOtherType FROM (SELECT FileID FROM Files AS Files_15 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_7 WHERE (fk_ProcessTypeID = '21')))) AS Files_53), 0), 1), 3) AS PercentOfReviewsWithOtherErrors, (SELECT COUNT(*) AS NumberOfReviewsWithSelectionFromTheWaitlist FROM (SELECT FileID FROM Files AS Files_14 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_6 WHERE (fk_ProcessTypeID = '22')))) AS Files_52) AS TotalNumberOfReviewsWithSelectionFromTheWaitlist, (SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_8 WHERE (fk_ProcessTypeID = '22')) AS TotalNumberOfReviewsWithSelectionFromTheWaitlistErrors, ROUND((SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_7 WHERE (fk_ProcessTypeID = '22')) * 100.0 / ISNULL(NULLIF ((SELECT COUNT(*) AS NumberOfReviewsWithSelectionFromTheWaitlistType FROM (SELECT FileID FROM Files AS Files_13 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_5 WHERE (fk_ProcessTypeID = '22')))) AS Files_51), 0), 1), 3) AS PercentOfReviewsWithSelectionFromTheWaitlistErrors, (SELECT COUNT(*) AS NumberOfReviewsWithReasonableRent FROM (SELECT FileID FROM Files AS Files_12 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_4 WHERE (fk_ProcessTypeID = '15')))) AS Files_50) AS TotalNumberOfReviewsWithReasonableRent, (SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_6 WHERE (fk_ProcessTypeID = '15')) AS TotalNumberOfReviewsWithReasonableRentErrors, ROUND((SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_5 WHERE (fk_ProcessTypeID = '15')) * 100.0 / ISNULL(NULLIF ((SELECT COUNT(*) AS NumberOfReviewsWithReasonableRentType FROM (SELECT FileID FROM Files AS Files_11 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_3 WHERE (fk_ProcessTypeID = '15')))) AS Files_49), 0), 1), 3) AS PercentOfReviewsWithReasonableRentErrors, (SELECT COUNT(*) AS NumberOfReviewsWithPortability FROM (SELECT FileID FROM Files AS Files_10 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_2 WHERE (fk_ProcessTypeID = '16')))) AS Files_48) AS TotalNumberOfReviewsWithPortability, (SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_4 WHERE (fk_ProcessTypeID = '16')) AS TotalNumberOfReviewsWithPortabilityErrors, ROUND((SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_3 WHERE (fk_ProcessTypeID = '16')) * 100.0 / ISNULL(NULLIF ((SELECT COUNT(*) AS NumberOfReviewsWithPortabilityType FROM (SELECT FileID FROM Files AS Files_9 WHERE (fk_ReviewTypeID IN (SELECT fk_ReviewTypeID FROM ReviewTypesProcesses AS ReviewTypesProcesses_1 WHERE (fk_ProcessTypeID = '16')))) AS Files_47), 0), 1), 3) AS PercentOfReviewsWithPortabilityErrors, (SELECT COUNT(FileID) AS Expr1 FROM Files AS Files_8 WHERE (fk_ReviewTypeID = '7')) AS TotalNumberOfReviewsWithLotteryNumber, (SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM LotteryNumberErrors) AS TotalNumberOfReviewsWithLotteryNumberErrors, ROUND((SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM LotteryNumberErrors AS LotteryNumberErrors_1) * 100.0 / ISNULL(NULLIF ((SELECT COUNT(FileID) AS Expr1 FROM Files AS Files_7 WHERE (fk_ReviewTypeID = '7')), 0), 1), 3) AS PercentOfReviewsWithLotteryNumberErrors, (SELECT COUNT(FileID) AS Expr1 FROM Files AS Files_6 WHERE (fk_ReviewTypeID = '7')) AS TotalNumberOfReviewsWithPortIn, (SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM SpecialCaseErrors WHERE (fk_ErrorTypeID = '20')) AS TotalNumberOfReviewsWithPortInErrors, ROUND((SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM SpecialCaseErrors AS SpecialCaseErrors_3 WHERE (fk_ErrorTypeID = '20')) * 100.0 / ISNULL(NULLIF ((SELECT COUNT(FileID) AS Expr1 FROM Files AS Files_5 WHERE (fk_ReviewTypeID = '7')), 0), 1), 3) AS PercentOfReviewsWithPortInErrors, (SELECT COUNT(FileID) AS Expr1 FROM Files AS Files_4 WHERE (fk_ReviewTypeID = '7')) AS TotalNumberOfReviewsWithSpecialAdmission, (SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM SpecialCaseErrors AS SpecialCaseErrors_2 WHERE (fk_ErrorTypeID = '19')) AS TotalNumberOfReviewsWithSpecialAdmissionErrors, ROUND((SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM SpecialCaseErrors AS SpecialCaseErrors_1 WHERE (fk_ErrorTypeID = '19')) * 100.0 / ISNULL(NULLIF ((SELECT COUNT(FileID) AS Expr1 FROM Files AS Files_3 WHERE (fk_ReviewTypeID = '7')), 0), 1), 3) AS PercentOfReviewsWithSpecialAdmissionErrors, (SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_2 WHERE (fk_ProcessTypeID = '18')) AS TotalNumberOfReviewsWithDocumentErrors, ROUND((SELECT COUNT(DISTINCT fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_1 WHERE (fk_ProcessTypeID = '18')) * 100.0 / ISNULL(NULLIF ((SELECT COUNT(FileID) AS Expr1 FROM Files AS Files_2), 0), 1), 3) AS PercentOfReviewsWithDocumentErrors FROM Files AS Files_1">
    </asp:SqlDataSource>

    <div class="row">
        <div class="col-lg-12">
            <div class="card">
                <div class="header">
                    <h4 class="title"><i class="fa fa-signal" aria-hidden="true"></i> Statistics</h4>
                    <hr />
                </div>
                <div class="content">
                    <div class="panel panel-success">
                        <div class="panel-heading">
                            <h3 class="panel-title">  <i class="fa fa-signal" aria-hidden="true"></i> Statistics</h3>
                        </div>
                    
                     <asp:ListView ID="Summary" runat="server" DataSourceID="SqlStatisticalReview" ItemPlaceholderID="itemPlaceholderSummary">
                            <LayoutTemplate>
                                <table class="table table-bordered">
                                    <tbody>
                                        <asp:PlaceHolder ID="itemPlaceholderSummary" runat="server" />
                                    </tbody>
                                </table>
                            </LayoutTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td></td>
                                    <td class="text-center" colspan="2"></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td class="text-center">
                                        <strong># of Reviews</strong>
                                    </td>
                                    <td class="text-center">
                                        <strong>% of Reviews</strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <strong>Total Reviews</strong>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalReviews") %>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>
                                        <strong>Total Reviews with Errors</strong>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalReviewsWithErrors")%>
                                    </td>
                                    <td class="text-center">
                                        <%# decimal.Round(Eval("TotalReviewsWithErrorsPercent"), 3, MidpointRounding.AwayFromZero) %> %
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <strong>Total Reviews without Any Errors</strong>
                                    </td>
                                    <td class="text-center">
                                         <%# Eval("TotalReviewsWithNoErrors")%>
                                    </td>
                                    <td class="text-center">
                                        <%# decimal.Round(Eval("TotalReviewsWithNoErrorsPercent"), 3, MidpointRounding.AwayFromZero)%>  %
                                    </td>
                                </tr>
                                <tr>
                                    <td class="text-center" colspan="3"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <strong>Total Number of Pending Errors</strong>
                                    </td>
                                    <td class="text-center" colspan="2">
                                       <%# Eval("TotalNumberOfPendingErrors")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <strong>Total Number of Complete Errors</strong>
                                    </td>
                                    <td class="text-center" colspan="2">
                                        <%# Eval("TotalNumberOfCompleteErrors")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <strong>Total Number of Errors</strong>
                                    </td>
                                    <td class="text-center" colspan="2">
                                        <%# Eval("TotalNumberOfAllErrors")%>
                                    </td>
                                </tr>

                                <tr>
                                    <td class="text-center" colspan="3"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <strong>Error Types</strong>
                                    </td>
                                    <td class="text-center" colspan="2">
                                        <strong># of Error Types</strong>
                                    </td>
                                </tr>
                                 <tr>
                                    <td>
                                        <em>Error</em>
                                    </td>
                                    <td class="text-center" colspan="2">
                                        <%# Eval("TotalNumberOfNoticeTypeError")%>
                                    </td>
                                 </tr>
                                 <tr>
                                    <td>
                                        <em>Warning</em>
                                    </td>
                                    <td class="text-center" colspan="2">
                                         <%# Eval("TotalNumberOfNoticeTypeWarning")%>
                                    </td>
                                 </tr>
                                 <tr>
                                    <td>
                                        <em>Missing</em>
                                    </td>
                                    <td class="text-center" colspan="2">
                                         <%# Eval("TotalNumberOfNoticeTypeMissing")%>
                                    </td>
                                 </tr>
                                 <tr>
                                    <td>
                                        <em>Other</em>
                                    </td>
                                    <td class="text-center" colspan="2">
                                        <%# Eval("TotalNumberOfNoticeTypeOther")%>
                                    </td>
                                 </tr>
                                 <tr>
                                    <td>
                                        <em>Income</em>
                                    </td>
                                    <td class="text-center" colspan="2">
                                        <%# Eval("TotalNumberOfNoticeTypeIncome")%>
                                    </td>
                                 </tr>
                                 <tr>
                                    <td>
                                        <em>Adjusted Income</em>
                                    </td>
                                    <td class="text-center" colspan="2">
                                        <%# Eval("TotalNumberOfNoticeTypeAdjustedIncome")%>
                                    </td>
                                 </tr>
                                 <tr>
                                    <td>
                                        <em>Payment Standard</em>
                                    </td>
                                    <td class="text-center" colspan="2">
                                        <%# Eval("TotalNumberOfNoticeTypePaymentStandard")%>
                                    </td>
                                 </tr>
                                 <tr>
                                    <td>
                                        <em>Utility Allowance</em>
                                    </td>
                                    <td class="text-center" colspan="2">
                                        <%# Eval("TotalNumberOfNoticeTypeUtilityAllowance")%>
                                    </td>
                                 </tr>
                                 <tr>
                                    <td>
                                        <em>Contract Rent</em>
                                    </td>
                                    <td class="text-center" colspan="2">
                                        <%# Eval("TotalNumberOfNoticeTypeContractRent")%>
                                    </td>
                                 </tr>
                                 <tr>
                                    <td>
                                        <em>Income or Adjusted Rent</em>
                                    </td>
                                    <td class="text-center" colspan="2">
                                        <%# Eval("TotalNumberOfNoticeTypeIncomeOrAdjustedRent")%>
                                    </td>
                                 </tr>

                                <tr>
                                    <td></td>
                                </tr>
                            </ItemTemplate>
                        </asp:ListView>
                       
                       <asp:ListView ID="Composition" runat="server" DataSourceID="SqlStatisticalReview" ItemPlaceholderID="itemPlaceholderComposition">
                            <LayoutTemplate>
                                <table class="table table-bordered">
                                    <tbody>
                                        <asp:PlaceHolder ID="itemPlaceholderComposition" runat="server" />
                                    </tbody>
                                </table>
                            </LayoutTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td class="text-center" colspan="3"></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td class="text-center">
                                        <strong># of Reviews with Error Type</strong>
                                    </td>
                                    <td class="text-center">
                                        <strong># of Reviews With Errors</strong>
                                    </td>
                                    <td class="text-center">
                                        <strong>% of Reviews With Errors</strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="text-center" colspan="4"></td>
                                </tr>

                                <!-- Substantive -->
                                <tr>
                                    <td>
                                        <strong>Substantive</strong>
                                    </td>
                                    <td class="text-center" colspan="3"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <em>Verification</em>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithVerification")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithVerificationErrors")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Decimal.Round(Eval("PercentOfReviewsWithVerificationErrors"), 2, MidpointRounding.AwayFromZero)%> %
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <em>Calculation</em>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithCalculation")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithCalculationErrors")%>
                                    </td>
                                    <td class="text-center">
                                         <%# Decimal.Round(Eval("PercentOfReviewsWithCalculationErrors"), 2, MidpointRounding.AwayFromZero)%> %
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <em>Payment Standard</em>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithPaymentStandard")%>
                                    </td>
                                    <td class="text-center">
                                         <%# Eval("TotalNumberOfReviewsWithPaymentStandardErrors")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Decimal.Round(Eval("PercentOfReviewsWithPaymentStandardErrors"), 2, MidpointRounding.AwayFromZero)%> %
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <em>Utility Allowance</em>
                                    </td>
                                    <td class="text-center">
                                         <%# Eval("TotalNumberOfReviewsWithUtilityAllowance")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithUtilityAllowanceErrors")%>
                                    </td>
                                    <td class="text-center">
                                         <%# Decimal.Round(Eval("PercentOfReviewsWithUtilityAllowanceErrors"), 2, MidpointRounding.AwayFromZero)%> %
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <em>Tenant Rent</em>
                                    </td>
                                    <td class="text-center">
                                         <%# Eval("TotalNumberOfReviewsWithTenantRent")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithTenantRentErrors")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Decimal.Round(Eval("PercentOfReviewsWithTenantRentErrors"), 2, MidpointRounding.AwayFromZero)%> %
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <em>Occupancy Standard</em>
                                    </td>
                                    <td class="text-center">
                                         <%# Eval("TotalNumberOfReviewsWithOccupanyStandard")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithOccupanyStandardErrors")%>
                                    </td>
                                    <td class="text-center">
                                        <%# decimal.Round(Eval("PercentOfReviewsWithOccupanyStandardErrors"), 2, MidpointRounding.AwayFromZero) %> %
                                    </td>
                                </tr>

                                <tr>
                                    <td class="text-center" colspan="4"></td>
                                </tr>

                                <!-- Processing -->
                                <tr>
                                    <td>
                                        <strong>Processing</strong>
                                    </td>
                                    <td class="text-center" colspan="3"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <em>Annual Reexamination</em>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithAnnualReexamination")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithAnnualReexaminationErrors")%>
                                    </td>
                                    <td class="text-center">
                                        <%# decimal.Round(Eval("PercentOfReviewsWithAnnualReexaminationErrors"), 2, MidpointRounding.AwayFromZero) %> %
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <em>Interim Reexamination</em>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithInterimReexamination")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithInterimReexaminationErrors")%>
                                    </td>
                                    <td class="text-center">
                                       <%# decimal.Round(Eval("PercentOfReviewsWithInterimReexaminationErrors"), 2, MidpointRounding.AwayFromZero) %> %
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <em>Moves</em>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithMoves")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithMovesErrors")%>
                                    </td>
                                    <td class="text-center">
                                        <%# decimal.Round(Eval("PercentOfReviewsWithMovesErrors"), 2, MidpointRounding.AwayFromZero) %> %
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <em>Change in Family Composition</em>
                                    </td>
                                    <td class="text-center">
                                         <%# Eval("TotalNumberOfReviewsWithChangeInFamilyComposition")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithChangeInFamilyCompositionErrors")%>
                                    </td>
                                    <td class="text-center">
                                         <%# Decimal.Round(Eval("PercentOfReviewsWithChangeInFamilyCompositionErrors"), 2, MidpointRounding.AwayFromZero)%> %
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <em>Eligibility and Screening</em>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithEligibilityAndScreening")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithEligibilityAndScreeningErrors")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Decimal.Round(Eval("PercentOfReviewsWithEligibilityAndScreeningErrors"), 2, MidpointRounding.AwayFromZero)%> %
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <em>Leasing</em>
                                    </td>
                                    <td class="text-center">
                                         <%# Eval("TotalNumberOfReviewsWithLeasing")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithLeasingErrors")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Decimal.Round(Eval("PercentOfReviewsWithLeasingErrors"), 2, MidpointRounding.AwayFromZero)%> %
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <em>Data Entry</em>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithDataEntry")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithDataEntryErrors")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Decimal.Round(Eval("PercentOfReviewsWithDataEntryErrors"), 2, MidpointRounding.AwayFromZero)%> %
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <em>Other</em>
                                    </td>
                                    <td class="text-center">
                                         <%# Eval("TotalNumberOfReviewsWithOther")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithOtherErrors")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Decimal.Round(Eval("PercentOfReviewsWithOtherErrors"), 2, MidpointRounding.AwayFromZero)%> %
                                    </td>
                                </tr>

                                <tr>
                                    <td class="text-center" colspan="4"></td>
                                </tr>

                                <!-- Targeted -->
                                <tr>
                                    <td>
                                        <strong>Targeted</strong>
                                    </td>
                                    <td class="text-center" colspan="3"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <em>Selection from the Waiting List</em>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithSelectionFromTheWaitlist")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithSelectionFromTheWaitlistErrors")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Decimal.Round(Eval("PercentOfReviewsWithSelectionFromTheWaitlistErrors"), 2, MidpointRounding.AwayFromZero)%> %
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <em>Reasonable Rent</em>
                                    </td>
                                    <td class="text-center">
                                         <%# Eval("TotalNumberOfReviewsWithReasonableRent")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithReasonableRentErrors")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Decimal.Round(Eval("PercentOfReviewsWithReasonableRentErrors"), 2, MidpointRounding.AwayFromZero)%> %
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <em>Portability</em>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithPortability")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithPortabilityErrors")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Decimal.Round(Eval("PercentOfReviewsWithPortabilityErrors"), 2, MidpointRounding.AwayFromZero)%> %
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <em>Lottery Number</em>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithLotteryNumber")%>
                                    </td>
                                    <td class="text-center">
                                         <%# Eval("TotalNumberOfReviewsWithLotteryNumberErrors")%>
                                    </td>
                                    <td class="text-center">
                                         <%# Decimal.Round(Eval("PercentOfReviewsWithLotteryNumberErrors"), 2, MidpointRounding.AwayFromZero)%> %
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <em>Port In</em>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithPortIn")%>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithPortInErrors")%>
                                    </td>
                                    <td class="text-center">
                                         <%# Decimal.Round(Eval("PercentOfReviewsWithPortInErrors"), 2, MidpointRounding.AwayFromZero)%> %
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <em>Special Admission</em>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithSpecialAdmission") %>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithSpecialAdmissionErrors")%>
                                    </td>
                                    <td class="text-center">
                                         <%# Decimal.Round(Eval("PercentOfReviewsWithSpecialAdmissionErrors"), 2, MidpointRounding.AwayFromZero)%> %
                                    </td>
                                </tr>
                                <tr>
                                    <td class="text-center" colspan="4">
                                    </td>
                                </tr>

                                <!-- Document -->
                                <tr>
                                    <td>
                                        <strong>Document</strong>
                                    </td>
                                    <td class="text-center" colspan="3"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <em>Document</em>
                                    </td>
                                    <td class="text-center">
                                       <%# Eval("TotalReviews") %>
                                    </td>
                                    <td class="text-center">
                                        <%# Eval("TotalNumberOfReviewsWithDocumentErrors")%>
                                    </td>
                                    <td class="text-center">
                                          <%# Decimal.Round(Eval("PercentOfReviewsWithDocumentErrors"), 2, MidpointRounding.AwayFromZero)%> %
                                    </td>
                                </tr>
                            </ItemTemplate>
                       </asp:ListView>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
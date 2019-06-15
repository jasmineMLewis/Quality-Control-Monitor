<%@ Page Title="QC :: Review List" Language="vb" AutoEventWireup="false" MasterPageFile="~/User.Master" CodeBehind="ReviewList.aspx.vb" Inherits="QualityControlMonitor.ReviewList" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="header">
                    <h4 class="title"><i class="fa fa-list-alt" aria-hidden="true"></i> List :: Review</h4>
                    <hr />
                </div>
                <div class="content">
                    <form id="Form1" runat="server">
                         <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
                         <div class="row">
                          <div class="col-md-4">
                            <label> Client First Name</label>
                            <div class="form-group">
                                <asp:TextBox ID="ClientFirstName" runat="server" class="form-control border-input"
                                     MaxLength="50" placeholder="Client First Name"></asp:TextBox>
                            </div>
                          </div>
                          <div class="col-md-4">
                            <label>Client Last Name</label>
                            <div class="form-group">
                                <asp:TextBox ID="ClientLastName" runat="server" class="form-control border-input"
                                     MaxLength="50" placeholder="Client Last Name"></asp:TextBox>
                            </div>
                          </div>
                          <div class="col-md-4">
                            <label>Elite ID</label>
                            <div class="form-group">
                                <asp:TextBox ID="EliteID" runat="server" class="form-control border-input"
                                     MaxLength="9" placeholder="Elite ID"></asp:TextBox>
                            </div>
                          </div>
                         </div>
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

                               Dim sessionRoleID As Integer
                               Dim query As New SqlCommand("SELECT fk_RoleID FROM Users WHERE UserID  = '" & sessionUserID & "'", conn)
                               Dim reader As SqlDataReader = query.ExecuteReader()
                               While reader.Read
                                   sessionRoleID = CStr(reader("fk_RoleID"))
                               End While
                               conn.Close()

                               Const AUDITEE As Integer = 3

                               If Not sessionRoleID = AUDITEE Then
                                %>
                                <div class="row">
                                     <div class="col-md-4">
                                      <label>File Housing Specialist</label>
                                     <div class="form-group input-group">
                                <asp:DropDownList ID="FileStaff" runat="server" class="form-control border-input"
                                    DataSourceID="SqlFileStaff" DataValueField="UserID" DataTextField="FullName" required="required"></asp:DropDownList>
                                <asp:SqlDataSource ID="SqlFileStaff" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                    SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                </asp:SqlDataSource>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                                     </div>
                                 <div class="col-md-4">
                                     <label>Auditor</label>
                                     <div class="form-group input-group">
                                <asp:DropDownList ID="Auditor" runat="server" class="form-control border-input"
                                    DataSourceID="SqlAuditor" DataValueField="UserID" DataTextField="FullName" required="required"></asp:DropDownList>
                                <asp:SqlDataSource ID="SqlAuditor" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                    SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '2' OR [fk_RoleID] = '1' ORDER BY [FirstName] ASC">
                                </asp:SqlDataSource>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                                 </div>
                                 <div class="col-md-4">
                                     <label>Group</label>
                                  <div class="form-group input-group">
                                    <asp:DropDownList ID="Group" runat="server" class="form-control border-input" 
                                        DataSourceID="SqlGroup" DataTextField="Group" DataValueField="GroupID" required="required">
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="SqlGroup" runat="server" 
                                        ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                        SelectCommand="SELECT GroupID, [Group] FROM Groups ORDER BY [Group]"></asp:SqlDataSource>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span> </span>
                               </div>
                                 </div>
                                </div>
                           <%
                           End If
                           %>

                         <div class="row">
                           <div class="col-md-4">
                            <label>Review Date Begin</label>
                                 <asp:TextBox ID="ReviewDateBegin" runat="server" class="form-control border-input"  placeholder="Review Begin Date"  />
                                 <ajaxToolkit:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="ReviewDateBegin" Format="MM/dd/yyyy" />
                           </div>
                           <div class="col-md-4">
                             <label>Review Date End</label>
                                 <asp:TextBox ID="ReviewDateEnd" runat="server" class="form-control border-input" placeholder="Review Date End"/>
                                 <ajaxToolkit:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="ReviewDateEnd" Format="MM/dd/yyyy" />
                           </div>
                           <div class="col-md-4">
                            <label>Review Type</label>
                            <div class="form-group input-group">
                                <asp:DropDownList ID="ReviewType" runat="server" class="form-control border-input" required="required"
                                    DataSourceID="SqlReviewType" DataTextField="Review" DataValueField="ReviewTypeID">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlReviewType" runat="server"
                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                    SelectCommand="SELECT [ReviewTypeID], [Review] FROM [ReviewTypes] ORDER By [Review] ASC">
                                </asp:SqlDataSource>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span> </span>
                            </div>
                           </div>
                         </div>
                          <hr />
                          <div class="text-center">
                                <asp:Button ID="btnFilterReport" runat="server" class="btn btn-info btn-fill btn-wd" Text="Filter" />
                   <%--                      <%
                            If Not sessionRoleID = HOUSING_SPECALIST Then
                         %>--%>
                         <asp:Button ID="btnExportToExcel" runat="server" class="btn btn-info btn-fill btn-wd" Text="Export To Excel" />
                       <%--  <%
                            End If
                         %>--%>
                          </div>
                          <div class="clearfix"></div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
        ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
        SelectCommand="SELECT Files.FileID, Files.ClientFirstName + ' ' + Files.ClientLastName AS Client,
                              fk_CaseManagerID AS FileStaffID,
                              Files.EliteID, FileStaff.FirstName + ' ' + FileStaff.LastName AS FileStaffName,
                              GroupID, Groups.[Group], Files.fk_ReviewTypeID, ReviewTypes.Review,
                              CONVERT (varchar(MAX), CAST(Files.ReviewDate AS date), 101) AS ReviewDate, 
                              CONVERT (varchar(MAX), CAST(Files.EffectiveDate AS date), 101) AS EffectiveDate, 
                              Auditor.FirstName + ' ' + Auditor.LastName AS AuditorName, 
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors WHERE (fk_FileID = Files.FileID)) + 
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM LotteryNumberErrors WHERE (fk_FileID = Files.FileID)) +
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM SpecialCaseErrors WHERE (fk_FileID = Files.FileID) AND (fk_ErrorTypeID = '19')) + 
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM SpecialCaseErrors AS SpecialCaseErrors_3 WHERE (fk_FileID = Files.FileID) AND (fk_ErrorTypeID = '20')) AS TotalErrors, 
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_19 WHERE (fk_FileID = Files.FileID) AND (fk_ProcessTypeID = '1')) AS Verification, 
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_18 WHERE (fk_FileID = Files.FileID) AND (fk_ProcessTypeID = '2')) AS Calculation, 
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_17 WHERE (fk_FileID = Files.FileID) AND (fk_ProcessTypeID = '3')) AS PaymentStandard, 
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_16 WHERE (fk_FileID = Files.FileID) AND (fk_ProcessTypeID = '4')) AS UtilityAllowance, 
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_15 WHERE (fk_FileID = Files.FileID) AND (fk_ProcessTypeID = '5')) AS TenantRent, 
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_14 WHERE (fk_FileID = Files.FileID) AND (fk_ProcessTypeID = '6')) AS OccupanyStandard, 
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_13 WHERE (fk_FileID = Files.FileID) AND (fk_ProcessTypeID = '7')) AS AnnualReexamination, 
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_12 WHERE (fk_FileID = Files.FileID) AND (fk_ProcessTypeID = '8')) AS InterimReexamination, 
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_11 WHERE (fk_FileID = Files.FileID) AND (fk_ProcessTypeID = '9')) AS Moves, 
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_10 WHERE (fk_FileID = Files.FileID) AND (fk_ProcessTypeID = '10')) AS ChangeInFamilyComposition, 
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_9 WHERE (fk_FileID = Files.FileID) AND (fk_ProcessTypeID = '11')) AS EligibilityAndScreening, 
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_8 WHERE (fk_FileID = Files.FileID) AND (fk_ProcessTypeID = '12')) AS Leasing,
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_7 WHERE (fk_FileID = Files.FileID) AND (fk_ProcessTypeID = '13')) AS DataEntry, 
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM LotteryNumberErrors AS LotteryNumberErrors_1 WHERE (fk_FileID = Files.FileID)) AS LotteryNumber, 
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_6 WHERE (fk_FileID = Files.FileID) AND (fk_ProcessTypeID = '15')) AS ReasonableRent,
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_5 WHERE (fk_FileID = Files.FileID) AND (fk_ProcessTypeID = '16')) AS Portability, 
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_4 WHERE (fk_FileID = Files.FileID) AND (fk_ProcessTypeID = '17')) AS OwnerCertification, 
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_3 WHERE (fk_FileID = Files.FileID) AND (fk_ProcessTypeID = '18')) AS Document, 
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM SpecialCaseErrors AS SpecialCaseErrors_2 WHERE (fk_FileID = Files.FileID) AND (fk_ErrorTypeID = '19')) AS SpecialAdmission, 
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM SpecialCaseErrors AS SpecialCaseErrors_1 WHERE (fk_FileID = Files.FileID) AND (fk_ErrorTypeID = '20')) AS PortIn, 
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_2 WHERE (fk_FileID = Files.FileID) AND (fk_ProcessTypeID = '21')) AS Other, 
                              (SELECT COUNT(fk_FileID) AS Expr1 FROM FileErrors AS FileErrors_1 WHERE (fk_FileID = Files.FileID) AND (fk_ProcessTypeID = '22')) AS SelectionFromTheWaitlist
                        FROM Files 
                        INNER JOIN Users AS FileStaff ON Files.fk_CaseManagerID = FileStaff.UserID 
                        INNER JOIN ReviewTypes ON Files.fk_ReviewTypeID = ReviewTypes.ReviewTypeID 
                        INNER JOIN Users AS Auditor ON Files.fk_AudtitorID = Auditor.UserID
                        INNER JOIN Groups ON FileStaff.fk_GroupID = Groups.GroupID">
    </asp:SqlDataSource>

    <div class="row">
        <div class="col-lg-12">
            <div class="card">
                <div class="header">
                    <h4 class="title"><i class="fa fa-list-alt" aria-hidden="true"></i> Listings</h4>
                    <hr />
                </div>
                <div class="content">
                  <div class="panel panel-success">
                        <div class="panel-heading">
                            <h3 class="panel-title"> <i class="fa fa-list-alt" aria-hidden="true"></i> Listings</h3>
                        </div>
                        <div class="table-responsive">
                            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="table"
                                DataKeyNames="fk_ReviewTypeID, FileID" GridLines="None" DataSourceID="SqlDataSource1">
                                <Columns>
                                 <asp:TemplateField HeaderText="Client">
                                     <ItemTemplate> 
                                        <%# DisplayFileLink(Eval("fk_ReviewTypeID"), Eval("Client"), Eval("FileID"), Request.QueryString("SessionUserID"))%>
                                     </ItemTemplate>
                                 </asp:TemplateField>  
                                 <asp:BoundField DataField="EliteID" HeaderText="Elite ID" 
                                        SortExpression="EliteID" /> 
                                 <asp:BoundField DataField="FileStaffName" HeaderText="Housing Specialist"  
                                        SortExpression="FileStaffName" /> 
                                 <asp:BoundField DataField="Group" HeaderText="Group" 
                                        SortExpression="Group" /> 
                                 <asp:BoundField DataField="Review" HeaderText="Review" SortExpression="Review" /> 
                                 <asp:BoundField DataField="ReviewDate" HeaderText="Review Date" 
                                        SortExpression="ReviewDate" /> 
                                 <asp:BoundField DataField="EffectiveDate" HeaderText="Effective Date" 
                                        SortExpression="EffectiveDate" /> 
                                 <asp:BoundField DataField="AuditorName" HeaderText="Auditor" 
                                        SortExpression="AuditorName"  /> 
                                 <asp:TemplateField HeaderText="Total Errors">
                                     <ItemTemplate> 
                                         <asp:HyperLink ID="LinkTotalErrors" runat="server"
                                                NavigateUrl='<%# String.Format("~/ErrorReport.aspx?SessionUserID={0}&FileID={1}&ReviewTypeID={2}", Request.QueryString("SessionUserID"), Eval("FileID"), Eval("fk_ReviewTypeID"))  %>'
                                             Text='<%# Eval("TotalErrors") %>'>
                                         </asp:HyperLink>
                                     </ItemTemplate>
                                 </asp:TemplateField>  
                                  <asp:TemplateField HeaderText="Verification">
                                     <ItemTemplate> 
                                         <asp:HyperLink ID="LinkVerification" runat="server"
                                                NavigateUrl='<%# String.Format("~/ErrorReport.aspx?SessionUserID={0}&FileID={1}&ReviewTypeID={2}&ProcessTypeID=1", Request.QueryString("SessionUserID"), Eval("FileID"), Eval("fk_ReviewTypeID"))  %>'
                                             Text='<%# Eval("Verification") %>'>
                                         </asp:HyperLink>
                                     </ItemTemplate>
                                  </asp:TemplateField> 
                                  <asp:TemplateField HeaderText="Calculation">
                                     <ItemTemplate> 
                                         <asp:HyperLink ID="LinkCalculation" runat="server"
                                                NavigateUrl='<%# String.Format("~/ErrorReport.aspx?SessionUserID={0}&FileID={1}&ReviewTypeID={2}&ProcessTypeID=2", Request.QueryString("SessionUserID"), Eval("FileID"), Eval("fk_ReviewTypeID"))  %>'
                                             Text='<%# Eval("Calculation") %>'>
                                         </asp:HyperLink>
                                     </ItemTemplate>
                                  </asp:TemplateField> 
                                  <asp:TemplateField HeaderText="Payment Standard">
                                     <ItemTemplate> 
                                         <asp:HyperLink ID="LinkPaymentStandard" runat="server"
                                                NavigateUrl='<%# String.Format("~/ErrorReport.aspx?SessionUserID={0}&FileID={1}&&ReviewTypeID={2}&ProcessTypeID=3", Request.QueryString("SessionUserID"), Eval("FileID"), Eval("fk_ReviewTypeID"))  %>'
                                             Text='<%# Eval("PaymentStandard") %>'>
                                         </asp:HyperLink>
                                     </ItemTemplate>
                                  </asp:TemplateField> 
                                  <asp:TemplateField HeaderText="Utility Allowance">
                                     <ItemTemplate> 
                                         <asp:HyperLink ID="LinkUtilityAllowance" runat="server"
                                                NavigateUrl='<%# String.Format("~/ErrorReport.aspx?SessionUserID={0}&FileID={1}&ReviewTypeID={2}&ProcessTypeID=4", Request.QueryString("SessionUserID"), Eval("FileID"), Eval("fk_ReviewTypeID"))  %>'
                                             Text='<%# Eval("UtilityAllowance") %>'>
                                         </asp:HyperLink>
                                     </ItemTemplate>
                                  </asp:TemplateField> 
                                  <asp:TemplateField HeaderText="Tenant Rent">
                                     <ItemTemplate> 
                                         <asp:HyperLink ID="LinkTenantRent" runat="server"
                                                NavigateUrl='<%# String.Format("~/ErrorReport.aspx?SessionUserID={0}&FileID={1}&ReviewTypeID={2}&ProcessTypeID=5", Request.QueryString("SessionUserID"), Eval("FileID"), Eval("fk_ReviewTypeID"))  %>'
                                             Text='<%# Eval("TenantRent") %>'>
                                         </asp:HyperLink>
                                     </ItemTemplate>
                                  </asp:TemplateField> 
                                  <asp:TemplateField HeaderText="Occupany Standard">
                                     <ItemTemplate> 
                                         <asp:HyperLink ID="LinkOccupanyStandard" runat="server"
                                                NavigateUrl='<%# String.Format("~/ErrorReport.aspx?SessionUserID={0}&FileID={1}&ReviewTypeID={2}&ProcessTypeID=6", Request.QueryString("SessionUserID"), Eval("FileID"), Eval("fk_ReviewTypeID"))  %>'
                                             Text='<%# Eval("OccupanyStandard") %>'>
                                         </asp:HyperLink>
                                     </ItemTemplate>
                                  </asp:TemplateField> 
                                  <asp:TemplateField HeaderText="Annual Reexamination">
                                     <ItemTemplate> 
                                         <asp:HyperLink ID="LinkAnnualReexamination" runat="server"
                                                NavigateUrl='<%# String.Format("~/ErrorReport.aspx?SessionUserID={0}&FileID={1}&ReviewTypeID={2}&ProcessTypeID=7", Request.QueryString("SessionUserID"), Eval("FileID"), Eval("fk_ReviewTypeID")) %>'
                                             Text='<%# Eval("AnnualReexamination") %>'>
                                         </asp:HyperLink>
                                     </ItemTemplate>
                                  </asp:TemplateField> 
                                  <asp:TemplateField HeaderText="Interim Reexamination">
                                     <ItemTemplate> 
                                         <asp:HyperLink ID="LinkInterimReexamination" runat="server"
                                                NavigateUrl='<%# String.Format("~/ErrorReport.aspx?SessionUserID={0}&FileID={1}&ReviewTypeID={2}&ProcessTypeID=8", Request.QueryString("SessionUserID"), Eval("FileID"), Eval("fk_ReviewTypeID"))  %>'
                                             Text='<%# Eval("InterimReexamination") %>'>
                                         </asp:HyperLink>
                                     </ItemTemplate>
                                  </asp:TemplateField> 
                                  <asp:TemplateField HeaderText="Moves">
                                     <ItemTemplate> 
                                         <asp:HyperLink ID="LinkMoves" runat="server"
                                                NavigateUrl='<%# String.Format("~/ErrorReport.aspx?SessionUserID={0}&FileID={1}&ReviewTypeID={2}&ProcessTypeID=9", Request.QueryString("SessionUserID"), Eval("FileID"), Eval("fk_ReviewTypeID"))  %>'
                                             Text='<%# Eval("Moves") %>'>
                                         </asp:HyperLink>
                                     </ItemTemplate>
                                  </asp:TemplateField> 
                                  <asp:TemplateField HeaderText="Change In Family Composition">
                                     <ItemTemplate> 
                                         <asp:HyperLink ID="LinkChangeInFamilyComposition" runat="server"
                                                NavigateUrl='<%# String.Format("~/ErrorReport.aspx?SessionUserID={0}&FileID={1}&ReviewTypeID={2}&ProcessTypeID=10", Request.QueryString("SessionUserID"), Eval("FileID"), Eval("fk_ReviewTypeID"))  %>'
                                             Text='<%# Eval("ChangeInFamilyComposition") %>'>
                                         </asp:HyperLink>
                                     </ItemTemplate>
                                  </asp:TemplateField> 
                                  <asp:TemplateField HeaderText="Eligibility And Screening">
                                     <ItemTemplate> 
                                         <asp:HyperLink ID="LinkEligibilityAndScreening" runat="server"
                                                NavigateUrl='<%# String.Format("~/ErrorReport.aspx?SessionUserID={0}&FileID={1}&ReviewTypeID={2}&ProcessTypeID=11", Request.QueryString("SessionUserID"), Eval("FileID"), Eval("fk_ReviewTypeID"))  %>'
                                             Text='<%# Eval("EligibilityAndScreening") %>'>
                                         </asp:HyperLink>
                                     </ItemTemplate>
                                  </asp:TemplateField> 
                                  <asp:TemplateField HeaderText="Leasing">
                                     <ItemTemplate> 
                                         <asp:HyperLink ID="LinkLeasing" runat="server"
                                                NavigateUrl='<%# String.Format("~/ErrorReport.aspx?SessionUserID={0}&FileID={1}&ReviewTypeID={2}&ProcessTypeID=12", Request.QueryString("SessionUserID"), Eval("FileID"), Eval("fk_ReviewTypeID"))  %>'
                                             Text='<%# Eval("Leasing") %>'>
                                         </asp:HyperLink>
                                     </ItemTemplate>
                                  </asp:TemplateField> 
                                  <asp:TemplateField HeaderText="Data Entry">
                                     <ItemTemplate> 
                                         <asp:HyperLink ID="LinkDataEntry" runat="server"
                                                NavigateUrl='<%# String.Format("~/ErrorReport.aspx?SessionUserID={0}&FileID={1}&ReviewTypeID={2}&ProcessTypeID=13", Request.QueryString("SessionUserID"), Eval("FileID"), Eval("fk_ReviewTypeID"))  %>'
                                             Text='<%# Eval("DataEntry") %>'>
                                         </asp:HyperLink>
                                     </ItemTemplate>
                                  </asp:TemplateField> 
                                  <asp:TemplateField HeaderText="Reasonable Rent">
                                     <ItemTemplate> 
                                         <asp:HyperLink ID="LinkReasonableRent" runat="server"
                                                NavigateUrl='<%# String.Format("~/ErrorReport.aspx?SessionUserID={0}&FileID={1}&ReviewTypeID={2}&ProcessTypeID=15", Request.QueryString("SessionUserID"), Eval("FileID"), Eval("fk_ReviewTypeID"))  %>'
                                             Text='<%# Eval("ReasonableRent") %>'>
                                         </asp:HyperLink>
                                     </ItemTemplate>
                                  </asp:TemplateField> 
                                  <asp:TemplateField HeaderText="Portability">
                                     <ItemTemplate> 
                                         <asp:HyperLink ID="LinkPortability" runat="server"
                                                NavigateUrl='<%# String.Format("~/ErrorReport.aspx?SessionUserID={0}&FileID={1}&ReviewTypeID={2}&ProcessTypeID=16", Request.QueryString("SessionUserID"), Eval("FileID"), Eval("fk_ReviewTypeID"))  %>'
                                             Text='<%# Eval("Portability") %>'>
                                         </asp:HyperLink>
                                     </ItemTemplate>
                                  </asp:TemplateField> 
                                  <asp:TemplateField HeaderText="Owner Certification">
                                     <ItemTemplate> 
                                         <asp:HyperLink ID="LinkOwnerCertification" runat="server"
                                                NavigateUrl='<%# String.Format("~/ErrorReport.aspx?SessionUserID={0}&FileID={1}&ReviewTypeID={2}&ProcessTypeID=17", Request.QueryString("SessionUserID"), Eval("FileID"), Eval("fk_ReviewTypeID"))  %>'
                                             Text='<%# Eval("OwnerCertification") %>'>
                                         </asp:HyperLink>
                                     </ItemTemplate>
                                  </asp:TemplateField> 
                                  <asp:TemplateField HeaderText="Document">
                                     <ItemTemplate> 
                                         <asp:HyperLink ID="LinkDocument" runat="server"
                                                NavigateUrl='<%# String.Format("~/ErrorReport.aspx?SessionUserID={0}&FileID={1}&ReviewTypeID={2}&ProcessTypeID=18", Request.QueryString("SessionUserID"), Eval("FileID"), Eval("fk_ReviewTypeID"))  %>'
                                             Text='<%# Eval("Document") %>'>
                                         </asp:HyperLink>
                                     </ItemTemplate>
                                  </asp:TemplateField> 
                                  <asp:TemplateField HeaderText="Other">
                                     <ItemTemplate> 
                                         <asp:HyperLink ID="LinkOther" runat="server"
                                                NavigateUrl='<%# String.Format("~/ErrorReport.aspx?SessionUserID={0}&FileID={1}&ReviewTypeID={2}&ProcessTypeID=21", Request.QueryString("SessionUserID"), Eval("FileID"), Eval("fk_ReviewTypeID"))  %>'
                                             Text='<%# Eval("Other") %>'>
                                         </asp:HyperLink>
                                     </ItemTemplate>
                                  </asp:TemplateField> 
                                  <asp:TemplateField HeaderText="Selection From The Waitlist">
                                     <ItemTemplate> 
                                         <asp:HyperLink ID="LinkSelectionFromTheWaitlist" runat="server"
                                                NavigateUrl='<%# String.Format("~/ErrorReport.aspx?SessionUserID={0}&FileID={1}&ReviewTypeID={2}&ProcessTypeID=22", Request.QueryString("SessionUserID"), Eval("FileID"), Eval("fk_ReviewTypeID"))  %>'
                                             Text='<%# Eval("SelectionFromTheWaitlist") %>'>
                                         </asp:HyperLink>
                                     </ItemTemplate>
                                  </asp:TemplateField> 
                                <%--   <asp:TemplateField HeaderText="">
                                     <ItemTemplate> 
                                        <%# DisplayDisableLink(Eval("FileID"), Request.QueryString("SessionUserID"))%>
                                     </ItemTemplate>
                                   </asp:TemplateField>  --%>
                                </Columns>
                            </asp:GridView>
                        </div>
                  </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
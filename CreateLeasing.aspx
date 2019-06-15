<%@ Page Title="QC :: Leasing" Language="vb" AutoEventWireup="false" MasterPageFile="~/FileDetails.master" CodeBehind="CreateLeasing.aspx.vb" Inherits="QualityControlMonitor.CreateLeasing" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="nestedContent" runat="server">
    <div class="row">
        <div class="col-lg-12 col-md-7">
            <div class="card">
                <div class="header">
                    <h4 class="title"> <i class="fa fa-home" aria-hidden="true"></i> QC Review :: Leasing</h4>
                    <hr />
                </div>
                <div class="content">
                   <form id="Form1" action="" method="post" runat="server">
                     <div class="text-center">
                         <%
                             Dim connReview As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)
                             connReview.Open()
                             Dim fileID As Integer = Request.QueryString("FileID")

                             Dim isReviewComplete As Boolean
                             Dim result As New SqlCommand("SELECT IsReviewComplete FROM Files WHERE FileID = '" & fileID & "'", connReview)
                             Dim reader As SqlDataReader = result.ExecuteReader()
                             While reader.Read
                                 isReviewComplete = CStr(reader("IsReviewComplete"))
                             End While

                             If isReviewComplete = False Then
                          %>
                             <asp:Button ID="btnCompleteReview" runat="server" class="btn btn-info btn-fill btn-wd" Text="Complete Leasing Review" />
                          <%
                                Else
                          %>
                           <asp:Button ID="btnUpdateReview" runat="server" class="btn btn-warning btn-fill btn-wd" Text="Resubmit Leasing Review" />
                          <%
                          End If
                          connReview.Close()
                        %>
                     </div>
                    <div class="clearfix"></div>
                    <br />
                    <ul class="nav nav-tabs nav-justified" role="tablist">
                        <li role="presentation" class="active"><a href="#process" aria-controls="process"
                            role="tab" data-toggle="tab"><i class="fa fa-folder-open" aria-hidden="true"></i>
                            &nbsp;&nbsp; Processing</a></li>
                        <li role="presentation"><a href="#documents" aria-controls="documents" role="tab"
                            data-toggle="tab"><i class="fa fa-file-text" aria-hidden="true"></i>&nbsp;&nbsp;
                            Documents</a></li>
                    </ul>
                    <div class="tab-content">
                              <%
                            Dim sessionUserID As String
                            If Not Web.HttpContext.Current.Session("SessionUserID") Is Nothing Then
                                sessionUserID = Web.HttpContext.Current.Session("SessionUserID").ToString()
                            End If

                            If sessionUserID = Nothing Then
                                sessionUserID = Request.QueryString("SessionUserID")
                                Web.HttpContext.Current.Session("SessionUserID") = sessionUserID
                            End If
                        %>
                        <div role="tabpanel" class="tab-pane fade active in" id="process">
                            <br />
                            <div class="panel panel-info">
                                <div class="panel-heading">
                                    <h4 class="panel-title">
                                      <i class="fa fa-home" aria-hidden="true"></i>  Leasing
                                    </h4>
                                </div>
                                <div class="panel-body">
                                    <hr />
                                    <div id="payment-standard">
                                        <h6> Payment Standard
                                             &nbsp; &nbsp; &nbsp;
                                            <%
                                                Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)
                                                conn.Open()
                                                Dim processes As New ArrayList
                                                Dim queryProcesses As New SqlCommand("SELECT fk_ProcessID FROM FileReviewedProcesses WHERE fk_FileID ='" & fileID & "'", conn)
                                                Dim readerProcesses As SqlDataReader = queryProcesses.ExecuteReader()
                                                If readerProcesses.HasRows Then
                                                    While readerProcesses.Read
                                                        processes.Add(CStr(readerProcesses("fk_ProcessID")))
                                                    End While
                                                End If
                                                conn.Close()

                                                If processes.Count > 0 Then
                                                    If processes.Contains("3") Then
                                                        Response.Write("<input type='checkbox' name='processPaymentStandard' checked='checked' />")
                                                    Else
                                                        Response.Write("<input type='checkbox' name='processPaymentStandard' />")
                                                    End If
                                                Else
                                                    Response.Write("<input type='checkbox' name='processPaymentStandard' />")
                                                End If
                                             %>
                                        </h6>
                                        <br />
                                            <%
                                            conn.Open()
                                                      Dim errorPaymentStandardID As Integer
                                                      Dim detailsPaymentStandard As String
                                                      Dim noticeTypePaymentStandard As String
                                                      Dim statusPaymentStandard As String
                                                      Dim errorStaffNamePaymentStandard As String
                                                Dim errorReviewTypeIDPaymentStandard As Integer
                                                Dim processPaymentStandardID As Integer
                                            
                                                Dim queryPaymentStandard As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE fk_FileID = '" & fileID & "' AND fk_ProcessTypeID = 3 ORDER BY NoticeTypes.Notice", conn)
                                                      Dim readerPaymentStandard As SqlDataReader = queryPaymentStandard.ExecuteReader()
                                                      If readerPaymentStandard.HasRows Then
                                                          While readerPaymentStandard.Read
                                                              errorPaymentStandardID = CStr(readerPaymentStandard("ErrorID"))
                                                              detailsPaymentStandard = CStr(readerPaymentStandard("Details"))
                                                              noticeTypePaymentStandard = CStr(readerPaymentStandard("Notice"))
                                                              statusPaymentStandard = CStr(readerPaymentStandard("Status"))
                                                              errorStaffNamePaymentStandard = CStr(readerPaymentStandard("ErrorStaffName"))
                                                        errorReviewTypeIDPaymentStandard = CStr(readerPaymentStandard("fk_ReviewTypeID"))
                                                        processPaymentStandardID = CStr(readerPaymentStandard("fk_ProcessTypeID"))
                                             %>
                                               <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypePaymentStandard) %>" type="text" />
                                                 </div>
                                               </div>
                                               <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                 <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsPaymentStandard)%></textarea>
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNamePaymentStandard) %>" type="text" />
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusPaymentStandard) %>"  type="text" />
                                                </div>
                                               </div>
                                               <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorPaymentStandardID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDPaymentStandard) %>&ProcessTypeID=<% Response.Write(processPaymentStandardID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                               <div class="clearfix"></div>
                                                 <br />
                                        <%
                                        End While
                                    End If
                                        conn.Close()
                                        %>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                  <asp:DropDownList ID="NoticeTypePaymentStandard" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypePaymentStandard" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypePaymentStandard" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <textarea class="form-control border-input" cols="4" name="commentPaymentStandard" placeholder="Comment"
                                                    rows="1"></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                 <asp:DropDownList ID="CaseManagerPaymentStandard" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerPaymentStandard" DataValueField="UserID" DataTextField="FullName" required="required"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerPaymentStandard" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3'  OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                               <asp:DropDownList ID="StatusPaymentStandard" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="text-center">
                                            <asp:Button ID="btnCreateProcessPaymentStandard" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <hr />
                                    </div>
                                    <div id="utility-allowance">
                                          <h6> Utility Allowance
                                          &nbsp; &nbsp; &nbsp;
                                            <%
                                                If processes.Count > 0 Then
                                                    If processes.Contains("4") Then
                                                        Response.Write("<input type='checkbox' name='processUtilityAllowance' checked='checked' />")
                                                    Else
                                                        Response.Write("<input type='checkbox' name='processUtilityAllowance' />")
                                                    End If
                                                Else
                                                    Response.Write("<input type='checkbox' name='processUtilityAllowance' />")
                                                End If
                                             %>
                                          </h6>
                                        <br />
                                            <%
                                            conn.Open()
                                                Dim errorUtilityAllowanceID As Integer
                                                Dim detailsUtilityAllowance As String
                                                Dim noticeTypeUtilityAllowance As String
                                                Dim statusUtilityAllowance As String
                                                Dim errorStaffNameUtilityAllowance As String
                                                Dim errorReviewTypeIDUtilityAllowance As Integer
                                                Dim processUtilityAllowanceID As Integer
                                            
                                                Dim queryUtilityAllowance As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE fk_FileID = '" & fileID & "' AND fk_ProcessTypeID = 4 ORDER BY NoticeTypes.Notice", conn)
                                                Dim readerUtilityAllowance As SqlDataReader = queryUtilityAllowance.ExecuteReader()
                                                If readerUtilityAllowance.HasRows Then
                                                    While readerUtilityAllowance.Read
                                                        errorUtilityAllowanceID = CStr(readerUtilityAllowance("ErrorID"))
                                                        detailsUtilityAllowance = CStr(readerUtilityAllowance("Details"))
                                                        noticeTypeUtilityAllowance = CStr(readerUtilityAllowance("Notice"))
                                                        statusUtilityAllowance = CStr(readerUtilityAllowance("Status"))
                                                        errorStaffNameUtilityAllowance = CStr(readerUtilityAllowance("ErrorStaffName"))
                                                        errorReviewTypeIDUtilityAllowance = CStr(readerUtilityAllowance("fk_ReviewTypeID"))
                                                        processUtilityAllowanceID = CStr(readerUtilityAllowance("fk_ProcessTypeID"))
                                             %>
                                               <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeUtilityAllowance) %>" type="text" />
                                                 </div>
                                               </div>
                                               <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                 <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsUtilityAllowance)%></textarea>
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameUtilityAllowance) %>" type="text" />
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusUtilityAllowance) %>"  type="text" />
                                                </div>
                                               </div>
                                               <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorUtilityAllowanceID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDUtilityAllowance) %>&ProcessTypeID=<% Response.Write(processUtilityAllowanceID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                               <div class="clearfix"></div>
                                                 <br />
                                        <%
                                        End While
                                    End If
                                        conn.Close()
                                        %>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="NoticeTypeUtilityAllowance" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeUtilityAllowance" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeUtilityAllowance" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <textarea class="form-control border-input" cols="4" name="commentUtilityAllowance" placeholder="Comment"
                                                    rows="1"></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                               <asp:DropDownList ID="CaseManagerUtilityAllowance" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerUtilityAllowance" DataValueField="UserID" DataTextField="FullName" required="required"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerUtilityAllowance" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="StatusUtilityAllowance" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="text-center">
                                             <asp:Button ID="btnCreateProcessUtilityAllowance" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                        </div>
                                        <div class="clearfix"></div>
                                        <hr />
                                    </div>
                                    <div id="tenant-rent">
                                     <h6> Tenant Rent
                                         &nbsp; &nbsp; &nbsp;
                                             <%
                                                If processes.Count > 0 Then
                                                     If processes.Contains("5") Then
                                                         Response.Write("<input type='checkbox' name='processTenantRent' checked='checked' />")
                                                     Else
                                                         Response.Write("<input type='checkbox' name='processTenantRent' />")
                                                     End If
                                                Else
                                                     Response.Write("<input type='checkbox' name='processTenantRent' />")
                                                End If
                                             %>
                                     </h6>
                                        <br />
                                           <%
                                            conn.Open()
                                               Dim errorTenantRentID As Integer
                                               Dim detailsTenantRent As String
                                               Dim noticeTypeTenantRent As String
                                               Dim statusTenantRent As String
                                               Dim errorStaffNameTenantRent As String
                                               Dim errorReviewTypeIDTenantRent As Integer
                                               Dim processTenantRentID As Integer
                                            
                                               Dim queryTenantRent As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE fk_FileID = '" & fileID & "' AND fk_ProcessTypeID = 5 ORDER BY NoticeTypes.Notice", conn)
                                               Dim readerTenantRent As SqlDataReader = queryTenantRent.ExecuteReader()
                                               If readerTenantRent.HasRows Then
                                                   While readerTenantRent.Read
                                                       errorTenantRentID = CStr(readerTenantRent("ErrorID"))
                                                       detailsTenantRent = CStr(readerTenantRent("Details"))
                                                       noticeTypeTenantRent = CStr(readerTenantRent("Notice"))
                                                       statusTenantRent = CStr(readerTenantRent("Status"))
                                                       errorStaffNameTenantRent = CStr(readerTenantRent("ErrorStaffName"))
                                                       errorReviewTypeIDTenantRent = CStr(readerTenantRent("fk_ReviewTypeID"))
                                                       processTenantRentID = CStr(readerTenantRent("fk_ProcessTypeID"))
                                             %>
                                               <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeTenantRent) %>" type="text" />
                                                 </div>
                                               </div>
                                               <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                 <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsTenantRent)%></textarea>
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameTenantRent) %>" type="text" />
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusTenantRent) %>"  type="text" />
                                                </div>
                                               </div>
                                               <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorTenantRentID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDTenantRent) %>&ProcessTypeID=<% Response.Write(processTenantRentID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                               <div class="clearfix"></div>
                                                 <br />
                                        <%
                                        End While
                                    End If
                                        conn.Close()
                                        %>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                  <asp:DropDownList ID="NoticeTypeTenantRent" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeTenantRent" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeTenantRent" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '11' OR [NoticeTypeID] = '8' OR [NoticeTypeID] = '9' OR [NoticeTypeID] = '10'  OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '2' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <textarea class="form-control border-input" cols="4" name="commentTenantRent" placeholder="Comment"
                                                    rows="1"></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                               <asp:DropDownList ID="CaseManagerTenantRent" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerTenantRent" DataValueField="UserID" DataTextField="FullName" required="required"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerTenantRent" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="StatusTenantRent" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="text-center">
                                             <asp:Button ID="btnCreateProcessTenantRent" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                        </div>
                                        <div class="clearfix"></div>
                                        <hr />
                                    </div>
                                    <div id="leasing">
                                        <h6> Leasing
                                             &nbsp; &nbsp; &nbsp;
                                              <%
                                                If processes.Count > 0 Then
                                                           If processes.Contains("12") Then
                                                               Response.Write("<input type='checkbox' name='processLeasing' checked='checked' />")
                                                           Else
                                                               Response.Write("<input type='checkbox' name='processLeasing' />")
                                                           End If
                                                Else
                                                           Response.Write("<input type='checkbox' name='processLeasing' />")
                                                End If
                                             %>
                                        </h6>
                                        <br />
                                         <%
                                            conn.Open()
                                             Dim errorLeasingID As Integer
                                             Dim detailsLeasing As String
                                             Dim noticeTypeLeasing As String
                                             Dim statusLeasing As String
                                             Dim errorStaffNameLeasing As String
                                             Dim errorReviewTypeIDLeasing As Integer
                                             Dim processLeasingID As Integer
                                            
                                             Dim queryLeasing As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE fk_FileID = '" & fileID & "' AND fk_ProcessTypeID = 12 ORDER BY NoticeTypes.Notice", conn)
                                             Dim readerLeasing As SqlDataReader = queryLeasing.ExecuteReader()
                                             If readerLeasing.HasRows Then
                                                 While readerLeasing.Read
                                                     errorLeasingID = CStr(readerLeasing("ErrorID"))
                                                     detailsLeasing = CStr(readerLeasing("Details"))
                                                     noticeTypeLeasing = CStr(readerLeasing("Notice"))
                                                     statusLeasing = CStr(readerLeasing("Status"))
                                                     errorStaffNameLeasing = CStr(readerLeasing("ErrorStaffName"))
                                                     errorReviewTypeIDLeasing = CStr(readerLeasing("fk_ReviewTypeID"))
                                                     processLeasingID = CStr(readerLeasing("Fk_ProcessTypeID"))
                                             %>
                                               <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeLeasing) %>" type="text" />
                                                 </div>
                                               </div>
                                               <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                 <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsLeasing)%></textarea>
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameLeasing) %>" type="text" />
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusLeasing) %>"  type="text" />
                                                </div>
                                               </div>
                                               <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorLeasingID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDLeasing) %>&ProcessTypeID=<% Response.Write(processLeasingID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                               <div class="clearfix"></div>
                                                 <br />
                                        <%
                                        End While
                                    End If
                                        conn.Close()
                                        %>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="NoticeTypeLeasing" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeLeasing" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeLeasing" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <textarea class="form-control border-input" cols="4" name="commentLeasing" placeholder="Comment"
                                                    rows="1"></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="CaseManagerLeasing" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerLeasing" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerLeasing" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="StatusLeasing" class="form-control border-input" runat="server">
                                                 <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                  <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                  <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                 </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="text-center">
                                             <asp:Button ID="btnCreateProcessLeasing" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <hr />
                                    </div>
                                    <div id="data-entry">
                                        <h6>Data Entry
                                             &nbsp; &nbsp; &nbsp;
                                              <%
                                                If processes.Count > 0 Then
                                                     If processes.Contains("13") Then
                                                         Response.Write("<input type='checkbox' name='processDataEntry' checked='checked' />")
                                                     Else
                                                         Response.Write("<input type='checkbox' name='processDataEntry' />")
                                                     End If
                                                Else
                                                    Response.Write("<input type='checkbox' name='processDataEntry' />")
                                                End If
                                             %>
                                        </h6>
                                        <br />
                                          <%
                                            conn.Open()
                                              Dim errorDataEntryID As Integer
                                           Dim detailsDataEntry As String
                                           Dim noticeTypeDataEntry As String
                                           Dim statusDataEntry As String
                                           Dim errorStaffNameDataEntry As String
                                              Dim errorReviewTypeIDDataEntry As Integer
                                              Dim processDataEntryID As Integer
                                            
                                              Dim queryDataEntry As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE fk_FileID = '" & fileID & "' AND fk_ProcessTypeID = 13 ORDER BY NoticeTypes.Notice", conn)
                                           Dim readerDataEntry As SqlDataReader = queryDataEntry.ExecuteReader()
                                           If readerDataEntry.HasRows Then
                                               While readerDataEntry.Read
                                                   errorDataEntryID = CStr(readerDataEntry("ErrorID"))
                                                   detailsDataEntry = CStr(readerDataEntry("Details"))
                                                   noticeTypeDataEntry = CStr(readerDataEntry("Notice"))
                                                   statusDataEntry = CStr(readerDataEntry("Status"))
                                                   errorStaffNameDataEntry = CStr(readerDataEntry("ErrorStaffName"))
                                                      errorReviewTypeIDDataEntry = CStr(readerDataEntry("fk_ReviewTypeID"))
                                                      processDataEntryID = CStr(readerDataEntry("fk_ProcessTypeID"))
                                             %>
                                               <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDataEntry) %>" type="text" />
                                                 </div>
                                               </div>
                                               <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                 <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDataEntry)%></textarea>
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDataEntry) %>" type="text" />
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDataEntry) %>"  type="text" />
                                                </div>
                                               </div>
                                               <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDataEntryID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDDataEntry) %>&ProcessTypeID=<% Response.Write(processDataEntryID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                               <div class="clearfix"></div>
                                                 <br />
                                        <%
                                        End While
                                    End If
                                        conn.Close()
                                        %>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="NoticeTypeDataEntry" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeDataEntry" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeDataEntry" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <textarea class="form-control border-input" cols="4" name="commentDataEntry" placeholder="Comment"
                                                    rows="1"></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="CaseManagerDataEntry" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerDataEntry" DataValueField="UserID" DataTextField="FullName" required="required"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerDataEntry" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                  <asp:DropDownList ID="StatusDataEntry" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="text-center">
                                            <asp:Button ID="btnCreateProcessDataEntry" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                        </div>
                                        <div class="clearfix"></div>
                                        <hr />
                                    </div>
                                    <div id="process-other">
                                        <h6> Other
                                             &nbsp; &nbsp; &nbsp;
                                             <%
                                                If processes.Count > 0 Then
                                                    If processes.Contains("21") Then
                                                        Response.Write("<input type='checkbox' name='processOther' checked='checked' />")
                                                    Else
                                                        Response.Write("<input type='checkbox' name='processOther' />")
                                                    End If
                                                Else
                                                    Response.Write("<input type='checkbox' name='processOther' />")
                                                End If
                                             %>
                                        </h6>
                                        <br />
                                          <%
                                            conn.Open()
                                              Dim errorOtherID As Integer
                                           Dim detailsOther As String
                                           Dim noticeTypeOther As String
                                           Dim statusOther As String
                                           Dim errorStaffNameOther As String
                                              Dim errorReviewTypeIDOther As Integer
                                              Dim processOtherID As Integer
                                            
                                              Dim queryOther As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE fk_FileID = '" & fileID & "' AND fk_ProcessTypeID = 21 ORDER BY NoticeTypes.Notice", conn)
                                           Dim readerOther As SqlDataReader = queryOther.ExecuteReader()
                                           If readerOther.HasRows Then
                                               While readerOther.Read
                                                   errorOtherID = CStr(readerOther("ErrorID"))
                                                   detailsOther = CStr(readerOther("Details"))
                                                   noticeTypeOther = CStr(readerOther("Notice"))
                                                   statusOther = CStr(readerOther("Status"))
                                                   errorStaffNameOther = CStr(readerOther("ErrorStaffName"))
                                                      errorReviewTypeIDOther = CStr(readerOther("fk_ReviewTypeID"))
                                                      processOtherID = CStr(readerOther("fk_ProcessTypeID"))
                                             %>
                                               <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeOther) %>" type="text" />
                                                 </div>
                                               </div>
                                               <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                 <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsOther)%></textarea>
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameOther) %>" type="text" />
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusOther) %>"  type="text" />
                                                </div>
                                               </div>
                                               <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorOtherID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDOther) %>&ProcessTypeID=<% Response.Write(processOtherID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                               <div class="clearfix"></div>
                                                 <br />
                                        <%
                                        End While
                                    End If
                                        conn.Close()
                                        %>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                 <asp:DropDownList ID="NoticeTypeProcessOther" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeProcessOther" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeProcessOther" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4'">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <textarea class="form-control border-input" cols="4" name="commentProcessOther" placeholder="Comment"
                                                    rows="1"></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                  <asp:DropDownList ID="CaseManagerProcessOther" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerProcessOther" DataValueField="UserID" DataTextField="FullName" required="required"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerProcessOther" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                               <asp:DropDownList ID="StatusProcessOther" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="text-center">
                                            <asp:Button ID="btnCreateProcessOther" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                        </div>
                                        <div class="clearfix"></div>
                                        <hr />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane fade" id="documents">
                            <br />
                            <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                                <div class="panel panel-info">
                                    <div class="panel-heading" role="tab" id="headingOne">
                                        <h4 class="panel-title">
                                            <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne"
                                                aria-expanded="true" aria-controls="collapseOne"><i class="fa fa-home" aria-hidden="true"></i>  Leasing Documents </a>
                                        </h4>
                                    </div>
                                    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="panel-body">
                                            <hr />
                                            <div id="master-leasing-checklist">
                                                <h6> Master Leasing Checklist
                                                     &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        conn.Open()
                                                        Dim documents As New ArrayList
                                                        Dim queryDocuments As New SqlCommand("SELECT fk_DocumentID FROM FileReviewedDocuments WHERE fk_FileID ='" & fileID & "'", conn)
                                                        Dim readerDocuments As SqlDataReader = queryDocuments.ExecuteReader()
                                                        If readerDocuments.HasRows Then
                                                            While readerDocuments.Read
                                                                documents.Add(CStr(readerDocuments("fk_DocumentID")))
                                                            End While
                                                        End If
                                                        conn.Close()
                                                        
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("29") Then
                                                                Response.Write("<input type='checkbox' name='documentMasterLeasingChecklist' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentMasterLeasingChecklist' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentMasterLeasingChecklist' />")
                                                        End If
                                                     %>
                                                </h6>
                                               <br />
                                               <%
                                                   conn.Open()
                                                   Dim errorDocumentMasterLeasingChecklistErrorID As Integer
                                                   Dim errorDocumentMasterLeasingChecklistID As Integer
                                                   Dim detailsDocumentMasterLeasingChecklist As String
                                                   Dim noticeTypeDocumentMasterLeasingChecklist As String
                                                   Dim statusDocumentMasterLeasingChecklist As String
                                                   Dim errorStaffNameDocumentMasterLeasingChecklist As String
                                                   Dim errorDocumentMasterLeasingChecklistReviewTypeID As Integer
                                                   Dim errorsMasterLeasingChecklistList As New ArrayList
                                                   Dim processDocumentMasterLeasingChecklistErrorID As Integer
                                                        
                                                    Dim queryDocumentMasterLeasingChecklistError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '29' AND fk_FileID = '" & fileID & "'", conn)
                                                   Dim readerDocumentMasterLeasingChecklistError As SqlDataReader = queryDocumentMasterLeasingChecklistError.ExecuteReader()
                                                   If readerDocumentMasterLeasingChecklistError.HasRows Then
                                                       While readerDocumentMasterLeasingChecklistError.Read
                                                           errorDocumentMasterLeasingChecklistErrorID = CStr(readerDocumentMasterLeasingChecklistError("fk_ErrorID"))
                                                           errorsMasterLeasingChecklistList.Add(errorDocumentMasterLeasingChecklistErrorID)
                                                       End While
                                                   End If
                                                   conn.Close()
                                           
                                                   conn.Open()
                                                   Dim errorMasterLeasingChecklistIndex As Integer
                                                   For Each errorMasterLeasingChecklistIndex In errorsMasterLeasingChecklistList
                                                       Dim queryDocumentMasterLeasingChecklist As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorMasterLeasingChecklistIndex & "'", conn)
                                                       Dim readerDocumentMasterLeasingChecklist As SqlDataReader = queryDocumentMasterLeasingChecklist.ExecuteReader()
                                                       While readerDocumentMasterLeasingChecklist.Read
                                                           errorDocumentMasterLeasingChecklistID = CStr(readerDocumentMasterLeasingChecklist("ErrorID"))
                                                           detailsDocumentMasterLeasingChecklist = CStr(readerDocumentMasterLeasingChecklist("Details"))
                                                           noticeTypeDocumentMasterLeasingChecklist = CStr(readerDocumentMasterLeasingChecklist("Notice"))
                                                           statusDocumentMasterLeasingChecklist = CStr(readerDocumentMasterLeasingChecklist("Status"))
                                                           errorStaffNameDocumentMasterLeasingChecklist = CStr(readerDocumentMasterLeasingChecklist("ErrorStaffName"))
                                                           errorDocumentMasterLeasingChecklistReviewTypeID = CStr(readerDocumentMasterLeasingChecklist("fk_ReviewTypeID"))
                                                           processDocumentMasterLeasingChecklistErrorID = CStr(readerDocumentMasterLeasingChecklist("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentMasterLeasingChecklist) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentMasterLeasingChecklist)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentMasterLeasingChecklist) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentMasterLeasingChecklist) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentMasterLeasingChecklistID) %>&ReviewTypeID=<% Response.Write(errorDocumentMasterLeasingChecklistReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentMasterLeasingChecklistErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                                <div class="clearfix"></div>
                                                                 <br />
                                                                <%
                                                                End While
                                                                    Next
                                                            conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeMasterLeasingChecklist" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeMasterLeasingChecklist" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeMasterLeasingChecklist" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentMasterLeasingChecklist" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerMasterLeasingChecklist" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerMasterLeasingChecklist" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerMasterLeasingChecklist" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusMasterLeasingChecklist" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateMasterLeasingChecklist" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix"></div>
                                                <hr />
                                            </div>
                                            <div id="checklist-leasing-inspections">
                                                <h6> Checklist-Leasing / Inspections 
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("30") Then
                                                                Response.Write("<input type='checkbox' name='documentChecklistLeasingInspections' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentChecklistLeasingInspections' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentChecklistLeasingInspections' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                   <%
                                                   conn.Open()
                                                       Dim errorDocumentChecklistLeasingInspectionsErrorID As Integer
                                                   Dim errorDocumentChecklistLeasingInspectionsID As Integer
                                                   Dim detailsDocumentChecklistLeasingInspections As String
                                                   Dim noticeTypeDocumentChecklistLeasingInspections As String
                                                   Dim statusDocumentChecklistLeasingInspections As String
                                                   Dim errorStaffNameDocumentChecklistLeasingInspections As String
                                                   Dim errorDocumentChecklistLeasingInspectionsReviewTypeID As Integer
                                                       Dim errorsChecklistLeasingInspectionsList As New ArrayList
                                                       Dim processDocumentChecklistLeasingInspectionsErrorID As Integer
                                                        
                                                    Dim queryDocumentChecklistLeasingInspectionsError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '30' AND fk_FileID = '" & fileID & "'", conn)
                                                   Dim readerDocumentChecklistLeasingInspectionsError As SqlDataReader = queryDocumentChecklistLeasingInspectionsError.ExecuteReader()
                                                   If readerDocumentChecklistLeasingInspectionsError.HasRows Then
                                                       While readerDocumentChecklistLeasingInspectionsError.Read
                                                           errorDocumentChecklistLeasingInspectionsErrorID = CStr(readerDocumentChecklistLeasingInspectionsError("fk_ErrorID"))
                                                           errorsChecklistLeasingInspectionsList.Add(errorDocumentChecklistLeasingInspectionsErrorID)
                                                       End While
                                                   End If
                                                   conn.Close()
                                           
                                                   conn.Open()
                                                   Dim errorChecklistLeasingInspectionsIndex As Integer
                                                   For Each errorChecklistLeasingInspectionsIndex In errorsChecklistLeasingInspectionsList
                                                           Dim queryDocumentChecklistLeasingInspections As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorChecklistLeasingInspectionsIndex & "'", conn)
                                                       Dim readerDocumentChecklistLeasingInspections As SqlDataReader = queryDocumentChecklistLeasingInspections.ExecuteReader()
                                                       While readerDocumentChecklistLeasingInspections.Read
                                                           errorDocumentChecklistLeasingInspectionsID = CStr(readerDocumentChecklistLeasingInspections("ErrorID"))
                                                           detailsDocumentChecklistLeasingInspections = CStr(readerDocumentChecklistLeasingInspections("Details"))
                                                           noticeTypeDocumentChecklistLeasingInspections = CStr(readerDocumentChecklistLeasingInspections("Notice"))
                                                           statusDocumentChecklistLeasingInspections = CStr(readerDocumentChecklistLeasingInspections("Status"))
                                                           errorStaffNameDocumentChecklistLeasingInspections = CStr(readerDocumentChecklistLeasingInspections("ErrorStaffName"))
                                                           errorDocumentChecklistLeasingInspectionsReviewTypeID = CStr(readerDocumentChecklistLeasingInspections("fk_ReviewTypeID"))
                                                             processDocumentChecklistLeasingInspectionsErrorID = CStr(readerDocumentChecklistLeasingInspections("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentChecklistLeasingInspections) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentChecklistLeasingInspections)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentChecklistLeasingInspections) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentChecklistLeasingInspections) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentChecklistLeasingInspectionsID) %>&ReviewTypeID=<% Response.Write(errorDocumentChecklistLeasingInspectionsReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentChecklistLeasingInspectionsErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                                <div class="clearfix"></div>
                                                                 <br />
                                                                <%
                                                                End While
                                                                    Next
                                                            conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeChecklistLeasingInspections" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeChecklistLeasingInspections" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeChecklistLeasingInspections" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentChecklistLeasingInspections" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerChecklistLeasingInspections" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerChecklistLeasingInspections" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerChecklistLeasingInspections" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusChecklistLeasingInspections" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateChecklistLeasingInspections" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="leasing-packet-checklist">
                                                <h6> Leasing Packet Checklist
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("31") Then
                                                                Response.Write("<input type='checkbox' name='documentLeasingPacketChecklist' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentLeasingPacketChecklist' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentLeasingPacketChecklist' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                              <%
                                                   conn.Open()
                                                   Dim errorDocumentLeasingPacketChecklistErrorID As Integer
                                                   Dim errorDocumentLeasingPacketChecklistID As Integer
                                                   Dim detailsDocumentLeasingPacketChecklist As String
                                                   Dim noticeTypeDocumentLeasingPacketChecklist As String
                                                   Dim statusDocumentLeasingPacketChecklist As String
                                                   Dim errorStaffNameDocumentLeasingPacketChecklist As String
                                                   Dim errorDocumentLeasingPacketChecklistReviewTypeID As Integer
                                                  Dim errorsLeasingPacketChecklistList As New ArrayList
                                                  Dim processDocumentLeasingPacketChecklistErrorID As Integer
                                                        
                                                  Dim queryDocumentLeasingPacketChecklistError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '31' AND fk_FileID = '" & fileID & "'", conn)
                                                   Dim readerDocumentLeasingPacketChecklistError As SqlDataReader = queryDocumentLeasingPacketChecklistError.ExecuteReader()
                                                   If readerDocumentLeasingPacketChecklistError.HasRows Then
                                                       While readerDocumentLeasingPacketChecklistError.Read
                                                           errorDocumentLeasingPacketChecklistErrorID = CStr(readerDocumentLeasingPacketChecklistError("fk_ErrorID"))
                                                           errorsLeasingPacketChecklistList.Add(errorDocumentLeasingPacketChecklistErrorID)
                                                       End While
                                                   End If
                                                   conn.Close()
                                           
                                                   conn.Open()
                                                   Dim errorLeasingPacketChecklistIndex As Integer
                                                   For Each errorLeasingPacketChecklistIndex In errorsLeasingPacketChecklistList
                                                       Dim queryDocumentLeasingPacketChecklist As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorLeasingPacketChecklistIndex & "'", conn)
                                                       Dim readerDocumentLeasingPacketChecklist As SqlDataReader = queryDocumentLeasingPacketChecklist.ExecuteReader()
                                                       While readerDocumentLeasingPacketChecklist.Read
                                                           errorDocumentLeasingPacketChecklistID = CStr(readerDocumentLeasingPacketChecklist("ErrorID"))
                                                           detailsDocumentLeasingPacketChecklist = CStr(readerDocumentLeasingPacketChecklist("Details"))
                                                           noticeTypeDocumentLeasingPacketChecklist = CStr(readerDocumentLeasingPacketChecklist("Notice"))
                                                           statusDocumentLeasingPacketChecklist = CStr(readerDocumentLeasingPacketChecklist("Status"))
                                                           errorStaffNameDocumentLeasingPacketChecklist = CStr(readerDocumentLeasingPacketChecklist("ErrorStaffName"))
                                                           errorDocumentLeasingPacketChecklistReviewTypeID = CStr(readerDocumentLeasingPacketChecklist("fk_ReviewTypeID"))
                                                             processDocumentLeasingPacketChecklistErrorID = CStr(readerDocumentLeasingPacketChecklist("fk_ProcessTypeID"))
                                                          %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentLeasingPacketChecklist) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentLeasingPacketChecklist)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentLeasingPacketChecklist) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentLeasingPacketChecklist) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentLeasingPacketChecklistID) %>&ReviewTypeID=<% Response.Write(errorDocumentLeasingPacketChecklistReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentLeasingPacketChecklistErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                                <div class="clearfix"></div>
                                                                 <br />
                                                                <%
                                                                End While
                                                                    Next
                                                            conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeLeasingPacketChecklist" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeLeasingPacketChecklist" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeLeasingPacketChecklist" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentLeasingPacketChecklist" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerLeasingPacketChecklist" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerLeasingPacketChecklist" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerLeasingPacketChecklist" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusLeasingPacketChecklist" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateLeasingPacketChecklist" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="contracts-execution-checklist">
                                                <h6> Contracts Execution Checklist 
                                                     &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("5") Then
                                                                Response.Write("<input type='checkbox' name='documentContractsExecutionChecklist' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentContractsExecutionChecklist' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentContractsExecutionChecklist' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                       <%
                                                   conn.Open()
                                                   Dim errorDocumentContractsExecutionChecklistErrorID As Integer
                                                   Dim errorDocumentContractsExecutionChecklistID As Integer
                                                   Dim detailsDocumentContractsExecutionChecklist As String
                                                   Dim noticeTypeDocumentContractsExecutionChecklist As String
                                                   Dim statusDocumentContractsExecutionChecklist As String
                                                   Dim errorStaffNameDocumentContractsExecutionChecklist As String
                                                   Dim errorDocumentContractsExecutionChecklistReviewTypeID As Integer
                                                           Dim errorsContractsExecutionChecklistList As New ArrayList
                                                           Dim processDocumentContractsExecutionChecklistErrorID As Integer
                                                        
                                                    Dim queryDocumentContractsExecutionChecklistError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '5' AND fk_FileID = '" & fileID & "'", conn)
                                                   Dim readerDocumentContractsExecutionChecklistError As SqlDataReader = queryDocumentContractsExecutionChecklistError.ExecuteReader()
                                                   If readerDocumentContractsExecutionChecklistError.HasRows Then
                                                       While readerDocumentContractsExecutionChecklistError.Read
                                                           errorDocumentContractsExecutionChecklistErrorID = CStr(readerDocumentContractsExecutionChecklistError("fk_ErrorID"))
                                                           errorsContractsExecutionChecklistList.Add(errorDocumentContractsExecutionChecklistErrorID)
                                                       End While
                                                   End If
                                                   conn.Close()
                                           
                                                   conn.Open()
                                                   Dim errorContractsExecutionChecklistIndex As Integer
                                                   For Each errorContractsExecutionChecklistIndex In errorsContractsExecutionChecklistList
                                                               Dim queryDocumentContractsExecutionChecklist As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorContractsExecutionChecklistIndex & "'", conn)
                                                       Dim readerDocumentContractsExecutionChecklist As SqlDataReader = queryDocumentContractsExecutionChecklist.ExecuteReader()
                                                       While readerDocumentContractsExecutionChecklist.Read
                                                           errorDocumentContractsExecutionChecklistID = CStr(readerDocumentContractsExecutionChecklist("ErrorID"))
                                                           detailsDocumentContractsExecutionChecklist = CStr(readerDocumentContractsExecutionChecklist("Details"))
                                                           noticeTypeDocumentContractsExecutionChecklist = CStr(readerDocumentContractsExecutionChecklist("Notice"))
                                                           statusDocumentContractsExecutionChecklist = CStr(readerDocumentContractsExecutionChecklist("Status"))
                                                           errorStaffNameDocumentContractsExecutionChecklist = CStr(readerDocumentContractsExecutionChecklist("ErrorStaffName"))
                                                           errorDocumentContractsExecutionChecklistReviewTypeID = CStr(readerDocumentContractsExecutionChecklist("fk_ReviewTypeID"))
                                                             processDocumentContractsExecutionChecklistErrorID = CStr(readerDocumentContractsExecutionChecklist("fk_ProcessTypeID"))
                                                                   %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentContractsExecutionChecklist) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentContractsExecutionChecklist)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentContractsExecutionChecklist) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentContractsExecutionChecklist) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentContractsExecutionChecklistID) %>&ReviewTypeID=<% Response.Write(errorDocumentContractsExecutionChecklistReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentContractsExecutionChecklistErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                                <div class="clearfix"></div>
                                                                 <br />
                                                                <%
                                                                End While
                                                                    Next
                                                            conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeContractsExecutionChecklist" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeContractsExecutionChecklist" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeContractsExecutionChecklist" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentContractsExecutionChecklist" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerContractsExecutionChecklist" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerContractsExecutionChecklist" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerContractsExecutionChecklist" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusContractsExecutionChecklist" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateContractsExecutionChecklist" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix"></div>
                                                <hr />
                                            </div>
                                            <div id="utility-allowance-checklist">
                                                <h6>  Utility Allowance Checklist
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("32") Then
                                                                Response.Write("<input type='checkbox' name='documentUtilityAllowanceChecklist' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentUtilityAllowanceChecklist' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentUtilityAllowanceChecklist' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                <%
                                                    conn.Open()
                                                                 Dim errorDocumentUtilityAllowanceChecklistErrorID As Integer
                                                                 Dim errorDocumentUtilityAllowanceChecklistID As Integer
                                                                 Dim detailsDocumentUtilityAllowanceChecklist As String
                                                                 Dim noticeTypeDocumentUtilityAllowanceChecklist As String
                                                                 Dim statusDocumentUtilityAllowanceChecklist As String
                                                                 Dim errorStaffNameDocumentUtilityAllowanceChecklist As String
                                                                 Dim errorDocumentUtilityAllowanceChecklistReviewTypeID As Integer
                                                    Dim errorsUtilityAllowanceChecklistList As New ArrayList
                                                    Dim processDocumentUtilityAllowanceChecklistErrorID As Integer
                                                        
                                                    Dim queryDocumentUtilityAllowanceChecklistError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '32' AND fk_FileID = '" & fileID & "'", conn)
                                                                 Dim readerDocumentUtilityAllowanceChecklistError As SqlDataReader = queryDocumentUtilityAllowanceChecklistError.ExecuteReader()
                                                                 If readerDocumentUtilityAllowanceChecklistError.HasRows Then
                                                                     While readerDocumentUtilityAllowanceChecklistError.Read
                                                                         errorDocumentUtilityAllowanceChecklistErrorID = CStr(readerDocumentUtilityAllowanceChecklistError("fk_ErrorID"))
                                                                         errorsUtilityAllowanceChecklistList.Add(errorDocumentUtilityAllowanceChecklistErrorID)
                                                                     End While
                                                                 End If
                                                                 conn.Close()
                                           
                                                                 conn.Open()
                                                                 Dim errorUtilityAllowanceChecklistIndex As Integer
                                                                 For Each errorUtilityAllowanceChecklistIndex In errorsUtilityAllowanceChecklistList
                                                        Dim queryDocumentUtilityAllowanceChecklist As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorUtilityAllowanceChecklistIndex & "'", conn)
                                                                     Dim readerDocumentUtilityAllowanceChecklist As SqlDataReader = queryDocumentUtilityAllowanceChecklist.ExecuteReader()
                                                                     While readerDocumentUtilityAllowanceChecklist.Read
                                                                         errorDocumentUtilityAllowanceChecklistID = CStr(readerDocumentUtilityAllowanceChecklist("ErrorID"))
                                                                         detailsDocumentUtilityAllowanceChecklist = CStr(readerDocumentUtilityAllowanceChecklist("Details"))
                                                                         noticeTypeDocumentUtilityAllowanceChecklist = CStr(readerDocumentUtilityAllowanceChecklist("Notice"))
                                                                         statusDocumentUtilityAllowanceChecklist = CStr(readerDocumentUtilityAllowanceChecklist("Status"))
                                                                         errorStaffNameDocumentUtilityAllowanceChecklist = CStr(readerDocumentUtilityAllowanceChecklist("ErrorStaffName"))
                                                            errorDocumentUtilityAllowanceChecklistReviewTypeID = CStr(readerDocumentUtilityAllowanceChecklist("fk_ReviewTypeID"))
                                                            processDocumentUtilityAllowanceChecklistErrorID = CStr(readerDocumentUtilityAllowanceChecklist("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentUtilityAllowanceChecklist) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentUtilityAllowanceChecklist)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentUtilityAllowanceChecklist) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentUtilityAllowanceChecklist) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentUtilityAllowanceChecklistID) %>&ReviewTypeID=<% Response.Write(errorDocumentUtilityAllowanceChecklistReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentUtilityAllowanceChecklistErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                                <div class="clearfix"></div>
                                                                 <br />
                                                                <%
                                                                End While
                                                                    Next
                                                            conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeUtilityAllowanceChecklist" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeUtilityAllowanceChecklist" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeUtilityAllowanceChecklist" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentUtilityAllowanceChecklist" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerUtilityAllowanceChecklist" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerUtilityAllowanceChecklist" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerUtilityAllowanceChecklist" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusUtilityAllowanceChecklist" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateUtilityAllowanceChecklist" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="lease">
                                                <h6> Lease
                                                     &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("33") Then
                                                                 Response.Write("<input type='checkbox' name='documentLease' checked='checked' />")
                                                            Else
                                                                 Response.Write("<input type='checkbox' name='documentLease' />")
                                                            End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentLease' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                 <%
                                                   conn.Open()
                                                   Dim errorDocumentLeaseErrorID As Integer
                                                   Dim errorDocumentLeaseID As Integer
                                                   Dim detailsDocumentLease As String
                                                   Dim noticeTypeDocumentLease As String
                                                   Dim statusDocumentLease As String
                                                   Dim errorStaffNameDocumentLease As String
                                                   Dim errorDocumentLeaseReviewTypeID As Integer
                                                                 Dim errorsLeaseList As New ArrayList
                                                                 Dim processDocumentLeaseErrorID As Integer
                                                        
                                                    Dim queryDocumentLeaseError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '33' AND fk_FileID = '" & fileID & "'", conn)
                                                   Dim readerDocumentLeaseError As SqlDataReader = queryDocumentLeaseError.ExecuteReader()
                                                   If readerDocumentLeaseError.HasRows Then
                                                       While readerDocumentLeaseError.Read
                                                           errorDocumentLeaseErrorID = CStr(readerDocumentLeaseError("fk_ErrorID"))
                                                           errorsLeaseList.Add(errorDocumentLeaseErrorID)
                                                       End While
                                                   End If
                                                   conn.Close()
                                           
                                                   conn.Open()
                                                   Dim errorLeaseIndex As Integer
                                                   For Each errorLeaseIndex In errorsLeaseList
                                                                     Dim queryDocumentLease As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorLeaseIndex & "'", conn)
                                                       Dim readerDocumentLease As SqlDataReader = queryDocumentLease.ExecuteReader()
                                                       While readerDocumentLease.Read
                                                           errorDocumentLeaseID = CStr(readerDocumentLease("ErrorID"))
                                                           detailsDocumentLease = CStr(readerDocumentLease("Details"))
                                                           noticeTypeDocumentLease = CStr(readerDocumentLease("Notice"))
                                                           statusDocumentLease = CStr(readerDocumentLease("Status"))
                                                           errorStaffNameDocumentLease = CStr(readerDocumentLease("ErrorStaffName"))
                                                                         errorDocumentLeaseReviewTypeID = CStr(readerDocumentLease("fk_ReviewTypeID"))
                                                                  processDocumentLeaseErrorID = CStr(readerDocumentLease("fk_ProcessTypeID"))       
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentLease) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentLease)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentLease) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentLease) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentLeaseID) %>&ReviewTypeID=<% Response.Write(errorDocumentLeaseReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentLeaseErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                                <div class="clearfix"></div>
                                                                 <br />
                                                                <%
                                                                End While
                                                                    Next
                                                            conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeLease" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeLease" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeLease" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentLease" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerLease" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerLease" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerLease" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusLease" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateLease" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="hap-contract">
                                                <h6> HAP Contract
                                                    &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("53") Then
                                                                 Response.Write("<input type='checkbox' name='documentHapContract' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentHapContract' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentHapContract' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                 <%
                                                   conn.Open()
                                                   Dim errorDocumentHapContractErrorID As Integer
                                                   Dim errorDocumentHapContractID As Integer
                                                   Dim detailsDocumentHapContract As String
                                                   Dim noticeTypeDocumentHapContract As String
                                                   Dim statusDocumentHapContract As String
                                                   Dim errorStaffNameDocumentHapContract As String
                                                   Dim errorDocumentHapContractReviewTypeID As Integer
                                                     Dim errorsHapContractList As New ArrayList
                                                       Dim processDocumentHapContractErrorID As Integer
                                                        
                                                     Dim queryDocumentHapContractError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '53' AND fk_FileID = '" & fileID & "'", conn)
                                                   Dim readerDocumentHapContractError As SqlDataReader = queryDocumentHapContractError.ExecuteReader()
                                                   If readerDocumentHapContractError.HasRows Then
                                                       While readerDocumentHapContractError.Read
                                                           errorDocumentHapContractErrorID = CStr(readerDocumentHapContractError("fk_ErrorID"))
                                                           errorsHapContractList.Add(errorDocumentHapContractErrorID)
                                                       End While
                                                   End If
                                                   conn.Close()
                                           
                                                   conn.Open()
                                                   Dim errorHapContractIndex As Integer
                                                   For Each errorHapContractIndex In errorsHapContractList
                                                         Dim queryDocumentHapContract As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorHapContractIndex & "'", conn)
                                                       Dim readerDocumentHapContract As SqlDataReader = queryDocumentHapContract.ExecuteReader()
                                                       While readerDocumentHapContract.Read
                                                           errorDocumentHapContractID = CStr(readerDocumentHapContract("ErrorID"))
                                                           detailsDocumentHapContract = CStr(readerDocumentHapContract("Details"))
                                                           noticeTypeDocumentHapContract = CStr(readerDocumentHapContract("Notice"))
                                                           statusDocumentHapContract = CStr(readerDocumentHapContract("Status"))
                                                           errorStaffNameDocumentHapContract = CStr(readerDocumentHapContract("ErrorStaffName"))
                                                           errorDocumentHapContractReviewTypeID = CStr(readerDocumentHapContract("fk_ReviewTypeID"))
                                                           processDocumentHapContractErrorID = CStr(readerDocumentHapContract("fk_ProcessTypeID"))  
                                                             %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentHapContract) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentHapContract)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentHapContract) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentHapContract) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentHapContractID) %>&ReviewTypeID=<% Response.Write(errorDocumentHapContractReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentHapContractErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                                <div class="clearfix"></div>
                                                                 <br />
                                                                <%
                                                                End While
                                                                    Next
                                                            conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeHapContract" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeHapContract" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeHapContract" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentHapContract" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerHapContract" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerHapContract" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerHapContract" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusHapContract" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateHapContract" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix"></div>
                                                <hr />
                                            </div>
                                            <div id="hud-tenancy-addedum">
                                                <h6> HUD Tenancy Addedum
                                                     &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("34") Then
                                                                 Response.Write("<input type='checkbox' name='documentHudTenancyAddendum' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentHudTenancyAddendum' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentHudTenancyAddendum' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                       <%
                                                   conn.Open()
                                                   Dim errorDocumentHudTenancyAddendumErrorID As Integer
                                                   Dim errorDocumentHudTenancyAddendumID As Integer
                                                   Dim detailsDocumentHudTenancyAddendum As String
                                                   Dim noticeTypeDocumentHudTenancyAddendum As String
                                                   Dim statusDocumentHudTenancyAddendum As String
                                                   Dim errorStaffNameDocumentHudTenancyAddendum As String
                                                   Dim errorDocumentHudTenancyAddendumReviewTypeID As Integer
                                                           Dim errorsHudTenancyAddendumList As New ArrayList
                                                           Dim processDocumentHudTenancyAddendumErrorID As Integer
                                                        
                                                    Dim queryDocumentHudTenancyAddendumError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '34' AND fk_FileID = '" & fileID & "'", conn)
                                                   Dim readerDocumentHudTenancyAddendumError As SqlDataReader = queryDocumentHudTenancyAddendumError.ExecuteReader()
                                                   If readerDocumentHudTenancyAddendumError.HasRows Then
                                                       While readerDocumentHudTenancyAddendumError.Read
                                                           errorDocumentHudTenancyAddendumErrorID = CStr(readerDocumentHudTenancyAddendumError("fk_ErrorID"))
                                                           errorsHudTenancyAddendumList.Add(errorDocumentHudTenancyAddendumErrorID)
                                                       End While
                                                   End If
                                                   conn.Close()
                                           
                                                   conn.Open()
                                                   Dim errorHudTenancyAddendumIndex As Integer
                                                   For Each errorHudTenancyAddendumIndex In errorsHudTenancyAddendumList
                                                               Dim queryDocumentHudTenancyAddendum As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorHudTenancyAddendumIndex & "'", conn)
                                                       Dim readerDocumentHudTenancyAddendum As SqlDataReader = queryDocumentHudTenancyAddendum.ExecuteReader()
                                                       While readerDocumentHudTenancyAddendum.Read
                                                           errorDocumentHudTenancyAddendumID = CStr(readerDocumentHudTenancyAddendum("ErrorID"))
                                                           detailsDocumentHudTenancyAddendum = CStr(readerDocumentHudTenancyAddendum("Details"))
                                                           noticeTypeDocumentHudTenancyAddendum = CStr(readerDocumentHudTenancyAddendum("Notice"))
                                                           statusDocumentHudTenancyAddendum = CStr(readerDocumentHudTenancyAddendum("Status"))
                                                           errorStaffNameDocumentHudTenancyAddendum = CStr(readerDocumentHudTenancyAddendum("ErrorStaffName"))
                                                           errorDocumentHudTenancyAddendumReviewTypeID = CStr(readerDocumentHudTenancyAddendum("fk_ReviewTypeID"))
                                                                   processDocumentHudTenancyAddendumErrorID = CStr(readerDocumentHudTenancyAddendum("fk_ProcessTypeID"))
                                                                   %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentHudTenancyAddendum) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentHudTenancyAddendum)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentHudTenancyAddendum) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentHudTenancyAddendum) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentHudTenancyAddendumID) %>&ReviewTypeID=<% Response.Write(errorDocumentHudTenancyAddendumReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentHudTenancyAddendumErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                                <div class="clearfix"></div>
                                                                 <br />
                                                                <%
                                                                End While
                                                                    Next
                                                            conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeHudTenancyAddendum" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeHudTenancyAddendum" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeHudTenancyAddendum" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentHudTenancyAddendum" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerHudTenancyAddendum" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerHudTenancyAddendum" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerHudTenancyAddendum" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusHudTenancyAddendum" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateHudTenancyAddendum" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix"></div>
                                                <hr />
                                            </div>
                                            <div id="rfta">
                                                <h6> RFTA
                                                    &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("52") Then
                                                                 Response.Write("<input type='checkbox' name='documentRfta' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentRfta' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentRfta' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                   <%
                                                   conn.Open()
                                                   Dim errorDocumentRftaErrorID As Integer
                                                   Dim errorDocumentRftaID As Integer
                                                   Dim detailsDocumentRfta As String
                                                   Dim noticeTypeDocumentRfta As String
                                                   Dim statusDocumentRfta As String
                                                   Dim errorStaffNameDocumentRfta As String
                                                   Dim errorDocumentRftaReviewTypeID As Integer
                                                       Dim errorsRftaList As New ArrayList
                                                       Dim processDocumentRftaErrorID As Integer
                                                        
                                                    Dim queryDocumentRftaError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '52' AND fk_FileID = '" & fileID & "'", conn)
                                                   Dim readerDocumentRftaError As SqlDataReader = queryDocumentRftaError.ExecuteReader()
                                                   If readerDocumentRftaError.HasRows Then
                                                       While readerDocumentRftaError.Read
                                                           errorDocumentRftaErrorID = CStr(readerDocumentRftaError("fk_ErrorID"))
                                                           errorsRftaList.Add(errorDocumentRftaErrorID)
                                                       End While
                                                   End If
                                                   conn.Close()
                                           
                                                   conn.Open()
                                                   Dim errorRftaIndex As Integer
                                                   For Each errorRftaIndex In errorsRftaList
                                                           Dim queryDocumentRfta As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorRftaIndex & "'", conn)
                                                       Dim readerDocumentRfta As SqlDataReader = queryDocumentRfta.ExecuteReader()
                                                       While readerDocumentRfta.Read
                                                           errorDocumentRftaID = CStr(readerDocumentRfta("ErrorID"))
                                                           detailsDocumentRfta = CStr(readerDocumentRfta("Details"))
                                                           noticeTypeDocumentRfta = CStr(readerDocumentRfta("Notice"))
                                                           statusDocumentRfta = CStr(readerDocumentRfta("Status"))
                                                           errorStaffNameDocumentRfta = CStr(readerDocumentRfta("ErrorStaffName"))
                                                           errorDocumentRftaReviewTypeID = CStr(readerDocumentRfta("fk_ReviewTypeID"))
                                                               processDocumentRftaErrorID = CStr(readerDocumentRfta("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentRfta) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentRfta)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentRfta) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentRfta) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentRftaID) %>&ReviewTypeID=<% Response.Write(errorDocumentRftaReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentRftaErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                                <div class="clearfix"></div>
                                                                 <br />
                                                                <%
                                                                End While
                                                                    Next
                                                            conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeRfta" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeRfta" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeRfta" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentRfta" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerRfta" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerRfta" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerRfta" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusRfta" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateRfta" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="security-deposit-confirmation">
                                                <h6> Security Deposit Confirmation
                                                    &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("35") Then
                                                                 Response.Write("<input type='checkbox' name='documentSecurityDepositConfirmation' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentSecurityDepositConfirmation' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentSecurityDepositConfirmation' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                  <%
                                                   conn.Open()
                                                   Dim errorDocumentSecurityDepositConfirmationErrorID As Integer
                                                   Dim errorDocumentSecurityDepositConfirmationID As Integer
                                                   Dim detailsDocumentSecurityDepositConfirmation As String
                                                   Dim noticeTypeDocumentSecurityDepositConfirmation As String
                                                   Dim statusDocumentSecurityDepositConfirmation As String
                                                   Dim errorStaffNameDocumentSecurityDepositConfirmation As String
                                                   Dim errorDocumentSecurityDepositConfirmationReviewTypeID As Integer
                                                      Dim errorsSecurityDepositConfirmationList As New ArrayList
                                                      Dim processDocumentSecurityDepositConfirmationErrorID As Integer
                                                        
                                                    Dim queryDocumentSecurityDepositConfirmationError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '35' AND fk_FileID = '" & fileID & "'", conn)
                                                   Dim readerDocumentSecurityDepositConfirmationError As SqlDataReader = queryDocumentSecurityDepositConfirmationError.ExecuteReader()
                                                   If readerDocumentSecurityDepositConfirmationError.HasRows Then
                                                       While readerDocumentSecurityDepositConfirmationError.Read
                                                           errorDocumentSecurityDepositConfirmationErrorID = CStr(readerDocumentSecurityDepositConfirmationError("fk_ErrorID"))
                                                           errorsSecurityDepositConfirmationList.Add(errorDocumentSecurityDepositConfirmationErrorID)
                                                       End While
                                                   End If
                                                   conn.Close()
                                           
                                                   conn.Open()
                                                   Dim errorSecurityDepositConfirmationIndex As Integer
                                                   For Each errorSecurityDepositConfirmationIndex In errorsSecurityDepositConfirmationList
                                                          Dim queryDocumentSecurityDepositConfirmation As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorSecurityDepositConfirmationIndex & "'", conn)
                                                       Dim readerDocumentSecurityDepositConfirmation As SqlDataReader = queryDocumentSecurityDepositConfirmation.ExecuteReader()
                                                       While readerDocumentSecurityDepositConfirmation.Read
                                                           errorDocumentSecurityDepositConfirmationID = CStr(readerDocumentSecurityDepositConfirmation("ErrorID"))
                                                           detailsDocumentSecurityDepositConfirmation = CStr(readerDocumentSecurityDepositConfirmation("Details"))
                                                           noticeTypeDocumentSecurityDepositConfirmation = CStr(readerDocumentSecurityDepositConfirmation("Notice"))
                                                           statusDocumentSecurityDepositConfirmation = CStr(readerDocumentSecurityDepositConfirmation("Status"))
                                                           errorStaffNameDocumentSecurityDepositConfirmation = CStr(readerDocumentSecurityDepositConfirmation("ErrorStaffName"))
                                                           errorDocumentSecurityDepositConfirmationReviewTypeID = CStr(readerDocumentSecurityDepositConfirmation("fk_ReviewTypeID"))
                                                             processDocumentSecurityDepositConfirmationErrorID = CStr(readerDocumentSecurityDepositConfirmation("fk_ProcessTypeID"))
                                                              %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentSecurityDepositConfirmation) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentSecurityDepositConfirmation)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentSecurityDepositConfirmation) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentSecurityDepositConfirmation) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentSecurityDepositConfirmationID) %>&ReviewTypeID=<% Response.Write(errorDocumentSecurityDepositConfirmationReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentSecurityDepositConfirmationErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                                <div class="clearfix"></div>
                                                                 <br />
                                                                <%
                                                                End While
                                                                    Next
                                                            conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeSecurityDepositConfirmation" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeSecurityDepositConfirmation" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeSecurityDepositConfirmation" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentSecurityDepositConfirmation" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerSecurityDepositConfirmation" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerSecurityDepositConfirmation" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerSecurityDepositConfirmation" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusSecurityDepositConfirmation" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateSecurityDepositConfirmation" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="important-notice-to-owner-and-tenant">
                                                <h6>Important Notice to Owner and Tenant
                                                    &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("36") Then
                                                                 Response.Write("<input type='checkbox' name='documentImportantNoticeToOwnerAndTenant' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentImportantNoticeToOwnerAndTenant' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentImportantNoticeToOwnerAndTenant' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                  <%
                                                   conn.Open()
                                                   Dim errorDocumentImportantNoticeToOwnerAndTenantErrorID As Integer
                                                   Dim errorDocumentImportantNoticeToOwnerAndTenantID As Integer
                                                   Dim detailsDocumentImportantNoticeToOwnerAndTenant As String
                                                   Dim noticeTypeDocumentImportantNoticeToOwnerAndTenant As String
                                                   Dim statusDocumentImportantNoticeToOwnerAndTenant As String
                                                   Dim errorStaffNameDocumentImportantNoticeToOwnerAndTenant As String
                                                   Dim errorDocumentImportantNoticeToOwnerAndTenantReviewTypeID As Integer
                                                      Dim errorsImportantNoticeToOwnerAndTenantList As New ArrayList
                                                      Dim processDocumentImportantNoticeToOwnerAndTenantErrorID As Integer
                                                        
                                                      Dim queryDocumentImportantNoticeToOwnerAndTenantError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '36' AND fk_FileID = '" & fileID & "'", conn)
                                                   Dim readerDocumentImportantNoticeToOwnerAndTenantError As SqlDataReader = queryDocumentImportantNoticeToOwnerAndTenantError.ExecuteReader()
                                                   If readerDocumentImportantNoticeToOwnerAndTenantError.HasRows Then
                                                       While readerDocumentImportantNoticeToOwnerAndTenantError.Read
                                                           errorDocumentImportantNoticeToOwnerAndTenantErrorID = CStr(readerDocumentImportantNoticeToOwnerAndTenantError("fk_ErrorID"))
                                                           errorsImportantNoticeToOwnerAndTenantList.Add(errorDocumentImportantNoticeToOwnerAndTenantErrorID)
                                                       End While
                                                   End If
                                                   conn.Close()
                                           
                                                   conn.Open()
                                                   Dim errorImportantNoticeToOwnerAndTenantIndex As Integer
                                                   For Each errorImportantNoticeToOwnerAndTenantIndex In errorsImportantNoticeToOwnerAndTenantList
                                                          Dim queryDocumentImportantNoticeToOwnerAndTenant As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorImportantNoticeToOwnerAndTenantIndex & "'", conn)
                                                       Dim readerDocumentImportantNoticeToOwnerAndTenant As SqlDataReader = queryDocumentImportantNoticeToOwnerAndTenant.ExecuteReader()
                                                       While readerDocumentImportantNoticeToOwnerAndTenant.Read
                                                           errorDocumentImportantNoticeToOwnerAndTenantID = CStr(readerDocumentImportantNoticeToOwnerAndTenant("ErrorID"))
                                                           detailsDocumentImportantNoticeToOwnerAndTenant = CStr(readerDocumentImportantNoticeToOwnerAndTenant("Details"))
                                                           noticeTypeDocumentImportantNoticeToOwnerAndTenant = CStr(readerDocumentImportantNoticeToOwnerAndTenant("Notice"))
                                                           statusDocumentImportantNoticeToOwnerAndTenant = CStr(readerDocumentImportantNoticeToOwnerAndTenant("Status"))
                                                           errorStaffNameDocumentImportantNoticeToOwnerAndTenant = CStr(readerDocumentImportantNoticeToOwnerAndTenant("ErrorStaffName"))
                                                              errorDocumentImportantNoticeToOwnerAndTenantReviewTypeID = CStr(readerDocumentImportantNoticeToOwnerAndTenant("fk_ReviewTypeID"))
                                                              processDocumentImportantNoticeToOwnerAndTenantErrorID = CStr(readerDocumentImportantNoticeToOwnerAndTenant("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentImportantNoticeToOwnerAndTenant) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentImportantNoticeToOwnerAndTenant)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentImportantNoticeToOwnerAndTenant) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentImportantNoticeToOwnerAndTenant) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentImportantNoticeToOwnerAndTenantID) %>&ReviewTypeID=<% Response.Write(errorDocumentImportantNoticeToOwnerAndTenantReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentImportantNoticeToOwnerAndTenantErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                                <div class="clearfix"></div>
                                                                 <br />
                                                                <%
                                                                End While
                                                                    Next
                                                            conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeImportantNoticeToOwnerAndTenant" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeImportantNoticeToOwnerAndTenant" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeImportantNoticeToOwnerAndTenant" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentImportantNoticeToOwnerAndTenant" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerImportantNoticeToOwnerAndTenant" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerImportantNoticeToOwnerAndTenant" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerImportantNoticeToOwnerAndTenant" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusImportantNoticeToOwnerAndTenant" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateImportantNoticeToOwnerAndTenant" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix"></div>
                                                <hr />
                                            </div>
                                            <div id="hqs-inspection-certification-tenant">
                                                <h6>HQS Inspection Certification - Tenant
                                                    &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("37") Then
                                                                 Response.Write("<input type='checkbox' name='documentHqsInspectionCertificationTenant' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentHqsInspectionCertificationTenant' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentHqsInspectionCertificationTenant' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                  <%
                                                   conn.Open()
                                                   Dim errorDocumentHqsInspectionCertificationTenantErrorID As Integer
                                                   Dim errorDocumentHqsInspectionCertificationTenantID As Integer
                                                   Dim detailsDocumentHqsInspectionCertificationTenant As String
                                                   Dim noticeTypeDocumentHqsInspectionCertificationTenant As String
                                                   Dim statusDocumentHqsInspectionCertificationTenant As String
                                                   Dim errorStaffNameDocumentHqsInspectionCertificationTenant As String
                                                   Dim errorDocumentHqsInspectionCertificationTenantReviewTypeID As Integer
                                                      Dim errorsHqsInspectionCertificationTenantList As New ArrayList
                                                      Dim processDocumentHqsInspectionCertificationTenantErrorID As Integer
                                                        
                                                    Dim queryDocumentHqsInspectionCertificationTenantError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '37' AND fk_FileID = '" & fileID & "'", conn)
                                                   Dim readerDocumentHqsInspectionCertificationTenantError As SqlDataReader = queryDocumentHqsInspectionCertificationTenantError.ExecuteReader()
                                                   If readerDocumentHqsInspectionCertificationTenantError.HasRows Then
                                                       While readerDocumentHqsInspectionCertificationTenantError.Read
                                                           errorDocumentHqsInspectionCertificationTenantErrorID = CStr(readerDocumentHqsInspectionCertificationTenantError("fk_ErrorID"))
                                                           errorsHqsInspectionCertificationTenantList.Add(errorDocumentHqsInspectionCertificationTenantErrorID)
                                                       End While
                                                   End If
                                                   conn.Close()
                                           
                                                   conn.Open()
                                                   Dim errorHqsInspectionCertificationTenantIndex As Integer
                                                   For Each errorHqsInspectionCertificationTenantIndex In errorsHqsInspectionCertificationTenantList
                                                          Dim queryDocumentHqsInspectionCertificationTenant As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorHqsInspectionCertificationTenantIndex & "'", conn)
                                                       Dim readerDocumentHqsInspectionCertificationTenant As SqlDataReader = queryDocumentHqsInspectionCertificationTenant.ExecuteReader()
                                                       While readerDocumentHqsInspectionCertificationTenant.Read
                                                           errorDocumentHqsInspectionCertificationTenantID = CStr(readerDocumentHqsInspectionCertificationTenant("ErrorID"))
                                                           detailsDocumentHqsInspectionCertificationTenant = CStr(readerDocumentHqsInspectionCertificationTenant("Details"))
                                                           noticeTypeDocumentHqsInspectionCertificationTenant = CStr(readerDocumentHqsInspectionCertificationTenant("Notice"))
                                                           statusDocumentHqsInspectionCertificationTenant = CStr(readerDocumentHqsInspectionCertificationTenant("Status"))
                                                           errorStaffNameDocumentHqsInspectionCertificationTenant = CStr(readerDocumentHqsInspectionCertificationTenant("ErrorStaffName"))
                                                              errorDocumentHqsInspectionCertificationTenantReviewTypeID = CStr(readerDocumentHqsInspectionCertificationTenant("fk_ReviewTypeID"))
                                                              processDocumentHqsInspectionCertificationTenantErrorID = CStr(readerDocumentHqsInspectionCertificationTenant("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentHqsInspectionCertificationTenant) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentHqsInspectionCertificationTenant)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentHqsInspectionCertificationTenant) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentHqsInspectionCertificationTenant) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentHqsInspectionCertificationTenantID) %>&ReviewTypeID=<% Response.Write(errorDocumentHqsInspectionCertificationTenantReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentHqsInspectionCertificationTenantErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                                <div class="clearfix"></div>
                                                                 <br />
                                                                <%
                                                                End While
                                                                    Next
                                                            conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeHqsInspectionCertificationTenant" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeHqsInspectionCertificationTenant" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeHqsInspectionCertificationTenant" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentHqsInspectionCertificationTenant" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerHqsInspectionCertificationTenant" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerHqsInspectionCertificationTenant" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerHqsInspectionCertificationTenant" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusHqsInspectionCertificationTenant" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateHqsInspectionCertificationTenant" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="hqs-inspection-certification-owner">
                                                <h6>HQS Inspection Certification - Owner
                                                    &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("38") Then
                                                                 Response.Write("<input type='checkbox' name='documentHqsInspectionCertificationOwner' checked='checked' />")
                                                            Else
                                                                 Response.Write("<input type='checkbox' name='documentHqsInspectionCertificationOwner' />")
                                                            End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentHqsInspectionCertificationOwner' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                <%
                                                   conn.Open()
                                                   Dim errorDocumentHqsInspectionCertificationOwnerErrorID As Integer
                                                   Dim errorDocumentHqsInspectionCertificationOwnerID As Integer
                                                   Dim detailsDocumentHqsInspectionCertificationOwner As String
                                                   Dim noticeTypeDocumentHqsInspectionCertificationOwner As String
                                                   Dim statusDocumentHqsInspectionCertificationOwner As String
                                                   Dim errorStaffNameDocumentHqsInspectionCertificationOwner As String
                                                   Dim errorDocumentHqsInspectionCertificationOwnerReviewTypeID As Integer
                                                    Dim errorsHqsInspectionCertificationOwnerList As New ArrayList
                                                    Dim processDocumentHqsInspectionCertificationOwnerErrorID As Integer
                                                        
                                                    Dim queryDocumentHqsInspectionCertificationOwnerError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = 38 AND fk_FileID = '" & fileID & "'", conn)
                                                   Dim readerDocumentHqsInspectionCertificationOwnerError As SqlDataReader = queryDocumentHqsInspectionCertificationOwnerError.ExecuteReader()
                                                   If readerDocumentHqsInspectionCertificationOwnerError.HasRows Then
                                                       While readerDocumentHqsInspectionCertificationOwnerError.Read
                                                           errorDocumentHqsInspectionCertificationOwnerErrorID = CStr(readerDocumentHqsInspectionCertificationOwnerError("fk_ErrorID"))
                                                           errorsHqsInspectionCertificationOwnerList.Add(errorDocumentHqsInspectionCertificationOwnerErrorID)
                                                       End While
                                                   End If
                                                   conn.Close()
                                           
                                                   conn.Open()
                                                   Dim errorHqsInspectionCertificationOwnerIndex As Integer
                                                   For Each errorHqsInspectionCertificationOwnerIndex In errorsHqsInspectionCertificationOwnerList
                                                        Dim queryDocumentHqsInspectionCertificationOwner As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorHqsInspectionCertificationOwnerIndex & "'", conn)
                                                       Dim readerDocumentHqsInspectionCertificationOwner As SqlDataReader = queryDocumentHqsInspectionCertificationOwner.ExecuteReader()
                                                       While readerDocumentHqsInspectionCertificationOwner.Read
                                                           errorDocumentHqsInspectionCertificationOwnerID = CStr(readerDocumentHqsInspectionCertificationOwner("ErrorID"))
                                                           detailsDocumentHqsInspectionCertificationOwner = CStr(readerDocumentHqsInspectionCertificationOwner("Details"))
                                                           noticeTypeDocumentHqsInspectionCertificationOwner = CStr(readerDocumentHqsInspectionCertificationOwner("Notice"))
                                                           statusDocumentHqsInspectionCertificationOwner = CStr(readerDocumentHqsInspectionCertificationOwner("Status"))
                                                           errorStaffNameDocumentHqsInspectionCertificationOwner = CStr(readerDocumentHqsInspectionCertificationOwner("ErrorStaffName"))
                                                           errorDocumentHqsInspectionCertificationOwnerReviewTypeID = CStr(readerDocumentHqsInspectionCertificationOwner("fk_ReviewTypeID"))
                                                           processDocumentHqsInspectionCertificationOwnerErrorID = CStr(readerDocumentHqsInspectionCertificationOwner("fk_ProcessTypeID"))
                                                            %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentHqsInspectionCertificationOwner) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentHqsInspectionCertificationOwner)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentHqsInspectionCertificationOwner) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentHqsInspectionCertificationOwner) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentHqsInspectionCertificationOwnerID) %>&ReviewTypeID=<% Response.Write(errorDocumentHqsInspectionCertificationOwnerReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentHqsInspectionCertificationOwnerErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                                <div class="clearfix"></div>
                                                                 <br />
                                                                <%
                                                                End While
                                                                    Next
                                                            conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeHqsInspectionCertificationOwner" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeHqsInspectionCertificationOwner" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeHqsInspectionCertificationOwner" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentHqsInspectionCertificationOwner" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerHqsInspectionCertificationOwner" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerHqsInspectionCertificationOwner" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerHqsInspectionCertificationOwner" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusHqsInspectionCertificationOwner" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateHqsInspectionCertificationOwner" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="lead-based-paint-disclosure-and-certification">
                                                <h6> Lead Based Paint Disclosure and Certification
                                                    &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("39") Then
                                                                 Response.Write("<input type='checkbox' name='documentLeadBasedPaintDisclosureAndCertification' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentLeadBasedPaintDisclosureAndCertification' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentLeadBasedPaintDisclosureAndCertification' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                     <%
                                                   conn.Open()
                                                   Dim errorDocumentLeadBasedPaintDisclosureAndCertificationErrorID As Integer
                                                   Dim errorDocumentLeadBasedPaintDisclosureAndCertificationID As Integer
                                                   Dim detailsDocumentLeadBasedPaintDisclosureAndCertification As String
                                                   Dim noticeTypeDocumentLeadBasedPaintDisclosureAndCertification As String
                                                   Dim statusDocumentLeadBasedPaintDisclosureAndCertification As String
                                                   Dim errorStaffNameDocumentLeadBasedPaintDisclosureAndCertification As String
                                                   Dim errorDocumentLeadBasedPaintDisclosureAndCertificationReviewTypeID As Integer
                                                         Dim errorsLeadBasedPaintDisclosureAndCertificationList As New ArrayList
                                                         Dim processDocumentLeadBasedPaintDisclosureAndCertificationErrorID As Integer
                                                        
                                                    Dim queryDocumentLeadBasedPaintDisclosureAndCertificationError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '39' AND fk_FileID = '" & fileID & "'", conn)
                                                   Dim readerDocumentLeadBasedPaintDisclosureAndCertificationError As SqlDataReader = queryDocumentLeadBasedPaintDisclosureAndCertificationError.ExecuteReader()
                                                   If readerDocumentLeadBasedPaintDisclosureAndCertificationError.HasRows Then
                                                       While readerDocumentLeadBasedPaintDisclosureAndCertificationError.Read
                                                           errorDocumentLeadBasedPaintDisclosureAndCertificationErrorID = CStr(readerDocumentLeadBasedPaintDisclosureAndCertificationError("fk_ErrorID"))
                                                           errorsLeadBasedPaintDisclosureAndCertificationList.Add(errorDocumentLeadBasedPaintDisclosureAndCertificationErrorID)
                                                       End While
                                                   End If
                                                   conn.Close()
                                           
                                                   conn.Open()
                                                   Dim errorLeadBasedPaintDisclosureAndCertificationIndex As Integer
                                                   For Each errorLeadBasedPaintDisclosureAndCertificationIndex In errorsLeadBasedPaintDisclosureAndCertificationList
                                                             Dim queryDocumentLeadBasedPaintDisclosureAndCertification As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorLeadBasedPaintDisclosureAndCertificationIndex & "'", conn)
                                                       Dim readerDocumentLeadBasedPaintDisclosureAndCertification As SqlDataReader = queryDocumentLeadBasedPaintDisclosureAndCertification.ExecuteReader()
                                                       While readerDocumentLeadBasedPaintDisclosureAndCertification.Read
                                                           errorDocumentLeadBasedPaintDisclosureAndCertificationID = CStr(readerDocumentLeadBasedPaintDisclosureAndCertification("ErrorID"))
                                                           detailsDocumentLeadBasedPaintDisclosureAndCertification = CStr(readerDocumentLeadBasedPaintDisclosureAndCertification("Details"))
                                                           noticeTypeDocumentLeadBasedPaintDisclosureAndCertification = CStr(readerDocumentLeadBasedPaintDisclosureAndCertification("Notice"))
                                                           statusDocumentLeadBasedPaintDisclosureAndCertification = CStr(readerDocumentLeadBasedPaintDisclosureAndCertification("Status"))
                                                           errorStaffNameDocumentLeadBasedPaintDisclosureAndCertification = CStr(readerDocumentLeadBasedPaintDisclosureAndCertification("ErrorStaffName"))
                                                                 errorDocumentLeadBasedPaintDisclosureAndCertificationReviewTypeID = CStr(readerDocumentLeadBasedPaintDisclosureAndCertification("fk_ReviewTypeID"))
                                                                 processDocumentLeadBasedPaintDisclosureAndCertificationErrorID = CStr(readerDocumentLeadBasedPaintDisclosureAndCertification("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentLeadBasedPaintDisclosureAndCertification) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentLeadBasedPaintDisclosureAndCertification)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentLeadBasedPaintDisclosureAndCertification) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentLeadBasedPaintDisclosureAndCertification) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentLeadBasedPaintDisclosureAndCertificationID) %>&ReviewTypeID=<% Response.Write(errorDocumentLeadBasedPaintDisclosureAndCertificationReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentLeadBasedPaintDisclosureAndCertificationErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                                <div class="clearfix"></div>
                                                                 <br />
                                                                <%
                                                                End While
                                                                    Next
                                                            conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeLeadBasedPaintDisclosureAndCertification" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeLeadBasedPaintDisclosureAndCertification" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeLeadBasedPaintDisclosureAndCertification" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentLeadBasedPaintDisclosureAndCertification" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerLeadBasedPaintDisclosureAndCertification" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerLeadBasedPaintDisclosureAndCertification" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerLeadBasedPaintDisclosureAndCertification" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusLeadBasedPaintDisclosureAndCertification" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateLeadBasedPaintDisclosureAndCertification" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="housing-search-log">
                                                <h6> Housing Search Log (if applicable)
                                                    &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("40") Then
                                                                 Response.Write("<input type='checkbox' name='documentHousingSearchLogIfApplicable' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentHousingSearchLogIfApplicable' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentHousingSearchLogIfApplicable' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                       <%
                                                   conn.Open()
                                                   Dim errorDocumentHousingSearchLogIfApplicableErrorID As Integer
                                                   Dim errorDocumentHousingSearchLogIfApplicableID As Integer
                                                   Dim detailsDocumentHousingSearchLogIfApplicable As String
                                                   Dim noticeTypeDocumentHousingSearchLogIfApplicable As String
                                                   Dim statusDocumentHousingSearchLogIfApplicable As String
                                                   Dim errorStaffNameDocumentHousingSearchLogIfApplicable As String
                                                   Dim errorDocumentHousingSearchLogIfApplicableReviewTypeID As Integer
                                                           Dim errorsHousingSearchLogIfApplicableList As New ArrayList
                                                           Dim processDocumentHousingSearchLogIfApplicableErrorID As Integer
                                                        
                                                    Dim queryDocumentHousingSearchLogIfApplicableError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '40' AND fk_FileID = '" & fileID & "'", conn)
                                                   Dim readerDocumentHousingSearchLogIfApplicableError As SqlDataReader = queryDocumentHousingSearchLogIfApplicableError.ExecuteReader()
                                                   If readerDocumentHousingSearchLogIfApplicableError.HasRows Then
                                                       While readerDocumentHousingSearchLogIfApplicableError.Read
                                                           errorDocumentHousingSearchLogIfApplicableErrorID = CStr(readerDocumentHousingSearchLogIfApplicableError("fk_ErrorID"))
                                                           errorsHousingSearchLogIfApplicableList.Add(errorDocumentHousingSearchLogIfApplicableErrorID)
                                                       End While
                                                   End If
                                                   conn.Close()
                                           
                                                   conn.Open()
                                                   Dim errorHousingSearchLogIfApplicableIndex As Integer
                                                   For Each errorHousingSearchLogIfApplicableIndex In errorsHousingSearchLogIfApplicableList
                                                               Dim queryDocumentHousingSearchLogIfApplicable As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorHousingSearchLogIfApplicableIndex & "'", conn)
                                                       Dim readerDocumentHousingSearchLogIfApplicable As SqlDataReader = queryDocumentHousingSearchLogIfApplicable.ExecuteReader()
                                                       While readerDocumentHousingSearchLogIfApplicable.Read
                                                           errorDocumentHousingSearchLogIfApplicableID = CStr(readerDocumentHousingSearchLogIfApplicable("ErrorID"))
                                                           detailsDocumentHousingSearchLogIfApplicable = CStr(readerDocumentHousingSearchLogIfApplicable("Details"))
                                                           noticeTypeDocumentHousingSearchLogIfApplicable = CStr(readerDocumentHousingSearchLogIfApplicable("Notice"))
                                                           statusDocumentHousingSearchLogIfApplicable = CStr(readerDocumentHousingSearchLogIfApplicable("Status"))
                                                           errorStaffNameDocumentHousingSearchLogIfApplicable = CStr(readerDocumentHousingSearchLogIfApplicable("ErrorStaffName"))
                                                           errorDocumentHousingSearchLogIfApplicableReviewTypeID = CStr(readerDocumentHousingSearchLogIfApplicable("fk_ReviewTypeID"))
                                                             processDocumentHousingSearchLogIfApplicableErrorID = CStr(readerDocumentHousingSearchLogIfApplicable("fk_ProcessTypeID"))
                                                                   %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentHousingSearchLogIfApplicable) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentHousingSearchLogIfApplicable)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentHousingSearchLogIfApplicable) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentHousingSearchLogIfApplicable) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentHousingSearchLogIfApplicableID) %>&ReviewTypeID=<% Response.Write(errorDocumentHousingSearchLogIfApplicableReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentHousingSearchLogIfApplicableErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                                <div class="clearfix"></div>
                                                                 <br />
                                                                <%
                                                                End While
                                                                    Next
                                                            conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeHousingSearchLogIfApplicable" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeHousingSearchLogIfApplicable" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeHousingSearchLogIfApplicable" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentHousingSearchLogIfApplicable" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerHousingSearchLogIfApplicable" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerHousingSearchLogIfApplicable" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerHousingSearchLogIfApplicable" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusHousingSearchLogIfApplicable" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateHousingSearchLogIfApplicable" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix"></div>
                                                <hr />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel panel-success">
                                    <div class="panel-heading" role="tab" id="headingTwo">
                                        <h4 class="panel-title">
                                            <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion"
                                                href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo"><i class="fa fa-shield" aria-hidden="true"></i> Master Documents</a>
                                        </h4>
                                    </div>
                                    <div id="collapseTwo" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                                        <div class="panel-body">
                                            <div class="panel-body">
                                                <hr />
                                                <div id="initial-rent-letter">
                                                <h6>Initial Rent Letter
                                                    &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("41") Then
                                                                 Response.Write("<input type='checkbox' name='documentInitialRentLetter' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentInitialRentLetter' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentInitialRentLetter' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                       <%
                                                   conn.Open()
                                                   Dim errorDocumentInitialRentLetterErrorID As Integer
                                                   Dim errorDocumentInitialRentLetterID As Integer
                                                   Dim detailsDocumentInitialRentLetter As String
                                                   Dim noticeTypeDocumentInitialRentLetter As String
                                                   Dim statusDocumentInitialRentLetter As String
                                                   Dim errorStaffNameDocumentInitialRentLetter As String
                                                   Dim errorDocumentInitialRentLetterReviewTypeID As Integer
                                                           Dim errorsInitialRentLetterList As New ArrayList
                                                           Dim processDocumentInitialRentLetterErrorID As Integer
                                                        
                                                    Dim queryDocumentInitialRentLetterError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '41' AND fk_FileID = '" & fileID & "'", conn)
                                                   Dim readerDocumentInitialRentLetterError As SqlDataReader = queryDocumentInitialRentLetterError.ExecuteReader()
                                                   If readerDocumentInitialRentLetterError.HasRows Then
                                                       While readerDocumentInitialRentLetterError.Read
                                                           errorDocumentInitialRentLetterErrorID = CStr(readerDocumentInitialRentLetterError("fk_ErrorID"))
                                                           errorsInitialRentLetterList.Add(errorDocumentInitialRentLetterErrorID)
                                                       End While
                                                   End If
                                                   conn.Close()
                                           
                                                   conn.Open()
                                                   Dim errorInitialRentLetterIndex As Integer
                                                   For Each errorInitialRentLetterIndex In errorsInitialRentLetterList
                                                               Dim queryDocumentInitialRentLetter As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorInitialRentLetterIndex & "'", conn)
                                                       Dim readerDocumentInitialRentLetter As SqlDataReader = queryDocumentInitialRentLetter.ExecuteReader()
                                                       While readerDocumentInitialRentLetter.Read
                                                           errorDocumentInitialRentLetterID = CStr(readerDocumentInitialRentLetter("ErrorID"))
                                                           detailsDocumentInitialRentLetter = CStr(readerDocumentInitialRentLetter("Details"))
                                                           noticeTypeDocumentInitialRentLetter = CStr(readerDocumentInitialRentLetter("Notice"))
                                                           statusDocumentInitialRentLetter = CStr(readerDocumentInitialRentLetter("Status"))
                                                           errorStaffNameDocumentInitialRentLetter = CStr(readerDocumentInitialRentLetter("ErrorStaffName"))
                                                           errorDocumentInitialRentLetterReviewTypeID = CStr(readerDocumentInitialRentLetter("fk_ReviewTypeID"))
                                                             processDocumentInitialRentLetterErrorID = CStr(readerDocumentInitialRentLetter("fk_ProcessTypeID"))
                                                                   %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentInitialRentLetter) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentInitialRentLetter)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentInitialRentLetter) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentInitialRentLetter) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentInitialRentLetterID) %>&ReviewTypeID=<% Response.Write(errorDocumentInitialRentLetterReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentInitialRentLetterErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                                <div class="clearfix"></div>
                                                                 <br />
                                                                <%
                                                                End While
                                                                    Next
                                                            conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeInitialRentLetter" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeInitialRentLetter" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeInitialRentLetter" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentInitialRentLetter" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerInitialRentLetter" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerInitialRentLetter" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerInitialRentLetter" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusInitialRentLetter" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateInitialRentLetter" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix"></div>
                                                <hr />
                                            </div>
                                                <div id="initial-hud-form-50058">
                                                <h6> Initial HUD Form 50058
                                                    &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("42") Then
                                                                 Response.Write("<input type='checkbox' name='documentInitialHudForm50058' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentInitialHudForm50058' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentInitialHudForm50058' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                            <%
                                                conn.Open()
                                                Dim errorDocumentInitialHudForm50058ErrorID As Integer
                                                Dim errorDocumentInitialHudForm50058ID As Integer
                                                Dim detailsDocumentInitialHudForm50058 As String
                                                Dim noticeTypeDocumentInitialHudForm50058 As String
                                                Dim statusDocumentInitialHudForm50058 As String
                                                Dim errorStaffNameDocumentInitialHudForm50058 As String
                                                Dim errorDocumentInitialHudForm50058ReviewTypeID As Integer
                                                Dim errorsInitialHudForm50058List As New ArrayList
                                                Dim processDocumentInitialHudForm50058ErrorID As Integer
                                                        
                                                Dim queryDocumentInitialHudForm50058Error As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '42' AND fk_FileID = '" & fileID & "'", conn)
                                                Dim readerDocumentInitialHudForm50058Error As SqlDataReader = queryDocumentInitialHudForm50058Error.ExecuteReader()
                                                If readerDocumentInitialHudForm50058Error.HasRows Then
                                                    While readerDocumentInitialHudForm50058Error.Read
                                                        errorDocumentInitialHudForm50058ErrorID = CStr(readerDocumentInitialHudForm50058Error("fk_ErrorID"))
                                                        errorsInitialHudForm50058List.Add(errorDocumentInitialHudForm50058ErrorID)
                                                    End While
                                                End If
                                                conn.Close()
                                           
                                                conn.Open()
                                                Dim errorInitialHudForm50058Index As Integer
                                                For Each errorInitialHudForm50058Index In errorsInitialHudForm50058List
                                                    Dim queryDocumentInitialHudForm50058 As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorInitialHudForm50058Index & "'", conn)
                                                    Dim readerDocumentInitialHudForm50058 As SqlDataReader = queryDocumentInitialHudForm50058.ExecuteReader()
                                                    While readerDocumentInitialHudForm50058.Read
                                                        errorDocumentInitialHudForm50058ID = CStr(readerDocumentInitialHudForm50058("ErrorID"))
                                                        detailsDocumentInitialHudForm50058 = CStr(readerDocumentInitialHudForm50058("Details"))
                                                        noticeTypeDocumentInitialHudForm50058 = CStr(readerDocumentInitialHudForm50058("Notice"))
                                                        statusDocumentInitialHudForm50058 = CStr(readerDocumentInitialHudForm50058("Status"))
                                                        errorStaffNameDocumentInitialHudForm50058 = CStr(readerDocumentInitialHudForm50058("ErrorStaffName"))
                                                        errorDocumentInitialHudForm50058ReviewTypeID = CStr(readerDocumentInitialHudForm50058("fk_ReviewTypeID"))
                                                        processDocumentInitialHudForm50058ErrorID = CStr(readerDocumentInitialHudForm50058("fk_ProcessTypeID"))
                                                        %>
                                                                <div class="col-md-2"> 
                                            <h6>Notice</h6>
                                                <br />
                                                <div class="form-group">
                                                    <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentInitialHudForm50058) %>" type="text" />
                                                </div>
                                            </div>
                                                            <div class="col-md-4"> 
                                            <h6>Comments</h6>
                                        <br />
                                            <div class="form-group">
                                            <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentInitialHudForm50058)%></textarea>
                                        </div>
                                            </div>
                                                            <div class="col-md-2"> 
                                            <h6>Staff</h6>
                                            <br />
                                            <div class="form-group">
                                            <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentInitialHudForm50058) %>" type="text" />
                                        </div>
                                            </div>
                                                            <div class="col-md-2"> 
                                            <h6>Status</h6>
                                                <br />
                                            <div class="form-group">
                                            <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentInitialHudForm50058) %>"  type="text" />
                                            </div>
                                            </div>
                                                            <div class="text-center">
                                                <br /><br />
                                                <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentInitialHudForm50058ID) %>&ReviewTypeID=<% Response.Write(errorDocumentInitialHudForm50058ReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentInitialHudForm50058ErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                            </div>
                                                            <div class="clearfix"></div>
                                                                <br />
                                                            <%
                                                            End While
                                                                Next
                                                        conn.Close()
                                        %>
                                            <div class="col-md-2">
                                                <div class="form-group">
                                                    <asp:DropDownList ID="NoticeTypeInitialHudForm50058" runat="server" 
                                                class="form-control border-input" DataSourceID="SqlNoticeTypeInitialHudForm50058" 
                                                DataTextField="Notice" DataValueField="NoticeTypeID">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="SqlNoticeTypeInitialHudForm50058" runat="server" 
                                                ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                            </asp:SqlDataSource>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="form-group">
                                                    <textarea class="form-control border-input" cols="4" name="commentInitialHudForm50058" placeholder="Comment"
                                                        rows="1"></textarea>
                                                </div>
                                            </div>
                                            <div class="col-md-2">
                                                <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerInitialHudForm50058" runat="server" class="form-control border-input"
                                                        DataSourceID="SqlCaseManagerInitialHudForm50058" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerInitialHudForm50058" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                        SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                </div>
                                            </div>
                                            <div class="col-md-2">
                                                <div class="form-group">
                                                    <asp:DropDownList ID="StatusInitialHudForm50058" class="form-control border-input" runat="server">
                                                    <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                    <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                    <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="text-center">
                                                    <asp:Button ID="btnCreateInitialHudForm50058" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                            </div>
                                            <div class="clearfix">
                                            </div>
                                            <hr />
                                        </div>
                                                <div id="initial-rent-calculation-sheet">
                                                <h6>Initial Rent Calculation Sheet
                                                    &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("43") Then
                                                                 Response.Write("<input type='checkbox' name='documentInitialRentCalculationSheet' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentInitialRentCalculationSheet' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentInitialRentCalculationSheet' />")
                                                        End If
                                                     %>
                                                </h6>
                                            <br />
                                                        <%
                                                conn.Open()
                                                Dim errorDocumentInitialRentCalculationSheetErrorID As Integer
                                                Dim errorDocumentInitialRentCalculationSheetID As Integer
                                                Dim detailsDocumentInitialRentCalculationSheet As String
                                                Dim noticeTypeDocumentInitialRentCalculationSheet As String
                                                Dim statusDocumentInitialRentCalculationSheet As String
                                                Dim errorStaffNameDocumentInitialRentCalculationSheet As String
                                                Dim errorDocumentInitialRentCalculationSheetReviewTypeID As Integer
                                                            Dim errorsInitialRentCalculationSheetList As New ArrayList
                                                            Dim processDocumentInitialRentCalculationSheetErrorID As Integer
                                                        
                                                            Dim queryDocumentInitialRentCalculationSheetError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '43' AND fk_FileID = '" & fileID & "'", conn)
                                                Dim readerDocumentInitialRentCalculationSheetError As SqlDataReader = queryDocumentInitialRentCalculationSheetError.ExecuteReader()
                                                If readerDocumentInitialRentCalculationSheetError.HasRows Then
                                                    While readerDocumentInitialRentCalculationSheetError.Read
                                                        errorDocumentInitialRentCalculationSheetErrorID = CStr(readerDocumentInitialRentCalculationSheetError("fk_ErrorID"))
                                                        errorsInitialRentCalculationSheetList.Add(errorDocumentInitialRentCalculationSheetErrorID)
                                                    End While
                                                End If
                                                conn.Close()
                                           
                                                conn.Open()
                                                Dim errorInitialRentCalculationSheetIndex As Integer
                                                For Each errorInitialRentCalculationSheetIndex In errorsInitialRentCalculationSheetList
                                                                Dim queryDocumentInitialRentCalculationSheet As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorInitialRentCalculationSheetIndex & "'", conn)
                                                    Dim readerDocumentInitialRentCalculationSheet As SqlDataReader = queryDocumentInitialRentCalculationSheet.ExecuteReader()
                                                    While readerDocumentInitialRentCalculationSheet.Read
                                                        errorDocumentInitialRentCalculationSheetID = CStr(readerDocumentInitialRentCalculationSheet("ErrorID"))
                                                        detailsDocumentInitialRentCalculationSheet = CStr(readerDocumentInitialRentCalculationSheet("Details"))
                                                        noticeTypeDocumentInitialRentCalculationSheet = CStr(readerDocumentInitialRentCalculationSheet("Notice"))
                                                        statusDocumentInitialRentCalculationSheet = CStr(readerDocumentInitialRentCalculationSheet("Status"))
                                                        errorStaffNameDocumentInitialRentCalculationSheet = CStr(readerDocumentInitialRentCalculationSheet("ErrorStaffName"))
                                                        errorDocumentInitialRentCalculationSheetReviewTypeID = CStr(readerDocumentInitialRentCalculationSheet("fk_ReviewTypeID"))
                                                        processDocumentInitialRentCalculationSheetErrorID = CStr(readerDocumentInitialRentCalculationSheet("fk_ProcessTypeID"))
                                                                    %>
                                                                <div class="col-md-2"> 
                                            <h6>Notice</h6>
                                                <br />
                                                <div class="form-group">
                                                    <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentInitialRentCalculationSheet) %>" type="text" />
                                                </div>
                                            </div>
                                                            <div class="col-md-4"> 
                                            <h6>Comments</h6>
                                        <br />
                                            <div class="form-group">
                                            <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentInitialRentCalculationSheet)%></textarea>
                                        </div>
                                            </div>
                                                            <div class="col-md-2"> 
                                            <h6>Staff</h6>
                                            <br />
                                            <div class="form-group">
                                            <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentInitialRentCalculationSheet) %>" type="text" />
                                        </div>
                                            </div>
                                                            <div class="col-md-2"> 
                                            <h6>Status</h6>
                                                <br />
                                            <div class="form-group">
                                            <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentInitialRentCalculationSheet) %>"  type="text" />
                                            </div>
                                            </div>
                                                            <div class="text-center">
                                                <br /><br />
                                                <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentInitialRentCalculationSheetID) %>&ReviewTypeID=<% Response.Write(errorDocumentInitialRentCalculationSheetReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentInitialRentCalculationSheetErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                            </div>
                                                            <div class="clearfix"></div>
                                                                <br />
                                                            <%
                                                            End While
                                                                Next
                                                        conn.Close()
                                        %>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                                <asp:DropDownList ID="NoticeTypeInitialRentCalculationSheet" runat="server" 
                                                class="form-control border-input" DataSourceID="SqlNoticeTypeInitialRentCalculationSheet" 
                                                DataTextField="Notice" DataValueField="NoticeTypeID">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="SqlNoticeTypeInitialRentCalculationSheet" runat="server" 
                                                ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                            </asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <textarea class="form-control border-input" cols="4" name="commentInitialRentCalculationSheet" placeholder="Comment"
                                                rows="1"></textarea>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                                <asp:DropDownList ID="CaseManagerInitialRentCalculationSheet" runat="server" class="form-control border-input"
                                                        DataSourceID="SqlCaseManagerInitialRentCalculationSheet" DataValueField="UserID" DataTextField="FullName" required="required"></asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerInitialRentCalculationSheet" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                        SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <asp:DropDownList ID="StatusInitialRentCalculationSheet" class="form-control border-input" runat="server">
                                                    <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                    <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                    <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                    </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="text-center">
                                            <asp:Button ID="btnCreateProcessInitialRentCalculationSheet" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                    </div>
                                            <div class="clearfix">
                                            </div>
                                            <hr />
                                        </div>
                                                <div id="initial-ua-calculation-worksheet-elite">
                                                 <h6> Initial UA Calculation Worksheet - Elite
                                                     &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("44") Then
                                                                 Response.Write("<input type='checkbox' name='documentInitialUaCalculationWorksheetElite' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentInitialUaCalculationWorksheetElite' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentInitialUaCalculationWorksheetElite' />")
                                                        End If
                                                     %>
                                                 </h6>
                                            <br />
                                                <%
                                                conn.Open()
                                                Dim errorDocumentInitialUaCalculationWorksheetEliteErrorID As Integer
                                                Dim errorDocumentInitialUaCalculationWorksheetEliteID As Integer
                                                Dim detailsDocumentInitialUaCalculationWorksheetElite As String
                                                Dim noticeTypeDocumentInitialUaCalculationWorksheetElite As String
                                                Dim statusDocumentInitialUaCalculationWorksheetElite As String
                                                Dim errorStaffNameDocumentInitialUaCalculationWorksheetElite As String
                                                Dim errorDocumentInitialUaCalculationWorksheetEliteReviewTypeID As Integer
                                                    Dim errorsInitialUaCalculationWorksheetEliteList As New ArrayList
                                                    Dim processDocumentInitialUaCalculationWorksheetEliteErrorID As Integer
                                                        
                                                                        Dim queryDocumentInitialUaCalculationWorksheetEliteError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '44' AND fk_FileID = '" & fileID & "'", conn)
                                                Dim readerDocumentInitialUaCalculationWorksheetEliteError As SqlDataReader = queryDocumentInitialUaCalculationWorksheetEliteError.ExecuteReader()
                                                If readerDocumentInitialUaCalculationWorksheetEliteError.HasRows Then
                                                    While readerDocumentInitialUaCalculationWorksheetEliteError.Read
                                                        errorDocumentInitialUaCalculationWorksheetEliteErrorID = CStr(readerDocumentInitialUaCalculationWorksheetEliteError("fk_ErrorID"))
                                                        errorsInitialUaCalculationWorksheetEliteList.Add(errorDocumentInitialUaCalculationWorksheetEliteErrorID)
                                                    End While
                                                End If
                                                conn.Close()
                                           
                                                conn.Open()
                                                Dim errorInitialUaCalculationWorksheetEliteIndex As Integer
                                                For Each errorInitialUaCalculationWorksheetEliteIndex In errorsInitialUaCalculationWorksheetEliteList
                                                        Dim queryDocumentInitialUaCalculationWorksheetElite As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorInitialUaCalculationWorksheetEliteIndex & "'", conn)
                                                    Dim readerDocumentInitialUaCalculationWorksheetElite As SqlDataReader = queryDocumentInitialUaCalculationWorksheetElite.ExecuteReader()
                                                    While readerDocumentInitialUaCalculationWorksheetElite.Read
                                                        errorDocumentInitialUaCalculationWorksheetEliteID = CStr(readerDocumentInitialUaCalculationWorksheetElite("ErrorID"))
                                                        detailsDocumentInitialUaCalculationWorksheetElite = CStr(readerDocumentInitialUaCalculationWorksheetElite("Details"))
                                                        noticeTypeDocumentInitialUaCalculationWorksheetElite = CStr(readerDocumentInitialUaCalculationWorksheetElite("Notice"))
                                                        statusDocumentInitialUaCalculationWorksheetElite = CStr(readerDocumentInitialUaCalculationWorksheetElite("Status"))
                                                        errorStaffNameDocumentInitialUaCalculationWorksheetElite = CStr(readerDocumentInitialUaCalculationWorksheetElite("ErrorStaffName"))
                                                        errorDocumentInitialUaCalculationWorksheetEliteReviewTypeID = CStr(readerDocumentInitialUaCalculationWorksheetElite("fk_ReviewTypeID"))
                                                        processDocumentInitialUaCalculationWorksheetEliteErrorID = CStr(readerDocumentInitialUaCalculationWorksheetElite("fk_ProcessTypeID"))
                                                            %>
                                                                <div class="col-md-2"> 
                                            <h6>Notice</h6>
                                                <br />
                                                <div class="form-group">
                                                    <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentInitialUaCalculationWorksheetElite) %>" type="text" />
                                                </div>
                                            </div>
                                                            <div class="col-md-4"> 
                                            <h6>Comments</h6>
                                        <br />
                                            <div class="form-group">
                                            <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentInitialUaCalculationWorksheetElite)%></textarea>
                                        </div>
                                            </div>
                                                            <div class="col-md-2"> 
                                            <h6>Staff</h6>
                                            <br />
                                            <div class="form-group">
                                            <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentInitialUaCalculationWorksheetElite) %>" type="text" />
                                        </div>
                                            </div>
                                                            <div class="col-md-2"> 
                                            <h6>Status</h6>
                                                <br />
                                            <div class="form-group">
                                            <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentInitialUaCalculationWorksheetElite) %>"  type="text" />
                                            </div>
                                            </div>
                                                            <div class="text-center">
                                                <br /><br />
                                                <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentInitialUaCalculationWorksheetEliteID) %>&ReviewTypeID=<% Response.Write(errorDocumentInitialUaCalculationWorksheetEliteReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentInitialUaCalculationWorksheetEliteErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                            </div>
                                                            <div class="clearfix"></div>
                                                                <br />
                                                            <%
                                                            End While
                                                                Next
                                                        conn.Close()
                                        %>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                                <asp:DropDownList ID="NoticeTypeInitialUaCalculationWorksheetElite" runat="server" 
                                                class="form-control border-input" DataSourceID="SqlNoticeTypeInitialUaCalculationWorksheetElite" 
                                                DataTextField="Notice" DataValueField="NoticeTypeID">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="SqlNoticeTypeInitialUaCalculationWorksheetElite" runat="server" 
                                                ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                            </asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <textarea class="form-control border-input" cols="4" name="commentInitialUaCalculationWorksheetElite" placeholder="Comment"
                                                rows="1"></textarea>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                                <asp:DropDownList ID="CaseManagerInitialUaCalculationWorksheetElite" runat="server" class="form-control border-input"
                                                        DataSourceID="SqlCaseManagerInitialUaCalculationWorksheetElite" DataValueField="UserID" DataTextField="FullName" required="required"></asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerInitialUaCalculationWorksheetElite" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                        SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <asp:DropDownList ID="StatusInitialUaCalculationWorksheetElite" class="form-control border-input" runat="server">
                                                    <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                    <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                    <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                    </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="text-center">
                                            <asp:Button ID="btnCreateInitialUaCalculationWorksheetElite" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                    </div>
                                            <div class="clearfix">
                                            </div>
                                            <hr />
                                        </div>
                                                <div id="hap-contract-initial-unit">
                                                <h6> HAP Contract (initial unit)
                                                    &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("45") Then
                                                                 Response.Write("<input type='checkbox' name='documentHapContractInitialUnit' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentHapContractInitialUnit' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentHapContractInitialUnit' />")
                                                        End If
                                                     %>
                                                </h6>
                                            <br />
                                            <%
                                                conn.Open()
                                                Dim errorDocumentHapContractInitialUnitErrorID As Integer
                                                Dim errorDocumentHapContractInitialUnitID As Integer
                                                Dim detailsDocumentHapContractInitialUnit As String
                                                Dim noticeTypeDocumentHapContractInitialUnit As String
                                                Dim statusDocumentHapContractInitialUnit As String
                                                Dim errorStaffNameDocumentHapContractInitialUnit As String
                                                Dim errorDocumentHapContractInitialUnitReviewTypeID As Integer
                                                Dim errorsHapContractInitialUnitList As New ArrayList
                                                Dim processDocumentHapContractInitialUnitErrorID As Integer
                                                        
                                                                        Dim queryDocumentHapContractInitialUnitError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '45' AND fk_FileID = '" & fileID & "'", conn)
                                                Dim readerDocumentHapContractInitialUnitError As SqlDataReader = queryDocumentHapContractInitialUnitError.ExecuteReader()
                                                If readerDocumentHapContractInitialUnitError.HasRows Then
                                                    While readerDocumentHapContractInitialUnitError.Read
                                                        errorDocumentHapContractInitialUnitErrorID = CStr(readerDocumentHapContractInitialUnitError("fk_ErrorID"))
                                                        errorsHapContractInitialUnitList.Add(errorDocumentHapContractInitialUnitErrorID)
                                                    End While
                                                End If
                                                conn.Close()
                                           
                                                conn.Open()
                                                Dim errorHapContractInitialUnitIndex As Integer
                                                For Each errorHapContractInitialUnitIndex In errorsHapContractInitialUnitList
                                                    Dim queryDocumentHapContractInitialUnit As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorHapContractInitialUnitIndex & "'", conn)
                                                    Dim readerDocumentHapContractInitialUnit As SqlDataReader = queryDocumentHapContractInitialUnit.ExecuteReader()
                                                    While readerDocumentHapContractInitialUnit.Read
                                                        errorDocumentHapContractInitialUnitID = CStr(readerDocumentHapContractInitialUnit("ErrorID"))
                                                        detailsDocumentHapContractInitialUnit = CStr(readerDocumentHapContractInitialUnit("Details"))
                                                        noticeTypeDocumentHapContractInitialUnit = CStr(readerDocumentHapContractInitialUnit("Notice"))
                                                        statusDocumentHapContractInitialUnit = CStr(readerDocumentHapContractInitialUnit("Status"))
                                                        errorStaffNameDocumentHapContractInitialUnit = CStr(readerDocumentHapContractInitialUnit("ErrorStaffName"))
                                                        errorDocumentHapContractInitialUnitReviewTypeID = CStr(readerDocumentHapContractInitialUnit("fk_ReviewTypeID"))
                                                        processDocumentHapContractInitialUnitErrorID = CStr(readerDocumentHapContractInitialUnit("fk_ProcessTypeID"))
                                                        %>
                                                                <div class="col-md-2"> 
                                            <h6>Notice</h6>
                                                <br />
                                                <div class="form-group">
                                                    <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentHapContractInitialUnit) %>" type="text" />
                                                </div>
                                            </div>
                                                            <div class="col-md-4"> 
                                            <h6>Comments</h6>
                                        <br />
                                            <div class="form-group">
                                            <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentHapContractInitialUnit)%></textarea>
                                        </div>
                                            </div>
                                                            <div class="col-md-2"> 
                                            <h6>Staff</h6>
                                            <br />
                                            <div class="form-group">
                                            <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentHapContractInitialUnit) %>" type="text" />
                                        </div>
                                            </div>
                                                            <div class="col-md-2"> 
                                            <h6>Status</h6>
                                                <br />
                                            <div class="form-group">
                                            <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentHapContractInitialUnit) %>"  type="text" />
                                            </div>
                                            </div>
                                                            <div class="text-center">
                                                <br /><br />
                                                <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentHapContractInitialUnitID) %>&ReviewTypeID=<% Response.Write(errorDocumentHapContractInitialUnitReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentHapContractInitialUnitErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                            </div>
                                                            <div class="clearfix"></div>
                                                                <br />
                                                            <%
                                                            End While
                                                                Next
                                                        conn.Close()
                                        %>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                                <asp:DropDownList ID="NoticeTypeHapContractInitialUnit" runat="server" 
                                                class="form-control border-input" DataSourceID="SqlNoticeTypeHapContractInitialUnit" 
                                                DataTextField="Notice" DataValueField="NoticeTypeID">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="SqlNoticeTypeHapContractInitialUnit" runat="server" 
                                                ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                            </asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <textarea class="form-control border-input" cols="4" name="commentHapContractInitialUnit" placeholder="Comment"
                                                rows="1"></textarea>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                                <asp:DropDownList ID="CaseManagerHapContractInitialUnit" runat="server" class="form-control border-input"
                                                        DataSourceID="SqlCaseManagerHapContractInitialUnit" DataValueField="UserID" DataTextField="FullName" required="required"></asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerHapContractInitialUnit" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                        SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <asp:DropDownList ID="StatusHapContractInitialUnit" class="form-control border-input" runat="server">
                                                    <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                    <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                    <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                    </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="text-center">
                                            <asp:Button ID="btnCreateProcessHapContractInitialUnit" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                    </div>
                                            <div class="clearfix">
                                            </div>
                                            <hr />
                                        </div>
                                                <div id="hud-tenancy-addendum-initial-unit">
                                                <h6>HUD Tenancy Addendum (initial unit)
                                                    &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("46") Then
                                                                 Response.Write("<input type='checkbox' name='documentHudTenancyAddendumInitialUnit' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentHudTenancyAddendumInitialUnit' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentHudTenancyAddendumInitialUnit' />")
                                                        End If
                                                     %>
                                                </h6>
                                            <br />
                                            <%
                                                conn.Open()
                                                Dim errorDocumentHudTenancyAddendumInitialUnitErrorID As Integer
                                                Dim errorDocumentHudTenancyAddendumInitialUnitID As Integer
                                                Dim detailsDocumentHudTenancyAddendumInitialUnit As String
                                                Dim noticeTypeDocumentHudTenancyAddendumInitialUnit As String
                                                Dim statusDocumentHudTenancyAddendumInitialUnit As String
                                                Dim errorStaffNameDocumentHudTenancyAddendumInitialUnit As String
                                                Dim errorDocumentHudTenancyAddendumInitialUnitReviewTypeID As Integer
                                                Dim errorsHudTenancyAddendumInitialUnitList As New ArrayList
                                                Dim processDocumentHudTenancyAddendumInitialUnitErrorID As Integer
                                                        
                                                                        Dim queryDocumentHudTenancyAddendumInitialUnitError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '46' AND fk_FileID = '" & fileID & "'", conn)
                                                Dim readerDocumentHudTenancyAddendumInitialUnitError As SqlDataReader = queryDocumentHudTenancyAddendumInitialUnitError.ExecuteReader()
                                                If readerDocumentHudTenancyAddendumInitialUnitError.HasRows Then
                                                    While readerDocumentHudTenancyAddendumInitialUnitError.Read
                                                        errorDocumentHudTenancyAddendumInitialUnitErrorID = CStr(readerDocumentHudTenancyAddendumInitialUnitError("fk_ErrorID"))
                                                        errorsHudTenancyAddendumInitialUnitList.Add(errorDocumentHudTenancyAddendumInitialUnitErrorID)
                                                    End While
                                                End If
                                                conn.Close()
                                           
                                                conn.Open()
                                                Dim errorHudTenancyAddendumInitialUnitIndex As Integer
                                                For Each errorHudTenancyAddendumInitialUnitIndex In errorsHudTenancyAddendumInitialUnitList
                                                    Dim queryDocumentHudTenancyAddendumInitialUnit As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorHudTenancyAddendumInitialUnitIndex & "'", conn)
                                                    Dim readerDocumentHudTenancyAddendumInitialUnit As SqlDataReader = queryDocumentHudTenancyAddendumInitialUnit.ExecuteReader()
                                                    While readerDocumentHudTenancyAddendumInitialUnit.Read
                                                        errorDocumentHudTenancyAddendumInitialUnitID = CStr(readerDocumentHudTenancyAddendumInitialUnit("ErrorID"))
                                                        detailsDocumentHudTenancyAddendumInitialUnit = CStr(readerDocumentHudTenancyAddendumInitialUnit("Details"))
                                                        noticeTypeDocumentHudTenancyAddendumInitialUnit = CStr(readerDocumentHudTenancyAddendumInitialUnit("Notice"))
                                                        statusDocumentHudTenancyAddendumInitialUnit = CStr(readerDocumentHudTenancyAddendumInitialUnit("Status"))
                                                        errorStaffNameDocumentHudTenancyAddendumInitialUnit = CStr(readerDocumentHudTenancyAddendumInitialUnit("ErrorStaffName"))
                                                        errorDocumentHudTenancyAddendumInitialUnitReviewTypeID = CStr(readerDocumentHudTenancyAddendumInitialUnit("fk_ReviewTypeID"))
                                                            processDocumentHudTenancyAddendumInitialUnitErrorID = CStr(readerDocumentHudTenancyAddendumInitialUnit("fk_ProcessTypeID"))
                                                        %>
                                                                <div class="col-md-2"> 
                                            <h6>Notice</h6>
                                                <br />
                                                <div class="form-group">
                                                    <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentHudTenancyAddendumInitialUnit) %>" type="text" />
                                                </div>
                                            </div>
                                                            <div class="col-md-4"> 
                                            <h6>Comments</h6>
                                        <br />
                                            <div class="form-group">
                                            <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentHudTenancyAddendumInitialUnit)%></textarea>
                                        </div>
                                            </div>
                                                            <div class="col-md-2"> 
                                            <h6>Staff</h6>
                                            <br />
                                            <div class="form-group">
                                            <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentHudTenancyAddendumInitialUnit) %>" type="text" />
                                        </div>
                                            </div>
                                                            <div class="col-md-2"> 
                                            <h6>Status</h6>
                                                <br />
                                            <div class="form-group">
                                            <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentHudTenancyAddendumInitialUnit) %>"  type="text" />
                                            </div>
                                            </div>
                                                            <div class="text-center">
                                                <br /><br />
                                                <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentHudTenancyAddendumInitialUnitID) %>&ReviewTypeID=<% Response.Write(errorDocumentHudTenancyAddendumInitialUnitReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentHudTenancyAddendumInitialUnitErrorID) %>" class="btn btn-warning btn-fill btn-wd">NEED TO FIX</a>
                                            </div>
                                                            <div class="clearfix"></div>
                                                                <br />
                                                            <%
                                                            End While
                                                                Next
                                                        conn.Close()
                                        %>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                                <asp:DropDownList ID="NoticeTypeHudTenancyAddendumInitialUnit" runat="server" 
                                                class="form-control border-input" DataSourceID="SqlNoticeTypeHudTenancyAddendumInitialUnit" 
                                                DataTextField="Notice" DataValueField="NoticeTypeID">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="SqlNoticeTypeHudTenancyAddendumInitialUnit" runat="server" 
                                                ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                            </asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <textarea class="form-control border-input" cols="4" name="commentHudTenancyAddendumInitialUnit" placeholder="Comment"
                                                rows="1"></textarea>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                                <asp:DropDownList ID="CaseManagerHudTenancyAddendumInitialUnit" runat="server" class="form-control border-input"
                                                        DataSourceID="SqlCaseManagerHudTenancyAddendumInitialUnit" DataValueField="UserID" DataTextField="FullName" required="required"></asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerHudTenancyAddendumInitialUnit" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                        SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <asp:DropDownList ID="StatusHudTenancyAddendumInitialUnit" class="form-control border-input" runat="server">
                                                    <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                    <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                    <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                    </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="text-center">
                                            <asp:Button ID="btnCreateHudTenancyAddendumInitialUnit" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                    </div>
                                            <div class="clearfix">
                                            </div>
                                            <hr />
                                        </div>
                                                <div id="lease-initial-unit">
                                                <h6>Lease (initial unit)
                                                    &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("47") Then
                                                                 Response.Write("<input type='checkbox' name='documentLeaseInitialUnit' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentLeaseInitialUnit' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentLeaseInitialUnit' />")
                                                        End If
                                                     %>
                                                </h6>
                                            <br />
                                            <%
                                                conn.Open()
                                                Dim errorDocumentLeaseInitialUnitErrorID As Integer
                                                Dim errorDocumentLeaseInitialUnitID As Integer
                                                Dim detailsDocumentLeaseInitialUnit As String
                                                Dim noticeTypeDocumentLeaseInitialUnit As String
                                                Dim statusDocumentLeaseInitialUnit As String
                                                Dim errorStaffNameDocumentLeaseInitialUnit As String
                                                Dim errorDocumentLeaseInitialUnitReviewTypeID As Integer
                                                Dim errorsLeaseInitialUnitList As New ArrayList
                                                Dim processDocumentLeaseInitialUnitErrorID As Integer
                                                        
                                                                        Dim queryDocumentLeaseInitialUnitError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '47' AND fk_FileID = '" & fileID & "'", conn)
                                                Dim readerDocumentLeaseInitialUnitError As SqlDataReader = queryDocumentLeaseInitialUnitError.ExecuteReader()
                                                If readerDocumentLeaseInitialUnitError.HasRows Then
                                                    While readerDocumentLeaseInitialUnitError.Read
                                                        errorDocumentLeaseInitialUnitErrorID = CStr(readerDocumentLeaseInitialUnitError("fk_ErrorID"))
                                                        errorsLeaseInitialUnitList.Add(errorDocumentLeaseInitialUnitErrorID)
                                                    End While
                                                End If
                                                conn.Close()
                                           
                                                conn.Open()
                                                Dim errorLeaseInitialUnitIndex As Integer
                                                For Each errorLeaseInitialUnitIndex In errorsLeaseInitialUnitList
                                                    Dim queryDocumentLeaseInitialUnit As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorLeaseInitialUnitIndex & "'", conn)
                                                    Dim readerDocumentLeaseInitialUnit As SqlDataReader = queryDocumentLeaseInitialUnit.ExecuteReader()
                                                    While readerDocumentLeaseInitialUnit.Read
                                                        errorDocumentLeaseInitialUnitID = CStr(readerDocumentLeaseInitialUnit("ErrorID"))
                                                        detailsDocumentLeaseInitialUnit = CStr(readerDocumentLeaseInitialUnit("Details"))
                                                        noticeTypeDocumentLeaseInitialUnit = CStr(readerDocumentLeaseInitialUnit("Notice"))
                                                        statusDocumentLeaseInitialUnit = CStr(readerDocumentLeaseInitialUnit("Status"))
                                                        errorStaffNameDocumentLeaseInitialUnit = CStr(readerDocumentLeaseInitialUnit("ErrorStaffName"))
                                                        errorDocumentLeaseInitialUnitReviewTypeID = CStr(readerDocumentLeaseInitialUnit("fk_ReviewTypeID"))
                                                        processDocumentLeaseInitialUnitErrorID = CStr(readerDocumentLeaseInitialUnit("fk_ProcessTypeID")) 
                                                        %>
                                                                <div class="col-md-2"> 
                                            <h6>Notice</h6>
                                                <br />
                                                <div class="form-group">
                                                    <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentLeaseInitialUnit) %>" type="text" />
                                                </div>
                                            </div>
                                                            <div class="col-md-4"> 
                                            <h6>Comments</h6>
                                        <br />
                                            <div class="form-group">
                                            <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentLeaseInitialUnit)%></textarea>
                                        </div>
                                            </div>
                                                            <div class="col-md-2"> 
                                            <h6>Staff</h6>
                                            <br />
                                            <div class="form-group">
                                            <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentLeaseInitialUnit) %>" type="text" />
                                        </div>
                                            </div>
                                                            <div class="col-md-2"> 
                                            <h6>Status</h6>
                                                <br />
                                            <div class="form-group">
                                            <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentLeaseInitialUnit) %>"  type="text" />
                                            </div>
                                            </div>
                                                            <div class="text-center">
                                                <br /><br />
                                                <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentLeaseInitialUnitID) %>&ReviewTypeID=<% Response.Write(errorDocumentLeaseInitialUnitReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentLeaseInitialUnitErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                            </div>
                                                            <div class="clearfix"></div>
                                                                <br />
                                                            <%
                                                            End While
                                                                Next
                                                        conn.Close()
                                        %>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                                <asp:DropDownList ID="NoticeTypeLeaseInitialUnit" runat="server" 
                                                class="form-control border-input" DataSourceID="SqlNoticeTypeLeaseInitialUnit" 
                                                DataTextField="Notice" DataValueField="NoticeTypeID">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="SqlNoticeTypeLeaseInitialUnit" runat="server" 
                                                ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                            </asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <textarea class="form-control border-input" cols="4" name="commentLeaseInitialUnit" placeholder="Comment"
                                                rows="1"></textarea>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                                <asp:DropDownList ID="CaseManagerLeaseInitialUnit" runat="server" class="form-control border-input"
                                                        DataSourceID="SqlCaseManagerLeaseInitialUnit" DataValueField="UserID" DataTextField="FullName" required="required"></asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerLeaseInitialUnit" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                        SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <asp:DropDownList ID="StatusLeaseInitialUnit" class="form-control border-input" runat="server">
                                                    <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                    <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                    <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                    </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="text-center">
                                            <asp:Button ID="btnCreateLeaseInitialUnit" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                    </div>
                                            <div class="clearfix">
                                            </div>
                                            <hr />
                                        </div>
                                                <div id="rfta-initial-unit">
                                                <h6> RFTA (initial unit)
                                                    &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("48") Then
                                                                 Response.Write("<input type='checkbox' name='documentRftaInitialUnit' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentRftaInitialUnit' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentRftaInitialUnit' />")
                                                        End If
                                                     %>
                                                </h6>
                                            <br />
                                                <%
                                                conn.Open()
                                                Dim errorDocumentRftaInitialUnitErrorID As Integer
                                                Dim errorDocumentRftaInitialUnitID As Integer
                                                Dim detailsDocumentRftaInitialUnit As String
                                                Dim noticeTypeDocumentRftaInitialUnit As String
                                                Dim statusDocumentRftaInitialUnit As String
                                                Dim errorStaffNameDocumentRftaInitialUnit As String
                                                Dim errorDocumentRftaInitialUnitReviewTypeID As Integer
                                                    Dim errorsRftaInitialUnitList As New ArrayList
                                                    Dim processDocumentRftaInitialUnitErrorID As Integer
                                                        
                                                    Dim queryDocumentRftaInitialUnitError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '48' AND fk_FileID = '" & fileID & "'", conn)
                                                Dim readerDocumentRftaInitialUnitError As SqlDataReader = queryDocumentRftaInitialUnitError.ExecuteReader()
                                                If readerDocumentRftaInitialUnitError.HasRows Then
                                                    While readerDocumentRftaInitialUnitError.Read
                                                        errorDocumentRftaInitialUnitErrorID = CStr(readerDocumentRftaInitialUnitError("fk_ErrorID"))
                                                        errorsRftaInitialUnitList.Add(errorDocumentRftaInitialUnitErrorID)
                                                    End While
                                                End If
                                                conn.Close()
                                           
                                                conn.Open()
                                                Dim errorRftaInitialUnitIndex As Integer
                                                For Each errorRftaInitialUnitIndex In errorsRftaInitialUnitList
                                                        Dim queryDocumentRftaInitialUnit As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorRftaInitialUnitIndex & "'", conn)
                                                    Dim readerDocumentRftaInitialUnit As SqlDataReader = queryDocumentRftaInitialUnit.ExecuteReader()
                                                    While readerDocumentRftaInitialUnit.Read
                                                        errorDocumentRftaInitialUnitID = CStr(readerDocumentRftaInitialUnit("ErrorID"))
                                                        detailsDocumentRftaInitialUnit = CStr(readerDocumentRftaInitialUnit("Details"))
                                                        noticeTypeDocumentRftaInitialUnit = CStr(readerDocumentRftaInitialUnit("Notice"))
                                                        statusDocumentRftaInitialUnit = CStr(readerDocumentRftaInitialUnit("Status"))
                                                        errorStaffNameDocumentRftaInitialUnit = CStr(readerDocumentRftaInitialUnit("ErrorStaffName"))
                                                        errorDocumentRftaInitialUnitReviewTypeID = CStr(readerDocumentRftaInitialUnit("fk_ReviewTypeID"))
                                                            processDocumentRftaInitialUnitErrorID = CStr(readerDocumentRftaInitialUnit("fk_ProcessTypeID"))
                                                            %>
                                                                <div class="col-md-2"> 
                                            <h6>Notice</h6>
                                                <br />
                                                <div class="form-group">
                                                    <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentRftaInitialUnit) %>" type="text" />
                                                </div>
                                            </div>
                                                            <div class="col-md-4"> 
                                            <h6>Comments</h6>
                                        <br />
                                            <div class="form-group">
                                            <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentRftaInitialUnit)%></textarea>
                                        </div>
                                            </div>
                                                            <div class="col-md-2"> 
                                            <h6>Staff</h6>
                                            <br />
                                            <div class="form-group">
                                            <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentRftaInitialUnit) %>" type="text" />
                                        </div>
                                            </div>
                                                            <div class="col-md-2"> 
                                            <h6>Status</h6>
                                                <br />
                                            <div class="form-group">
                                            <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentRftaInitialUnit) %>"  type="text" />
                                            </div>
                                            </div>
                                                            <div class="text-center">
                                                <br /><br />
                                                <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentRftaInitialUnitID) %>&ReviewTypeID=<% Response.Write(errorDocumentRftaInitialUnitReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentRftaInitialUnitErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                            </div>
                                                            <div class="clearfix"></div>
                                                                <br />
                                                            <%
                                                            End While
                                                                Next
                                                        conn.Close()
                                        %>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                                <asp:DropDownList ID="NoticeTypeRftaInitialUnit" runat="server" 
                                                class="form-control border-input" DataSourceID="SqlNoticeTypeRftaInitialUnit" 
                                                DataTextField="Notice" DataValueField="NoticeTypeID">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="SqlNoticeTypeRftaInitialUnit" runat="server" 
                                                ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                            </asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <textarea class="form-control border-input" cols="4" name="commentRftaInitialUnit" placeholder="Comment"
                                                rows="1"></textarea>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                                <asp:DropDownList ID="CaseManagerRftaInitialUnit" runat="server" class="form-control border-input"
                                                        DataSourceID="SqlCaseManagerRftaInitialUnit" DataValueField="UserID" DataTextField="FullName" required="required"></asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerRftaInitialUnit" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                        SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <asp:DropDownList ID="StatusRftaInitialUnit" class="form-control border-input" runat="server">
                                                    <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                    <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                    <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                    </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="text-center">
                                            <asp:Button ID="btnCreateRftaInitialUnit" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                    </div>
                                            <div class="clearfix">
                                            </div>
                                            <hr />
                                        </div>
                                                <div id="utility-allowance-checklist-initial-unit">
                                                <h6>Utility Allowance Checklist (initial unit)
                                                    &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("49") Then
                                                                 Response.Write("<input type='checkbox' name='documentUtilityAllowanceChecklistInitialUnit' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentUtilityAllowanceChecklistInitialUnit' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentUtilityAllowanceChecklistInitialUnit' />")
                                                        End If
                                                     %>
                                                </h6>
                                            <br />
                                                <%
                                                conn.Open()
                                                Dim errorDocumentUtilityAllowanceChecklistInitialUnitErrorID As Integer
                                                Dim errorDocumentUtilityAllowanceChecklistInitialUnitID As Integer
                                                Dim detailsDocumentUtilityAllowanceChecklistInitialUnit As String
                                                Dim noticeTypeDocumentUtilityAllowanceChecklistInitialUnit As String
                                                Dim statusDocumentUtilityAllowanceChecklistInitialUnit As String
                                                Dim errorStaffNameDocumentUtilityAllowanceChecklistInitialUnit As String
                                                Dim errorDocumentUtilityAllowanceChecklistInitialUnitReviewTypeID As Integer
                                                    Dim errorsUtilityAllowanceChecklistInitialUnitList As New ArrayList
                                                    Dim processDocumentUtilityAllowanceChecklistInitialUnitErrorID As Integer
                                                        
                                                    Dim queryDocumentUtilityAllowanceChecklistInitialUnitError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '49' AND fk_FileID = '" & fileID & "'", conn)
                                                Dim readerDocumentUtilityAllowanceChecklistInitialUnitError As SqlDataReader = queryDocumentUtilityAllowanceChecklistInitialUnitError.ExecuteReader()
                                                If readerDocumentUtilityAllowanceChecklistInitialUnitError.HasRows Then
                                                    While readerDocumentUtilityAllowanceChecklistInitialUnitError.Read
                                                        errorDocumentUtilityAllowanceChecklistInitialUnitErrorID = CStr(readerDocumentUtilityAllowanceChecklistInitialUnitError("fk_ErrorID"))
                                                        errorsUtilityAllowanceChecklistInitialUnitList.Add(errorDocumentUtilityAllowanceChecklistInitialUnitErrorID)
                                                    End While
                                                End If
                                                conn.Close()
                                           
                                                conn.Open()
                                                Dim errorUtilityAllowanceChecklistInitialUnitIndex As Integer
                                                For Each errorUtilityAllowanceChecklistInitialUnitIndex In errorsUtilityAllowanceChecklistInitialUnitList
                                                        Dim queryDocumentUtilityAllowanceChecklistInitialUnit As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorUtilityAllowanceChecklistInitialUnitIndex & "'", conn)
                                                    Dim readerDocumentUtilityAllowanceChecklistInitialUnit As SqlDataReader = queryDocumentUtilityAllowanceChecklistInitialUnit.ExecuteReader()
                                                    While readerDocumentUtilityAllowanceChecklistInitialUnit.Read
                                                        errorDocumentUtilityAllowanceChecklistInitialUnitID = CStr(readerDocumentUtilityAllowanceChecklistInitialUnit("ErrorID"))
                                                        detailsDocumentUtilityAllowanceChecklistInitialUnit = CStr(readerDocumentUtilityAllowanceChecklistInitialUnit("Details"))
                                                        noticeTypeDocumentUtilityAllowanceChecklistInitialUnit = CStr(readerDocumentUtilityAllowanceChecklistInitialUnit("Notice"))
                                                        statusDocumentUtilityAllowanceChecklistInitialUnit = CStr(readerDocumentUtilityAllowanceChecklistInitialUnit("Status"))
                                                        errorStaffNameDocumentUtilityAllowanceChecklistInitialUnit = CStr(readerDocumentUtilityAllowanceChecklistInitialUnit("ErrorStaffName"))
                                                            errorDocumentUtilityAllowanceChecklistInitialUnitReviewTypeID = CStr(readerDocumentUtilityAllowanceChecklistInitialUnit("fk_ReviewTypeID"))
                                                            processDocumentUtilityAllowanceChecklistInitialUnitErrorID = CStr(readerDocumentUtilityAllowanceChecklistInitialUnit("fk_ProcessTypeID"))
                                                            %>
                                                                <div class="col-md-2"> 
                                            <h6>Notice</h6>
                                                <br />
                                                <div class="form-group">
                                                    <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentUtilityAllowanceChecklistInitialUnit) %>" type="text" />
                                                </div>
                                            </div>
                                                            <div class="col-md-4"> 
                                            <h6>Comments</h6>
                                        <br />
                                            <div class="form-group">
                                            <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentUtilityAllowanceChecklistInitialUnit)%></textarea>
                                        </div>
                                            </div>
                                                            <div class="col-md-2"> 
                                            <h6>Staff</h6>
                                            <br />
                                            <div class="form-group">
                                            <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentUtilityAllowanceChecklistInitialUnit) %>" type="text" />
                                        </div>
                                            </div>
                                                            <div class="col-md-2"> 
                                            <h6>Status</h6>
                                                <br />
                                            <div class="form-group">
                                            <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentUtilityAllowanceChecklistInitialUnit) %>"  type="text" />
                                            </div>
                                            </div>
                                                            <div class="text-center">
                                                <br /><br />
                                                <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentUtilityAllowanceChecklistInitialUnitID) %>&ReviewTypeID=<% Response.Write(errorDocumentUtilityAllowanceChecklistInitialUnitReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentUtilityAllowanceChecklistInitialUnitErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                            </div>
                                                            <div class="clearfix"></div>
                                                                <br />
                                                            <%
                                                            End While
                                                                Next
                                                        conn.Close()
                                        %>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                                <asp:DropDownList ID="NoticeTypeUtilityAllowanceChecklistInitialUnit" runat="server" 
                                                class="form-control border-input" DataSourceID="SqlNoticeTypeUtilityAllowanceChecklistInitialUnit" 
                                                DataTextField="Notice" DataValueField="NoticeTypeID">
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="SqlNoticeTypeUtilityAllowanceChecklistInitialUnit" runat="server" 
                                                ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                            </asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <textarea class="form-control border-input" cols="4" name="commentUtilityAllowanceChecklistInitialUnit" placeholder="Comment"
                                                rows="1"></textarea>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                                <asp:DropDownList ID="CaseManagerUtilityAllowanceChecklistInitialUnit" runat="server" class="form-control border-input"
                                                        DataSourceID="SqlCaseManagerUtilityAllowanceChecklistInitialUnit" DataValueField="UserID" DataTextField="FullName" required="required"></asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlCaseManagerUtilityAllowanceChecklistInitialUnit" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                        SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3'  OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                </asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="form-group">
                                            <asp:DropDownList ID="StatusUtilityAllowanceChecklistInitialUnit" class="form-control border-input" runat="server">
                                                    <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                    <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                    <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                    </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="text-center">
                                        <asp:Button ID="btnCreateUtilityAllowanceChecklistInitialUnit" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                    </div>
                                            <div class="clearfix">
                                            </div>
                                            <hr />
                                        </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel panel-info">
                                    <div class="panel-heading" role="tab" id="headingThree">
                                        <h4 class="panel-title">
                                            <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion"
                                                href="#collapseThree" aria-expanded="false" aria-controls="collapseThree"><i class="fa fa-sticky-note" aria-hidden="true"></i> Notes / Portability
                                                Billing / Compliance</a>
                                        </h4>
                                    </div>
                                    <div id="collapseThree" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingThree">
                                        <div class="panel-body">
                                            <hr />
                                            <div id="document-other">
                                                 <h6>Other
                                                     &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("6") Then
                                                                 Response.Write("<input type='checkbox' name='documentOther' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentOther' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentOther' />")
                                                        End If
                                                     %>
                                                 </h6>
                                                <br />
                                            <%
                                            conn.Open()
                                             Dim errorDocumentOtherErrorID As Integer
                                             Dim errorDocumentOtherID As Integer
                                             Dim detailsDocumentOther As String
                                             Dim noticeTypeDocumentOther As String
                                             Dim statusDocumentOther As String
                                             Dim errorStaffNameDocumentOther As String
                                             Dim errorDocumentOtherReviewTypeID As Integer
                                                Dim errorsOtherList As New ArrayList
                                                Dim processDocumentOtherErrorID As Integer
                                                        
                                             Dim queryDocumentOtherError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '6' AND fk_FileID = '" & fileID & "'", conn)
                                             Dim readerDocumentOtherError As SqlDataReader = queryDocumentOtherError.ExecuteReader()
                                             If readerDocumentOtherError.HasRows Then
                                                 While readerDocumentOtherError.Read
                                                     errorDocumentOtherErrorID = CStr(readerDocumentOtherError("fk_ErrorID"))
                                                     errorsOtherList.Add(errorDocumentOtherErrorID)
                                                 End While
                                             End If
                                             conn.Close()
                                           
                                             conn.Open()
                                             Dim errorOtherIndex As Integer
                                             For Each errorOtherIndex In errorsOtherList
                                                    Dim queryDocumentOther As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorOtherIndex & "'", conn)
                                                 Dim readerDocumentOther As SqlDataReader = queryDocumentOther.ExecuteReader()
                                                 While readerDocumentOther.Read
                                                     errorDocumentOtherID = CStr(readerDocumentOther("ErrorID"))
                                                     detailsDocumentOther = CStr(readerDocumentOther("Details"))
                                                     noticeTypeDocumentOther = CStr(readerDocumentOther("Notice"))
                                                     statusDocumentOther = CStr(readerDocumentOther("Status"))
                                                     errorStaffNameDocumentOther = CStr(readerDocumentOther("ErrorStaffName"))
                                                        errorDocumentOtherReviewTypeID = CStr(readerDocumentOther("fk_ReviewTypeID"))
                                                        processDocumentOtherErrorID = CStr(readerDocumentOther("fk_ProcessTypeID"))
                                                      %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentOther) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                             <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentOther)%></textarea>
                                            </div>
                                               </div>
                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentOther) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentOther) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentOtherID) %>&ReviewTypeID=<% Response.Write(errorDocumentOtherReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentOtherErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                 <div class="clearfix"></div>
                                                <br />
                                        <%
                                             End While
                                         Next
                                         conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                          <asp:DropDownList ID="NoticeTypeDocumentOther" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlDocumentOther" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlDocumentOther" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentDocumentOther" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerDocumentOther" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerDocumentOther" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerDocumentOther" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusDocumentOther" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateDocumentOther" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix"></div>
                                                <hr />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel panel-success">
                                    <div class="panel-heading" role="tab" id="headingFour">
                                        <h4 class="panel-title">
                                            <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion"
                                                href="#collapseFour" aria-expanded="false" aria-controls="collapseFour"><i class="fa fa-certificate" aria-hidden="true"></i> Recertification
                                                Documents</a>
                                        </h4>
                                    </div>
                                    <div id="collapseFour" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingFour">
                                        <div class="panel-body">
                                            <hr />
                                            <div id="hap-processing-action-form">
                                                <h6> HAP Processing Action Form 
                                                     &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("50") Then
                                                                 Response.Write("<input type='checkbox' name='documentHapProcessingActionForm' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentHapProcessingActionForm' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentHapProcessingActionForm' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                          <%
                                            conn.Open()
                                              Dim errorDocumentHapProcessingActionFormErrorID As Integer
                                             Dim errorDocumentHapProcessingActionFormID As Integer
                                             Dim detailsDocumentHapProcessingActionForm As String
                                             Dim noticeTypeDocumentHapProcessingActionForm As String
                                             Dim statusDocumentHapProcessingActionForm As String
                                             Dim errorStaffNameDocumentHapProcessingActionForm As String
                                             Dim errorDocumentHapProcessingActionFormReviewTypeID As Integer
                                              Dim errorsHapProcessingActionFormList As New ArrayList
                                              Dim processDocumentHapProcessingActionFormErrorID As Integer
                                                        
                                              Dim queryDocumentHapProcessingActionFormError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '50' AND fk_FileID = '" & fileID & "'", conn)
                                             Dim readerDocumentHapProcessingActionFormError As SqlDataReader = queryDocumentHapProcessingActionFormError.ExecuteReader()
                                             If readerDocumentHapProcessingActionFormError.HasRows Then
                                                 While readerDocumentHapProcessingActionFormError.Read
                                                     errorDocumentHapProcessingActionFormErrorID = CStr(readerDocumentHapProcessingActionFormError("fk_ErrorID"))
                                                     errorsHapProcessingActionFormList.Add(errorDocumentHapProcessingActionFormErrorID)
                                                 End While
                                             End If
                                             conn.Close()
                                           
                                             conn.Open()
                                             Dim errorHapProcessingActionFormIndex As Integer
                                             For Each errorHapProcessingActionFormIndex In errorsHapProcessingActionFormList
                                                  Dim queryDocumentHapProcessingActionForm As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorHapProcessingActionFormIndex & "'", conn)
                                                 Dim readerDocumentHapProcessingActionForm As SqlDataReader = queryDocumentHapProcessingActionForm.ExecuteReader()
                                                 While readerDocumentHapProcessingActionForm.Read
                                                     errorDocumentHapProcessingActionFormID = CStr(readerDocumentHapProcessingActionForm("ErrorID"))
                                                     detailsDocumentHapProcessingActionForm = CStr(readerDocumentHapProcessingActionForm("Details"))
                                                     noticeTypeDocumentHapProcessingActionForm = CStr(readerDocumentHapProcessingActionForm("Notice"))
                                                     statusDocumentHapProcessingActionForm = CStr(readerDocumentHapProcessingActionForm("Status"))
                                                     errorStaffNameDocumentHapProcessingActionForm = CStr(readerDocumentHapProcessingActionForm("ErrorStaffName"))
                                                     errorDocumentHapProcessingActionFormReviewTypeID = CStr(readerDocumentHapProcessingActionForm("fk_ReviewTypeID"))
                                                        processDocumentHapProcessingActionFormErrorID = CStr(readerDocumentHapProcessingActionForm("fk_ProcessTypeID"))
                                                      %>
                                               <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentHapProcessingActionForm) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                             <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentHapProcessingActionForm)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentHapProcessingActionForm) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentHapProcessingActionForm) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentHapProcessingActionFormID) %>&ReviewTypeID=<% Response.Write(errorDocumentHapProcessingActionFormReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentHapProcessingActionFormErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                                <div class="clearfix"></div>
                                                                 <br />
                                        <%
                                             End While
                                         Next
                                         conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                          <asp:DropDownList ID="NoticeTypeHapProcessingActionForm" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlHapProcessingActionForm" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlHapProcessingActionForm" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentHapProcessingActionForm" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerHapProcessingActionForm" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerHapProcessingActionForm" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerHapProcessingActionForm" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusHapProcessingActionForm" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateHapProcessingActionForm" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix"></div>
                                                <hr />
                                            </div>
                                            <div id="ua-calculation-worksheet-elite">
                                                <h6>  UA Calculation Worksheet - Elite
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("51") Then
                                                                Response.Write("<input type='checkbox' name='documentUaCalculationWorksheetElite' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentUaCalculationWorksheetElite' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentUaCalculationWorksheetElite' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                           <%
                                            conn.Open()
                                              Dim errorDocumentUaCalculationWorksheetEliteErrorID As Integer
                                             Dim errorDocumentUaCalculationWorksheetEliteID As Integer
                                             Dim detailsDocumentUaCalculationWorksheetElite As String
                                             Dim noticeTypeDocumentUaCalculationWorksheetElite As String
                                             Dim statusDocumentUaCalculationWorksheetElite As String
                                             Dim errorStaffNameDocumentUaCalculationWorksheetElite As String
                                             Dim errorDocumentUaCalculationWorksheetEliteReviewTypeID As Integer
                                               Dim errorsUaCalculationWorksheetEliteList As New ArrayList
                                               Dim processDocumentUaCalculationWorksheetEliteErrorID As Integer
                                                        
                                              Dim queryDocumentUaCalculationWorksheetEliteError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '51' AND fk_FileID = '" & fileID & "'", conn)
                                             Dim readerDocumentUaCalculationWorksheetEliteError As SqlDataReader = queryDocumentUaCalculationWorksheetEliteError.ExecuteReader()
                                             If readerDocumentUaCalculationWorksheetEliteError.HasRows Then
                                                 While readerDocumentUaCalculationWorksheetEliteError.Read
                                                     errorDocumentUaCalculationWorksheetEliteErrorID = CStr(readerDocumentUaCalculationWorksheetEliteError("fk_ErrorID"))
                                                     errorsUaCalculationWorksheetEliteList.Add(errorDocumentUaCalculationWorksheetEliteErrorID)
                                                 End While
                                             End If
                                             conn.Close()
                                           
                                             conn.Open()
                                             Dim errorUaCalculationWorksheetEliteIndex As Integer
                                             For Each errorUaCalculationWorksheetEliteIndex In errorsUaCalculationWorksheetEliteList
                                                   Dim queryDocumentUaCalculationWorksheetElite As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorUaCalculationWorksheetEliteIndex & "'", conn)
                                                 Dim readerDocumentUaCalculationWorksheetElite As SqlDataReader = queryDocumentUaCalculationWorksheetElite.ExecuteReader()
                                                 While readerDocumentUaCalculationWorksheetElite.Read
                                                     errorDocumentUaCalculationWorksheetEliteID = CStr(readerDocumentUaCalculationWorksheetElite("ErrorID"))
                                                     detailsDocumentUaCalculationWorksheetElite = CStr(readerDocumentUaCalculationWorksheetElite("Details"))
                                                     noticeTypeDocumentUaCalculationWorksheetElite = CStr(readerDocumentUaCalculationWorksheetElite("Notice"))
                                                     statusDocumentUaCalculationWorksheetElite = CStr(readerDocumentUaCalculationWorksheetElite("Status"))
                                                     errorStaffNameDocumentUaCalculationWorksheetElite = CStr(readerDocumentUaCalculationWorksheetElite("ErrorStaffName"))
                                                     errorDocumentUaCalculationWorksheetEliteReviewTypeID = CStr(readerDocumentUaCalculationWorksheetElite("fk_ReviewTypeID"))
                                                       processDocumentUaCalculationWorksheetEliteErrorID = CStr(readerDocumentUaCalculationWorksheetElite("fk_ProcessTypeID"))
                                                       %>
                                               <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentUaCalculationWorksheetElite) %>" type="text" />
                                                 </div>
                                               </div>
                                                   <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                             <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentUaCalculationWorksheetElite)%></textarea>
                                            </div>
                                               </div>
                                                 <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentUaCalculationWorksheetElite) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentUaCalculationWorksheetElite) %>"  type="text" />
                                                </div>
                                               </div>
                                                  <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentUaCalculationWorksheetEliteID) %>&ReviewTypeID=<% Response.Write(errorDocumentUaCalculationWorksheetEliteReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentUaCalculationWorksheetEliteErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                 <div class="clearfix"></div>
                                                                 <br />
                                        <%
                                             End While
                                         Next
                                         conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="NoticeTypeUaCalculationWorksheetElite" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlUaCalculationWorksheetElite" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlUaCalculationWorksheetElite" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2'">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentUaCalculationWorksheetElite" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerUaCalculationWorksheetElite" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerUaCalculationWorksheetElite" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerUaCalculationWorksheetElite" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusUaCalculationWorksheetElite" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateUaCalculationWorksheetElite" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $('#myTabs a').click(function (e) {
            e.preventDefault()
            $(this).tab('show')
        })
    </script>
</asp:Content>

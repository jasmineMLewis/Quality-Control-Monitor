<%@ Page Title="QC :: Interim" Language="vb" AutoEventWireup="false" MasterPageFile="~/FileDetails.master" CodeBehind="CreateInterimReexamination.aspx.vb" Inherits="QualityControlMonitor.CreateInterimReexamination" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="nestedContent" runat="server">
    <div class="row">
        <div class="col-lg-12 col-md-7">
            <div class="card">
                <div class="header">
                    <h4 class="title"><i class="fa fa-calendar-o" aria-hidden="true"></i> QC Review :: Interim Reexamination</h4>
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
                             <asp:Button ID="btnCompleteReview" runat="server" class="btn btn-info btn-fill btn-wd" Text="Complete Interim Reexamination Review" />
                          <%
                                Else
                          %>
                           <asp:Button ID="btnUpdateReview" runat="server" class="btn btn-warning btn-fill btn-wd" Text="Resubmit Interim Reexamination Review" />
                          <%
                          End If
                          connReview.Close()
                        %>
                    </div>
                    <div class="clearfix">  </div>
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
                                      <i class="fa fa-calendar-o" aria-hidden="true"></i>  Interim Reexamination
                                    </h4>
                                </div>
                                <div class="panel-body">
                                    <hr />
                                     <div id="verification">
                                        <h6>  Verification
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
                                                    If processes.Contains("1") Then
                                                        Response.Write("<input type='checkbox' name='processVerification' checked='checked' />")
                                                    Else
                                                        Response.Write("<input type='checkbox' name='processVerification' />")
                                                    End If
                                                Else
                                                    Response.Write("<input type='checkbox' name='processVerification' />")
                                                End If
                                            %>

                                        </h6>
                                        <br />
                                         <%
                                            conn.Open()
                                             Dim errorVerificationID As Integer
                                             Dim detailsVerification As String
                                             Dim noticeTypeVerification As String
                                             Dim statusVerification As String
                                             Dim errorStaffNameVerification As String
                                             Dim errorReviewTypeIDVerification As Integer
                                             Dim processVerificationID As Integer
                                            
                                             Dim queryVerification As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE fk_FileID = '" & fileID & "' AND fk_ProcessTypeID = 1 ORDER BY NoticeTypes.Notice", conn)
                                             Dim readerVerification As SqlDataReader = queryVerification.ExecuteReader()
                                             If readerVerification.HasRows Then
                                                 While readerVerification.Read
                                                     errorVerificationID = CStr(readerVerification("ErrorID"))
                                                     detailsVerification = CStr(readerVerification("Details"))
                                                     noticeTypeVerification = CStr(readerVerification("Notice"))
                                                     statusVerification = CStr(readerVerification("Status"))
                                                     errorStaffNameVerification = CStr(readerVerification("ErrorStaffName"))
                                                     errorReviewTypeIDVerification = CStr(readerVerification("fk_ReviewTypeID"))
                                                     processVerificationID = CStr(readerVerification("fk_ProcessTypeID"))
                                             %>
                                               <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeVerification) %>" type="text" />
                                                 </div>
                                               </div>
                                               <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                 <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsVerification)%></textarea>
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameVerification) %>" type="text" />
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusVerification) %>"  type="text" />
                                                </div>
                                               </div>
                                               <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorVerificationID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDVerification) %>&ProcessTypeID=<% Response.Write(processVerificationID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                <asp:DropDownList ID="NoticeTypeVerification" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeVerification" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeVerification" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '6' OR [NoticeTypeID] = '7' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '1' OR [NoticeTypeID] = '3' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <textarea class="form-control border-input" cols="4" name="commentVerification" placeholder="Comment"
                                                    rows="1"></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="CaseManagerVerification" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerVerification" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerVerification" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="StatusVerification" class="form-control border-input" runat="server">
                                                  <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                  <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                  <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                 </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="text-center">
                                             <asp:Button ID="btnCreateProcessVerification" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <hr />
                                    </div>
                                    <div id="calculation">
                                        <h6>Calculation
                                            &nbsp; &nbsp; &nbsp;
                                            <%
                                                If processes.Count > 0 Then
                                                    If processes.Contains("2") Then
                                                        Response.Write("<input type='checkbox' name='processCalculation' checked='checked' />")
                                                    Else
                                                        Response.Write("<input type='checkbox' name='processCalculation' />")
                                                    End If
                                                Else
                                                    Response.Write("<input type='checkbox' name='processCalculation' />")
                                                End If
                                             %>
                                        </h6>
                                        <br />
                                        <%
                                            conn.Open()
                                            Dim errorCalculationID As Integer
                                            Dim detailsCalculation As String
                                            Dim noticeTypeCalculation As String
                                            Dim statusCalculation As String
                                            Dim errorStaffNameCalculation As String
                                            Dim errorReviewTypeIDCalculation As Integer
                                            Dim processCalculationID As Integer
                                            
                                            Dim queryCalculation As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE fk_FileID = '" & fileID & "' AND fk_ProcessTypeID = 2 ORDER BY NoticeTypes.Notice", conn)
                                            Dim readerCalculation As SqlDataReader = queryCalculation.ExecuteReader()
                                            If readerCalculation.HasRows Then
                                                While readerCalculation.Read
                                                    errorCalculationID = CStr(readerCalculation("ErrorID"))
                                                    detailsCalculation = CStr(readerCalculation("Details"))
                                                    noticeTypeCalculation = CStr(readerCalculation("Notice"))
                                                    statusCalculation = CStr(readerCalculation("Status"))
                                                    errorStaffNameCalculation = CStr(readerCalculation("ErrorStaffName"))
                                                    errorReviewTypeIDCalculation = CStr(readerCalculation("fk_ReviewTypeID"))
                                                    processCalculationID = CStr(readerCalculation("fk_ProcessTypeID"))
                                             %>
                                               <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeCalculation) %>" type="text" />
                                                 </div>
                                               </div>
                                               <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                 <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsCalculation)%></textarea>
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameCalculation) %>" type="text" />
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusCalculation) %>"  type="text" />
                                                </div>
                                               </div>
                                               <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorCalculationID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDCalculation) %>&ProcessTypeID=<% Response.Write(processCalculationID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                 <asp:DropDownList ID="NoticeTypeCalculation" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeCalculation" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeCalculation" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '6' OR [NoticeTypeID] = '7' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '1' OR [NoticeTypeID] = '3' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <textarea class="form-control border-input" cols="4" name="commentCalculation" placeholder="Comment"
                                                    rows="1"></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                 <asp:DropDownList ID="CaseManagerCalculation" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerCalculation" DataValueField="UserID" DataTextField="FullName" required="required"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerCalculation" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="StatusCalculation" class="form-control border-input" runat="server">
                                                         <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="text-center">
                                             <asp:Button ID="btnCreateProcessCalculation" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <hr />
                                    </div>
                                    <div id="payment-standard">
                                        <h6>Payment Standard
                                            &nbsp; &nbsp; &nbsp;
                                            <%
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
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
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
                                        <div class="clearfix">
                                        </div>
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
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorTenantRentID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDTenantRent) %>&PropertyTypeID=<% Response.Write(processTenantRentID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                    <div id="occupancy-standard">
                                        <h6> Occupancy Standard
                                            &nbsp; &nbsp; &nbsp;
                                            <%
                                                If processes.Count > 0 Then
                                                    If processes.Contains("6") Then
                                                        Response.Write("<input type='checkbox' name='processOccupancyStandard' checked='checked' />")
                                                    Else
                                                        Response.Write("<input type='checkbox' name='processOccupancyStandard' />")
                                                    End If
                                                Else
                                                    Response.Write("<input type='checkbox' name='processOccupancyStandard' />")
                                                End If
                                             %>
                                        </h6>
                                        <br />
                                           <%
                                            conn.Open()
                                               Dim errorOccupancyStandardID As Integer
                                               Dim detailsOccupancyStandard As String
                                               Dim noticeTypeOccupancyStandard As String
                                               Dim statusOccupancyStandard As String
                                               Dim errorStaffNameOccupancyStandard As String
                                               Dim errorReviewTypeIDOccupancyStandard As Integer
                                               Dim processOccupancyStandardID As Integer
                                            
                                               Dim queryOccupancyStandard As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE fk_FileID = '" & fileID & "' AND fk_ProcessTypeID = 6 ORDER BY NoticeTypes.Notice", conn)
                                               Dim readerOccupancyStandard As SqlDataReader = queryOccupancyStandard.ExecuteReader()
                                               If readerOccupancyStandard.HasRows Then
                                                   While readerOccupancyStandard.Read
                                                       errorOccupancyStandardID = CStr(readerOccupancyStandard("ErrorID"))
                                                       detailsOccupancyStandard = CStr(readerOccupancyStandard("Details"))
                                                       noticeTypeOccupancyStandard = CStr(readerOccupancyStandard("Notice"))
                                                       statusOccupancyStandard = CStr(readerOccupancyStandard("Status"))
                                                       errorStaffNameOccupancyStandard = CStr(readerOccupancyStandard("ErrorStaffName"))
                                                       errorReviewTypeIDOccupancyStandard = CStr(readerOccupancyStandard("fk_ReviewTypeID"))
                                                       processOccupancyStandardID = CStr(readerOccupancyStandard("fk_ProcessTypeID"))
                                             %>
                                               <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeOccupancyStandard) %>" type="text" />
                                                 </div>
                                               </div>
                                               <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                 <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsOccupancyStandard)%></textarea>
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameOccupancyStandard) %>" type="text" />
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusOccupancyStandard) %>"  type="text" />
                                                </div>
                                               </div>
                                               <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorOccupancyStandardID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDOccupancyStandard) %>&ProcessTypeID=<% Response.Write(processOccupancyStandardID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                   <asp:DropDownList ID="NoticeTypeOccupancyStandard" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeOccupancyStandard" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeOccupancyStandard" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <textarea class="form-control border-input" cols="4" name="commentOccupancyStandard" placeholder="Comment"
                                                    rows="1"></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                               <asp:DropDownList ID="CaseManagerOccupancyStandard" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerOccupancyStandard" DataValueField="UserID" DataTextField="FullName" required="required"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerOccupancyStandard" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="StatusOccupancyStandard" class="form-control border-input" runat="server">
                                                         <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="text-center">
                                             <asp:Button ID="btnCreateProcessOccupancyStandard" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <hr />
                                    </div>
                                    <div id="interim-reexamination">
                                        <h6> Interim Reexamination
                                             &nbsp; &nbsp; &nbsp;
                                            <%
                                                If processes.Count > 0 Then
                                                    If processes.Contains("8") Then
                                                        Response.Write("<input type='checkbox' name='processInterimReexamination' checked='checked' />")
                                                    Else
                                                        Response.Write("<input type='checkbox' name='processInterimReexamination' />")
                                                    End If
                                                Else
                                                    Response.Write("<input type='checkbox' name='procesInterimReexamination' />")
                                                End If
                                             %>
                                        </h6>
                                        <br />
                                       <%
                                            conn.Open()
                                           Dim errorInterimReexaminationID As Integer
                                           Dim detailsInterimReexamination As String
                                           Dim noticeTypeInterimReexamination As String
                                           Dim statusInterimReexamination As String
                                           Dim errorStaffNameInterimReexamination As String
                                           Dim errorReviewTypeIDInterimReexamination As Integer
                                           Dim processInterimReexaminationID As Integer
                                            
                                           Dim queryInterimReexamination As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE fk_FileID = '" & fileID & "' AND fk_ProcessTypeID = 8 ORDER BY NoticeTypes.Notice", conn)
                                           Dim readerInterimReexamination As SqlDataReader = queryInterimReexamination.ExecuteReader()
                                           If readerInterimReexamination.HasRows Then
                                               While readerInterimReexamination.Read
                                                   errorInterimReexaminationID = CStr(readerInterimReexamination("ErrorID"))
                                                   detailsInterimReexamination = CStr(readerInterimReexamination("Details"))
                                                   noticeTypeInterimReexamination = CStr(readerInterimReexamination("Notice"))
                                                   statusInterimReexamination = CStr(readerInterimReexamination("Status"))
                                                   errorStaffNameInterimReexamination = CStr(readerInterimReexamination("ErrorStaffName"))
                                                   errorReviewTypeIDInterimReexamination = CStr(readerInterimReexamination("fk_ReviewTypeID"))
                                                   processInterimReexaminationID = CStr(readerInterimReexamination("fk_ProcessTypeID"))
                                             %>
                                               <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeInterimReexamination) %>" type="text" />
                                                 </div>
                                               </div>
                                               <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                 <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsInterimReexamination)%></textarea>
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameInterimReexamination) %>" type="text" />
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusInterimReexamination) %>"  type="text" />
                                                </div>
                                               </div>
                                               <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorInterimReexaminationID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDInterimReexamination) %>&ProcessTypeID=<% Response.Write(processInterimReexaminationID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                  <asp:DropDownList ID="NoticeTypeInterimReexamination" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeInterimReexamination" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeInterimReexamination" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <textarea class="form-control border-input" cols="4" name="commentInterimReexamination" placeholder="Comment"
                                                    rows="1"></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                  <asp:DropDownList ID="CaseManagerInterimReexamination" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerInterimReexamination" DataValueField="UserID" DataTextField="FullName" required="required"></asp:DropDownList>
                                                  <asp:SqlDataSource ID="SqlCaseManagerInterimReexamination" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                 </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="StatusInterimReexamination" class="form-control border-input" runat="server">
                                                         <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="text-center">
                                            <asp:Button ID="btnCreateProcessInterimReexamination" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <hr />
                                    </div>
                                    <div id="change-in-family-composition">
                                        <h6> Change in Family Composition
                                            &nbsp; &nbsp; &nbsp;
                                              <%
                                                If processes.Count > 0 Then
                                                      If processes.Contains("10") Then
                                                          Response.Write("<input type='checkbox' name='processChangeInFamilyComposition' checked='checked' />")
                                                      Else
                                                          Response.Write("<input type='checkbox' name='processChangeInFamilyComposition' />")
                                                      End If
                                                Else
                                                    Response.Write("<input type='checkbox' name='processChangeInFamilyComposition' />")
                                                End If
                                             %>
                                        </h6>
                                        <br />
                                          <%
                                            conn.Open()
                                              Dim errorChangeInFamilyCompositionID As Integer
                                           Dim detailsChangeInFamilyComposition As String
                                           Dim noticeTypeChangeInFamilyComposition As String
                                           Dim statusChangeInFamilyComposition As String
                                           Dim errorStaffNameChangeInFamilyComposition As String
                                              Dim errorReviewTypeIDChangeInFamilyComposition As Integer
                                              Dim processChangeInFamilyCompositionID As Integer
                                            
                                              Dim queryChangeInFamilyComposition As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE fk_FileID = '" & fileID & "' AND fk_ProcessTypeID = 10 ORDER BY NoticeTypes.Notice", conn)
                                           Dim readerChangeInFamilyComposition As SqlDataReader = queryChangeInFamilyComposition.ExecuteReader()
                                           If readerChangeInFamilyComposition.HasRows Then
                                               While readerChangeInFamilyComposition.Read
                                                   errorChangeInFamilyCompositionID = CStr(readerChangeInFamilyComposition("ErrorID"))
                                                   detailsChangeInFamilyComposition = CStr(readerChangeInFamilyComposition("Details"))
                                                   noticeTypeChangeInFamilyComposition = CStr(readerChangeInFamilyComposition("Notice"))
                                                   statusChangeInFamilyComposition = CStr(readerChangeInFamilyComposition("Status"))
                                                   errorStaffNameChangeInFamilyComposition = CStr(readerChangeInFamilyComposition("ErrorStaffName"))
                                                      errorReviewTypeIDChangeInFamilyComposition = CStr(readerChangeInFamilyComposition("fk_ReviewTypeID"))
                                                      processChangeInFamilyCompositionID = CStr(readerChangeInFamilyComposition("fk_ProcessTypeID"))
                                             %>
                                               <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeChangeInFamilyComposition) %>" type="text" />
                                                 </div>
                                               </div>
                                               <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                 <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsChangeInFamilyComposition)%></textarea>
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameChangeInFamilyComposition) %>" type="text" />
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusChangeInFamilyComposition) %>"  type="text" />
                                                </div>
                                               </div>
                                               <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorChangeInFamilyCompositionID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDChangeInFamilyComposition) %>&ProcessTypeID=<% Response.Write(processChangeInFamilyCompositionID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                <asp:DropDownList ID="NoticeTypeChangeInFamilyComposition" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeChangeInFamilyComposition"
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeChangeInFamilyComposition" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4'">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <textarea class="form-control border-input" cols="4" name="commentChangeInFamilyComposition" placeholder="Comment"
                                                    rows="1"></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                 <asp:DropDownList ID="CaseManagerChangeInFamilyComposition" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerChangeInFamilyComposition" DataValueField="UserID" DataTextField="FullName" required="required"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerChangeInFamilyComposition" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="StatusChangeInFamilyComposition" class="form-control border-input" runat="server">
                                                         <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="text-center">
                                            <asp:Button ID="btnCreateProcessChangeInFamilyComposition" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
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
                                        <div class="clearfix">
                                        </div>
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
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorOtherID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDOther) %>&PropertyTypeID=<% Response.Write(processOtherID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                aria-expanded="true" aria-controls="collapseOne"><i class="fa fa-home" aria-hidden="true"></i> Leasing Documents </a>
                                        </h4>
                                    </div>
                                    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="panel-body">
                                            <hr />
                                            <div id="utility-allowance-checklist">
                                                <h6>  Utility Allowance Checklist
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
                                                    Dim processDocumentUtilityAllowanceChecklistID As Integer
                                                        
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
                                                            processDocumentUtilityAllowanceChecklistID = CStr(readerDocumentUtilityAllowanceChecklist("fk_ProcessTypeID"))
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
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentUtilityAllowanceChecklistID) %>&ReviewTypeID=<% Response.Write(errorDocumentUtilityAllowanceChecklistReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentUtilityAllowanceChecklistID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                        </div>
                                    </div>
                                </div>
                                <div class="panel panel-success">
                                    <div class="panel-heading" role="tab" id="headingTwo">
                                        <h4 class="panel-title">
                                            <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion"
                                                href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo"><i class="fa fa-sticky-note" aria-hidden="true"></i> Notes / Portability
                                                Billing / Compliance</a>
                                        </h4>
                                    </div>
                                    <div id="collapseTwo" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                                        <div class="panel-body">
                                            <hr />
                                            <div id="notes">
                                                <h6> Notes
                                                    &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("56") Then
                                                                 Response.Write("<input type='checkbox' name='documentNotes' checked='checked' />")
                                                            Else
                                                                 Response.Write("<input type='checkbox' name='documentNotes' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentNotes' />")
                                                        End If
                                                     %>
                                                 </h6>
                                                <br />
                                         <%
                                            conn.Open()
                                             Dim errorDocumentNotesErrorID As Integer
                                             Dim errorDocumentNotesID As Integer
                                             Dim detailsDocumentNotes As String
                                             Dim noticeTypeDocumentNotes As String
                                             Dim statusDocumentNotes As String
                                             Dim errorStaffNameDocumentNotes As String
                                             Dim errorDocumentNotesReviewTypeID As Integer
                                             Dim errorsNotesList As New ArrayList
                                             Dim processDocumentNotesID As Integer
                                                        
                                             Dim queryDocumentNotesError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '56' AND fk_FileID = '" & fileID & "'", conn)
                                             Dim readerDocumentNotesError As SqlDataReader = queryDocumentNotesError.ExecuteReader()
                                             If readerDocumentNotesError.HasRows Then
                                                 While readerDocumentNotesError.Read
                                                     errorDocumentNotesErrorID = CStr(readerDocumentNotesError("fk_ErrorID"))
                                                     errorsNotesList.Add(errorDocumentNotesErrorID)
                                                 End While
                                             End If
                                             conn.Close()
                                           
                                             conn.Open()
                                             Dim errorNotesIndex As Integer
                                             For Each errorNotesIndex In errorsNotesList
                                                 Dim queryDocumentNotes As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorNotesIndex & "'", conn)
                                                 Dim readerDocumentNotes As SqlDataReader = queryDocumentNotes.ExecuteReader()
                                                 While readerDocumentNotes.Read
                                                     errorDocumentNotesID = CStr(readerDocumentNotes("ErrorID"))
                                                     detailsDocumentNotes = CStr(readerDocumentNotes("Details"))
                                                     noticeTypeDocumentNotes = CStr(readerDocumentNotes("Notice"))
                                                     statusDocumentNotes = CStr(readerDocumentNotes("Status"))
                                                     errorStaffNameDocumentNotes = CStr(readerDocumentNotes("ErrorStaffName"))
                                                     errorDocumentNotesReviewTypeID = CStr(readerDocumentNotes("fk_ReviewTypeID"))
                                                     processDocumentNotesID = CStr(readerDocumentNotes("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentNotes) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                             <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentNotes)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentNotes) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentNotes) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentNotesID) %>&ReviewTypeID=<% Response.Write(errorDocumentNotesReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentNotesID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                          <asp:DropDownList ID="NoticeTypeNotes" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeNotes" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeNotes" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentNotes" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerNotes" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerNotes" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerNotes" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="StatusNotes" class="form-control border-input" runat="server">
                                                         <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateNotes" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="other">
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
                                                Dim processDocumentOtherID As Integer
                                                        
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
                                                        processDocumentOtherID = CStr(readerDocumentOther("fk_ProcessTypeID"))
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
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentOtherID) %>&ReviewTypeID=<% Response.Write(errorDocumentOtherReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentOtherID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel panel-info">
                                    <div class="panel-heading" role="tab" id="headingThree">
                                        <h4 class="panel-title">
                                            <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion"
                                                href="#collapseThree" aria-expanded="false" aria-controls="collapseThree"><i class="fa fa-certificate" aria-hidden="true"></i> Recertification
                                                Documents</a>
                                        </h4>
                                    </div>
                                    <div id="collapseThree" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingThree">
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
                                              Dim processHapProcessingActionFormID As Integer
                                                        
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
                                                      processHapProcessingActionFormID = CStr(readerDocumentHapProcessingActionForm("fk_ProcessTypeID"))
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
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentHapProcessingActionFormID) %>&ReviewTypeID=<% Response.Write(errorDocumentHapProcessingActionFormReviewTypeID) %>&ProcessTypeID=<% Response.Write(processHapProcessingActionFormID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                            <div id="rent-letter-tenant">
                                                <h6> Rent Letter – Tenant
                                                     &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("58") Then
                                                                Response.Write("<input type='checkbox' name='documentRentLetterTenant' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentRentLetterTenant' />")
                                                            End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentRentLetterTenant' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                        <%
                                            conn.Open()
                                            Dim errorDocumentRentLetterTenantErrorID As Integer
                                             Dim errorDocumentRentLetterTenantID As Integer
                                             Dim detailsDocumentRentLetterTenant As String
                                             Dim noticeTypeDocumentRentLetterTenant As String
                                             Dim statusDocumentRentLetterTenant As String
                                             Dim errorStaffNameDocumentRentLetterTenant As String
                                             Dim errorDocumentRentLetterTenantReviewTypeID As Integer
                                            Dim errorsRentLetterTenantList As New ArrayList
                                            Dim processDocumentRentLetterTenantID As Integer
                                                        
                                              Dim queryDocumentRentLetterTenantError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '58' AND fk_FileID = '" & fileID & "'", conn)
                                             Dim readerDocumentRentLetterTenantError As SqlDataReader = queryDocumentRentLetterTenantError.ExecuteReader()
                                             If readerDocumentRentLetterTenantError.HasRows Then
                                                 While readerDocumentRentLetterTenantError.Read
                                                     errorDocumentRentLetterTenantErrorID = CStr(readerDocumentRentLetterTenantError("fk_ErrorID"))
                                                     errorsRentLetterTenantList.Add(errorDocumentRentLetterTenantErrorID)
                                                 End While
                                             End If
                                             conn.Close()
                                           
                                             conn.Open()
                                             Dim errorRentLetterTenantIndex As Integer
                                             For Each errorRentLetterTenantIndex In errorsRentLetterTenantList
                                                 Dim queryDocumentRentLetterTenant As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorRentLetterTenantIndex & "'", conn)
                                                 Dim readerDocumentRentLetterTenant As SqlDataReader = queryDocumentRentLetterTenant.ExecuteReader()
                                                 While readerDocumentRentLetterTenant.Read
                                                     errorDocumentRentLetterTenantID = CStr(readerDocumentRentLetterTenant("ErrorID"))
                                                     detailsDocumentRentLetterTenant = CStr(readerDocumentRentLetterTenant("Details"))
                                                     noticeTypeDocumentRentLetterTenant = CStr(readerDocumentRentLetterTenant("Notice"))
                                                     statusDocumentRentLetterTenant = CStr(readerDocumentRentLetterTenant("Status"))
                                                     errorStaffNameDocumentRentLetterTenant = CStr(readerDocumentRentLetterTenant("ErrorStaffName"))
                                                    errorDocumentRentLetterTenantReviewTypeID = CStr(readerDocumentRentLetterTenant("fk_ReviewTypeID"))
                                                    processDocumentRentLetterTenantID = CStr(readerDocumentRentLetterTenant("fk_ProcessTypeID"))
                                                               %>
                                               <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentRentLetterTenant) %>" type="text" />
                                                 </div>
                                               </div>
                                                   <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                             <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentRentLetterTenant)%></textarea>
                                            </div>
                                               </div>
                                                 <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentRentLetterTenant) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentRentLetterTenant) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentRentLetterTenantID) %>&ReviewTypeID=<% Response.Write(errorDocumentRentLetterTenantReviewTypeID) %>&PropertyTypeID=<% Response.Write(processDocumentRentLetterTenantID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeRentLetterTenant" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlRentLetterTenant" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlRentLetterTenant" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentRentLetterTenant" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerRentLetterTenant" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerRentLetterTenant" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerRentLetterTenant" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="StatusRentLetterTenant" class="form-control border-input" runat="server">
                                                         <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateRentLetterTenant" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="rent-letter-owner">
                                                <h6>Rent Letter – Owner
                                                      &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("59") Then
                                                                Response.Write("<input type='checkbox' name='documentRentLetterOwner' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentRentLetterOwner' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentRentLetterOwner' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                             <%
                                            conn.Open()
                                                 Dim errorDocumentRentLetterOwnerErrorID As Integer
                                             Dim errorDocumentRentLetterOwnerID As Integer
                                             Dim detailsDocumentRentLetterOwner As String
                                             Dim noticeTypeDocumentRentLetterOwner As String
                                             Dim statusDocumentRentLetterOwner As String
                                             Dim errorStaffNameDocumentRentLetterOwner As String
                                             Dim errorDocumentRentLetterOwnerReviewTypeID As Integer
                                                 Dim errorsRentLetterOwnerList As New ArrayList
                                                 Dim processDocumentRentLetterOwnerID As Integer
                                                        
                                              Dim queryDocumentRentLetterOwnerError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '59' AND fk_FileID = '" & fileID & "'", conn)
                                             Dim readerDocumentRentLetterOwnerError As SqlDataReader = queryDocumentRentLetterOwnerError.ExecuteReader()
                                             If readerDocumentRentLetterOwnerError.HasRows Then
                                                 While readerDocumentRentLetterOwnerError.Read
                                                     errorDocumentRentLetterOwnerErrorID = CStr(readerDocumentRentLetterOwnerError("fk_ErrorID"))
                                                     errorsRentLetterOwnerList.Add(errorDocumentRentLetterOwnerErrorID)
                                                 End While
                                             End If
                                             conn.Close()
                                           
                                             conn.Open()
                                             Dim errorRentLetterOwnerIndex As Integer
                                             For Each errorRentLetterOwnerIndex In errorsRentLetterOwnerList
                                                 Dim queryDocumentRentLetterOwner As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorRentLetterOwnerIndex & "'", conn)
                                                 Dim readerDocumentRentLetterOwner As SqlDataReader = queryDocumentRentLetterOwner.ExecuteReader()
                                                 While readerDocumentRentLetterOwner.Read
                                                     errorDocumentRentLetterOwnerID = CStr(readerDocumentRentLetterOwner("ErrorID"))
                                                     detailsDocumentRentLetterOwner = CStr(readerDocumentRentLetterOwner("Details"))
                                                     noticeTypeDocumentRentLetterOwner = CStr(readerDocumentRentLetterOwner("Notice"))
                                                     statusDocumentRentLetterOwner = CStr(readerDocumentRentLetterOwner("Status"))
                                                     errorStaffNameDocumentRentLetterOwner = CStr(readerDocumentRentLetterOwner("ErrorStaffName"))
                                                         errorDocumentRentLetterOwnerReviewTypeID = CStr(readerDocumentRentLetterOwner("fk_ReviewTypeID"))
                                                         processDocumentRentLetterOwnerID = CStr(readerDocumentRentLetterOwner("fk_ProcessTypeID"))
                                                               %>
                                               <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentRentLetterOwner) %>" type="text" />
                                                 </div>
                                               </div>
                                                   <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                             <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentRentLetterOwner)%></textarea>
                                            </div>
                                               </div>
                                                 <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentRentLetterOwner) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentRentLetterOwner) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentRentLetterOwnerID) %>&ReviewTypeID=<% Response.Write(errorDocumentRentLetterOwnerReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentRentLetterOwnerID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                          <asp:DropDownList ID="NoticeTypeRentLetterOwner" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlRentLetterOwner" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlRentLetterOwner" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentRentLetterOwner" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                          <asp:DropDownList ID="CaseManagerRentLetterOwner" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerRentLetterOwner" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerRentLetterOwner" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="StatusRentLetterOwner" class="form-control border-input" runat="server">
                                                         <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                   <asp:Button ID="btnCreateRentLetterOwner" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="hud-form-50058">
                                                <h6> HUD Form 50058
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("60") Then
                                                                Response.Write("<input type='checkbox' name='documentHudForm50058' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentHudForm50058' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentHudForm50058' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                          <%
                                            conn.Open()
                                              Dim errorDocumentHudForm50058ErrorID As Integer
                                             Dim errorDocumentHudForm50058ID As Integer
                                             Dim detailsDocumentHudForm50058 As String
                                             Dim noticeTypeDocumentHudForm50058 As String
                                             Dim statusDocumentHudForm50058 As String
                                             Dim errorStaffNameDocumentHudForm50058 As String
                                             Dim errorDocumentHudForm50058ReviewTypeID As Integer
                                              Dim errorsHudForm50058List As New ArrayList
                                              Dim processDocumentHudForm50058ID As Integer
                                                        
                                              Dim queryDocumentHudForm50058Error As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '60' AND fk_FileID = '" & fileID & "'", conn)
                                             Dim readerDocumentHudForm50058Error As SqlDataReader = queryDocumentHudForm50058Error.ExecuteReader()
                                             If readerDocumentHudForm50058Error.HasRows Then
                                                 While readerDocumentHudForm50058Error.Read
                                                     errorDocumentHudForm50058ErrorID = CStr(readerDocumentHudForm50058Error("fk_ErrorID"))
                                                     errorsHudForm50058List.Add(errorDocumentHudForm50058ErrorID)
                                                 End While
                                             End If
                                             conn.Close()
                                           
                                             conn.Open()
                                             Dim errorHudForm50058Index As Integer
                                             For Each errorHudForm50058Index In errorsHudForm50058List
                                                 Dim queryDocumentHudForm50058 As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorHudForm50058Index & "'", conn)
                                                 Dim readerDocumentHudForm50058 As SqlDataReader = queryDocumentHudForm50058.ExecuteReader()
                                                 While readerDocumentHudForm50058.Read
                                                     errorDocumentHudForm50058ID = CStr(readerDocumentHudForm50058("ErrorID"))
                                                     detailsDocumentHudForm50058 = CStr(readerDocumentHudForm50058("Details"))
                                                     noticeTypeDocumentHudForm50058 = CStr(readerDocumentHudForm50058("Notice"))
                                                     statusDocumentHudForm50058 = CStr(readerDocumentHudForm50058("Status"))
                                                     errorStaffNameDocumentHudForm50058 = CStr(readerDocumentHudForm50058("ErrorStaffName"))
                                                      errorDocumentHudForm50058ReviewTypeID = CStr(readerDocumentHudForm50058("fk_ReviewTypeID"))
                                                      processDocumentHudForm50058ID = CStr(readerDocumentHudForm50058("fk_ProcessTypeID"))
                                                               %>
                                               <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentHudForm50058) %>" type="text" />
                                                 </div>
                                               </div>
                                                   <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                             <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentHudForm50058)%></textarea>
                                            </div>
                                               </div>
                                                 <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentHudForm50058) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentHudForm50058) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentHudForm50058ID) %>&ReviewTypeID=<% Response.Write(errorDocumentHudForm50058ReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentHudForm50058ID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                      <asp:DropDownList ID="NoticeTypeHudForm50058" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlHudForm50058" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlHudForm50058" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                                </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentHudForm50058" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                          <asp:DropDownList ID="CaseManagerHudForm50058" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerHudForm50058" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerHudForm50058" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="StatusHudForm50058" class="form-control border-input" runat="server">
                                                         <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateHudForm50058" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="rent-calculation-sheet">
                                                <h6>Rent Calculation Sheet
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("61") Then
                                                                Response.Write("<input type='checkbox' name='documentRentCalculationSheet' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentRentCalculationSheet' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentRentCalculationSheet' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                                          <%
                                            conn.Open()
                                              Dim errorDocumentRentCalculationSheetErrorID As Integer
                                             Dim errorDocumentRentCalculationSheetID As Integer
                                             Dim detailsDocumentRentCalculationSheet As String
                                             Dim noticeTypeDocumentRentCalculationSheet As String
                                             Dim statusDocumentRentCalculationSheet As String
                                             Dim errorStaffNameDocumentRentCalculationSheet As String
                                             Dim errorDocumentRentCalculationSheetReviewTypeID As Integer
                                                                              Dim errorsRentCalculationSheetList As New ArrayList
                                                                              Dim processRentCalculationSheetID As Integer
                                                        
                                              Dim queryDocumentRentCalculationSheetError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '61' AND fk_FileID = '" & fileID & "'", conn)
                                             Dim readerDocumentRentCalculationSheetError As SqlDataReader = queryDocumentRentCalculationSheetError.ExecuteReader()
                                             If readerDocumentRentCalculationSheetError.HasRows Then
                                                 While readerDocumentRentCalculationSheetError.Read
                                                     errorDocumentRentCalculationSheetErrorID = CStr(readerDocumentRentCalculationSheetError("fk_ErrorID"))
                                                     errorsRentCalculationSheetList.Add(errorDocumentRentCalculationSheetErrorID)
                                                 End While
                                             End If
                                             conn.Close()
                                           
                                             conn.Open()
                                             Dim errorRentCalculationSheetIndex As Integer
                                             For Each errorRentCalculationSheetIndex In errorsRentCalculationSheetList
                                                 Dim queryDocumentRentCalculationSheet As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorRentCalculationSheetIndex & "'", conn)
                                                 Dim readerDocumentRentCalculationSheet As SqlDataReader = queryDocumentRentCalculationSheet.ExecuteReader()
                                                 While readerDocumentRentCalculationSheet.Read
                                                     errorDocumentRentCalculationSheetID = CStr(readerDocumentRentCalculationSheet("ErrorID"))
                                                     detailsDocumentRentCalculationSheet = CStr(readerDocumentRentCalculationSheet("Details"))
                                                     noticeTypeDocumentRentCalculationSheet = CStr(readerDocumentRentCalculationSheet("Notice"))
                                                     statusDocumentRentCalculationSheet = CStr(readerDocumentRentCalculationSheet("Status"))
                                                     errorStaffNameDocumentRentCalculationSheet = CStr(readerDocumentRentCalculationSheet("ErrorStaffName"))
                                                     errorDocumentRentCalculationSheetReviewTypeID = CStr(readerDocumentRentCalculationSheet("fk_ReviewTypeID"))
                                                        processRentCalculationSheetID = CStr(readerDocumentRentCalculationSheet("fk_ProcessTypeID"))    
                                                                                      %>
                                               <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentRentCalculationSheet) %>" type="text" />
                                                 </div>
                                               </div>
                                                   <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                             <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentRentCalculationSheet)%></textarea>
                                            </div>
                                               </div>
                                                 <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentRentCalculationSheet) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentRentCalculationSheet) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentRentCalculationSheetID) %>&ReviewTypeID=<% Response.Write(errorDocumentRentCalculationSheetReviewTypeID) %>&ProcessTypeID=<% Response.Write(processRentCalculationSheetID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                          <asp:DropDownList ID="NoticeTypeRentCalculationSheet" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlRentCalculationSheet" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlRentCalculationSheet" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentRentCalculationSheet" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerRentCalculationSheet" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerRentCalculationSheet" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerRentCalculationSheet" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="StatusRentCalculationSheet" class="form-control border-input" runat="server">
                                                         <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateRentCalculationSheet" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
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
                                               Dim processDocumentUaCalculationWorksheetEliteID As Integer
                                                        
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
                                                       processDocumentUaCalculationWorksheetEliteID = CStr(readerDocumentUaCalculationWorksheetElite("fk_ProcessTypeID"))   
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
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentUaCalculationWorksheetEliteID) %>&ReviewTypeID=<% Response.Write(errorDocumentUaCalculationWorksheetEliteReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentUaCalculationWorksheetEliteID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                            <div id="application-for-continued-occupancy">
                                                <h6> Application for Continued Occupancy
                                                     &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("62") Then
                                                                 Response.Write("<input type='checkbox' name='documentApplicationForContinuedOccupancy' checked='checked' />")
                                                            Else
                                                                 Response.Write("<input type='checkbox' name='documentApplicationForContinuedOccupancy' />")
                                                            End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentApplicationForContinuedOccupancy' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                          <%
                                            conn.Open()
                                              Dim errorDocumentApplicationForContinuedOccupancyErrorID As Integer
                                             Dim errorDocumentApplicationForContinuedOccupancyID As Integer
                                             Dim detailsDocumentApplicationForContinuedOccupancy As String
                                             Dim noticeTypeDocumentApplicationForContinuedOccupancy As String
                                             Dim statusDocumentApplicationForContinuedOccupancy As String
                                             Dim errorStaffNameDocumentApplicationForContinuedOccupancy As String
                                             Dim errorDocumentApplicationForContinuedOccupancyReviewTypeID As Integer
                                             Dim errorsApplicationForContinuedOccupancyList As New ArrayList
                                             Dim processDocumentApplicationForContinuedOccupancyID As Integer    
                                              
                                              
                                              Dim queryDocumentApplicationForContinuedOccupancyError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '62' AND fk_FileID = '" & fileID & "'", conn)
                                             Dim readerDocumentApplicationForContinuedOccupancyError As SqlDataReader = queryDocumentApplicationForContinuedOccupancyError.ExecuteReader()
                                             If readerDocumentApplicationForContinuedOccupancyError.HasRows Then
                                                 While readerDocumentApplicationForContinuedOccupancyError.Read
                                                     errorDocumentApplicationForContinuedOccupancyErrorID = CStr(readerDocumentApplicationForContinuedOccupancyError("fk_ErrorID"))
                                                     errorsApplicationForContinuedOccupancyList.Add(errorDocumentApplicationForContinuedOccupancyErrorID)
                                                 End While
                                             End If
                                             conn.Close()
                                           
                                             conn.Open()
                                             Dim errorApplicationForContinuedOccupancyIndex As Integer
                                             For Each errorApplicationForContinuedOccupancyIndex In errorsApplicationForContinuedOccupancyList
                                                 Dim queryDocumentApplicationForContinuedOccupancy As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorApplicationForContinuedOccupancyIndex & "'", conn)
                                                 Dim readerDocumentApplicationForContinuedOccupancy As SqlDataReader = queryDocumentApplicationForContinuedOccupancy.ExecuteReader()
                                                 While readerDocumentApplicationForContinuedOccupancy.Read
                                                     errorDocumentApplicationForContinuedOccupancyID = CStr(readerDocumentApplicationForContinuedOccupancy("ErrorID"))
                                                     detailsDocumentApplicationForContinuedOccupancy = CStr(readerDocumentApplicationForContinuedOccupancy("Details"))
                                                     noticeTypeDocumentApplicationForContinuedOccupancy = CStr(readerDocumentApplicationForContinuedOccupancy("Notice"))
                                                     statusDocumentApplicationForContinuedOccupancy = CStr(readerDocumentApplicationForContinuedOccupancy("Status"))
                                                     errorStaffNameDocumentApplicationForContinuedOccupancy = CStr(readerDocumentApplicationForContinuedOccupancy("ErrorStaffName"))
                                                      errorDocumentApplicationForContinuedOccupancyReviewTypeID = CStr(readerDocumentApplicationForContinuedOccupancy("fk_ReviewTypeID"))
                                                      processDocumentApplicationForContinuedOccupancyID = CStr(readerDocumentApplicationForContinuedOccupancy("fk_ProcessTypeID"))
                                                               %>
                                               <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentApplicationForContinuedOccupancy) %>" type="text" />
                                                 </div>
                                               </div>
                                                   <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                             <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentApplicationForContinuedOccupancy)%></textarea>
                                            </div>
                                               </div>
                                                 <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentApplicationForContinuedOccupancy) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentApplicationForContinuedOccupancy) %>"  type="text" />
                                                </div>
                                               </div>
                                                  <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentApplicationForContinuedOccupancyID) %>&ReviewTypeID=<% Response.Write(errorDocumentApplicationForContinuedOccupancyReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentApplicationForContinuedOccupancyID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeApplicationForContinuedOccupancy" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlApplicationForContinuedOccupancy" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlApplicationForContinuedOccupancy" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentApplicationForContinuedOccupancy" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerApplicationForContinuedOccupancy" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerApplicationForContinuedOccupancy" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerApplicationForContinuedOccupancy" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                          <asp:DropDownList ID="StatusApplicationForContinuedOccupancy" class="form-control border-input" runat="server">
                                                         <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateApplicationForContinuedOccupancy" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
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

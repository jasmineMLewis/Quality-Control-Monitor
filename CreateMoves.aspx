<%@ Page Title="QC :: Moves" Language="vb" AutoEventWireup="false" MasterPageFile="~/FileDetails.master" CodeBehind="CreateMoves.aspx.vb" Inherits="QualityControlMonitor.CreateMoves" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="nestedContent" runat="server">
 <div class="row">
        <div class="col-lg-12 col-md-7">
            <div class="card">
                <div class="header">
                    <h4 class="title"><i class="fa fa-map" aria-hidden="true"></i> QC Review :: Moves</h4>
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
                             <asp:Button ID="btnCompleteReview" runat="server" class="btn btn-info btn-fill btn-wd" Text="Complete Moves Review" />
                          <%
                                Else
                          %>
                           <asp:Button ID="btnUpdateReview" runat="server" class="btn btn-warning btn-fill btn-wd" Text="Resubmit Moves Review" />
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
                            &nbsp;&nbsp; Processing</a>
                        </li>
                        <li role="presentation"><a href="#documents" aria-controls="documents" role="tab"
                            data-toggle="tab"><i class="fa fa-file-text" aria-hidden="true"></i>&nbsp;&nbsp;
                            Documents</a>
                        </li>
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
                                     <i class="fa fa-map" aria-hidden="true"></i>    Moves
                                    </h4>
                                </div>
                                <div class="panel-body">
                                    <hr />
                                    <div id="verification">
                                        <h6>Verification  &nbsp; &nbsp; &nbsp;
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
                                        <h6> Calculation
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
                                        <div class="clearfix"></div>
                                        <hr />
                                    </div>
                                    <div id="payment-standard">
                                        <h6> Payment Standard
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
                                    <div id="occupancy-standard">
                                        <h6>Occupancy Standard
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
                                        <div class="clearfix"></div>
                                        <hr />
                                    </div>
                                    <div id="moves">
                                        <h6>Moves &nbsp; &nbsp; &nbsp;
                                            <%
                                                If processes.Count > 0 Then
                                                    If processes.Contains("9") Then
                                                        Response.Write("<input type='checkbox' name='processMoves' checked='checked' />")
                                                    Else
                                                        Response.Write("<input type='checkbox' name='processMoves' />")
                                                    End If
                                                Else
                                                    Response.Write("<input type='checkbox' name='processMoves' />")
                                                End If
                                             %>
                                        </h6>
                                        <br />
                                        <%
                                            conn.Open()
                                           Dim errorMovesID As Integer
                                           Dim detailsMoves As String
                                           Dim noticeTypeMoves As String
                                           Dim statusMoves As String
                                           Dim errorStaffNameMoves As String
                                            Dim errorReviewTypeIDMoves As Integer
                                            Dim processMovesID As Integer
                                            
                                            Dim queryMoves As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE fk_FileID = '" & fileID & "' AND fk_ProcessTypeID = 9 ORDER BY NoticeTypes.Notice", conn)
                                           Dim readerMoves As SqlDataReader = queryMoves.ExecuteReader()
                                           If readerMoves.HasRows Then
                                               While readerMoves.Read
                                                   errorMovesID = CStr(readerMoves("ErrorID"))
                                                   detailsMoves = CStr(readerMoves("Details"))
                                                   noticeTypeMoves = CStr(readerMoves("Notice"))
                                                   statusMoves = CStr(readerMoves("Status"))
                                                   errorStaffNameMoves = CStr(readerMoves("ErrorStaffName"))
                                                    errorReviewTypeIDMoves = CStr(readerMoves("fk_ReviewTypeID"))
                                                    processMovesID = CStr(readerMoves("fk_ProcessTypeID"))
                                             %>
                                               <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeMoves) %>" type="text" />
                                                 </div>
                                               </div>
                                               <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                 <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsMoves)%></textarea>
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameMoves) %>" type="text" />
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusMoves) %>"  type="text" />
                                                </div>
                                               </div>
                                               <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorMovesID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDMoves) %>&ProcessTypeID=<% Response.Write(processMovesID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                  <asp:DropDownList ID="NoticeTypeMoves" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeMoves" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeMoves" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <textarea class="form-control border-input" cols="4" name="commentMoves" placeholder="Comment"
                                                    rows="1"></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                  <asp:DropDownList ID="CaseManagerMoves" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerMoves" DataValueField="UserID" DataTextField="FullName" required="required"></asp:DropDownList>
                                                  <asp:SqlDataSource ID="SqlCaseManagerMoves" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                 </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="StatusMoves" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="text-center">
                                            <asp:Button ID="btnCreateProcessMoves" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <hr />
                                    </div>
                                    <div id="change-in-family-composition">
                                        <h6>Change in Family Composition  &nbsp; &nbsp; &nbsp;
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
                                    <div id="leasing">
                                        <h6> Leasing   &nbsp; &nbsp; &nbsp;
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
                                                     processLeasingID = CStr(readerLeasing("fk_ProcessTypeID"))
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
                                        <h6>Data Entry &nbsp; &nbsp; &nbsp;
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
                                                      processOtherID = Cstr(readerOther("fk_ProcessTypeID"))
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
                                                aria-expanded="true" aria-controls="collapseOne"><i class="fa fa-home" aria-hidden="true"></i> Leasing Documents </a>
                                        </h4>
                                    </div>
                                    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="panel-body">
                                            <hr />
                                            <div id="hud-inspection-checklist-form-hud-52580">
                                                <h6> HUD Inspection Checklist (Form HUD-52580)
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
                                                            If documents.Contains("69") Then
                                                                Response.Write("<input type='checkbox' name='documentHudInspectionChecklistFormHud52580' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentHudInspectionChecklistFormHud52580' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentHudInspectionChecklistFormHud52580' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                               <%
                                                   conn.Open()
                                                   Dim errorDocumentHudInspectionChecklistFormHud52580ErrorID As Integer
                                                   Dim errorDocumentHudInspectionChecklistFormHud52580ID As Integer
                                                   Dim detailsDocumentHudInspectionChecklistFormHud52580 As String
                                                   Dim noticeTypeDocumentHudInspectionChecklistFormHud52580 As String
                                                   Dim statusDocumentHudInspectionChecklistFormHud52580 As String
                                                   Dim errorStaffNameDocumentHudInspectionChecklistFormHud52580 As String
                                                   Dim errorDocumentHudInspectionChecklistFormHud52580ReviewTypeID As Integer
                                                   Dim errorsHudInspectionChecklistFormHud52580List As New ArrayList
                                                   Dim processHudInspectionChecklistFormHud52580ID As Integer
                                                        
                                                    Dim queryDocumentHudInspectionChecklistFormHud52580Error As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '69' AND fk_FileID = '" & fileID & "'", conn)
                                                   Dim readerDocumentHudInspectionChecklistFormHud52580Error As SqlDataReader = queryDocumentHudInspectionChecklistFormHud52580Error.ExecuteReader()
                                                   If readerDocumentHudInspectionChecklistFormHud52580Error.HasRows Then
                                                       While readerDocumentHudInspectionChecklistFormHud52580Error.Read
                                                           errorDocumentHudInspectionChecklistFormHud52580ErrorID = CStr(readerDocumentHudInspectionChecklistFormHud52580Error("fk_ErrorID"))
                                                           errorsHudInspectionChecklistFormHud52580List.Add(errorDocumentHudInspectionChecklistFormHud52580ErrorID)
                                                       End While
                                                   End If
                                                   conn.Close()
                                           
                                                   conn.Open()
                                                   Dim errorHudInspectionChecklistFormHud52580Index As Integer
                                                   For Each errorHudInspectionChecklistFormHud52580Index In errorsHudInspectionChecklistFormHud52580List
                                                       Dim queryDocumentHudInspectionChecklistFormHud52580 As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorHudInspectionChecklistFormHud52580Index & "'", conn)
                                                       Dim readerDocumentHudInspectionChecklistFormHud52580 As SqlDataReader = queryDocumentHudInspectionChecklistFormHud52580.ExecuteReader()
                                                       While readerDocumentHudInspectionChecklistFormHud52580.Read
                                                           errorDocumentHudInspectionChecklistFormHud52580ID = CStr(readerDocumentHudInspectionChecklistFormHud52580("ErrorID"))
                                                           detailsDocumentHudInspectionChecklistFormHud52580 = CStr(readerDocumentHudInspectionChecklistFormHud52580("Details"))
                                                           noticeTypeDocumentHudInspectionChecklistFormHud52580 = CStr(readerDocumentHudInspectionChecklistFormHud52580("Notice"))
                                                           statusDocumentHudInspectionChecklistFormHud52580 = CStr(readerDocumentHudInspectionChecklistFormHud52580("Status"))
                                                           errorStaffNameDocumentHudInspectionChecklistFormHud52580 = CStr(readerDocumentHudInspectionChecklistFormHud52580("ErrorStaffName"))
                                                           errorDocumentHudInspectionChecklistFormHud52580ReviewTypeID = CStr(readerDocumentHudInspectionChecklistFormHud52580("fk_ReviewTypeID"))
                                                           processHudInspectionChecklistFormHud52580ID = CStr(readerDocumentHudInspectionChecklistFormHud52580("fk_ProcessTypeID"))
                                                           %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentHudInspectionChecklistFormHud52580) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentHudInspectionChecklistFormHud52580)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentHudInspectionChecklistFormHud52580) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentHudInspectionChecklistFormHud52580) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentHudInspectionChecklistFormHud52580ID) %>&ReviewTypeID=<% Response.Write(errorDocumentHudInspectionChecklistFormHud52580ReviewTypeID) %>&ProcessTypeID=<% Response.Write(processHudInspectionChecklistFormHud52580ID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeHudInspectionChecklistFormHud52580" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeHudInspectionChecklistFormHud52580" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeHudInspectionChecklistFormHud52580" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentHudInspectionChecklistFormHud52580" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerHudInspectionChecklistFormHud52580" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerHudInspectionChecklistFormHud52580" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerHudInspectionChecklistFormHud52580" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusHudInspectionChecklistFormHud52580" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateHudInspectionChecklistFormHud52580" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix"></div>
                                                <hr />
                                            </div>
                                            <div id="hano-inspection-report">
                                                <h6> HANO Inspection Report
                                                     &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("70") Then
                                                                Response.Write("<input type='checkbox' name='documentHanoInspectionReport' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentHanoInspectionReport' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentHanoInspectionReport' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                              <%
                                                  conn.Open()
                                             Dim errorDocumentHanoInspectionReportErrorID As Integer
                                             Dim errorDocumentHanoInspectionReportID As Integer
                                             Dim detailsDocumentHanoInspectionReport As String
                                             Dim noticeTypeDocumentHanoInspectionReport As String
                                             Dim statusDocumentHanoInspectionReport As String
                                             Dim errorStaffNameDocumentHanoInspectionReport As String
                                             Dim errorDocumentHanoInspectionReportReviewTypeID As Integer
                                                  Dim errorsHanoInspectionReportList As New ArrayList
                                                  Dim processDocumentHanoInspectionReportErrorID As Integer
                                                        
                                                                            Dim queryDocumentHanoInspectionReportError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '70' AND fk_FileID = '" & fileID & "'", conn)
                                             Dim readerDocumentHanoInspectionReportError As SqlDataReader = queryDocumentHanoInspectionReportError.ExecuteReader()
                                             If readerDocumentHanoInspectionReportError.HasRows Then
                                                 While readerDocumentHanoInspectionReportError.Read
                                                     errorDocumentHanoInspectionReportErrorID = CStr(readerDocumentHanoInspectionReportError("fk_ErrorID"))
                                                     errorsHanoInspectionReportList.Add(errorDocumentHanoInspectionReportErrorID)
                                                 End While
                                             End If
                                             conn.Close()
                                           
                                             conn.Open()
                                             Dim errorHanoInspectionReportIndex As Integer
                                             For Each errorHanoInspectionReportIndex In errorsHanoInspectionReportList
                                                      Dim queryDocumentHanoInspectionReport As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorHanoInspectionReportIndex & "'", conn)
                                                 Dim readerDocumentHanoInspectionReport As SqlDataReader = queryDocumentHanoInspectionReport.ExecuteReader()
                                                 While readerDocumentHanoInspectionReport.Read
                                                     errorDocumentHanoInspectionReportID = CStr(readerDocumentHanoInspectionReport("ErrorID"))
                                                     detailsDocumentHanoInspectionReport = CStr(readerDocumentHanoInspectionReport("Details"))
                                                     noticeTypeDocumentHanoInspectionReport = CStr(readerDocumentHanoInspectionReport("Notice"))
                                                     statusDocumentHanoInspectionReport = CStr(readerDocumentHanoInspectionReport("Status"))
                                                     errorStaffNameDocumentHanoInspectionReport = CStr(readerDocumentHanoInspectionReport("ErrorStaffName"))
                                                          errorDocumentHanoInspectionReportReviewTypeID = CStr(readerDocumentHanoInspectionReport("fk_ReviewTypeID"))
                                                          processDocumentHanoInspectionReportErrorID = CStr(readerDocumentHanoInspectionReport("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentHanoInspectionReport) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                             <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentHanoInspectionReport)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentHanoInspectionReport) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentHanoInspectionReport) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentHanoInspectionReportID) %>&ReviewTypeID=<% Response.Write(errorDocumentHanoInspectionReportReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentHanoInspectionReportErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                          <asp:DropDownList ID="NoticeTypeHanoInspectionReport" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeHanoInspectionReport" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeHanoInspectionReport" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentHanoInspectionReport" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerHanoInspectionReport" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerHanoInspectionReport" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerHanoInspectionReport" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="StatusHanoInspectionReport" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateHanoInspectionReport" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix"></div>
                                                <hr />
                                            </div>
                                            <div id="inspection-outcome-letter">
                                                <h6> Inspection Outcome Letter
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("71") Then
                                                                Response.Write("<input type='checkbox' name='documentInspectionOutcomeLetter' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentInspectionOutcomeLetter' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentInspectionOutcomeLetter' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                <%
                                            conn.Open()
                                             Dim errorDocumentInspectionOutcomeLetterErrorID As Integer
                                             Dim errorDocumentInspectionOutcomeLetterID As Integer
                                             Dim detailsDocumentInspectionOutcomeLetter As String
                                             Dim noticeTypeDocumentInspectionOutcomeLetter As String
                                             Dim statusDocumentInspectionOutcomeLetter As String
                                             Dim errorStaffNameDocumentInspectionOutcomeLetter As String
                                             Dim errorDocumentInspectionOutcomeLetterReviewTypeID As Integer
                                                                            Dim errorsInspectionOutcomeLetterList As New ArrayList
                                                                            Dim processDocumentInspectionOutcomeLetterErrorID As Integer
                                                        
                                                                            Dim queryDocumentInspectionOutcomeLetterError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '71' AND fk_FileID = '" & fileID & "'", conn)
                                             Dim readerDocumentInspectionOutcomeLetterError As SqlDataReader = queryDocumentInspectionOutcomeLetterError.ExecuteReader()
                                             If readerDocumentInspectionOutcomeLetterError.HasRows Then
                                                 While readerDocumentInspectionOutcomeLetterError.Read
                                                     errorDocumentInspectionOutcomeLetterErrorID = CStr(readerDocumentInspectionOutcomeLetterError("fk_ErrorID"))
                                                     errorsInspectionOutcomeLetterList.Add(errorDocumentInspectionOutcomeLetterErrorID)
                                                 End While
                                             End If
                                             conn.Close()
                                           
                                             conn.Open()
                                             Dim errorInspectionOutcomeLetterIndex As Integer
                                             For Each errorInspectionOutcomeLetterIndex In errorsInspectionOutcomeLetterList
                                                                                Dim queryDocumentInspectionOutcomeLetter As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorInspectionOutcomeLetterIndex & "'", conn)
                                                 Dim readerDocumentInspectionOutcomeLetter As SqlDataReader = queryDocumentInspectionOutcomeLetter.ExecuteReader()
                                                 While readerDocumentInspectionOutcomeLetter.Read
                                                     errorDocumentInspectionOutcomeLetterID = CStr(readerDocumentInspectionOutcomeLetter("ErrorID"))
                                                     detailsDocumentInspectionOutcomeLetter = CStr(readerDocumentInspectionOutcomeLetter("Details"))
                                                     noticeTypeDocumentInspectionOutcomeLetter = CStr(readerDocumentInspectionOutcomeLetter("Notice"))
                                                     statusDocumentInspectionOutcomeLetter = CStr(readerDocumentInspectionOutcomeLetter("Status"))
                                                     errorStaffNameDocumentInspectionOutcomeLetter = CStr(readerDocumentInspectionOutcomeLetter("ErrorStaffName"))
                                                                                    errorDocumentInspectionOutcomeLetterReviewTypeID = CStr(readerDocumentInspectionOutcomeLetter("fk_ReviewTypeID"))
                                                                                    processDocumentInspectionOutcomeLetterErrorID = CStr(readerDocumentInspectionOutcomeLetter("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentInspectionOutcomeLetter) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                             <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentInspectionOutcomeLetter)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentInspectionOutcomeLetter) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentInspectionOutcomeLetter) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentInspectionOutcomeLetterID) %>&ReviewTypeID=<% Response.Write(errorDocumentInspectionOutcomeLetterReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentInspectionOutcomeLetterErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                          <asp:DropDownList ID="NoticeTypeInspectionOutcomeLetter" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeInspectionOutcomeLetter" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeInspectionOutcomeLetter" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentInspectionOutcomeLetter" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerInspectionOutcomeLetter" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerInspectionOutcomeLetter" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerInspectionOutcomeLetter" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="StatusInspectionOutcomeLetter" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateInspectionOutcomeLetter" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix"></div>
                                                <hr />
                                            </div>
                                            <div id="amenities-report">
                                                <h6> Amenities Report
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("1") Then
                                                                Response.Write("<input type='checkbox' name='documentAmenitiesReport' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentAmenitiesReport' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentAmenitiesReport' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                                       <%
                                            conn.Open()
                                             Dim errorDocumentAmenitiesReportErrorID As Integer
                                             Dim errorDocumentAmenitiesReportID As Integer
                                             Dim detailsDocumentAmenitiesReport As String
                                             Dim noticeTypeDocumentAmenitiesReport As String
                                             Dim statusDocumentAmenitiesReport As String
                                             Dim errorStaffNameDocumentAmenitiesReport As String
                                             Dim errorDocumentAmenitiesReportReviewTypeID As Integer
                                                                           Dim errorsAmenitiesReportList As New ArrayList
                                                                           Dim processDocumentAmenitiesReportErrorID As Integer
                                                        
                                             Dim queryDocumentAmenitiesReportError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '1' AND fk_FileID = '" & fileID & "'", conn)
                                             Dim readerDocumentAmenitiesReportError As SqlDataReader = queryDocumentAmenitiesReportError.ExecuteReader()
                                             If readerDocumentAmenitiesReportError.HasRows Then
                                                 While readerDocumentAmenitiesReportError.Read
                                                     errorDocumentAmenitiesReportErrorID = CStr(readerDocumentAmenitiesReportError("fk_ErrorID"))
                                                     errorsAmenitiesReportList.Add(errorDocumentAmenitiesReportErrorID)
                                                 End While
                                             End If
                                             conn.Close()
                                           
                                             conn.Open()
                                             Dim errorAmenitiesReportIndex As Integer
                                             For Each errorAmenitiesReportIndex In errorsAmenitiesReportList
                                                 Dim queryDocumentAmenitiesReport As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorAmenitiesReportIndex & "'", conn)
                                                 Dim readerDocumentAmenitiesReport As SqlDataReader = queryDocumentAmenitiesReport.ExecuteReader()
                                                 While readerDocumentAmenitiesReport.Read
                                                     errorDocumentAmenitiesReportID = CStr(readerDocumentAmenitiesReport("ErrorID"))
                                                     detailsDocumentAmenitiesReport = CStr(readerDocumentAmenitiesReport("Details"))
                                                     noticeTypeDocumentAmenitiesReport = CStr(readerDocumentAmenitiesReport("Notice"))
                                                     statusDocumentAmenitiesReport = CStr(readerDocumentAmenitiesReport("Status"))
                                                     errorStaffNameDocumentAmenitiesReport = CStr(readerDocumentAmenitiesReport("ErrorStaffName"))
                                                                                   errorDocumentAmenitiesReportReviewTypeID = CStr(readerDocumentAmenitiesReport("fk_ReviewTypeID"))
                                                                                   processDocumentAmenitiesReportErrorID = CStr(readerDocumentAmenitiesReport("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentAmenitiesReport) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                             <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentAmenitiesReport)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentAmenitiesReport) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentAmenitiesReport) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentAmenitiesReportID) %>&ReviewTypeID=<% Response.Write(errorDocumentAmenitiesReportReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentAmenitiesReportErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                          <asp:DropDownList ID="NoticeTypeAmenitiesReport" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeAmenitiesReport" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeAmenitiesReport" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentAmenitiesReport" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerAmenitiesReport" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerAmenitiesReport" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerAmenitiesReport" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="StatusAmenitiesReport" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateAmenitiesReport" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix"> </div>
                                                <hr />
                                            </div>
                                            <div id="reasonable-rent-determination-certification">
                                                <h6> Reasonable Rent Determination Certification
                                                     &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("7") Then
                                                                Response.Write("<input type='checkbox' name='documentReasonableRentDeterminationCertification' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentReasonableRentDeterminationCertification' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentReasonableRentDeterminationCertification' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                   <%
                                                   conn.Open()
                                                   Dim errorDocumentReasonableRentDeterminationCertificationErrorID As Integer
                                                   Dim errorDocumentReasonableRentDeterminationCertificationID As Integer
                                                   Dim detailsDocumentReasonableRentDeterminationCertification As String
                                                   Dim noticeTypeDocumentReasonableRentDeterminationCertification As String
                                                   Dim statusDocumentReasonableRentDeterminationCertification As String
                                                   Dim errorStaffNameDocumentReasonableRentDeterminationCertification As String
                                                   Dim errorDocumentReasonableRentDeterminationCertificationReviewTypeID As Integer
                                                       Dim errorsReasonableRentDeterminationCertificationList As New ArrayList
                                                       Dim processDocumentReasonableRentDeterminationCertificationErrorID As Integer
                                                        
                                                    Dim queryDocumentReasonableRentDeterminationCertificationError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '7' AND fk_FileID = '" & fileID & "'", conn)
                                                   Dim readerDocumentReasonableRentDeterminationCertificationError As SqlDataReader = queryDocumentReasonableRentDeterminationCertificationError.ExecuteReader()
                                                   If readerDocumentReasonableRentDeterminationCertificationError.HasRows Then
                                                       While readerDocumentReasonableRentDeterminationCertificationError.Read
                                                           errorDocumentReasonableRentDeterminationCertificationErrorID = CStr(readerDocumentReasonableRentDeterminationCertificationError("fk_ErrorID"))
                                                           errorsReasonableRentDeterminationCertificationList.Add(errorDocumentReasonableRentDeterminationCertificationErrorID)
                                                       End While
                                                   End If
                                                   conn.Close()
                                           
                                                   conn.Open()
                                                   Dim errorReasonableRentDeterminationCertificationIndex As Integer
                                                   For Each errorReasonableRentDeterminationCertificationIndex In errorsReasonableRentDeterminationCertificationList
                                                           Dim queryDocumentReasonableRentDeterminationCertification As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorReasonableRentDeterminationCertificationIndex & "'", conn)
                                                       Dim readerDocumentReasonableRentDeterminationCertification As SqlDataReader = queryDocumentReasonableRentDeterminationCertification.ExecuteReader()
                                                       While readerDocumentReasonableRentDeterminationCertification.Read
                                                           errorDocumentReasonableRentDeterminationCertificationID = CStr(readerDocumentReasonableRentDeterminationCertification("ErrorID"))
                                                           detailsDocumentReasonableRentDeterminationCertification = CStr(readerDocumentReasonableRentDeterminationCertification("Details"))
                                                           noticeTypeDocumentReasonableRentDeterminationCertification = CStr(readerDocumentReasonableRentDeterminationCertification("Notice"))
                                                           statusDocumentReasonableRentDeterminationCertification = CStr(readerDocumentReasonableRentDeterminationCertification("Status"))
                                                           errorStaffNameDocumentReasonableRentDeterminationCertification = CStr(readerDocumentReasonableRentDeterminationCertification("ErrorStaffName"))
                                                               errorDocumentReasonableRentDeterminationCertificationReviewTypeID = CStr(readerDocumentReasonableRentDeterminationCertification("fk_ReviewTypeID"))
                                                               processDocumentReasonableRentDeterminationCertificationErrorID = CStr(readerDocumentReasonableRentDeterminationCertification("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentReasonableRentDeterminationCertification) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentReasonableRentDeterminationCertification)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentReasonableRentDeterminationCertification) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentReasonableRentDeterminationCertification) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentReasonableRentDeterminationCertificationID) %>&ReviewTypeID=<% Response.Write(errorDocumentReasonableRentDeterminationCertificationReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentReasonableRentDeterminationCertificationErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeReasonableRentDeterminationCertification" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeReasonableRentDeterminationCertification" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeReasonableRentDeterminationCertification" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentReasonableRentDeterminationCertification" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerReasonableRentDeterminationCertification" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerReasonableRentDeterminationCertification" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerReasonableRentDeterminationCertification" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusReasonableRentDeterminationCertification" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateReasonableRentDeterminationCertification" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix"></div>
                                                <hr />
                                            </div>
                                            <div id="reasonable-rent-comparables">
                                                <h6> Reasonable Rent Comparables
                                                     &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("2") Then
                                                                Response.Write("<input type='checkbox' name='documentReasonableRentComparables' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentReasonableRentComparables' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentReasonableRentComparables' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                             <%
                                                   conn.Open()
                                                   Dim errorDocumentReasonableRentComparablesErrorID As Integer
                                                   Dim errorDocumentReasonableRentComparablesID As Integer
                                                   Dim detailsDocumentReasonableRentComparables As String
                                                   Dim noticeTypeDocumentReasonableRentComparables As String
                                                   Dim statusDocumentReasonableRentComparables As String
                                                   Dim errorStaffNameDocumentReasonableRentComparables As String
                                                   Dim errorDocumentReasonableRentComparablesReviewTypeID As Integer
                                                 Dim errorsReasonableRentComparablesList As New ArrayList
                                                 Dim processDocumentReasonableRentComparablesErrorID As Integer
                                                        
                                                 Dim queryDocumentReasonableRentComparablesError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '2' AND fk_FileID = '" & fileID & "'", conn)
                                                   Dim readerDocumentReasonableRentComparablesError As SqlDataReader = queryDocumentReasonableRentComparablesError.ExecuteReader()
                                                   If readerDocumentReasonableRentComparablesError.HasRows Then
                                                       While readerDocumentReasonableRentComparablesError.Read
                                                           errorDocumentReasonableRentComparablesErrorID = CStr(readerDocumentReasonableRentComparablesError("fk_ErrorID"))
                                                           errorsReasonableRentComparablesList.Add(errorDocumentReasonableRentComparablesErrorID)
                                                       End While
                                                   End If
                                                   conn.Close()
                                           
                                                   conn.Open()
                                                   Dim errorReasonableRentComparablesIndex As Integer
                                                   For Each errorReasonableRentComparablesIndex In errorsReasonableRentComparablesList
                                                     Dim queryDocumentReasonableRentComparables As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorReasonableRentComparablesIndex & "'", conn)
                                                       Dim readerDocumentReasonableRentComparables As SqlDataReader = queryDocumentReasonableRentComparables.ExecuteReader()
                                                       While readerDocumentReasonableRentComparables.Read
                                                           errorDocumentReasonableRentComparablesID = CStr(readerDocumentReasonableRentComparables("ErrorID"))
                                                           detailsDocumentReasonableRentComparables = CStr(readerDocumentReasonableRentComparables("Details"))
                                                           noticeTypeDocumentReasonableRentComparables = CStr(readerDocumentReasonableRentComparables("Notice"))
                                                           statusDocumentReasonableRentComparables = CStr(readerDocumentReasonableRentComparables("Status"))
                                                           errorStaffNameDocumentReasonableRentComparables = CStr(readerDocumentReasonableRentComparables("ErrorStaffName"))
                                                         errorDocumentReasonableRentComparablesReviewTypeID = CStr(readerDocumentReasonableRentComparables("fk_ReviewTypeID"))
                                                         processDocumentReasonableRentComparablesErrorID = CStr(readerDocumentReasonableRentComparables("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentReasonableRentComparables) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentReasonableRentComparables)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentReasonableRentComparables) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentReasonableRentComparables) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentReasonableRentComparablesID) %>&ReviewTypeID=<% Response.Write(errorDocumentReasonableRentComparablesReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentReasonableRentComparablesErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeReasonableRentComparables" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeReasonableRentComparables" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeReasonableRentComparables" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentReasonableRentComparables" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerReasonableRentComparables" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerReasonableRentComparables" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerReasonableRentComparables" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusReasonableRentComparables" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateReasonableRentComparables" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix"></div>
                                                <hr />
                                            </div>
                                            <div id="rent-burden-worksheet">
                                                <h6>Rent Burden Worksheet
                                                     &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("3") Then
                                                                Response.Write("<input type='checkbox' name='documentRentBurdenWorksheet' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentRentBurdenWorksheet' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentRentBurdenWorksheet' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                  <%
                                                   conn.Open()
                                                   Dim errorDocumentRentBurdenWorksheetErrorID As Integer
                                                   Dim errorDocumentRentBurdenWorksheetID As Integer
                                                   Dim detailsDocumentRentBurdenWorksheet As String
                                                   Dim noticeTypeDocumentRentBurdenWorksheet As String
                                                   Dim statusDocumentRentBurdenWorksheet As String
                                                   Dim errorStaffNameDocumentRentBurdenWorksheet As String
                                                   Dim errorDocumentRentBurdenWorksheetReviewTypeID As Integer
                                                      Dim errorsRentBurdenWorksheetList As New ArrayList
                                                      Dim processDocumentRentBurdenWorksheetErrorID As Integer
                                                        
                                                    Dim queryDocumentRentBurdenWorksheetError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '3' AND fk_FileID = '" & fileID & "'", conn)
                                                   Dim readerDocumentRentBurdenWorksheetError As SqlDataReader = queryDocumentRentBurdenWorksheetError.ExecuteReader()
                                                   If readerDocumentRentBurdenWorksheetError.HasRows Then
                                                       While readerDocumentRentBurdenWorksheetError.Read
                                                           errorDocumentRentBurdenWorksheetErrorID = CStr(readerDocumentRentBurdenWorksheetError("fk_ErrorID"))
                                                           errorsRentBurdenWorksheetList.Add(errorDocumentRentBurdenWorksheetErrorID)
                                                       End While
                                                   End If
                                                   conn.Close()
                                           
                                                   conn.Open()
                                                   Dim errorRentBurdenWorksheetIndex As Integer
                                                   For Each errorRentBurdenWorksheetIndex In errorsRentBurdenWorksheetList
                                                          Dim queryDocumentRentBurdenWorksheet As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorRentBurdenWorksheetIndex & "'", conn)
                                                       Dim readerDocumentRentBurdenWorksheet As SqlDataReader = queryDocumentRentBurdenWorksheet.ExecuteReader()
                                                       While readerDocumentRentBurdenWorksheet.Read
                                                           errorDocumentRentBurdenWorksheetID = CStr(readerDocumentRentBurdenWorksheet("ErrorID"))
                                                           detailsDocumentRentBurdenWorksheet = CStr(readerDocumentRentBurdenWorksheet("Details"))
                                                           noticeTypeDocumentRentBurdenWorksheet = CStr(readerDocumentRentBurdenWorksheet("Notice"))
                                                           statusDocumentRentBurdenWorksheet = CStr(readerDocumentRentBurdenWorksheet("Status"))
                                                           errorStaffNameDocumentRentBurdenWorksheet = CStr(readerDocumentRentBurdenWorksheet("ErrorStaffName"))
                                                              errorDocumentRentBurdenWorksheetReviewTypeID = CStr(readerDocumentRentBurdenWorksheet("fk_ReviewTypeID"))
                                                              processDocumentRentBurdenWorksheetErrorID = CStr(readerDocumentRentBurdenWorksheet("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentRentBurdenWorksheet) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentRentBurdenWorksheet)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentRentBurdenWorksheet) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentRentBurdenWorksheet) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentRentBurdenWorksheetID) %>&ReviewTypeID=<% Response.Write(errorDocumentRentBurdenWorksheetReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentRentBurdenWorksheetErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeRentBurdenWorksheet" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeRentBurdenWorksheet" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeRentBurdenWorksheet" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentRentBurdenWorksheet" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerRentBurdenWorksheet" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerRentBurdenWorksheet" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerRentBurdenWorksheet" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusRentBurdenWorksheet" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateRentBurdenWorksheet" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="master-leasing-checklist">
                                                <h6> Master Leasing Checklist
                                                 &nbsp; &nbsp; &nbsp;
                                                 <%
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
                                                <h6> Checklist-Leasing /  Inspections
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
                                                <h6> Utility Allowance Checklist
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
                                            <hr />
                                            <div id="signed-original-voucher">
                                                <h6>Signed Original Voucher
                                                    &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("55") Then
                                                                 Response.Write("<input type='checkbox' name='documentSignedOriginalVoucher' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentSignedOriginalVoucher' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentSignedOriginalVoucher' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                <%
                                            conn.Open()
                                             Dim errorDocumentSignedOriginalVoucherErrorID As Integer
                                             Dim errorDocumentSignedOriginalVoucherID As Integer
                                             Dim detailsDocumentSignedOriginalVoucher As String
                                             Dim noticeTypeDocumentSignedOriginalVoucher As String
                                             Dim statusDocumentSignedOriginalVoucher As String
                                             Dim errorStaffNameDocumentSignedOriginalVoucher As String
                                             Dim errorDocumentSignedOriginalVoucherReviewTypeID As Integer
                                                    Dim errorsSignedOriginalVoucherList As New ArrayList
                                                    Dim processDocumentSignedOriginalVoucherErrorID As Integer
                                                        
                                             Dim queryDocumentSignedOriginalVoucherError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '55' AND fk_FileID = '" & fileID & "'", conn)
                                             Dim readerDocumentSignedOriginalVoucherError As SqlDataReader = queryDocumentSignedOriginalVoucherError.ExecuteReader()
                                             If readerDocumentSignedOriginalVoucherError.HasRows Then
                                                 While readerDocumentSignedOriginalVoucherError.Read
                                                     errorDocumentSignedOriginalVoucherErrorID = CStr(readerDocumentSignedOriginalVoucherError("fk_ErrorID"))
                                                     errorsSignedOriginalVoucherList.Add(errorDocumentSignedOriginalVoucherErrorID)
                                                 End While
                                             End If
                                             conn.Close()
                                           
                                             conn.Open()
                                             Dim errorSignedOriginalVoucherIndex As Integer
                                             For Each errorSignedOriginalVoucherIndex In errorsSignedOriginalVoucherList
                                                 Dim queryDocumentSignedOriginalVoucher As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorSignedOriginalVoucherIndex & "'", conn)
                                                 Dim readerDocumentSignedOriginalVoucher As SqlDataReader = queryDocumentSignedOriginalVoucher.ExecuteReader()
                                                 While readerDocumentSignedOriginalVoucher.Read
                                                     errorDocumentSignedOriginalVoucherID = CStr(readerDocumentSignedOriginalVoucher("ErrorID"))
                                                     detailsDocumentSignedOriginalVoucher = CStr(readerDocumentSignedOriginalVoucher("Details"))
                                                     noticeTypeDocumentSignedOriginalVoucher = CStr(readerDocumentSignedOriginalVoucher("Notice"))
                                                     statusDocumentSignedOriginalVoucher = CStr(readerDocumentSignedOriginalVoucher("Status"))
                                                     errorStaffNameDocumentSignedOriginalVoucher = CStr(readerDocumentSignedOriginalVoucher("ErrorStaffName"))
                                                            errorDocumentSignedOriginalVoucherReviewTypeID = CStr(readerDocumentSignedOriginalVoucher("fk_ReviewTypeID"))
                                                            processDocumentSignedOriginalVoucherErrorID = CStr(readerDocumentSignedOriginalVoucher("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentSignedOriginalVoucher) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                             <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentSignedOriginalVoucher)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentSignedOriginalVoucher) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentSignedOriginalVoucher) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentSignedOriginalVoucherID) %>&ReviewTypeID=<% Response.Write(errorDocumentSignedOriginalVoucherReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentSignedOriginalVoucherErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                          <asp:DropDownList ID="NoticeTypeSignedOriginalVoucher" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeSignedOriginalVoucher" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeSignedOriginalVoucher" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentSignedOriginalVoucher" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerSignedOriginalVoucher" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerSignedOriginalVoucher" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerSignedOriginalVoucher" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="StatusSignedOriginalVoucher" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateSignedOriginalVoucher" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix"></div>
                                                <hr />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel panel-info">
                                    <div class="panel-heading" role="tab" id="headingThree">
                                        <h4 class="panel-title">
                                            <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion"
                                                href="#collapseThree" aria-expanded="false" aria-controls="collapseThree"><i class="fa fa-sticky-note" aria-hidden="true"></i> Notes
                                                / Portability Billing / Compliance</a>
                                        </h4>
                                    </div>
                                    <div id="collapseThree" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingThree">
                                        <div class="panel-body">
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
                                            <div id="rent-letter-tenant">
                                                <h6>Rent Letter – Tenant
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
                                            Dim processDocumentRentLetterTenantErrorID As Integer
                                                        
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
                                                    processDocumentRentLetterTenantErrorID = CStr(readerDocumentRentLetterTenant("fk_ProcessTypeID"))
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
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentRentLetterTenantID) %>&ReviewTypeID=<% Response.Write(errorDocumentRentLetterTenantReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentRentLetterTenantErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                 Dim processDocumentRentLetterOwnerErrorID As Integer
                                                        
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
                                                         processDocumentRentLetterOwnerErrorID = CStr(readerDocumentRentLetterOwner("fk_ProcessTypeID"))
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
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentRentLetterOwnerID) %>&ReviewTypeID=<% Response.Write(errorDocumentRentLetterOwnerReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentRentLetterOwnerErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                <h6>HUD Form 50058
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
                                              Dim processDocumentHudForm50058ErrorID As Integer
                                                        
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
                                                      processDocumentHudForm50058ErrorID = CStr(readerDocumentHudForm50058("fk_ProcessTypeID"))
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
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentHudForm50058ID) %>&ReviewTypeID=<% Response.Write(errorDocumentHudForm50058ReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentHudForm50058ErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                <h6> Rent Calculation Sheet
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
                                                                              Dim processDocumentRentCalculationSheetErrorID As Integer
                                                        
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
                                                                                      processDocumentRentCalculationSheetErrorID = CStr(readerDocumentRentCalculationSheet("fk_ProcessTypeID"))
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
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentRentCalculationSheetID) %>&ReviewTypeID=<% Response.Write(errorDocumentRentCalculationSheetReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentRentCalculationSheetErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                            <div id="letter-of-good-standing">
                                                <h6>Letter of Good Standing
                                                     &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("73") Then
                                                                 Response.Write("<input type='checkbox' name='documentLetterOfGoodStanding' checked='checked' />")
                                                            Else
                                                                 Response.Write("<input type='checkbox' name='documentLetterOfGoodStanding' />")
                                                            End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentLetterOfGoodStanding' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                <%
                                                    conn.Open()
                                                                 Dim errorDocumentLetterOfGoodStandingErrorID As Integer
                                                                 Dim errorDocumentLetterOfGoodStandingID As Integer
                                                                 Dim detailsDocumentLetterOfGoodStanding As String
                                                                 Dim noticeTypeDocumentLetterOfGoodStanding As String
                                                                 Dim statusDocumentLetterOfGoodStanding As String
                                                                 Dim errorStaffNameDocumentLetterOfGoodStanding As String
                                                                 Dim errorDocumentLetterOfGoodStandingReviewTypeID As Integer
                                                    Dim errorsLetterOfGoodStandingList As New ArrayList
                                                    Dim processDocumentLetterOfGoodStandingErrorID As Integer
                                                        
                                                     Dim queryDocumentLetterOfGoodStandingError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '73' AND fk_FileID = '" & fileID & "'", conn)
                                                                 Dim readerDocumentLetterOfGoodStandingError As SqlDataReader = queryDocumentLetterOfGoodStandingError.ExecuteReader()
                                                                 If readerDocumentLetterOfGoodStandingError.HasRows Then
                                                                     While readerDocumentLetterOfGoodStandingError.Read
                                                                         errorDocumentLetterOfGoodStandingErrorID = CStr(readerDocumentLetterOfGoodStandingError("fk_ErrorID"))
                                                                         errorsLetterOfGoodStandingList.Add(errorDocumentLetterOfGoodStandingErrorID)
                                                                     End While
                                                                 End If
                                                                 conn.Close()
                                           
                                                                 conn.Open()
                                                                 Dim errorLetterOfGoodStandingIndex As Integer
                                                                 For Each errorLetterOfGoodStandingIndex In errorsLetterOfGoodStandingList
                                                        Dim queryDocumentLetterOfGoodStanding As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorLetterOfGoodStandingIndex & "'", conn)
                                                                     Dim readerDocumentLetterOfGoodStanding As SqlDataReader = queryDocumentLetterOfGoodStanding.ExecuteReader()
                                                                     While readerDocumentLetterOfGoodStanding.Read
                                                                         errorDocumentLetterOfGoodStandingID = CStr(readerDocumentLetterOfGoodStanding("ErrorID"))
                                                                         detailsDocumentLetterOfGoodStanding = CStr(readerDocumentLetterOfGoodStanding("Details"))
                                                                         noticeTypeDocumentLetterOfGoodStanding = CStr(readerDocumentLetterOfGoodStanding("Notice"))
                                                                         statusDocumentLetterOfGoodStanding = CStr(readerDocumentLetterOfGoodStanding("Status"))
                                                                         errorStaffNameDocumentLetterOfGoodStanding = CStr(readerDocumentLetterOfGoodStanding("ErrorStaffName"))
                                                            errorDocumentLetterOfGoodStandingReviewTypeID = CStr(readerDocumentLetterOfGoodStanding("fk_ReviewTypeID"))
                                                            processDocumentLetterOfGoodStandingErrorID = CStr(readerDocumentLetterOfGoodStanding("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentLetterOfGoodStanding) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentLetterOfGoodStanding)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentLetterOfGoodStanding) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentLetterOfGoodStanding) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentLetterOfGoodStandingID) %>&ReviewTypeID=<% Response.Write(errorDocumentLetterOfGoodStandingReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentLetterOfGoodStandingErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeLetterOfGoodStanding" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeLetterOfGoodStanding" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeLetterOfGoodStanding" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentLetterOfGoodStanding" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerLetterOfGoodStanding" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerLetterOfGoodStanding" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerLetterOfGoodStanding" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusLetterOfGoodStanding" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateLetterOfGoodStanding" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix"> </div>
                                                <hr />
                                            </div>
                                            <div id="notice-to-vacate-notice-of-lease-termination">
                                                <h6>Notice to Vacate / Notice of Lease Termination
                                                     &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("74") Then
                                                                 Response.Write("<input type='checkbox' name='documentNoticeToVacateNoticeOfLeaseTermination' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentNoticeToVacateNoticeOfLeaseTermination' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentNoticeToVacateNoticeOfLeaseTermination' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                  <%
                                                    conn.Open()
                                                                 Dim errorDocumentNoticeToVacateNoticeOfLeaseTerminationErrorID As Integer
                                                                 Dim errorDocumentNoticeToVacateNoticeOfLeaseTerminationID As Integer
                                                                 Dim detailsDocumentNoticeToVacateNoticeOfLeaseTermination As String
                                                                 Dim noticeTypeDocumentNoticeToVacateNoticeOfLeaseTermination As String
                                                                 Dim statusDocumentNoticeToVacateNoticeOfLeaseTermination As String
                                                                 Dim errorStaffNameDocumentNoticeToVacateNoticeOfLeaseTermination As String
                                                                 Dim errorDocumentNoticeToVacateNoticeOfLeaseTerminationReviewTypeID As Integer
                                                      Dim errorsNoticeToVacateNoticeOfLeaseTerminationList As New ArrayList
                                                      Dim processDocumentNoticeToVacateNoticeOfLeaseTerminationErrorID As Integer
                                                        
                                                     Dim queryDocumentNoticeToVacateNoticeOfLeaseTerminationError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '74' AND fk_FileID = '" & fileID & "'", conn)
                                                                 Dim readerDocumentNoticeToVacateNoticeOfLeaseTerminationError As SqlDataReader = queryDocumentNoticeToVacateNoticeOfLeaseTerminationError.ExecuteReader()
                                                                 If readerDocumentNoticeToVacateNoticeOfLeaseTerminationError.HasRows Then
                                                                     While readerDocumentNoticeToVacateNoticeOfLeaseTerminationError.Read
                                                                         errorDocumentNoticeToVacateNoticeOfLeaseTerminationErrorID = CStr(readerDocumentNoticeToVacateNoticeOfLeaseTerminationError("fk_ErrorID"))
                                                                         errorsNoticeToVacateNoticeOfLeaseTerminationList.Add(errorDocumentNoticeToVacateNoticeOfLeaseTerminationErrorID)
                                                                     End While
                                                                 End If
                                                                 conn.Close()
                                           
                                                                 conn.Open()
                                                                 Dim errorNoticeToVacateNoticeOfLeaseTerminationIndex As Integer
                                                                 For Each errorNoticeToVacateNoticeOfLeaseTerminationIndex In errorsNoticeToVacateNoticeOfLeaseTerminationList
                                                          Dim queryDocumentNoticeToVacateNoticeOfLeaseTermination As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorNoticeToVacateNoticeOfLeaseTerminationIndex & "'", conn)
                                                                     Dim readerDocumentNoticeToVacateNoticeOfLeaseTermination As SqlDataReader = queryDocumentNoticeToVacateNoticeOfLeaseTermination.ExecuteReader()
                                                                     While readerDocumentNoticeToVacateNoticeOfLeaseTermination.Read
                                                                         errorDocumentNoticeToVacateNoticeOfLeaseTerminationID = CStr(readerDocumentNoticeToVacateNoticeOfLeaseTermination("ErrorID"))
                                                                         detailsDocumentNoticeToVacateNoticeOfLeaseTermination = CStr(readerDocumentNoticeToVacateNoticeOfLeaseTermination("Details"))
                                                                         noticeTypeDocumentNoticeToVacateNoticeOfLeaseTermination = CStr(readerDocumentNoticeToVacateNoticeOfLeaseTermination("Notice"))
                                                                         statusDocumentNoticeToVacateNoticeOfLeaseTermination = CStr(readerDocumentNoticeToVacateNoticeOfLeaseTermination("Status"))
                                                                         errorStaffNameDocumentNoticeToVacateNoticeOfLeaseTermination = CStr(readerDocumentNoticeToVacateNoticeOfLeaseTermination("ErrorStaffName"))
                                                              errorDocumentNoticeToVacateNoticeOfLeaseTerminationReviewTypeID = CStr(readerDocumentNoticeToVacateNoticeOfLeaseTermination("fk_ReviewTypeID"))
                                                              processDocumentNoticeToVacateNoticeOfLeaseTerminationErrorID = CStr(readerDocumentNoticeToVacateNoticeOfLeaseTermination("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentNoticeToVacateNoticeOfLeaseTermination) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentNoticeToVacateNoticeOfLeaseTermination)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentNoticeToVacateNoticeOfLeaseTermination) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentNoticeToVacateNoticeOfLeaseTermination) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentNoticeToVacateNoticeOfLeaseTerminationID) %>&ReviewTypeID=<% Response.Write(errorDocumentNoticeToVacateNoticeOfLeaseTerminationReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentNoticeToVacateNoticeOfLeaseTerminationErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeNoticeToVacateNoticeOfLeaseTermination" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeNoticeToVacateNoticeOfLeaseTermination" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeNoticeToVacateNoticeOfLeaseTermination" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentNoticeToVacateNoticeOfLeaseTermination" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerNoticeToVacateNoticeOfLeaseTermination" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerNoticeToVacateNoticeOfLeaseTermination" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerNoticeToVacateNoticeOfLeaseTermination" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusNoticeToVacateNoticeOfLeaseTermination" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateNoticeToVacateNoticeOfLeaseTermination" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix"></div>
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
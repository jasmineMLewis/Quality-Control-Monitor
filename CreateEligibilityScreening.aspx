<%@ Page Title="QC :: Screening" Language="vb" AutoEventWireup="false" MasterPageFile="~/FileDetails.master" CodeBehind="CreateEligibilityScreening.aspx.vb" Inherits="QualityControlMonitor.CreateEligibilityScreening" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="nestedContent" runat="server">
    <div class="row">
        <div class="col-lg-12 col-md-7">
            <div class="card">
                <div class="header">
                    <h4 class="title"><i class="fa fa-windows" aria-hidden="true">  </i> QC Review :: Eligibility & Screening</h4>
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
                             <asp:Button ID="btnCompleteReview" runat="server" class="btn btn-info btn-fill btn-wd" Text="Complete Eligibility & Screening Review" />
                          <%
                                Else
                          %>
                           <asp:Button ID="btnUpdateReview" runat="server" class="btn btn-warning btn-fill btn-wd" Text="Resubmit Eligibility & Screening Review" />
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
                                      <i class="fa fa-windows" aria-hidden="true"></i>  Eligibility/Screening
                                    </h4>
                                </div>
                                <div class="panel-body">
                                    <hr />
                                    <div id="verification">
                                        <h6>Verification 
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
                                                       SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
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
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
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
                                    <div id="occupancy-standard">
                                        <h6>Occupancy Standard &nbsp; &nbsp; &nbsp;
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
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
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
                                    <div id="eligibility-and-screening">
                                        <h6>Eligibility and Screening
                                            &nbsp; &nbsp; &nbsp;
                                            <%
                                                If processes.Count > 0 Then
                                                    If processes.Contains("11") Then
                                                        Response.Write("<input type='checkbox' name='processligibilityAndScreening' checked='checked' />")
                                                    Else
                                                        Response.Write("<input type='checkbox' name='processligibilityAndScreening' />")
                                                    End If
                                                Else
                                                    Response.Write("<input type='checkbox' name='processligibilityAndScreening' />")
                                                End If
                                             %>
                                        </h6>
                                        <br />
                                          <%
                                            conn.Open()
                                           Dim errorEligibilityAndScreeningID As Integer
                                           Dim detailsEligibilityAndScreening As String
                                           Dim noticeTypeEligibilityAndScreening As String
                                           Dim statusEligibilityAndScreening As String
                                           Dim errorStaffNameEligibilityAndScreening As String
                                              Dim errorReviewTypeIDEligibilityAndScreening As Integer
                                              Dim processEligibilityAndScreeningID As Integer
                                            
                                           Dim queryEligibilityAndScreening As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE fk_FileID = '" & fileID & "' AND fk_ProcessTypeID = 11 ORDER BY NoticeTypes.Notice", conn)
                                           Dim readerEligibilityAndScreening As SqlDataReader = queryEligibilityAndScreening.ExecuteReader()
                                           If readerEligibilityAndScreening.HasRows Then
                                               While readerEligibilityAndScreening.Read
                                                   errorEligibilityAndScreeningID = CStr(readerEligibilityAndScreening("ErrorID"))
                                                   detailsEligibilityAndScreening = CStr(readerEligibilityAndScreening("Details"))
                                                   noticeTypeEligibilityAndScreening = CStr(readerEligibilityAndScreening("Notice"))
                                                   statusEligibilityAndScreening = CStr(readerEligibilityAndScreening("Status"))
                                                   errorStaffNameEligibilityAndScreening = CStr(readerEligibilityAndScreening("ErrorStaffName"))
                                                      errorReviewTypeIDEligibilityAndScreening = CStr(readerEligibilityAndScreening("fk_ReviewTypeID"))
                                                      processEligibilityAndScreeningID = CStr(readerEligibilityAndScreening("fk_ProcessTypeID"))
                                             %>
                                               <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeEligibilityAndScreening) %>" type="text" />
                                                 </div>
                                               </div>
                                               <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                 <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsEligibilityAndScreening)%></textarea>
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameEligibilityAndScreening) %>" type="text" />
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusEligibilityAndScreening) %>"  type="text" />
                                                </div>
                                               </div>
                                               <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorEligibilityAndScreeningID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDEligibilityAndScreening) %>&ProcessTypeID=<% Response.Write(processEligibilityAndScreeningID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                  <asp:DropDownList ID="NoticeTypeEligibilityAndScreening" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeEligibilityAndScreening" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeEligibilityAndScreening" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <textarea class="form-control border-input" cols="4" name="commentEligibilityAndScreening" placeholder="Comment"
                                                    rows="1"></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                  <asp:DropDownList ID="CaseManagerEligibilityAndScreening" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerEligibilityAndScreening" DataValueField="UserID" DataTextField="FullName" required="required"></asp:DropDownList>
                                                  <asp:SqlDataSource ID="SqlCaseManagerEligibilityAndScreening" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                 </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="StatusEligibilityAndScreening" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="text-center">
                                            <asp:Button ID="btnCreateProcessEligibilityAndScreening" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                        </div>
                                        <div class="clearfix"> </div>
                                        <hr />
                                    </div>
                                    <div id="data-entry">
                                        <h6> Data Entry
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
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
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
                                    <div id="other">
                                        <h6>Other
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
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
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
                                        <div class="clearfix">
                                        </div>
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
                                                aria-expanded="true" aria-controls="collapseOne"><i class="fa fa-shield" aria-hidden="true"></i> Master Documents </a>
                                        </h4>
                                    </div>
                                    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="panel-body">
                                            <hr />
                                            <div id="master-family-documents-checklist ">
                                                <h6> Master Family Documents Checklist
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
                                                            If documents.Contains("8") Then
                                                                Response.Write("<input type='checkbox' name='documentMasterFamilyDocumentsChecklist' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentMasterFamilyDocumentsChecklist' />")
                                                            End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentMasterFamilyDocumentsChecklist' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                               <%
                                                   conn.Open()
                                                   Dim errorDocumentMasterFamilyDocumentsChecklistErrorID As Integer
                                                   Dim errorDocumentMasterFamilyDocumentsChecklistID As Integer
                                                   Dim detailsDocumentMasterFamilyDocumentsChecklist As String
                                                   Dim noticeTypeDocumentMasterFamilyDocumentsChecklist As String
                                                   Dim statusDocumentMasterFamilyDocumentsChecklist As String
                                                   Dim errorStaffNameDocumentMasterFamilyDocumentsChecklist As String
                                                   Dim errorDocumentMasterFamilyDocumentsChecklistReviewTypeID As Integer
                                                   Dim errorsMasterFamilyDocumentsChecklistList As New ArrayList
                                                   Dim processMasterFamilyDocumentsChecklistID As Integer
                                                        
                                                    Dim queryDocumentMasterFamilyDocumentsChecklistError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '8' AND fk_FileID = '" & fileID & "'", conn)
                                                   Dim readerDocumentMasterFamilyDocumentsChecklistError As SqlDataReader = queryDocumentMasterFamilyDocumentsChecklistError.ExecuteReader()
                                                   If readerDocumentMasterFamilyDocumentsChecklistError.HasRows Then
                                                       While readerDocumentMasterFamilyDocumentsChecklistError.Read
                                                           errorDocumentMasterFamilyDocumentsChecklistErrorID = CStr(readerDocumentMasterFamilyDocumentsChecklistError("fk_ErrorID"))
                                                           errorsMasterFamilyDocumentsChecklistList.Add(errorDocumentMasterFamilyDocumentsChecklistErrorID)
                                                       End While
                                                   End If
                                                   conn.Close()
                                           
                                                   conn.Open()
                                                   Dim errorMasterFamilyDocumentsChecklistIndex As Integer
                                                   For Each errorMasterFamilyDocumentsChecklistIndex In errorsMasterFamilyDocumentsChecklistList
                                                       Dim queryDocumentMasterFamilyDocumentsChecklist As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorMasterFamilyDocumentsChecklistIndex & "'", conn)
                                                       Dim readerDocumentMasterFamilyDocumentsChecklist As SqlDataReader = queryDocumentMasterFamilyDocumentsChecklist.ExecuteReader()
                                                       While readerDocumentMasterFamilyDocumentsChecklist.Read
                                                           errorDocumentMasterFamilyDocumentsChecklistID = CStr(readerDocumentMasterFamilyDocumentsChecklist("ErrorID"))
                                                           detailsDocumentMasterFamilyDocumentsChecklist = CStr(readerDocumentMasterFamilyDocumentsChecklist("Details"))
                                                           noticeTypeDocumentMasterFamilyDocumentsChecklist = CStr(readerDocumentMasterFamilyDocumentsChecklist("Notice"))
                                                           statusDocumentMasterFamilyDocumentsChecklist = CStr(readerDocumentMasterFamilyDocumentsChecklist("Status"))
                                                           errorStaffNameDocumentMasterFamilyDocumentsChecklist = CStr(readerDocumentMasterFamilyDocumentsChecklist("ErrorStaffName"))
                                                           errorDocumentMasterFamilyDocumentsChecklistReviewTypeID = CStr(readerDocumentMasterFamilyDocumentsChecklist("fk_ReviewTypeID"))
                                                           processMasterFamilyDocumentsChecklistID = CStr(readerDocumentMasterFamilyDocumentsChecklist("fk_ProcessTypeID"))
                                                           %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentMasterFamilyDocumentsChecklist) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentMasterFamilyDocumentsChecklist)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentMasterFamilyDocumentsChecklist) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentMasterFamilyDocumentsChecklist) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentMasterFamilyDocumentsChecklistID) %>&ReviewTypeID=<% Response.Write(errorDocumentMasterFamilyDocumentsChecklistReviewTypeID) %>&ProcessTypeID=<% Response.Write(processMasterFamilyDocumentsChecklistID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeMasterFamilyDocumentsChecklist" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeMasterFamilyDocumentsChecklist" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeMasterFamilyDocumentsChecklist" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentMasterFamilyDocumentsChecklist" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerMasterFamilyDocumentsChecklist" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerMasterFamilyDocumentsChecklist" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerMasterFamilyDocumentsChecklist" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusMasterFamilyDocumentsChecklist" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateMasterFamilyDocumentsChecklist" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix"></div>
                                                <hr />
                                            </div>
                                            <div id="new-admission-checklist">
                                                <h6>New Admission Checklist &nbsp; &nbsp; &nbsp;
                                                 <%
                                                        If documents.Count > 0 Then
                                                         If documents.Contains("9") Then
                                                             Response.Write("<input type='checkbox' name='documentNewAdmissionChecklist' checked='checked' />")
                                                         Else
                                                             Response.Write("<input type='checkbox' name='documentNewAdmissionChecklist' />")
                                                         End If
                                                        Else
                                                         Response.Write("<input type='checkbox' name='documentNewAdmissionChecklist' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                 <%
                                                    conn.Open()
                                                     Dim errorDocumentNewAdmissionChecklistErrorID As Integer
                                                     Dim errorDocumentNewAdmissionChecklistID As Integer
                                                     Dim detailsDocumentNewAdmissionChecklist As String
                                                     Dim noticeTypeDocumentNewAdmissionChecklist As String
                                                     Dim statusDocumentNewAdmissionChecklist As String
                                                     Dim errorStaffNameDocumentNewAdmissionChecklist As String
                                                     Dim errorDocumentNewAdmissionChecklistReviewTypeID As Integer
                                                     Dim errorsNewAdmissionChecklistList As New ArrayList
                                                     Dim processNewAdmissionChecklistID As Integer
                                                        
                                                    Dim queryDocumentNewAdmissionChecklistError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '9' AND fk_FileID = '" & fileID & "'", conn)
                                                     Dim readerDocumentNewAdmissionChecklistError As SqlDataReader = queryDocumentNewAdmissionChecklistError.ExecuteReader()
                                                     If readerDocumentNewAdmissionChecklistError.HasRows Then
                                                         While readerDocumentNewAdmissionChecklistError.Read
                                                             errorDocumentNewAdmissionChecklistErrorID = CStr(readerDocumentNewAdmissionChecklistError("fk_ErrorID"))
                                                             errorsNewAdmissionChecklistList.Add(errorDocumentNewAdmissionChecklistErrorID)
                                                         End While
                                                     End If
                                                     conn.Close()
                                           
                                                     conn.Open()
                                                     Dim errorNewAdmissionChecklistIndex As Integer
                                                     For Each errorNewAdmissionChecklistIndex In errorsNewAdmissionChecklistList
                                                         Dim queryDocumentNewAdmissionChecklist As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorNewAdmissionChecklistIndex & "'", conn)
                                                         Dim readerDocumentNewAdmissionChecklist As SqlDataReader = queryDocumentNewAdmissionChecklist.ExecuteReader()
                                                         While readerDocumentNewAdmissionChecklist.Read
                                                             errorDocumentNewAdmissionChecklistID = CStr(readerDocumentNewAdmissionChecklist("ErrorID"))
                                                             detailsDocumentNewAdmissionChecklist = CStr(readerDocumentNewAdmissionChecklist("Details"))
                                                             noticeTypeDocumentNewAdmissionChecklist = CStr(readerDocumentNewAdmissionChecklist("Notice"))
                                                             statusDocumentNewAdmissionChecklist = CStr(readerDocumentNewAdmissionChecklist("Status"))
                                                             errorStaffNameDocumentNewAdmissionChecklist = CStr(readerDocumentNewAdmissionChecklist("ErrorStaffName"))
                                                             errorDocumentNewAdmissionChecklistReviewTypeID = CStr(readerDocumentNewAdmissionChecklist("fk_ReviewTypeID"))
                                                             processNewAdmissionChecklistID =  CStr(readerDocumentNewAdmissionChecklist("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentNewAdmissionChecklist) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentNewAdmissionChecklist)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentNewAdmissionChecklist) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentNewAdmissionChecklist) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentNewAdmissionChecklistID) %>&ReviewTypeID=<% Response.Write(errorDocumentNewAdmissionChecklistReviewTypeID) %>&ProcessTypeID=<% Response.Write(processNewAdmissionChecklistID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeNewAdmissionChecklist" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeNewAdmissionChecklist" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeNewAdmissionChecklist" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentNewAdmissionChecklist" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerNewAdmissionChecklist" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerNewAdmissionChecklist" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerNewAdmissionChecklist" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusNewAdmissionChecklist" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateNewAdmissionChecklist" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="valid-photo-identification">
                                                <h6> Valid Photo Identification
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("10") Then
                                                                Response.Write("<input type='checkbox' name='documentValidPhotoIdentification' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentValidPhotoIdentification' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentValidPhotoIdentification' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                   <%
                                                    conn.Open()
                                                                 Dim errorDocumentValidPhotoIdentificationErrorID As Integer
                                                                 Dim errorDocumentValidPhotoIdentificationID As Integer
                                                                 Dim detailsDocumentValidPhotoIdentification As String
                                                                 Dim noticeTypeDocumentValidPhotoIdentification As String
                                                                 Dim statusDocumentValidPhotoIdentification As String
                                                                 Dim errorStaffNameDocumentValidPhotoIdentification As String
                                                                 Dim errorDocumentValidPhotoIdentificationReviewTypeID As Integer
                                                       Dim errorsValidPhotoIdentificationList As New ArrayList
                                                       Dim processValidPhotoIdentificationID As Integer
                                                        
                                                    Dim queryDocumentValidPhotoIdentificationError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '10' AND fk_FileID = '" & fileID & "'", conn)
                                                                 Dim readerDocumentValidPhotoIdentificationError As SqlDataReader = queryDocumentValidPhotoIdentificationError.ExecuteReader()
                                                                 If readerDocumentValidPhotoIdentificationError.HasRows Then
                                                                     While readerDocumentValidPhotoIdentificationError.Read
                                                                         errorDocumentValidPhotoIdentificationErrorID = CStr(readerDocumentValidPhotoIdentificationError("fk_ErrorID"))
                                                                         errorsValidPhotoIdentificationList.Add(errorDocumentValidPhotoIdentificationErrorID)
                                                                     End While
                                                                 End If
                                                                 conn.Close()
                                           
                                                                 conn.Open()
                                                                 Dim errorValidPhotoIdentificationIndex As Integer
                                                                 For Each errorValidPhotoIdentificationIndex In errorsValidPhotoIdentificationList
                                                                     Dim queryDocumentValidPhotoIdentification As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorValidPhotoIdentificationIndex & "'", conn)
                                                                     Dim readerDocumentValidPhotoIdentification As SqlDataReader = queryDocumentValidPhotoIdentification.ExecuteReader()
                                                                     While readerDocumentValidPhotoIdentification.Read
                                                                         errorDocumentValidPhotoIdentificationID = CStr(readerDocumentValidPhotoIdentification("ErrorID"))
                                                                         detailsDocumentValidPhotoIdentification = CStr(readerDocumentValidPhotoIdentification("Details"))
                                                                         noticeTypeDocumentValidPhotoIdentification = CStr(readerDocumentValidPhotoIdentification("Notice"))
                                                                         statusDocumentValidPhotoIdentification = CStr(readerDocumentValidPhotoIdentification("Status"))
                                                                         errorStaffNameDocumentValidPhotoIdentification = CStr(readerDocumentValidPhotoIdentification("ErrorStaffName"))
                                                               errorDocumentValidPhotoIdentificationReviewTypeID = CStr(readerDocumentValidPhotoIdentification("fk_ReviewTypeID"))
                                                                processValidPhotoIdentificationID = CStr(readerDocumentValidPhotoIdentification("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentValidPhotoIdentification) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentValidPhotoIdentification)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentValidPhotoIdentification) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentValidPhotoIdentification) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentValidPhotoIdentificationID) %>&ReviewTypeID=<% Response.Write(errorDocumentValidPhotoIdentificationReviewTypeID) %>&ProcessTypeID=<% Response.Write(processValidPhotoIdentificationID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeValidPhotoIdentification" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeValidPhotoIdentification" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeValidPhotoIdentification" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentValidPhotoIdentification" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerValidPhotoIdentification" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerValidPhotoIdentification" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerValidPhotoIdentification" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusValidPhotoIdentification" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateValidPhotoIdentification" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="proof-of-social-security-number">
                                                <h6>Proof of Social Security Number 
                                                    &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("11") Then
                                                                Response.Write("<input type='checkbox' name='documentProofOfSocialSecurityNumber' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentProofOfSocialSecurityNumber' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentProofOfSocialSecurityNumber' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                            <%
                                                conn.Open()
                                                Dim errorDocumentProofOfSocialSecurityNumberErrorID As Integer
                                                Dim errorDocumentProofOfSocialSecurityNumberID As Integer
                                                Dim detailsDocumentProofOfSocialSecurityNumber As String
                                                Dim noticeTypeDocumentProofOfSocialSecurityNumber As String
                                                Dim statusDocumentProofOfSocialSecurityNumber As String
                                                Dim errorStaffNameDocumentProofOfSocialSecurityNumber As String
                                                Dim errorDocumentProofOfSocialSecurityNumberReviewTypeID As Integer
                                                Dim errorsProofOfSocialSecurityNumberList As New ArrayList
                                                Dim processProofOfSocialSecurityNumberID As Integer
                                                        
                                                Dim queryDocumentProofOfSocialSecurityNumberError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '11' AND fk_FileID = '" & fileID & "'", conn)
                                                Dim readerDocumentProofOfSocialSecurityNumberError As SqlDataReader = queryDocumentProofOfSocialSecurityNumberError.ExecuteReader()
                                                If readerDocumentProofOfSocialSecurityNumberError.HasRows Then
                                                    While readerDocumentProofOfSocialSecurityNumberError.Read
                                                        errorDocumentProofOfSocialSecurityNumberErrorID = CStr(readerDocumentProofOfSocialSecurityNumberError("fk_ErrorID"))
                                                        errorsProofOfSocialSecurityNumberList.Add(errorDocumentProofOfSocialSecurityNumberErrorID)
                                                    End While
                                                End If
                                                conn.Close()
                                           
                                                conn.Open()
                                                Dim errorProofOfSocialSecurityNumberIndex As Integer
                                                For Each errorProofOfSocialSecurityNumberIndex In errorsProofOfSocialSecurityNumberList
                                                    Dim queryDocumentProofOfSocialSecurityNumber As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorProofOfSocialSecurityNumberIndex & "'", conn)
                                                    Dim readerDocumentProofOfSocialSecurityNumber As SqlDataReader = queryDocumentProofOfSocialSecurityNumber.ExecuteReader()
                                                    While readerDocumentProofOfSocialSecurityNumber.Read
                                                        errorDocumentProofOfSocialSecurityNumberID = CStr(readerDocumentProofOfSocialSecurityNumber("ErrorID"))
                                                        detailsDocumentProofOfSocialSecurityNumber = CStr(readerDocumentProofOfSocialSecurityNumber("Details"))
                                                        noticeTypeDocumentProofOfSocialSecurityNumber = CStr(readerDocumentProofOfSocialSecurityNumber("Notice"))
                                                        statusDocumentProofOfSocialSecurityNumber = CStr(readerDocumentProofOfSocialSecurityNumber("Status"))
                                                        errorStaffNameDocumentProofOfSocialSecurityNumber = CStr(readerDocumentProofOfSocialSecurityNumber("ErrorStaffName"))
                                                        errorDocumentProofOfSocialSecurityNumberReviewTypeID = CStr(readerDocumentProofOfSocialSecurityNumber("fk_ReviewTypeID"))
                                                           processProofOfSocialSecurityNumberID = CStr(readerDocumentProofOfSocialSecurityNumber("fk_ProcessTypeID"))
                                                        %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentProofOfSocialSecurityNumber) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentProofOfSocialSecurityNumber)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentProofOfSocialSecurityNumber) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentProofOfSocialSecurityNumber) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentProofOfSocialSecurityNumberID) %>&ReviewTypeID=<% Response.Write(errorDocumentProofOfSocialSecurityNumberReviewTypeID) %>&ProcessTypeID=<% Response.Write(processProofOfSocialSecurityNumberID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeProofOfSocialSecurityNumber" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeProofOfSocialSecurityNumber" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeProofOfSocialSecurityNumber" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentProofOfSocialSecurityNumber" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerProofOfSocialSecurityNumber" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerProofOfSocialSecurityNumber" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerProofOfSocialSecurityNumber" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusProofOfSocialSecurityNumber" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateProofOfSocialSecurityNumber" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="proof-of-birth-date">
                                                <h6>   Proof of Birth Date 
                                                        &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                              If documents.Contains("12") Then
                                                                  Response.Write("<input type='checkbox' name='documentProofOfBirthDate' checked='checked' />")
                                                              Else
                                                                  Response.Write("<input type='checkbox' name='documentProofOfBirthDate' />")
                                                              End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentProofOfBirthDate' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                   <%
                                                    conn.Open()
                                                       Dim errorDocumentProofOfBirthDateErrorID As Integer
                                                       Dim errorDocumentProofOfBirthDateID As Integer
                                                       Dim detailsDocumentProofOfBirthDate As String
                                                       Dim noticeTypeDocumentProofOfBirthDate As String
                                                       Dim statusDocumentProofOfBirthDate As String
                                                       Dim errorStaffNameDocumentProofOfBirthDate As String
                                                       Dim errorDocumentProofOfBirthDateReviewTypeID As Integer
                                                       Dim errorsProofOfBirthDateList As New ArrayList
                                                       Dim processProofOfBirthDateID As Integer
                                                        
                                                       Dim queryDocumentProofOfBirthDateError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '12' AND fk_FileID = '" & fileID & "'", conn)
                                                       Dim readerDocumentProofOfBirthDateError As SqlDataReader = queryDocumentProofOfBirthDateError.ExecuteReader()
                                                       If readerDocumentProofOfBirthDateError.HasRows Then
                                                           While readerDocumentProofOfBirthDateError.Read
                                                               errorDocumentProofOfBirthDateErrorID = CStr(readerDocumentProofOfBirthDateError("fk_ErrorID"))
                                                               errorsProofOfBirthDateList.Add(errorDocumentProofOfBirthDateErrorID)
                                                           End While
                                                       End If
                                                       conn.Close()
                                           
                                                                 conn.Open()
                                                       Dim errorProofOfBirthDateIndex As Integer
                                                       For Each errorProofOfBirthDateIndex In errorsProofOfBirthDateList
                                                           Dim queryDocumentProofOfBirthDate As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorProofOfBirthDateIndex & "'", conn)
                                                           Dim readerDocumentProofOfBirthDate As SqlDataReader = queryDocumentProofOfBirthDate.ExecuteReader()
                                                           While readerDocumentProofOfBirthDate.Read
                                                               errorDocumentProofOfBirthDateID = CStr(readerDocumentProofOfBirthDate("ErrorID"))
                                                               detailsDocumentProofOfBirthDate = CStr(readerDocumentProofOfBirthDate("Details"))
                                                               noticeTypeDocumentProofOfBirthDate = CStr(readerDocumentProofOfBirthDate("Notice"))
                                                               statusDocumentProofOfBirthDate = CStr(readerDocumentProofOfBirthDate("Status"))
                                                               errorStaffNameDocumentProofOfBirthDate = CStr(readerDocumentProofOfBirthDate("ErrorStaffName"))
                                                               errorDocumentProofOfBirthDateReviewTypeID = CStr(readerDocumentProofOfBirthDate("fk_ReviewTypeID"))
                                                              processProofOfBirthDateID = CStr(readerDocumentProofOfBirthDate("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentProofOfBirthDate) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentProofOfBirthDate)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentProofOfBirthDate) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentProofOfBirthDate) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentProofOfBirthDateID) %>&ReviewTypeID=<% Response.Write(errorDocumentProofOfBirthDateReviewTypeID) %>&ProcessTypeID=<% Response.Write(processProofOfBirthDateID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeProofOfBirthDate" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeProofOfBirthDate" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeProofOfBirthDate" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentProofOfBirthDate" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerProofOfBirthDate" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerProofOfBirthDate" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerProofOfBirthDate" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusProofOfBirthDate" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateProofOfBirthDate" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="proof-of-name-change">
                                                <h6> Proof of Name Change (If applicable)
                                                    &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("13") Then
                                                                 Response.Write("<input type='checkbox' name='documentProofOfNameChangeIfApplicable' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentProofOfNameChangeIfApplicable' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentProofOfNameChangeIfApplicable' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                  <%
                                                    conn.Open()
                                                      Dim errorDocumentProofOfNameChangeIfApplicableErrorID As Integer
                                                      Dim errorDocumentProofOfNameChangeIfApplicableID As Integer
                                                                 Dim detailsDocumentProofOfNameChangeIfApplicable As String
                                                                 Dim noticeTypeDocumentProofOfNameChangeIfApplicable As String
                                                                 Dim statusDocumentProofOfNameChangeIfApplicable As String
                                                                 Dim errorStaffNameDocumentProofOfNameChangeIfApplicable As String
                                                                 Dim errorDocumentProofOfNameChangeIfApplicableReviewTypeID As Integer
                                                      Dim errorsProofOfNameChangeIfApplicableList As New ArrayList
                                                      Dim processProofOfNameChangeIfApplicableID As Integer
                                                        
                                                      Dim queryDocumentProofOfNameChangeIfApplicableError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '13' AND fk_FileID = '" & fileID & "'", conn)
                                                                 Dim readerDocumentProofOfNameChangeIfApplicableError As SqlDataReader = queryDocumentProofOfNameChangeIfApplicableError.ExecuteReader()
                                                                 If readerDocumentProofOfNameChangeIfApplicableError.HasRows Then
                                                                     While readerDocumentProofOfNameChangeIfApplicableError.Read
                                                                         errorDocumentProofOfNameChangeIfApplicableErrorID = CStr(readerDocumentProofOfNameChangeIfApplicableError("fk_ErrorID"))
                                                                         errorsProofOfNameChangeIfApplicableList.Add(errorDocumentProofOfNameChangeIfApplicableErrorID)
                                                                     End While
                                                                 End If
                                                                 conn.Close()
                                           
                                                                 conn.Open()
                                                                 Dim errorProofOfNameChangeIfApplicableIndex As Integer
                                                                 For Each errorProofOfNameChangeIfApplicableIndex In errorsProofOfNameChangeIfApplicableList
                                                                     Dim queryDocumentProofOfNameChangeIfApplicable As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorProofOfNameChangeIfApplicableIndex & "'", conn)
                                                                     Dim readerDocumentProofOfNameChangeIfApplicable As SqlDataReader = queryDocumentProofOfNameChangeIfApplicable.ExecuteReader()
                                                                     While readerDocumentProofOfNameChangeIfApplicable.Read
                                                                         errorDocumentProofOfNameChangeIfApplicableID = CStr(readerDocumentProofOfNameChangeIfApplicable("ErrorID"))
                                                                         detailsDocumentProofOfNameChangeIfApplicable = CStr(readerDocumentProofOfNameChangeIfApplicable("Details"))
                                                                         noticeTypeDocumentProofOfNameChangeIfApplicable = CStr(readerDocumentProofOfNameChangeIfApplicable("Notice"))
                                                                         statusDocumentProofOfNameChangeIfApplicable = CStr(readerDocumentProofOfNameChangeIfApplicable("Status"))
                                                                         errorStaffNameDocumentProofOfNameChangeIfApplicable = CStr(readerDocumentProofOfNameChangeIfApplicable("ErrorStaffName"))
                                                              errorDocumentProofOfNameChangeIfApplicableReviewTypeID = CStr(readerDocumentProofOfNameChangeIfApplicable("fk_ReviewTypeID"))
                                                              processProofOfNameChangeIfApplicableID = CStr(readerDocumentProofOfNameChangeIfApplicable("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentProofOfNameChangeIfApplicable) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentProofOfNameChangeIfApplicable)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentProofOfNameChangeIfApplicable) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentProofOfNameChangeIfApplicable) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentProofOfNameChangeIfApplicableID) %>&ReviewTypeID=<% Response.Write(errorDocumentProofOfNameChangeIfApplicableReviewTypeID) %>&ProcessTypeID=<% Response.Write(processProofOfNameChangeIfApplicableID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeProofOfNameChangeIfApplicable" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeProofOfNameChangeIfApplicable" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeProofOfNameChangeIfApplicable" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentProofOfNameChangeIfApplicable" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerProofOfNameChangeIfApplicable" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerProofOfNameChangeIfApplicable" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerProofOfNameChangeIfApplicable" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusProofOfNameChangeIfApplicable" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateProofOfNameChangeIfApplicable" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="proof-of-eligible-immigration-status">
                                                <h6>Proof of Eligible Immigration Status 
                                                    &nbsp; &nbsp; &nbsp;
                                                   <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("14") Then
                                                                 Response.Write("<input type='checkbox' name='documentProofOfEligibleImmigrationStatus' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentProofOfEligibleImmigrationStatus' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentProofOfEligibleImmigrationStatus' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                    <%
                                                    conn.Open()
                                                                 Dim errorDocumentProofOfEligibleImmigrationStatusErrorID As Integer
                                                                 Dim errorDocumentProofOfEligibleImmigrationStatusID As Integer
                                                                 Dim detailsDocumentProofOfEligibleImmigrationStatus As String
                                                                 Dim noticeTypeDocumentProofOfEligibleImmigrationStatus As String
                                                                 Dim statusDocumentProofOfEligibleImmigrationStatus As String
                                                                 Dim errorStaffNameDocumentProofOfEligibleImmigrationStatus As String
                                                                 Dim errorDocumentProofOfEligibleImmigrationStatusReviewTypeID As Integer
                                                        Dim errorsProofOfEligibleImmigrationStatusList As New ArrayList
                                                        Dim processProofOfEligibleImmigrationStatusID As Integer
                                                        
                                                    Dim queryDocumentProofOfEligibleImmigrationStatusError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '14' AND fk_FileID = '" & fileID & "'", conn)
                                                                 Dim readerDocumentProofOfEligibleImmigrationStatusError As SqlDataReader = queryDocumentProofOfEligibleImmigrationStatusError.ExecuteReader()
                                                                 If readerDocumentProofOfEligibleImmigrationStatusError.HasRows Then
                                                                     While readerDocumentProofOfEligibleImmigrationStatusError.Read
                                                                         errorDocumentProofOfEligibleImmigrationStatusErrorID = CStr(readerDocumentProofOfEligibleImmigrationStatusError("fk_ErrorID"))
                                                                         errorsProofOfEligibleImmigrationStatusList.Add(errorDocumentProofOfEligibleImmigrationStatusErrorID)
                                                                     End While
                                                                 End If
                                                                 conn.Close()
                                           
                                                                 conn.Open()
                                                                 Dim errorProofOfEligibleImmigrationStatusIndex As Integer
                                                                 For Each errorProofOfEligibleImmigrationStatusIndex In errorsProofOfEligibleImmigrationStatusList
                                                            Dim queryDocumentProofOfEligibleImmigrationStatus As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorProofOfEligibleImmigrationStatusIndex & "'", conn)
                                                                     Dim readerDocumentProofOfEligibleImmigrationStatus As SqlDataReader = queryDocumentProofOfEligibleImmigrationStatus.ExecuteReader()
                                                                     While readerDocumentProofOfEligibleImmigrationStatus.Read
                                                                         errorDocumentProofOfEligibleImmigrationStatusID = CStr(readerDocumentProofOfEligibleImmigrationStatus("ErrorID"))
                                                                         detailsDocumentProofOfEligibleImmigrationStatus = CStr(readerDocumentProofOfEligibleImmigrationStatus("Details"))
                                                                         noticeTypeDocumentProofOfEligibleImmigrationStatus = CStr(readerDocumentProofOfEligibleImmigrationStatus("Notice"))
                                                                         statusDocumentProofOfEligibleImmigrationStatus = CStr(readerDocumentProofOfEligibleImmigrationStatus("Status"))
                                                                         errorStaffNameDocumentProofOfEligibleImmigrationStatus = CStr(readerDocumentProofOfEligibleImmigrationStatus("ErrorStaffName"))
                                                                errorDocumentProofOfEligibleImmigrationStatusReviewTypeID = CStr(readerDocumentProofOfEligibleImmigrationStatus("fk_ReviewTypeID"))
                                                                processProofOfEligibleImmigrationStatusID = CStr(readerDocumentProofOfEligibleImmigrationStatus("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentProofOfEligibleImmigrationStatus) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentProofOfEligibleImmigrationStatus)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentProofOfEligibleImmigrationStatus) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentProofOfEligibleImmigrationStatus) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentProofOfEligibleImmigrationStatusID) %>&ReviewTypeID=<% Response.Write(errorDocumentProofOfEligibleImmigrationStatusReviewTypeID) %>&ProcessTypeID=<% Response.Write(processProofOfEligibleImmigrationStatusID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeProofOfEligibleImmigrationStatus" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeProofOfEligibleImmigrationStatus" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeProofOfEligibleImmigrationStatus" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentProofOfEligibleImmigrationStatus" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerProofOfEligibleImmigrationStatus" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerProofOfEligibleImmigrationStatus" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerProofOfEligibleImmigrationStatus" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusProofOfEligibleImmigrationStatus" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateProofOfEligibleImmigrationStatus" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="declaration-of-citizenship-or-eligible-immigration-status">
                                                <h6>Declaration of Citizenship or Eligible Immigration Status
                                                     &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                              If documents.Contains("54") Then
                                                                  Response.Write("<input type='checkbox' name='documentDeclarationOfCitizenshipOrEligibleImmigrationStatus' checked='checked' />")
                                                              Else
                                                                  Response.Write("<input type='checkbox' name='documentDeclarationOfCitizenshipOrEligibleImmigrationStatus' />")
                                                              End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentDeclarationOfCitizenshipOrEligibleImmigrationStatus' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                          <%
                                                    conn.Open()
                                                                 Dim errorDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatusErrorID As Integer
                                                                 Dim errorDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatusID As Integer
                                                                 Dim detailsDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus As String
                                                                 Dim noticeTypeDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus As String
                                                                 Dim statusDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus As String
                                                                 Dim errorStaffNameDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus As String
                                                                 Dim errorDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatusReviewTypeID As Integer
                                              Dim errorsDeclarationOfCitizenshipOrEligibleImmigrationStatusList As New ArrayList
                                              Dim processDeclarationOfCitizenshipOrEligibleImmigrationStatusID As Integer
                                                        
                                              Dim queryDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatusError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '54' AND fk_FileID = '" & fileID & "'", conn)
                                                                 Dim readerDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatusError As SqlDataReader = queryDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatusError.ExecuteReader()
                                                                 If readerDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatusError.HasRows Then
                                                                     While readerDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatusError.Read
                                                                         errorDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatusErrorID = CStr(readerDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatusError("fk_ErrorID"))
                                                                         errorsDeclarationOfCitizenshipOrEligibleImmigrationStatusList.Add(errorDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatusErrorID)
                                                                     End While
                                                                 End If
                                                                 conn.Close()
                                           
                                                                 conn.Open()
                                                                 Dim errorDeclarationOfCitizenshipOrEligibleImmigrationStatusIndex As Integer
                                                                 For Each errorDeclarationOfCitizenshipOrEligibleImmigrationStatusIndex In errorsDeclarationOfCitizenshipOrEligibleImmigrationStatusList
                                                                     Dim queryDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorDeclarationOfCitizenshipOrEligibleImmigrationStatusIndex & "'", conn)
                                                                     Dim readerDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus As SqlDataReader = queryDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus.ExecuteReader()
                                                                     While readerDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus.Read
                                                                         errorDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatusID = CStr(readerDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus("ErrorID"))
                                                                         detailsDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus = CStr(readerDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus("Details"))
                                                                         noticeTypeDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus = CStr(readerDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus("Notice"))
                                                                         statusDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus = CStr(readerDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus("Status"))
                                                                         errorStaffNameDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus = CStr(readerDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus("ErrorStaffName"))
                                                      errorDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatusReviewTypeID = CStr(readerDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus("fk_ReviewTypeID"))
                                                      processDeclarationOfCitizenshipOrEligibleImmigrationStatusID = CStr(readerDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatusID) %>&ReviewTypeID=<% Response.Write(errorDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatusReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDeclarationOfCitizenshipOrEligibleImmigrationStatusID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeDeclarationOfCitizenshipOrEligibleImmigrationStatus" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeDeclarationOfCitizenshipOrEligibleImmigrationStatus" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeDeclarationOfCitizenshipOrEligibleImmigrationStatus" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentDeclarationOfCitizenshipOrEligibleImmigrationStatus" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerDeclarationOfCitizenshipOrEligibleImmigrationStatus" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerDeclarationOfCitizenshipOrEligibleImmigrationStatus" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerDeclarationOfCitizenshipOrEligibleImmigrationStatus" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusDeclarationOfCitizenshipOrEligibleImmigrationStatus" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateDeclarationOfCitizenshipOrEligibleImmigrationStatus" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="criminal-background-screening-determination">
                                                <h6> Criminal Background Screening Determination (initial intake) 
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("15") Then
                                                                Response.Write("<input type='checkbox' name='documentCriminalBackgroundScreeningDeterminationInitialIntake' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentCriminalBackgroundScreeningDeterminationInitialIntake' />")
                                                            End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentCriminalBackgroundScreeningDeterminationInitialIntake' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                   <%
                                                    conn.Open()
                                                                 Dim errorDocumentCriminalBackgroundScreeningDeterminationInitialIntakeErrorID As Integer
                                                                 Dim errorDocumentCriminalBackgroundScreeningDeterminationInitialIntakeID As Integer
                                                                 Dim detailsDocumentCriminalBackgroundScreeningDeterminationInitialIntake As String
                                                                 Dim noticeTypeDocumentCriminalBackgroundScreeningDeterminationInitialIntake As String
                                                                 Dim statusDocumentCriminalBackgroundScreeningDeterminationInitialIntake As String
                                                                 Dim errorStaffNameDocumentCriminalBackgroundScreeningDeterminationInitialIntake As String
                                                                 Dim errorDocumentCriminalBackgroundScreeningDeterminationInitialIntakeReviewTypeID As Integer
                                                       Dim errorsCriminalBackgroundScreeningDeterminationInitialIntakeList As New ArrayList
                                                       Dim processDocumentCriminalBackgroundScreeningDeterminationInitialIntakeID As Integer
                                                        
                                                    Dim queryDocumentCriminalBackgroundScreeningDeterminationInitialIntakeError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '15' AND fk_FileID = '" & fileID & "'", conn)
                                                                 Dim readerDocumentCriminalBackgroundScreeningDeterminationInitialIntakeError As SqlDataReader = queryDocumentCriminalBackgroundScreeningDeterminationInitialIntakeError.ExecuteReader()
                                                                 If readerDocumentCriminalBackgroundScreeningDeterminationInitialIntakeError.HasRows Then
                                                                     While readerDocumentCriminalBackgroundScreeningDeterminationInitialIntakeError.Read
                                                                         errorDocumentCriminalBackgroundScreeningDeterminationInitialIntakeErrorID = CStr(readerDocumentCriminalBackgroundScreeningDeterminationInitialIntakeError("fk_ErrorID"))
                                                                         errorsCriminalBackgroundScreeningDeterminationInitialIntakeList.Add(errorDocumentCriminalBackgroundScreeningDeterminationInitialIntakeErrorID)
                                                                     End While
                                                                 End If
                                                                 conn.Close()
                                           
                                                                 conn.Open()
                                                                 Dim errorCriminalBackgroundScreeningDeterminationInitialIntakeIndex As Integer
                                                                 For Each errorCriminalBackgroundScreeningDeterminationInitialIntakeIndex In errorsCriminalBackgroundScreeningDeterminationInitialIntakeList
                                                                     Dim queryDocumentCriminalBackgroundScreeningDeterminationInitialIntake As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorCriminalBackgroundScreeningDeterminationInitialIntakeIndex & "'", conn)
                                                                     Dim readerDocumentCriminalBackgroundScreeningDeterminationInitialIntake As SqlDataReader = queryDocumentCriminalBackgroundScreeningDeterminationInitialIntake.ExecuteReader()
                                                                     While readerDocumentCriminalBackgroundScreeningDeterminationInitialIntake.Read
                                                                         errorDocumentCriminalBackgroundScreeningDeterminationInitialIntakeID = CStr(readerDocumentCriminalBackgroundScreeningDeterminationInitialIntake("ErrorID"))
                                                                         detailsDocumentCriminalBackgroundScreeningDeterminationInitialIntake = CStr(readerDocumentCriminalBackgroundScreeningDeterminationInitialIntake("Details"))
                                                                         noticeTypeDocumentCriminalBackgroundScreeningDeterminationInitialIntake = CStr(readerDocumentCriminalBackgroundScreeningDeterminationInitialIntake("Notice"))
                                                                         statusDocumentCriminalBackgroundScreeningDeterminationInitialIntake = CStr(readerDocumentCriminalBackgroundScreeningDeterminationInitialIntake("Status"))
                                                                         errorStaffNameDocumentCriminalBackgroundScreeningDeterminationInitialIntake = CStr(readerDocumentCriminalBackgroundScreeningDeterminationInitialIntake("ErrorStaffName"))
                                                               errorDocumentCriminalBackgroundScreeningDeterminationInitialIntakeReviewTypeID = CStr(readerDocumentCriminalBackgroundScreeningDeterminationInitialIntake("fk_ReviewTypeID"))
                                                               processDocumentCriminalBackgroundScreeningDeterminationInitialIntakeID = CStr(readerDocumentCriminalBackgroundScreeningDeterminationInitialIntake("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentCriminalBackgroundScreeningDeterminationInitialIntake) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentCriminalBackgroundScreeningDeterminationInitialIntake)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentCriminalBackgroundScreeningDeterminationInitialIntake) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentCriminalBackgroundScreeningDeterminationInitialIntake) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentCriminalBackgroundScreeningDeterminationInitialIntakeID) %>&ReviewTypeID=<% Response.Write(errorDocumentCriminalBackgroundScreeningDeterminationInitialIntakeReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentCriminalBackgroundScreeningDeterminationInitialIntakeID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeCriminalBackgroundScreeningDeterminationInitialIntake" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeCriminalBackgroundScreeningDeterminationInitialIntake" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeCriminalBackgroundScreeningDeterminationInitialIntake" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentCriminalBackgroundScreeningDeterminationInitialIntake" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerCriminalBackgroundScreeningDeterminationInitialIntake" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerCriminalBackgroundScreeningDeterminationInitialIntake" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerCriminalBackgroundScreeningDeterminationInitialIntake" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusCriminalBackgroundScreeningDeterminationInitialIntake" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateCriminalBackgroundScreeningDeterminationInitialIntake" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="criminal-background-screening-request ">
                                                <h6>Criminal Background Screening Request (initial intake)  
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("16") Then
                                                                Response.Write("<input type='checkbox' name='documentCriminalBackgroundScreeningRequestInitialIntake' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentCriminalBackgroundScreeningRequestInitialIntake' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentCriminalBackgroundScreeningRequestInitialIntake' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                    <%
                                                    conn.Open()
                                                                 Dim errorDocumentCriminalBackgroundScreeningRequestInitialIntakeErrorID As Integer
                                                                 Dim errorDocumentCriminalBackgroundScreeningRequestInitialIntakeID As Integer
                                                                 Dim detailsDocumentCriminalBackgroundScreeningRequestInitialIntake As String
                                                                 Dim noticeTypeDocumentCriminalBackgroundScreeningRequestInitialIntake As String
                                                                 Dim statusDocumentCriminalBackgroundScreeningRequestInitialIntake As String
                                                                 Dim errorStaffNameDocumentCriminalBackgroundScreeningRequestInitialIntake As String
                                                                 Dim errorDocumentCriminalBackgroundScreeningRequestInitialIntakeReviewTypeID As Integer
                                                        Dim errorsCriminalBackgroundScreeningRequestInitialIntakeList As New ArrayList
                                                        Dim processDocumentCriminalBackgroundScreeningRequestInitialIntakeID As Integer
                                                        
                                                    Dim queryDocumentCriminalBackgroundScreeningRequestInitialIntakeError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '16' AND fk_FileID = '" & fileID & "'", conn)
                                                                 Dim readerDocumentCriminalBackgroundScreeningRequestInitialIntakeError As SqlDataReader = queryDocumentCriminalBackgroundScreeningRequestInitialIntakeError.ExecuteReader()
                                                                 If readerDocumentCriminalBackgroundScreeningRequestInitialIntakeError.HasRows Then
                                                                     While readerDocumentCriminalBackgroundScreeningRequestInitialIntakeError.Read
                                                                         errorDocumentCriminalBackgroundScreeningRequestInitialIntakeErrorID = CStr(readerDocumentCriminalBackgroundScreeningRequestInitialIntakeError("fk_ErrorID"))
                                                                         errorsCriminalBackgroundScreeningRequestInitialIntakeList.Add(errorDocumentCriminalBackgroundScreeningRequestInitialIntakeErrorID)
                                                                     End While
                                                                 End If
                                                                 conn.Close()
                                           
                                                                 conn.Open()
                                                                 Dim errorCriminalBackgroundScreeningRequestInitialIntakeIndex As Integer
                                                                 For Each errorCriminalBackgroundScreeningRequestInitialIntakeIndex In errorsCriminalBackgroundScreeningRequestInitialIntakeList
                                                            Dim queryDocumentCriminalBackgroundScreeningRequestInitialIntake As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorCriminalBackgroundScreeningRequestInitialIntakeIndex & "'", conn)
                                                                     Dim readerDocumentCriminalBackgroundScreeningRequestInitialIntake As SqlDataReader = queryDocumentCriminalBackgroundScreeningRequestInitialIntake.ExecuteReader()
                                                                     While readerDocumentCriminalBackgroundScreeningRequestInitialIntake.Read
                                                                         errorDocumentCriminalBackgroundScreeningRequestInitialIntakeID = CStr(readerDocumentCriminalBackgroundScreeningRequestInitialIntake("ErrorID"))
                                                                         detailsDocumentCriminalBackgroundScreeningRequestInitialIntake = CStr(readerDocumentCriminalBackgroundScreeningRequestInitialIntake("Details"))
                                                                         noticeTypeDocumentCriminalBackgroundScreeningRequestInitialIntake = CStr(readerDocumentCriminalBackgroundScreeningRequestInitialIntake("Notice"))
                                                                         statusDocumentCriminalBackgroundScreeningRequestInitialIntake = CStr(readerDocumentCriminalBackgroundScreeningRequestInitialIntake("Status"))
                                                                         errorStaffNameDocumentCriminalBackgroundScreeningRequestInitialIntake = CStr(readerDocumentCriminalBackgroundScreeningRequestInitialIntake("ErrorStaffName"))
                                                                errorDocumentCriminalBackgroundScreeningRequestInitialIntakeReviewTypeID = CStr(readerDocumentCriminalBackgroundScreeningRequestInitialIntake("fk_ReviewTypeID"))
                                                                processDocumentCriminalBackgroundScreeningRequestInitialIntakeID = CStr(readerDocumentCriminalBackgroundScreeningRequestInitialIntake("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentCriminalBackgroundScreeningRequestInitialIntake) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentCriminalBackgroundScreeningRequestInitialIntake)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentCriminalBackgroundScreeningRequestInitialIntake) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentCriminalBackgroundScreeningRequestInitialIntake) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentCriminalBackgroundScreeningRequestInitialIntakeID) %>&ReviewTypeID=<% Response.Write(errorDocumentCriminalBackgroundScreeningRequestInitialIntakeReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentCriminalBackgroundScreeningRequestInitialIntakeID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeCriminalBackgroundScreeningRequestInitialIntake" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeCriminalBackgroundScreeningRequestInitialIntake" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeCriminalBackgroundScreeningRequestInitialIntake" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentCriminalBackgroundScreeningRequestInitialIntake" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerCriminalBackgroundScreeningRequestInitialIntake" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerCriminalBackgroundScreeningRequestInitialIntake" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerCriminalBackgroundScreeningRequestInitialIntake" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusCriminalBackgroundScreeningRequestInitialIntake" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateCriminalBackgroundScreeningRequestInitialIntake" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="eiv:-existing-tenant-search">
                                                <h6> EIV: Existing Tenant Search  &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("76") Then
                                                                Response.Write("<input type='checkbox' name='documentEivExistingTenantSearch' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentEivExistingTenantSearch' />")
                                                            End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentEivExistingTenantSearch' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                <%
                                                    conn.Open()
                                                                 Dim errorDocumentEivExistingTenantSearchErrorID As Integer
                                                                 Dim errorDocumentEivExistingTenantSearchID As Integer
                                                                 Dim detailsDocumentEivExistingTenantSearch As String
                                                                 Dim noticeTypeDocumentEivExistingTenantSearch As String
                                                                 Dim statusDocumentEivExistingTenantSearch As String
                                                                 Dim errorStaffNameDocumentEivExistingTenantSearch As String
                                                                 Dim errorDocumentEivExistingTenantSearchReviewTypeID As Integer
                                                    Dim errorsEivExistingTenantSearchList As New ArrayList
                                                    Dim processDocumentEivExistingTenantSearchID As Integer
                                                        
                                                    Dim queryDocumentEivExistingTenantSearchError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '76' AND fk_FileID = '" & fileID & "'", conn)
                                                                 Dim readerDocumentEivExistingTenantSearchError As SqlDataReader = queryDocumentEivExistingTenantSearchError.ExecuteReader()
                                                                 If readerDocumentEivExistingTenantSearchError.HasRows Then
                                                                     While readerDocumentEivExistingTenantSearchError.Read
                                                                         errorDocumentEivExistingTenantSearchErrorID = CStr(readerDocumentEivExistingTenantSearchError("fk_ErrorID"))
                                                                         errorsEivExistingTenantSearchList.Add(errorDocumentEivExistingTenantSearchErrorID)
                                                                     End While
                                                                 End If
                                                                 conn.Close()
                                           
                                                                 conn.Open()
                                                                 Dim errorEivExistingTenantSearchIndex As Integer
                                                                 For Each errorEivExistingTenantSearchIndex In errorsEivExistingTenantSearchList
                                                                     Dim queryDocumentEivExistingTenantSearch As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorEivExistingTenantSearchIndex & "'", conn)
                                                                     Dim readerDocumentEivExistingTenantSearch As SqlDataReader = queryDocumentEivExistingTenantSearch.ExecuteReader()
                                                                     While readerDocumentEivExistingTenantSearch.Read
                                                                         errorDocumentEivExistingTenantSearchID = CStr(readerDocumentEivExistingTenantSearch("ErrorID"))
                                                                         detailsDocumentEivExistingTenantSearch = CStr(readerDocumentEivExistingTenantSearch("Details"))
                                                                         noticeTypeDocumentEivExistingTenantSearch = CStr(readerDocumentEivExistingTenantSearch("Notice"))
                                                                         statusDocumentEivExistingTenantSearch = CStr(readerDocumentEivExistingTenantSearch("Status"))
                                                                         errorStaffNameDocumentEivExistingTenantSearch = CStr(readerDocumentEivExistingTenantSearch("ErrorStaffName"))
                                                            errorDocumentEivExistingTenantSearchReviewTypeID = CStr(readerDocumentEivExistingTenantSearch("fk_ReviewTypeID"))
                                                            processDocumentEivExistingTenantSearchID = CStr(readerDocumentEivExistingTenantSearch("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentEivExistingTenantSearch) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentEivExistingTenantSearch)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentEivExistingTenantSearch) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentEivExistingTenantSearch) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentEivExistingTenantSearchID) %>&ReviewTypeID=<% Response.Write(errorDocumentEivExistingTenantSearchReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentEivExistingTenantSearchID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeEivExistingTenantSearch" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeEivExistingTenantSearch" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeEivExistingTenantSearch" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentEivExistingTenantSearch" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerEivExistingTenantSearch" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerEivExistingTenantSearch" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerEivExistingTenantSearch" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusEivExistingTenantSearch" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateEivExistingTenantSearch" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="eiv-former-tenant-search">
                                                <h6> EIV: Former Tenant Search 
                                                     &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("17") Then
                                                                Response.Write("<input type='checkbox' name='documentEivFormerTenantSearch' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentEivFormerTenantSearch' />")
                                                            End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentEivFormerTenantSearch' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                   <%
                                                    conn.Open()
                                                                 Dim errorDocumentEivFormerTenantSearchErrorID As Integer
                                                                 Dim errorDocumentEivFormerTenantSearchID As Integer
                                                                 Dim detailsDocumentEivFormerTenantSearch As String
                                                                 Dim noticeTypeDocumentEivFormerTenantSearch As String
                                                                 Dim statusDocumentEivFormerTenantSearch As String
                                                                 Dim errorStaffNameDocumentEivFormerTenantSearch As String
                                                                 Dim errorDocumentEivFormerTenantSearchReviewTypeID As Integer
                                                       Dim errorsEivFormerTenantSearchList As New ArrayList
                                                       Dim processDocumentEivFormerTenantSearchID As Integer
                                                        
                                                       Dim queryDocumentEivFormerTenantSearchError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '17' AND fk_FileID = '" & fileID & "'", conn)
                                                                 Dim readerDocumentEivFormerTenantSearchError As SqlDataReader = queryDocumentEivFormerTenantSearchError.ExecuteReader()
                                                                 If readerDocumentEivFormerTenantSearchError.HasRows Then
                                                                     While readerDocumentEivFormerTenantSearchError.Read
                                                                         errorDocumentEivFormerTenantSearchErrorID = CStr(readerDocumentEivFormerTenantSearchError("fk_ErrorID"))
                                                                         errorsEivFormerTenantSearchList.Add(errorDocumentEivFormerTenantSearchErrorID)
                                                                     End While
                                                                 End If
                                                                 conn.Close()
                                           
                                                                 conn.Open()
                                                                 Dim errorEivFormerTenantSearchIndex As Integer
                                                                 For Each errorEivFormerTenantSearchIndex In errorsEivFormerTenantSearchList
                                                           Dim queryDocumentEivFormerTenantSearch As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorEivFormerTenantSearchIndex & "'", conn)
                                                                     Dim readerDocumentEivFormerTenantSearch As SqlDataReader = queryDocumentEivFormerTenantSearch.ExecuteReader()
                                                                     While readerDocumentEivFormerTenantSearch.Read
                                                                         errorDocumentEivFormerTenantSearchID = CStr(readerDocumentEivFormerTenantSearch("ErrorID"))
                                                                         detailsDocumentEivFormerTenantSearch = CStr(readerDocumentEivFormerTenantSearch("Details"))
                                                                         noticeTypeDocumentEivFormerTenantSearch = CStr(readerDocumentEivFormerTenantSearch("Notice"))
                                                                         statusDocumentEivFormerTenantSearch = CStr(readerDocumentEivFormerTenantSearch("Status"))
                                                                         errorStaffNameDocumentEivFormerTenantSearch = CStr(readerDocumentEivFormerTenantSearch("ErrorStaffName"))
                                                               errorDocumentEivFormerTenantSearchReviewTypeID = CStr(readerDocumentEivFormerTenantSearch("fk_ReviewTypeID"))
                                                               processDocumentEivFormerTenantSearchID = CStr(readerDocumentEivFormerTenantSearch("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentEivFormerTenantSearch) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentEivFormerTenantSearch)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentEivFormerTenantSearch) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentEivFormerTenantSearch) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentEivFormerTenantSearchID) %>&ReviewTypeID=<% Response.Write(errorDocumentEivFormerTenantSearchReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentEivFormerTenantSearchID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeEivFormerTenantSearch" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeEivFormerTenantSearch" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeEivFormerTenantSearch" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentEivFormerTenantSearch" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerEivFormerTenantSearch" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerEivFormerTenantSearch" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerEivFormerTenantSearch" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusEivFormerTenantSearch" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateEivFormerTenantSearch" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="authorization-for-release-of-information/privacy-act-hud-9886-initial)">
                                                <h6>Authorization for Release of Information/Privacy Act (HUD-9886) (Initial)
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("18") Then
                                                                Response.Write("<input type='checkbox' name='documentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial' />")
                                                            End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                 <%
                                                    conn.Open()
                                                                 Dim errorDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886InitialErrorID As Integer
                                                                 Dim errorDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886InitialID As Integer
                                                                 Dim detailsDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial As String
                                                                 Dim noticeTypeDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial As String
                                                                 Dim statusDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial As String
                                                                 Dim errorStaffNameDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial As String
                                                                 Dim errorDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886InitialReviewTypeID As Integer
                                                     Dim errorsAuthorizationForReleaseOfInformationPrivacyActHud9886InitialList As New ArrayList
                                                     Dim processDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886InitialID As Integer
                                                        
                                                     Dim queryDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886InitialError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '18' AND fk_FileID = '" & fileID & "'", conn)
                                                                 Dim readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886InitialError As SqlDataReader = queryDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886InitialError.ExecuteReader()
                                                                 If readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886InitialError.HasRows Then
                                                                     While readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886InitialError.Read
                                                                         errorDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886InitialErrorID = CStr(readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886InitialError("fk_ErrorID"))
                                                                         errorsAuthorizationForReleaseOfInformationPrivacyActHud9886InitialList.Add(errorDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886InitialErrorID)
                                                                     End While
                                                                 End If
                                                                 conn.Close()
                                           
                                                                 conn.Open()
                                                                 Dim errorAuthorizationForReleaseOfInformationPrivacyActHud9886InitialIndex As Integer
                                                                 For Each errorAuthorizationForReleaseOfInformationPrivacyActHud9886InitialIndex In errorsAuthorizationForReleaseOfInformationPrivacyActHud9886InitialList
                                                         Dim queryDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorAuthorizationForReleaseOfInformationPrivacyActHud9886InitialIndex & "'", conn)
                                                                     Dim readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial As SqlDataReader = queryDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial.ExecuteReader()
                                                                     While readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial.Read
                                                                         errorDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886InitialID = CStr(readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial("ErrorID"))
                                                                         detailsDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial = CStr(readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial("Details"))
                                                                         noticeTypeDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial = CStr(readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial("Notice"))
                                                                         statusDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial = CStr(readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial("Status"))
                                                                         errorStaffNameDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial = CStr(readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial("ErrorStaffName"))
                                                             errorDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886InitialReviewTypeID = CStr(readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial("fk_ReviewTypeID"))
                                                             processDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886InitialID = CStr(readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886InitialID) %>&ReviewTypeID=<% Response.Write(errorDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886InitialReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886InitialID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeAuthorizationForReleaseOfInformationPrivacyActHud9886Initial" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeAuthorizationForReleaseOfInformationPrivacyActHud9886Initial" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeAuthorizationForReleaseOfInformationPrivacyActHud9886Initial" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentAuthorizationForReleaseOfInformationPrivacyActHud9886Initial" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerAuthorizationForReleaseOfInformationPrivacyActHud9886Initial" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerAuthorizationForReleaseOfInformationPrivacyActHud9886Initial" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerAuthorizationForReleaseOfInformationPrivacyActHud9886Initial" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusAuthorizationForReleaseOfInformationPrivacyActHud9886Initial" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateAuthorizationForReleaseOfInformationPrivacyActHud9886Initial" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="hano-authorization-for-release-of-information-initial">
                                                <h6> HANO Authorization for Release of Information (Initial)
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("19") Then
                                                                Response.Write("<input type='checkbox' name='documentHanoAuthorizationForReleaseOfInformationInitial' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentHanoAuthorizationForReleaseOfInformationInitial' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentHanoAuthorizationForReleaseOfInformationInitial' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                  <%
                                                    conn.Open()
                                                                 Dim errorDocumentHanoAuthorizationForReleaseOfInformationInitialErrorID As Integer
                                                                 Dim errorDocumentHanoAuthorizationForReleaseOfInformationInitialID As Integer
                                                                 Dim detailsDocumentHanoAuthorizationForReleaseOfInformationInitial As String
                                                                 Dim noticeTypeDocumentHanoAuthorizationForReleaseOfInformationInitial As String
                                                                 Dim statusDocumentHanoAuthorizationForReleaseOfInformationInitial As String
                                                                 Dim errorStaffNameDocumentHanoAuthorizationForReleaseOfInformationInitial As String
                                                                 Dim errorDocumentHanoAuthorizationForReleaseOfInformationInitialReviewTypeID As Integer
                                                      Dim errorsHanoAuthorizationForReleaseOfInformationInitialList As New ArrayList
                                                      Dim processDocumentHanoAuthorizationForReleaseOfInformationInitialID As Integer
                                                        
                                                    Dim queryDocumentHanoAuthorizationForReleaseOfInformationInitialError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '19' AND fk_FileID = '" & fileID & "'", conn)
                                                                 Dim readerDocumentHanoAuthorizationForReleaseOfInformationInitialError As SqlDataReader = queryDocumentHanoAuthorizationForReleaseOfInformationInitialError.ExecuteReader()
                                                                 If readerDocumentHanoAuthorizationForReleaseOfInformationInitialError.HasRows Then
                                                                     While readerDocumentHanoAuthorizationForReleaseOfInformationInitialError.Read
                                                                         errorDocumentHanoAuthorizationForReleaseOfInformationInitialErrorID = CStr(readerDocumentHanoAuthorizationForReleaseOfInformationInitialError("fk_ErrorID"))
                                                                         errorsHanoAuthorizationForReleaseOfInformationInitialList.Add(errorDocumentHanoAuthorizationForReleaseOfInformationInitialErrorID)
                                                                     End While
                                                                 End If
                                                                 conn.Close()
                                           
                                                                 conn.Open()
                                                                 Dim errorHanoAuthorizationForReleaseOfInformationInitialIndex As Integer
                                                                 For Each errorHanoAuthorizationForReleaseOfInformationInitialIndex In errorsHanoAuthorizationForReleaseOfInformationInitialList
                                                                     Dim queryDocumentHanoAuthorizationForReleaseOfInformationInitial As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorHanoAuthorizationForReleaseOfInformationInitialIndex & "'", conn)
                                                                     Dim readerDocumentHanoAuthorizationForReleaseOfInformationInitial As SqlDataReader = queryDocumentHanoAuthorizationForReleaseOfInformationInitial.ExecuteReader()
                                                                     While readerDocumentHanoAuthorizationForReleaseOfInformationInitial.Read
                                                                         errorDocumentHanoAuthorizationForReleaseOfInformationInitialID = CStr(readerDocumentHanoAuthorizationForReleaseOfInformationInitial("ErrorID"))
                                                                         detailsDocumentHanoAuthorizationForReleaseOfInformationInitial = CStr(readerDocumentHanoAuthorizationForReleaseOfInformationInitial("Details"))
                                                                         noticeTypeDocumentHanoAuthorizationForReleaseOfInformationInitial = CStr(readerDocumentHanoAuthorizationForReleaseOfInformationInitial("Notice"))
                                                                         statusDocumentHanoAuthorizationForReleaseOfInformationInitial = CStr(readerDocumentHanoAuthorizationForReleaseOfInformationInitial("Status"))
                                                                         errorStaffNameDocumentHanoAuthorizationForReleaseOfInformationInitial = CStr(readerDocumentHanoAuthorizationForReleaseOfInformationInitial("ErrorStaffName"))
                                                              errorDocumentHanoAuthorizationForReleaseOfInformationInitialReviewTypeID = CStr(readerDocumentHanoAuthorizationForReleaseOfInformationInitial("fk_ReviewTypeID"))
                                                              processDocumentHanoAuthorizationForReleaseOfInformationInitialID = CStr(readerDocumentHanoAuthorizationForReleaseOfInformationInitial("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentHanoAuthorizationForReleaseOfInformationInitial) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentHanoAuthorizationForReleaseOfInformationInitial)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentHanoAuthorizationForReleaseOfInformationInitial) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentHanoAuthorizationForReleaseOfInformationInitial) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentHanoAuthorizationForReleaseOfInformationInitialID) %>&ReviewTypeID=<% Response.Write(errorDocumentHanoAuthorizationForReleaseOfInformationInitialReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentHanoAuthorizationForReleaseOfInformationInitialID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeHanoAuthorizationForReleaseOfInformationInitial" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeHanoAuthorizationForReleaseOfInformationInitial" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeHanoAuthorizationForReleaseOfInformationInitial" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentHanoAuthorizationForReleaseOfInformationInitial" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerHanoAuthorizationForReleaseOfInformationInitial" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerHanoAuthorizationForReleaseOfInformationInitial" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerHanoAuthorizationForReleaseOfInformationInitial" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusHanoAuthorizationForReleaseOfInformationInitial" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateHanoAuthorizationForReleaseOfInformationInitial" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="debts-owed-to-pha-and-terminations-hud-52675">
                                                <h6> Debts Owed to PHA and Terminations (HUD 52675)
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("20") Then
                                                                Response.Write("<input type='checkbox' name='documentDebtsOwedToPhaAndTerminationsHud52675' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentDebtsOwedToPhaAndTerminationsHud52675' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentDebtsOwedToPhaAndTerminationsHud52675' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                 <%
                                                    conn.Open()
                                                                 Dim errorDocumentDebtsOwedToPhaAndTerminationsHud52675ErrorID As Integer
                                                                 Dim errorDocumentDebtsOwedToPhaAndTerminationsHud52675ID As Integer
                                                                 Dim detailsDocumentDebtsOwedToPhaAndTerminationsHud52675 As String
                                                                 Dim noticeTypeDocumentDebtsOwedToPhaAndTerminationsHud52675 As String
                                                                 Dim statusDocumentDebtsOwedToPhaAndTerminationsHud52675 As String
                                                                 Dim errorStaffNameDocumentDebtsOwedToPhaAndTerminationsHud52675 As String
                                                                 Dim errorDocumentDebtsOwedToPhaAndTerminationsHud52675ReviewTypeID As Integer
                                                     Dim errorsDebtsOwedToPhaAndTerminationsHud52675List As New ArrayList
                                                     Dim processDocumentDebtsOwedToPhaAndTerminationsHud52675ID As Integer
                                                        
                                                    Dim queryDocumentDebtsOwedToPhaAndTerminationsHud52675Error As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '20' AND fk_FileID = '" & fileID & "'", conn)
                                                                 Dim readerDocumentDebtsOwedToPhaAndTerminationsHud52675Error As SqlDataReader = queryDocumentDebtsOwedToPhaAndTerminationsHud52675Error.ExecuteReader()
                                                                 If readerDocumentDebtsOwedToPhaAndTerminationsHud52675Error.HasRows Then
                                                                     While readerDocumentDebtsOwedToPhaAndTerminationsHud52675Error.Read
                                                                         errorDocumentDebtsOwedToPhaAndTerminationsHud52675ErrorID = CStr(readerDocumentDebtsOwedToPhaAndTerminationsHud52675Error("fk_ErrorID"))
                                                                         errorsDebtsOwedToPhaAndTerminationsHud52675List.Add(errorDocumentDebtsOwedToPhaAndTerminationsHud52675ErrorID)
                                                                     End While
                                                                 End If
                                                                 conn.Close()
                                           
                                                                 conn.Open()
                                                                 Dim errorDebtsOwedToPhaAndTerminationsHud52675Index As Integer
                                                                 For Each errorDebtsOwedToPhaAndTerminationsHud52675Index In errorsDebtsOwedToPhaAndTerminationsHud52675List
                                                         Dim queryDocumentDebtsOwedToPhaAndTerminationsHud52675 As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorDebtsOwedToPhaAndTerminationsHud52675Index & "'", conn)
                                                                     Dim readerDocumentDebtsOwedToPhaAndTerminationsHud52675 As SqlDataReader = queryDocumentDebtsOwedToPhaAndTerminationsHud52675.ExecuteReader()
                                                                     While readerDocumentDebtsOwedToPhaAndTerminationsHud52675.Read
                                                                         errorDocumentDebtsOwedToPhaAndTerminationsHud52675ID = CStr(readerDocumentDebtsOwedToPhaAndTerminationsHud52675("ErrorID"))
                                                                         detailsDocumentDebtsOwedToPhaAndTerminationsHud52675 = CStr(readerDocumentDebtsOwedToPhaAndTerminationsHud52675("Details"))
                                                                         noticeTypeDocumentDebtsOwedToPhaAndTerminationsHud52675 = CStr(readerDocumentDebtsOwedToPhaAndTerminationsHud52675("Notice"))
                                                                         statusDocumentDebtsOwedToPhaAndTerminationsHud52675 = CStr(readerDocumentDebtsOwedToPhaAndTerminationsHud52675("Status"))
                                                                         errorStaffNameDocumentDebtsOwedToPhaAndTerminationsHud52675 = CStr(readerDocumentDebtsOwedToPhaAndTerminationsHud52675("ErrorStaffName"))
                                                             errorDocumentDebtsOwedToPhaAndTerminationsHud52675ReviewTypeID = CStr(readerDocumentDebtsOwedToPhaAndTerminationsHud52675("fk_ReviewTypeID"))
                                                             processDocumentDebtsOwedToPhaAndTerminationsHud52675ID = CStr(readerDocumentDebtsOwedToPhaAndTerminationsHud52675("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentDebtsOwedToPhaAndTerminationsHud52675) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentDebtsOwedToPhaAndTerminationsHud52675)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentDebtsOwedToPhaAndTerminationsHud52675) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentDebtsOwedToPhaAndTerminationsHud52675) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentDebtsOwedToPhaAndTerminationsHud52675ID) %>&ReviewTypeID=<% Response.Write(errorDocumentDebtsOwedToPhaAndTerminationsHud52675ReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentDebtsOwedToPhaAndTerminationsHud52675ID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeDebtsOwedToPhaAndTerminationsHud52675" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeDebtsOwedToPhaAndTerminationsHud52675" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeDebtsOwedToPhaAndTerminationsHud52675" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentDebtsOwedToPhaAndTerminationsHud52675" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerDebtsOwedToPhaAndTerminationsHud52675" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerDebtsOwedToPhaAndTerminationsHud52675" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerDebtsOwedToPhaAndTerminationsHud52675" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusDebtsOwedToPhaAndTerminationsHud52675" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateDebtsOwedToPhaAndTerminationsHud52675" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="hud-supplement-sheet-hud-92006">
                                                <h6> HUD Supplement Sheet (HUD 92006)
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("21") Then
                                                                Response.Write("<input type='checkbox' name='documentHudSupplementSheetHud92006' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentHudSupplementSheetHud92006' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentHudSupplementSheetHud92006' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                              <%
                                                    conn.Open()
                                                                 Dim errorDocumentHudSupplementSheetHud92006ErrorID As Integer
                                                                 Dim errorDocumentHudSupplementSheetHud92006ID As Integer
                                                                 Dim detailsDocumentHudSupplementSheetHud92006 As String
                                                                 Dim noticeTypeDocumentHudSupplementSheetHud92006 As String
                                                                 Dim statusDocumentHudSupplementSheetHud92006 As String
                                                                 Dim errorStaffNameDocumentHudSupplementSheetHud92006 As String
                                                                 Dim errorDocumentHudSupplementSheetHud92006ReviewTypeID As Integer
                                                  Dim errorsHudSupplementSheetHud92006List As New ArrayList
                                                  Dim processDocumentHudSupplementSheetHud92006ID As Integer
                                                        
                                                  Dim queryDocumentHudSupplementSheetHud92006Error As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '21' AND fk_FileID = '" & fileID & "'", conn)
                                                                 Dim readerDocumentHudSupplementSheetHud92006Error As SqlDataReader = queryDocumentHudSupplementSheetHud92006Error.ExecuteReader()
                                                                 If readerDocumentHudSupplementSheetHud92006Error.HasRows Then
                                                                     While readerDocumentHudSupplementSheetHud92006Error.Read
                                                                         errorDocumentHudSupplementSheetHud92006ErrorID = CStr(readerDocumentHudSupplementSheetHud92006Error("fk_ErrorID"))
                                                                         errorsHudSupplementSheetHud92006List.Add(errorDocumentHudSupplementSheetHud92006ErrorID)
                                                                     End While
                                                                 End If
                                                                 conn.Close()
                                           
                                                                 conn.Open()
                                                                 Dim errorHudSupplementSheetHud92006Index As Integer
                                                                 For Each errorHudSupplementSheetHud92006Index In errorsHudSupplementSheetHud92006List
                                                      Dim queryDocumentHudSupplementSheetHud92006 As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorHudSupplementSheetHud92006Index & "'", conn)
                                                                     Dim readerDocumentHudSupplementSheetHud92006 As SqlDataReader = queryDocumentHudSupplementSheetHud92006.ExecuteReader()
                                                                     While readerDocumentHudSupplementSheetHud92006.Read
                                                                         errorDocumentHudSupplementSheetHud92006ID = CStr(readerDocumentHudSupplementSheetHud92006("ErrorID"))
                                                                         detailsDocumentHudSupplementSheetHud92006 = CStr(readerDocumentHudSupplementSheetHud92006("Details"))
                                                                         noticeTypeDocumentHudSupplementSheetHud92006 = CStr(readerDocumentHudSupplementSheetHud92006("Notice"))
                                                                         statusDocumentHudSupplementSheetHud92006 = CStr(readerDocumentHudSupplementSheetHud92006("Status"))
                                                                         errorStaffNameDocumentHudSupplementSheetHud92006 = CStr(readerDocumentHudSupplementSheetHud92006("ErrorStaffName"))
                                                                         errorDocumentHudSupplementSheetHud92006ReviewTypeID = CStr(readerDocumentHudSupplementSheetHud92006("fk_ReviewTypeID"))
                                                                           processDocumentHudSupplementSheetHud92006ID = CStr(readerDocumentHudSupplementSheetHud92006("fk_ProcessTypeID")) 
                                                          %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentHudSupplementSheetHud92006) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentHudSupplementSheetHud92006)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentHudSupplementSheetHud92006) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentHudSupplementSheetHud92006) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentHudSupplementSheetHud92006ID) %>&ReviewTypeID=<% Response.Write(errorDocumentHudSupplementSheetHud92006ReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentHudSupplementSheetHud92006ID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeHudSupplementSheetHud92006" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeHudSupplementSheetHud92006" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeHudSupplementSheetHud92006" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentHudSupplementSheetHud92006" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerHudSupplementSheetHud92006" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerHudSupplementSheetHud92006" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerHudSupplementSheetHud92006" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusHudSupplementSheetHud92006" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateHudSupplementSheetHud92006" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="vama-client-notice">
                                                <h6> VAWA – Client Notice
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("22") Then
                                                                 Response.Write("<input type='checkbox' name='documentVawaClientNotice' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentVawaClientNotice' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentVawaClientNotice' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                 <%
                                                    conn.Open()
                                                                 Dim errorDocumentVawaClientNoticeErrorID As Integer
                                                                 Dim errorDocumentVawaClientNoticeID As Integer
                                                                 Dim detailsDocumentVawaClientNotice As String
                                                                 Dim noticeTypeDocumentVawaClientNotice As String
                                                                 Dim statusDocumentVawaClientNotice As String
                                                                 Dim errorStaffNameDocumentVawaClientNotice As String
                                                                 Dim errorDocumentVawaClientNoticeReviewTypeID As Integer
                                                     Dim errorsVawaClientNoticeList As New ArrayList
                                                     Dim processDocumentVawaClientID As Integer
                                                        
                                                     Dim queryDocumentVawaClientNoticeError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '22' AND fk_FileID = '" & fileID & "'", conn)
                                                                 Dim readerDocumentVawaClientNoticeError As SqlDataReader = queryDocumentVawaClientNoticeError.ExecuteReader()
                                                                 If readerDocumentVawaClientNoticeError.HasRows Then
                                                                     While readerDocumentVawaClientNoticeError.Read
                                                                         errorDocumentVawaClientNoticeErrorID = CStr(readerDocumentVawaClientNoticeError("fk_ErrorID"))
                                                                         errorsVawaClientNoticeList.Add(errorDocumentVawaClientNoticeErrorID)
                                                                     End While
                                                                 End If
                                                                 conn.Close()
                                           
                                                                 conn.Open()
                                                                 Dim errorVawaClientNoticeIndex As Integer
                                                                 For Each errorVawaClientNoticeIndex In errorsVawaClientNoticeList
                                                                     Dim queryDocumentVawaClientNotice As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorVawaClientNoticeIndex & "'", conn)
                                                                     Dim readerDocumentVawaClientNotice As SqlDataReader = queryDocumentVawaClientNotice.ExecuteReader()
                                                                     While readerDocumentVawaClientNotice.Read
                                                                         errorDocumentVawaClientNoticeID = CStr(readerDocumentVawaClientNotice("ErrorID"))
                                                                         detailsDocumentVawaClientNotice = CStr(readerDocumentVawaClientNotice("Details"))
                                                                         noticeTypeDocumentVawaClientNotice = CStr(readerDocumentVawaClientNotice("Notice"))
                                                                         statusDocumentVawaClientNotice = CStr(readerDocumentVawaClientNotice("Status"))
                                                                         errorStaffNameDocumentVawaClientNotice = CStr(readerDocumentVawaClientNotice("ErrorStaffName"))
                                                             errorDocumentVawaClientNoticeReviewTypeID = CStr(readerDocumentVawaClientNotice("fk_ReviewTypeID"))
                                                             processDocumentVawaClientID = CStr(readerDocumentVawaClientNotice("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentVawaClientNotice) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentVawaClientNotice)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentVawaClientNotice) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentVawaClientNotice) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentVawaClientNoticeID) %>&ReviewTypeID=<% Response.Write(errorDocumentVawaClientNoticeReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentVawaClientID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeVawaClientNotice" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeVawaClientNotice" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeVawaClientNotice" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentVawaClientNotice" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerVawaClientNotice" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerVawaClientNotice" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerVawaClientNotice" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusVawaClientNotice" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateVawaClientNotice" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="special-program-referral-form">
                                                <h6> Special Program Referral Form (If applicable)
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("23") Then
                                                                Response.Write("<input type='checkbox' name='documentSpecialProgramReferralFormIfApplicable' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentSpecialProgramReferralFormIfApplicable' />")
                                                            End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentSpecialProgramReferralFormIfApplicable' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                  <%
                                                    conn.Open()
                                                                 Dim errorDocumentSpecialProgramReferralFormIfApplicableErrorID As Integer
                                                                 Dim errorDocumentSpecialProgramReferralFormIfApplicableID As Integer
                                                                 Dim detailsDocumentSpecialProgramReferralFormIfApplicable As String
                                                                 Dim noticeTypeDocumentSpecialProgramReferralFormIfApplicable As String
                                                                 Dim statusDocumentSpecialProgramReferralFormIfApplicable As String
                                                                 Dim errorStaffNameDocumentSpecialProgramReferralFormIfApplicable As String
                                                                 Dim errorDocumentSpecialProgramReferralFormIfApplicableReviewTypeID As Integer
                                                      Dim errorsSpecialProgramReferralFormIfApplicableList As New ArrayList
                                                      Dim processDocumentSpecialProgramReferralFormIfApplicableID As Integer
                                                        
                                                      Dim queryDocumentSpecialProgramReferralFormIfApplicableError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '23' AND fk_FileID = '" & fileID & "'", conn)
                                                                 Dim readerDocumentSpecialProgramReferralFormIfApplicableError As SqlDataReader = queryDocumentSpecialProgramReferralFormIfApplicableError.ExecuteReader()
                                                                 If readerDocumentSpecialProgramReferralFormIfApplicableError.HasRows Then
                                                                     While readerDocumentSpecialProgramReferralFormIfApplicableError.Read
                                                                         errorDocumentSpecialProgramReferralFormIfApplicableErrorID = CStr(readerDocumentSpecialProgramReferralFormIfApplicableError("fk_ErrorID"))
                                                                         errorsSpecialProgramReferralFormIfApplicableList.Add(errorDocumentSpecialProgramReferralFormIfApplicableErrorID)
                                                                     End While
                                                                 End If
                                                                 conn.Close()
                                           
                                                                 conn.Open()
                                                                 Dim errorSpecialProgramReferralFormIfApplicableIndex As Integer
                                                                 For Each errorSpecialProgramReferralFormIfApplicableIndex In errorsSpecialProgramReferralFormIfApplicableList
                                                          Dim queryDocumentSpecialProgramReferralFormIfApplicable As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorSpecialProgramReferralFormIfApplicableIndex & "'", conn)
                                                                     Dim readerDocumentSpecialProgramReferralFormIfApplicable As SqlDataReader = queryDocumentSpecialProgramReferralFormIfApplicable.ExecuteReader()
                                                                     While readerDocumentSpecialProgramReferralFormIfApplicable.Read
                                                                         errorDocumentSpecialProgramReferralFormIfApplicableID = CStr(readerDocumentSpecialProgramReferralFormIfApplicable("ErrorID"))
                                                                         detailsDocumentSpecialProgramReferralFormIfApplicable = CStr(readerDocumentSpecialProgramReferralFormIfApplicable("Details"))
                                                                         noticeTypeDocumentSpecialProgramReferralFormIfApplicable = CStr(readerDocumentSpecialProgramReferralFormIfApplicable("Notice"))
                                                                         statusDocumentSpecialProgramReferralFormIfApplicable = CStr(readerDocumentSpecialProgramReferralFormIfApplicable("Status"))
                                                                         errorStaffNameDocumentSpecialProgramReferralFormIfApplicable = CStr(readerDocumentSpecialProgramReferralFormIfApplicable("ErrorStaffName"))
                                                              errorDocumentSpecialProgramReferralFormIfApplicableReviewTypeID = CStr(readerDocumentSpecialProgramReferralFormIfApplicable("fk_ReviewTypeID"))
                                                              processDocumentSpecialProgramReferralFormIfApplicableID =  CStr(readerDocumentSpecialProgramReferralFormIfApplicable("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentSpecialProgramReferralFormIfApplicable) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentSpecialProgramReferralFormIfApplicable)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentSpecialProgramReferralFormIfApplicable) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentSpecialProgramReferralFormIfApplicable) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentSpecialProgramReferralFormIfApplicableID) %>&ReviewTypeID=<% Response.Write(errorDocumentSpecialProgramReferralFormIfApplicableReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentSpecialProgramReferralFormIfApplicableID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeSpecialProgramReferralFormIfApplicable" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeSpecialProgramReferralFormIfApplicable" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeSpecialProgramReferralFormIfApplicable" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentSpecialProgramReferralFormIfApplicable" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerSpecialProgramReferralFormIfApplicable" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerSpecialProgramReferralFormIfApplicable" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerSpecialProgramReferralFormIfApplicable" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusSpecialProgramReferralFormIfApplicable" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateSpecialProgramReferralFormIfApplicable" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="hano-pre-application/initial-application">
                                                <h6>HANO Pre-Application/ Initial Application
                                                    &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("24") Then
                                                                 Response.Write("<input type='checkbox' name='documentHanoPreApplicationInitialApplication' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentHanoPreApplicationInitialApplication' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentHanoPreApplicationInitialApplication' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                 <%
                                                    conn.Open()
                                                                 Dim errorDocumentHanoPreApplicationInitialApplicationErrorID As Integer
                                                                 Dim errorDocumentHanoPreApplicationInitialApplicationID As Integer
                                                                 Dim detailsDocumentHanoPreApplicationInitialApplication As String
                                                                 Dim noticeTypeDocumentHanoPreApplicationInitialApplication As String
                                                                 Dim statusDocumentHanoPreApplicationInitialApplication As String
                                                                 Dim errorStaffNameDocumentHanoPreApplicationInitialApplication As String
                                                                 Dim errorDocumentHanoPreApplicationInitialApplicationReviewTypeID As Integer
                                                     Dim errorsHanoPreApplicationInitialApplicationList As New ArrayList
                                                     Dim processDocumentHanoPreApplicationInitialApplicationID As Integer
                                                        
                                                     Dim queryDocumentHanoPreApplicationInitialApplicationError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '24' AND fk_FileID = '" & fileID & "'", conn)
                                                                 Dim readerDocumentHanoPreApplicationInitialApplicationError As SqlDataReader = queryDocumentHanoPreApplicationInitialApplicationError.ExecuteReader()
                                                                 If readerDocumentHanoPreApplicationInitialApplicationError.HasRows Then
                                                                     While readerDocumentHanoPreApplicationInitialApplicationError.Read
                                                                         errorDocumentHanoPreApplicationInitialApplicationErrorID = CStr(readerDocumentHanoPreApplicationInitialApplicationError("fk_ErrorID"))
                                                                         errorsHanoPreApplicationInitialApplicationList.Add(errorDocumentHanoPreApplicationInitialApplicationErrorID)
                                                                     End While
                                                                 End If
                                                                 conn.Close()
                                           
                                                                 conn.Open()
                                                                 Dim errorHanoPreApplicationInitialApplicationIndex As Integer
                                                                 For Each errorHanoPreApplicationInitialApplicationIndex In errorsHanoPreApplicationInitialApplicationList
                                                         Dim queryDocumentHanoPreApplicationInitialApplication As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorHanoPreApplicationInitialApplicationIndex & "'", conn)
                                                                     Dim readerDocumentHanoPreApplicationInitialApplication As SqlDataReader = queryDocumentHanoPreApplicationInitialApplication.ExecuteReader()
                                                                     While readerDocumentHanoPreApplicationInitialApplication.Read
                                                                         errorDocumentHanoPreApplicationInitialApplicationID = CStr(readerDocumentHanoPreApplicationInitialApplication("ErrorID"))
                                                                         detailsDocumentHanoPreApplicationInitialApplication = CStr(readerDocumentHanoPreApplicationInitialApplication("Details"))
                                                                         noticeTypeDocumentHanoPreApplicationInitialApplication = CStr(readerDocumentHanoPreApplicationInitialApplication("Notice"))
                                                                         statusDocumentHanoPreApplicationInitialApplication = CStr(readerDocumentHanoPreApplicationInitialApplication("Status"))
                                                                         errorStaffNameDocumentHanoPreApplicationInitialApplication = CStr(readerDocumentHanoPreApplicationInitialApplication("ErrorStaffName"))
                                                             errorDocumentHanoPreApplicationInitialApplicationReviewTypeID = CStr(readerDocumentHanoPreApplicationInitialApplication("fk_ReviewTypeID"))
                                                             processDocumentHanoPreApplicationInitialApplicationID = CStr(readerDocumentHanoPreApplicationInitialApplication("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentHanoPreApplicationInitialApplication) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentHanoPreApplicationInitialApplication)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentHanoPreApplicationInitialApplication) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentHanoPreApplicationInitialApplication) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentHanoPreApplicationInitialApplicationID) %>&ReviewTypeID=<% Response.Write(errorDocumentHanoPreApplicationInitialApplicationReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentHanoPreApplicationInitialApplicationID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeHanoPreApplicationInitialApplication" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeHanoPreApplicationInitialApplication" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeHanoPreApplicationInitialApplication" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentHanoPreApplicationInitialApplication" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerHanoPreApplicationInitialApplication" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerHanoPreApplicationInitialApplication" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerHanoPreApplicationInitialApplication" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusHanoPreApplicationInitialApplication" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateHanoPreApplicationInitialApplication" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="briefing-appointment-letter">
                                                <h6> Briefing Appointment Letter
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("25") Then
                                                                Response.Write("<input type='checkbox' name='documentBriefingAppointmentLetter' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentBriefingAppointmentLetter' />")
                                                            End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentBriefingAppointmentLetter' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                <%
                                                    conn.Open()
                                                                 Dim errorDocumentBriefingAppointmentLetterErrorID As Integer
                                                                 Dim errorDocumentBriefingAppointmentLetterID As Integer
                                                                 Dim detailsDocumentBriefingAppointmentLetter As String
                                                                 Dim noticeTypeDocumentBriefingAppointmentLetter As String
                                                                 Dim statusDocumentBriefingAppointmentLetter As String
                                                                 Dim errorStaffNameDocumentBriefingAppointmentLetter As String
                                                                 Dim errorDocumentBriefingAppointmentLetterReviewTypeID As Integer
                                                    Dim errorsBriefingAppointmentLetterList As New ArrayList
                                                    Dim processDocumentBriefingAppointmentLetterID As Integer
                                                        
                                                    Dim queryDocumentBriefingAppointmentLetterError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '25' AND fk_FileID = '" & fileID & "'", conn)
                                                                 Dim readerDocumentBriefingAppointmentLetterError As SqlDataReader = queryDocumentBriefingAppointmentLetterError.ExecuteReader()
                                                                 If readerDocumentBriefingAppointmentLetterError.HasRows Then
                                                                     While readerDocumentBriefingAppointmentLetterError.Read
                                                                         errorDocumentBriefingAppointmentLetterErrorID = CStr(readerDocumentBriefingAppointmentLetterError("fk_ErrorID"))
                                                                         errorsBriefingAppointmentLetterList.Add(errorDocumentBriefingAppointmentLetterErrorID)
                                                                     End While
                                                                 End If
                                                                 conn.Close()
                                           
                                                                 conn.Open()
                                                                 Dim errorBriefingAppointmentLetterIndex As Integer
                                                                 For Each errorBriefingAppointmentLetterIndex In errorsBriefingAppointmentLetterList
                                                        Dim queryDocumentBriefingAppointmentLetter As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorBriefingAppointmentLetterIndex & "'", conn)
                                                                     Dim readerDocumentBriefingAppointmentLetter As SqlDataReader = queryDocumentBriefingAppointmentLetter.ExecuteReader()
                                                                     While readerDocumentBriefingAppointmentLetter.Read
                                                                         errorDocumentBriefingAppointmentLetterID = CStr(readerDocumentBriefingAppointmentLetter("ErrorID"))
                                                                         detailsDocumentBriefingAppointmentLetter = CStr(readerDocumentBriefingAppointmentLetter("Details"))
                                                                         noticeTypeDocumentBriefingAppointmentLetter = CStr(readerDocumentBriefingAppointmentLetter("Notice"))
                                                                         statusDocumentBriefingAppointmentLetter = CStr(readerDocumentBriefingAppointmentLetter("Status"))
                                                                         errorStaffNameDocumentBriefingAppointmentLetter = CStr(readerDocumentBriefingAppointmentLetter("ErrorStaffName"))
                                                            errorDocumentBriefingAppointmentLetterReviewTypeID = CStr(readerDocumentBriefingAppointmentLetter("fk_ReviewTypeID"))
                                                            processDocumentBriefingAppointmentLetterID = CStr(readerDocumentBriefingAppointmentLetter("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentBriefingAppointmentLetter) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentBriefingAppointmentLetter)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentBriefingAppointmentLetter) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentBriefingAppointmentLetter) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentBriefingAppointmentLetterID) %>&ReviewTypeID=<% Response.Write(errorDocumentBriefingAppointmentLetterReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentBriefingAppointmentLetterID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeBriefingAppointmentLetter" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeBriefingAppointmentLetter" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeBriefingAppointmentLetter" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentBriefingAppointmentLetter" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerBriefingAppointmentLetter" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerBriefingAppointmentLetter" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerBriefingAppointmentLetter" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusBriefingAppointmentLetter" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateBriefingAppointmentLetter" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="screening-appointment-letter">
                                                <h6> Screening Appointment Letter
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("26") Then
                                                                Response.Write("<input type='checkbox' name='documentScreeningAppointmentLetter' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentScreeningAppointmentLetter' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentScreeningAppointmentLetter' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                  <%
                                                    conn.Open()
                                                                 Dim errorDocumentScreeningAppointmentLetterErrorID As Integer
                                                                 Dim errorDocumentScreeningAppointmentLetterID As Integer
                                                                 Dim detailsDocumentScreeningAppointmentLetter As String
                                                                 Dim noticeTypeDocumentScreeningAppointmentLetter As String
                                                                 Dim statusDocumentScreeningAppointmentLetter As String
                                                                 Dim errorStaffNameDocumentScreeningAppointmentLetter As String
                                                                 Dim errorDocumentScreeningAppointmentLetterReviewTypeID As Integer
                                                      Dim errorsScreeningAppointmentLetterList As New ArrayList
                                                      Dim processDocumentScreeningAppointmentLetterID As Integer
                                                        
                                                    Dim queryDocumentScreeningAppointmentLetterError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '26' AND fk_FileID = '" & fileID & "'", conn)
                                                                 Dim readerDocumentScreeningAppointmentLetterError As SqlDataReader = queryDocumentScreeningAppointmentLetterError.ExecuteReader()
                                                                 If readerDocumentScreeningAppointmentLetterError.HasRows Then
                                                                     While readerDocumentScreeningAppointmentLetterError.Read
                                                                         errorDocumentScreeningAppointmentLetterErrorID = CStr(readerDocumentScreeningAppointmentLetterError("fk_ErrorID"))
                                                                         errorsScreeningAppointmentLetterList.Add(errorDocumentScreeningAppointmentLetterErrorID)
                                                                     End While
                                                                 End If
                                                                 conn.Close()
                                           
                                                                 conn.Open()
                                                                 Dim errorScreeningAppointmentLetterIndex As Integer
                                                                 For Each errorScreeningAppointmentLetterIndex In errorsScreeningAppointmentLetterList
                                                          Dim queryDocumentScreeningAppointmentLetter As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorScreeningAppointmentLetterIndex & "'", conn)
                                                                     Dim readerDocumentScreeningAppointmentLetter As SqlDataReader = queryDocumentScreeningAppointmentLetter.ExecuteReader()
                                                                     While readerDocumentScreeningAppointmentLetter.Read
                                                                         errorDocumentScreeningAppointmentLetterID = CStr(readerDocumentScreeningAppointmentLetter("ErrorID"))
                                                                         detailsDocumentScreeningAppointmentLetter = CStr(readerDocumentScreeningAppointmentLetter("Details"))
                                                                         noticeTypeDocumentScreeningAppointmentLetter = CStr(readerDocumentScreeningAppointmentLetter("Notice"))
                                                                         statusDocumentScreeningAppointmentLetter = CStr(readerDocumentScreeningAppointmentLetter("Status"))
                                                                         errorStaffNameDocumentScreeningAppointmentLetter = CStr(readerDocumentScreeningAppointmentLetter("ErrorStaffName"))
                                                              errorDocumentScreeningAppointmentLetterReviewTypeID = CStr(readerDocumentScreeningAppointmentLetter("fk_ReviewTypeID"))
                                                              processDocumentScreeningAppointmentLetterID = CStr(readerDocumentScreeningAppointmentLetter("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentScreeningAppointmentLetter) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentScreeningAppointmentLetter)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentScreeningAppointmentLetter) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentScreeningAppointmentLetter) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentScreeningAppointmentLetterID) %>&ReviewTypeID=<% Response.Write(errorDocumentScreeningAppointmentLetterReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentScreeningAppointmentLetterID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeScreeningAppointmentLetter" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeScreeningAppointmentLetter" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeScreeningAppointmentLetter" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentScreeningAppointmentLetter" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerScreeningAppointmentLetter" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerScreeningAppointmentLetter" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerScreeningAppointmentLetter" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusScreeningAppointmentLetter" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateScreeningAppointmentLetter" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
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
                                                href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                                  <i class="fa fa-sticky-note" aria-hidden="true"></i> Notes / Portability Billing / Compliance</a>
                                        </h4>
                                    </div>
                                    <div id="collapseTwo" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                                        <div class="panel-body">
                                            <hr />
                                            <div id="notes-other">
                                                <h6> Other 
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
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeDocumentOther" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeDocumentOther" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
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
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
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
                                                href="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                                <i class="fa fa-certificate" aria-hidden="true"></i> Recertification Documents</a>
                                        </h4>
                                    </div>
                                    <div id="collapseThree" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingThree">
                                        <div class="panel-body">
                                            <hr />
                                            <div id="authorization-for-release-of-information/privacy-act-hud-9886">
                                                <h6>Authorization for Release of Information/Privacy Act (HUD-9886)
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("27") Then
                                                                Response.Write("<input type='checkbox' name='documentAuthorizationForReleaseOfInformationPrivacyActHud9886' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentAuthorizationForReleaseOfInformationPrivacyActHud9886' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentAuthorizationForReleaseOfInformationPrivacyActHud9886' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                 <%
                                                    conn.Open()
                                                                 Dim errorDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886ErrorID As Integer
                                                                 Dim errorDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886ID As Integer
                                                                 Dim detailsDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886 As String
                                                                 Dim noticeTypeDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886 As String
                                                                 Dim statusDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886 As String
                                                                 Dim errorStaffNameDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886 As String
                                                                 Dim errorDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886ReviewTypeID As Integer
                                                     Dim errorsAuthorizationForReleaseOfInformationPrivacyActHud9886List As New ArrayList
                                                     Dim processDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886ID As Integer
                                                        
                                                     Dim queryDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Error As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '27' AND fk_FileID = '" & fileID & "'", conn)
                                                                 Dim readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Error As SqlDataReader = queryDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Error.ExecuteReader()
                                                                 If readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Error.HasRows Then
                                                                     While readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Error.Read
                                                                         errorDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886ErrorID = CStr(readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886Error("fk_ErrorID"))
                                                                         errorsAuthorizationForReleaseOfInformationPrivacyActHud9886List.Add(errorDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886ErrorID)
                                                                     End While
                                                                 End If
                                                                 conn.Close()
                                           
                                                                 conn.Open()
                                                                 Dim errorAuthorizationForReleaseOfInformationPrivacyActHud9886Index As Integer
                                                                 For Each errorAuthorizationForReleaseOfInformationPrivacyActHud9886Index In errorsAuthorizationForReleaseOfInformationPrivacyActHud9886List
                                                         Dim queryDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886 As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorAuthorizationForReleaseOfInformationPrivacyActHud9886Index & "'", conn)
                                                                     Dim readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886 As SqlDataReader = queryDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886.ExecuteReader()
                                                                     While readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886.Read
                                                                         errorDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886ID = CStr(readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886("ErrorID"))
                                                                         detailsDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886 = CStr(readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886("Details"))
                                                                         noticeTypeDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886 = CStr(readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886("Notice"))
                                                                         statusDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886 = CStr(readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886("Status"))
                                                                         errorStaffNameDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886 = CStr(readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886("ErrorStaffName"))
                                                             errorDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886ReviewTypeID = CStr(readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886("fk_ReviewTypeID"))
                                                             processDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886ID = CStr(readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886ID) %>&ReviewTypeID=<% Response.Write(errorDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886ReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886ID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeAuthorizationForReleaseOfInformationPrivacyActHud9886" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeAuthorizationForReleaseOfInformationPrivacyActHud9886" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeAuthorizationForReleaseOfInformationPrivacyActHud9886" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentAuthorizationForReleaseOfInformationPrivacyActHud9886" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerAuthorizationForReleaseOfInformationPrivacyActHud9886" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerAuthorizationForReleaseOfInformationPrivacyActHud9886" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerAuthorizationForReleaseOfInformationPrivacyActHud9886" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusAuthorizationForReleaseOfInformationPrivacyActHud9886" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateAuthorizationForReleaseOfInformationPrivacyActHud9886" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix"></div>
                                                <hr />
                                            </div>
                                            <div id="hano-authorization-for-release-of-information">
                                                <h6> HANO Authorization for Release of Information
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("28") Then
                                                                Response.Write("<input type='checkbox' name='documentHanoAuthorizationForReleaseOfInformation' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentHanoAuthorizationForReleaseOfInformation' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentHanoAuthorizationForReleaseOfInformation' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                 <%
                                                    conn.Open()
                                                                 Dim errorDocumentHanoAuthorizationForReleaseOfInformationErrorID As Integer
                                                                 Dim errorDocumentHanoAuthorizationForReleaseOfInformationID As Integer
                                                                 Dim detailsDocumentHanoAuthorizationForReleaseOfInformation As String
                                                                 Dim noticeTypeDocumentHanoAuthorizationForReleaseOfInformation As String
                                                                 Dim statusDocumentHanoAuthorizationForReleaseOfInformation As String
                                                                 Dim errorStaffNameDocumentHanoAuthorizationForReleaseOfInformation As String
                                                                 Dim errorDocumentHanoAuthorizationForReleaseOfInformationReviewTypeID As Integer
                                                     Dim errorsHanoAuthorizationForReleaseOfInformationList As New ArrayList
                                                     Dim processDocumentHanoAuthorizationForReleaseOfInformationID As Integer
                                                        
                                                    Dim queryDocumentHanoAuthorizationForReleaseOfInformationError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '28' AND fk_FileID = '" & fileID & "'", conn)
                                                                 Dim readerDocumentHanoAuthorizationForReleaseOfInformationError As SqlDataReader = queryDocumentHanoAuthorizationForReleaseOfInformationError.ExecuteReader()
                                                                 If readerDocumentHanoAuthorizationForReleaseOfInformationError.HasRows Then
                                                                     While readerDocumentHanoAuthorizationForReleaseOfInformationError.Read
                                                                         errorDocumentHanoAuthorizationForReleaseOfInformationErrorID = CStr(readerDocumentHanoAuthorizationForReleaseOfInformationError("fk_ErrorID"))
                                                                         errorsHanoAuthorizationForReleaseOfInformationList.Add(errorDocumentHanoAuthorizationForReleaseOfInformationErrorID)
                                                                     End While
                                                                 End If
                                                                 conn.Close()
                                           
                                                                 conn.Open()
                                                                 Dim errorHanoAuthorizationForReleaseOfInformationIndex As Integer
                                                                 For Each errorHanoAuthorizationForReleaseOfInformationIndex In errorsHanoAuthorizationForReleaseOfInformationList
                                                         Dim queryDocumentHanoAuthorizationForReleaseOfInformation As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorHanoAuthorizationForReleaseOfInformationIndex & "'", conn)
                                                                     Dim readerDocumentHanoAuthorizationForReleaseOfInformation As SqlDataReader = queryDocumentHanoAuthorizationForReleaseOfInformation.ExecuteReader()
                                                                     While readerDocumentHanoAuthorizationForReleaseOfInformation.Read
                                                                         errorDocumentHanoAuthorizationForReleaseOfInformationID = CStr(readerDocumentHanoAuthorizationForReleaseOfInformation("ErrorID"))
                                                                         detailsDocumentHanoAuthorizationForReleaseOfInformation = CStr(readerDocumentHanoAuthorizationForReleaseOfInformation("Details"))
                                                                         noticeTypeDocumentHanoAuthorizationForReleaseOfInformation = CStr(readerDocumentHanoAuthorizationForReleaseOfInformation("Notice"))
                                                                         statusDocumentHanoAuthorizationForReleaseOfInformation = CStr(readerDocumentHanoAuthorizationForReleaseOfInformation("Status"))
                                                                         errorStaffNameDocumentHanoAuthorizationForReleaseOfInformation = CStr(readerDocumentHanoAuthorizationForReleaseOfInformation("ErrorStaffName"))
                                                             errorDocumentHanoAuthorizationForReleaseOfInformationReviewTypeID = CStr(readerDocumentHanoAuthorizationForReleaseOfInformation("fk_ReviewTypeID"))
                                                             processDocumentHanoAuthorizationForReleaseOfInformationID = CStr(readerDocumentHanoAuthorizationForReleaseOfInformation("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentHanoAuthorizationForReleaseOfInformation) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentHanoAuthorizationForReleaseOfInformation)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentHanoAuthorizationForReleaseOfInformation) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentHanoAuthorizationForReleaseOfInformation) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentHanoAuthorizationForReleaseOfInformationID) %>&ReviewTypeID=<% Response.Write(errorDocumentHanoAuthorizationForReleaseOfInformationReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentHanoAuthorizationForReleaseOfInformationID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
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
                                                        <asp:DropDownList ID="NoticeTypeHanoAuthorizationForReleaseOfInformation" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeHanoAuthorizationForReleaseOfInformation" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeHanoAuthorizationForReleaseOfInformation" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentHanoAuthorizationForReleaseOfInformation" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="CaseManagerHanoAuthorizationForReleaseOfInformation" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerHanoAuthorizationForReleaseOfInformation" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerHanoAuthorizationForReleaseOfInformation" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusHanoAuthorizationForReleaseOfInformation" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnCreateHanoAuthorizationForReleaseOfInformation" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
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

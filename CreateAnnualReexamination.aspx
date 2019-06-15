<%@ Page Title="QC :: Annual " Language="vb" AutoEventWireup="false" MasterPageFile="~/FileDetails.master"
    CodeBehind="CreateAnnualReexamination.aspx.vb" Inherits="QualityControlMonitor.CreateAnnualReexamination" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="nestedContent" runat="server">
    <div class="row">
        <div class="col-lg-12 col-md-7">
            <div class="card">
                <div class="header">
                    <h4 class="title">
                        <i class="fa fa-calendar" aria-hidden="true"></i> QC Review :: Annual Reexamination
                    </h4>
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
                        <asp:Button ID="btnCompleteReview" runat="server" class="btn btn-info btn-fill btn-wd"
                            Text="Complete Annual Reexamination Review" />
                        <%
                        Else
                        %>
                        <asp:Button ID="btnUpdateReview" runat="server" class="btn btn-warning btn-fill btn-wd"
                            Text="Resubmit Annual Reexamination Review" />
                        <%
                        End If
                        connReview.Close()
                        %>
                    </div>
                    <div class="clearfix">
                    </div>
                    <br />
                    <ul class="nav nav-tabs nav-justified" role="tablist">
                        <li role="presentation" class="active"><a href="#process" aria-controls="process"
                            role="tab" data-toggle="tab"><i class="fa fa-folder-open" aria-hidden="true"></i>
                            &nbsp;&nbsp; Processing</a> </li>
                        <li role="presentation"><a href="#documents" aria-controls="documents" role="tab"
                            data-toggle="tab"><i class="fa fa-file-text" aria-hidden="true"></i>&nbsp;&nbsp;
                            Documents</a> </li>
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
                                        <i class="fa fa-calendar" aria-hidden="true"></i>Annual Reexamination
                                    </h4>
                                </div>
                                <div class="panel-body">
                                    <hr />
                                    <div id="verification">
                                        <h6>
                                            Verification &nbsp; &nbsp; &nbsp;
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
                                            <h6>
                                                Notice</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeVerification) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <h6>
                                                Comments</h6>
                                            <br />
                                            <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsVerification)%></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <h6>
                                                Staff</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameVerification) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <h6>
                                                Status</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusVerification) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="text-center">
                                            <br />
                                            <br />
                                            <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorVerificationID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDVerification) %>&ProcessTypeID=<% Response.Write(processVerificationID) %>"
                                                class="btn btn-warning btn-fill btn-wd">Edit</a>
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <br />
                                        <%
                                        End While
                                    End If
                                    conn.Close()
                                        %>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="NoticeTypeVerification" runat="server" class="form-control border-input"
                                                    DataSourceID="SqlNoticeTypeVerification" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeVerification" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
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
                                                    DataSourceID="SqlCaseManagerVerification" DataValueField="UserID" DataTextField="FullName">
                                                </asp:DropDownList>
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
                                            <asp:Button ID="btnCreateProcessVerification" runat="server" class="btn btn-success btn-fill btn-wd"
                                                Text="Add" />
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <hr />
                                    </div>
                                    <div id="calculation">
                                        <h6>
                                            Calculation &nbsp; &nbsp; &nbsp;
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
                                            <h6>
                                                Notice</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeCalculation) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <h6>
                                                Comments</h6>
                                            <br />
                                            <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsCalculation)%></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <h6>
                                                Staff</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameCalculation) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <h6>
                                                Status</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusCalculation) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="text-center">
                                            <br />
                                            <br />
                                            <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorCalculationID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDCalculation) %>&ProcessTypeID=<% Response.Write(processCalculationID) %>"
                                                class="btn btn-warning btn-fill btn-wd">Edit</a>
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <br />
                                        <%
                                        End While
                                    End If
                                    conn.Close()
                                        %>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="NoticeTypeCalculation" runat="server" class="form-control border-input"
                                                    DataSourceID="SqlNoticeTypeCalculation" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeCalculation" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '6' OR [NoticeTypeID] = '7' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '1' OR [NoticeTypeID] = '3'  ORDER BY [Notice] ASC">
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
                                                    DataSourceID="SqlCaseManagerCalculation" DataValueField="UserID" DataTextField="FullName"
                                                    required="required">
                                                </asp:DropDownList>
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
                                            <asp:Button ID="btnCreateProcessCalculation" runat="server" class="btn btn-success btn-fill btn-wd"
                                                Text="Add" />
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <hr />
                                    </div>
                                    <div id="payment-standard">
                                        <h6>
                                            Payment Standard &nbsp; &nbsp; &nbsp;
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
                                            <h6>
                                                Notice</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypePaymentStandard) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <h6>
                                                Comments</h6>
                                            <br />
                                            <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsPaymentStandard)%></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <h6>
                                                Staff</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNamePaymentStandard) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <h6>
                                                Status</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusPaymentStandard) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="text-center">
                                            <br />
                                            <br />
                                            <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorPaymentStandardID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDPaymentStandard) %>&ProcessTypeID=<% Response.Write(processPaymentStandardID) %>"
                                                class="btn btn-warning btn-fill btn-wd">Edit</a>
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <br />
                                        <%
                                        End While
                                    End If
                                    conn.Close()
                                        %>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="NoticeTypePaymentStandard" runat="server" class="form-control border-input"
                                                    DataSourceID="SqlNoticeTypePaymentStandard" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypePaymentStandard" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <textarea class="form-control border-input" cols="4" name="commentPaymentStandard"
                                                    placeholder="Comment" rows="1"></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="CaseManagerPaymentStandard" runat="server" class="form-control border-input"
                                                    DataSourceID="SqlCaseManagerPaymentStandard" DataValueField="UserID" DataTextField="FullName"
                                                    required="required">
                                                </asp:DropDownList>
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
                                            <asp:Button ID="btnCreateProcessPaymentStandard" runat="server" class="btn btn-success btn-fill btn-wd"
                                                Text="Add" />
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <hr />
                                    </div>
                                    <div id="utility-allowance">
                                        <h6>
                                            Utility Allowance &nbsp; &nbsp; &nbsp;
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
                                            <h6>
                                                Notice</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeUtilityAllowance) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <h6>
                                                Comments</h6>
                                            <br />
                                            <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsUtilityAllowance)%></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <h6>
                                                Staff</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameUtilityAllowance) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <h6>
                                                Status</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusUtilityAllowance) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="text-center">
                                            <br />
                                            <br />
                                            <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorUtilityAllowanceID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDUtilityAllowance) %>&ProcessTypeID=<% Response.Write(processUtilityAllowanceID) %>"
                                                class="btn btn-warning btn-fill btn-wd">Edit</a>
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <br />
                                        <%
                                        End While
                                    End If
                                    conn.Close()
                                        %>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="NoticeTypeUtilityAllowance" runat="server" class="form-control border-input"
                                                    DataSourceID="SqlNoticeTypeUtilityAllowance" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeUtilityAllowance" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <textarea class="form-control border-input" cols="4" name="commentUtilityAllowance"
                                                    placeholder="Comment" rows="1"></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="CaseManagerUtilityAllowance" runat="server" class="form-control border-input"
                                                    DataSourceID="SqlCaseManagerUtilityAllowance" DataValueField="UserID" DataTextField="FullName"
                                                    required="required">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlCaseManagerUtilityAllowance" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                    SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
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
                                            <asp:Button ID="btnCreateProcessUtilityAllowance" runat="server" class="btn btn-success btn-fill btn-wd"
                                                Text="Add" />
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <hr />
                                    </div>
                                    <div id="tenant-rent">
                                        <h6>
                                            Tenant Rent &nbsp; &nbsp; &nbsp;
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
                                            <h6>
                                                Notice</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeTenantRent) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <h6>
                                                Comments</h6>
                                            <br />
                                            <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsTenantRent)%></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <h6>
                                                Staff</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameTenantRent) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <h6>
                                                Status</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusTenantRent) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="text-center">
                                            <br />
                                            <br />
                                            <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorTenantRentID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDTenantRent) %>&ProcessTypeID=<% Response.Write(processTenantRentID) %>"
                                                class="btn btn-warning btn-fill btn-wd">Edit</a>
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <br />
                                        <%
                                        End While
                                    End If
                                    conn.Close()
                                        %>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="NoticeTypeTenantRent" runat="server" class="form-control border-input"
                                                    DataSourceID="SqlNoticeTypeTenantRent" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeTenantRent" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
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
                                                    DataSourceID="SqlCaseManagerTenantRent" DataValueField="UserID" DataTextField="FullName"
                                                    required="required">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlCaseManagerTenantRent" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                    SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
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
                                            <asp:Button ID="btnCreateProcessTenantRent" runat="server" class="btn btn-success btn-fill btn-wd"
                                                Text="Add" />
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <hr />
                                    </div>
                                    <div id="occupancy-standard">
                                        <h6>
                                            Occupancy Standard &nbsp; &nbsp; &nbsp;
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
                                            <h6>
                                                Notice</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeOccupancyStandard) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <h6>
                                                Comments</h6>
                                            <br />
                                            <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsOccupancyStandard)%></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <h6>
                                                Staff</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameOccupancyStandard) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <h6>
                                                Status</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusOccupancyStandard) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="text-center">
                                            <br />
                                            <br />
                                            <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorOccupancyStandardID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDOccupancyStandard) %>&ProcessTypeID=<% Response.Write(processOccupancyStandardID) %>"
                                                class="btn btn-warning btn-fill btn-wd">Edit</a>
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <br />
                                        <%
                                        End While
                                    End If
                                    conn.Close()
                                        %>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="NoticeTypeOccupancyStandard" runat="server" class="form-control border-input"
                                                    DataSourceID="SqlNoticeTypeOccupancyStandard" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeOccupancyStandard" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <textarea class="form-control border-input" cols="4" name="commentOccupancyStandard"
                                                    placeholder="Comment" rows="1"></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="CaseManagerOccupancyStandard" runat="server" class="form-control border-input"
                                                    DataSourceID="SqlCaseManagerOccupancyStandard" DataValueField="UserID" DataTextField="FullName"
                                                    required="required">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlCaseManagerOccupancyStandard" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                    SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="StatusOccupancyStandard" class="form-control border-input"
                                                    runat="server">
                                                    <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                    <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                    <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="text-center">
                                            <asp:Button ID="btnCreateProcessOccupancyStandard" runat="server" class="btn btn-success btn-fill btn-wd"
                                                Text="Add" />
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <hr />
                                    </div>
                                    <div id="annual-reexamination">
                                        <h6>
                                            Annual Reexamination &nbsp; &nbsp; &nbsp;
                                            <%
                                                If processes.Count > 0 Then
                                                     If processes.Contains("7") Then
                                                        Response.Write("<input type='checkbox' name='processAnnualReexamination' checked='checked' />")
                                                     Else
                                                        Response.Write("<input type='checkbox' name='processAnnualReexamination' />")
                                                     End If
                                                Else
                                                    Response.Write("<input type='checkbox' name='processAnnualReexamination' />")
                                                End If
                                             %>
                                        </h6>
                                        <br />
                                        <%
                                            conn.Open()
                                            Dim errorAnnualReexaminationID As Integer
                                            Dim detailsAnnualReexamination As String
                                            Dim noticeTypeAnnualReexamination As String
                                            Dim statusAnnualReexamination As String
                                            Dim errorStaffNameAnnualReexamination As String
                                            Dim errorReviewTypeIDAnnualReexamination As Integer
                                            Dim processAnnualReexaminationID As Integer
                                            
                                            Dim queryAnnualReexamination As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID  FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE fk_FileID = '" & fileID & "' AND fk_ProcessTypeID = 7 ORDER BY NoticeTypes.Notice", conn)
                                            Dim readerAnnualReexamination As SqlDataReader = queryAnnualReexamination.ExecuteReader()
                                            If readerAnnualReexamination.HasRows Then
                                                While readerAnnualReexamination.Read
                                                    errorAnnualReexaminationID = CStr(readerAnnualReexamination("ErrorID"))
                                                    detailsAnnualReexamination = CStr(readerAnnualReexamination("Details"))
                                                    noticeTypeAnnualReexamination = CStr(readerAnnualReexamination("Notice"))
                                                    statusAnnualReexamination = CStr(readerAnnualReexamination("Status"))
                                                    errorStaffNameAnnualReexamination = CStr(readerAnnualReexamination("ErrorStaffName"))
                                                    errorReviewTypeIDAnnualReexamination = CStr(readerAnnualReexamination("fk_ReviewTypeID"))
                                                    processAnnualReexaminationID = CStr(readerAnnualReexamination("fk_ProcessTypeID"))
                                        %>
                                        <div class="col-md-2">
                                            <h6>
                                                Notice</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeAnnualReexamination) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <h6>
                                                Comments</h6>
                                            <br />
                                            <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsAnnualReexamination)%></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <h6>
                                                Staff</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameAnnualReexamination) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <h6>
                                                Status</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusAnnualReexamination) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="text-center">
                                            <br />
                                            <br />
                                            <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorAnnualReexaminationID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDAnnualReexamination) %>&ProcessTypeID=<% Response.Write(processAnnualReexaminationID) %>"
                                                class="btn btn-warning btn-fill btn-wd">Edit</a>
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <br />
                                        <%
                                        End While
                                    End If
                                    conn.Close()
                                        %>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="NoticeTypeAnnualReexamination" runat="server" class="form-control border-input"
                                                    DataSourceID="SqlNoticeTypeAnnualReexamination" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeAnnualReexamination" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <textarea class="form-control border-input" cols="4" name="commentAnnualReexamination"
                                                    placeholder="Comment" rows="1"></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="CaseManagerAnnualReexamination" runat="server" class="form-control border-input"
                                                    DataSourceID="SqlCaseManagerAnnualReexamination" DataValueField="UserID" DataTextField="FullName"
                                                    required="required">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlCaseManagerAnnualReexamination" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                    SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="StatusAnnualReexamination" class="form-control border-input"
                                                    runat="server">
                                                    <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                    <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                    <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="text-center">
                                            <asp:Button ID="btnCreateProcessAnnualReexamination" runat="server" class="btn btn-success btn-fill btn-wd"
                                                Text="Add" />
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <hr />
                                    </div>
                                    <div id="change-in-family-composition">
                                        <h6>
                                            Change in Family Composition &nbsp; &nbsp; &nbsp;
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
                                            <h6>
                                                Notice</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeChangeInFamilyComposition) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <h6>
                                                Comments</h6>
                                            <br />
                                            <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsChangeInFamilyComposition)%></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <h6>
                                                Staff</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameChangeInFamilyComposition) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <h6>
                                                Status</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusChangeInFamilyComposition) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="text-center">
                                            <br />
                                            <br />
                                            <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorChangeInFamilyCompositionID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDChangeInFamilyComposition) %>&ProcessTypeID=<% Response.Write(processChangeInFamilyCompositionID) %>"
                                                class="btn btn-warning btn-fill btn-wd">Edit</a>
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <br />
                                        <%
                                        End While
                                    End If
                                    conn.Close()
                                        %>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="NoticeTypeChangeInFamilyComposition" runat="server" class="form-control border-input"
                                                    DataSourceID="SqlNoticeTypeChangeInFamilyComposition" DataTextField="Notice"
                                                    DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeChangeInFamilyComposition" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4'">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <textarea class="form-control border-input" cols="4" name="commentChangeInFamilyComposition"
                                                    placeholder="Comment" rows="1"></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="CaseManagerChangeInFamilyComposition" runat="server" class="form-control border-input"
                                                    DataSourceID="SqlCaseManagerChangeInFamilyComposition" DataValueField="UserID"
                                                    DataTextField="FullName" required="required">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlCaseManagerChangeInFamilyComposition" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                    SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="StatusChangeInFamilyComposition" class="form-control border-input"
                                                    runat="server">
                                                    <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                    <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                    <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                        <div class="text-center">
                                            <asp:Button ID="btnCreateProcessChangeInFamilyComposition" runat="server" class="btn btn-success btn-fill btn-wd"
                                                Text="Add" />
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <hr />
                                    </div>
                                    <div id="data-entry">
                                        <h6>
                                            Data Entry &nbsp; &nbsp; &nbsp;
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
                                            <h6>
                                                Notice</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDataEntry) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <h6>
                                                Comments</h6>
                                            <br />
                                            <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDataEntry)%></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <h6>
                                                Staff</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDataEntry) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <h6>
                                                Status</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDataEntry) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="text-center">
                                            <br />
                                            <br />
                                            <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDataEntryID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDDataEntry) %>&ProcessTypeID=<% Response.Write(processDataEntryID) %>"
                                                class="btn btn-warning btn-fill btn-wd">Edit</a>
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <br />
                                        <%
                                        End While
                                    End If
                                    conn.Close()
                                        %>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="NoticeTypeDataEntry" runat="server" class="form-control border-input"
                                                    DataSourceID="SqlNoticeTypeDataEntry" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeDataEntry" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
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
                                                    DataSourceID="SqlCaseManagerDataEntry" DataValueField="UserID" DataTextField="FullName"
                                                    required="required">
                                                </asp:DropDownList>
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
                                            <asp:Button ID="btnCreateProcessDataEntry" runat="server" class="btn btn-success btn-fill btn-wd"
                                                Text="Add" />
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <hr />
                                    </div>
                                    <div id="process-other">
                                        <h6>
                                            Other &nbsp; &nbsp; &nbsp;
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
                                            <h6>
                                                Notice</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeOther) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <h6>
                                                Comments</h6>
                                            <br />
                                            <div class="form-group">
                                                <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsOther)%></textarea>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <h6>
                                                Staff</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameOther) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <h6>
                                                Status</h6>
                                            <br />
                                            <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusOther) %>"
                                                    type="text" />
                                            </div>
                                        </div>
                                        <div class="text-center">
                                            <br />
                                            <br />
                                            <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorOtherID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDOther) %>&ProcessTypeID=<% Response.Write(processOtherID) %>"
                                                class="btn btn-warning btn-fill btn-wd">Edit</a>
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <br />
                                        <%
                                        End While
                                    End If
                                    conn.Close()
                                        %>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="NoticeTypeProcessOther" runat="server" class="form-control border-input"
                                                    DataSourceID="SqlNoticeTypeProcessOther" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeProcessOther" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
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
                                                    DataSourceID="SqlCaseManagerProcessOther" DataValueField="UserID" DataTextField="FullName"
                                                    required="required">
                                                </asp:DropDownList>
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
                                            <asp:Button ID="btnCreateProcessOther" runat="server" class="btn btn-success btn-fill btn-wd"
                                                Text="Add" />
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
                                                aria-expanded="true" aria-controls="collapseOne"><i class="fa fa-home" aria-hidden="true">
                                                </i>Leasing Documents </a>
                                        </h4>
                                    </div>
                                    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="panel-body">
                                            <hr />
                                            <div id="utility-allowance-checklist">
                                                <h6>
                                                    Utility Allowance Checklist &nbsp; &nbsp; &nbsp;
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
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentUtilityAllowanceChecklist) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentUtilityAllowanceChecklist)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentUtilityAllowanceChecklist) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentUtilityAllowanceChecklist) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentUtilityAllowanceChecklistID) %>&ReviewTypeID=<% Response.Write(errorDocumentUtilityAllowanceChecklistReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentUtilityAllowanceChecklistID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeUtilityAllowanceChecklist" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlNoticeTypeUtilityAllowanceChecklist" DataTextField="Notice"
                                                            DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlNoticeTypeUtilityAllowanceChecklist" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentUtilityAllowanceChecklist"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerUtilityAllowanceChecklist" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlCaseManagerUtilityAllowanceChecklist" DataValueField="UserID"
                                                            DataTextField="FullName">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerUtilityAllowanceChecklist" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusUtilityAllowanceChecklist" class="form-control border-input"
                                                            runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateUtilityAllowanceChecklist" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="lease">
                                                <h6>
                                                    Lease &nbsp; &nbsp; &nbsp;
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
                                                    Dim processDocumentLeaseID As Integer
                                                        
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
                                                            processDocumentLeaseID = CStr(readerDocumentLease("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentLease) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentLease)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentLease) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentLease) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentLeaseID) %>&ReviewTypeID=<% Response.Write(errorDocumentLeaseReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentLeaseID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeLease" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlNoticeTypeLease" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlNoticeTypeLease" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
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
                                                            DataSourceID="SqlCaseManagerLease" DataValueField="UserID" DataTextField="FullName">
                                                        </asp:DropDownList>
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
                                                    <asp:Button ID="btnCreateLease" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="hap-contract">
                                                <h6>
                                                    HAP Contract &nbsp; &nbsp; &nbsp;
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
                                                    Dim processDocumentHapContractID As Integer
                                                        
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
                                                            processDocumentHapContractID = CStr(readerDocumentHapContract("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentHapContract) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentHapContract)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentHapContract) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentHapContract) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentHapContractID) %>&ReviewTypeID=<% Response.Write(errorDocumentHapContractReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentHapContractID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeHapContract" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlNoticeTypeHapContract" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlNoticeTypeHapContract" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
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
                                                            DataSourceID="SqlCaseManagerHapContract" DataValueField="UserID" DataTextField="FullName">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerHapContract" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
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
                                                    <asp:Button ID="btnCreateHapContract" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="hud-tenancy-addedum">
                                                <h6>
                                                    HUD Tenancy Addedum &nbsp; &nbsp; &nbsp;
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
                                                    Dim processDocumentHudTenancyAddendumID As Integer
                                                        
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
                                                            processDocumentHudTenancyAddendumID = CStr(readerDocumentHudTenancyAddendum("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentHudTenancyAddendum) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentHudTenancyAddendum)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentHudTenancyAddendum) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentHudTenancyAddendum) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentHudTenancyAddendumID) %>&ReviewTypeID=<% Response.Write(errorDocumentHudTenancyAddendumReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentHudTenancyAddendumID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeHudTenancyAddendum" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlNoticeTypeHudTenancyAddendum" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlNoticeTypeHudTenancyAddendum" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentHudTenancyAddendum"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerHudTenancyAddendum" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlCaseManagerHudTenancyAddendum" DataValueField="UserID" DataTextField="FullName">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerHudTenancyAddendum" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusHudTenancyAddendum" class="form-control border-input"
                                                            runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateHudTenancyAddendum" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
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
                                                href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo"><i class="fa fa-shield"
                                                    aria-hidden="true"></i>Master Documents</a>
                                        </h4>
                                    </div>
                                    <div id="collapseTwo" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                                        <div class="panel-body">
                                            <hr />
                                            <div id="master-family-documents-checklist ">
                                                <h6>
                                                    Master Family Documents Checklist &nbsp; &nbsp; &nbsp;
                                                    <%
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
                                                    Dim processDocumentMasterFamilyDocumentsChecklistID As Integer
                                                        
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
                                                            processDocumentMasterFamilyDocumentsChecklistID = CStr(readerDocumentMasterFamilyDocumentsChecklist("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentMasterFamilyDocumentsChecklist) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentMasterFamilyDocumentsChecklist)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentMasterFamilyDocumentsChecklist) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentMasterFamilyDocumentsChecklist) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentMasterFamilyDocumentsChecklistID) %>&ReviewTypeID=<% Response.Write(errorDocumentMasterFamilyDocumentsChecklistReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentMasterFamilyDocumentsChecklistID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeMasterFamilyDocumentsChecklist" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlNoticeTypeMasterFamilyDocumentsChecklist" DataTextField="Notice"
                                                            DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlNoticeTypeMasterFamilyDocumentsChecklist" runat="server"
                                                            ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentMasterFamilyDocumentsChecklist"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerMasterFamilyDocumentsChecklist" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlCaseManagerMasterFamilyDocumentsChecklist" DataValueField="UserID"
                                                            DataTextField="FullName">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerMasterFamilyDocumentsChecklist" runat="server"
                                                            ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusMasterFamilyDocumentsChecklist" class="form-control border-input"
                                                            runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateMasterFamilyDocumentsChecklist" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="valid-photo-identification">
                                                <h6>
                                                    Valid Photo Identification &nbsp; &nbsp; &nbsp;
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
                                                    Dim processDocumentValidPhotoIdentificationID As Integer
                                                        
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
                                                            processDocumentValidPhotoIdentificationID = CStr(readerDocumentValidPhotoIdentification("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentValidPhotoIdentification) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentValidPhotoIdentification)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentValidPhotoIdentification) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentValidPhotoIdentification) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentValidPhotoIdentificationID) %>&ReviewTypeID=<% Response.Write(errorDocumentValidPhotoIdentificationReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentValidPhotoIdentificationID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeValidPhotoIdentification" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlNoticeTypeValidPhotoIdentification" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlNoticeTypeValidPhotoIdentification" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentValidPhotoIdentification"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerValidPhotoIdentification" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlCaseManagerValidPhotoIdentification" DataValueField="UserID"
                                                            DataTextField="FullName">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerValidPhotoIdentification" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusValidPhotoIdentification" class="form-control border-input"
                                                            runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateValidPhotoIdentification" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="proof-of-social-security-number">
                                                <h6>
                                                    Proof of Social Security Number &nbsp; &nbsp; &nbsp;
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
                                                    Dim processDocumentProofOfSocialSecurityNumberID As Integer
                                                        
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
                                                            processDocumentProofOfSocialSecurityNumberID = CStr(readerDocumentProofOfSocialSecurityNumber("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentProofOfSocialSecurityNumber) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentProofOfSocialSecurityNumber)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentProofOfSocialSecurityNumber) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentProofOfSocialSecurityNumber) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentProofOfSocialSecurityNumberID) %>&ReviewTypeID=<% Response.Write(errorDocumentProofOfSocialSecurityNumberReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentProofOfSocialSecurityNumberID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeProofOfSocialSecurityNumber" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlNoticeTypeProofOfSocialSecurityNumber" DataTextField="Notice"
                                                            DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlNoticeTypeProofOfSocialSecurityNumber" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentProofOfSocialSecurityNumber"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerProofOfSocialSecurityNumber" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlCaseManagerProofOfSocialSecurityNumber" DataValueField="UserID"
                                                            DataTextField="FullName">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerProofOfSocialSecurityNumber" runat="server"
                                                            ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusProofOfSocialSecurityNumber" class="form-control border-input"
                                                            runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateProofOfSocialSecurityNumber" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="proof-of-birth-date">
                                                <h6>
                                                    Proof of Birth Date &nbsp; &nbsp; &nbsp;
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
                                                    Dim processDocumentProofOfBirthDateID As Integer
                                                        
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
                                                            processDocumentProofOfBirthDateID = CStr(readerDocumentProofOfBirthDate("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentProofOfBirthDate) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentProofOfBirthDate)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentProofOfBirthDate) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentProofOfBirthDate) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentProofOfBirthDateID) %>&ReviewTypeID=<% Response.Write(errorDocumentProofOfBirthDateReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentProofOfBirthDateID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeProofOfBirthDate" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlNoticeTypeProofOfBirthDate" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlNoticeTypeProofOfBirthDate" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentProofOfBirthDate"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerProofOfBirthDate" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlCaseManagerProofOfBirthDate" DataValueField="UserID" DataTextField="FullName">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerProofOfBirthDate" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
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
                                                    <asp:Button ID="btnCreateProofOfBirthDate" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="proof-of-name-change">
                                                <h6>
                                                    Proof of Name Change (If applicable)
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
                                                    Dim processDocumentProofOfNameChangeIfApplicableID As Integer
                                                        
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
                                                            processDocumentProofOfNameChangeIfApplicableID = CStr(readerDocumentProofOfNameChangeIfApplicable("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentProofOfNameChangeIfApplicable) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentProofOfNameChangeIfApplicable)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentProofOfNameChangeIfApplicable) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentProofOfNameChangeIfApplicable) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentProofOfNameChangeIfApplicableID) %>&ReviewTypeID=<% Response.Write(errorDocumentProofOfNameChangeIfApplicableReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentProofOfNameChangeIfApplicableID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeProofOfNameChangeIfApplicable" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlNoticeTypeProofOfNameChangeIfApplicable" DataTextField="Notice"
                                                            DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlNoticeTypeProofOfNameChangeIfApplicable" runat="server"
                                                            ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentProofOfNameChangeIfApplicable"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerProofOfNameChangeIfApplicable" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlCaseManagerProofOfNameChangeIfApplicable" DataValueField="UserID"
                                                            DataTextField="FullName">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerProofOfNameChangeIfApplicable" runat="server"
                                                            ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusProofOfNameChangeIfApplicable" class="form-control border-input"
                                                            runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateProofOfNameChangeIfApplicable" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="proof-of-eligible-immigration-status">
                                                <h6>
                                                    Proof of Eligible Immigration Status
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
                                                    Dim processDocumentProofOfEligibleImmigrationStatusID As Integer
                                                        
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
                                                            processDocumentProofOfEligibleImmigrationStatusID = CStr(readerDocumentProofOfEligibleImmigrationStatus("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentProofOfEligibleImmigrationStatus) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentProofOfEligibleImmigrationStatus)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentProofOfEligibleImmigrationStatus) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentProofOfEligibleImmigrationStatus) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentProofOfEligibleImmigrationStatusID) %>&ReviewTypeID=<% Response.Write(errorDocumentProofOfEligibleImmigrationStatusReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentProofOfEligibleImmigrationStatusID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
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
                                                        <textarea class="form-control border-input" cols="4" name="commentProofOfEligibleImmigrationStatus"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerProofOfEligibleImmigrationStatus" runat="server"
                                                            class="form-control border-input" DataSourceID="SqlCaseManagerProofOfEligibleImmigrationStatus"
                                                            DataValueField="UserID" DataTextField="FullName">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerProofOfEligibleImmigrationStatus" runat="server"
                                                            ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusProofOfEligibleImmigrationStatus" class="form-control border-input"
                                                            runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateProofOfEligibleImmigrationStatus" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="declaration-of-citizenship-or-eligible-immigration-status">
                                                <h6>
                                                    Declaration of Citizenship or Eligible Immigration Status
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
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatus) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatusID) %>&ReviewTypeID=<% Response.Write(errorDocumentDeclarationOfCitizenshipOrEligibleImmigrationStatusReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDeclarationOfCitizenshipOrEligibleImmigrationStatusID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeDeclarationOfCitizenshipOrEligibleImmigrationStatus"
                                                            runat="server" class="form-control border-input" DataSourceID="SqlNoticeTypeDeclarationOfCitizenshipOrEligibleImmigrationStatus"
                                                            DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlNoticeTypeDeclarationOfCitizenshipOrEligibleImmigrationStatus"
                                                            runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentDeclarationOfCitizenshipOrEligibleImmigrationStatus"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerDeclarationOfCitizenshipOrEligibleImmigrationStatus"
                                                            runat="server" class="form-control border-input" DataSourceID="SqlCaseManagerDeclarationOfCitizenshipOrEligibleImmigrationStatus"
                                                            DataValueField="UserID" DataTextField="FullName">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerDeclarationOfCitizenshipOrEligibleImmigrationStatus"
                                                            runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusDeclarationOfCitizenshipOrEligibleImmigrationStatus"
                                                            class="form-control border-input" runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateDeclarationOfCitizenshipOrEligibleImmigrationStatus" runat="server"
                                                        class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="debts-owed-to-pha-and-terminations">
                                                <h6>
                                                    Debts Owed to PHA and Terminations (HUD 52675)
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
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentDebtsOwedToPhaAndTerminationsHud52675) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentDebtsOwedToPhaAndTerminationsHud52675)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentDebtsOwedToPhaAndTerminationsHud52675) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentDebtsOwedToPhaAndTerminationsHud52675) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentDebtsOwedToPhaAndTerminationsHud52675ID) %>&ReviewTypeID=<% Response.Write(errorDocumentDebtsOwedToPhaAndTerminationsHud52675ReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentDebtsOwedToPhaAndTerminationsHud52675ID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
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
                                                        <textarea class="form-control border-input" cols="4" name="commentDebtsOwedToPhaAndTerminationsHud52675"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerDebtsOwedToPhaAndTerminationsHud52675" runat="server"
                                                            class="form-control border-input" DataSourceID="SqlCaseManagerDebtsOwedToPhaAndTerminationsHud52675"
                                                            DataValueField="UserID" DataTextField="FullName">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerDebtsOwedToPhaAndTerminationsHud52675" runat="server"
                                                            ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusDebtsOwedToPhaAndTerminationsHud52675" class="form-control border-input"
                                                            runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateDebtsOwedToPhaAndTerminationsHud52675" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="hud-supplement-sheet-hud-92006">
                                                <h6>
                                                    HUD Supplement Sheet (HUD 92006)
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
                                                    Dim processDocumentHudSupplementSheetHud92006ListID As Integer
                                                        
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
                                                            processDocumentHudSupplementSheetHud92006ListID = CStr(readerDocumentHudSupplementSheetHud92006("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentHudSupplementSheetHud92006) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentHudSupplementSheetHud92006)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentHudSupplementSheetHud92006) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentHudSupplementSheetHud92006) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentHudSupplementSheetHud92006ID) %>&ReviewTypeID=<% Response.Write(errorDocumentHudSupplementSheetHud92006ReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentHudSupplementSheetHud92006ListID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeHudSupplementSheetHud92006" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlNoticeTypeHudSupplementSheetHud92006" DataTextField="Notice"
                                                            DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlNoticeTypeHudSupplementSheetHud92006" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentHudSupplementSheetHud92006"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerHudSupplementSheetHud92006" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlCaseManagerHudSupplementSheetHud92006" DataValueField="UserID"
                                                            DataTextField="FullName">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerHudSupplementSheetHud92006" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusHudSupplementSheetHud92006" class="form-control border-input"
                                                            runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateHudSupplementSheetHud92006" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="vama-client-notice">
                                                <h6>
                                                    VAWA – Client Notice
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
                                                    Dim processDocumentVawaClientNoticeID As Integer
                                                        
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
                                                            processDocumentVawaClientNoticeID = CStr(readerDocumentVawaClientNotice("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentVawaClientNotice) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentVawaClientNotice)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentVawaClientNotice) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentVawaClientNotice) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentVawaClientNoticeID) %>&ReviewTypeID=<% Response.Write(errorDocumentVawaClientNoticeReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentVawaClientNoticeID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeVawaClientNotice" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlNoticeTypeVawaClientNotice" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlNoticeTypeVawaClientNotice" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentVawaClientNotice"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerVawaClientNotice" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlCaseManagerVawaClientNotice" DataValueField="UserID" DataTextField="FullName">
                                                        </asp:DropDownList>
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
                                                    <asp:Button ID="btnCreateVawaClientNotice" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="signed-original-voucher">
                                                <h6>
                                                    Signed Original Voucher
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
                                                    Dim processSignedOriginalVoucherID As Integer
                                                        
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
                                                            processSignedOriginalVoucherID = CStr(readerDocumentSignedOriginalVoucher("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentSignedOriginalVoucher) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentSignedOriginalVoucher)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentSignedOriginalVoucher) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentSignedOriginalVoucher) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentSignedOriginalVoucherID) %>&ReviewTypeID=<% Response.Write(errorDocumentSignedOriginalVoucherReviewTypeID) %>&ProcessTypeID=<% Response.Write(processSignedOriginalVoucherID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeSignedOriginalVoucher" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlNoticeTypeSignedOriginalVoucher" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlNoticeTypeSignedOriginalVoucher" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentSignedOriginalVoucher"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerSignedOriginalVoucher" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlCaseManagerSignedOriginalVoucher" DataValueField="UserID" DataTextField="FullName">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerSignedOriginalVoucher" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusSignedOriginalVoucher" class="form-control border-input"
                                                            runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateSignedOriginalVoucher" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="criminal-background-screening-determination">
                                                <h6>
                                                    Criminal Background Screening Determination
                                                     &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("65") Then
                                                                 Response.Write("<input type='checkbox' name='documentCriminalBackgroundScreeningDetermination' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentCriminalBackgroundScreeningDetermination' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentCriminalBackgroundScreeningDetermination' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                <%
                                                    conn.Open()
                                                    Dim errorDocumentCriminalBackgroundScreeningDeterminationErrorID As Integer
                                                    Dim errorDocumentCriminalBackgroundScreeningDeterminationID As Integer
                                                    Dim detailsDocumentCriminalBackgroundScreeningDetermination As String
                                                    Dim noticeTypeDocumentCriminalBackgroundScreeningDetermination As String
                                                    Dim statusDocumentCriminalBackgroundScreeningDetermination As String
                                                    Dim errorStaffNameDocumentCriminalBackgroundScreeningDetermination As String
                                                    Dim errorDocumentCriminalBackgroundScreeningDeterminationReviewTypeID As Integer
                                                    Dim errorsCriminalBackgroundScreeningDeterminationList As New ArrayList
                                                    Dim processDocumentCriminalBackgroundScreeningDeterminationID As Integer
                                                        
                                                    Dim queryDocumentCriminalBackgroundScreeningDeterminationError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '65' AND fk_FileID = '" & fileID & "'", conn)
                                                    Dim readerDocumentCriminalBackgroundScreeningDeterminationError As SqlDataReader = queryDocumentCriminalBackgroundScreeningDeterminationError.ExecuteReader()
                                                    If readerDocumentCriminalBackgroundScreeningDeterminationError.HasRows Then
                                                        While readerDocumentCriminalBackgroundScreeningDeterminationError.Read
                                                            errorDocumentCriminalBackgroundScreeningDeterminationErrorID = CStr(readerDocumentCriminalBackgroundScreeningDeterminationError("fk_ErrorID"))
                                                            errorsCriminalBackgroundScreeningDeterminationList.Add(errorDocumentCriminalBackgroundScreeningDeterminationErrorID)
                                                        End While
                                                    End If
                                                    conn.Close()
                                           
                                                    conn.Open()
                                                    Dim errorCriminalBackgroundScreeningDeterminationIndex As Integer
                                                    For Each errorCriminalBackgroundScreeningDeterminationIndex In errorsCriminalBackgroundScreeningDeterminationList
                                                        Dim queryDocumentCriminalBackgroundScreeningDetermination As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorCriminalBackgroundScreeningDeterminationIndex & "'", conn)
                                                        Dim readerDocumentCriminalBackgroundScreeningDetermination As SqlDataReader = queryDocumentCriminalBackgroundScreeningDetermination.ExecuteReader()
                                                        While readerDocumentCriminalBackgroundScreeningDetermination.Read
                                                            errorDocumentCriminalBackgroundScreeningDeterminationID = CStr(readerDocumentCriminalBackgroundScreeningDetermination("ErrorID"))
                                                            detailsDocumentCriminalBackgroundScreeningDetermination = CStr(readerDocumentCriminalBackgroundScreeningDetermination("Details"))
                                                            noticeTypeDocumentCriminalBackgroundScreeningDetermination = CStr(readerDocumentCriminalBackgroundScreeningDetermination("Notice"))
                                                            statusDocumentCriminalBackgroundScreeningDetermination = CStr(readerDocumentCriminalBackgroundScreeningDetermination("Status"))
                                                            errorStaffNameDocumentCriminalBackgroundScreeningDetermination = CStr(readerDocumentCriminalBackgroundScreeningDetermination("ErrorStaffName"))
                                                            errorDocumentCriminalBackgroundScreeningDeterminationReviewTypeID = CStr(readerDocumentCriminalBackgroundScreeningDetermination("fk_ReviewTypeID"))
                                                            processDocumentCriminalBackgroundScreeningDeterminationID = CStr(readerDocumentCriminalBackgroundScreeningDetermination("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentCriminalBackgroundScreeningDetermination) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentCriminalBackgroundScreeningDetermination)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentCriminalBackgroundScreeningDetermination) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentCriminalBackgroundScreeningDetermination) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentCriminalBackgroundScreeningDeterminationID) %>&ReviewTypeID=<% Response.Write(errorDocumentCriminalBackgroundScreeningDeterminationReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentCriminalBackgroundScreeningDeterminationID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeCriminalBackgroundScreeningDetermination" runat="server"
                                                            class="form-control border-input" DataSourceID="SqlNoticeTypeCriminalBackgroundScreeningDetermination"
                                                            DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlNoticeTypeCriminalBackgroundScreeningDetermination" runat="server"
                                                            ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentCriminalBackgroundScreeningDetermination"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerCriminalBackgroundScreeningDetermination" runat="server"
                                                            class="form-control border-input" DataSourceID="SqlCaseManagerCriminalBackgroundScreeningDetermination"
                                                            DataValueField="UserID" DataTextField="FullName" required="required">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerCriminalBackgroundScreeningDetermination" runat="server"
                                                            ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusCriminalBackgroundScreeningDetermination" class="form-control border-input"
                                                            runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateCriminalBackgroundScreeningDetermination" runat="server"
                                                        class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="criminal-background-screening-request">
                                                <h6>
                                                    Criminal Background Screening Request
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("66") Then
                                                                Response.Write("<input type='checkbox' name='documentCriminalBackgroundScreeningRequest' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentCriminalBackgroundScreeningRequest' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentCriminalBackgroundScreeningRequest' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                <%
                                                    conn.Open()
                                                    Dim errorDocumentCriminalBackgroundScreeningRequestErrorID As Integer
                                                    Dim errorDocumentCriminalBackgroundScreeningRequestID As Integer
                                                    Dim detailsDocumentCriminalBackgroundScreeningRequest As String
                                                    Dim noticeTypeDocumentCriminalBackgroundScreeningRequest As String
                                                    Dim statusDocumentCriminalBackgroundScreeningRequest As String
                                                    Dim errorStaffNameDocumentCriminalBackgroundScreeningRequest As String
                                                    Dim errorDocumentCriminalBackgroundScreeningRequestReviewTypeID As Integer
                                                    Dim errorsCriminalBackgroundScreeningRequestList As New ArrayList
                                                    Dim processCriminalBackgroundScreeningRequestID As Integer
                                                        
                                                    Dim queryDocumentCriminalBackgroundScreeningRequestError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '66' AND fk_FileID = '" & fileID & "'", conn)
                                                    Dim readerDocumentCriminalBackgroundScreeningRequestError As SqlDataReader = queryDocumentCriminalBackgroundScreeningRequestError.ExecuteReader()
                                                    If readerDocumentCriminalBackgroundScreeningRequestError.HasRows Then
                                                        While readerDocumentCriminalBackgroundScreeningRequestError.Read
                                                            errorDocumentCriminalBackgroundScreeningRequestErrorID = CStr(readerDocumentCriminalBackgroundScreeningRequestError("fk_ErrorID"))
                                                            errorsCriminalBackgroundScreeningRequestList.Add(errorDocumentCriminalBackgroundScreeningRequestErrorID)
                                                        End While
                                                    End If
                                                    conn.Close()
                                           
                                                    conn.Open()
                                                    Dim errorCriminalBackgroundScreeningRequestIndex As Integer
                                                    For Each errorCriminalBackgroundScreeningRequestIndex In errorsCriminalBackgroundScreeningRequestList
                                                        Dim queryDocumentCriminalBackgroundScreeningRequest As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorCriminalBackgroundScreeningRequestIndex & "'", conn)
                                                        Dim readerDocumentCriminalBackgroundScreeningRequest As SqlDataReader = queryDocumentCriminalBackgroundScreeningRequest.ExecuteReader()
                                                        While readerDocumentCriminalBackgroundScreeningRequest.Read
                                                            errorDocumentCriminalBackgroundScreeningRequestID = CStr(readerDocumentCriminalBackgroundScreeningRequest("ErrorID"))
                                                            detailsDocumentCriminalBackgroundScreeningRequest = CStr(readerDocumentCriminalBackgroundScreeningRequest("Details"))
                                                            noticeTypeDocumentCriminalBackgroundScreeningRequest = CStr(readerDocumentCriminalBackgroundScreeningRequest("Notice"))
                                                            statusDocumentCriminalBackgroundScreeningRequest = CStr(readerDocumentCriminalBackgroundScreeningRequest("Status"))
                                                            errorStaffNameDocumentCriminalBackgroundScreeningRequest = CStr(readerDocumentCriminalBackgroundScreeningRequest("ErrorStaffName"))
                                                            errorDocumentCriminalBackgroundScreeningRequestReviewTypeID = CStr(readerDocumentCriminalBackgroundScreeningRequest("fk_ReviewTypeID"))
                                                            processCriminalBackgroundScreeningRequestID = CStr(readerDocumentCriminalBackgroundScreeningRequest("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentCriminalBackgroundScreeningRequest) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentCriminalBackgroundScreeningRequest)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentCriminalBackgroundScreeningRequest) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentCriminalBackgroundScreeningRequest) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentCriminalBackgroundScreeningRequestID) %>&ReviewTypeID=<% Response.Write(errorDocumentCriminalBackgroundScreeningRequestReviewTypeID) %>&ProcessTypeID=<% Response.Write(processCriminalBackgroundScreeningRequestID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeCriminalBackgroundScreeningRequest" runat="server"
                                                            class="form-control border-input" DataSourceID="SqlNoticeTypeCriminalBackgroundScreeningRequest"
                                                            DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlNoticeTypeCriminalBackgroundScreeningRequest" runat="server"
                                                            ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentCriminalBackgroundScreeningRequest"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerCriminalBackgroundScreeningRequest" runat="server"
                                                            class="form-control border-input" DataSourceID="SqlCaseManagerCriminalBackgroundScreeningRequest"
                                                            DataValueField="UserID" DataTextField="FullName" required="required">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerCriminalBackgroundScreeningRequest" runat="server"
                                                            ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusCriminalBackgroundScreeningRequest" class="form-control border-input"
                                                            runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateCriminalBackgroundScreeningRequest" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
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
                                                href="#collapseThree" aria-expanded="false" aria-controls="collapseThree"><i class="fa fa-sticky-note"
                                                    aria-hidden="true"></i>Notes / Portability Billing / Compliance</a>
                                        </h4>
                                    </div>
                                    <div id="collapseThree" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingThree">
                                        <div class="panel-body">
                                            <hr />
                                            <div id="notes">
                                                <h6>
                                                    Notes
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
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentNotes) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentNotes)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentNotes) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentNotes) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentNotesID) %>&ReviewTypeID=<% Response.Write(errorDocumentNotesReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentNotesID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeNotes" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlNoticeTypeNotes" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlNoticeTypeNotes" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
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
                                                            DataSourceID="SqlCaseManagerNotes" DataValueField="UserID" DataTextField="FullName">
                                                        </asp:DropDownList>
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
                                                    <asp:Button ID="btnCreateNotes" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="other">
                                                <h6>
                                                    Other
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
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentOther) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentOther)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentOther) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentOther) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentOtherID) %>&ReviewTypeID=<% Response.Write(errorDocumentOtherReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentOtherID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeDocumentOther" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlDocumentOther" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlDocumentOther" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2' ORDER BY [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentDocumentOther"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerDocumentOther" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlCaseManagerDocumentOther" DataValueField="UserID" DataTextField="FullName">
                                                        </asp:DropDownList>
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
                                                    <asp:Button ID="btnCreateDocumentOther" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel panel-success">
                                    <div class="panel-heading" role="tab" id="headingFour">
                                        <h4 class="panel-title">
                                            <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion"
                                                href="#collapseFour" aria-expanded="false" aria-controls="collapseFour"><i class="fa fa-certificate"
                                                    aria-hidden="true"></i>Recertification Documents</a>
                                        </h4>
                                    </div>
                                    <div id="collapseFour" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingFour">
                                        <div class="panel-body">
                                            <div id="recertification-checklist">
                                                <h6>
                                                    Recertification Checklist
                                                    &nbsp; &nbsp; &nbsp;
                                                     <%
                                                        If documents.Count > 0 Then
                                                             If documents.Contains("57") Then
                                                                 Response.Write("<input type='checkbox' name='documentRecertificationChecklist' checked='checked' />")
                                                             Else
                                                                 Response.Write("<input type='checkbox' name='documentRecertificationChecklist' />")
                                                             End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentRecertificationChecklist' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                <%
                                                    conn.Open()
                                                    Dim errorDocumentRecertificationChecklistErrorID As Integer
                                                    Dim errorDocumentRecertificationChecklistID As Integer
                                                    Dim detailsDocumentRecertificationChecklist As String
                                                    Dim noticeTypeDocumentRecertificationChecklist As String
                                                    Dim statusDocumentRecertificationChecklist As String
                                                    Dim errorStaffNameDocumentRecertificationChecklist As String
                                                    Dim errorDocumentRecertificationChecklistReviewTypeID As Integer
                                                    Dim errorsRecertificationChecklistList As New ArrayList
                                                    Dim processDocumentRecertificationChecklistID As Integer
                                                        
                                                    Dim queryDocumentRecertificationChecklistError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '57' AND fk_FileID = '" & fileID & "'", conn)
                                                    Dim readerDocumentRecertificationChecklistError As SqlDataReader = queryDocumentRecertificationChecklistError.ExecuteReader()
                                                    If readerDocumentRecertificationChecklistError.HasRows Then
                                                        While readerDocumentRecertificationChecklistError.Read
                                                            errorDocumentRecertificationChecklistErrorID = CStr(readerDocumentRecertificationChecklistError("fk_ErrorID"))
                                                            errorsRecertificationChecklistList.Add(errorDocumentRecertificationChecklistErrorID)
                                                        End While
                                                    End If
                                                    conn.Close()
                                           
                                                    conn.Open()
                                                    Dim errorRecertificationChecklistIndex As Integer
                                                    For Each errorRecertificationChecklistIndex In errorsRecertificationChecklistList
                                                        Dim queryDocumentRecertificationChecklist As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorRecertificationChecklistIndex & "'", conn)
                                                        Dim readerDocumentRecertificationChecklist As SqlDataReader = queryDocumentRecertificationChecklist.ExecuteReader()
                                                        While readerDocumentRecertificationChecklist.Read
                                                            errorDocumentRecertificationChecklistID = CStr(readerDocumentRecertificationChecklist("ErrorID"))
                                                            detailsDocumentRecertificationChecklist = CStr(readerDocumentRecertificationChecklist("Details"))
                                                            noticeTypeDocumentRecertificationChecklist = CStr(readerDocumentRecertificationChecklist("Notice"))
                                                            statusDocumentRecertificationChecklist = CStr(readerDocumentRecertificationChecklist("Status"))
                                                            errorStaffNameDocumentRecertificationChecklist = CStr(readerDocumentRecertificationChecklist("ErrorStaffName"))
                                                            errorDocumentRecertificationChecklistReviewTypeID = CStr(readerDocumentRecertificationChecklist("fk_ReviewTypeID"))
                                                            processDocumentRecertificationChecklistID = CStr(readerDocumentRecertificationChecklist("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentRecertificationChecklist) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentRecertificationChecklist)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentRecertificationChecklist) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentRecertificationChecklist) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentRecertificationChecklistID) %>&ReviewTypeID=<% Response.Write(errorDocumentRecertificationChecklistReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentRecertificationChecklistID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeRecertificationChecklist" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlRecertificationChecklist" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlRecertificationChecklist" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2' ORDER BY [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentRecertificationChecklist"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerRecertificationChecklist" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlCaseManagerRecertificationChecklist" DataValueField="UserID"
                                                            DataTextField="FullName">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerRecertificationChecklist" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusRecertificationChecklist" class="form-control border-input"
                                                            runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateRecertificationChecklist" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="rent-letter-tenant">
                                                <h6>
                                                    Rent Letter – Tenant
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
                                                    Dim processRentLetterTenantID As Integer
                                                        
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
                                                            processRentLetterTenantID = CStr(readerDocumentRentLetterTenant("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentRentLetterTenant) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentRentLetterTenant)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentRentLetterTenant) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentRentLetterTenant) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentRentLetterTenantID) %>&ReviewTypeID=<% Response.Write(errorDocumentRentLetterTenantReviewTypeID) %>&ProcessTypeID=<% Response.Write(processRentLetterTenantID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeRentLetterTenant" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlRentLetterTenant" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlRentLetterTenant" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2' ORDER BY [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentRentLetterTenant"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerRentLetterTenant" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlCaseManagerRentLetterTenant" DataValueField="UserID" DataTextField="FullName">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerRentLetterTenant" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
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
                                                    <asp:Button ID="btnCreateRentLetterTenant" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="rent-letter-owner">
                                                <h6>
                                                    Rent Letter – Owner
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
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentRentLetterOwner) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentRentLetterOwner)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentRentLetterOwner) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentRentLetterOwner) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentRentLetterOwnerID) %>&ReviewTypeID=<% Response.Write(errorDocumentRentLetterOwnerReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentRentLetterOwnerID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeRentLetterOwner" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlRentLetterOwner" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlRentLetterOwner" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2' ORDER BY [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentRentLetterOwner"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerRentLetterOwner" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlCaseManagerRentLetterOwner" DataValueField="UserID" DataTextField="FullName">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerRentLetterOwner" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
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
                                                    <asp:Button ID="btnCreateRentLetterOwner" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="hud-form-50058">
                                                <h6>
                                                    HUD Form 50058
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
                                                    Dim processHudForm50058ID As Integer
                                                        
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
                                                            processHudForm50058ID = CStr(readerDocumentHudForm50058("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentHudForm50058) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentHudForm50058)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentHudForm50058) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentHudForm50058) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentHudForm50058ID) %>&ReviewTypeID=<% Response.Write(errorDocumentHudForm50058ReviewTypeID) %>&ProcessTypeID=<% Response.Write(processHudForm50058ID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeHudForm50058" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlHudForm50058" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlHudForm50058" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
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
                                                            DataSourceID="SqlCaseManagerHudForm50058" DataValueField="UserID" DataTextField="FullName">
                                                        </asp:DropDownList>
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
                                                    <asp:Button ID="btnCreateHudForm50058" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="rent-calculation-sheet">
                                                <h6>
                                                    Rent Calculation Sheet
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
                                                    Dim processDocumentRentCalculationSheetID As Integer
                                                        
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
                                                            processDocumentRentCalculationSheetID = CStr(readerDocumentRentCalculationSheet("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentRentCalculationSheet) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentRentCalculationSheet)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentRentCalculationSheet) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentRentCalculationSheet) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentRentCalculationSheetID) %>&ReviewTypeID=<% Response.Write(errorDocumentRentCalculationSheetReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentRentCalculationSheetID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeRentCalculationSheet" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlRentCalculationSheet" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlRentCalculationSheet" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2' ORDER BY [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentRentCalculationSheet"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerRentCalculationSheet" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlCaseManagerRentCalculationSheet" DataValueField="UserID" DataTextField="FullName">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerRentCalculationSheet" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusRentCalculationSheet" class="form-control border-input"
                                                            runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateRentCalculationSheet" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="ua-calculation-worksheet-elite">
                                                <h6>
                                                    UA Calculation Worksheet - Elite
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
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentUaCalculationWorksheetElite) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentUaCalculationWorksheetElite)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentUaCalculationWorksheetElite) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentUaCalculationWorksheetElite) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentUaCalculationWorksheetEliteID) %>&ReviewTypeID=<% Response.Write(errorDocumentUaCalculationWorksheetEliteReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentUaCalculationWorksheetEliteID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeUaCalculationWorksheetElite" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlUaCalculationWorksheetElite" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlUaCalculationWorksheetElite" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2'">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentUaCalculationWorksheetElite"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerUaCalculationWorksheetElite" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlCaseManagerUaCalculationWorksheetElite" DataValueField="UserID"
                                                            DataTextField="FullName">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerUaCalculationWorksheetElite" runat="server"
                                                            ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusUaCalculationWorksheetElite" class="form-control border-input"
                                                            runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateUaCalculationWorksheetElite" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="application-for-continued-occupancy">
                                                <h6>
                                                    Application for Continued Occupancy
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
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentApplicationForContinuedOccupancy) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentApplicationForContinuedOccupancy)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentApplicationForContinuedOccupancy) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentApplicationForContinuedOccupancy) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentApplicationForContinuedOccupancyID) %>&ReviewTypeID=<% Response.Write(errorDocumentApplicationForContinuedOccupancyReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentApplicationForContinuedOccupancyID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
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
                                                        <asp:SqlDataSource ID="SqlApplicationForContinuedOccupancy" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2' ORDER BY [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentApplicationForContinuedOccupancy"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerApplicationForContinuedOccupancy" runat="server"
                                                            class="form-control border-input" DataSourceID="SqlCaseManagerApplicationForContinuedOccupancy"
                                                            DataValueField="UserID" DataTextField="FullName">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerApplicationForContinuedOccupancy" runat="server"
                                                            ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusApplicationForContinuedOccupancy" class="form-control border-input"
                                                            runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateApplicationForContinuedOccupancy" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="eiv-income-report">
                                                <h6>
                                                    EIV Income Report
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("63") Then
                                                                Response.Write("<input type='checkbox' name='documentEivIncomeReport' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentEivIncomeReport' />")
                                                            End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentEivIncomeReport' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                <%
                                                    conn.Open()
                                                    Dim errorDocumentEivIncomeReportErrorID As Integer
                                                    Dim errorDocumentEivIncomeReportID As Integer
                                                    Dim detailsDocumentEivIncomeReport As String
                                                    Dim noticeTypeDocumentEivIncomeReport As String
                                                    Dim statusDocumentEivIncomeReport As String
                                                    Dim errorStaffNameDocumentEivIncomeReport As String
                                                    Dim errorDocumentEivIncomeReportReviewTypeID As Integer
                                                    Dim errorsEivIncomeReportList As New ArrayList
                                                    Dim processDocumentEivIncomeReportID As Integer
                                                        
                                                    Dim queryDocumentEivIncomeReportError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '63' AND fk_FileID = '" & fileID & "'", conn)
                                                    Dim readerDocumentEivIncomeReportError As SqlDataReader = queryDocumentEivIncomeReportError.ExecuteReader()
                                                    If readerDocumentEivIncomeReportError.HasRows Then
                                                        While readerDocumentEivIncomeReportError.Read
                                                            errorDocumentEivIncomeReportErrorID = CStr(readerDocumentEivIncomeReportError("fk_ErrorID"))
                                                            errorsEivIncomeReportList.Add(errorDocumentEivIncomeReportErrorID)
                                                        End While
                                                    End If
                                                    conn.Close()
                                           
                                                    conn.Open()
                                                    Dim errorEivIncomeReportIndex As Integer
                                                    For Each errorEivIncomeReportIndex In errorsEivIncomeReportList
                                                        Dim queryDocumentEivIncomeReport As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorEivIncomeReportIndex & "'", conn)
                                                        Dim readerDocumentEivIncomeReport As SqlDataReader = queryDocumentEivIncomeReport.ExecuteReader()
                                                        While readerDocumentEivIncomeReport.Read
                                                            errorDocumentEivIncomeReportID = CStr(readerDocumentEivIncomeReport("ErrorID"))
                                                            detailsDocumentEivIncomeReport = CStr(readerDocumentEivIncomeReport("Details"))
                                                            noticeTypeDocumentEivIncomeReport = CStr(readerDocumentEivIncomeReport("Notice"))
                                                            statusDocumentEivIncomeReport = CStr(readerDocumentEivIncomeReport("Status"))
                                                            errorStaffNameDocumentEivIncomeReport = CStr(readerDocumentEivIncomeReport("ErrorStaffName"))
                                                            errorDocumentEivIncomeReportReviewTypeID = CStr(readerDocumentEivIncomeReport("fk_ReviewTypeID"))
                                                            processDocumentEivIncomeReportID = CStr(readerDocumentEivIncomeReport("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentEivIncomeReport) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentEivIncomeReport)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentEivIncomeReport) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentEivIncomeReport) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentEivIncomeReportID) %>&ReviewTypeID=<% Response.Write(errorDocumentEivIncomeReportReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentEivIncomeReportID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeEivIncomeReport" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlNoticeTypeEivIncomeReport" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlNoticeTypeEivIncomeReport" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentEivIncomeReport"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerEivIncomeReport" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlCaseManagerEivIncomeReport" DataValueField="UserID" DataTextField="FullName"
                                                            required="required">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerEivIncomeReport" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusEivIncomeReport" class="form-control border-input" runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateEivIncomeReport" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="utility-bill-for-tenant-paid-utilities">
                                                <h6>
                                                    Utility Bill (for tenant-paid utilities)
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("64") Then
                                                                Response.Write("<input type='checkbox' name='documentUtilityBillForTenantPaidUtilities' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentUtilityBillForTenantPaidUtilities' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentUtilityBillForTenantPaidUtilities' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                <%
                                                    conn.Open()
                                                    Dim errorDocumentUtilityBillForTenantPaidUtilitiesErrorID As Integer
                                                    Dim errorDocumentUtilityBillForTenantPaidUtilitiesID As Integer
                                                    Dim detailsDocumentUtilityBillForTenantPaidUtilities As String
                                                    Dim noticeTypeDocumentUtilityBillForTenantPaidUtilities As String
                                                    Dim statusDocumentUtilityBillForTenantPaidUtilities As String
                                                    Dim errorStaffNameDocumentUtilityBillForTenantPaidUtilities As String
                                                    Dim errorDocumentUtilityBillForTenantPaidUtilitiesReviewTypeID As Integer
                                                    Dim errorsUtilityBillForTenantPaidUtilitiesList As New ArrayList
                                                    Dim processDocumentUtilityBillForTenantPaidUtilitiesID As Integer
                                                        
                                                    Dim queryDocumentUtilityBillForTenantPaidUtilitiesError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '64' AND fk_FileID = '" & fileID & "'", conn)
                                                    Dim readerDocumentUtilityBillForTenantPaidUtilitiesError As SqlDataReader = queryDocumentUtilityBillForTenantPaidUtilitiesError.ExecuteReader()
                                                    If readerDocumentUtilityBillForTenantPaidUtilitiesError.HasRows Then
                                                        While readerDocumentUtilityBillForTenantPaidUtilitiesError.Read
                                                            errorDocumentUtilityBillForTenantPaidUtilitiesErrorID = CStr(readerDocumentUtilityBillForTenantPaidUtilitiesError("fk_ErrorID"))
                                                            errorsUtilityBillForTenantPaidUtilitiesList.Add(errorDocumentUtilityBillForTenantPaidUtilitiesErrorID)
                                                        End While
                                                    End If
                                                    conn.Close()
                                           
                                                    conn.Open()
                                                    Dim errorUtilityBillForTenantPaidUtilitiesIndex As Integer
                                                    For Each errorUtilityBillForTenantPaidUtilitiesIndex In errorsUtilityBillForTenantPaidUtilitiesList
                                                        Dim queryDocumentUtilityBillForTenantPaidUtilities As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorUtilityBillForTenantPaidUtilitiesIndex & "'", conn)
                                                        Dim readerDocumentUtilityBillForTenantPaidUtilities As SqlDataReader = queryDocumentUtilityBillForTenantPaidUtilities.ExecuteReader()
                                                        While readerDocumentUtilityBillForTenantPaidUtilities.Read
                                                            errorDocumentUtilityBillForTenantPaidUtilitiesID = CStr(readerDocumentUtilityBillForTenantPaidUtilities("ErrorID"))
                                                            detailsDocumentUtilityBillForTenantPaidUtilities = CStr(readerDocumentUtilityBillForTenantPaidUtilities("Details"))
                                                            noticeTypeDocumentUtilityBillForTenantPaidUtilities = CStr(readerDocumentUtilityBillForTenantPaidUtilities("Notice"))
                                                            statusDocumentUtilityBillForTenantPaidUtilities = CStr(readerDocumentUtilityBillForTenantPaidUtilities("Status"))
                                                            errorStaffNameDocumentUtilityBillForTenantPaidUtilities = CStr(readerDocumentUtilityBillForTenantPaidUtilities("ErrorStaffName"))
                                                            errorDocumentUtilityBillForTenantPaidUtilitiesReviewTypeID = CStr(readerDocumentUtilityBillForTenantPaidUtilities("fk_ReviewTypeID"))
                                                            processDocumentUtilityBillForTenantPaidUtilitiesID = CStr(readerDocumentUtilityBillForTenantPaidUtilities("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentUtilityBillForTenantPaidUtilities) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentUtilityBillForTenantPaidUtilities)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentUtilityBillForTenantPaidUtilities) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentUtilityBillForTenantPaidUtilities) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentUtilityBillForTenantPaidUtilitiesID) %>&ReviewTypeID=<% Response.Write(errorDocumentUtilityBillForTenantPaidUtilitiesReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentUtilityBillForTenantPaidUtilitiesID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeUtilityBillForTenantPaidUtilities" runat="server"
                                                            class="form-control border-input" DataSourceID="SqlNoticeTypeUtilityBillForTenantPaidUtilities"
                                                            DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlNoticeTypeUtilityBillForTenantPaidUtilities" runat="server"
                                                            ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentUtilityBillForTenantPaidUtilities"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerUtilityBillForTenantPaidUtilities" runat="server"
                                                            class="form-control border-input" DataSourceID="SqlCaseManagerUtilityBillForTenantPaidUtilities"
                                                            DataValueField="UserID" DataTextField="FullName" required="required">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerUtilityBillForTenantPaidUtilities" runat="server"
                                                            ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusUtilityBillForTenantPaidUtilities" class="form-control border-input"
                                                            runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateUtilityBillForTenantPaidUtilities" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="authorization-for-release-of-information/privacy-act-hud-9886">
                                                <h6>
                                                    Authorization for Release of Information/Privacy Act (HUD-9886)
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
                                                    Dim processAuthorizationForReleaseOfInformationPrivacyActHud9886ID As Integer
                                                        
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
                                                            processAuthorizationForReleaseOfInformationPrivacyActHud9886ID = CStr(readerDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886ID) %>&ReviewTypeID=<% Response.Write(errorDocumentAuthorizationForReleaseOfInformationPrivacyActHud9886ReviewTypeID) %>&ProcessType=<% Response.Write(processAuthorizationForReleaseOfInformationPrivacyActHud9886ID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeAuthorizationForReleaseOfInformationPrivacyActHud9886"
                                                            runat="server" class="form-control border-input" DataSourceID="SqlNoticeTypeAuthorizationForReleaseOfInformationPrivacyActHud9886"
                                                            DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlNoticeTypeAuthorizationForReleaseOfInformationPrivacyActHud9886"
                                                            runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentAuthorizationForReleaseOfInformationPrivacyActHud9886"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerAuthorizationForReleaseOfInformationPrivacyActHud9886"
                                                            runat="server" class="form-control border-input" DataSourceID="SqlCaseManagerAuthorizationForReleaseOfInformationPrivacyActHud9886"
                                                            DataValueField="UserID" DataTextField="FullName" required="required">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerAuthorizationForReleaseOfInformationPrivacyActHud9886"
                                                            runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusAuthorizationForReleaseOfInformationPrivacyActHud9886"
                                                            class="form-control border-input" runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateAuthorizationForReleaseOfInformationPrivacyActHud9886" runat="server"
                                                        class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="hano-authorization-for-release-of-information">
                                                <h6>
                                                    HANO Authorization for Release of Information
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
                                                    Dim processHanoAuthorizationForReleaseOfInformationID As Integer
                                                        
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
                                                            processHanoAuthorizationForReleaseOfInformationID = CStr(readerDocumentHanoAuthorizationForReleaseOfInformation("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentHanoAuthorizationForReleaseOfInformation) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentHanoAuthorizationForReleaseOfInformation)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentHanoAuthorizationForReleaseOfInformation) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentHanoAuthorizationForReleaseOfInformation) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentHanoAuthorizationForReleaseOfInformationID) %>&ReviewTypeID=<% Response.Write(errorDocumentHanoAuthorizationForReleaseOfInformationReviewTypeID) %>&ProcessTypeID=<% Response.Write(processHanoAuthorizationForReleaseOfInformationID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
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
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER BY [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentHanoAuthorizationForReleaseOfInformation"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerHanoAuthorizationForReleaseOfInformation" runat="server"
                                                            class="form-control border-input" DataSourceID="SqlCaseManagerHanoAuthorizationForReleaseOfInformation"
                                                            DataValueField="UserID" DataTextField="FullName" required="required">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerHanoAuthorizationForReleaseOfInformation" runat="server"
                                                            ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusHanoAuthorizationForReleaseOfInformation" class="form-control border-input"
                                                            runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateHanoAuthorizationForReleaseOfInformation" runat="server"
                                                        class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="family-obligations">
                                                <h6>
                                                    Family Obligations
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("67") Then
                                                                Response.Write("<input type='checkbox' name='documentFamilyObligations' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentFamilyObligations' />")
                                                            End If
                                                        Else
                                                             Response.Write("<input type='checkbox' name='documentFamilyObligations' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                <%
                                                    conn.Open()
                                                    Dim errorDocumentFamilyObligationsErrorID As Integer
                                                    Dim errorDocumentFamilyObligationsID As Integer
                                                    Dim detailsDocumentFamilyObligations As String
                                                    Dim noticeTypeDocumentFamilyObligations As String
                                                    Dim statusDocumentFamilyObligations As String
                                                    Dim errorStaffNameDocumentFamilyObligations As String
                                                    Dim errorDocumentFamilyObligationsReviewTypeID As Integer
                                                    Dim errorsFamilyObligationsList As New ArrayList
                                                    Dim processDocumentFamilyObligationsID As Integer
                                                        
                                                    Dim queryDocumentFamilyObligationsError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '67' AND fk_FileID = '" & fileID & "'", conn)
                                                    Dim readerDocumentFamilyObligationsError As SqlDataReader = queryDocumentFamilyObligationsError.ExecuteReader()
                                                    If readerDocumentFamilyObligationsError.HasRows Then
                                                        While readerDocumentFamilyObligationsError.Read
                                                            errorDocumentFamilyObligationsErrorID = CStr(readerDocumentFamilyObligationsError("fk_ErrorID"))
                                                            errorsFamilyObligationsList.Add(errorDocumentFamilyObligationsErrorID)
                                                        End While
                                                    End If
                                                    conn.Close()
                                           
                                                    conn.Open()
                                                    Dim errorFamilyObligationsIndex As Integer
                                                    For Each errorFamilyObligationsIndex In errorsFamilyObligationsList
                                                        Dim queryDocumentFamilyObligations As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorFamilyObligationsIndex & "'", conn)
                                                        Dim readerDocumentFamilyObligations As SqlDataReader = queryDocumentFamilyObligations.ExecuteReader()
                                                        While readerDocumentFamilyObligations.Read
                                                            errorDocumentFamilyObligationsID = CStr(readerDocumentFamilyObligations("ErrorID"))
                                                            detailsDocumentFamilyObligations = CStr(readerDocumentFamilyObligations("Details"))
                                                            noticeTypeDocumentFamilyObligations = CStr(readerDocumentFamilyObligations("Notice"))
                                                            statusDocumentFamilyObligations = CStr(readerDocumentFamilyObligations("Status"))
                                                            errorStaffNameDocumentFamilyObligations = CStr(readerDocumentFamilyObligations("ErrorStaffName"))
                                                            errorDocumentFamilyObligationsReviewTypeID = CStr(readerDocumentFamilyObligations("fk_ReviewTypeID"))
                                                            processDocumentFamilyObligationsID = CStr(readerDocumentFamilyObligations("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentFamilyObligations) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentFamilyObligations)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentFamilyObligations) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentFamilyObligations) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentFamilyObligationsID) %>&ReviewTypeID=<% Response.Write(errorDocumentFamilyObligationsReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentFamilyObligationsID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeFamilyObligations" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlNoticeTypeFamilyObligations" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlNoticeTypeFamilyObligations" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentFamilyObligations"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerFamilyObligations" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlCaseManagerFamilyObligations" DataValueField="UserID" DataTextField="FullName"
                                                            required="required">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerFamilyObligations" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusFamilyObligations" class="form-control border-input"
                                                            runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateFamilyObligations" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="recertification-appointment-letter">
                                                <h6>
                                                    Recertification Appointment Letter
                                                    &nbsp; &nbsp; &nbsp;
                                                            <%
                                                        If documents.Count > 0 Then
                                                                    If documents.Contains("68") Then
                                                                        Response.Write("<input type='checkbox' name='documentRecertificationAppointmentLetter' checked='checked' />")
                                                                    Else
                                                                        Response.Write("<input type='checkbox' name='documentRecertificationAppointmentLetter' />")
                                                                    End If
                                                        Else
                                                                    Response.Write("<input type='checkbox' name='documentRecertificationAppointmentLetter' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                <%
                                                    conn.Open()
                                                    Dim errorDocumentRecertificationAppointmentLetterErrorID As Integer
                                                    Dim errorDocumentRecertificationAppointmentLetterID As Integer
                                                    Dim detailsDocumentRecertificationAppointmentLetter As String
                                                    Dim noticeTypeDocumentRecertificationAppointmentLetter As String
                                                    Dim statusDocumentRecertificationAppointmentLetter As String
                                                    Dim errorStaffNameDocumentRecertificationAppointmentLetter As String
                                                    Dim errorDocumentRecertificationAppointmentLetterReviewTypeID As Integer
                                                    Dim errorsRecertificationAppointmentLetterList As New ArrayList
                                                    Dim processRecertificationAppointmentLetterID As Integer
                                                        
                                                    Dim queryDocumentRecertificationAppointmentLetterError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '68' AND fk_FileID = '" & fileID & "'", conn)
                                                    Dim readerDocumentRecertificationAppointmentLetterError As SqlDataReader = queryDocumentRecertificationAppointmentLetterError.ExecuteReader()
                                                    If readerDocumentRecertificationAppointmentLetterError.HasRows Then
                                                        While readerDocumentRecertificationAppointmentLetterError.Read
                                                            errorDocumentRecertificationAppointmentLetterErrorID = CStr(readerDocumentRecertificationAppointmentLetterError("fk_ErrorID"))
                                                            errorsRecertificationAppointmentLetterList.Add(errorDocumentRecertificationAppointmentLetterErrorID)
                                                        End While
                                                    End If
                                                    conn.Close()
                                           
                                                    conn.Open()
                                                    Dim errorRecertificationAppointmentLetterIndex As Integer
                                                    For Each errorRecertificationAppointmentLetterIndex In errorsRecertificationAppointmentLetterList
                                                        Dim queryDocumentRecertificationAppointmentLetter As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorRecertificationAppointmentLetterIndex & "'", conn)
                                                        Dim readerDocumentRecertificationAppointmentLetter As SqlDataReader = queryDocumentRecertificationAppointmentLetter.ExecuteReader()
                                                        While readerDocumentRecertificationAppointmentLetter.Read
                                                            errorDocumentRecertificationAppointmentLetterID = CStr(readerDocumentRecertificationAppointmentLetter("ErrorID"))
                                                            detailsDocumentRecertificationAppointmentLetter = CStr(readerDocumentRecertificationAppointmentLetter("Details"))
                                                            noticeTypeDocumentRecertificationAppointmentLetter = CStr(readerDocumentRecertificationAppointmentLetter("Notice"))
                                                            statusDocumentRecertificationAppointmentLetter = CStr(readerDocumentRecertificationAppointmentLetter("Status"))
                                                            errorStaffNameDocumentRecertificationAppointmentLetter = CStr(readerDocumentRecertificationAppointmentLetter("ErrorStaffName"))
                                                            errorDocumentRecertificationAppointmentLetterReviewTypeID = CStr(readerDocumentRecertificationAppointmentLetter("fk_ReviewTypeID"))
                                                            processRecertificationAppointmentLetterID = CStr(readerDocumentRecertificationAppointmentLetter("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentRecertificationAppointmentLetter) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentRecertificationAppointmentLetter)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentRecertificationAppointmentLetter) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentRecertificationAppointmentLetter) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentRecertificationAppointmentLetterID) %>&ReviewTypeID=<% Response.Write(errorDocumentRecertificationAppointmentLetterReviewTypeID) %>&ProcessTypeID=<% Response.Write(processRecertificationAppointmentLetterID) %>"
                                                        class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <br />
                                                <%
                                                End While
                                            Next
                                            conn.Close()
                                                %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeRecertificationAppointmentLetter" runat="server"
                                                            class="form-control border-input" DataSourceID="SqlNoticeTypeRecertificationAppointmentLetter"
                                                            DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlNoticeTypeRecertificationAppointmentLetter" runat="server"
                                                            ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4' ORDER By [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentRecertificationAppointmentLetter"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerRecertificationAppointmentLetter" runat="server"
                                                            class="form-control border-input" DataSourceID="SqlCaseManagerRecertificationAppointmentLetter"
                                                            DataValueField="UserID" DataTextField="FullName">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerRecertificationAppointmentLetter" runat="server"
                                                            ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusRecertificationAppointmentLetter" class="form-control border-input"
                                                            runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnCreateRecertificationAppointmentLetter" runat="server" class="btn btn-success btn-fill btn-wd"
                                                        Text="Add" />
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

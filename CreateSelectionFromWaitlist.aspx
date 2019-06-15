<%@ Page Title="QC :: Waitlist" Language="vb" AutoEventWireup="false" MasterPageFile="~/FileDetails.master"
    CodeBehind="CreateSelectionFromWaitlist.aspx.vb" Inherits="QualityControlMonitor.CreateSelectionFromWaitlist" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>

<asp:Content runat="server" ID="myContent" ContentPlaceHolderID="nestedContent">
    <div class="row">
        <div class="col-lg-12 col-md-7">
            <div class="card">
                <div class="header">
                    <h4 class="title">
                        <i class="fa fa-pause" aria-hidden="true"></i>QC Review :: Selection from the Waitlist</h4>
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
                            Text="Complete Selection from the Waitlist Review" />
                        <%
                        Else
                        %>
                        <asp:Button ID="btnUpdateReview" runat="server" class="btn btn-warning btn-fill btn-wd"
                            Text="Resubmit Selection from the Waitlist Review" />
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
                                        <i class="fa fa-pause" aria-hidden="true"></i>Selection from the Waiting List
                                    </h4>
                                </div>
                                <div class="panel-body">
                                    <hr />
                                    <div id="lottery-number">
                                        <h6>
                                            Lottery Number</h6>
                                        <%
                                            Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)
                                            conn.Open()
                                            Dim lotteryNumberID As Integer
                                            Dim doClientHaveNumber As Boolean
                                            Dim clientNumberResponse As String
                                            Dim number As String
                                            Dim comments As String

                                            Dim queryLotteryNumber As New SqlCommand("SELECT LotteryNumberID, doClientHaveNumber, Number, Comments FROM LotteryNumberErrors WHERE fk_FileID = '" & fileID & "'", conn)
                                            Dim readerLotteryNumber As SqlDataReader = queryLotteryNumber.ExecuteReader()
                                            If readerLotteryNumber.HasRows Then
                                                While readerLotteryNumber.Read
                                                    lotteryNumberID = CStr(readerLotteryNumber("LotteryNumberID"))
                                                    doClientHaveNumber = CStr(readerLotteryNumber("doClientHaveNumber"))
                                                    number = CStr(readerLotteryNumber("Number"))
                                                    comments = CStr(readerLotteryNumber("Comments"))
                                                End While
                                        %>
                                        <div class="errorContent">
                                            <br />
                                            <br />
                                            <div class="col-md-3">
                                                <h6>
                                                    Do client have a Lottery Number?</h6>
                                                <br />
                                                <div class="form-group">
                                                    <% 
                                                        If doClientHaveNumber = True Then
                                                            clientNumberResponse = "Yes"
                                                        Else
                                                            clientNumberResponse = "No"
                                                        End If
                                                    %>
                                                    <input class="form-control border-input" disabled="disabled" value="<% Response.Write(clientNumberResponse) %>"
                                                        type="text" />
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <h6>
                                                    If so, what is the lottery number?</h6>
                                                <br />
                                                <div class="form-group">
                                                    <input class="form-control border-input" disabled="disabled" value="<% Response.Write(number) %>"
                                                        type="text" />
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <h6>
                                                    Comments for Lottery Number</h6>
                                                <br />
                                                <div class="form-group">
                                                    <textarea class="form-control border-input" cols="4" disabled="disabled" rows="1"><% Response.Write(comments)%></textarea>
                                                </div>
                                            </div>
                                            <div class="text-center">
                                                <br />
                                                <br />
                                                <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&LotteryNumberID=<% Response.Write(lotteryNumberID) %>"
                                                    class="btn btn-warning btn-fill btn-wd">Edit</a>
                                            </div>
                                            <div class="clearfix">
                                            </div>
                                        </div>
                                        <%
                                        Else
                                        %>
                                        <div class="formContent">
                                            <br />
                                            <br />
                                            <div class="col-md-3">
                                                <h6>
                                                    Do client have a Lottery Number?</h6>
                                                <br />
                                                <div class="form-group">
                                                    <div class="btn-group" data-toggle="buttons">
                                                        <label class="btn btn-info">
                                                            <input type="radio" name="islotteryNumber14" autocomplete="off" value="1" />Yes</label>
                                                        <label class="btn btn-info">
                                                            <input type="radio" name="islotteryNumber14" autocomplete="off" value="0" />No</label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <h6>
                                                    If so, what is the lottery number?</h6>
                                                <br />
                                                <div class="form-group">
                                                    <input class="form-control border-input" name="lotteryNumber14" placeholder="Lottery Number"
                                                        type="text" />
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <h6>
                                                    Comments for Lottery Number</h6>
                                                <br />
                                                <div class="form-group">
                                                    <textarea class="form-control  border-input" cols="4" name="Comment14" placeholder="Comment"
                                                        rows="1"></textarea>
                                                </div>
                                            </div>
                                            <div class="text-center">
                                                <br />
                                                <br />
                                                <asp:Button ID="btnLotteryNumber" runat="server" class="btn btn-success btn-fill btn-wd"
                                                    Text="Lottery Number" />
                                            </div>
                                            <div class="clearfix">
                                            </div>
                                        </div>
                                        <%
                                        End If
                                        conn.Close()
                                        %>
                                        <hr />
                                    </div>
                                    <div id="special-admission">
                                        <%
                                            conn.Open()
                                            Dim specialAdmissionID As Integer
                                            Dim isSpecialAdmission As Boolean
                                            Dim commentSpecialAdmission As String
                                            Dim specialAdmissionResponse As String
                                             
                                            Dim querySpecialAdmission As New SqlCommand("SELECT SpecialCaseID, isExists, Comments FROM SpecialCaseErrors WHERE fk_FileID = '" & fileID & "' AND fk_ErrorTypeID = 19", conn)
                                            Dim readerSpecialAdmission As SqlDataReader = querySpecialAdmission.ExecuteReader()
                                            If readerSpecialAdmission.HasRows Then
                                                While readerSpecialAdmission.Read
                                                    specialAdmissionID = CStr(readerSpecialAdmission("SpecialCaseID"))
                                                    isSpecialAdmission = CStr(readerSpecialAdmission("isExists"))
                                                    commentSpecialAdmission = CStr(readerSpecialAdmission("Comments"))
                                                End While
                                        %>
                                        <div class="errorContent">
                                            <h6>
                                                Special Admission</h6>
                                            <br />
                                            <br />
                                            <div class="col-md-3">
                                                <h6>
                                                    Is Special Admissions?</h6>
                                                <br />
                                                <div class="form-group">
                                                    <% 
                                                        If isSpecialAdmission = True Then
                                                            specialAdmissionResponse = "Yes"
                                                        Else
                                                            specialAdmissionResponse = "No"
                                                        End If
                                                    %>
                                                    <input class="form-control border-input" type="text" disabled="disabled" value="<% Response.Write(specialAdmissionResponse) %>" />
                                                </div>
                                            </div>
                                            <div class="col-md-7">
                                                <h6>
                                                    Comments per Special Admission</h6>
                                                <br />
                                                <div class="form-group">
                                                    <input class="form-control border-input" type="text" disabled="disabled" value="<% Response.Write(commentSpecialAdmission) %>" />
                                                </div>
                                            </div>
                                            <div class="text-center">
                                                <br />
                                                <br />
                                                <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&SpecialCaseID=<% Response.Write(specialAdmissionID) %>"
                                                    class="btn btn-warning btn-fill btn-wd">Edit</a>
                                            </div>
                                            <div class="clearfix">
                                            </div>
                                        </div>
                                        <%
                                        Else
                                        %>
                                        <div class="formContent">
                                            <h6>
                                                Special Admission</h6>
                                            <br />
                                            <br />
                                            <div class="col-md-3">
                                                <h6>
                                                    Is Special Admissions?</h6>
                                                <br />
                                                <div class="form-group">
                                                    <div class="btn-group" data-toggle="buttons">
                                                        <label class="btn btn-info">
                                                            <input type="radio" name="isSpecialAdmission19" autocomplete="off" value="1" />Yes</label>
                                                        <label class="btn btn-info">
                                                            <input type="radio" name="isSpecialAdmission19" autocomplete="off" value="0" />No</label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-7">
                                                <h6>
                                                    Comments per Special Admission</h6>
                                                <br />
                                                <div class="form-group">
                                                    <textarea class="form-control  border-input" cols="4" name="Comment19" placeholder="Comment"
                                                        rows="1"></textarea>
                                                </div>
                                            </div>
                                            <div class="text-center">
                                                <br />
                                                <br />
                                                <asp:Button ID="btnSpecialAdmission" runat="server" class="btn btn-success btn-fill btn-wd"
                                                    Text="Special Admissions" />
                                            </div>
                                            <div class="clearfix">
                                            </div>
                                        </div>
                                        <%     
                                        End If
                                        conn.Close()
                                        %>
                                        <hr />
                                    </div>
                                    <div id="port-in">
                                        <%
                                            conn.Open()
                                            Dim portInID As Integer
                                            Dim isPortIn As Boolean
                                            Dim commentPortIn As String
                                            Dim portInResponse As String
                                              
                                            Dim queryPortIn As New SqlCommand("SELECT SpecialCaseID, isExists, Comments FROM SpecialCaseErrors WHERE fk_FileID = '" & fileID & "' AND fk_ErrorTypeID = 20", conn)
                                            Dim readerPortIn As SqlDataReader = queryPortIn.ExecuteReader()
                                            If readerPortIn.HasRows Then
                                                While readerPortIn.Read
                                                    portInID = CStr(readerPortIn("SpecialCaseID"))
                                                    isPortIn = CStr(readerPortIn("isExists"))
                                                    commentPortIn = CStr(readerPortIn("Comments"))
                                                End While
                                        %>
                                        <div class="errorContent">
                                            <h6>
                                                Port In</h6>
                                            <br />
                                            <br />
                                            <div class="col-md-3">
                                                <h6>
                                                    Is Port In?</h6>
                                                <br />
                                                <% 
                                                    If isPortIn = True Then
                                                        portInResponse = "Yes"
                                                    Else
                                                        portInResponse = "No"
                                                    End If
                                                %>
                                                <div class="form-group">
                                                    <input class="form-control border-input" value="<% Response.Write(portInResponse) %>"
                                                        type="text" disabled="disabled" />
                                                </div>
                                            </div>
                                            <div class="col-md-7">
                                                <h6>
                                                    Comments per Port In</h6>
                                                <br />
                                                <div class="form-group">
                                                    <input class="form-control border-input" value="<% Response.Write(commentPortIn) %>"
                                                        type="text" disabled="disabled" />
                                                </div>
                                            </div>
                                            <div class="text-center">
                                                <br />
                                                <br />
                                                <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&SpecialCaseID=<% Response.Write(portInID) %>"
                                                    class="btn btn-warning btn-fill btn-wd">Edit</a>
                                            </div>
                                            <div class="clearfix">
                                            </div>
                                        </div>
                                        <%
                                        Else
                                        %>
                                        <div class="formContent">
                                            <h6>
                                                Port In</h6>
                                            <br />
                                            <br />
                                            <div class="col-md-3">
                                                <h6>
                                                    Is Port In?</h6>
                                                <br />
                                                <div class="form-group">
                                                    <div class="btn-group" data-toggle="buttons">
                                                        <label class="btn btn-info">
                                                            <input type="radio" name="isPortIn20" autocomplete="off" value="1" />
                                                            Yes</label>
                                                        <label class="btn btn-info">
                                                            <input type="radio" name="isPortIn20" autocomplete="off" value="0" />No</label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-7">
                                                <h6>
                                                    Comments per Port In</h6>
                                                <br />
                                                <div class="form-group">
                                                    <textarea class="form-control  border-input" cols="4" name="comment20" placeholder="Comment"
                                                        rows="1"></textarea>
                                                </div>
                                            </div>
                                            <div class="text-center">
                                                <br />
                                                <br />
                                                <asp:Button ID="btnPortIn" runat="server" class="btn btn-success btn-fill btn-wd"
                                                    Text="Port In" />
                                            </div>
                                            <div class="clearfix">
                                            </div>
                                        </div>
                                        <!-- ./formContent -->
                                        <%
                                        End If
                                        conn.Close()
                                        %>
                                        <hr />
                                    </div>
                                    <!-- ./portIn -->
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
                                                aria-expanded="true" aria-controls="collapseOne"><i class="fa fa-sticky-note" aria-hidden="true">
                                                </i>Notes / Portability Billing / Compliance </a>
                                        </h4>
                                    </div>
                                    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="panel-body">
                                            <hr />
                                            <div id="other">
                                                <h6>
                                                    Other &nbsp; &nbsp; &nbsp;
                                                    <%
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
                                                            If processes.Contains("6") Then
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
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentOtherID) %>&ReviewTypeID=<% Response.Write(errorDocumentOtherReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentOtherErrorID) %>"
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
                                                        <asp:DropDownList ID="NoticeTypeOther6" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlNoticeTypeOther6" DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlNoticeTypeOther6" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2' ORDER BY [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentOther6" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerOther6" runat="server" class="form-control border-input"
                                                            DataSourceID="SqlCaseManagerOther6" DataValueField="UserID" DataTextField="FullName">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerOther6" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusOther6" class="form-control border-input" runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <p>
                                                    </p>
                                                    <asp:Button ID="btnDocument6" runat="server" class="btn btn-success btn-fill btn-wd"
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
                                                href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo"><i class="fa fa-file-word-o"
                                                    aria-hidden="true"></i>Waitlist File</a>
                                        </h4>
                                    </div>
                                    <div id="collapseTwo" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                                        <div class="panel-body">
                                            <div id="other-selection-from-the-waiting-list-documents">
                                                <h6>
                                                    Other Selection from the Waiting List Documents
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
                                                         If documents.Contains("35") Then
                                                             Response.Write("<input type='checkbox' name='documentOtherSelectionFromTheWaitingListDocuments' checked='checked' />")
                                                         Else
                                                             Response.Write("<input type='checkbox' name='documentOtherSelectionFromTheWaitingListDocuments' />")
                                                         End If
                                                     Else
                                                         Response.Write("<input type='checkbox' name='documentOtherSelectionFromTheWaitingListDocuments' />")
                                                     End If
                                                %>
                                                </h6>
                                                <br />
                                                <%
                                                    conn.Open()
                                                    Dim errorDocumentOtherSelectionFromTheWaitingListDocumentsErrorID As Integer
                                                    Dim errorDocumentOtherSelectionFromTheWaitingListDocumentsID As Integer
                                                    Dim detailsDocumentOtherSelectionFromTheWaitingListDocuments As String
                                                    Dim noticeTypeDocumentOtherSelectionFromTheWaitingListDocuments As String
                                                    Dim statusDocumentOtherSelectionFromTheWaitingListDocuments As String
                                                    Dim errorStaffNameDocumentOtherSelectionFromTheWaitingListDocuments As String
                                                    Dim errorDocumentOtherSelectionFromTheWaitingListDocumentsReviewTypeID As Integer
                                                    Dim errorsOtherSelectionFromTheWaitingListDocumentsList As New ArrayList
                                                    Dim processDocumentOtherSelectionFromTheWaitingListDocumentsErrorID As Integer
                                                        
                                                    Dim queryDocumentOtherSelectionFromTheWaitingListDocumentsError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '75' AND fk_FileID = '" & fileID & "'", conn)
                                                    Dim readerDocumentOtherSelectionFromTheWaitingListDocumentsError As SqlDataReader = queryDocumentOtherSelectionFromTheWaitingListDocumentsError.ExecuteReader()
                                                    If readerDocumentOtherSelectionFromTheWaitingListDocumentsError.HasRows Then
                                                        While readerDocumentOtherSelectionFromTheWaitingListDocumentsError.Read
                                                            errorDocumentOtherSelectionFromTheWaitingListDocumentsErrorID = CStr(readerDocumentOtherSelectionFromTheWaitingListDocumentsError("fk_ErrorID"))
                                                            errorsOtherSelectionFromTheWaitingListDocumentsList.Add(errorDocumentOtherSelectionFromTheWaitingListDocumentsErrorID)
                                                        End While
                                                    End If
                                                    conn.Close()
                                           
                                                    conn.Open()
                                                    Dim errorOtherSelectionFromTheWaitingListDocumentsIndex As Integer
                                                    For Each errorOtherSelectionFromTheWaitingListDocumentsIndex In errorsOtherSelectionFromTheWaitingListDocumentsList
                                                        Dim queryDocumentOtherSelectionFromTheWaitingListDocuments As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorOtherSelectionFromTheWaitingListDocumentsIndex & "'", conn)
                                                        Dim readerDocumentOtherSelectionFromTheWaitingListDocuments As SqlDataReader = queryDocumentOtherSelectionFromTheWaitingListDocuments.ExecuteReader()
                                                        While readerDocumentOtherSelectionFromTheWaitingListDocuments.Read
                                                            errorDocumentOtherSelectionFromTheWaitingListDocumentsID = CStr(readerDocumentOtherSelectionFromTheWaitingListDocuments("ErrorID"))
                                                            detailsDocumentOtherSelectionFromTheWaitingListDocuments = CStr(readerDocumentOtherSelectionFromTheWaitingListDocuments("Details"))
                                                            noticeTypeDocumentOtherSelectionFromTheWaitingListDocuments = CStr(readerDocumentOtherSelectionFromTheWaitingListDocuments("Notice"))
                                                            statusDocumentOtherSelectionFromTheWaitingListDocuments = CStr(readerDocumentOtherSelectionFromTheWaitingListDocuments("Status"))
                                                            errorStaffNameDocumentOtherSelectionFromTheWaitingListDocuments = CStr(readerDocumentOtherSelectionFromTheWaitingListDocuments("ErrorStaffName"))
                                                            errorDocumentOtherSelectionFromTheWaitingListDocumentsReviewTypeID = CStr(readerDocumentOtherSelectionFromTheWaitingListDocuments("fk_ReviewTypeID"))
                                                            processDocumentOtherSelectionFromTheWaitingListDocumentsErrorID = CStr(readerDocumentOtherSelectionFromTheWaitingListDocuments("fk_ProcessTypeID"))
                                                %>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Notice</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentOtherSelectionFromTheWaitingListDocuments) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <h6>
                                                        Comments</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentOtherSelectionFromTheWaitingListDocuments)%></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Staff</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentOtherSelectionFromTheWaitingListDocuments) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <h6>
                                                        Status</h6>
                                                    <br />
                                                    <div class="form-group">
                                                        <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentOtherSelectionFromTheWaitingListDocuments) %>"
                                                            type="text" />
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <br />
                                                    <br />
                                                    <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentOtherSelectionFromTheWaitingListDocumentsID) %>&ReviewTypeID=<% Response.Write(errorDocumentOtherSelectionFromTheWaitingListDocumentsReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentOtherSelectionFromTheWaitingListDocumentsErrorID) %>"
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
                                                        <asp:DropDownList ID="NoticeTypeOtherSelectionFromTheWaitingListDocuments75" runat="server"
                                                            class="form-control border-input" DataSourceID="SqlNoticeTypeOtherSelectionFromTheWaitingListDocuments75"
                                                            DataTextField="Notice" DataValueField="NoticeTypeID">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlNoticeTypeOtherSelectionFromTheWaitingListDocuments75"
                                                            runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2' ORDER BY [Notice] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentOtherSelectionFromTheWaitingListDocuments75"
                                                            placeholder="Comment" rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerOtherSelectionFromTheWaitingListDocuments75" runat="server"
                                                            class="form-control border-input" DataSourceID="SqlCaseManagerOtherSelectionFromTheWaitingListDocuments75"
                                                            DataValueField="UserID" DataTextField="FullName" required="required">
                                                        </asp:DropDownList>
                                                        <asp:SqlDataSource ID="SqlCaseManagerOtherSelectionFromTheWaitingListDocuments75"
                                                            runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                            SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                        </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusOtherSelectionFromTheWaitingListDocuments75" class="form-control border-input"
                                                            runat="server">
                                                            <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                            <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <p>
                                                    </p>
                                                    <asp:Button ID="btnDocument75" runat="server" class="btn btn-success btn-fill btn-wd"
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
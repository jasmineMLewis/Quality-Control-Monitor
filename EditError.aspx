<%@ Page Title="QC :: Edit Error" Language="vb" AutoEventWireup="false" MasterPageFile="~/User.Master"
    CodeBehind="EditError.aspx.vb" Inherits="QualityControlMonitor.EditError" %>

<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <%
            Dim sessionUserID As String
            If Not Web.HttpContext.Current.Session("SessionUserID") Is Nothing Then
                sessionUserID = Web.HttpContext.Current.Session("SessionUserID").ToString()
            End If

            If sessionUserID = Nothing Then
                sessionUserID = Request.QueryString("SessionUserID")
                Web.HttpContext.Current.Session("SessionUserID") = sessionUserID
            End If

            Dim fileID As Integer = Request.QueryString("FileID")

            Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)
            conn.Open()
            Dim clientFirstName As String
            Dim clientLastName As String
            Dim eliteID As String
            Dim housingSpecialistFullName As String
            Dim auditorFullName As String
            Dim reviewDate As String

            Dim query As String = String.Empty
            query &= "SELECT ClientFirstName, ClientLastName, EliteID, Users.FirstName + ' ' + Users.LastName AS FullName, "
            query &= "CASE WHEN LEFT(ReviewDate, 1) LIKE '[0-9]' THEN CONVERT(VARCHAR(max), CONVERT(date, [ReviewDate], 1), 101) ELSE CONVERT(VARCHAR(max), CONVERT(date, [ReviewDate], 109), 101) END ReviewDate, "
            query &= " Auditor =  (SELECT  Users.FirstName + ' ' + Users.LastName AS Auditor FROM Files  INNER JOIN Users ON Files.fk_AudtitorID = Users.UserID  WHERE FileID = '" & fileID & "')"
            query &= " FROM Files INNER JOIN Users ON Files.fk_CaseManagerID = Users.UserID WHERE FileID = '" & fileID & "'"

            Dim result As New SqlCommand(query, conn)
            Dim reader As SqlDataReader = result.ExecuteReader()
            While reader.Read
                clientFirstName = CStr(reader("ClientFirstName"))
                clientLastName = CStr(reader("ClientLastName"))
                eliteID = CStr(reader("EliteID"))
                housingSpecialistFullName = CStr(reader("FullName"))
                reviewDate = CStr(reader("ReviewDate"))
                auditorFullName = CStr(reader("Auditor"))
            End While
            conn.Close()
        %>
        <div class="col-lg-12 col-md-7">
            <div class="card">
                <div class="header">
                    <h4 class="title">
                        <i class="fa fa-file" aria-hidden="true"></i> &nbsp;File Info</h4>
                    <hr />
                </div>
                <div class="content">
                    <div class="row">
                        <div class="col-md-4">
                            <label>
                                Client First Name</label>
                            <div class="form-group input-group">
                                <input class="form-control border-input" value="<% Response.Write(clientFirstName) %>"
                                    required="required" type="text" disabled="disabled" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <label>
                                Client Last Name</label>
                            <div class="form-group input-group">
                                <input class="form-control  border-input" disabled="disabled" value="<% Response.Write(clientLastName) %>"
                                    required="required" type="text" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <label>
                                Elite ID</label>
                            <div class="form-group input-group">
                                <input class="form-control  border-input" value="<% Response.Write(eliteID) %>" disabled="disabled"
                                    required="required" type="text" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label>
                                Housing Specialist</label>
                            <div class="form-group input-group">
                                <input class="form-control  border-input" value="<% Response.Write(housingSpecialistFullName) %>"
                                    disabled="disabled" required="required" type="text" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <label>
                                Auditor</label>
                            <div class="form-group input-group">
                                <input class="form-control  border-input" value="<% Response.Write(auditorFullName) %>"
                                    disabled="disabled" required="required" type="text" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <label>
                                Review Date</label>
                            <div class="form-group input-group">
                                <input class="form-control border-input" value="<% Response.Write(reviewDate) %>"
                                    required="required" type="text" disabled="disabled" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <br />
    <div class="row">
        <div class="col-lg-12 col-md-7">
            <div class="card">
                <div class="header">
                    <h4 class="title">
                        <i class="fa fa-exclamation-circle" aria-hidden="true"></i> &nbsp;Error :: Edit</h4>
                    <hr />
                </div>
                <div class="content">
                    <%
                        Const BASIC_ERROR As Integer = 1
                        Const LOTTERY_NUMBER As Integer = 2
                        Const SPECIAL_CASE As Integer = 3  'Port In or Special Admissions
                        
                        Dim errorCase As Integer
                        If Request.QueryString("LotteryNumberID") Is Nothing And Request.QueryString("SpecialCaseID") Is Nothing Then
                            errorCase = BASIC_ERROR
                        Else
                            If Request.QueryString("LotteryNumberID") Is Nothing Then
                                errorCase = SPECIAL_CASE
                            Else
                                errorCase = LOTTERY_NUMBER
                            End If
                        End If
                        
                        Select Case errorCase
                            Case BASIC_ERROR
                    %>
                    <form class="editError" action="" method="post" runat="server">
                    <asp:ScriptManager ID="ScriptManager1" runat="server">
                    </asp:ScriptManager>
                    <div class="row">
                        <%
                            Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)
                            conn.Open()

                            Dim queryUserRoleID As New SqlCommand("SELECT fk_RoleID FROM Users WHERE UserID  = '" & Request.QueryString("SessionUserID") & "'", conn)
                            Dim readerUserRoleID As SqlDataReader = queryUserRoleID.ExecuteReader()
                            Dim sessionUserRoleID As Integer

                            While readerUserRoleID.Read
                                sessionUserRoleID = CStr(readerUserRoleID("fk_RoleID"))
                            End While
                            conn.Close()

                            Const HOUSING_SPECALIST As Integer = 3
                            Const DOCUMENT_PROCESS As Integer = 18

                            conn.Open()
                            Dim query As String = "SELECT fk_ProcessTypeID, ProcessTypes.Process, ErrorType = " & _
                                                  "       CASE fk_ProcessTypeID " & _
                                                  "           WHEN '18' THEN (SELECT DocumentTypes.DocumentType " & _
                                                  "                        FROM FileErrorsDocumentTypes " & _
                                                  "                        INNER JOIN DocumentTypes ON FileErrorsDocumentTypes.fk_DocumentTypeID = DocumentTypes.DocumentTypeID " & _
                                                  "                        WHERE fk_ErrorID = '" & Request.QueryString("ErrorID") & "') " & _
                                                  "       END," & _
                                                  "      fk_NoticeTypeID, NoticeTypes.Notice, Details, " & _
                                                  "      fk_ErrorStaffID, Users.FirstName + ' ' + Users.LastName As HousingSpecialistName " & _
                                                  "FROM FileErrors " & _
                                                  "INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID " & _
                                                  "INNER JOIN ProcessTypes ON FileErrors.fk_ProcessTypeID = ProcessTypes.ProcessTypeID " & _
                                                  "INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID " & _
                                                  "WHERE ErrorID  = '" & Request.QueryString("ErrorID") & "'"
                            Dim queryError As New SqlCommand(query, conn)
                            Dim readerError As SqlDataReader = queryError.ExecuteReader()
                            Dim processTypeID As Integer
                            Dim process As String
                            Dim errorType As String
                            Dim noticeType As String
                            Dim detailsBasicError As String
                            Dim housingSpecialistFullName As String

                            While readerError.Read
                                processTypeID = CStr(readerError("fk_ProcessTypeID"))
                                process = CStr(readerError("Process"))
                                errorType = CStr(readerError("ErrorType").ToString())
                                noticeType = CStr(readerError("Notice"))
                                detailsBasicError = CStr(readerError("Details"))
                                housingSpecialistFullName = CStr(readerError("HousingSpecialistName"))
                            End While
                            conn.Close()

                            If Not sessionUserRoleID = HOUSING_SPECALIST Then

                                'If Document utilize different table (Error Type)
                                If processTypeID = DOCUMENT_PROCESS Then
                        %>
                        <div class="col-md-4">
                            <label>
                                Error Type</label>
                            <div class="form-group">
                                <asp:DropDownList ID="Document" runat="server" class="form-control border-input"
                                    DataSourceID="SqlDocumentTypeProcess" DataTextField="DocumentType" DataValueField="fk_DocumentTypeID">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlDocumentTypeProcess" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                    SelectCommand="SELECT [fk_ReviewTypeID], [fk_DocumentTypeID], DocumentTypes.DocumentType  
                                                                    FROM ReviewTypesDocuments
                                                                    INNER JOIN DocumentTypes ON ReviewTypesDocuments.fk_DocumentTypeID = DocumentTypes.DocumentTypeID
                                                                    WHERE fk_ReviewTypeID = @ReviewTypeID">
                                    <SelectParameters>
                                        <asp:QueryStringParameter Name="ReviewTypeID" QueryStringField="ReviewTypeID" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </div>
                        </div>
                        <%
                        Else
                        %>
                        <div class="col-md-4">
                            <label>
                                Error Type</label>
                            <div class="form-group">
                                <asp:DropDownList ID="ProcessType" runat="server" class="form-control border-input"
                                    DataSourceID="SqlReviewTypeProcess" DataTextField="Process" DataValueField="fk_ProcessTypeID">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlReviewTypeProcess" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                    SelectCommand="SELECT [fk_ReviewTypeID], [fk_ProcessTypeID], ProcessTypes.Process  
                                                                    FROM ReviewTypesProcesses
                                                                    INNER JOIN ProcessTypes ON ReviewTypesProcesses.fk_ProcessTypeID = ProcessTypes.ProcessTypeID
                                                                    WHERE fk_ReviewTypeID = @ReviewTypeID">
                                    <SelectParameters>
                                        <asp:QueryStringParameter Name="ReviewTypeID" QueryStringField="ReviewTypeID" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </div>
                        </div>
                        <%
                        End If
                        %>
                        <div class="col-md-4">
                        </div>
                        <%
                            'If Document utilize different table (Error Category)
                            If processTypeID = DOCUMENT_PROCESS Then
                        %>
                        <div class="col-md-4">
                            <label>
                                Error Catergory</label>
                            <div class="form-group">
                                <asp:DropDownList ID="NoticeTypeDocument" runat="server" class="form-control border-input"
                                    DataSourceID="SqlDocumentNoticeType" DataTextField="Notice" DataValueField="fk_NoticeTypeID">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlDocumentNoticeType" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                    SelectCommand="SELECT NoticeTypeDocuments.fk_ReviewTypeID, NoticeTypeDocuments.fk_DocumentTypeID, NoticeTypes.Notice, 
                                                                        REPLACE(RTRIM(LTRIM(NoticeTypeDocuments.fk_NoticeTypeID)), ' ', '') AS fk_NoticeTypeID 
                                                                        FROM NoticeTypeDocuments 
                                                                        INNER JOIN NoticeTypes ON NoticeTypeDocuments.fk_NoticeTypeID = NoticeTypes.NoticeTypeID 
                                                                        WHERE (NoticeTypeDocuments.fk_ReviewTypeID = @ReviewTypeID) 
                                                                                AND (NoticeTypeDocuments.fk_DocumentTypeID = (SELECT fk_DocumentTypeID FROM FileErrorsDocumentTypes WHERE (fk_ErrorID = @ErrorID)))">
                                    <SelectParameters>
                                        <asp:QueryStringParameter Name="ReviewTypeID" QueryStringField="ReviewTypeID" />
                                        <asp:QueryStringParameter Name="ErrorID" QueryStringField="ErrorID" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </div>
                        </div>
                        <%
                        Else
                        %>
                        <div class="col-md-4">
                            <label>
                                Error Catergory</label>
                            <div class="form-group">
                                <asp:DropDownList ID="NoticeTypeProcess" runat="server" class="form-control border-input"
                                    DataSourceID="SqlProcessNoticeType" DataTextField="Notice" DataValueField="fk_NoticeTypeID">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlProcessNoticeType" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                    SelectCommand="SELECT NoticeTypeProcesses.fk_ReviewTypeID, NoticeTypeProcesses.fk_ProcessTypeID, NoticeTypes.Notice, 
                                                                               REPLACE(RTRIM(LTRIM(NoticeTypeProcesses.fk_NoticeTypeID)), ' ', '') AS fk_NoticeTypeID 
                                                                        FROM NoticeTypeProcesses 
                                                                        INNER JOIN NoticeTypes ON NoticeTypeProcesses.fk_NoticeTypeID = NoticeTypes.NoticeTypeID 
                                                                        WHERE (NoticeTypeProcesses.fk_ReviewTypeID = @ReviewTypeID) 
                                                                            AND (NoticeTypeProcesses.fk_ProcessTypeID = @ProcessTypeID)">
                                    <SelectParameters>
                                        <asp:QueryStringParameter Name="ReviewTypeID" QueryStringField="ReviewTypeID" />
                                        <asp:QueryStringParameter Name="ProcessTypeID" QueryStringField="ProcessTypeID" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </div>
                        </div>
                        <% 
                        End If
                        %>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <label>
                                Details</label>
                            <div class="form-group">
                                <textarea class="form-control border-input" rows="5" cols="40" name="Details"><% Response.Write(detailsBasicError)%></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label>
                                Housing Specialist</label>
                            <div class="form-group">
                                <asp:DropDownList ID="HousingSpecialistDropdownList" runat="server" class="form-control border-input"
                                    DataSourceID="SqlCaseManager" DataValueField="UserID" DataTextField="FullName">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlCaseManager" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                    SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR (fk_RoleID = ' 2') ORDER BY [FirstName] ASC">
                                </asp:SqlDataSource>
                            </div>
                        </div>
                        <div class="col-md-4">
                        </div>
                        <div class="col-md-4">
                            <label>
                                Status</label>
                            <div class="form-group">
                                <asp:DropDownList ID="StatusDropDownList" class="form-control border-input" runat="server"
                                    AutoPostBack="true" OnSelectedIndexChanged="displayStatusCompeleteSelectedIndexChanged">
                                    <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                    <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                    </div>
                    <%
                    End If
                    %>
                    <%
                        If sessionUserRoleID = HOUSING_SPECALIST Then
                    %>
                    <div class="row">
                        <div class="col-md-4">
                            <label>
                                Error Type</label>
                            <div class="form-group input-group">
                                <%
                                    If processTypeID = DOCUMENT_PROCESS Then
                                                                
                                        If Not String.IsNullOrEmpty(errorType) Then
                                            process = String.Concat(process, " - ", errorType)
                                        End If
                                                                
                                %>
                                <input class="form-control  border-input" disabled="disabled" value="<% Response.Write(process) %>"
                                    required="required" type="text" />
                                <%
                                Else
                                %>
                                <input class="form-control  border-input" disabled="disabled" value="<% Response.Write(process) %>"
                                    required="required" type="text" />
                                <%
                                End If
                                %>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-4">
                        </div>
                        <div class="col-md-4">
                            <label>
                                Error Category</label>
                            <div class="form-group input-group">
                                <input class="form-control  border-input" disabled="disabled" value="<% Response.Write(noticeType) %>"
                                    required="required" type="text" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <label>
                                Details</label>
                            <div class="form-group input-group">
                                <textarea class="form-control border-input" rows="5" cols="40" disabled="disabled"
                                    required="required"><% Response.Write(detailsBasicError)%></textarea>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label>
                                Housing Specialist</label>
                            <div class="form-group input-group">
                                <input class="form-control  border-input" disabled="disabled" value="<% Response.Write(housingSpecialistFullName) %>"
                                    required="required" type="text" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-4">
                        </div>
                        <div class="col-md-4">
                            <label>
                                Status</label>
                            <div class="form-group">
                                <asp:DropDownList ID="StatusHousingSpecialistDropdownList" class="form-control border-input"
                                    runat="server">
                                    <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                    <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                    </div>
                    <%
                    End If
                    %>
                    <%
                        If Not sessionUserRoleID = HOUSING_SPECALIST Then
                    %>
                    <br />
                    <div id="statusComplete" runat="server" visible="false">
                        <div class="row">
                            <div class="col-md-4">
                                <label>
                                    Completion Date (Date will NOT changed when Updated)</label>
                                <div class="form-group">
                                    <asp:TextBox ID="CompletionDate" runat="server" class="form-control border-input"
                                        placeholder="Completion Date" />
                                    <ajaxToolkit:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="CompletionDate"
                                        Format="MM/dd/yyyy" />
                                </div>
                            </div>
                            <div class="col-md-4">
                            </div>
                            <div class="col-md-4">
                                <label>
                                    Completion Aprroved</label>
                                <div class="form-group">
                                    <asp:DropDownList ID="CompletionApproved" class="form-control border-input" runat="server">
                                        <asp:ListItem Text="Completion Approved" Value="Completion Approved"></asp:ListItem>
                                        <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <label>
                                    Notes</label>
                                <div class="form-group">
                                    <%
                                        Dim connection As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)
                                        connection.Open()
                                        Dim queryErrorContent As New SqlCommand("SELECT IsNull(Notes, '') as Notes FROM FileErrors WHERE ErrorID = '" & Request.QueryString("ErrorID") & "'", connection)
                                        Dim readerErrorContent As SqlDataReader = queryErrorContent.ExecuteReader()

                                        Dim notesErrorContent As String
                                        While readerErrorContent.Read
                                            notesErrorContent = CStr(readerErrorContent("Notes"))
                                        End While

                                        If Not String.IsNullOrEmpty(notesErrorContent) Then
                                    %>
                                    <textarea class="form-control border-input" rows="5" cols="40" name="Notes" placeholder="Notes"><% Response.Write(notesErrorContent)%></textarea>
                                    <%
                                    Else
                                    %>
                                    <textarea class="form-control border-input" rows="5" cols="40" name="Notes" id="Notes"
                                        placeholder="Notes"></textarea>
                                    <%
                                    End If
                                    connection.Close()
                                    %>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%
                    End If
                    %>
                    <hr />
                    <div class="text-center">
                        <asp:Button ID="btnEditBasicError" runat="server" class="btn btn-info btn-fill btn-wd"
                            Text="Update" />
                        <asp:Button ID="btnEditBasicBack" runat="server" class="btn btn-info btn-fill btn-wd"
                            Text="Back" />
                    </div>
                    <div class="clearfix">
                    </div>
                    </form>
                    <%
                    Case LOTTERY_NUMBER
                    %>
                    <form class="editError" action="" method="post" runat="server">
                    <div class="row">
                        <%
                            Dim fileID As Integer = Request.QueryString("FileID")
                            Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)

                            Dim lotteryNumberID As Integer = Request.QueryString("LotteryNumberID")
                            Dim doClientHaveNumber As Boolean
                            Dim number As String
                            Dim commentsLotteryNumber As String

                            conn.Open()
                            Dim queryLotteryNumber As New SqlCommand("SELECT doClientHaveNumber, Number, Comments FROM LotteryNumberErrors WHERE fk_FileID = '" & fileID & "'", conn)
                            Dim readerLotteryNumber As SqlDataReader = queryLotteryNumber.ExecuteReader()
                            While readerLotteryNumber.Read
                                doClientHaveNumber = CStr(readerLotteryNumber("doClientHaveNumber"))
                                number = CStr(readerLotteryNumber("Number"))
                                commentsLotteryNumber = CStr(readerLotteryNumber("Comments"))
                            End While
                            conn.Close()
                        %>
                        <h6>
                            Lottery Number</h6>
                        <br />
                        <br />
                        <div class="col-md-3">
                            <h6>
                                Do client have a Lottery Number?</h6>
                            <br />
                            <div class="form-group">
                                <div class="btn-group" data-toggle="buttons">
                                    <%
                                        If doClientHaveNumber = True Then
                                    %>
                                    <label class="btn btn-info active">
                                        <input type="radio" name="islotteryNumber14" autocomplete="off" value="1" />Yes</label>
                                    <label class="btn btn-info">
                                        <input type="radio" name="islotteryNumber14" autocomplete="off" value="0" />No</label>
                                    <%
                                    Else
                                    %>
                                    <label class="btn btn-info">
                                        <input type="radio" name="islotteryNumber14" autocomplete="off" value="1" />Yes</label>
                                    <label class="btn btn-info active">
                                        <input type="radio" name="islotteryNumber14" autocomplete="off" value="0" />No</label>
                                    <%
                                    End If
                                    %>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <h6>
                                If so, what is the lottery number?</h6>
                            <br />
                            <div class="form-group">
                                <input class="form-control border-input" name="lotteryNumber14" value="<% Response.Write(number) %>"
                                    type="text" />
                            </div>
                        </div>
                        <div class="col-md-4">
                            <h6>
                                Comments for Lottery Number</h6>
                            <br />
                            <div class="form-group">
                                <textarea class="form-control  border-input" cols="4" name="Comment14" rows="1"><% Response.Write(commentsLotteryNumber)%></textarea>
                            </div>
                        </div>
                    </div>
                    <hr />
                    <div class="text-center">
                        <asp:Button ID="btnEditLotteryNumber" runat="server" class="btn btn-info btn-fill btn-wd"
                            Text="Update" />
                        <asp:Button ID="btnEditLotteryNumberBack" runat="server" class="btn btn-info btn-fill btn-wd"
                            Text="Back" />
                    </div>
                    <div class="clearfix">
                    </div>
                    </form>
                    <%
                    Case SPECIAL_CASE
                    %>
                    <form class="editError" action="" method="post" runat="server">
                    <%
                        Const ERROR_SPEICAL_ADMISSION As Integer = 19
                        Const ERROR_PORT_IN As Integer = 20

                        Dim specialCaseID As Integer = Request.QueryString("SpecialCaseID")
                        Dim fileID As Integer = Request.QueryString("FileID")
                        Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)

                        Dim errorSpecialCaseTypeID As Integer
                        Dim isExists As Boolean
                        Dim commentSpecialCase As String

                        conn.Open()
                        Dim querySpecialCase As New SqlCommand("SELECT isExists, Comments, fk_ErrorTypeID FROM SpecialCaseErrors WHERE fk_FileID = '" & fileID & "' AND SpecialCaseID = '" & specialCaseID & "'", conn)
                        Dim readerSpecialCase As SqlDataReader = querySpecialCase.ExecuteReader()
                        While readerSpecialCase.Read
                            isExists = CStr(readerSpecialCase("isExists"))
                            commentSpecialCase = CStr(readerSpecialCase("Comments"))
                            errorSpecialCaseTypeID = CStr(readerSpecialCase("fk_ErrorTypeID"))
                        End While
                        conn.Close()

                        If errorSpecialCaseTypeID = ERROR_SPEICAL_ADMISSION Then
                    %>
                    <div class="row">
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
                                    <%
                                        If isExists = True Then
                                    %>
                                    <label class="btn btn-info active">
                                        <input type="radio" name="isSpecialAdmission19" autocomplete="off" value="1" />Yes</label>
                                    <label class="btn btn-info">
                                        <input type="radio" name="isSpecialAdmission19" autocomplete="off" value="0" />No</label>
                                    <%
                                    Else
                                    %>
                                    <label class="btn btn-info">
                                        <input type="radio" name="isSpecialAdmission19" autocomplete="off" value="1" />Yes</label>
                                    <label class="btn btn-info active">
                                        <input type="radio" name="isSpecialAdmission19" autocomplete="off" value="0" />No</label>
                                    <%
                                    End If
                                    %>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-7">
                            <h6>
                                Comments per Special Admission</h6>
                            <br />
                            <div class="form-group">
                                <textarea class="form-control  border-input" cols="4" name="Comment19" rows="1"><% Response.Write(commentSpecialCase)%></textarea>
                            </div>
                        </div>
                    </div>
                    <hr />
                    <div class="text-center">
                        <asp:Button ID="btnEditSpecialAdmission" runat="server" class="btn btn-info btn-fill btn-wd"
                            Text="Update" />
                        <asp:Button ID="btnEditSpecialAdmissionBack" runat="server" class="btn btn-info btn-fill btn-wd"
                            Text="Back" />
                    </div>
                    <div class="clearfix">
                    </div>
                    <% 
                    End If
                                      
                    If errorSpecialCaseTypeID = ERROR_PORT_IN Then
                    %>
                    <div class="row">
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
                                    <%
                                        If isExists = True Then
                                    %>
                                    <label class="btn btn-info active">
                                        <input type="radio" name="isPortIn20" autocomplete="off" value="1" />Yes</label>
                                    <label class="btn btn-info">
                                        <input type="radio" name="isPortIn20" autocomplete="off" value="0" />No</label>
                                    <%
                                    Else
                                    %>
                                    <label class="btn btn-info">
                                        <input type="radio" name="isPortIn20" autocomplete="off" value="1" />Yes</label>
                                    <label class="btn btn-info active">
                                        <input type="radio" name="isPortIn20" autocomplete="off" value="0" />No</label>
                                    <%
                                    End If
                                    %>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-7">
                            <h6>
                                Comments per Port In</h6>
                            <br />
                            <div class="form-group">
                                <textarea class="form-control  border-input" cols="4" name="comment20" rows="1"><% Response.Write(commentSpecialCase)%></textarea>
                            </div>
                        </div>
                    </div>
                    <hr />
                    <div class="text-center">
                        <asp:Button ID="btnEditPortIn" runat="server" class="btn btn-info btn-fill btn-wd"
                            Text="Update" />
                        <asp:Button ID="btnEditPortInBack" runat="server" class="btn btn-info btn-fill btn-wd"
                            Text="Back" />
                    </div>
                    <div class="clearfix">
                    </div>
                    <%
                    End If
                    %>
                    </form>
                    <%
                End Select
                    %>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

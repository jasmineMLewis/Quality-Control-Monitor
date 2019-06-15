<%@ Page Title="QC :: Error Report" Language="vb" AutoEventWireup="false" MasterPageFile="~/User.Master"
    CodeBehind="ErrorReport.aspx.vb" Inherits="QualityControlMonitor.ErrorReport" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="header">
                    <h4 class="title">
                        <i class="fa fa-exclamation-triangle" aria-hidden="true"></i> Report :: Error</h4>
                    <hr />
                </div>
                <div class="content">
                    <form id="Form1" runat="server">
                    <asp:ScriptManager ID="ScriptManager1" runat="server">
                    </asp:ScriptManager>
                    <div class="row">
                        <div class="col-md-4">
                            <label>
                                Client First Name</label>
                            <div class="form-group">
                                <asp:TextBox ID="ClientFirstName" runat="server" class="form-control border-input"
                                    MaxLength="50" placeholder="Client First Name"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <label>
                                Client Last Name</label>
                            <div class="form-group">
                                <asp:TextBox ID="ClientLastName" runat="server" class="form-control border-input"
                                    MaxLength="50" placeholder="Client Last Name"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <label>
                                Error</label>
                            <div class="form-group input-group">
                                <asp:DropDownList ID="Process" runat="server" DataSourceID="SqlProcess" class="form-control border-input"
                                    DataTextField="Process" DataValueField="ProcessTypeID" required="required">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlProcess" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                    SelectCommand="SELECT ProcessTypeID, Process 
                                                   FROM ProcessTypes 
                                                   WHERE (ProcessTypeID &lt;&gt; 14) AND (ProcessTypeID &lt;&gt; 19)
                                                         AND (ProcessTypeID &lt;&gt; 20) ORDER BY Process"></asp:SqlDataSource>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
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
                            <label>
                                File Housing Specialist</label>
                            <div class="form-group input-group">
                                <asp:DropDownList ID="FileStaff" runat="server" class="form-control border-input"
                                    DataSourceID="SqlFileStaff" DataValueField="UserID" DataTextField="FullName"
                                    required="required">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlFileStaff" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                    SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                </asp:SqlDataSource>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <label>
                                File Staff Group</label>
                            <div class="form-group input-group">
                                <asp:DropDownList ID="Group" runat="server" class="form-control border-input" DataSourceID="SqlGroup"
                                    DataTextField="Group" DataValueField="GroupID" required="required">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlGroup" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                    SelectCommand="SELECT GroupID, [Group] FROM Groups ORDER BY [Group]"></asp:SqlDataSource>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <label>
                                Error Housing Specialist</label>
                            <div class="form-group input-group">
                                <asp:DropDownList ID="ErrorStaff" runat="server" class="form-control border-input"
                                    DataSourceID="SqlErrorStaff" DataValueField="UserID" DataTextField="FullName"
                                    required="required">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlErrorStaff" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                    SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3'OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
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
                            <label>
                                Review Date Begin</label>
                            <asp:TextBox ID="ReviewDateBegin" runat="server" class="form-control border-input"
                                placeholder="Review Begin Date" />
                            <ajaxToolkit:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="ReviewDateBegin"
                                Format="MM/dd/yyyy" />
                        </div>
                        <div class="col-md-4">
                            <label>
                                Review Date End</label>
                            <asp:TextBox ID="ReviewDateEnd" runat="server" class="form-control border-input"
                                placeholder="Review Date End" />
                            <ajaxToolkit:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="ReviewDateEnd"
                                Format="MM/dd/yyyy" />
                        </div>
                        <div class="col-md-4">
                            <label>
                                Review Type</label>
                            <div class="form-group input-group">
                                <asp:DropDownList ID="ReviewType" runat="server" class="form-control border-input"
                                    required="required" DataSourceID="SqlReviewType" DataTextField="Review" DataValueField="ReviewTypeID">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlReviewType" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                    SelectCommand="SELECT [ReviewTypeID], [Review] FROM [ReviewTypes] ORDER By [Review] ASC">
                                </asp:SqlDataSource>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label>
                                Error Status</label>
                            <div class="form-group input-group">
                                <asp:DropDownList ID="ErrorStatus" runat="server" class="form-control border-input"
                                    required="required">
                                    <asp:ListItem Value="All">All</asp:ListItem>
                                    <asp:ListItem Value="Pending">Pending</asp:ListItem>
                                    <asp:ListItem Value="Complete">Complete</asp:ListItem>
                                </asp:DropDownList>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-4"></div>
                        <div class="col-md-4">
                            <label>
                                Auditor</label>
                            <div class="form-group input-group">
                                <asp:DropDownList ID="Auditor" runat="server" class="form-control border-input" DataSourceID="SqlAuditor"
                                    DataValueField="UserID" DataTextField="FullName" required="required">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlAuditor" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                    SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '2'OR [fk_RoleID] = '1' ORDER BY [FirstName] ASC">
                                </asp:SqlDataSource>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                    </div>
                    <hr />
                    <div class="text-center">
                        <asp:Button ID="btnFilterReport" runat="server" class="btn btn-info btn-fill btn-wd"
                            Text="Filter" />
                   <%--     <%
                            If Not sessionRoleID = HOUSING_SPECALIST Then
                        %>--%>
                        <asp:Button ID="btnExportToExcel" runat="server" class="btn btn-info btn-fill btn-wd"
                            Text="Export To Excel" />
                       <%-- <%
                        End If
                        %>--%>
                    </div>
                    <div class="clearfix">
                    </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
        SelectCommand="SELECT FileErrors.fk_FileID, FileErrors.ErrorID, Files.ClientFirstName + ' ' + Files.ClientLastName AS Client, Files.IsFileDisable,
                              Files.EliteID, FileStaff.FirstName + ' ' + FileStaff.LastName AS FileStaffName,
                              ErrorStaff.FirstName + ' ' + ErrorStaff.LastName AS ErrorStaffName, FileErrors.fk_ErrorStaffID,
                              Auditor.FirstName + ' ' + Auditor.LastName AS AuditorName, ReviewTypes.Review, 
                               CONVERT (varchar(MAX), CAST(Files.ReviewDate AS date), 101) AS ReviewDate,
                                CONVERT (varchar(MAX), CAST(Files.EffectiveDate AS date), 101) AS EffectiveDate,
                              ProcessTypes.Process + ' - ' + NoticeTypes.Notice AS EntireError, 
                              (SELECT DocumentTypes.DocumentType
                               FROM FileErrorsDocumentTypes 
                               INNER JOIN DocumentTypes ON FileErrorsDocumentTypes.fk_DocumentTypeID = DocumentTypes.DocumentTypeID 
                               WHERE (FileErrorsDocumentTypes.fk_ErrorID = FileErrors.ErrorID)) AS DocumentErrorType,
                              FileErrors.Details AS ErrorComments, FileErrors.Status,
                              CONVERT (varchar(MAX), CAST(FileErrors.CompletionDate AS date), 101) AS CompletionDate,
                              CASE WHEN CompletionDate IS NULL THEN DATEDIFF(DAY , ReviewDate , GETDATE()) ELSE '0' END AS DaysInProcess,
                              FileErrors.Notes, FileErrors.fk_ReviewTypeID, FileErrors.fk_AuditorSubmittedID, 
                              fk_ProcessTypeID 
                             FROM FileErrors 
                             INNER JOIN Files ON FileErrors.fk_FileID = Files.FileID 
                             INNER JOIN Users AS FileStaff ON Files.fk_CaseManagerID = FileStaff.UserID 
                             INNER JOIN Users AS ErrorStaff ON FileErrors.fk_ErrorStaffID = ErrorStaff.UserID 
                             INNER JOIN Users AS Auditor ON FileErrors.fk_AuditorSubmittedID = Auditor.UserID 
                             INNER JOIN ReviewTypes ON FileErrors.fk_ReviewTypeID = ReviewTypes.ReviewTypeID 
                             INNER JOIN ProcessTypes ON FileErrors.fk_ProcessTypeID = ProcessTypes.ProcessTypeID
                             INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID
                             ORDER BY FileErrors.fk_FileID"></asp:SqlDataSource>
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="header">
                    <h4 class="title">
                        <i class="fa fa-exclamation-triangle" aria-hidden="true"></i> Errors</h4>
                    <hr />
                </div>
                <div class="content">
                    <div class="panel panel-success">
                        <div class="panel-heading">
                            <h3 class="panel-title">
                                <i class="fa fa-exclamation-triangle" aria-hidden="true"></i>Errors</h3>
                        </div>
                        <div class="table-responsive">
                            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="table"
                                GridLines="None" DataKeyNames="fk_FileID,ErrorID,fk_ReviewTypeID,fk_ProcessTypeID, ErrorComments"
                                DataSourceID="SqlDataSource1">
                                <Columns>
                                    <asp:TemplateField HeaderText="Client Name">
                                        <ItemTemplate>
                                            <%# DisplayFileLink(Eval("fk_ReviewTypeID"), Eval("Client"), Eval("fk_FileID"), Request.QueryString("SessionUserID"))%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="EliteID" HeaderText="Elite ID" SortExpression="EliteID" />
                                    <asp:BoundField DataField="FileStaffName" HeaderText="File Housing Specialist" ReadOnly="True"
                                        SortExpression="FileStaffName" />
                                    <asp:BoundField DataField="ErrorStaffName" HeaderText="Error Housing Specialist"
                                        ReadOnly="True" SortExpression="ErrorStaffName" />
                                    <asp:BoundField DataField="AuditorName" HeaderText="Auditor" ReadOnly="True" SortExpression="AuditorName" />
                                    <asp:BoundField DataField="Review" HeaderText="Review" SortExpression="Review" />
                                    <asp:BoundField DataField="ReviewDate" HeaderText="Review Date" ReadOnly="True" SortExpression="ReviewDate" />
                                    <asp:BoundField DataField="EffectiveDate" HeaderText="Effective Date" ReadOnly="True"
                                        SortExpression="EffectiveDate" />
                                    <asp:BoundField DataField="EntireError" HeaderText="Error" SortExpression="EntireError" />
                                    <asp:BoundField DataField="DocumentErrorType" HeaderText="Document Error" ReadOnly="True"
                                        SortExpression="DocumentErrorType" />
                                    <asp:TemplateField HeaderText="Error Comments">
                                        <ItemTemplate>
                                            <%# DisplayDecodedText(Eval("ErrorComments"))%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" />
                                    <asp:BoundField DataField="CompletionDate" HeaderText="Completion Date" SortExpression="CompletionDate" />
                                    <asp:BoundField DataField="DaysInProcess" HeaderText="Days In Process" ReadOnly="True"
                                        SortExpression="DaysInProcess" />
                                    <asp:BoundField DataField="Notes" HeaderText="Notes" SortExpression="Notes" />
                                    <asp:TemplateField HeaderText="">
                                        <ItemTemplate>
                                            <%# DisplayEditErrorLink(Request.QueryString("SessionUserID"), Eval("fk_FileID"), Eval("ErrorID"), Eval("fk_ReviewTypeID"), Eval("fk_ProcessTypeID"))%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="">
                                        <ItemTemplate>
                                            <%# DisplayDeleteErrorLink(Request.QueryString("SessionUserID"), Eval("fk_FileID"), Eval("ErrorID"), Eval("fk_ReviewTypeID"), Eval("fk_ProcessTypeID"))%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

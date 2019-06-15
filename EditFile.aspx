<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/FileDetails.master"
    CodeBehind="EditFile.aspx.vb" Inherits="QualityControlMonitor.EditFile" %>

<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="nestedContent" runat="server">
    <div class="row">
        <div class="col-lg-12 col-md-7">
            <div class="card">
                <div class="header">
                    <h4 class="title">
                        <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Edit :: File
                    </h4>
                    <hr />
                </div>
                <div class="content">
                    <form action="" method="post" runat="server">
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
                        Dim comment As String

                        Dim sql As New SqlCommand("SELECT ClientFirstName, ClientLastName, EliteID, Comment FROM Files WHERE FileID = '" & fileID & "'", conn)
                        Dim reader As SqlDataReader = sql.ExecuteReader()
                        While reader.Read
                            clientFirstName = CStr(reader("ClientFirstName")).Trim
                            clientLastName = CStr(reader("ClientLastName")).Trim
                            eliteID = CStr(reader("EliteID")).Trim
                            comment = CStr(reader("Comment")).Trim
                        End While
                        conn.Close()
                    %>
                    <asp:ScriptManager ID="ScriptManager1" runat="server">
                    </asp:ScriptManager>
                    <div class="row">
                        <div class="col-md-4">
                            <label>
                                Client First Name</label>
                            <div class="form-group input-group">
                                <input class="form-control border-input" id="ClientFirstName" maxlength="100" value="<% Response.Write(clientFirstName) %>"
                                    name="ClientFirstName" placeholder="Client First Name" required="required" type="text" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <label>
                                Client Last Name</label>
                            <div class="form-group input-group">
                                <input class="form-control  border-input" id="ClientLastName" maxlength="100" value="<% Response.Write(clientLastName) %>"
                                    name="ClientLastName" placeholder="Client Last Name" required="required" type="text" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <label>
                                Elite ID</label>
                            <div class="form-group input-group" data-validate="number">
                                <input class="form-control  border-input" id="ClientID" maxlength="9" value="<% Response.Write(eliteID) %>"
                                    name="ClientID" placeholder="Elite ID" required="required" type="text" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label>
                                Hosuing Specialist</label>
                            <div class="form-group input-group">
                                <asp:DropDownList ID="CaseManager" runat="server" class="form-control border-input"
                                    DataSourceID="SqlCaseManager" DataValueField="UserID" DataTextField="FullName"
                                    required="required">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlCaseManager" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                    SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                </asp:SqlDataSource>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-4">
                        </div>
                        <div class="col-md-4">
                            <label>
                                Review Type</label>
                            <div class="form-group input-group">
                                <asp:DropDownList ID="ReviewType" runat="server" class="form-control border-input"
                                    required="required" DataSourceID="SqlReviewType" DataTextField="Review" DataValueField="ReviewTypeID">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlReviewType" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                    SelectCommand="SELECT [ReviewTypeID], [Review] FROM [ReviewTypes] ORDER BY [Review] ASC">
                                </asp:SqlDataSource>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label>
                                Review Date</label>
                            <div class="form-group input-group">
                                <asp:TextBox ID="ReviewDate" runat="server" class="form-control border-input" required="required"
                                    MaxLength="15" placeholder="Review Date" />
                                <ajaxToolkit:CalendarExtender ID="ReviewDateCalendar" runat="server" TargetControlID="ReviewDate"
                                    Format="MM/dd/yyyy" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-4">
                        </div>
                        <div class="col-md-4">
                            <label>
                                Effective Date</label>
                            <div class="form-group input-group">
                                <asp:TextBox ID="EffectiveDate" runat="server" class="form-control border-input"
                                    required="required" MaxLength="15" placeholder="Effective Date" />
                                <ajaxToolkit:CalendarExtender ID="EffectiveDateCalendar" runat="server" TargetControlID="EffectiveDate"
                                    Format="MM/dd/yyyy" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <label>
                                Notes</label>
                            <div class="form-group input-group">
                                <textarea class="form-control border-input" rows="5" cols="40" id="Comment" maxlength="500"
                                    name="Comment" placeholder="Notes"><% Response.Write(comment)%></textarea>
                                <span class="input-group-addon success"><span class="glyphicon glyphicon-ok"></span>
                                </span>
                            </div>
                        </div>
                    </div>
                    <hr />
                    <div class="text-center">
                        <asp:Button ID="btnEditFile" runat="server" class="btn btn-info btn-fill btn-wd"
                            Text="Edit File" />
                    </div>
                    <div class="clearfix">
                    </div>
                    </form>
                </div>
            </div>
        </div>
    </div>


</asp:Content>

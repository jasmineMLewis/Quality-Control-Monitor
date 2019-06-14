<%@ Page Title="QC :: Edit User" Language="vb" AutoEventWireup="false" MasterPageFile="~/User.Master" CodeBehind="EditUser.aspx.vb" Inherits="QualityControlMonitor.EditUser" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-lg-8 col-md-7">
            <div class="card">
                <div class="header">
                    <h4 class="title">
                        <i class="fa fa-id-card-o" aria-hidden="true"></i> Profile :: User</h4>
                    <hr />
                </div>
                <div class="content">
                    <form action="" method="post" runat="server">
                    <%
                        'Get user id from session to dictate which form will display
                        Dim sessionUserID As String
                        If Not Web.HttpContext.Current.Session("SessionUserID") Is Nothing Then
                            sessionUserID = Web.HttpContext.Current.Session("SessionUserID").ToString()
                        End If

                        If sessionUserID = Nothing Then
                            sessionUserID = Request.QueryString("SessionUserID")
                            Web.HttpContext.Current.Session("SessionUserID") = sessionUserID
                        End If

                        Dim conn As SqlConnection = New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)
                        conn.Open()
                        Dim sessionUserRole As Integer

                        Dim querySessionUserRole As New SqlCommand("SELECT fk_RoleID FROM Users WHERE UserID='" & sessionUserID & "'", conn)
                        Dim readerSessionUserRole As SqlDataReader = querySessionUserRole.ExecuteReader()
                        While readerSessionUserRole.Read
                            sessionUserRole = CStr(readerSessionUserRole("fk_RoleID"))
                        End While
                        conn.Close()

                        Dim urlUserID As String
                        If Request.QueryString("UserID") Is Nothing Then
                            'It is the session's useer form to edit their info
                            urlUserID = sessionUserID
                        Else
                            'Get url's user id to edit that user's info
                            urlUserID = Request.QueryString("UserID")
                        End If

                        conn.Open()
                        Dim firstName As String
                        Dim lastName As String
                        Dim email As String
                        Dim password As String

                        Dim query As New SqlCommand("SELECT FirstName, LastName, Email, Password FROM Users WHERE UserID='" & urlUserID & "'", conn)
                        Dim reader As SqlDataReader = query.ExecuteReader()
                        While reader.Read
                            firstName = CStr(reader("FirstName"))
                            lastName = CStr(reader("LastName"))
                            email = CStr(reader("Email"))
                            password = CStr(reader("Password"))
                        End While
                        conn.Close()

                        Const ADMIN As Integer = 1
                        Const AUDITOR As Integer = 2
                        Const HOUSING_SPECILAIST As Integer = 3

                        Select Case sessionUserRole
                            Case ADMIN
                        %>
                    <div class="row">
                        <div class="col-md-6">
                            <label>
                                First Name</label>
                            <div class="form-group input-group">
                                <input class="form-control border-input" maxlength="20" name="FirstName"
                                    placeholder="First Name" required="required" type="text" value="<% Response.Write(firstname) %>" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label>
                                Last Name</label>
                            <div class="form-group input-group">
                                <input class="form-control border-input" maxlength="20" name="LastName"
                                    placeholder="Last Name" required="required" type="text" value="<% Response.Write(lastname) %>" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <label>
                                Email</label>
                            <div class="form-group input-group" data-validate="email">
                                <input class="form-control border-input" maxlength="100" name="Email"
                                    placeholder="Email" required="required" type="text" value="<% Response.Write(email) %>"/>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label>
                                Password</label>
                            <div class="form-group input-group">
                                <input class="form-control border-input" maxlength="15" name="Password" type="password"
                                    required="required" value="<% Response.Write(password) %>" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <label> Role</label>
                            <div class="form-group input-group">
                                <asp:DropDownList ID="Role" runat="server" class="form-control border-input" DataSourceID="SqlRole"
                                    DataTextField="Role" DataValueField="RoleID" required="required">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlRole" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                    SelectCommand="SELECT [RoleID], [Role] FROM [Roles]"></asp:SqlDataSource>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label>Group</label>
                            <div class="form-group input-group">
                                <asp:DropDownList ID="GroupType" runat="server" class="form-control border-input"
                                    DataSourceID="SqlGroupType" DataTextField="Group" DataValueField="GroupID" required="required">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlGroupType" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                    SelectCommand="SELECT [GroupID], [Group] FROM [Groups]"></asp:SqlDataSource>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <label>
                                Active</label>
                            <div class="form-group input-group">
                                <asp:DropDownList ID="IsActive" runat="server" class="form-control border-input"
                                    required="required">
                                    <asp:ListItem Value="">Active</asp:ListItem>
                                    <asp:ListItem Value="1">Yes</asp:ListItem>
                                    <asp:ListItem Value="0">No</asp:ListItem>
                                </asp:DropDownList>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-6">
                        </div>
                    </div>
                        <%
                        Case AUDITOR To HOUSING_SPECILAIST
                       %>
                    <div class="row">
                        <div class="col-md-6">
                            <label>
                                First Name</label>
                            <div class="form-group input-group">
                                <input class="form-control border-input" maxlength="20" name="FirstName"
                                    disabled="disabled" required="required" type="text" value="<% Response.Write(firstname) %>" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label>
                                Last Name</label>
                            <div class="form-group input-group">
                                <input class="form-control border-input" maxlength="20" name="LastName"
                                    disabled="disabled" required="required" type="text" value="<% Response.Write(lastname) %>" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span></span>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <label>
                                Email</label>
                            <div class="form-group input-group" data-validate="email">
                                <input class="form-control border-input" maxlength="100" name="Email" 
                                    disabled="disabled" required="required" type="text" value="<% Response.Write(email) %>" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span></span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label>
                                Password</label>
                            <div class="form-group input-group">
                                <input class="form-control border-input" maxlength="15" name="Password" type="password"
                                    required="required" value="<% Response.Write(password) %>" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span></span>
                            </div>
                        </div>
                    </div>
                       <%
                     End Select
                     %>
                    <hr />
                    <div class="text-center">
                        <asp:Button ID="btnEditUser" runat="server" class="btn btn-info btn-fill btn-wd"
                            Text="Edit User" />
                    </div>
                    <div class="clearfix">  </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
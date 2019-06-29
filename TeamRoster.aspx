<%@ Page Title="QC :: Team Roster" Language="vb" AutoEventWireup="false" MasterPageFile="~/User.Master" CodeBehind="TeamRoster.aspx.vb" Inherits="QualityControlMonitor.TeamRoster" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Styles/table-filter.css" rel="stylesheet" type="text/css" />
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="header">
                    <h4 class="title">
                        <i class="fa fa-tag" aria-hidden="true"></i> Team :: Roster
                    </h4>
                    <hr />
                </div>
                <div class="row">
                    <div class="panel panel-success filterable">
                        <div class="panel-heading">
                            <h3 class="panel-title">
                                  <i class="fa fa-tag" aria-hidden="true"></i> Team Roster</h3>
                            <div class="pull-right">
                                <button class="btn btn-default btn-xs btn-filter">
                                    <span class="glyphicon glyphicon-filter"></span>Filter</button>
                            </div>
                        </div>
                        <table class="table">
                            <thead>
                                <tr class="filters">
                                <th class="text-center"></th>
                                    <th>
                                        <input class="form-control border-input" type="text" placeholder="Name" disabled>
                                    </th>
                                    <th>
                                        <input class="form-control border-input" type="text" placeholder="Email" disabled>
                                    </th>
                                    <th>
                                        <input class="form-control border-input" type="text" placeholder="Role" disabled>
                                    </th>
                                    <th>
                                        <input class="form-control border-input" type="text" placeholder="Group" disabled>
                                    </th>
                                    <th>
                                        Active
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                            <%
                                Dim connGroup As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)
                                connGroup.Open()

                                Dim sessionUserID As Integer = Request.QueryString("SessionUserID")
                                Dim queryGroup As New SqlCommand("SELECT fk_GroupID FROM Users WHERE UserID  = '" & sessionUserID & "'", connGroup)
                                Dim readerGroup As SqlDataReader = queryGroup.ExecuteReader()
                                Dim sessionGroupID As Integer

                                While readerGroup.Read
                                    sessionGroupID = CStr(readerGroup("fk_GroupID"))
                                End While
                                connGroup.Close()

                                Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)
                                conn.Open()
                                Dim dirUserID As Integer
                                Dim dirFirstName As String
                                Dim dirLastName As String
                                Dim dirEmail As String
                                Dim dirGroup As String
                                Dim dirUserType As String
                                Dim dirActive As Boolean
                                Dim rowCount As Integer = 0

                                Dim query As New SqlCommand("SELECT UserID, FirstName, LastName, Email, Password, Groups.[Group], Roles.[Role], IsActive FROM Users INNER JOIN Groups ON Users.fk_GroupID = Groups.GroupID INNER JOIN Roles ON Users.fk_RoleID = Roles.RoleID WHERE fk_GroupID = '" & sessionGroupID & "'  ORDER BY FirstName ASC ", conn)
                                Dim reader As SqlDataReader = query.ExecuteReader()
                                If reader.HasRows Then
                                    While reader.Read
                                        dirUserID = CStr(reader("UserID"))
                                        dirFirstName = CStr(reader("FirstName"))
                                        dirLastName = CStr(reader("LastName"))
                                        dirEmail = CStr(reader("Email"))
                                        dirGroup = CStr(reader("Group"))
                                        dirUserType = CStr(reader("Role"))
                                        dirActive = CStr(reader("IsActive"))
                             %>
                                <tr>
                                <td>
                                    <% 
                                        rowCount = rowCount + 1
                                        Response.Write(rowCount)
                                    %>
                                </td>
                                    <td>
                                        <% Response.Write(dirFirstName & " " & dirLastName)%>
                                    </td>
                                    <td>
                                        <% Response.Write(dirEmail) %>
                                    </td>
                                    <td>
                                        <% Response.Write(dirUserType) %>
                                    </td>
                                    <td>
                                        <% Response.Write(dirGroup) %>
                                    </td>
                                    <td>
                                        <%
                                            If dirActive = True Then
                                         %>
                                        <i class="fa fa-check" style="color: green" aria-hidden="true"></i>
                                        <%
                                        Else
                                         %>
                                        <i class="fa fa-minus" style="color: red" aria-hidden="true"></i>
                                         <%
                                        End If
                                         %>
                                    </td>
                                </tr>
                              <%
                              End While
                              conn.Close()
                          Else
                              %>
                              <tr><%  Response.Write("There are no users")%></tr>
                              <%
                              End If
                              %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<%@ Page Title="QC :: Dashboard" Language="vb" AutoEventWireup="false" MasterPageFile="~/User.Master"
    CodeBehind="AdminDashboard.aspx.vb" Inherits="QualityControlMonitor.AdminDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
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
    <div class="row">
        <div class="row">
            <div class="col-sm-6 col-md-4">
                <div class="dashboardMiniBox">
                    <div class="thumbnail text-center">
                        <a href="CreateFile.aspx?SessionUserID=<% Response.Write(sessionUserID) %>"><span class="glyphicon glyphicon-file"></span></a>
                        <hr />
                        <div class="caption">
                            <h3> Quality Control Review</h3>
                            <p> Access the Quality of Clients' Documents</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-md-4">
                <div class="dashboardMiniBox">
                    <div class="thumbnail text-center">
                        <a href="ErrorReport.aspx?SessionUserID=<% Response.Write(sessionUserID) %>"><span class="glyphicon glyphicon-alert"></span></a>
                        <hr />
                        <div class="caption">
                            <h3> Error Report</h3>
                            <p>Outstanding Users' Errors via Comments</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-md-4">
                <div class="dashboardMiniBox">
                    <div class="thumbnail text-center">
                        <a href="CreateUser.aspx?SessionUserID=<% Response.Write(sessionUserID) %>"><span class="glyphicon glyphicon-cloud-upload"></span></a>
                        <hr />
                        <div class="caption">
                            <h3> Register User</h3>
                            <p>Add a new User to the Quality Control Monitor</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
           <div class="col-sm-6 col-md-4">
                <div class="dashboardMiniBox">
                    <div class="thumbnail text-center">
                        <a href="FileDirectory.aspx?SessionUserID=<% Response.Write(sessionUserID) %>"><i class="glyphicon glyphicon-inbox"></i></a>
                        <hr />
                        <div class="caption">
                            <h3>File Directory</h3>
                            <p>Manage and Search Files via Directory</p>
                        </div>
                    </div>
                </div>
           </div>
            <div class="col-sm-6 col-md-4">
                <div class="dashboardMiniBox">
                    <div class="thumbnail text-center">
                        <a href="StatisticalReport.aspx?SessionUserID=<% Response.Write(sessionUserID) %>"><span class="glyphicon glyphicon-signal"></span></a>
                        <hr />
                        <div class="caption">
                            <h3> Statistical Report</h3>
                            <p>Perform Analysis of Users' Errors</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-md-4">
                <div class="dashboardMiniBox">
                    <div class="thumbnail text-center">
                        <a href="UserDirectory.aspx?SessionUserID=<% Response.Write(sessionUserID) %>"><span class="glyphicon glyphicon-user"></span></a>
                        <hr />
                        <div class="caption">
                            <h3> User Directory</h3>
                            <p> Manage and Search Users via Directory</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-6 col-md-4">
                <div class="dashboardMiniBox">
                    <div class="thumbnail text-center">
                        <a href="ReviewList.aspx?SessionUserID=<% Response.Write(sessionUserID) %>"><span class="glyphicon glyphicon-list-alt"></span></a>
                        <hr />
                        <div class="caption">
                            <h3>Review List</h3>
                            <p>Itemization of Housing Users' Errors by Client</p>
                        </div>
                    </div>
                </div>
            </div>
          
            <div class="col-sm-6 col-md-4">

            </div>

            <div class="col-sm-6 col-md-4">
              <div class="dashboardMiniBox">
                    <div class="thumbnail text-center">
                        <a href="TeamRoster.aspx?SessionUserID=<% Response.Write(sessionUserID) %>"><i class="glyphicon glyphicon-tag"></i></a>
                        <hr />
                        <div class="caption">
                            <h3>Team Roster</h3>
                            <p>Search and View Team Members via Roster</p>
                        </div>
                    </div>
              </div>
            </div>
        </div>
    </div>
</asp:Content>
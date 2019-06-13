Imports System.Data.SqlClient
Imports System.Web.Configuration

Public Class Login
    Inherits System.Web.UI.Page
    Public Const ADMIN As Integer = 1
    Public Const AUDITOR As Integer = 2
    Public Const HOUSING_SPECIALIST As Integer = 3

    Dim conn As SqlConnection = New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub BtnSubmitClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnLoginUser.Click
        Dim email As String = Request.Form("email").Trim
        Dim password As String = Request.Form("password").Trim
        Dim sessionRoleID As Integer
        Dim sessionUserID As Integer
        Dim sessionUserActivity As Boolean

        conn.Open()
        Dim query As New SqlCommand("SELECT UserID, fk_RoleID, IsActive FROM Users WHERE Email='" & email & "' AND Password= '" & password & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()

        If reader.HasRows Then
            While reader.Read
                sessionRoleID = CStr(reader("fk_RoleID"))
                sessionUserID = CStr(reader("UserID"))
                sessionUserActivity = CStr(reader("IsActive"))
            End While
            conn.Close()

            If sessionUserActivity = False Then
                Response.Write("<div id='alertError'><div class='alert alert-danger' role='alert'>You have been disabled.</div></div>")
            Else
                If sessionRoleID = ADMIN Then
                    Response.Redirect("AdminDashboard.aspx?SessionUserID=" & sessionUserID & "")
                ElseIf sessionRoleID = AUDITOR Then
                    Response.Redirect("AuditorDashboard.aspx?SessionUserID=" & sessionUserID & "")
                ElseIf sessionRoleID = HOUSING_SPECIALIST Then
                    Response.Redirect("HousingSpecialistDashboard.aspx?SessionUserID=" & sessionUserID & "")
                End If
            End If
        Else
            Response.Write("<div id='alertError'><div class='alert alert-danger' role='alert'>Email/Password Incorrect.</div></div>")
        End If
    End Sub

End Class
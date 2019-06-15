Imports System.Data.SqlClient
Imports System.Web.Configuration

Public Class CreateUser
    Inherits System.Web.UI.Page
    Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Role.AppendDataBoundItems = True
            Role.Items.Insert(0, New ListItem("Role", ""))

            GroupType.AppendDataBoundItems = True
            GroupType.Items.Insert(0, New ListItem("Group Type", ""))
        End If
    End Sub

    Protected Sub BtnSubmitClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnRegisterUser.Click
        CreateUser()
    End Sub

    Public Sub CreateUser()
        Const DEFAULT_PASSWORD As String = "Qwerty1"
        Dim firstName As String = Request.Form("FirstName")
        Dim lastName As String = Request.Form("LastName")
        Dim email As String = Request.Form("Email")
        Dim roleID As Integer
        Dim groupTypeID As Integer
        Dim isActiveID As Boolean
        Dim isEnabled As Boolean = True

        If Role.SelectedValue Is Nothing Then
            roleID = 3 'Default - Case Manager
        Else
            roleID = Role.SelectedValue
        End If

        If GroupType.SelectedValue Is Nothing Then
            groupTypeID = 12 'Default - Team 1
        Else
            groupTypeID = GroupType.SelectedValue
        End If

        If IsActive.SelectedValue Is Nothing Then
            isActiveID = 1 'Default - Active
        Else
            isActiveID = IsActive.SelectedValue
        End If

        Dim query As String = String.Empty
        query &= "INSERT INTO Users (FirstName, LastName, Email, Password, fk_GroupID, fk_RoleID, IsActive, IsEnabled)"
        query &= "VALUES (@FirstName, @LastName, @Email, @Password, @fk_GroupID, @fk_RoleID, @IsActive, @IsEnabled)"

        Using comm As New SqlCommand()
            With comm
                .Connection = conn
                .CommandType = CommandType.Text
                .CommandText = query
                .Parameters.AddWithValue("@FirstName", firstName)
                .Parameters.AddWithValue("@LastName", lastName)
                .Parameters.AddWithValue("@Email", email)
                .Parameters.AddWithValue("@Password", DEFAULT_PASSWORD)
                .Parameters.AddWithValue("@fk_GroupID", groupTypeID)
                .Parameters.AddWithValue("@fk_RoleID", roleID)
                .Parameters.AddWithValue("@IsActive", isActiveID)
                .Parameters.AddWithValue("@IsEnabled", isEnabled)
            End With
            conn.Open()
            comm.ExecuteNonQuery()
            conn.Close()
        End Using
    End Sub
End Class
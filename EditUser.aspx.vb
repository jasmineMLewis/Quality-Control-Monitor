Imports System.Data.SqlClient
Imports System.Web.Configuration

Public Class EditUser
    Inherits System.Web.UI.Page
    Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)
    Const ADMIN_ROLE As Integer = 1

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim sessionUserID As String = GetSessionUserID()
            Dim urlUserID As String = GetUrlUserID(sessionUserID)
            Dim sessionUserRoleID As Integer = GetUserRoleID(sessionUserID)

            If sessionUserRoleID = ADMIN_ROLE Then
                SetFiltersForUser(urlUserID)
            End If
        End If
    End Sub

    Protected Sub BtnSubmitClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnEditUser.Click
        Dim sessionUserID As String = GetSessionUserID()
        Dim urlUserID As String = GetUrlUserID(sessionUserID)
        Dim sessionUserRoleID As Integer = GetUserRoleID(sessionUserID)

        If sessionUserRoleID = ADMIN_ROLE Then
            EditUserByAdmin(urlUserID)
        Else
            Dim isSuccessful As Integer = EditUser(urlUserID)
        End If
    End Sub

    Public Sub EditUserByAdmin(ByVal userID As Integer)
        Const HOUSING_SPECILAIST As Integer = 3
        Const DEFAULT_GROUP As Integer = 3 'Default
        Const ACTIVE As Integer = 1

        Dim firstName As String = Request.Form("FirstName").Trim
        Dim lastName As String = Request.Form("LastName").Trim
        Dim email As String = Request.Form("Email").Trim
        Dim password As String = Request.Form("Password").Trim
        Dim roleID As Integer
        Dim groupTypeID As Integer
        Dim isActiveID As Boolean

        If Role.SelectedValue Is Nothing Then
            roleID = HOUSING_SPECILAIST
        Else
            roleID = Role.SelectedValue
        End If

        If GroupType.SelectedValue Is Nothing Then
            groupTypeID = DEFAULT_GROUP
        Else
            groupTypeID = GroupType.SelectedValue
        End If

        If IsActive.SelectedValue Is Nothing Then
            isActiveID = ACTIVE
        Else
            isActiveID = IsActive.SelectedValue
        End If

        conn.Open()
        Dim query As New SqlCommand("UPDATE Users SET FirstName = '" & firstName & "', LastName = '" & lastName & "', Email = '" & email & "', Password = '" & password & "', fk_GroupID = '" & groupTypeID & "', fk_RoleID = '" & roleID & "', IsActive = '" & isActiveID & "' WHERE UserID = '" & userID & "'", conn)
        query.ExecuteNonQuery()
        conn.Close()
    End Sub

    'Auditor & Auditee edits thier profile
    Public Function EditUser(ByVal userID As Integer) As Integer
        Dim password As String = Request.Form("Password").Trim
        Dim isSuccessful As Integer = 0

        conn.Open()
        Dim query As New SqlCommand("UPDATE Users SET Password = '" & password & "' WHERE UserID = '" & userID & "'", conn)
        isSuccessful = query.ExecuteNonQuery()
        conn.Close()

        Return isSuccessful
    End Function

    Public Function GetSessionUserID() As String
        'Get user id from session to dictate which form will display
        Dim sessionUserID As String
        If Not Web.HttpContext.Current.Session("SessionUserID") Is Nothing Then
            sessionUserID = Web.HttpContext.Current.Session("SessionUserID").ToString()
        End If

        If sessionUserID = Nothing Then
            sessionUserID = Request.QueryString("SessionUserID")
            Web.HttpContext.Current.Session("SessionUserID") = sessionUserID
        End If

        Return sessionUserID
    End Function

    Public Function GetUrlUserID(ByVal id As String) As String
        Dim urlUserID As String = ""
        If Request.QueryString("UserID") Is Nothing Then
            'It is the session's user form to edit their info
            urlUserID = id
        Else
            'Get url's user id to edit that user's info
            urlUserID = Request.QueryString("UserID")
        End If
        Return urlUserID
    End Function

    Public Function GetUserRoleID(ByVal userID As Integer) As Integer
        conn.Open()
        Dim query As New SqlCommand("SELECT fk_RoleID FROM Users WHERE UserID  = '" & userID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()
        Dim roleID As Integer

        While reader.Read
            roleID = CStr(reader("fk_RoleID"))
        End While
        conn.Close()

        Return roleID
    End Function

    Public Sub SetFiltersForUser(ByVal userID As Integer)
        conn.Open()
        Dim groupID As Integer
        Dim roleID As Integer
        Dim isActiveID As Boolean

        Dim query As New SqlCommand("SELECT fk_GroupID, fk_RoleID, IsActive FROM Users WHERE UserID='" & userID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()
        While reader.Read
            groupID = CStr(reader("fk_GroupID"))
            roleID = CStr(reader("fk_RoleID"))
            isActiveID = CStr(reader("IsActive"))
        End While

        If roleID <> 0 Then
            Role.DataBind()
            Role.Items.FindByValue(roleID).Selected = True
        Else
            Role.AppendDataBoundItems = True
            Role.Items.Insert(0, New ListItem("Role", ""))
        End If

        If groupID <> 0 Then
            GroupType.DataBind()
            GroupType.Items.FindByValue(groupID).Selected = True
        Else
            GroupType.AppendDataBoundItems = True
            GroupType.Items.Insert(0, New ListItem("Group Type", ""))
        End If

        If Convert.ToInt32(isActiveID) <> -1 Then
            IsActive.DataBind()
            IsActive.Items.FindByValue(Convert.ToInt32(isActiveID)).Selected = True
        Else
            IsActive.AppendDataBoundItems = True
            IsActive.Items.Insert(0, New ListItem("Active", ""))
        End If

        conn.Close()
    End Sub
End Class
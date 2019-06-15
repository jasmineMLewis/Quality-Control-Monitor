Imports System.Data.SqlClient
Imports System.Web.Configuration

Public Class FileDirectory
    Inherits System.Web.UI.Page
    Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            SetFiltersToAll()
        End If
    End Sub

    Public Function DeleteFileLink(ByVal sessionUserID As Integer, ByVal fileID As Integer) As String
        Return "<a href=DeleteFile.ashx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & "><i class='fa fa-trash' aria-hidden='true'></i></a>"
    End Function

    Public Function DisplayClientNameLink(ByVal reviewTypeID As Integer, ByVal clientName As String, ByVal fileID As Integer, ByVal sessionUserID As Integer) As String
        Const ANNUAL_REEXAMINATION As Integer = 1
        Const ELIGIBILITY_SCREENING As Integer = 2
        Const INTERIM_REEXAMINATION As Integer = 3
        Const MOVES As Integer = 4
        Const PORT_IN As Integer = 5
        Const REASONABLE_RENT As Integer = 6
        Const SELECTION_FROM_WAITLIST As Integer = 7
        Const LEASING As Integer = 8

        Dim link As String = ""

        Select Case reviewTypeID
            Case ANNUAL_REEXAMINATION
                link = "<a href=CreateAnnualReexamination.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & ">" & clientName & "</a>"
            Case ELIGIBILITY_SCREENING
                link = "<a href=CreateEligibilityScreening.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & ">" & clientName & "</a>"
            Case INTERIM_REEXAMINATION
                link = "<a href=CreateInterimReexamination.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & ">" & clientName & "</a>"
            Case MOVES
                link = "<a href=CreateMoves.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & ">" & clientName & "</a>"
            Case PORT_IN
                link = "<a href=CreatePortIn.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & ">" & clientName & "</a>"
            Case REASONABLE_RENT
                link = "<a href=CreateReasonableRent.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & ">" & clientName & "</a>"
            Case SELECTION_FROM_WAITLIST
                link = "<a href=CreateSelectionFromWaitlist.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & ">" & clientName & "</a>"
            Case LEASING
                link = "<a href=CreateLeasing.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & ">" & clientName & "</a>"
        End Select

        Return link
    End Function

    Public Function DisplayDeleteFileLink(ByVal sessionUserID As Integer, ByVal fileID As Integer) As String
        Const ADMIN As Integer = 1
        Const AUDITOR_ID As Integer = 2

        Dim link As String = ""

        Dim roleID As Integer = GetUserRoleID(sessionUserID)
        Select Case roleID
            Case ADMIN
                link = DeleteFileLink(sessionUserID, fileID)
            Case AUDITOR_ID
                Dim auditorID As Integer = GetAuditorIDForFile(fileID)

                If sessionUserID = auditorID Then
                    link = DeleteFileLink(sessionUserID, fileID)
                End If
        End Select

        Return link
    End Function

    Public Function DisplayEditLink(ByVal fileID As Integer, ByVal sessionUserID As Integer) As String
        Return "<a href=EditFile.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID & "><i class='fa fa-pencil' aria-hidden='true'></i></a>"
    End Function

    Public Function DisplayFileLink(ByVal reviewTypeID As Integer, ByVal clientName As String, ByVal fileID As Integer, ByVal sessionUserID As Integer) As String
        Const ADMIN As Integer = 1
        Const AUDITOR_ID As Integer = 2

        Dim link As String = ""

        Dim roleID As Integer = GetUserRoleID(sessionUserID)
        Select Case roleID
            Case ADMIN
                link = DisplayClientNameLink(reviewTypeID, clientName, fileID, sessionUserID)
            Case AUDITOR_ID
                Dim auditorID As Integer = GetAuditorIDForFile(fileID)

                If sessionUserID = auditorID Then
                    link = DisplayClientNameLink(reviewTypeID, clientName, fileID, sessionUserID)
                Else
                    link = clientName
                End If
        End Select

        Return link
    End Function

    Private Function GetAuditorIDForFile(ByVal fileID As Integer) As Integer
        conn.Open()
        Dim auditorID As Integer
        Dim query As New SqlCommand("SELECT fk_AudtitorID FROM Files WHERE FileID  = '" & fileID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()

        While reader.Read
            auditorID = CStr(reader("fk_AudtitorID"))
        End While
        conn.Close()

        Return auditorID
    End Function

    Public Function GetUserRoleID(ByVal sessionUserID As Integer) As Integer
        Dim roleID As Integer

        conn.Open()
        Dim query As New SqlCommand("SELECT fk_RoleID FROM Users WHERE UserID  = '" & sessionUserID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()
        While reader.Read
            roleID = CStr(reader("fk_RoleID"))
        End While
        conn.Close()

        Return roleID
    End Function

    Protected Sub FilterReport(ByVal sender As Object, ByVal e As EventArgs) Handles btnFilterReport.Click
        Dim sql As String = "SELECT Files.FileID, Files.ClientFirstName + ' ' +  Files.ClientLastName As Client, " & _
                            "       Files.EliteID, Users.FirstName + ' ' +  Users.LastName AS FileHousingSpecialist," & _
                            "       Auditor.FirstName + ' ' + Auditor.LastName AS AuditorName, Files.fk_ReviewTypeID, ReviewTypes.Review, " & _
                            "       CONVERT (varchar(MAX), CAST(Files.ReviewDate AS date), 101) AS ReviewDate, " & _
                            "       CONVERT (varchar(MAX), CAST(Files.EffectiveDate AS date), 101) AS EffectiveDate, Files.Comment " & _
                            "FROM Files " & _
                            "INNER JOIN Users ON Files.fk_CaseManagerID = Users.UserID " & _
                            "INNER JOIN Users As Auditor ON Files.fk_AudtitorID = Auditor.UserID " & _
                            "INNER JOIN ReviewTypes ON Files.fk_ReviewTypeID = ReviewTypes.ReviewTypeID"

        Dim firstName As String = ClientFirstName.Text
        Dim lastname As String = ClientLastName.Text
        Dim clientID As String = EliteID.Text
        Dim fileStaffID As Integer = FileStaff.SelectedValue
        Dim auditorID As Integer = Auditor.SelectedValue
        Dim reviewTypeID As Integer = ReviewType.SelectedValue

        If Not String.IsNullOrEmpty(firstName) Then
            sql += " AND Files.ClientFirstName LIKE '" + firstName.ToString() + "%'"
        End If

        If Not String.IsNullOrEmpty(lastname) Then
            sql += " AND Files.ClientLastName LIKE '" + lastname.ToString() + "%'"
        End If

        If Not String.IsNullOrEmpty(clientID) Then
            sql += " AND Files.EliteID LIKE '" + clientID.ToString() + "%'"
        End If

        If (fileStaffID > 0) Then
            sql += " AND Files.fk_CaseManagerID = " + fileStaffID.ToString()
        End If

        If (auditorID > 0) Then
            sql += " AND Auditor.UserID = " + auditorID.ToString()
        End If

        If (reviewTypeID > 0) Then
            sql += " AND ReviewTypes.ReviewTypeID = " + reviewTypeID.ToString()
        End If

        SqlFileDirectory.SelectCommand = sql
        SqlFileDirectory.DataBind()
        GridView1.DataBind()
    End Sub

    Public Sub SetFiltersToAll()
        FileStaff.AppendDataBoundItems = True
        FileStaff.Items.Insert(0, New ListItem("ALL", 0))

        Auditor.AppendDataBoundItems = True
        Auditor.Items.Insert(0, New ListItem("ALL", 0))

        ReviewType.AppendDataBoundItems = True
        ReviewType.Items.Insert(0, New ListItem("ALL", 0))
    End Sub

    Public Overrides Sub VerifyRenderingInServerForm(ByVal control As Control)
        ' Confirms that an HtmlForm control is rendered for the specified ASP.NET
        '     server control at run time. 
    End Sub
End Class
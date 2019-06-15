Imports System.Data.SqlClient
Imports System.Globalization
Imports System.Web.Configuration

Public Class CreateFile
    Inherits System.Web.UI.Page
    Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CaseManager.AppendDataBoundItems = True
            CaseManager.Items.Insert(0, New ListItem("Housing Specialist", ""))

            ReviewType.AppendDataBoundItems = True
            ReviewType.Items.Insert(0, New ListItem("Review Type", ""))
        End If
    End Sub

    Public Function CreateFile(ByVal submittedByUserID As Integer) As Integer
        Dim fileID As Integer
        Dim clientFirstName As String = Request.Form("ClientFirstName").Trim
        Dim clientLastName As String = Request.Form("ClientLastName").Trim
        Dim eliteID As String = Request.Form("ClientID").Trim
        Dim caseManagerID As Integer = CaseManager.SelectedValue
        Dim reviewTypeID As Integer = ReviewType.SelectedValue

        'The format that the date control uses
        Const DATE_FORMAT As String = "MM/dd/yyyy"
        Dim parsedReviewDate As DateTime = DateTime.ParseExact(ReviewDate.Text, DATE_FORMAT, CultureInfo.InvariantCulture)
        Dim parsedEffectiveDate As DateTime = DateTime.ParseExact(EffectiveDate.Text, DATE_FORMAT, CultureInfo.InvariantCulture)
        Dim comment As String = Request.Form("Comment").Trim

        Dim query As String = String.Empty
        query &= "INSERT INTO Files (ClientFirstName, ClientLastName, EliteID, fk_CaseManagerID, fk_ReviewTypeID, ReviewDate, EffectiveDate, Comment, fk_AudtitorID, IsReviewComplete, IsFileDisable)"
        query &= "VALUES (@ClientFirstName, @ClientLastName, @EliteID, @fk_CaseManagerID, @fk_ReviewTypeID, @ReviewDate, @EffectiveDate, @Comment, @fk_AudtitorID, @IsReviewComplete, @IsFileDisable)"
        query &= "SELECT @@IDENTITY from Files"

        Using comm As New SqlCommand()
            With comm
                .Connection = conn
                .CommandType = CommandType.Text
                .CommandText = query
                .Parameters.AddWithValue("@ClientFirstName", clientFirstName)
                .Parameters.AddWithValue("@ClientLastName", clientLastName)
                .Parameters.AddWithValue("@EliteID", eliteID)
                .Parameters.AddWithValue("@fk_CaseManagerID", caseManagerID)
                .Parameters.AddWithValue("@fk_ReviewTypeID", reviewTypeID)
                .Parameters.AddWithValue("@ReviewDate", parsedReviewDate)
                .Parameters.AddWithValue("@EffectiveDate", parsedEffectiveDate)
                .Parameters.AddWithValue("@Comment", comment)
                .Parameters.AddWithValue("@fk_AudtitorID", submittedByUserID)
                .Parameters.AddWithValue("@IsReviewComplete", 0)
                .Parameters.AddWithValue("@IsFileDisable", 0)
            End With
            conn.Open()
            fileID = comm.ExecuteScalar()
            conn.Close()
        End Using

        Return fileID
    End Function

    Public Function DoesReviewExists(ByVal eliteID As Integer, ByVal reviewTypeID As Integer, ByVal effectiveDate As DateTime) As Boolean
        Dim isExists As Boolean
        conn.Open()
        Dim query As New SqlCommand("SELECT FileID FROM Files WHERE EliteID = '" & eliteID & "' AND fk_ReviewTypeID = '" & reviewTypeID & "' AND EffectiveDate = '" & effectiveDate & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()

        If reader.HasRows Then
            isExists = True
        Else
            isExists = False
        End If
        conn.Close()

        Return isExists
    End Function

    Public Function GetFileReviewType(ByVal fileID As Integer) As Integer
        Dim reviewTypeID As Integer

        conn.Open()
        Dim query As New SqlCommand("SELECT fk_ReviewTypeID FROM Files WHERE FileID = '" & fileID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()
        While reader.Read
            reviewTypeID = CStr(reader("fk_ReviewTypeID"))
        End While
        conn.Close()

        Return reviewTypeID
    End Function

    Protected Sub InitiateReview(ByVal sender As Object, ByVal e As EventArgs) Handles btnInitiateReview.Click
        Dim sessionUserID As String
        If Not Web.HttpContext.Current.Session("SessionUserID") Is Nothing Then
            sessionUserID = Web.HttpContext.Current.Session("SessionUserID").ToString()
        End If

        If sessionUserID = Nothing Then
            sessionUserID = Request.QueryString("SessionUserID")
            Web.HttpContext.Current.Session("SessionUserID") = sessionUserID
        End If

        Dim eliteID As String = Request.Form("ClientID").Trim
        Dim reviewTypeID As Integer = ReviewType.SelectedValue

        'The format that the date control uses
        Const DATE_FORMAT As String = "MM/dd/yyyy"
        Dim parsedEffectiveDate As DateTime = DateTime.ParseExact(EffectiveDate.Text, DATE_FORMAT, CultureInfo.InvariantCulture)

        If DoesReviewExists(eliteID, reviewTypeID, parsedEffectiveDate) Then
            Response.Write("<div class='alert alert-danger'><strong>Submission Already!</strong> A review for that file has been submitted already!</div>")
        Else
            Dim fileID As Integer = CreateFile(sessionUserID)
            GetFileReviewType(fileID)
            RedirectToReviewPage(reviewTypeID, sessionUserID, fileID)
        End If
    End Sub

    Public Sub RedirectToReviewPage(ByVal ReviewTypeID As Integer, ByVal sessionUserID As Integer, ByVal fileID As Integer)
        Const ANNUAL_REEXAMINATION As Integer = 1
        Const ELIGIBILITY_SCREENING As Integer = 2
        Const INTERIM_REEXAMINATION As Integer = 3
        Const MOVES As Integer = 4
        Const PORT_IN As Integer = 5
        Const REASONABLE_RENT As Integer = 6
        Const SELECTION_FROM_WAITLIST As Integer = 7
        Const LEASING As Integer = 8

        Select Case ReviewTypeID
            Case ANNUAL_REEXAMINATION
                Response.Redirect("CreateAnnualReexamination.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID)
            Case ELIGIBILITY_SCREENING
                Response.Redirect("CreateEligibilityScreening.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID)
            Case INTERIM_REEXAMINATION
                Response.Redirect("CreateInterimReexamination.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID)
            Case MOVES
                Response.Redirect("CreateMoves.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID)
            Case PORT_IN
                Response.Redirect("CreatePortIn.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID)
            Case REASONABLE_RENT
                Response.Redirect("CreateReasonableRent.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID)
            Case SELECTION_FROM_WAITLIST
                Response.Redirect("CreateSelectionFromWaitlist.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID)
            Case LEASING
                Response.Redirect("CreateLeasing.aspx?SessionUserID=" & sessionUserID & "&FileID=" & fileID)
        End Select
    End Sub
End Class
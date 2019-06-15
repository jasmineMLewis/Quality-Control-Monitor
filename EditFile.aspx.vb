Imports System.Data.SqlClient
Imports System.Globalization
Imports System.Web.Configuration

Public Class EditFile
    Inherits System.Web.UI.Page
    Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            SetFiltersForFile(Request.QueryString("FileID"))
        End If
    End Sub

    Protected Sub BtnSubmitClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnEditFile.Click
        Dim clientFirstName As String = Request.Form("ClientFirstName").Trim
        Dim clientlastName As String = Request.Form("ClientLastName").Trim
        Dim eliteID As String = Request.Form("ClientID").Trim
        Dim caseManagerID As Integer = CaseManager.SelectedValue
        Dim reviewTypeID As Integer = ReviewType.SelectedValue
        Dim reviewDateConverted As Date = ConvertStringToDate(ReviewDate.Text)
        Dim effectiveDateConverted As Date = ConvertStringToDate(EffectiveDate.Text)
        Dim comment As String = Request.Form("Comment").Trim

        conn.Open()
        Dim query As String = "UPDATE Files SET ClientFirstName = '" & clientFirstName & "', ClientLastName = '" & clientlastName & "', EliteID = '" & eliteID & "', fk_CaseManagerID = '" & caseManagerID & "', fk_ReviewTypeID  = '" & reviewTypeID & "', ReviewDate = '" & reviewDateConverted & "', EffectiveDate = '" & effectiveDateConverted & "', Comment = '" & comment & "' WHERE FileID = '" & Request.QueryString("FileID") & "'"
        Dim queryDocument As New SqlCommand(query, conn)
        queryDocument.ExecuteReader()
        conn.Close()
    End Sub

    Public Function ConvertStringToDate(ByVal dateInput As String) As Date
        Dim provider As CultureInfo = CultureInfo.InvariantCulture
        Dim format As String = "d"
        Return Date.ParseExact(dateInput, format, provider)
    End Function

    Public Sub SetFiltersForFile(ByVal fileID As Integer)
        conn.Open()
        Dim caseManagerID As Integer
        Dim reviewTypeID As Integer
        Dim reviewDateDB As Date
        Dim effectiveDateDB As Date

        Dim query As New SqlCommand("SELECT fk_CaseManagerID, fk_ReviewTypeID, ReviewDate, EffectiveDate FROM Files WHERE FileID='" & fileID & "'", conn)
        Dim reader As SqlDataReader = query.ExecuteReader()
        While reader.Read
            caseManagerID = CStr(reader("fk_CaseManagerID"))
            reviewTypeID = CStr(reader("fk_ReviewTypeID"))
            reviewDateDB = CStr(reader("ReviewDate"))
            effectiveDateDB = CStr(reader("EffectiveDate"))
        End While

        If caseManagerID <> 0 Then
            CaseManager.DataBind()
            CaseManager.Items.FindByValue(caseManagerID).Selected = True
        Else
            CaseManager.AppendDataBoundItems = True
            CaseManager.Items.Insert(0, New ListItem("Case Manager", ""))
        End If

        If reviewTypeID <> 0 Then
            ReviewType.DataBind()
            ReviewType.Items.FindByValue(reviewTypeID).Selected = True
        Else
            ReviewType.AppendDataBoundItems = True
            ReviewType.Items.Insert(0, New ListItem("Case Manager", ""))
        End If

        ReviewDateCalendar.SelectedDate = reviewDateDB
        EffectiveDateCalendar.SelectedDate = effectiveDateDB
    End Sub
End Class
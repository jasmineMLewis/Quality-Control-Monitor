Imports System.Web
Imports System.Data.SqlClient
Imports System.Web.Configuration

Public Class DisableUser
    Implements System.Web.IHttpHandler
    Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim userID As Integer = Integer.Parse(context.Request.QueryString("UserID"))

        conn.Open()
        Dim query As New SqlCommand("UPDATE Users SET IsActive = '0', IsEnabled = '0' WHERE UserID = '" & userID & "'", conn)
        query.ExecuteNonQuery()
        conn.Close()

        context.Response.Redirect(context.Request.UrlReferrer.ToString())
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
End Class
Imports System.Web
Imports System.Data.SqlClient
Imports System.Web.Configuration

Public Class DeleteFileError
    Implements System.Web.IHttpHandler


    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim errorID As Integer = Integer.Parse(context.Request.QueryString("ErrorID"))
        Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)

        conn.Open()
        Dim query As New SqlCommand("DELETE FROM FileErrors WHERE ErrorID = '" & errorID & "'", conn)
        query.ExecuteNonQuery()
        conn.Close()

        context.Response.Redirect(context.Request.UrlReferrer.ToString())
    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
End Class
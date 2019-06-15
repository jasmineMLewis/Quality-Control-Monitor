Imports System.Web
Imports System.Data.SqlClient
Imports System.Web.Configuration

Public Class DeleteFile
    Implements System.Web.IHttpHandler
    Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim fileID As Integer = Integer.Parse(context.Request.QueryString("FileID"))

        'Delete FileReviewedDocuments
        DeleteFileReviewedDocuments(fileID)

        'Delete FileReviewedProcesses
        DeleteFileReviewedProcesses(fileID)

        'Delete FileErrorsDocumentTypes
        FileErrorsDocumentTypes(fileID)

        'Delete LotteryNumberErrors
        DeleteLotteryNumberErrors(fileID)

        'Delete SpecialCaseErrors
        DeleteSpecialCaseErrors(fileID)

        'Delete File Errors
        DeleteFileErrors(fileID)

        'Delete File
        DeleteFile(fileID)

        context.Response.Redirect(context.Request.UrlReferrer.ToString())
    End Sub

    Public Sub DeleteFile(ByVal fileID As Integer)
        conn.Open()
        Dim query As New SqlCommand("DELETE FROM Files WHERE FileID = '" & fileID & "'", conn)
        query.ExecuteNonQuery()
        conn.Close()
    End Sub

    Public Sub DeleteFileErrors(ByVal fileID As Integer)
        conn.Open()
        Dim query As New SqlCommand("DELETE FROM FileErrors WHERE fk_FileID = '" & fileID & "'", conn)
        query.ExecuteNonQuery()
        conn.Close()
    End Sub

    Public Sub FileErrorsDocumentTypes(ByVal fileID As Integer)
        conn.Open()
        Dim query As New SqlCommand("DELETE FROM FileErrorsDocumentTypes WHERE fk_FileID = '" & fileID & "'", conn)
        query.ExecuteNonQuery()
        conn.Close()
    End Sub

    Public Sub DeleteFileReviewedDocuments(ByVal fileID As Integer)
        conn.Open()
        Dim query As New SqlCommand("DELETE FROM FileReviewedDocuments WHERE fk_FileID = '" & fileID & "'", conn)
        query.ExecuteNonQuery()
        conn.Close()
    End Sub

    Public Sub DeleteFileReviewedProcesses(ByVal fileID As Integer)
        conn.Open()
        Dim query As New SqlCommand("DELETE FROM FileReviewedProcesses WHERE fk_FileID = '" & fileID & "'", conn)
        query.ExecuteNonQuery()
        conn.Close()
    End Sub

    Public Sub DeleteLotteryNumberErrors(ByVal fileID As Integer)
        conn.Open()
        Dim query As New SqlCommand("DELETE FROM LotteryNumberErrors WHERE fk_FileID = '" & fileID & "'", conn)
        query.ExecuteNonQuery()
        conn.Close()
    End Sub

    Public Sub DeleteSpecialCaseErrors(ByVal fileID As Integer)
        conn.Open()
        Dim query As New SqlCommand("DELETE FROM SpecialCaseErrors WHERE fk_FileID = '" & fileID & "'", conn)
        query.ExecuteNonQuery()
        conn.Close()
    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
End Class
<%@ Page Title="QC :: Rent" Language="vb" AutoEventWireup="false" MasterPageFile="~/FileDetails.master" CodeBehind="CreateReasonableRent.aspx.vb" Inherits="QualityControlMonitor.CreateReasonableRent" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="nestedContent" runat="server">
    <div class="row">
        <div class="col-lg-12 col-md-7">
            <div class="card">
                <div class="header">
                    <h4 class="title">
                        <i class="fa fa-money" aria-hidden="true"></i> QC Review :: Reasonable Rent</h4>
                    <hr />
                </div>
                <div class="content">
                    <form action="" method="post" runat="server">
                    <div class="text-center">
                            <%
                                Dim connReview As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)
                                connReview.Open()
                                Dim fileID As Integer = Request.QueryString("FileID")

                                Dim isReviewComplete As Boolean
                                Dim result As New SqlCommand("SELECT IsReviewComplete FROM Files WHERE FileID = '" & fileID & "'", connReview)
                                Dim reader As SqlDataReader = result.ExecuteReader()
                                While reader.Read
                                    isReviewComplete = CStr(reader("IsReviewComplete"))
                                End While

                                If isReviewComplete = False Then
                          %>
                             <asp:Button ID="btnCompleteReview" runat="server" class="btn btn-info btn-fill btn-wd" Text="Complete Reasonable Rent Review" />
                          <%
                                Else
                          %>
                           <asp:Button ID="btnUpdateReview" runat="server" class="btn btn-warning btn-fill btn-wd" Text="Resubmit Reasonable Rent Review" />
                          <%
                          End If
                          connReview.Close()
                        %>
                    </div>
                    <div class="clearfix"> </div>
                    <br />
                    <ul class="nav nav-tabs nav-justified" role="tablist">
                        <li role="presentation" class="active"><a href="#process" aria-controls="process"
                            role="tab" data-toggle="tab"><i class="fa fa-folder-open" aria-hidden="true"></i>
                            &nbsp;&nbsp; Processing</a>
                        </li>
                        <li role="presentation"><a href="#documents" aria-controls="documents" role="tab"
                            data-toggle="tab"><i class="fa fa-file-text" aria-hidden="true"></i>&nbsp;&nbsp;
                            Documents</a>
                        </li>
                    </ul>
                    <div class="tab-content">
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
                        <div role="tabpanel" class="tab-pane fade active in" id="process">
                            <br />
                            <div class="panel panel-info">
                                <div class="panel-heading">
                                    <h4 class="panel-title">
                                      <i class="fa fa-money" aria-hidden="true"></i>  Reasonable Rent
                                    </h4>
                                </div>
                                <div class="panel-body">
                                    <hr />
                                    <div id="data-entry">
                                        <h6>Data Entry
                                             &nbsp; &nbsp; &nbsp;
                                        <%
                                            Dim conn As New SqlConnection(WebConfigurationManager.ConnectionStrings("QualityControlMonitorConnectionString").ConnectionString)
                                            conn.Open()
                                            Dim processes As New ArrayList
                                            Dim queryProcesses As New SqlCommand("SELECT fk_ProcessID FROM FileReviewedProcesses WHERE fk_FileID ='" & fileID & "'", conn)
                                            Dim readerProcesses As SqlDataReader = queryProcesses.ExecuteReader()
                                            If readerProcesses.HasRows Then
                                                While readerProcesses.Read
                                                    processes.Add(CStr(readerProcesses("fk_ProcessID")))
                                                End While
                                            End If
                                            conn.Close()

                                            If processes.Count > 0 Then
                                                If processes.Contains("13") Then
                                                    Response.Write("<input type='checkbox' name='processDataEntry' checked='checked' />")
                                                Else
                                                    Response.Write("<input type='checkbox' name='processDataEntry' />")
                                                End If
                                            Else
                                                Response.Write("<input type='checkbox' name='processDataEntry' />")
                                            End If
                                            %>
                                        </h6>
                                        <br />
                                        <% 
                                            conn.Open()
                                            Dim errorDataEntryID As Integer
                                            Dim detailsDataEntry As String
                                            Dim noticeTypeDataEntry As String
                                            Dim statusDataEntry As String
                                            Dim errorStaffNameDataEntry As String
                                            Dim errorDataEntryReviewTypeID As Integer
                                            Dim processDataEntryID As Integer
                                            
                                            Dim queryDataEntry As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE fk_FileID = '" & fileID & "' AND fk_ProcessTypeID = 13 ORDER BY NoticeTypes.Notice", conn)
                                            Dim readerDataEntry As SqlDataReader = queryDataEntry.ExecuteReader()
                                            If readerDataEntry.HasRows Then
                                                While readerDataEntry.Read
                                                    errorDataEntryID = CStr(readerDataEntry("ErrorID"))
                                                    detailsDataEntry = CStr(readerDataEntry("Details"))
                                                    noticeTypeDataEntry = CStr(readerDataEntry("Notice"))
                                                    statusDataEntry = CStr(readerDataEntry("Status"))
                                                    errorStaffNameDataEntry = CStr(readerDataEntry("ErrorStaffName"))
                                                    errorDataEntryReviewTypeID = CStr(readerDataEntry("fk_ReviewTypeID"))
                                                    processDataEntryID = CStr(readerDataEntry("fk_ProcessTypeID"))
                                        %>
                                               <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDataEntry) %>" type="text" />
                                                 </div>
                                               </div>
                                               <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                 <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDataEntry)%></textarea>
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDataEntry) %>" type="text" />
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDataEntry) %>"  type="text" />
                                                </div>
                                               </div>
                                               <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDataEntryID) %>&ReviewTypeID=<% Response.Write(errorDataEntryReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDataEntryID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                               <div class="clearfix"></div>
                                                 <br />
                                        <%
                                        End While
                                    End If
                                        conn.Close()
                                        %>
                                                                
                                           <div class="col-md-2">
                                            <div class="form-group">
                                                <asp:DropDownList ID="NoticeType13" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeType13" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeType13" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4'">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                           <div class="col-md-4">
                                            <div class="form-group">
                                                <textarea class="form-control border-input" cols="4" name="Comment13" placeholder="Comment"
                                                    rows="1"></textarea>
                                            </div>
                                        </div>
                                           <div class="col-md-2">
                                               <div class="form-group">
                                                        <asp:DropDownList ID="CaseManager13" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManager" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManager" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3'  OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                       </div>
                                           <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="Status13" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                           <div class="text-center">
                                            <asp:Button ID="btnCreateProcess13" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                        </div>
                                        <div class="clearfix"> </div>

                                        <hr />
                                    </div>
                                    <div id="process-other">
                                        <h6> Other
                                             &nbsp; &nbsp; &nbsp;
                                             <%
                                                If processes.Count > 0 Then
                                                    If processes.Contains("21") Then
                                                        Response.Write("<input type='checkbox' name='processOther' checked='checked' />")
                                                    Else
                                                        Response.Write("<input type='checkbox' name='processOther' />")
                                                    End If
                                                Else
                                                    Response.Write("<input type='checkbox' name='processOther' />")
                                                End If
                                             %>
                                         </h6>
                                        <br />
                                             <%
                                            conn.Open()
                                                 Dim errorProcessOtherID As Integer
                                                 Dim detailsProcessOther As String
                                                 Dim noticeTypeProcessOther As String
                                                 Dim statusProcessOther As String
                                                 Dim errorStaffNameProcessOther As String
                                                 Dim errorProcessOtherReviewTypeID As Integer
                                                 Dim processOtherID As Integer
                                            
                                                 
                                                 Dim queryProcessOther As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE fk_FileID = '" & fileID & "' AND fk_ProcessTypeID = 21 ORDER BY NoticeTypes.Notice", conn)
                                                 Dim readerProcessOther As SqlDataReader = queryProcessOther.ExecuteReader()
                                                 If readerProcessOther.HasRows Then
                                                     While readerProcessOther.Read
                                                         errorProcessOtherID = CStr(readerProcessOther("ErrorID"))
                                                         detailsProcessOther = CStr(readerProcessOther("Details"))
                                                         noticeTypeProcessOther = CStr(readerProcessOther("Notice"))
                                                         statusProcessOther = CStr(readerProcessOther("Status"))
                                                         errorStaffNameProcessOther = CStr(readerProcessOther("ErrorStaffName"))
                                                         errorProcessOtherReviewTypeID = CStr(readerProcessOther("fk_ReviewTypeID"))
                                                         processOtherID = CStr(readerProcessOther("fk_ProcessTypeID"))
                                             %>
                                               <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeProcessOther) %>" type="text" />
                                                 </div>
                                               </div>
                                               <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                 <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsProcessOther)%></textarea>
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameProcessOther) %>" type="text" />
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusProcessOther) %>"  type="text" />
                                                </div>
                                               </div>
                                               <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorProcessOtherID) %>&ReviewTypeID=<% Response.Write(errorProcessOtherReviewTypeID) %>&ProcessTypeID=<% Response.Write(processOtherID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                               <div class="clearfix"></div>
                                                 <br />
                                        <%
                                        End While
                                    End If
                                        conn.Close()
                                        %>
                                         <div class="col-md-2">
                                            <div class="form-group">
                                                 <asp:DropDownList ID="NoticeType21" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeType21" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeType21" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4'">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                           <div class="col-md-4">
                                            <div class="form-group">
                                                <textarea class="form-control border-input" cols="4" name="Comment21" placeholder="Comment"
                                                    rows="1"></textarea>
                                            </div>
                                        </div>
                                           <div class="col-md-2">
                                               <div class="form-group">
                                                        <asp:DropDownList ID="CaseManager21" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManager21" DataValueField="UserID" DataTextField="FullName" required="required"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManager21" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3'  OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                       </div>
                                          <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="Status21" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                        <div class="text-center">
                                         <asp:Button ID="btnCreateProcess21" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <hr />
                                    </div>
                                    <div id="reasonable-rent">
                                        <h6>Reasonable Rent
                                             &nbsp; &nbsp; &nbsp;
                                             <%
                                                If processes.Count > 0 Then
                                                     If processes.Contains("15") Then
                                                         Response.Write("<input type='checkbox' name='processReasonableRent' checked='checked' />")
                                                     Else
                                                         Response.Write("<input type='checkbox' name='processReasonableRent' />")
                                                     End If
                                                Else
                                                    Response.Write("<input type='checkbox' name='processReasonableRent' />")
                                                End If
                                             %>
                                        </h6>
                                        <br />
                                             <%
                                            conn.Open()
                                                 Dim errorProcessReasonableRentID As Integer
                                                 Dim detailsProcessReasonableRent As String
                                                 Dim noticeTypeProcessReasonableRent As String
                                                 Dim statusProcessReasonableRent As String
                                                 Dim errorStaffNameProcessReasonableRent As String
                                                 Dim errorReviewTypeIDReasonableRent As Integer
                                                 Dim processReasonableRentID As Integer
                                            
                                                 Dim queryProcessReasonableRent As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE fk_FileID = '" & fileID & "' AND fk_ProcessTypeID = 15 ORDER BY NoticeTypes.Notice", conn)
                                                 Dim readerProcessReasonableRent As SqlDataReader = queryProcessReasonableRent.ExecuteReader()
                                                 If readerProcessReasonableRent.HasRows Then
                                                     While readerProcessReasonableRent.Read
                                                         errorProcessReasonableRentID = CStr(readerProcessReasonableRent("ErrorID"))
                                                         detailsProcessReasonableRent = CStr(readerProcessReasonableRent("Details"))
                                                         noticeTypeProcessReasonableRent = CStr(readerProcessReasonableRent("Notice"))
                                                         statusProcessReasonableRent = CStr(readerProcessReasonableRent("Status"))
                                                         errorStaffNameProcessReasonableRent = CStr(readerProcessReasonableRent("ErrorStaffName"))
                                                         errorReviewTypeIDReasonableRent = CStr(readerProcessReasonableRent("fk_ReviewTypeID"))
                                                         processReasonableRentID = CStr(readerProcessReasonableRent("fk_ProcessTypeID"))
                                             %>
                                               <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeProcessReasonableRent) %>" type="text" />
                                                 </div>
                                               </div>
                                               <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                 <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsProcessReasonableRent)%></textarea>
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameProcessReasonableRent) %>" type="text" />
                                            </div>
                                               </div>
                                               <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusProcessReasonableRent) %>"  type="text" />
                                                </div>
                                               </div>
                                               <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorProcessReasonableRentID) %>&ReviewTypeID=<% Response.Write(errorReviewTypeIDReasonableRent) %>&ProcessTypeID=<% Response.Write(processReasonableRentID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                               <div class="clearfix"></div>
                                                 <br />
                                        <%
                                        End While
                                    End If
                                        conn.Close()
                                        %>

                                        <div class="col-md-2">
                                            <div class="form-group">
                                                    <asp:DropDownList ID="NoticeType15" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeType15" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeType15" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '1' OR [NoticeTypeID] = '2' OR [NoticeTypeID] = '4'">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <textarea class="form-control border-input" cols="4" name="Comment15" placeholder="Comment"
                                                    rows="1"></textarea>
                                            </div>
                                        </div>
                                          <div class="col-md-2">
                                               <div class="form-group">
                                                        <asp:DropDownList ID="CaseManager15" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManager15" DataValueField="UserID" DataTextField="FullName" required="required"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManager15" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3'  OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                       </div>
                                          <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="Status15" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                        <div class="text-center">
                                            <asp:Button ID="btnCreateProcess15" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                        </div>
                                        <div class="clearfix">
                                        </div>
                                        <hr />
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div role="tabpanel" class="tab-pane fade" id="documents">
                            <br />
                            <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                                <div class="panel panel-info">
                                    <div class="panel-heading" role="tab" id="headingOne">
                                        <h4 class="panel-title">
                                            <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne"
                                                aria-expanded="true" aria-controls="collapseOne">
                                                <i class="fa fa-home" aria-hidden="true"></i> Leasing Documents </a>
                                        </h4>
                                    </div>
                                    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="panel-body">
                                            <hr />
                                            <div id="amenities-report">
                                                <h6>Amenities Report
                                                     &nbsp; &nbsp; &nbsp;
                                                 <%
                                                     conn.Open()
                                                     Dim documents As New ArrayList
                                                     Dim queryDocuments As New SqlCommand("SELECT fk_DocumentID FROM FileReviewedDocuments WHERE fk_FileID ='" & fileID & "'", conn)
                                                     Dim readerDocuments As SqlDataReader = queryDocuments.ExecuteReader()
                                                     If readerDocuments.HasRows Then
                                                         While readerDocuments.Read
                                                             documents.Add(CStr(readerDocuments("fk_DocumentID")))
                                                         End While
                                                     End If
                                                     conn.Close()
                                                     
                                                     If documents.Count > 0 Then
                                                         If documents.Contains("1") Then
                                                             Response.Write("<input type='checkbox' name='documentAmenitiesReport' checked='checked' />")
                                                         Else
                                                             Response.Write("<input type='checkbox' name='documentAmenitiesReport' />")
                                                         End If
                                                     Else
                                                         Response.Write("<input type='checkbox' name='documentAmenitiesReport' />")
                                                     End If
                                                %>
                                                </h6>
                                                <br />
                                                       <%
                                            conn.Open()
                                                           Dim errorDocumentAmenitiesReportErrorID As Integer
                                                           Dim errorDocumentAmenitiesReportID As Integer
                                                           Dim detailsDocumentAmenitiesReport As String
                                                           Dim noticeTypeDocumentAmenitiesReport As String
                                                           Dim statusDocumentAmenitiesReport As String
                                                           Dim errorStaffNameDocumentAmenitiesReport As String
                                                           Dim errorDocumentAmenitiesReportReviewTypeID As Integer
                                                           Dim errorsAmenitiesReportList As New ArrayList
                                                           Dim processDocumentAmenitiesReportErrorID As Integer
                                                        
                                                           Dim queryDocumentAmenitiesReportError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '1' AND fk_FileID = '" & fileID & "'", conn)
                                                           Dim readerDocumentAmenitiesReportError As SqlDataReader = queryDocumentAmenitiesReportError.ExecuteReader()
                                                           If readerDocumentAmenitiesReportError.HasRows Then
                                                               While readerDocumentAmenitiesReportError.Read
                                                                   errorDocumentAmenitiesReportErrorID = CStr(readerDocumentAmenitiesReportError("fk_ErrorID"))
                                                                   errorsAmenitiesReportList.Add(errorDocumentAmenitiesReportErrorID)
                                                               End While
                                                           End If
                                                    conn.Close()
                                           
                                                    conn.Open()
                                                           Dim errorAmenitiesReportIndex As Integer
                                                           For Each errorAmenitiesReportIndex In errorsAmenitiesReportList
                                                               Dim queryDocumentAmenitiesReport As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorAmenitiesReportIndex & "'", conn)
                                                               Dim readerDocumentAmenitiesReport As SqlDataReader = queryDocumentAmenitiesReport.ExecuteReader()
                                                               While readerDocumentAmenitiesReport.Read
                                                                   errorDocumentAmenitiesReportID = CStr(readerDocumentAmenitiesReport("ErrorID"))
                                                                   detailsDocumentAmenitiesReport = CStr(readerDocumentAmenitiesReport("Details"))
                                                                   noticeTypeDocumentAmenitiesReport = CStr(readerDocumentAmenitiesReport("Notice"))
                                                                   statusDocumentAmenitiesReport = CStr(readerDocumentAmenitiesReport("Status"))
                                                                   errorStaffNameDocumentAmenitiesReport = CStr(readerDocumentAmenitiesReport("ErrorStaffName"))
                                                                   errorDocumentAmenitiesReportReviewTypeID = CStr(readerDocumentAmenitiesReport("fk_ReviewTypeID"))
                                                                   processDocumentAmenitiesReportErrorID = CStr(readerDocumentAmenitiesReport("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentAmenitiesReport) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                 <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentAmenitiesReport)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentAmenitiesReport) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentAmenitiesReport) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentAmenitiesReportID) %>&ReviewTypeID=<% Response.Write(errorDocumentAmenitiesReportReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentAmenitiesReportErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                                <div class="clearfix"></div>
                                                                 <br />
                                                                <%
                                                                End While
                                                                    Next
                                                            conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                      <asp:DropDownList ID="NoticeTypeAmenitiesReport1" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlAmenitiesReport1" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlAmenitiesReport1" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2'">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentAmenitiesReport1" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                          <asp:DropDownList ID="CaseManagerAmenitiesReport1" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerAmenitiesReport1" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerAmenitiesReport1" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3'  OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="StatusAmenitiesReport1" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnDocument1" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="reasonable-rent-cetermination-certification">
                                                <h6>
                                                    Reasonable Rent Determination Certification
                                                     &nbsp; &nbsp; &nbsp;
                                                <%
                                                    If documents.Count > 0 Then
                                                        If documents.Contains("7") Then
                                                            Response.Write("<input type='checkbox' name='documentReasonableRentDeterminationCertification' checked='checked' />")
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentReasonableRentDeterminationCertification' />")
                                                        End If
                                                    Else
                                                        Response.Write("<input type='checkbox' name='documentReasonableRentDeterminationCertification' />")
                                                    End If
                                                 %>    
                                                </h6>
                                                <br />
                                                    <%
                                            conn.Open()
                                                        Dim errorDocumentReasonableRentDeterminationCertificationErrorID As Integer
                                                        Dim errorDocumentReasonableRentDeterminationCertificationID As Integer
                                                        Dim detailsDocumentReasonableRentDeterminationCertification As String
                                                        Dim noticeTypeDocumentReasonableRentDeterminationCertification As String
                                                        Dim statusDocumentReasonableRentDeterminationCertification As String
                                                        Dim errorStaffNameDocumentReasonableRentDeterminationCertification As String
                                                        Dim errorDocumentReasonableRentDeterminationCertificationReviewTypeID As Integer
                                                        Dim errorsReasonableRentDeterminationCertificationList As New ArrayList
                                                        Dim processDocumentReasonableRentDeterminationCertificationErrorID As Integer
                                                        
                                                        Dim queryDocumentReasonableRentDeterminationCertificationError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '7' AND fk_FileID = '" & fileID & "'", conn)
                                                        Dim readerDocumentReasonableRentDeterminationCertificationError As SqlDataReader = queryDocumentReasonableRentDeterminationCertificationError.ExecuteReader()
                                                        If readerDocumentReasonableRentDeterminationCertificationError.HasRows Then
                                                            While readerDocumentReasonableRentDeterminationCertificationError.Read
                                                                errorDocumentReasonableRentDeterminationCertificationErrorID = CStr(readerDocumentReasonableRentDeterminationCertificationError("fk_ErrorID"))
                                                                errorsReasonableRentDeterminationCertificationList.Add(errorDocumentReasonableRentDeterminationCertificationErrorID)
                                                            End While
                                                        End If
                                                    conn.Close()
                                           
                                                    conn.Open()
                                                        Dim errorReasonableRentDeterminationCertificationIndex As Integer
                                                        For Each errorReasonableRentDeterminationCertificationIndex In errorsReasonableRentDeterminationCertificationList
                                                            Dim queryDocumentReasonableRentDeterminationCertification As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorReasonableRentDeterminationCertificationIndex & "'", conn)
                                                            Dim readerDocumentReasonableRentDeterminationCertification As SqlDataReader = queryDocumentReasonableRentDeterminationCertification.ExecuteReader()
                                                            While readerDocumentReasonableRentDeterminationCertification.Read
                                                                errorDocumentReasonableRentDeterminationCertificationID = CStr(readerDocumentReasonableRentDeterminationCertification("ErrorID"))
                                                                detailsDocumentReasonableRentDeterminationCertification = CStr(readerDocumentReasonableRentDeterminationCertification("Details"))
                                                                noticeTypeDocumentReasonableRentDeterminationCertification = CStr(readerDocumentReasonableRentDeterminationCertification("Notice"))
                                                                statusDocumentReasonableRentDeterminationCertification = CStr(readerDocumentReasonableRentDeterminationCertification("Status"))
                                                                errorStaffNameDocumentReasonableRentDeterminationCertification = CStr(readerDocumentReasonableRentDeterminationCertification("ErrorStaffName"))
                                                                errorDocumentReasonableRentDeterminationCertificationReviewTypeID = CStr(readerDocumentReasonableRentDeterminationCertification("fk_ReviewTypeID"))
                                                             processDocumentReasonableRentDeterminationCertificationErrorID = CStr(readerDocumentReasonableRentDeterminationCertification("fk_ProcessTypeID"))
                                                                %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentReasonableRentDeterminationCertification) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                 <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentReasonableRentDeterminationCertification)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentReasonableRentDeterminationCertification) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentReasonableRentDeterminationCertification) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentReasonableRentDeterminationCertificationID) %>&ReviewTypeID=<% Response.Write(errorDocumentReasonableRentDeterminationCertificationReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentReasonableRentDeterminationCertificationErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                                <div class="clearfix"></div>
                                                                 <br />
                                                                <%
                                                                End While
                                                                    Next
                                                            conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeReasonableRentDeterminationCertification7" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlReasonableRentDeterminationCertification7" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlReasonableRentDeterminationCertification7" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2'">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentRentDeterminationCertification7" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                          <asp:DropDownList ID="CaseManagerRentDeterminationCertification7" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlRentDeterminationCertification7" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlRentDeterminationCertification7" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3'  OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                       <asp:DropDownList ID="StatusRentDeterminationCertification7" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                         </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnDocument7" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="reasonable-rent-comparables">
                                                <h6> Reasonable Rent Comparables
                                                      &nbsp; &nbsp; &nbsp;
                                                <%
                                                    If documents.Count > 0 Then
                                                        If documents.Contains("2") Then
                                                            Response.Write("<input type='checkbox' name='documentReasonableRentComparables' checked='checked' />")
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentReasonableRentComparables' />")
                                                        End If
                                                    Else
                                                        Response.Write("<input type='checkbox' name='documentReasonableRentComparables' />")
                                                    End If
                                                 %>    
                                                </h6>
                                                <br />
                                                     <%
                                            conn.Open()
                                                         Dim errorDocumentReasonableRentComparablesErrorID As Integer
                                                         Dim errorDocumentReasonableRentComparablesID As Integer
                                                         Dim detailsDocumentReasonableRentComparables As String
                                                         Dim noticeTypeDocumentReasonableRentComparables As String
                                                         Dim statusDocumentReasonableRentComparables As String
                                                         Dim errorStaffNameDocumentReasonableRentComparables As String
                                                         Dim errorDocumentReasonableRentComparablesReviewTypeID As Integer
                                                         Dim errorsReasonableRentComparablesList As New ArrayList
                                                         Dim processDocumentReasonableRentComparablesErrorID As Integer
                                                        
                                                         Dim queryDocumentReasonableRentComparablesError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '2' AND fk_FileID = '" & fileID & "'", conn)
                                                         Dim readerDocumentReasonableRentComparablesError As SqlDataReader = queryDocumentReasonableRentComparablesError.ExecuteReader()
                                                         If readerDocumentReasonableRentComparablesError.HasRows Then
                                                             While readerDocumentReasonableRentComparablesError.Read
                                                                 errorDocumentReasonableRentComparablesErrorID = CStr(readerDocumentReasonableRentComparablesError("fk_ErrorID"))
                                                                 errorsReasonableRentComparablesList.Add(errorDocumentReasonableRentComparablesErrorID)
                                                             End While
                                                         End If
                                                    conn.Close()
                                           
                                                    conn.Open()
                                                         Dim errorReasonableRentComparablesIndex As Integer
                                                         For Each errorReasonableRentComparablesIndex In errorsReasonableRentComparablesList
                                                             Dim queryDocumentReasonableRentComparables As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorReasonableRentComparablesIndex & "'", conn)
                                                             Dim readerDocumentReasonableRentComparables As SqlDataReader = queryDocumentReasonableRentComparables.ExecuteReader()
                                                             While readerDocumentReasonableRentComparables.Read
                                                                 errorDocumentReasonableRentComparablesID = CStr(readerDocumentReasonableRentComparables("ErrorID"))
                                                                 detailsDocumentReasonableRentComparables = CStr(readerDocumentReasonableRentComparables("Details"))
                                                                 noticeTypeDocumentReasonableRentComparables = CStr(readerDocumentReasonableRentComparables("Notice"))
                                                                 statusDocumentReasonableRentComparables = CStr(readerDocumentReasonableRentComparables("Status"))
                                                                 errorStaffNameDocumentReasonableRentComparables = CStr(readerDocumentReasonableRentComparables("ErrorStaffName"))
                                                                 errorDocumentReasonableRentComparablesReviewTypeID = CStr(readerDocumentReasonableRentComparables("fk_ReviewTypeID"))
                                                                 processDocumentReasonableRentComparablesErrorID = CStr(readerDocumentReasonableRentComparables("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentReasonableRentComparables) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                 <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentReasonableRentComparables)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentReasonableRentComparables) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentReasonableRentComparables) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentReasonableRentComparablesID) %>&ReviewTypeID=<% Response.Write(errorDocumentReasonableRentComparablesReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentReasonableRentComparablesErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                                <div class="clearfix"></div>
                                                                 <br />
                                                                <%
                                                                End While
                                                                    Next
                                                            conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeReasonableRentComparables2" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeReasonableRentComparables2" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeReasonableRentComparables2" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2'">
                                                </asp:SqlDataSource>
                                                </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentReasonableRentComparables2" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                       <asp:DropDownList ID="CaseManagerReasonableRentComparables2" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerReasonableRentComparables2" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerReasonableRentComparables2" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3'  OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="StatusReasonableRentComparables2" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                         </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnDocument2" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="rent-burden-worksheet">
                                                <h6>Rent Burden Worksheet
                                                      &nbsp; &nbsp; &nbsp;
                                                <%
                                                    If documents.Count > 0 Then
                                                        If documents.Contains("3") Then
                                                            Response.Write("<input type='checkbox' name='documentRentBurdenWorksheet' checked='checked' />")
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentRentBurdenWorksheet' />")
                                                        End If
                                                    Else
                                                        Response.Write("<input type='checkbox' name='documentRentBurdenWorksheet' />")
                                                    End If
                                                 %>    
                                                </h6>
                                                <br />
                                                     <%
                                            conn.Open()
                                                         Dim errorDocumentRentBurdenWorksheetErrorID As Integer
                                                         Dim errorDocumentRentBurdenWorksheetID As Integer
                                                         Dim detailsDocumentRentBurdenWorksheet As String
                                                         Dim noticeTypeDocumentRentBurdenWorksheet As String
                                                         Dim statusDocumentRentBurdenWorksheet As String
                                                         Dim errorStaffNameDocumentRentBurdenWorksheet As String
                                                         Dim errorDocumentRentBurdenWorksheetReviewTypeID As Integer
                                                         Dim errorsRentBurdenWorksheetList As New ArrayList
                                                         Dim processDocumentRentBurdenWorksheetErrorID As Integer
                                                        
                                                         Dim queryDocumentRentBurdenWorksheetError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '3' AND fk_FileID = '" & fileID & "'", conn)
                                                         Dim readerDocumentRentBurdenWorksheetError As SqlDataReader = queryDocumentRentBurdenWorksheetError.ExecuteReader()
                                                         If readerDocumentRentBurdenWorksheetError.HasRows Then
                                                             While readerDocumentRentBurdenWorksheetError.Read
                                                                 errorDocumentRentBurdenWorksheetErrorID = CStr(readerDocumentRentBurdenWorksheetError("fk_ErrorID"))
                                                                 errorsRentBurdenWorksheetList.Add(errorDocumentRentBurdenWorksheetErrorID)
                                                             End While
                                                         End If
                                                    conn.Close()
                                           
                                                    conn.Open()
                                                         Dim errorRentBurdenWorksheetIndex As Integer
                                                         For Each errorRentBurdenWorksheetIndex In errorsRentBurdenWorksheetList
                                                             Dim queryDocumentRentBurdenWorksheet As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorRentBurdenWorksheetIndex & "'", conn)
                                                             Dim readerDocumentRentBurdenWorksheet As SqlDataReader = queryDocumentRentBurdenWorksheet.ExecuteReader()
                                                             While readerDocumentRentBurdenWorksheet.Read
                                                                 errorDocumentRentBurdenWorksheetID = CStr(readerDocumentRentBurdenWorksheet("ErrorID"))
                                                                 detailsDocumentRentBurdenWorksheet = CStr(readerDocumentRentBurdenWorksheet("Details"))
                                                                 noticeTypeDocumentRentBurdenWorksheet = CStr(readerDocumentRentBurdenWorksheet("Notice"))
                                                                 statusDocumentRentBurdenWorksheet = CStr(readerDocumentRentBurdenWorksheet("Status"))
                                                                 errorStaffNameDocumentRentBurdenWorksheet = CStr(readerDocumentRentBurdenWorksheet("ErrorStaffName"))
                                                                 errorDocumentRentBurdenWorksheetReviewTypeID = CStr(readerDocumentRentBurdenWorksheet("fk_ReviewTypeID"))
                                                                 processDocumentRentBurdenWorksheetErrorID = CStr(readerDocumentRentBurdenWorksheet("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentRentBurdenWorksheet) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                 <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentRentBurdenWorksheet)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentRentBurdenWorksheet) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentRentBurdenWorksheet) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentRentBurdenWorksheetID) %>&ReviewTypeID=<% Response.Write(errorDocumentRentBurdenWorksheetReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentRentBurdenWorksheetErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                                <div class="clearfix"></div>
                                                                 <br />
                                                                <%
                                                                End While
                                                                    Next
                                                            conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                          <asp:DropDownList ID="NoticeTypeRentBurdenWorksheet3" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeRentBurdenWorksheet3" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeRentBurdenWorksheet3" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2'">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentRentBurdenWorksheet3" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                       <asp:DropDownList ID="CaseManagerRentBurdenWorksheet3" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlRentBurdenWorksheet3" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlRentBurdenWorksheet3" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3'  OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="StatusRentBurdenWorksheet3" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                         </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                     <asp:Button ID="btnDocument3" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="rent-increase-request-form">
                                                <h6>  Rent Increase Request Form (if applicable)
                                                     &nbsp; &nbsp; &nbsp;
                                                <%
                                                    If documents.Count > 0 Then
                                                        If documents.Contains("4") Then
                                                            Response.Write("<input type='checkbox' name='documentRentIncreaseRequestFormIfApplicable' checked='checked' />")
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentRentIncreaseRequestFormIfApplicable' />")
                                                        End If
                                                    Else
                                                        Response.Write("<input type='checkbox' name='documentRentIncreaseRequestFormIfApplicable' />")
                                                    End If
                                                 %>   
                                                </h6>
                                                <br />
                                                    <%
                                            conn.Open()
                                                        Dim errorDocumentRentIncreaseRequestFormIfApplicableErrorID As Integer
                                                        Dim errorDocumentRentIncreaseRequestFormIfApplicableID As Integer
                                                        Dim detailsDocumentRentIncreaseRequestFormIfApplicable As String
                                                        Dim noticeTypeDocumentRentIncreaseRequestFormIfApplicable As String
                                                        Dim statusDocumentRentIncreaseRequestFormIfApplicable As String
                                                        Dim errorStaffNameDocumentRentIncreaseRequestFormIfApplicable As String
                                                        Dim errorDocumentRentIncreaseRequestFormIfApplicableReviewTypeID As Integer
                                                        Dim errorsRentIncreaseRequestFormIfApplicableList As New ArrayList
                                                        Dim processDocumentRentIncreaseRequestFormIfApplicableErrorID As Integer
                                                        
                                                        Dim queryDocumentRentIncreaseRequestFormIfApplicableError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '4' AND fk_FileID = '" & fileID & "'", conn)
                                                        Dim readerDocumentRentIncreaseRequestFormIfApplicableError As SqlDataReader = queryDocumentRentIncreaseRequestFormIfApplicableError.ExecuteReader()
                                                        If readerDocumentRentIncreaseRequestFormIfApplicableError.HasRows Then
                                                            While readerDocumentRentIncreaseRequestFormIfApplicableError.Read
                                                                errorDocumentRentIncreaseRequestFormIfApplicableErrorID = CStr(readerDocumentRentIncreaseRequestFormIfApplicableError("fk_ErrorID"))
                                                                errorsRentIncreaseRequestFormIfApplicableList.Add(errorDocumentRentIncreaseRequestFormIfApplicableErrorID)
                                                            End While
                                                        End If
                                                    conn.Close()
                                           
                                                    conn.Open()
                                                        Dim errorRentIncreaseRequestFormIfApplicableIndex As Integer
                                                        For Each errorRentIncreaseRequestFormIfApplicableIndex In errorsRentIncreaseRequestFormIfApplicableList
                                                            Dim queryDocumentRentIncreaseRequestFormIfApplicable As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorRentIncreaseRequestFormIfApplicableIndex & "'", conn)
                                                            Dim readerDocumentRentIncreaseRequestFormIfApplicable As SqlDataReader = queryDocumentRentIncreaseRequestFormIfApplicable.ExecuteReader()
                                                            While readerDocumentRentIncreaseRequestFormIfApplicable.Read
                                                                errorDocumentRentIncreaseRequestFormIfApplicableID = CStr(readerDocumentRentIncreaseRequestFormIfApplicable("ErrorID"))
                                                                detailsDocumentRentIncreaseRequestFormIfApplicable = CStr(readerDocumentRentIncreaseRequestFormIfApplicable("Details"))
                                                                noticeTypeDocumentRentIncreaseRequestFormIfApplicable = CStr(readerDocumentRentIncreaseRequestFormIfApplicable("Notice"))
                                                                statusDocumentRentIncreaseRequestFormIfApplicable = CStr(readerDocumentRentIncreaseRequestFormIfApplicable("Status"))
                                                                errorStaffNameDocumentRentIncreaseRequestFormIfApplicable = CStr(readerDocumentRentIncreaseRequestFormIfApplicable("ErrorStaffName"))
                                                                errorDocumentRentIncreaseRequestFormIfApplicableReviewTypeID = CStr(readerDocumentRentIncreaseRequestFormIfApplicable("fk_ReviewTypeID"))
                                                                processDocumentRentIncreaseRequestFormIfApplicableErrorID = CStr(readerDocumentRentIncreaseRequestFormIfApplicable("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentRentIncreaseRequestFormIfApplicable) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                 <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentRentIncreaseRequestFormIfApplicable)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentRentIncreaseRequestFormIfApplicable) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentRentIncreaseRequestFormIfApplicable) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentRentIncreaseRequestFormIfApplicableID) %>&ReviewTypeID=<% Response.Write(errorDocumentRentIncreaseRequestFormIfApplicableReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentRentIncreaseRequestFormIfApplicableErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                                <div class="clearfix"></div>
                                                                 <br />
                                                                <%
                                                                End While
                                                                    Next
                                                            conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                       <asp:DropDownList ID="NoticeTypeRentIncreaseRequestFormIfApplicable4" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeRentIncreaseRequestFormIfApplicable4" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeRentIncreaseRequestFormIfApplicable4" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2'">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentRentIncreaseRequestFormIfApplicable4" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerRentIncreaseRequestFormIfApplicable4" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlRentIncreaseRequestFormIfApplicable4" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlRentIncreaseRequestFormIfApplicable4" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3'  OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                          <asp:DropDownList ID="StatusRentIncreaseRequestFormIfApplicable4" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                         </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                      <asp:Button ID="btnDocument4" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                            <div id="contracts-execution-checklist">
                                                <h6> Contracts Execution Checklist
                                                     &nbsp; &nbsp; &nbsp;
                                                <%
                                                    If documents.Count > 0 Then
                                                        If documents.Contains("5") Then
                                                            Response.Write("<input type='checkbox' name='documentContractsExecutionChecklist' checked='checked' />")
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentContractsExecutionChecklist' />")
                                                        End If
                                                    Else
                                                        Response.Write("<input type='checkbox' name='documentContractsExecutionChecklist' />")
                                                    End If
                                                 %>   
                                                </h6>
                                                <br />
                                                     <%
                                            conn.Open()
                                                         Dim errorDocumentContractsExecutionChecklistErrorID As Integer
                                                         Dim errorDocumentContractsExecutionChecklistID As Integer
                                                         Dim detailsDocumentContractsExecutionChecklist As String
                                                         Dim noticeTypeDocumentContractsExecutionChecklist As String
                                                         Dim statusDocumentContractsExecutionChecklist As String
                                                         Dim errorStaffNameDocumentContractsExecutionChecklist As String
                                                         Dim errorDocumentContractsExecutionChecklistReviewTypeID As Integer
                                                         Dim errorsContractsExecutionChecklistList As New ArrayList
                                                         Dim processDocumentContractsExecutionChecklistErrorID As Integer
                                                        
                                                         Dim queryDocumentContractsExecutionChecklistError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '5' AND fk_FileID = '" & fileID & "'", conn)
                                                         Dim readerDocumentContractsExecutionChecklistError As SqlDataReader = queryDocumentContractsExecutionChecklistError.ExecuteReader()
                                                         If readerDocumentContractsExecutionChecklistError.HasRows Then
                                                             While readerDocumentContractsExecutionChecklistError.Read
                                                                 errorDocumentContractsExecutionChecklistErrorID = CStr(readerDocumentContractsExecutionChecklistError("fk_ErrorID"))
                                                                 errorsContractsExecutionChecklistList.Add(errorDocumentContractsExecutionChecklistErrorID)
                                                             End While
                                                         End If
                                                    conn.Close()
                                           
                                                    conn.Open()
                                                         Dim errorContractsExecutionChecklistIndex As Integer
                                                         For Each errorContractsExecutionChecklistIndex In errorsContractsExecutionChecklistList
                                                             Dim queryDocumentContractsExecutionChecklist As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorContractsExecutionChecklistIndex & "'", conn)
                                                             Dim readerDocumentContractsExecutionChecklist As SqlDataReader = queryDocumentContractsExecutionChecklist.ExecuteReader()
                                                             While readerDocumentContractsExecutionChecklist.Read
                                                                 errorDocumentContractsExecutionChecklistID = CStr(readerDocumentContractsExecutionChecklist("ErrorID"))
                                                                 detailsDocumentContractsExecutionChecklist = CStr(readerDocumentContractsExecutionChecklist("Details"))
                                                                 noticeTypeDocumentContractsExecutionChecklist = CStr(readerDocumentContractsExecutionChecklist("Notice"))
                                                                 statusDocumentContractsExecutionChecklist = CStr(readerDocumentContractsExecutionChecklist("Status"))
                                                                 errorStaffNameDocumentContractsExecutionChecklist = CStr(readerDocumentContractsExecutionChecklist("ErrorStaffName"))
                                                                 errorDocumentContractsExecutionChecklistReviewTypeID = CStr(readerDocumentContractsExecutionChecklist("fk_ReviewTypeID"))
                                                                 processDocumentContractsExecutionChecklistErrorID = CStr(readerDocumentContractsExecutionChecklist("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentContractsExecutionChecklist) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                 <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentContractsExecutionChecklist)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentContractsExecutionChecklist) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentContractsExecutionChecklist) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentContractsExecutionChecklistID) %>&ReviewTypeID=<% Response.Write(errorDocumentContractsExecutionChecklistReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentContractsExecutionChecklistErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                                <div class="clearfix"></div>
                                                                 <br />
                                                                <%
                                                                End While
                                                                    Next
                                                            conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="NoticeTypeContractsExecutionChecklist5" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeContractsExecutionChecklist5" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeContractsExecutionChecklist5" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2'">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentContractsExecutionChecklist5" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="CaseManagerContractsExecutionChecklist5" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerContractsExecutionChecklist5" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerContractsExecutionChecklist5" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3'  OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                          <asp:DropDownList ID="StatusContractsExecutionChecklist5" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                         </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                   <asp:Button ID="btnDocument5" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel panel-success">
                                    <div class="panel-heading" role="tab" id="headingTwo">
                                        <h4 class="panel-title">
                                            <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion"
                                                href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                                <i class="fa fa-sticky-note" aria-hidden="true"></i>
                                                Notes / Portability Billing / Compliance
                                            </a>
                                        </h4>
                                    </div>
                                    <div id="collapseTwo" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                                        <div class="panel-body">
                                            <hr />
                                            <div id="other">
                                                <h6>  Other
                                                    &nbsp; &nbsp; &nbsp;
                                                    <%
                                                        If documents.Count > 0 Then
                                                            If documents.Contains("6") Then
                                                                Response.Write("<input type='checkbox' name='documentOther' checked='checked' />")
                                                            Else
                                                                Response.Write("<input type='checkbox' name='documentOther' />")
                                                            End If
                                                        Else
                                                            Response.Write("<input type='checkbox' name='documentOther' />")
                                                        End If
                                                     %>
                                                </h6>
                                                <br />
                                                <%
                                            conn.Open()
                                                    Dim errorDocumentOtherErrorID As Integer
                                                    Dim errorDocumentOtherID As Integer
                                                    Dim detailsDocumentOther As String
                                                    Dim noticeTypeDocumentOther As String
                                                    Dim statusDocumentOther As String
                                                    Dim errorStaffNameDocumentOther As String
                                                    Dim errorDocumentOtherReviewTypeID As Integer
                                                    Dim errorsOtherList As New ArrayList
                                                    Dim processDocumentOtherErrorID As Integer
                                                        
                                                    Dim queryDocumentOtherError As New SqlCommand("SELECT fk_ErrorID FROM FileErrorsDocumentTypes WHERE fk_DocumentTypeID  = '6' AND fk_FileID = '" & fileID & "'", conn)
                                                    Dim readerDocumentOtherError As SqlDataReader = queryDocumentOtherError.ExecuteReader()
                                                    If readerDocumentOtherError.HasRows Then
                                                        While readerDocumentOtherError.Read
                                                            errorDocumentOtherErrorID = CStr(readerDocumentOtherError("fk_ErrorID"))
                                                            errorsOtherList.Add(errorDocumentOtherErrorID)
                                                        End While
                                                    End If
                                                    conn.Close()
                                           
                                                    conn.Open()
                                                    Dim errorOtherIndex As Integer
                                                    For Each errorOtherIndex In errorsOtherList
                                                        Dim queryDocumentOther As New SqlCommand("SELECT ErrorID, Details, Status, NoticeTypes.Notice, Users.FirstName + ' ' + Users.LastName AS ErrorStaffName, fk_ReviewTypeID, fk_ProcessTypeID FROM FileErrors INNER JOIN NoticeTypes ON FileErrors.fk_NoticeTypeID = NoticeTypes.NoticeTypeID INNER JOIN Users ON FileErrors.fk_ErrorStaffID = Users.UserID WHERE ErrorID = '" & errorOtherIndex & "'", conn)
                                                        Dim readerDocumentOther As SqlDataReader = queryDocumentOther.ExecuteReader()
                                                        While readerDocumentOther.Read
                                                            errorDocumentOtherID = CStr(readerDocumentOther("ErrorID"))
                                                            detailsDocumentOther = CStr(readerDocumentOther("Details"))
                                                            noticeTypeDocumentOther = CStr(readerDocumentOther("Notice"))
                                                            statusDocumentOther = CStr(readerDocumentOther("Status"))
                                                            errorStaffNameDocumentOther = CStr(readerDocumentOther("ErrorStaffName"))
                                                            errorDocumentOtherReviewTypeID = CStr(readerDocumentOther("fk_ReviewTypeID"))
                                                            processDocumentOtherErrorID = CStr(readerDocumentOther("fk_ProcessTypeID"))
                                                               %>
                                                                 <div class="col-md-2"> 
                                                <h6>Notice</h6>
                                                 <br />
                                                 <div class="form-group">
                                                     <input class="form-control border-input" disabled="disabled" value="<% Response.Write(noticeTypeDocumentOther) %>" type="text" />
                                                 </div>
                                               </div>
                                                                <div class="col-md-4"> 
                                                <h6>Comments</h6>
                                            <br />
                                                <div class="form-group">
                                                 <textarea class="form-control border-input" rows="2" cols="10" disabled="disabled"><% Response.Write(detailsDocumentOther)%></textarea>
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Staff</h6>
                                                <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(errorStaffNameDocumentOther) %>" type="text" />
                                            </div>
                                               </div>
                                                                <div class="col-md-2"> 
                                                <h6>Status</h6>
                                                 <br />
                                                <div class="form-group">
                                                <input class="form-control border-input" disabled="disabled" value="<% Response.Write(statusDocumentOther) %>"  type="text" />
                                                </div>
                                               </div>
                                                                <div class="text-center">
                                                 <br /><br />
                                                 <a href="EditError.aspx?SessionUserID=<% Response.Write(sessionUserID) %>&FileID=<% Response.Write(fileID) %>&ErrorID=<% Response.Write(errorDocumentOtherID) %>&ReviewTypeID=<% Response.Write(errorDocumentOtherReviewTypeID) %>&ProcessTypeID=<% Response.Write(processDocumentOtherErrorID) %>" class="btn btn-warning btn-fill btn-wd">Edit</a>
                                                </div>
                                                                <div class="clearfix"></div>
                                                                 <br />
                                                                <%
                                                                End While
                                                                    Next
                                                            conn.Close()
                                           %>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                         <asp:DropDownList ID="NoticeTypeOther6" runat="server" 
                                                    class="form-control border-input" DataSourceID="SqlNoticeTypeOther6" 
                                                    DataTextField="Notice" DataValueField="NoticeTypeID">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlNoticeTypeOther6" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                                    SelectCommand="SELECT [NoticeTypeID], [Notice] FROM [NoticeTypes] WHERE [NoticeTypeID] = '3' OR [NoticeTypeID] = '5' OR [NoticeTypeID] = '4' OR [NoticeTypeID] = '2'">
                                                </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <textarea class="form-control border-input" cols="4" name="commentOther6" placeholder="Comment"
                                                            rows="1"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                      <asp:DropDownList ID="CaseManagerOther6" runat="server" class="form-control border-input"
                                                          DataSourceID="SqlCaseManagerOther6" DataValueField="UserID" DataTextField="FullName"></asp:DropDownList>
                                                         <asp:SqlDataSource ID="SqlCaseManagerOther6" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                                           SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                                         </asp:SqlDataSource>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <div class="form-group">
                                                          <asp:DropDownList ID="StatusOther6" class="form-control border-input" runat="server">
                                                        <asp:ListItem Text="Status" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                                        <asp:ListItem Text="Complete" Value="Complete"></asp:ListItem>
                                                         </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="text-center">
                                                    <asp:Button ID="btnDocument6" runat="server" class="btn btn-success btn-fill btn-wd" Text="Add" />
                                                </div>
                                                <div class="clearfix">
                                                </div>
                                                <hr />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        $('#myTabs a').click(function (e) {
            e.preventDefault()
            $(this).tab('show')
        })
    </script>
</asp:Content>

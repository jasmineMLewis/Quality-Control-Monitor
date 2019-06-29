<%@ Page Title="QC :: Files" Language="vb" AutoEventWireup="false" MasterPageFile="~/User.Master" CodeBehind="FileDirectory.aspx.vb" Inherits="QualityControlMonitor.FileDirectory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="header">
                    <h4 class="title"><i class="fa fa-inbox"></i> Directory :: File</h4>
                    <hr />
                </div>
                <div class="content">
                    <form id="Form1" runat="server">
                    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
                         <div class="row">
                          <div class="col-md-4">
                            <label> Client First Name</label>
                            <div class="form-group">
                                <asp:TextBox ID="ClientFirstName" runat="server" class="form-control border-input" MaxLength="50" placeholder="Client First Name"></asp:TextBox>
                            </div>
                          </div>
                          <div class="col-md-4">
                            <label>Client Last Name</label>
                            <div class="form-group">
                                <asp:TextBox ID="ClientLastName" runat="server" class="form-control border-input" MaxLength="50" placeholder="Client Last Name"></asp:TextBox>
                            </div>
                          </div>
                          <div class="col-md-4">
                            <label>Elite ID</label>
                            <div class="form-group">
                                <asp:TextBox ID="EliteID" runat="server" class="form-control border-input" MaxLength="9" placeholder="Elite ID"></asp:TextBox>
                            </div>
                          </div>
                         </div>
                         <div class="row">
                            <div class="col-md-4">
                                <label>File Housing Specialist</label>
                               <div class="form-group input-group">
                                <asp:DropDownList ID="FileStaff" runat="server" class="form-control border-input"
                                    DataSourceID="SqlFileStaff" DataValueField="UserID" DataTextField="FullName" required="required">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlFileStaff" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                    SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR [fk_RoleID] = '2' ORDER BY [FirstName] ASC">
                                </asp:SqlDataSource>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span></span>
                               </div>
                            </div>

                         <div class="col-md-4">
                          <label>Auditor</label>
                            <div class="form-group input-group">
                                <asp:DropDownList ID="Auditor" runat="server" class="form-control border-input"
                                    DataSourceID="SqlAuditor" DataValueField="UserID" DataTextField="FullName" required="required"></asp:DropDownList>
                                <asp:SqlDataSource ID="SqlAuditor" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                    SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '2'OR [fk_RoleID] = '1' ORDER BY [FirstName] ASC">
                                </asp:SqlDataSource>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>

                           <div class="col-md-4">
                            <label>Review Type</label>
                            <div class="form-group input-group">
                                <asp:DropDownList ID="ReviewType" runat="server" class="form-control border-input" required="required"
                                    DataSourceID="SqlReviewType" DataTextField="Review" DataValueField="ReviewTypeID">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlReviewType" runat="server"
                                    ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                    SelectCommand="SELECT [ReviewTypeID], [Review] FROM [ReviewTypes] ORDER By [Review] ASC">
                                </asp:SqlDataSource>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span> </span>
                            </div>
                           </div>
                         </div>
                          <hr />
                          <div class="text-center">
                                <asp:Button ID="btnFilterReport" runat="server" class="btn btn-info btn-fill btn-wd" Text="Filter" />
                          </div>
                          <div class="clearfix"></div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <asp:SqlDataSource ID="SqlFileDirectory" runat="server" 
        ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
        SelectCommand="SELECT Files.FileID, Files.ClientFirstName + ' ' +  Files.ClientLastName As Client,
                              Files.EliteID, Users.FirstName + ' ' + Users.LastName AS FileHousingSpecialist, 
                              Auditor.FirstName + ' ' + Auditor.LastName AS AuditorName, Files.fk_ReviewTypeID, ReviewTypes.Review, 
                              CONVERT (varchar(MAX), CAST(Files.ReviewDate AS date), 101) AS ReviewDate,
                              CONVERT (varchar(MAX), CAST(Files.EffectiveDate AS date), 101) AS EffectiveDate,
                              Files.Comment 
                       FROM Files 
                       INNER JOIN Users ON Files.fk_CaseManagerID = Users.UserID 
                       INNER JOIN Users AS Auditor ON Files.fk_AudtitorID = Auditor.UserID 
                       INNER JOIN ReviewTypes ON Files.fk_ReviewTypeID = ReviewTypes.ReviewTypeID
                       ORDER BY Client ASC">
    </asp:SqlDataSource>

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

    <div class="row">
        <div class="col-lg-12">
            <div class="card">
                <div class="header">
                    <h4 class="title"><i class="fa fa-inbox"></i> Files</h4>
                    <hr />
                </div>
                <div class="content">
                  <div class="panel panel-success">
                        <div class="panel-heading">
                            <h3 class="panel-title"> <i class="fa fa-inbox"></i> Files</h3>
                        </div>
                        <div class="table-responsive">
                            <asp:GridView ID="GridView1" runat="server" CssClass="table" AutoGenerateColumns="False" 
                                DataKeyNames="fk_ReviewTypeID, FileID" GridLines="None" DataSourceID="SqlFileDirectory">
                                <Columns>
                                 <asp:TemplateField HeaderText="Client">
                                     <ItemTemplate> 
                                        <%# DisplayFileLink(Eval("fk_ReviewTypeID"), Eval("Client"), Eval("FileID"), Request.QueryString("SessionUserID"))%>
                                     </ItemTemplate>
                                 </asp:TemplateField>  
                                 <asp:BoundField DataField="EliteID" HeaderText="Elite ID" 
                                        SortExpression="EliteID" /> 
                                 <asp:BoundField DataField="FileHousingSpecialist" HeaderText="File Housing Specialist"  
                                        SortExpression="FileHousingSpecialist" /> 
                                  <asp:BoundField DataField="AuditorName" HeaderText="Auditor" 
                                        SortExpression="AuditorName"  /> 
                                 <asp:BoundField DataField="Review" HeaderText="Review" SortExpression="Review" /> 
                                 <asp:BoundField DataField="ReviewDate" HeaderText="Review Date" 
                                        SortExpression="ReviewDate" /> 
                                 <asp:BoundField DataField="EffectiveDate" HeaderText="Effective Date" 
                                        SortExpression="EffectiveDate" /> 
                                 <asp:BoundField DataField="Comment" HeaderText="Notes" 
                                        SortExpression="Comment" /> 
                                 <asp:TemplateField HeaderText="Edit">
                                     <ItemTemplate> 
                                       <%# DisplayEditLink(Eval("FileID"), Request.QueryString("SessionUserID"))%>
                                     </ItemTemplate>
                                 </asp:TemplateField>
                                 <asp:TemplateField HeaderText="Delete">
                                     <ItemTemplate> 
                                       <%# DisplayDeleteFileLink(Request.QueryString("SessionUserID"), Eval("FileID"))%>
                                     </ItemTemplate>
                                 </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                  </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
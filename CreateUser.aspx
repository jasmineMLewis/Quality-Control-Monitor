<%@ Page Title="QC :: Register User" Language="vb" AutoEventWireup="false" MasterPageFile="~/User.Master"
    CodeBehind="CreateUser.aspx.vb" Inherits="QualityControlMonitor.CreateUser" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-lg-8 col-md-7">
            <div class="card">
                <div class="header">
                    <h4 class="title"><i class="fa fa-cloud-upload" aria-hidden="true"></i> Register :: User</h4>
                    <hr />
                </div>
                <div class="content">
                    <form action="" method="post" runat="server">
                   <div class="row">
                        <div class="col-md-6">
                            <label>First Name</label>
                            <div class="form-group input-group">
                                <input class="form-control border-input" id="FirstName" maxlength="20" name="FirstName" placeholder="First Name" required="required" Role="text" />
                                 <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span></span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label>Last Name</label>
                            <div class="form-group input-group">
                                <input class="form-control border-input" id="LastName" maxlength="20" name="LastName" placeholder="Last Name" required="required" Role="text" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span> </span>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <label>Email</label>
                            <div class="form-group input-group" data-validate="email">
                                <input class="form-control border-input" id="Email" maxlength="100" name="Email" placeholder="Email" required="required" Role="text" />
                               <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span></span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label>Password</label>
                            <div class="form-group">
                                <input class="form-control border-input" id="Password" maxlength="15" name="Password"
                                    placeholder="Qwerty1" disabled="disabled" Role="text" />
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                           <label>Role</label>
                            <div class="form-group input-group">
                                <asp:DropDownList ID="Role" runat="server" class="form-control border-input" DataSourceID="SqlRole" DataTextField="Role" 
                                    DataValueField="RoleID" required="required"></asp:DropDownList>
                                <asp:SqlDataSource ID="SqlRole" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                    SelectCommand="SELECT [RoleID], [Role] FROM [Roles]"></asp:SqlDataSource>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span></span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label>Group</label>
                            <div class="form-group input-group">
                                <asp:DropDownList ID="GroupType" runat="server" class="form-control border-input"
                                    DataSourceID="SqlGroupType" DataTextField="Group" DataValueField="GroupID" required="required"></asp:DropDownList>
                                <asp:SqlDataSource ID="SqlGroupType" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>" 
                                    SelectCommand="SELECT [GroupID], [Group] FROM [Groups]"></asp:SqlDataSource>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span> </span>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <label>Active</label>
                            <div class="form-group input-group">
                                <asp:DropDownList ID="IsActive" runat="server" class="form-control border-input" required="required">
                                    <asp:ListItem Value="">Active</asp:ListItem>
                                    <asp:ListItem Value="1">Yes</asp:ListItem>
                                    <asp:ListItem Value="0">No</asp:ListItem>
                                </asp:DropDownList>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span></span>
                            </div>
                        </div>
                        <div class="col-md-6"></div>
                     </div>
                    <hr />
                    <div class="text-center">
                        <asp:Button ID="btnRegisterUser" runat="server" class="btn btn-info btn-fill btn-wd"  Text="Register User" />
                    </div>
                    <div class="clearfix"> </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
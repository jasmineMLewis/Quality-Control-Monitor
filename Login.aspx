<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master"
    CodeBehind="Login.aspx.vb" Inherits="QualityControlMonitor.Login" %>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <div class="bg-faded p-4 my-4">
        <hr class="divider" />
        <h2 class="text-center text-lg text-uppercase my-0">
            <strong>Quality Control Users</strong>
        </h2>
        <hr class="divider" />
        <div class="row">
            <div class="col-md-4 mb-4 mb-md-0">
                <div class="card h-100">
                    <img class="card-img-top" src="./Images/housing specialist.jpg" alt="Housing Specialist" />
                    <div class="card-body text-center">
                        <h4 class="card-title m-0">
                            Housing Specialist</h4>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4 mb-md-0">
                <div class="card h-100">
                    <img class="card-img-top" src="./Images/auditor.jpg" alt="Auditor" />
                    <div class="card-body text-center">
                        <h4 class="card-title m-0">
                            Auditor</h4>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card h-100">
                    <img class="card-img-top" src="./Images/admin.png" alt="Admin" />
                    <div class="card-body text-center">
                        <h4 class="card-title m-0">
                            Administrator</h4>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="bg-faded p-4 my-4">
        <hr class="divider" />
        <h2 class="text-center text-lg text-uppercase my-0">
            <strong>Login</strong>
        </h2>
        <hr class="divider" />
        <form action="" method="post" runat="server">
        <div class="row">
            <div class="form-group form-group-lg col-lg-12">
                <label class="text-heading">
                    Email</label>
                <div class="input-group">
                    <span class="input-group-addon"><i class="fa fa-envelope-open" aria-hidden="true"></i></span>
                    <input type="text" class="form-control" id="email" name="email" placeholder="Email" required="required" />
                </div>
            </div>
            <div class="form-group form-group-lg col-lg-12">
                <label class="text-heading">
                    Password</label>
                <div class="input-group">
                    <span class="input-group-addon"><i class="fa fa-key" aria-hidden="true"></i></span>
                    <input type="password" class="form-control" id="password" name="password" placeholder="Password" required="required" />
                </div>
            </div>
            <div class="form-group col-lg-12">
                <asp:Button ID="btnLoginUser" runat="server" class="btn btn-secondary btn-block"
                    Text="Login" />
            </div>
        </div>
        </form>
    </div>
</asp:Content>
<asp:Content ID="FooterContent" runat="server" ContentPlaceHolderID="Footer">
</asp:Content>

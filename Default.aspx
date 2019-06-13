<%@ Page Title="Quality Control Monitor" Language="vb" MasterPageFile="~/Site.Master"
    AutoEventWireup="false" CodeBehind="Default.aspx.vb" Inherits="QualityControlMonitor._Default" %>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <div class="bg-faded p-4 my-4">
        <div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
            <ol class="carousel-indicators">
                <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
                <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
                <li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
            </ol>
            <div class="carousel-inner" role="listbox">
                <div class="carousel-item active">
                    <img class="d-block img-fluid w-100" src="./Images/quality-control-slider1.jpg"
                        alt="" />
                    <div class="carousel-caption d-none d-md-block">
                    </div>
                </div>
                <div class="carousel-item">
                    <img class="d-block img-fluid w-100" src="./Images/quality-control-slider2.jpg"
                        alt="" />
                    <div class="carousel-caption d-none d-md-block">
                    </div>
                </div>
                <div class="carousel-item">
                    <img class="d-block img-fluid w-100" src="./Images/quality-control-slider3.jpg"
                        alt="" />
                    <div class="carousel-caption d-none d-md-block">
                    </div>
                </div>
            </div>
            <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button"
                data-slide="prev"><span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="sr-only">Previous</span> </a><a class="carousel-control-next" href="#carouselExampleIndicators"
                    role="button" data-slide="next"><span class="carousel-control-next-icon" aria-hidden="true">
                    </span><span class="sr-only">Next</span> </a>
        </div>
        <div class="text-center mt-4">
            <div class="text-heading text-muted text-lg">
                Time to Monitor</div>
            <h1 class="my-2">Quality Control</h1>
        </div>
    </div>
    <div class="bg-faded p-4 my-4">
        <hr class="divider" />
        <h2 class="text-center text-lg text-uppercase my-0">
            <strong>Quality Control Monitor</strong>
        </h2>
        <hr class="divider" />
        <div class="row">
            <div class="col-lg-6">
                <img class="img-fluid mb-4 mb-lg-0" src="./Images/quality-control-slider1.jpg" alt="" />
            </div>
            <div class="col-lg-6">
                <p>
                    Quality Control Monitor allows auditors to assess the quality of clients’ documents
                    processed by housing specialists.</p>
                <p>
                    <strong>Housing Specialists</strong> :: someone who works with clients to help them
                    achieve immediate and long-term housing goals
                </p>
                <p>
                    <strong>Auditors</strong> :: an official whose carefully assesses the quality of
                    clients’ documents processed by housing specialists
                </p>
                <p>
                    <strong>Administrators</strong> :: a person responsible for overseeing and supervising
                    all users
                </p>
            </div>
        </div>
    </div>
</asp:Content>

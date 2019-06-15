<%@ Page Title="QC :: File" Language="vb" AutoEventWireup="false" MasterPageFile="~/User.Master"
    CodeBehind="CreateFile.aspx.vb" Inherits="QualityControlMonitor.CreateFile" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  <style type="text/css">
        .alert alert-danger    
        {
            top:150px;   
            width: 50%;    
            z-index: 100000;
        }
  </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-lg-12 col-md-7">
            <div class="card">
                <div class="header">
                    <h4 class="title">
                        <i class="fa fa-file" aria-hidden="true"></i> Review :: Quality Control
                    </h4>
                    <hr />
                </div>
                <div class="content">
                    <form action="" method="post" runat="server">
                    <asp:ScriptManager ID="ScriptManager1" runat="server">
                    </asp:ScriptManager>
                    <div class="row">
                        <div class="col-md-4">
                            <label>Client First Name</label>
                            <div class="form-group input-group">
                                <input class="form-control border-input" id="ClientFirstName" maxlength="100" name="ClientFirstName"
                                    placeholder="Client First Name" required="required" type="text" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <label>
                                Client Last Name</label>
                            <div class="form-group input-group">
                                <input class="form-control  border-input" id="ClientLastName" maxlength="100" name="ClientLastName"
                                    placeholder="Client Last Name" required="required" type="text" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <label>
                                Elite ID</label>
                            <div class="form-group input-group" data-validate="number">
                                <input class="form-control  border-input" id="ClientID" maxlength="9" name="ClientID"
                                    placeholder="Elite ID" required="required" type="text" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label>
                                Hosuing Specialist</label>
                            <div class="form-group input-group">
                                <asp:DropDownList ID="CaseManager" runat="server" class="form-control border-input"
                                    DataSourceID="SqlCaseManager" DataValueField="UserID" DataTextField="FullName"
                                    required="required">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlCaseManager" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                    SelectCommand="SELECT [UserID], [FirstName] + ' ' + [LastName] AS [FullName] FROM [Users] WHERE [fk_RoleID] = '3' OR  [fk_RoleID] = '2'  ORDER BY [FirstName] ASC">
                                </asp:SqlDataSource>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-4">
                        </div>
                        <div class="col-md-4">
                            <label>
                                Review Type</label>
                            <div class="form-group input-group">
                                <asp:DropDownList ID="ReviewType" runat="server" class="form-control border-input"
                                    required="required" DataSourceID="SqlReviewType" DataTextField="Review" DataValueField="ReviewTypeID">
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlReviewType" runat="server" ConnectionString="<%$ ConnectionStrings:QualityControlMonitorConnectionString %>"
                                    SelectCommand="SELECT [ReviewTypeID], [Review] FROM [ReviewTypes] ORDER BY [Review] ASC">
                                </asp:SqlDataSource>
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label>
                                Review Date</label>
                            <div class="form-group input-group">
                                <asp:TextBox ID="ReviewDate" runat="server" class="form-control border-input" required="required"
                                    MaxLength="15" placeholder="Review Date" />
                                <ajaxToolkit:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="ReviewDate" Format="MM/dd/yyyy" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span> </span>
                            </div>
                        </div>
                        <div class="col-md-4">
                        </div>
                        <div class="col-md-4">
                            <label>
                                Effective Date</label>
                            <div class="form-group input-group">
                                <asp:TextBox ID="EffectiveDate" runat="server" class="form-control border-input"
                                    required="required" MaxLength="15" placeholder="Effective Date" />
                                <ajaxToolkit:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="EffectiveDate" Format="MM/dd/yyyy" />
                                <span class="input-group-addon danger"><span class="glyphicon glyphicon-remove"></span>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <label>
                                Notes</label>
                            <div class="form-group input-group">
                                <textarea class="form-control border-input" rows="5" columns="40" id="Comment" maxlength="500"
                                    name="Comment" placeholder="Notes"></textarea>
                                <span class="input-group-addon success"><span class="glyphicon glyphicon-ok"></span>
                                </span>
                            </div>
                        </div>
                    </div>
                    <hr />
                    <div class="text-center">
                        <asp:Button ID="btnInitiateReview" runat="server" class="btn btn-info btn-fill btn-wd"
                            Text="Initiate Review" />
                    </div>
                    <div class="clearfix">
                    </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
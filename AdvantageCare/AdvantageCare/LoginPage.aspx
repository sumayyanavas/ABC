<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LoginPage.aspx.vb" Inherits="AdvantageCare.LoginPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <div>
        <asp:Label ID="Label1" runat="server" Text="User Name"></asp:Label>
        <asp:TextBox ID="txtUsername" runat="server"></asp:TextBox>
    </div>
    <div>
        <asp:Label ID="Label2" runat="server" Text="Password"></asp:Label>
        <asp:TextBox ID="txtPassword" runat="server"></asp:TextBox>
    </div>
    <div>
         <asp:Button ID="btnLogin" runat="server" Text="Login" />
    </div>
    </div>   
    </form>
</body>
</html>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script type="text/javascript">
$(function () {
    $("[id*=btnLogin]").click(function () {
        var name = $.trim($("txtUsername").val());
        var Password = $.trim($("txtPassword").val());
        $.ajax({
            type: "POST",
            url: "Login.aspx/Login",
            data: "{ name: '" + name + "', password: " + Password + "}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (r) {
                alert(r.d);
            },
            error: function (r) {
                alert(r.responseText);
            },
            failure: function (r) {
                alert(r.responseText);
            }
        });
        return false;
    });
});
</script>


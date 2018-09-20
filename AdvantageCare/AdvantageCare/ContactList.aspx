<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ContactList.aspx.vb" Inherits="AdvantageCare.ContactList" %>

<!DOCTYPE html>

<html >
<head runat="server">
    <title></title>
</head>
<body>
    <form id="ContactList" runat="server">
    <div>
     <asp:GridView ID="gvContacts" runat="server" AutoGenerateColumns="false">
    <Columns>
        <asp:TemplateField HeaderText="Id" ItemStyle-Width="110px" ItemStyle-CssClass="Id">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("Id") %>' runat="server" />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Name" ItemStyle-Width="150px" ItemStyle-CssClass="name">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("name") %>' runat="server" />
                <asp:TextBox Text='<%# Eval("name") %>' runat="server" Style="display: none" />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Address" ItemStyle-Width="150px" ItemStyle-CssClass="address">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("address") %>' runat="server" />
                <asp:TextBox Text='<%# Eval("address") %>' runat="server" Style="display: none" />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="PhoneNo" ItemStyle-Width="150px" ItemStyle-CssClass="phone">
            <ItemTemplate>
                <asp:Label Text='<%# Eval("phone") %>' runat="server" />
                <asp:TextBox Text='<%# Eval("phone") %>' runat="server" Style="display: none" />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField>
            <ItemTemplate>
                <asp:LinkButton Text="Edit" runat="server" CssClass="Edit" />
                <asp:LinkButton Text="Update" runat="server" CssClass="Update" Style="display: none" />
                <asp:LinkButton Text="Cancel" runat="server" CssClass="Cancel" Style="display: none" />
                <asp:LinkButton Text="Delete" runat="server" CssClass="Delete" />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>
<table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse">
    <tr>
        <td style="width: 150px">
            Name:<br />
            <asp:TextBox ID="txtName" runat="server" Width="140" />
        </td>
        <td style="width: 150px">
            Address:<br />
            <asp:TextBox ID="txtAddress" runat="server" Width="140" />
        </td>
        <td style="width: 150px">
            Phone:<br />
            <asp:TextBox ID="txtPhone" runat="server" Width="140" />
        </td>
        <td style="width: 100px">
            <br />
            <asp:Button ID="btnAdd" runat="server" Text="Add" />
        </td>
    </tr>
</table>
    </div>
    </form>
</body>
</html>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script type="text/javascript">
    $(function () {
        $.ajax({
            type: "POST",
            url: "ContactList.aspx/GetContacts",
            data: '{}',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess
        });
    });
 
    function OnSuccess(response) {
        var xmlDoc = $.parseXML(response.d);
        var xml = $(xmlDoc);
        var contacts = xml.find("Table");
        var row = $("[id*=gvContacts] tr:last-child");
        if (contacts.length > 0) {
            $.each(contacts, function () {
                var contact = $(this);
                AppendRow(row, $(this).find("Id").text(), $(this).find("name").text(), $(this).find("address").text(), $(this).find("phone").text())
                row = $("[id*=gvContacts] tr:last-child").clone(true);
            });
        } else {
            row.find(".Edit").hide();
            row.find(".Delete").hide();
            row.find("span").html('&nbsp;');
        }
    }
 
    function AppendRow(row, Id, name, address, phone) {
        //Bind Id.
        $(".Id", row).find("span").html(Id);
 
        //Bind Name.
        $(".name", row).find("span").html(name);
        $(".name", row).find("input").val(name);
 
        //Bind Address.
        $(".address", row).find("span").html(address);
        $(".address", row).find("input").val(address);

        //Bind Phone.
        $(".phone", row).find("span").html(phone);
        $(".phone", row).find("input").val(phone);
 
        row.find(".Edit").show();
        row.find(".Delete").show();
        $("[id*=gvContacts]").append(row);
    }
    //Add event handler.
    $("body").on("click", "[id*=btnAdd]", function () {
        var txtName = $("[id*=txtName]");
        var txtAddress = $("[id*=txtAddress]");
        var txtPhone = $("[id*=txtPhone]");

        $.ajax({
            type: "POST",
            url: "ContactList.aspx/InsertContact",
            data: '{name: "' + txtName.val() + '", address: "' + txtAddress.val() + '", phone: "' + txtPhone.val() + '" }',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                var row = $("[id*=gvContacts] tr:last-child");
                if ($("[id*=gvContacts] tr:last-child span").eq(0).html() != "&nbsp;") {
                    row = row.clone();
                }
                AppendRow(row, response.d, txtName.val(), txtAddress.val(), txtPhone.val());
                txtName.val("");
                txtAddress.val("");
                txtPhone.val("");
            }
        });
        return false;
    });
    //Edit event handler.
    $("body").on("click", "[id*=gvContacts] .Edit", function () {
        var row = $(this).closest("tr");
        $("td", row).each(function () {
            if ($(this).find("input").length > 0) {
                $(this).find("input").show();
                $(this).find("span").hide();
            }
        });
        row.find(".Update").show();
        row.find(".Cancel").show();
        row.find(".Delete").hide();
        $(this).hide();
        return false;
    });
    //Update event handler.
    $("body").on("click", "[id*=gvContacts] .Update", function () {
        var row = $(this).closest("tr");
        $("td", row).each(function () {
            if ($(this).find("input").length > 0) {
                var span = $(this).find("span");
                var input = $(this).find("input");
                span.html(input.val());
                span.show();
                input.hide();
            }
        });
        row.find(".Edit").show();
        row.find(".Delete").show();
        row.find(".Cancel").hide();
        $(this).hide();

        var Id = row.find(".Id").find("span").html();
        var name = row.find(".name").find("span").html();
        var address = row.find(".address").find("span").html();
        var phone = row.find(".phone").find("span").html();
        $.ajax({
            type: "POST",
            url: "ContactList.aspx/UpdateContact",
            data: '{Id: ' + Id + ', name: "' + name + '", address: "' + address + '",phone: "' + phone + '" }',
            contentType: "application/json; charset=utf-8",
            dataType: "json"
        });

        return false;
    });
    //Cancel event handler.
    $("body").on("click", "[id*=gvContacts] .Cancel", function () {
        var row = $(this).closest("tr");
        $("td", row).each(function () {
            if ($(this).find("input").length > 0) {
                var span = $(this).find("span");
                var input = $(this).find("input");
                input.val(span.html());
                span.show();
                input.hide();
            }
        });
        row.find(".Edit").show();
        row.find(".Delete").show();
        row.find(".Update").hide();
        $(this).hide();
        return false;
    });
    //Delete event handler.
    $("body").on("click", "[id*=gvContacts] .Delete", function () {
        if (confirm("Do you want to delete this row?")) {
            var row = $(this).closest("tr");
            var Id = row.find("span").html();
            $.ajax({
                type: "POST",
                url: "ContactList.aspx/DeleteContact",
                data: '{Id: ' + Id + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if ($("[id*=gvContacts] tr").length > 2) {
                        row.remove();
                    } else {
                        row.find(".Edit").hide();
                        row.find(".Delete").hide();
                        row.find("span").html('&nbsp;');
                    }
                }
            });
        }

        return false;
    });
</script>

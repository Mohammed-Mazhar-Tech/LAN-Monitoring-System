<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Report.aspx.cs" Inherits="LANMonitor.Report" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style>
        .header {
            text-align: center;
            padding: 10px;
            font-size: 28px;
            font-weight: bold;
        }
        .filter-panel {
            text-align: center;
            margin-bottom: 20px;
        }
        .filter-panel input, .filter-panel button {
            margin: 10px;
            padding: 8px 16px;
            font-size: 14px;
        }
        .gridview-container {
            margin: 0 auto;
            width: 90%;
        }

        .card-button {
    background-color: #007bff;
    border: none;
    color: white;
    padding: 10px 16px;
    border-radius: 6px;
    font-size: 14px;
    cursor: pointer;
    transition: background-color 0.3s ease;
    margin-right: 10px;
}

.card-button:hover {
    background-color: #0056b3;
}
.wrap-text {
    white-space: pre-wrap; /* Preserves line breaks */
    word-wrap: break-word;
    max-width: 300px; /* You can adjust the width */
}

#hourSidebar {
    background-color: #f4f4f4;
    /*padding: 10px;*/
    /*border-radius: 8px;*/
    height: 95vh;
    width:200px;
    overflow-y: auto;
}

.hour-button-container {
    text-align: center;
    /*margin-bottom: 10px;*/
}

.hour-button {
    width:184px;
    background-color: #006699;
    color: white;
    border-bottom:1px solid black;
    padding: 4.1px 0px;
    text-align: center;
    display: inline-block;
    font-size: 14px;
    cursor: pointer;
    text-decoration: none;
}

.hour-button:hover {
    background-color: #007bff;
}

    </style>
</head>
<body>
    <form id="form1" runat="server">
                <div id="hourSidebar" runat="server" visible="false" style="width: 200px; float: left; ">
    <asp:Repeater ID="rptHours" runat="server"  OnItemCommand="rptHours_ItemCommand">
        <ItemTemplate >
              <div class="hour-button-container">
            <asp:LinkButton  runat="server" CssClass="hour-button" 
                CommandName="SelectHour"
                CommandArgument='<%# Eval("Range") %>'>
                <%# Eval("Label") %>
            </asp:LinkButton>
                  </div>
            <%--<br /><br />--%>
        </ItemTemplate>
    </asp:Repeater>
</div>
        <div class="header">LAN Scan Report</div>

        <div class="filter-panel">
    <asp:Label ID="lblDate" runat="server" Text="Select Date:" />
    <asp:TextBox ID="txtDate" runat="server" TextMode="Date" />
    <br />
  
   <asp:Button ID="btnFilterByDate" runat="server" Text="Filter By Date" CssClass="card-button" OnClick="btnFilterByDate_Click" />
</div>

        <asp:Label ID="lblStatus" runat="server" ForeColor="Red" Style="display:block; text-align:center; margin-top:10px;" />
         <asp:Label ID="lblActiveCount" runat="server" Font-Bold="true" ForeColor="DarkGreen" Style="display:block; text-align:center; margin:10px;" />
        <div style="text-align: center; margin: 20px;">
    <asp:Button ID="btnDownloadPDF" runat="server" Text="Download as PDF" CssClass="card-button" OnClick="btnDownloadPDF_Click" Visible="false" />
</div>

       <asp:Panel ID="pnlReport" runat="server">
    <div style="max-height: 500px; overflow-y: auto; ">
        <asp:GridView ID="GridViewReport" runat="server" AutoGenerateColumns="False"
            HeaderStyle-BackColor="#006699" HeaderStyle-ForeColor="White"
            BorderStyle="Solid" BorderWidth="1px" Width="80%" align="center"
            GridLines="Both" ShowHeaderWhenEmpty="True" OnRowCommand="GridView1_RowCommand">
            
            <Columns>
                <asp:BoundField DataField="IPADDRESS" HeaderText="IP Address">
                    <ItemStyle HorizontalAlign="Center" />
                    <HeaderStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="MACADDRESS" HeaderText="MAC Address">
                    <ItemStyle HorizontalAlign="Center" />
                    <HeaderStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="SCANDATE" HeaderText="Scan Date">
                    <ItemStyle HorizontalAlign="Center" />
                    <HeaderStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="SESSIONID" HeaderText="Session ID">
                    <ItemStyle HorizontalAlign="Center" />
                    <HeaderStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="SHAREDFOLDERS" HeaderText="Shared Folders">
                    <ItemStyle CssClass="wrap-text" />
                </asp:BoundField>
                  <asp:TemplateField HeaderText="History">
    <ItemTemplate>
        <asp:LinkButton ID="lnkHistory" runat="server" CssClass="card-button"
            CommandName="ShowHistory" CommandArgument='<%# Eval("IPADDRESS") %>'>Show</asp:LinkButton>
    </ItemTemplate>
</asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Panel>
                                <%--<asp:SqlDataSource ID="SqlDataSource1" runat="server"
                            ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
                            ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                            SelectCommand="
SELECT * FROM ActiveSystems
WHERE SessionID = (SELECT MAX(SessionID) FROM ActiveSystems)"></asp:SqlDataSource>--%>


    </form>
</body>
</html>

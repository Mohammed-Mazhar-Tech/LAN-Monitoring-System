    <%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Stats.aspx.cs" Inherits="LANMonitor.Stats" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style>
        .header {
            text-align: center;
            font-size: 26px;
            font-weight: bold;
            padding: 15px;
        }
        .status-label {
            display: block;
            text-align: center;
            margin: 10px;
            font-size: 16px;
        }
        .gridview-container {
            width: 90%;
           display:flex;
           justify-content:center;
        }
        .styled-gridview th {
            background-color: #006699;
            color: white;
        }
        .styled-gridview td {
            text-align: center;
            padding: 5px;
            word-wrap: break-word;
            white-space: pre-wrap;
            max-width: 400px;
        }
    </style>
</head>
     
<body>
    <form id="form1" runat="server">
        <div class="header">IP Scan History</div>

        <asp:Label ID="lblMessage" runat="server" CssClass="status-label" ForeColor="DarkGreen" Font-Bold="True" />

        <div class="gridview-container">
            <asp:GridView ID="GridViewHistory" runat="server" AutoGenerateColumns="False"
                CssClass="styled-gridview" GridLines="Both" BorderWidth="1px"
                HeaderStyle-HorizontalAlign="Center" ShowHeaderWhenEmpty="True">
                <Columns>
                    <asp:BoundField DataField="IPADDRESS" HeaderText="IP Address" />
                    <asp:BoundField DataField="MACADDRESS" HeaderText="MAC Address" />
                    <asp:BoundField DataField="SCANDATE" HeaderText="Scan Date" DataFormatString="{0:dd-MM-yyyy HH:mm:ss}" />
                    <asp:BoundField DataField="SESSIONID" HeaderText="Session ID" />
                    <asp:BoundField DataField="SHAREDFOLDERS" HeaderText="Shared Folders" />
                </Columns>
            </asp:GridView>
        </div>
    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="LANMonitor.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>LAN Monitor Dashboard</title>
    <style>
        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 30px;
            background-color: #f9f9f9;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .dashboard-title {
            font-size: 24px;
            font-weight: bold;
            text-align: center;
            flex-grow: 1;
            color: black;
        }

        .dashboard-datetime {
            font-size: 16px;
            color: black;
            font-weight: bold;
            white-space: nowrap;
        }

        .actions-container {
            display: flex;
            justify-content: center;
            gap: 40px;
            margin-top: 10px;
        }

        .action-card {
            width: 250px;
            background: #fff;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            text-align: center;
            margin-top: 10px;
        }

            .action-card h3 {
                font-size: 20px;
                color: #333;
            }

            .action-card p {
                font-size: 14px;
                color: #666;
                margin: 10px 0;
            }

            .action-card button, .card-button {
                background-color: #007bff;
                border: none;
                color: white;
                padding: 10px 16px;
                border-radius: 6px;
                font-size: 14px;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }

                .action-card button:hover, .card-button:hover {
                    background-color: #0056b3;
                }

        .card-button {
            padding: 8px 16px;
        }

        .table {
            margin-top: 30px;
        }

        .wrap-text {
            white-space: pre-wrap; /* Preserves line breaks */
            word-wrap: break-word;
            max-width: 300px; /* You can adjust the width */
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="600" />
        <div>
            <div class="dashboard-header">
                <div class="dashboard-title">Dashboard</div>
                <div class="dashboard-datetime" id="datetime"></div>
            </div>

            <div class="actions-container">
                <asp:UpdatePanel ID="UpdatePanel1" CssClass="actions-container" runat="server">
                    <ContentTemplate>
                        <div class="actions-container">

                            <div class="action-card">
                                <h3>Scan Network</h3>
                                <p>Detect all active devices on the LAN.</p>

                                <asp:Button ID="btnScanNetwork" runat="server" Text="Start Scan" CssClass="card-button"
                                    OnClientClick="return showScanningMessage();"
                                    OnClick="btnScanNetwork_Click" />
                            </div>

                            <div class="action-card">
                                <h3>View Results</h3>
                                <p>See the most recent scan results.</p>
                                <asp:Button ID="btnShowResults" runat="server" Text="View Latest Scan Results" CssClass="card-button"
                                    OnClick="btnShowResults_Click" />
                            </div>
                        </div>

                        <asp:Label ID="lblScanning" runat="server" CssClass="dashboard-datetime" ForeColor="Red" />
                        <div class="table">
                            <div class="scrollable-table-container">
                                <asp:Panel ID="pnlResults" runat="server" Visible="false">
                                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"
                        CssClass="styled-grid" HeaderStyle-BackColor="#006699" HeaderStyle-ForeColor="White"
                        BorderStyle="Solid" BorderWidth="1px" Width="100%" GridLines="Both"
                        ShowHeaderWhenEmpty="True" DataSourceID="SqlDataSource1"
                        OnRowCommand="GridView1_RowCommand">
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
                                </asp:Panel>

                                <asp:SqlDataSource ID="SqlDataSource1" runat="server"
                                    ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
                                    ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                                    SelectCommand="
        SELECT * FROM ActiveSystems
        WHERE SessionID = (SELECT MAX(SessionID) FROM ActiveSystems)"></asp:SqlDataSource>

                            </div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </form>

    <script>
        function showScanningMessage() {
            document.getElementById('<%= lblScanning.ClientID %>').innerText = "🔄 Scan Started...";
            document.getElementById('<%= lblScanning.ClientID %>').style.color = "orange";
            return true;
        }

        function updateDateTime() {
            const now = new Date();
            const formatted = now.toLocaleString('en-IN', {
                weekday: 'short',
                year: 'numeric',
                month: 'short',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
                hour12: true
            });
            document.getElementById('datetime').innerHTML = formatted;
        }

        setInterval(updateDateTime, 1000);
        updateDateTime();
    </script>
</body>
</html>

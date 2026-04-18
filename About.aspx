<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="LANMonitor.About" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>About - LAN Monitor</title>
 <style>
        body {
            font-family: Arial, sans-serif;
            margin: 30px;
            background-color: #f9f9f9;
        }

        .container {
            max-width: 900px;
            margin: auto;
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 12px rgba(0, 0, 0, 0.1);
        }

        h1, h2 {
            color: #006699;
        }

        ul {
            margin-left: 20px;
        }

        .feature-section {
            margin-bottom: 30px;
        }

        .highlight {
            color: #444;
            font-weight: bold;
        }

        .footer {
            text-align: center;
            font-size: 13px;
            margin-top: 30px;
            color: #888;
        }
    </style>
</head>
<body>
   <form id="form1" runat="server">
        <div class="container">
            <h1>About the LAN Monitoring System</h1>
            <p>
                The LAN Monitoring System is a comprehensive web-based tool developed to track and manage the status of all systems connected to a local area network (LAN). It provides administrators with real-time visibility and historical reports of machine activity.
            </p>

            <div class="feature-section">
                <h2>🔍 Features</h2>
                <ul>
                    <li><span class="highlight">LAN Scanning:</span> Periodically scans all computers on the network to detect active systems.</li>
                    <li><span class="highlight">MAC and IP Address Tracking:</span> Captures MAC and IP addresses of all live systems.</li>
                    <li><span class="highlight">Scan Date and Time:</span> Records the exact timestamp of when each system was active.</li>
                    <li><span class="highlight">Shared Folder Discovery:</span> Retrieves and displays shared folders from each detected system.</li>
                    <li><span class="highlight">Filter by Date:</span> Admin can select a date and view systems that were active on that specific day.</li>
                    <li><span class="highlight">Hourly Filter:</span> After selecting a date, the admin can further filter results based on hourly time ranges.</li>
                    <li><span class="highlight">Session ID Tracking:</span> Keeps records of scans with session identifiers for easy auditing.</li>
                    <li><span class="highlight">PDF Export:</span> Download current scan results as a Word-style (.doc) report for offline use.</li>
                    <li><span class="highlight">System History:</span> View history of any particular system’s activity across different scans.</li>
                    <li><span class="highlight">Responsive UI:</span> Clean, easy-to-use interface with buttons and sidebars to filter and view data efficiently.</li>
                </ul>
            </div>

            <div class="feature-section">
                <h2>⚙️ How It Works</h2>
                <ul>
                    <li>The system scans the network using ping and other system utilities to detect active systems.</li>
                    <li>Each scan is stored with a session ID and includes the IP address, MAC address, scan timestamp, and shared folders.</li>
                    <li>Admins can view the latest scan or filter by any selected date and time slot to view historical data.</li>
                    <li>Clicking on "Show" under the History column redirects to a detailed statistics page for the selected IP.</li>
                    <li>All data is securely stored in an Oracle database for robust storage and retrieval.</li>
                </ul>
            </div>

            <div class="feature-section">
                <h2>👨‍💻 Who Should Use It?</h2>
                <p>
                    This system is ideal for system administrators and IT managers in educational institutions, corporate offices, or any organization that needs to monitor LAN activity for compliance, maintenance, or usage tracking.
                </p>
            </div>

            <div class="footer">
                &copy; 2025 LANMonitor System. All rights reserved.
            </div>
        </div>
    </form>

</body>
</html>

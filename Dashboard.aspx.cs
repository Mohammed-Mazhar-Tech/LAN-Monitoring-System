using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;
using static iTextSharp.text.pdf.events.IndexEvents;

namespace LANMonitor
{
    public partial class Dashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["username"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                pnlResults.Visible = false;  // Hide results panel on first load
            }
        }




        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ShowHistory")
            {
                string ip = e.CommandArgument.ToString();
                Response.Redirect("Stats.aspx?ip=" + Server.UrlEncode(ip));
            }
        }



        protected void btnShowResults_Click(object sender, EventArgs e)
        {
            pnlResults.Visible = true;
            GridView1.DataBind();
        }


        private List<string> DiscoverSharedFolders(string ip)
        {
            List<string> shares = new List<string>();

            try
            {
                ProcessStartInfo psi = new ProcessStartInfo
                {
                    FileName = "cmd.exe",
                    Arguments = $"/c net view \\\\{ip}",
                    RedirectStandardOutput = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                };

                using (Process proc = Process.Start(psi))
                {
                    string output = proc.StandardOutput.ReadToEnd();
                    proc.WaitForExit();

                    // Extract share names from output
                    var matches = Regex.Matches(output, @"\\\\.*\\([^\s]+)\s+Disk", RegexOptions.IgnoreCase);
                    foreach (Match match in matches)
                    {
                        if (match.Groups.Count > 1)
                        {
                            shares.Add(match.Groups[1].Value);
                        }
                    }

                    // Alternate parsing if that fails
                    if (shares.Count == 0)
                    {
                        string[] lines = output.Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries);
                        foreach (string line in lines)
                        {
                            if (line.Trim().StartsWith("Disk"))
                                continue;

                            if (line.Contains("Disk"))
                            {
                                string[] parts = line.Trim().Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                                if (parts.Length > 0)
                                    shares.Add(parts[0]);
                            }
                        }
                    }
                }
            }
            catch
            {
                shares.Add("Access Denied or No Shares");
            }

            return shares.Count > 0 ? shares : new List<string> { "No Shares Found" };
        }


        protected void btnScanNetwork_Click(object sender, EventArgs e)
        {
            var stopwatch = Stopwatch.StartNew();
            lblScanning.Text = "Scanning network, please wait...";
            lblScanning.ForeColor = System.Drawing.Color.Blue;

            List<string> ipList = IPScanner.GenerateIPRange("192.168.1.", 1, 254);
            int scanSessionId = OracleHandler.CreateNewScanSession();
            int savedCount = 0;

            foreach (string ip in ipList)
            {
                if (IPScanner.PingHost(ip))
                {
                    ArpEntry entry = IPScanner.GetArpInfo(ip);
                    if (entry != null)
                    {
                        // Discover shared folders
                        List<string> sharedFolders = DiscoverSharedFolders(ip);
                        string sharedInfo = string.Join(", ", sharedFolders);

                        OracleHandler.SaveToDatabase(ip, entry.MacAddress, entry.Type, scanSessionId, sharedInfo);
                        savedCount++;
                    }
                }
            }

            stopwatch.Stop();
            pnlResults.Visible = true;
            GridView1.DataBind();

            lblScanning.Text = $"✅ Scan complete. {savedCount} devices found in {stopwatch.Elapsed.TotalSeconds:F1} seconds.";
            lblScanning.ForeColor = System.Drawing.Color.Green;
        }
    }
}

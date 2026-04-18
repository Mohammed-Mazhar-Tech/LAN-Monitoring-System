using iTextSharp.text;
using iTextSharp.text.html.simpleparser;
using iTextSharp.text.pdf;

using System;
using System.Configuration;
using System.Data;
using System.Data.OracleClient;
using System.Drawing.Printing;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace LANMonitor
{
    public partial class Report : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["OracleDbContext"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["username"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            if (!IsPostBack)
            {
                lblStatus.Text = "";
            }

        }
        private void ShowHourSidebar()
        {
            DataTable hourTable = new DataTable();
            hourTable.Columns.Add("Range");
            hourTable.Columns.Add("Label");

            for (int i = 0; i < 24; i++)
            {
                DateTime from = DateTime.Today.AddHours(i);
                DateTime to = from.AddHours(1);
                string rangeValue = $"{from:HH}:00|{to:HH}:00"; // For internal use
                string displayLabel = $"{from:htt} - {to:htt}"; // e.g., 1AM - 2AM

                hourTable.Rows.Add(rangeValue, displayLabel);
            }

            rptHours.DataSource = hourTable;
            rptHours.DataBind();
            hourSidebar.Visible = true;
        }

        protected void btnLatest_Click(object sender, EventArgs e)
        {
            string query = @"
                SELECT DISTINCT IPADDRESS, MACADDRESS, SCANDATE, SESSIONID, SHAREDFOLDERS 
                FROM ActiveSystems
                WHERE SessionID = (SELECT MAX(SessionID) FROM ActiveSystems)";
            LoadGrid(query, null);
            int count = GetCount("SELECT COUNT(DISTINCT IPADDRESS) FROM ActiveSystems WHERE SessionID = (SELECT MAX(SessionID) FROM ActiveSystems)");
            lblActiveCount.Text = $"🖥️ Active Systems: {count}";
            lblStatus.Text = "✅ Showing latest scan results.";
            btnDownloadPDF.Visible = true;
        }

        protected void btnFilterByDate_Click(object sender, EventArgs e)
        {
            DateTime selectedDate;
            if (DateTime.TryParseExact(txtDate.Text, "yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None, out selectedDate))
            {
                string query = @"SELECT IPADDRESS, MACADDRESS, SCANDATE, SESSIONID, SHAREDFOLDERS
FROM (SELECT IPADDRESS, MACADDRESS, SCANDATE, SESSIONID, SHAREDFOLDERS,ROW_NUMBER() OVER (PARTITION BY IPADDRESS ORDER BY SCANDATE DESC) AS rn FROM ActiveSystems WHERE TRUNC(SCANDATE) = TO_DATE(:SelectedDate, 'DD-MM-YYYY') ) WHERE rn = 1";
                // Convert to DD-MM-YYYY format for Oracle
                string oracleDate = selectedDate.ToString("dd-MM-yyyy");
                OracleParameter[] gridParams = { new OracleParameter("SelectedDate", OracleType.VarChar) { Value = oracleDate } };
                OracleParameter[] countParams = { new OracleParameter("SelectedDate", OracleType.VarChar) { Value = oracleDate } };
                LoadGrid(query, gridParams);
                int count = GetCount("SELECT COUNT(DISTINCT IPADDRESS) FROM ActiveSystems WHERE TRUNC(SCANDATE) = TO_DATE(:SelectedDate, 'DD-MM-YYYY')", countParams);
                lblActiveCount.Text = "🖥️ Active Systems: " + count.ToString();
                lblStatus.Text = "📅 Showing results for: " + selectedDate.ToString("dd-MM-yyyy");
            }
            else
            {
                lblStatus.Text = "⚠️ Invalid date. Please select again.";
                lblActiveCount.Text = "";
            }
            btnDownloadPDF.Visible = true;
            Session["SelectedDate"] = selectedDate;
            ShowHourSidebar();  // display hour filters

        }



        protected void rptHours_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "SelectHour")
            {
                if (Session["SelectedDate"] == null) return;

                DateTime selectedDate = (DateTime)Session["SelectedDate"];
                string[] times = e.CommandArgument.ToString().Split('|');
                string fromTimeStr = times[0];
                string toTimeStr = times[1];

                DateTime fromTime = DateTime.ParseExact($"{selectedDate:yyyy-MM-dd} {fromTimeStr}", "yyyy-MM-dd HH:mm", null);
                DateTime toTime = DateTime.ParseExact($"{selectedDate:yyyy-MM-dd} {toTimeStr}", "yyyy-MM-dd HH:mm", null);

                string query = @"
SELECT IPADDRESS, MACADDRESS, SCANDATE, SESSIONID, SHAREDFOLDERS
FROM (
    SELECT IPADDRESS, MACADDRESS, SCANDATE, SESSIONID, SHAREDFOLDERS,
           ROW_NUMBER() OVER (PARTITION BY IPADDRESS ORDER BY SCANDATE DESC) AS rn
    FROM ActiveSystems
    WHERE SCANDATE BETWEEN TO_DATE(:FromTime, 'YYYY-MM-DD HH24:MI') AND TO_DATE(:ToTime, 'YYYY-MM-DD HH24:MI')
)
WHERE rn = 1";


                OracleParameter[] gridParams = {
            new OracleParameter("FromTime", OracleType.VarChar) { Value = fromTime.ToString("yyyy-MM-dd HH:mm") },
            new OracleParameter("ToTime", OracleType.VarChar) { Value = toTime.ToString("yyyy-MM-dd HH:mm") }
        };
                OracleParameter[] countParams = {
            new OracleParameter("FromTime", OracleType.VarChar) { Value = fromTime.ToString("yyyy-MM-dd HH:mm") },
            new OracleParameter("ToTime", OracleType.VarChar) { Value = toTime.ToString("yyyy-MM-dd HH:mm") }
        };
                LoadGrid(query, gridParams);

                // 🔄 Update count
                int count = GetCount(
                    "SELECT COUNT(DISTINCT IPADDRESS) FROM ActiveSystems WHERE SCANDATE BETWEEN TO_DATE(:FromTime, 'YYYY-MM-DD HH24:MI') AND TO_DATE(:ToTime, 'YYYY-MM-DD HH24:MI')",
                    countParams);

                lblActiveCount.Text = "🖥️ Active Systems: " + count.ToString();
                lblStatus.Text = $"⏰ Showing results from {fromTime:htt} to {toTime:htt} on {selectedDate:dd-MM-yyyy}";
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


        private int GetCount(string query, OracleParameter[] parameters = null)
        {
            using (OracleConnection conn = new OracleConnection(connStr))
            {
                using (OracleCommand cmd = new OracleCommand(query, conn))
                {
                    if (parameters != null)
                        foreach (OracleParameter param in parameters)
                            cmd.Parameters.Add(param);

                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    conn.Close();

                    return result != DBNull.Value ? Convert.ToInt32(result) : 0;
                }
            }
        }

        private void LoadGrid(string query, OracleParameter[] parameters)
        {
            using (OracleConnection conn = new OracleConnection(connStr))
            {
                OracleCommand cmd = new OracleCommand(query, conn);
                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);

                OracleDataAdapter da = new OracleDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                GridViewReport.DataSource = dt;
                GridViewReport.DataBind();
            }
        }

        [Obsolete]
        protected void btnDownloadPDF_Click(object sender, EventArgs e)
        {
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=ScanReport.doc");
            Response.Charset = "";
            Response.ContentType = "application/msword";

            using (StringWriter sw = new StringWriter())
            {
                using (HtmlTextWriter hw = new HtmlTextWriter(sw))
                {
                    // Render the labels
                    sw.Write("<h2>Scan Report</h2>");
                    sw.Write($"<p><strong>{lblActiveCount.Text}</strong></p>");
                    sw.Write($"<p><strong>{lblStatus.Text}</strong></p>");
                    sw.Write("<hr/>");

                    // Render the GridView
                    GridViewReport.RenderControl(hw);

                    // Output all content to Word
                    Response.Output.Write(sw.ToString());
                    Response.Flush();
                    Response.End();
                }
            }
        }



        public override void VerifyRenderingInServerForm(Control control)
        {
            // Required for exporting GridView to PDF
        }
    }
}

using System;
using System.Configuration;
using System.Data;
using System.Data.OracleClient; // NOTE: Use System.Data.OracleClient for .NET 4.0
using System.Web.UI;

namespace LANMonitor
{
    public partial class Stats : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["username"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            if (!IsPostBack)
            {
                string ip = Request.QueryString["ip"];
                if (!string.IsNullOrEmpty(ip))
                {
                    LoadIPHistory(ip);
                }
                else
                {
                    lblMessage.Text = "⚠️ No IP address provided in the URL.";
                }
            }
        }

        private void LoadIPHistory(string ip)
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (OracleConnection conn = new OracleConnection(connStr))
            {
                try
                {
                    conn.Open();

                    string query = @"SELECT IPADDRESS, MACADDRESS, SCANDATE, SESSIONID, SHAREDFOLDERS 
                                     FROM ActiveSystems 
                                     WHERE IPADDRESS = :ip 
                                     ORDER BY SCANDATE DESC";

                    using (OracleCommand cmd = new OracleCommand(query, conn))
                    {
                        cmd.Parameters.Add(new OracleParameter("ip", ip));

                        OracleDataAdapter adapter = new OracleDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        GridViewHistory.DataSource = dt;
                        GridViewHistory.DataBind();

                        lblMessage.Text = "✅ Records for IP: " + ip;
                    }
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "❌ Error: " + ex.Message;
                }
            }
        }
    }
}

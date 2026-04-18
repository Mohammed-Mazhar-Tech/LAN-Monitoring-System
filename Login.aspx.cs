using Oracle.ManagedDataAccess.Client;
using System;
using System.Configuration;
using System.Diagnostics;

namespace LANMonnitor
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Username"] != null)
                {
                    Response.Redirect("Home.aspx");
                }
            }
        }
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUser.Text.Trim();
            string password = txtPass.Text.Trim();

            bool isValid = ValidateUserFromDB(username, password);

            if (isValid)
            {
                Session["username"] = username;
                Response.Redirect("Home.aspx");
            }
            else
                lblMessage.Text = "Invalid username or password.";
        }

        private bool ValidateUserFromDB(string username, string password)
        {
            string conStr = ConfigurationManager.ConnectionStrings["OracleDbContext"].ConnectionString;

            using (OracleConnection con = new OracleConnection(conStr))
            {
                using (OracleCommand cmd = new OracleCommand("Active.VALIDATE_USER", con))
                {
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("p_user_id", OracleDbType.Varchar2).Value = username;
                    cmd.Parameters.Add("p_password", OracleDbType.Varchar2).Value = password;

                    OracleParameter output = new OracleParameter("p_is_valid", OracleDbType.Int32);
                    output.Direction = System.Data.ParameterDirection.Output;
                    cmd.Parameters.Add(output);

                    con.Open();
                    cmd.ExecuteNonQuery();

                    return ((Oracle.ManagedDataAccess.Types.OracleDecimal)output.Value).ToInt32() == 1;

                }
            }
        }
    }
}
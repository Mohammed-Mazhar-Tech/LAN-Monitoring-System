using System;
using System.Configuration;
using System.Data.OracleClient; // Legacy Oracle client

namespace LANMonitor
{
    public static class OracleHandler
    {
        // Connection string (no change here)
        private static readonly string connStr = "Data Source=XE;User Id=SYSTEM;Password=hemu2426;";

        public static void SaveToDatabase(string ip, string mac, string type, int sessionid, string sharedinfo)
        {
            try
            {
                using (OracleConnection con = new OracleConnection(connStr))
                {
                    con.Open();
                    string sql = "INSERT INTO ActiveSystems (IPAddress, MACAddress, Type, SessionId, SharedFolders) VALUES (:p1, :p2, :p3, :p4, :p5)";
                    using (OracleCommand cmd = new OracleCommand(sql, con))
                    {
                        cmd.Parameters.Add(new OracleParameter("p1", ip));
                        cmd.Parameters.Add(new OracleParameter("p2", mac));
                        cmd.Parameters.Add(new OracleParameter("p3", type));
                        cmd.Parameters.Add(new OracleParameter("p4", sessionid));
                        cmd.Parameters.Add(new OracleParameter("p5", sharedinfo));

                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("DB Error: " + ex.Message);
            }
        }

        /// <summary>
        /// Inserts a new scan session and returns the generated ID.
        /// </summary>
        public static int CreateNewScanSession()
        {
            int sessionId = -1;
            string connStr = ConfigurationManager.ConnectionStrings["OracleDbContext"].ConnectionString;

            try
            {
                using (OracleConnection conn = new OracleConnection(connStr))
                {
                    conn.Open();

                    // Insert the scan session
                    string insertSql = "INSERT INTO ScanSessions (ScanDate) VALUES (SYSDATE)";
                    using (OracleCommand insertCmd = new OracleCommand(insertSql, conn))
                    {
                        insertCmd.ExecuteNonQuery();
                    }

                    // Get the latest inserted session ID
                    string selectSql = "SELECT MAX(ID) FROM ScanSessions";
                    using (OracleCommand selectCmd = new OracleCommand(selectSql, conn))
                    {
                        object result = selectCmd.ExecuteScalar();
                        if (result != DBNull.Value)
                        {
                            sessionId = Convert.ToInt32(result);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Database Error (CreateNewScanSession): " + ex.Message);
            }

            return sessionId;
        }
    }
}

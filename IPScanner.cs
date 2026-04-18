using Org.BouncyCastle.Asn1.X509;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Net.NetworkInformation;
using System.Text.RegularExpressions;

namespace LANMonitor
{
    public static class IPScanner
    {
        public static List<string> GenerateIPRange(string prefix, int start, int end)
        {
            List<string> ips = new List<string>();
            for (int i = start; i <= end; 
                
                i++)
            {
                ips.Add(prefix + i);
            }
            return ips;
        }


        public static bool PingHost(string ip)
        {
            try
            {
                Ping ping = new Ping();
                PingReply reply = ping.Send(ip, 100);
                return reply.Status == IPStatus.Success;
            }
            catch
            {
                return false;
            }
        }

        public static ArpEntry GetArpInfo(string ip)
        {
            try
            {
                Process p = new Process();
                p.StartInfo.FileName = "arp";
                p.StartInfo.Arguments = "-a " + ip;
                p.StartInfo.RedirectStandardOutput = true;
                p.StartInfo.UseShellExecute = false;
                p.StartInfo.CreateNoWindow = true;
                p.Start();

                string output = p.StandardOutput.ReadToEnd();
                p.WaitForExit();

                // Match line like: 192.168.1.254    aa-bb-cc-dd-ee-ff     dynamic
                Match match = Regex.Match(output, @"(?<ip>\d+\.\d+\.\d+\.\d+)\s+(?<mac>([a-fA-F0-9]{2}[-:]){5}[a-fA-F0-9]{2})\s+(?<type>\w+)", RegexOptions.IgnoreCase);

                if (match.Success)
                {
                    return new ArpEntry
                    {
                        MacAddress = match.Groups["mac"].Value,
                        Type = match.Groups["type"].Value
                    };
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Detailed Error: " + ex.ToString());
            }

            return null;
        }
    }
}

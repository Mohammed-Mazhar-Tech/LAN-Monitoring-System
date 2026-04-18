# 🔐 LAN Monitoring System

🚀 Internship Project | HAL (Hindustan Aeronautics Limited)

A web-based LAN monitoring system developed using ASP.NET and C# to scan, analyze, and track devices connected within a local network. The system provides real-time network visibility, device discovery, and historical tracking using an Oracle database.

---

## 📌 Features

* 🔍 **Network Scanning** – Scan IP range to detect active devices
* 📡 **Device Discovery** – Identify devices using ICMP (Ping)
* 🧾 **MAC Address Detection** – Extract MAC addresses using ARP
* 📁 **Shared Folder Detection** – Discover shared resources
* 🗄️ **Database Integration** – Store scan results in Oracle DB
* 📊 **Session-Based Tracking** – Track each scan using unique session IDs
* 📅 **Date & Time Filtering** – Analyze network activity by date and hour
* 📈 **Device History Tracking** – View past records of devices
* 📥 **Report Generation** – Export scan results

---

## 🛠️ Tech Stack

* **Frontend:** ASP.NET WebForms
* **Backend:** C#
* **Database:** Oracle Database
* **Networking Tools:** Ping, ARP, Net View
* **Libraries:** iTextSharp

---

## ⚙️ How It Works

1. User logs into the system
2. Initiates network scan
3. System scans IP range (e.g., 192.168.1.1 – 254)
4. Active devices are detected using Ping
5. MAC addresses are retrieved using ARP
6. Shared folders are identified
7. Data is stored in Oracle database
8. Results are displayed in dashboard
9. Reports and device history can be accessed

---

## 📁 Project Structure

```plaintext
LAN-Monitoring-System/
│
├── LANMonitor.sln
│
├── LANMonitor/
│   ├── About.aspx
│   ├── Dashboard.aspx
│   ├── Home.aspx
│   ├── Login.aspx
│   ├── Report.aspx
│   ├── Stats.aspx
│   ├── IPScanner.cs
│   ├── OracleHandler.cs
│   ├── ArpEntry.cs
│   ├── Web.config
│   └── LANMonitor.csproj
│
├── README.md
└── .gitignore
```

---

## ▶️ How to Run

1. Clone the repository
2. Open `LANMonitor.sln` in Visual Studio
3. Restore NuGet packages
4. Configure database connection in `Web.config`
5. Build and run the project

---

## 📸 Screenshots

*Add screenshots of dashboard, reports, and scan results here*

---

## ⚠️ Security Note

Sensitive information such as database credentials has been removed or replaced with placeholders in this repository.

---

## 🚀 Future Enhancements

* ⚡ Multi-threaded network scanning for improved performance
* 🔔 Real-time alerts for unauthorized devices
* 🛡️ Intrusion detection integration
* 🌐 Migration to ASP.NET Core
* 📡 Live monitoring using SignalR

---

## 👨‍💻 Author

**Zayn Hamza**
CSE (Cyber Security) Student
Intern @ HAL

---

## 📄 License

This project is licensed under the MIT License.

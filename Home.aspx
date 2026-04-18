<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="LANMonitor.Home" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
    <style>
         body {
     margin: 0;
     padding: 0;
     font-family: Arial, sans-serif;
     /*background: url('Images/aircraft-1920x1080-sukhoi-su-35-wallpaper-preview.jpg') no-repeat center center fixed;*/
     background-size: cover;
 }
            /* Navbar styling */
.navbar {
  display: flex;
  align-items: center;
  justify-content: space-between; /* space between the 3 divs */
  background-color: #fff;
  padding: 10px 30px;
  height: 50px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.3);
}

.logo img {
  height: 60px;
}

/* Title centered and bold */
.title {
  font-size: 24px;
  font-weight: 800;
  color: black;
  flex-grow: 1;
  text-align: center;
}

/* Nav list on right */
.nav-list {
  display: flex;
  gap: 10px;
}

/* Nav links style */
.nav-list a {
  color: black;
  font-size: 16px;
  font-weight: 500;
  text-decoration: none;
  padding: 6px 12px;
  border-radius: 4px;
  transition: color 0.3s ease;
  cursor: pointer;
}

.nav-list a:hover {
  color: #007bff; /* blue on hover */
}

.content-frame {
    width: 100%;
    height: calc(100vh - 70px); /* full viewport height minus navbar height */
    border: none;
    display: block;
}

    </style>
<body>
    <form id="form1" runat="server">
        <div class="navbar">
            <div class="logo">
                <a href="Home.aspx">
                    <img src="Images/download.jpeg" alt="Logo" />
                </a>
                
            </div>

            <div class="title">
                LAN MONITORING SYSTEM
            </div>

            <div class="nav-list">
                <a href="Dashboard.aspx" target="contentFrame">Home</a>
    <a href="Report.aspx" target="contentFrame">Reports</a>
    <a href="About.aspx" target="contentFrame">About</a>
    <a href="javascript:void(0);" onclick="document.getElementById('<%= btnLogout.ClientID %>').click();">Logout</a>
            </div>
        </div>

        <asp:Button ID="btnLogout" runat="server" Text="Logout" OnClick="btnLogout_Click" Style="display: none;" />



        <iframe id="contentFrame" name="contentFrame" class="content-frame" src="Dashboard.aspx"></iframe>


    </form>
</body>
</html>

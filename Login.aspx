<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="LANMonnitor.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login</title>
    <style>
        /* Full page background image */
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background: url('Images/aircraft-1920x1080-sukhoi-su-35-wallpaper-preview.jpg') no-repeat center center fixed;
            background-size: cover;
        }

        /* Navbar styling */
        .navbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background-color: #ffff;
            padding: 10px 30px;
            color: white;
            height: 60px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.3);
        }

        .navbar .logo img {
            height: 80px;
        }

        .navbar .title {
            font-size: 24px;
            font-weight: bold;
            text-align: center;
            flex-grow: 1;
            color: black;
        }

        .navbar .right-text {
            font-size: 18px;
            color: black;
        }

        /* Centered login container */
        .login-container {
            width: 350px;
            background-color: rgba(255,255,255,0.9);
            margin: 100px auto;
            padding: 30px 40px;
            border: 2px solid #ccc;
            border-radius: 8px;
            box-shadow: 0 8px 16px black;
        }

        .login-container img{
            height: 60px;
            margin-left: 100px;
        }

        .login-container h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }

        .login-container label {
            font-weight: bold;
            color: #333;
        }

        .login-container input[type="text"],
        .login-container input[type="password"],
        .login-container input[type="submit"],
        .login-container input[type="button"],
        .login-container input[type="email"] {
            width: 100%;
            padding: 8px;
            margin-top: 6px;
            margin-bottom: 15px;
            border: 1px solid #aaa;
            border-radius: 4px;
            box-sizing: border-box;
        }

        .login-container input[type="submit"] {
            background-color: #007bff;
            font-size:16px;
            color: white;
            font-weight: bold;
            cursor: pointer;
            border: none;
            transition: background-color 0.3s ease;
        }

        .login-container input[type="submit"]:hover {
            background-color: #0056b3;
        }

        #<%= lblMessage.ClientID %> {
            text-align: center;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Navbar -->
        <div class="navbar">
            <div class="logo">
                <img src="Images/download.jpeg"  alt="Logo" />
            </div>
            <div class="title">
                LAN MONITORING SYSTEM
            </div>
            <div class="right-text">
                Hindustan Aeronautics Limited <br /> Avionics Department, HYD
            </div>
        </div>

        <!-- Login container -->
        <div class="login-container">
            <img src="Images/download.jpeg"  alt="Logo" />
            <h2>Login</h2>
            <asp:Label ID="lblUser" runat="server" Text="Username:"></asp:Label><br />
            <asp:TextBox ID="txtUser" runat="server"></asp:TextBox><br />

            <asp:Label ID="lblPass" runat="server" Text="Password:"></asp:Label><br />
            <asp:TextBox ID="txtPass" runat="server" TextMode="Password"></asp:TextBox><br />

            <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" /><br />

            <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>
        </div>
    </form>
</body>
</html>

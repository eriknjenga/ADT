<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="FormBased_Default" %>

<html>
<head>
    <title>FusionCharts - Form Based Data Charting Example </title>

    <script language="Javascript" src="../FusionCharts/FusionCharts.js"></script>

    <style type="text/css">
        <!--
        body {
            font-family: Arial, Helvetica, sans-serif;
            font-size: 12px;
        }
            .text{
            font-family: Arial, Helvetica, sans-serif;
            font-size: 12px;
        }
    -->
    </style>
</head>
<body>
    <center>
        <form id='form1' name='form1' method='post' runat="server">
            <center>
                <div id="DivSubmission" runat="server">
                    <h2>
                        FusionCharts Form-Based Data Example</h2>
                    <h4>
                        Restaurant Sales Chart below</h4>
                    <p class='text'>
                        Click on any pie slice to see slicing effect. Or, right click on chart and choose
                        "Enable Rotation", and then drag and rotate the chart.</p>
                    <asp:Literal ID="LiteralChart" runat="server"></asp:Literal>
                    <br />
                    <a href='javascript:history.go(-1);'>Enter data again</a>
                </div>
                <div id="DivFormParameters" runat="server">
                    <center>
                        <h2>
                            FusionCharts Form-Based Data Example</h2>
                        <p class='text'>
                            Please enter how many items of each category you sold within this week. We'll plot
                            this data on a Pie chart.
                        </p>
                        <p class='text'>
                            To keep things simple, we're not validating for non-numeric data here. So, please
                            enter valid numeric values only. In your real-world applications, you can put your
                            own validators.</p>
                        <table width='50%' align='center' cellpadding='2' cellspacing='1' border='0' class='text'>
                            <tr>
                                <td width='50%' align='right'>
                                    <b>Soups:</b> &nbsp;
                                </td>
                                <td width='50%'>
                                    <asp:TextBox ID="TextBoxSoups" runat="server" Width="60">108</asp:TextBox>
                                    bowls
                                </td>
                            </tr>
                            <tr>
                                <td width='50%' align='right'>
                                    <b>Salads:</b> &nbsp;
                                </td>
                                <td width='50%'>
                                    <asp:TextBox ID="TextboxSalads" runat="server" Width="60">162</asp:TextBox>
                                    plates
                                </td>
                            </tr>
                            <tr>
                                <td width='50%' align='right'>
                                    <b>Sandwiches:</b> &nbsp;
                                </td>
                                <td width='50%'>
                                    <asp:TextBox ID="TextboxSandwiches" runat="server" Width="60">360</asp:TextBox>
                                    pieces
                                </td>
                            </tr>
                            <tr>
                                <td width='50%' align='right'>
                                    <b>Beverages:</b> &nbsp;
                                </td>
                                <td width='50%'>
                                    <asp:TextBox ID="TextboxBeverages" runat="server" Width="60">171</asp:TextBox>
                                    cans
                                </td>
                            </tr>
                            <tr>
                                <td width='50%' align='right'>
                                    <b>Desserts:</b> &nbsp;
                                </td>
                                <td width='50%'>
                                    <asp:TextBox ID="TextboxDesserts" runat="server" Width="60">99</asp:TextBox>
                                    plates
                                </td>
                            </tr>
                            <tr>
                                <td width='50%' align='right'>
                                    &nbsp;
                                </td>
                                <td width='50%'>
                                    <asp:Button ID="ButtonChart" runat="server" Text="Chart it!" OnClick="ButtonChart_Click">
                                    </asp:Button>
                                </td>
                            </tr>
                        </table>
                    </center>
                </div>
            </center>
        </form>
        <h5>
            <a href='../default.aspx'>« Back to list of examples</a></h5>
        <a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
    </center>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="false" CodeFile="Combination.aspx.cs" Inherits="ArrayExample_Combination" %>

<html>
<head>
    <title>FusionCharts - Array Example</title>

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
    <form id='form1' name='form1' method='post' runat="server">
        <center>
            <h2>
                FusionCharts Examples</h2>
            <h4>
                Plotting Combination chart from data contained in Array.</h4>
            <%=GetProductSalesChartHtml()%>
            <br>
            <br>
            <h5>
                <a href='../default.aspx'>« Back to list of examples</a></h5>
            <a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
        </center>
    </form>
</body>
</html>

<%@ Page Language="VB" AutoEventWireup="false" CodeFile="MultiSeries.aspx.vb" Inherits="ArrayExample_MultiSeries" %>

<html>
<head>
    <title>FusionCharts - Array Example using Multi Series Column 3D Chart </title>

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
                Plotting multi-series chart from data contained in Array.</h4>
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

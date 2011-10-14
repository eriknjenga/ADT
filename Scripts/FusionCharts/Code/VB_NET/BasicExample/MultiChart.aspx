<%@ Page Language="VB" AutoEventWireup="false" CodeFile="MultiChart.aspx.vb" Inherits="MultiChart" %>

<html>
<head>
    <title>FusionCharts - Multiple Charts on one Page </title>

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
                Multiple Charts on the same page. Each chart has a unique ID.</h4>
            <%=GetMonthlySales3DChartHtml()%>
            <br>
            <br>
            <%=GetMonthlySales2DChartHtml()%>
            <br>
            <br>
            <%=GetMonthlySalesLineChartHtml()%>
            <br>
            <br>
            <h5>
                <a href='../default.aspx'>« Back to list of examples</a></h5>
            <a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
        </center>
    </form>
</body>
</html>

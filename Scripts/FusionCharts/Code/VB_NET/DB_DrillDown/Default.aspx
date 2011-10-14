<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="DBExample_Default" %>

<html>
<head>
    <title>FusionCharts - Database and Drill-Down Example </title>

    <script language="Javascript" src="../FusionCharts/FusionCharts.js"></script>

</head>
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
<body>
    <form id='form1' name='form1' method='post' runat="server">
        <center>
            <h2>
                FusionCharts Database and Drill-Down Example</h2>
            <h4>
                Click on any pie slice to see detailed data.</h4>
            <p class='text'>
                Or, right click on any pie to enable slicing or rotation mode.
            </p>
            <%=GetFactorySummaryChartHtml()%>
            <br>
            <br>
            <h5>
                <a href='../default.aspx'>« Back to list of examples</a></h5>
            <a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
        </center>
    </form>
</body>
</html>

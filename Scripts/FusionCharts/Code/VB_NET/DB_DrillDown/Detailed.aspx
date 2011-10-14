<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Detailed.aspx.vb" Inherits="DBExample_Detailed" %>

<html>
<head>
    <title>FusionCharts - Database and Drill-Down Example </title>

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
                FusionCharts Database and Drill-Down Example</h2>
            <h4>
                Detailed report for the factory</h4>
            <%=GetFactoryDetailedChartHtml()%>
            <br>
            <a href='Default.aspx?animate=0'>Back to Summary</a>
            <br>
            <br>
            <h5>
                <a href='../default.aspx'>« Back to list of examples</a></h5>
            <a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
        </center>
    </form>
</body>
</html>

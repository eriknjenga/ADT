<%@ Page Language="C#" AutoEventWireup="false" CodeFile="BasicDataXML.aspx.cs" Inherits="BasicDataXML" %>

<html>
<head>
    <title>FusionCharts - Simple Column 3D Chart using dataXML method </title>

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
                Basic example using dataXML method (with XML data hard-coded in ASP.NET page itself)</h4>
            <p>
                If you view the source of this page, you'll see that the XML data is present in
                this same page (inside HTML code). We're not calling any external XML (or script)
                files to serve XML data. dataXML method is ideal when you've to plot small amounts
                of data.</p>
            <%=GetMonthlySalesChartHtml()%>
            <br>
            <br>
            <h5>
                <a href='../default.aspx'>« Back to list of examples</a></h5>
            <a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
        </center>
    </form>
</body>
</html>

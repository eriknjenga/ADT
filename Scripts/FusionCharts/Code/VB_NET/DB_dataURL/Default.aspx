<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="DB_dataURL_Default" %>

<html>
<head>
    <title>FusionCharts - dataURL and Database Example </title>

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
                FusionCharts Database Example (Using dataURL method)</h2>
            <h4>
                Click on any pie slice to clice it out right click to enable rotation mode.</h4>
            <%=GetQuantityChartHtml()%>
            <br>
            <br>
            <h5>
                <a href='../default.aspx'>« Back to list of examples</a></h5>
            <a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
        </center>
    </form>
</body>
</html>

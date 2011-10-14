<%@LANGUAGE="VBSCRIPT"%>
<% option explicit %>
<%
'We've included ../Includes/FusionCharts_Gen.asp, which contains FusionCharts ASP Class
'to help us easily embed the charts.
%>
<!--#include file="../Includes/FusionCharts_Gen.asp"-->
<HTML>
<HEAD>
	<TITLE>
	FusionCharts V3 - Form Based Data Charting Example
	</TITLE>
	<%
	'You need to include the following JS file, if you intend to embed the chart using JavaScript.
	'Embedding using JavaScripts avoids the "Click to Activate..." issue in Internet Explorer
	'When you make your own charts, make sure that the path to this JS file is correct. Else, you would get JavaScript errors.
	%>	
	<SCRIPT LANGUAGE="Javascript" SRC="../../FusionCharts/FusionCharts.js"></SCRIPT>
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
</HEAD>
<BODY>

<CENTER>
<h2><a href="http://www.fusioncharts.com" target="_blank">FusionCharts V3</a> Form-Based Data Example</h2>
<h4>Restaurant Sales Chart below</h4>
<%
	'We first request the data from the form (Default.asp)
	dim intSoups, intSalads, intSandwiches,	intBeverages, intDesserts
	intSoups = Request("Soups")
	intSalads = Request("Salads")
	intSandwiches = Request("Sandwiches")
	intBeverages = Request("Beverages")
	intDesserts = Request("Desserts")
	
	'In this example, we're directly showing this data back on chart.
	'In your apps, you can do the required processing and then show the 
	'relevant data only.
	
	'Now that we've the data in variables, we need to convert this into chart data using
	'FusionCharts ASP Class
		
 	dim FC
	' Create FusionCharts ASP class object
	set FC = new FusionCharts
	' Set chart type to pie 3D
	Call FC.setChartType("Pie3D")
	' Set chart size 
	Call FC.setSize("600","300")
	
	' Set Relative Path of swf file. 
 	Call FC.setSWFPath("../../FusionCharts/")
	
	dim strParam
	' Define chart attributes
	strParam="caption=Sales by Product Category;subCaption=For this week;showPercentValues=1;  showPercentageInLabel=1;pieSliceDepth=25;showBorder=1;showLabels=1"

 	' Set chart attributes
 	Call FC.setChartParams(strParam)
	
	' Add chart data from form Field
	Call FC.addChartData(intSoups,"Label=Soups","")
	Call FC.addChartData(intSalads,"Label=Salads","")
	Call FC.addChartData(intSandwiches,"Label=Sandwitches","")
	Call FC.addChartData(intBeverages,"Label=Beverages","")
	Call FC.addChartData(intDesserts,"Label=Desserts","")
	
	'Create the chart 
 	Call FC.renderChart(false)
%>
<a href='Default.asp'>Enter data again</a>
<BR><BR>
<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
<H5 ><a href='../default.htm'>&laquo; Back to list of examples</a></h5>
</CENTER>
</BODY>
</HTML>
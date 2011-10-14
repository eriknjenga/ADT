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
	FusionCharts V3 - Simple Column 3D Chart 
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
	-->
	</style>
</HEAD>


<BODY>

<CENTER>
<h2><a href="http://www.fusioncharts.com" target="_blank">FusionCharts V3</a> Examples</h2>
<h4>Simple Column 3D Chart</h4>
<p>&nbsp;</p>
<%
	'This page demonstrates the ease of generating charts using FusionCharts ASPClass.
	'For this chart, we've cread a chart  object used FusionCharts ASP Class
	'supply chart data and configurations to it and render chart using the instance
	
	'Here, we've kept this example very simple.
	
	dim FC
	' Create FusionCharts ASP class object
 	set FC = new FusionCharts
	' Set chart type to Column 3D
	call FC.setChartType("Column3D")
	' Set chart size 
	call FC.setSize("600","300")
	
	' Set Relative Path of swf file.
 	Call FC.setSWFPath("../../FusionCharts/")
		
	dim strParam
	' Define chart attributes
	strParam="caption=Monthly Unit Sales;xAxisName=Month;yAxisName=Units"

 	' Set Chart attributes
 	Call FC.setChartParams(strParam)
	
	' Add chart data values and category names
	Call FC.addChartData("462","label=Jan","")
	Call FC.addChartData("857","label=Feb","")
	Call FC.addChartData("671","label=Mar","")
	Call FC.addChartData("494","label=Apr","")
	Call FC.addChartData("761","label=May","")
	Call FC.addChartData("960","label=Jun","")
	Call FC.addChartData("629","label=Jul","")
	Call FC.addChartData("622","label=Aug","")
	Call FC.addChartData("376","label=Sep","")
	Call FC.addChartData("494","label=Oct","")
	Call FC.addChartData("761","label=Nov","")
	Call FC.addChartData("960","label=Dec","")
	
	' Render Chart with JS Embedded Method
 	Call FC.renderChart(false)

%>
<BR><BR>
<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
<H5 ><a href='../default.htm'>&laquo; Back to list of examples</a></h5>
</CENTER>
</BODY>
</HTML>
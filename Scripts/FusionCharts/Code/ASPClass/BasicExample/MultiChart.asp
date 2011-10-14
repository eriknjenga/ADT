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
	FusionCharts V3 - Multiple Charts on one Page
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
<h4>Multiple Charts on the same page</h4>
<%
	
	'This page demonstrates how you can show multiple charts on the same page.
	'For this example, We have created 2 instances of the FusionCharts ASP Class
	'supplied data to both and rendered them
	

	'---------- Creating First Chart ----------------------------------------------
	 
	 dim FC
	 ' Create FusionCharts ASP class object
	 set FC = new FusionCharts
	 ' Set chart type to Column 3D
	 call FC.setChartType("Column3D")
	 ' Set chart size 
	 call FC.setSize("300","250")
		 
	 
	 ' set the relative path of the swf file
	 Call FC.setSWFPath("../../FusionCharts/")
	 
	 ' Set chart attributes
	 dim strParam
	 ' Define chart attributes
	 strParam="caption=Weekly Sales;subcaption=Revenue;xAxisName=Week;yAxisName=Revenue;numberPrefix=$"
	 ' Set Chart attributes
	 Call FC.setChartParams(strParam)
	 
	 ' add chart values and category names for the First Chart
	 Call FC.addChartData("40800","name=Week 1","")
	 Call FC.addChartData("31400","name=Week 2","")
	 Call FC.addChartData("26700","name=Week 3","")
	 Call FC.addChartData("54400","name=Week 4","")
	''------------------------------------------------------------------- 
	
	''----- Creating Second Chart ---------------------------------------
	 
	 dim FC2
	 ' Create another FusionCharts ASP class object
	 set FC2 = new FusionCharts
	 ' Set chart type to Column 3D
	 call FC2.setChartType("Column3D")
	 ' Set chart size 
	 call FC2.setSize("300","250")
	 	  
	 ' set the relative path of the swf file
	 Call FC2.setSWFPath("../../FusionCharts/")
	 
	 ' Define chart attributes
	 strParam="caption=Weekly Sales;subcaption=Quantity;xAxisName=Week;yAxisName=Quantity"
	
	 ' Set Chart attributes
	 Call FC2.setChartParams(strParam)
	 
	 ' Add chart values and  category names for the second chart
	 Call FC2.addChartData("32","name=Week 1","")
	 Call FC2.addChartData("35","name=Week 2","")
	 Call FC2.addChartData("26","name=Week 3","")
	 Call FC2.addChartData("44","name=Week 4","")
	 
	 ' Set Chart Caching Off for to Fix Caching error in FireFox
	 Call FC2.setOffChartCaching(true)  
	 ''------------------------------------------------------------------------- 
	 ' Render First Chart
	 Call FC.renderChart(false)
	
	 ' Render Second Chart
	 Call FC2.renderChart(false)
 
%>

<BR><BR>
<a href='../NoChart.html' target="_blank">Unable to see the charts above?</a>
<H5 ><a href='../default.htm'>&laquo; Back to list of examples</a></h5>
</CENTER>
</BODY>
</HTML>
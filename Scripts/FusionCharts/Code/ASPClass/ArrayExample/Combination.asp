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
	FusionCharts V3 - Array Example using Combination Column 3D Line Chart
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
<h4>Plotting Combination chart from data contained in Array.</h4>
<%
	'In this example, using FusionCharts ASP Class
	'we plot a Combination chart from data contained in arrays.
	
	
	'' The arrays need to be of the following  structure :
	
		'1. Array to store Category Namesnames :
		
		'  A single dimensional array storing the category names
		
		'2. A 2 Dimensional Array to store data values 

		'	** Each row will store data for 1 dataset
		 
		' Column 1 will store : Dataset Series Name.
		' Column 2 will store : Dataset attributes like parentYAxis=s etc.
		'	 (as list separated by delimiter.)
		' Column 3 and rest will store : values of the dataset
		  
	''
		
	'Store Quarter Name
	dim arrDataCat(4)
	arrDataCat(0) = "Quarter 1"
	arrDataCat(1) = "Quarter 2"
	arrDataCat(2) = "Quarter 3"
	arrDataCat(3) = "Quarter 4"
	
	'Store Revenue Data
	dim arrData(2, 6)
	arrData(0,0) = "Revenue"
	arrData(0,1) = "showValues=0;"  ' Dataset Parameters
	arrData(0,2) = 576000
	arrData(0,3) = 448000
	arrData(0,4) = 956000
	arrData(0,5) = 734000	
	
	'Store Quantity Data
	arrData(1,0) = "Quantity"
	arrData(1,1) = "parentYAxis=S" ' Dataset Parameters
	arrData(1,2) = 576
	arrData(1,3) = 448
	arrData(1,4) = 956
	arrData(1,5) = 734

	dim FC
	' Create FusionCharts ASP class object
 	set FC = new FusionCharts
	' Set chart type to MSColumn3DLineDY
	call FC.setChartType("MSColumn3DLineDY")
	' Set chart size 
	call FC.setSize("600","300")
	
	' Set Relative Path of swf file. 
 	call FC.setSWFPath("../../FusionCharts/")
	
	dim strParam
	' Define chart attributes
	strParam="caption=Product A - Sales Details;PYAxisName=Revenue;SYAxisName=Quantity (in Units);numberPrefix=$;sNumberSuffix= unit"

 	' Set chart attributes
 	call FC.setChartParams(strParam)
	
	' Pass the 2 arrays storing data and category names to 
	' FusionCharts ASP Class function addChartDataFromArray
	call FC.addChartDataFromArray(arrData, arrDataCat)

	' Render Second Chart with JS Embedded Method
 	call FC.renderChart(false)
	
%>
<BR><BR>
<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
<H5 ><a href='../default.htm'>&laquo; Back to list of examples</a></h5>
</CENTER>
</BODY>
</HTML>
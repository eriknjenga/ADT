<%@LANGUAGE="VBSCRIPT"%>
<% option explicit %>
<%
 'We've included ../../Includes/FusionCharts_Gen.asp - FusionCharts ASP Class
 'to help us easily embed the charts.

%>
<!--#include file="../../Includes/FusionCharts_Gen.asp"-->
<%
	
	'This page demonstrates the ease of generating charts using FusionCharts ASPClass.
	'We creata a FusionCharts object instance
	'Set chart values and configurations and retunns the XML using getXML() funciton
	'and write it to the response stream to build the XML
	
	'Here, we've kept this example very simple.
	
 	dim FC
	' Create FusionCharts ASP class object
	set FC = new FusionCharts
	' Set chart type to column 3d
	call FC.setChartType("column3D")
		
	dim strParam
	' Define chart attributes
	strParam="caption=Monthly Unit Sales;xAxisName=Month;yAxisName=Units;decimals=0; formatNumberScale=0;showLabels=1"
 	
	' Set chart attributes
 	call FC.setChartParams(strParam)
	
	' Add chart data values and category names
	call FC.addChartData("462","name=Jan","")
	call FC.addChartData("857","name=Feb","")
	call FC.addChartData("671","name=Mar","")
	call FC.addChartData("494","name=Apr","")
	call FC.addChartData("761","name=May","")
	call FC.addChartData("960","name=Jun","")
	call FC.addChartData("629","name=Jul","")
	call FC.addChartData("622","name=Aug","")
	call FC.addChartData("376","name=Sep","")
	call FC.addChartData("494","name=Oct","")
	call FC.addChartData("761","name=Nov","")
	call FC.addChartData("960","name=Dec","")
	
    'set content type as XML
	Response.ContentType ="text/xml"
	'Return the chart XML for Column 3D Chart 
	Response.Write(FC.getXML())
%>

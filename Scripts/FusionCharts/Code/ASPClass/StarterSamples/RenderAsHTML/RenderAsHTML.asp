<%@LANGUAGE="VBSCRIPT"%>
<%
  ' Include FusionCharts ASP Class
%>  
<!--#include file="../Class/FusionCharts_Gen.asp"-->
<%
  
  dim FC
  ' Create FusionCharts ASP class object
  set FC = new FusionCharts
  ' Set chart type to Column3D
  Call FC.setChartType("column3D")
  ' Set chart size 
  Call FC.setSize("300","250")
      
  ' Set the relative path of the swf file
  Call FC.setSWFPath("../FusionCharts/")

  dim strParam
  ' Define chart attributes
  strParam="caption=Weekly Sales;xAxisName=Week;yAxisName=Revenue;numberPrefix=$"
 
  ' Set chart attributes
  Call FC.setChartParams(strParam)

  ' Add chart values and category names
  Call FC.addChartData("40800","label=Week 1","")
  Call FC.addChartData("31400","label=Week 2","")
  Call FC.addChartData("26700","label=Week 3","")
  Call FC.addChartData("54400","label=Week 4","")

%>
<html>
  <head>
    <title>Render as HTML Using FusionCharts ASP Class</title>
  </head>
  <body>

  <%
    ' Pass true to renderChart() function
	' to use HTML Embedding Method.
	' This is helpful if you wish not use FusionCharts.js
	' or when rendering the chart using AJAX
    Call FC.renderChart(true)
  %>

  </body>
</html>


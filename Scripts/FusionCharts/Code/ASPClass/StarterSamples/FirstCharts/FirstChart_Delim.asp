<%@LANGUAGE="VBSCRIPT"%>
<%
  ' Include FusionCharts ASP Class
%>  
<!--#include file="../Class/FusionCharts_Gen.asp"-->
<%
  
  dim FC
  ' Create FusionCharts ASP class object
  set FC = new FusionCharts
  ' Set chart type to Column2D
  Call FC.setChartType("column2D")
  ' Set chart size 
  Call FC.setSize("450","350")
    
  ' Set the relative path of the swf file
  Call FC.setSWFPath("../FusionCharts/")

  ' Set colon (:) as delimiter
  Call FC.setParamDelimiter(":")

  dim strParam
  ' Define chart attributes  
  strParam="caption=Weekly Sales:xAxisName=Week:yAxisName=Revenue:numberPrefix=$"
  
  ' Set chart attributes  
  Call FC.setChartParams(strParam)

  ' Add chart values and category names
  Call FC.addChartData("40800","label=Week 1:alpha=80","")
  Call FC.addChartData("31400","label=Week 2:alpha=60","")
  Call FC.addChartData("26700","label=Week 3","")
  Call FC.addChartData("54400","label=Week 4","")
  
  ' Set hash (#) as delimiter
  Call FC.setParamDelimiter("#")
  
  ' Add First TrendLine
  Call FC.addTrendLine("startValue=42000#color=ff0000#displayvalue=Target#showOnTop=1")
  
  ' Set semicolon (;) as delimiter
  Call FC.setParamDelimiter(";")
  
  ' Add Second TrendLine
  Call FC.addTrendLine("startValue=30000;color=008800;displayvalue=Average;showOnTop=1")
    
%>
<html>
  <head>
    <title>First Chart - Set Delimiter : Using FusionCharts ASP Class</title>
    <script language='javascript' src='../FusionCharts/FusionCharts.js'></script>
  </head>
  <body>

  <%
    ' Render Chart with JS Embedded Method
    Call FC.renderChart(false)
  %>

  </body>
</html>


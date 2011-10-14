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
  Call FC.setSize("300","250")
      
  ' set the relative path of the swf file
  call FC.setSWFPath("../FusionCharts/")

  dim strParam
  ' Define chart attributes
  strParam="caption=Weekly Sales;xAxisName=Week;yAxisName=Revenue;numberPrefix=$"
  ' Set chart attributes   
  call FC.setChartParams(strParam)

  ' Add chart values and category names
  call FC.addChartData("40800","label=Week 1","")
  call FC.addChartData("31400","label=Week 2","")
  call FC.addChartData("26700","label=Week 3","")
  call FC.addChartData("54400","label=Week 4","")

  ' Add Simple First TrendLine
  call FC.addTrendLine("startValue=42000;color=ff0000")
  ' Add Second TrendLine
  call FC.addTrendLine("startValue=30000;color=008800;displayvalue=Average;showOnTop=1")
  ' Add Third TrendLine
  call FC.addTrendLine( "startValue=50000;endValue=60000;color=0000ff;alpha=20;displayvalue=Dream Sales;showOnTop=1;isTrendZone=1")
  
%>
<html>
  <head>
    <title>First Chart - Advanced - Add Trendlines : Using FusionCharts ASP Class</title>
    <script language='javascript' src='../FusionCharts/FusionCharts.js'></script>
  </head>
  <body>

  <%
    ' Render Chart with JS Embedded Method
    call FC.renderChart(false)
  %>

  </body>
</html>


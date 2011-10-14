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
    
  ' set the relative path of the swf file
  Call FC.setSWFPath("../FusionCharts/")

  dim strParam
  ' Define chart attributes
  strParam="caption=Weekly Sales;xAxisName=Week;yAxisName=Revenue;numberPrefix=$;decimals=0;formatNumberScale=0"
  
  ' Set chart attributes  
  Call FC.setChartParams(strParam)

  ' Add chart values and category names
  Call FC.addChartData("40800","label=Week 1;alpha=40;showLabel=0;showValue=0","")
  Call FC.addChartData("31400","label=Week 2;alpha=40;showLabel=0;showValue=0","")
  Call FC.addChartData("26700","label=Week 3;hoverText=Lowest;link=tooLow.asp","")
  Call FC.addChartData("54400","label=Week 4;showLabel=0;showValue=0; alpha=40;toolText=Highest","")

%>
<html>
  <head>
    <title>First Chart - Advanded - Set Other Elements : Using FusionCharts ASP Class</title>
    <script language='javascript' src='../FusionCharts/FusionCharts.js'></script>
  </head>
  <body>

  <%
    ' Render Chart with JS Embedded Method
    Call FC.renderChart(false)
  %>

  </body>
</html>


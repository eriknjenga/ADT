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
  
  ' Add First Vline 
  call FC.addChartData("","","color=FF0000")
  ' Add chart values  
  call FC.addChartData("31400","label=Week 2","")
  call FC.addChartData("26700","label=Week 3","")
  
  ' Add Second Vline 
  call FC.addChartData("","","color=00FF00")
  ' Add chart value  
  call FC.addChartData("54400","label=Week 4","")

 
%>
<html>
  <head>
    <title>First Chart -Advanded Add Vlines - Single Series : Using FusionCharts ASP Class</title>
    <script language='javascript' src='../FusionCharts/FusionCharts.js'></script>
  </head>
  <body>

  <%
    ' Render Chart with JS Embedded Method
    call FC.renderChart(false)
  %>

  </body>
</html>


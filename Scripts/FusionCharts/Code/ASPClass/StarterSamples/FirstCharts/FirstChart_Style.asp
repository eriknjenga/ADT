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

  ' Define first Style 
  call FC.defineStyle("MyFirstFontStyle","font","font=Verdana;size=12;color=FF0000; bgColor=FFFFDD;borderColor=666666")
  ' Define second Style 
  call FC.defineStyle("MyFirstGlow","Glow","color=FF5904;alpha=75")
  
  ' Apply Style on CAPTION
  call FC.applyStyle("CAPTION","MyFirstFontStyle")
  ' Apply Style on XAXISNAME
  call FC.applyStyle("XAXISNAME","MyFirstGlow,MyFirstFontStyle")
  ' Apply Style on YAXISNAME 
  call FC.applyStyle("YAXISNAME","MyFirstGlow")
  
%>
<html>
  <head>
    <title>First Chart - Advanced - Set Style : Using FusionCharts ASP Class</title>
    <script language='javascript' src='../FusionCharts/FusionCharts.js'></script>
  </head>
  <body>

  <%
    ' Render Chart with JS Embedded Method
    call FC.renderChart(false)
  %>

  </body>
</html>


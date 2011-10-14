<%@LANGUAGE="VBSCRIPT"%>
<%
  ' Include FusionCharts ASP Class
%>  
<!--#include file="../Class/FusionCharts_Gen.asp"-->
<%
  '---------- Configuring First Chart ----------
  dim FC
  ' Create First FusionCharts ASP class object
  set FC = new FusionCharts
  ' Set chart type to Column3D
  Call FC.setChartType("Column3D")
  ' Set chart size
  Call FC.setSize("300","250")
  
  ' set the relative path of the swf file
  Call FC.setSWFPath("../FusionCharts/")

  dim strParam
  ' Define chart attributes
  strParam="caption=Weekly Sales;subcaption=Revenue;xAxisName=Week;yAxisName=Revenue;numberPrefix=$"

  ' Set chart attributes
  Call FC.setChartParams(strParam)

  ' Add chart values and category names for the First Chart
  Call FC.addChartData("40800","Label=Week 1", "")
  Call FC.addChartData("31400","Label=Week 2", "")
  Call FC.addChartData("26700","Label=Week 3", "")
  Call FC.addChartData("54400","Label=Week 4", "")
  
  '--------------------------------------------------------- 

  '---------- Configuring Second Chart ----------
  
  dim FC2
  ' Create another FusionCharts ASP class object
  set FC2 = new FusionCharts
  ' Set chart type to another Column3D
  Call FC2.setChartType("Column3D")
  ' Set chart size
  Call FC2.setSize("300","250")
  
  ' set the relative path of the swf file
  Call FC2.setSWFPath("../FusionCharts/")
  
  ' Define chart attributes
  strParam="caption=Weekly Sales;subcaption=Quantity;xAxisName=Week;yAxisName=Quantity;numberSuffix= U"

  ' Set chart attributes
  Call FC2.setChartParams(strParam)

  ' Add chart values and category names for the second chart
  Call FC2.addChartData("32","Label=Week 1", "")
  Call FC2.addChartData("35","Label=Week 2", "")
  Call FC2.addChartData("26","Label=Week 3", "")
  Call FC2.addChartData("44","Label=Week 4", "")
  
  ' Set Chart Caching Off for to Fix Caching error in FireFox
  Call FC2.setOffChartCaching(true)
  
  '//--------------------------------------------------------

%>
<html>
  <head>
    <title>Multiple Charts Using FusionCharts ASP Class</title>
    <script language='javascript' src='../FusionCharts/FusionCharts.js'></script>
  </head>
  <body>

    <%
      ' Render First Chart with JS Embedded Method
      Call FC.renderChart(false)

      ' Render Second Chart with JS Embedded Method
      Call FC2.renderChart(false)

    %>

  </body>
</html>

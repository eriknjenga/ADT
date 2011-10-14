<%@LANGUAGE="VBSCRIPT"%>
<%
  ' Include FusionCharts ASP Class
%>  
<!--#include file="../Class/FusionCharts_Gen.asp"-->
<%
  
  dim FC
  ' Create FusionCharts ASP class object
  set FC = new FusionCharts
  ' Set chart type to Stacked Column2D chart
  Call FC.setChartType("StackedColumn3D")

  ' Set chart size
  Call FC.setSize("350","300")
  
  ' Set the relative path of the swf file
  Call FC.setSWFPath("../FusionCharts/")

  dim strParam
  ' Define chart attributes
  strParam="caption=Weekly Sales;subcaption=Comparison;xAxisName=Week;yAxisName=Revenue;numberPrefix=$"

  ' Set chart attributes 
  Call FC.setChartParams(strParam)

  ' Add category names
  Call FC.addCategory("Week 1", "", "")
  Call FC.addCategory("Week 2", "", "")
  Call FC.addCategory("Week 3", "", "")
  Call FC.addCategory("Week 4", "", "")

  ' Create a new dataset 
  Call FC.addDataset("This Month", "")
  ' Add chart values for the above dataset
  Call FC.addChartData("40800", "", "")
  Call FC.addChartData("31400", "", "")
  Call FC.addChartData("26700", "", "")
  Call FC.addChartData("54400", "", "")

  ' Create second dataset 
  Call FC.addDataset("Previous Month", "")
  ' Add chart values for the second dataset
  Call FC.addChartData("38300", "", "")
  Call FC.addChartData("28400", "", "")
  Call FC.addChartData("15700", "", "")
  Call FC.addChartData("48100", "", "")

%>

<html>
  <head>
    <title>Stacked Chart : Using FusionCharts ASP Class</title>
    <script language='javascript' src='../FusionCharts/FusionCharts.js'></script>
  </head>
  <body>

    <%
      ' Render Chart with JS Embedded Method
      Call FC.renderChart(false)
    %>


</body>
</html>

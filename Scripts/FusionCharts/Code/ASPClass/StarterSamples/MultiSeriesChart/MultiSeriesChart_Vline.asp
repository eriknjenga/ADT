<%@LANGUAGE="VBSCRIPT"%>
<%
  ' Include FusionCharts ASP Class
%>  
<!--#include file="../Class/FusionCharts_Gen.asp"-->
<%
  
  dim FC
  ' Create FusionCharts ASP class object
  set FC = new FusionCharts
  ' Set chart type to Multiseries Column2D chart
  Call FC.setChartType("MSColumn2D")
  ' Set chart size
  Call FC.setSize("450","350")
 
  ' Set the relative path of the swf file
  call FC.setSWFPath("../FusionCharts/")

  dim strParam
  ' Define chart attributes
  strParam="caption=Weekly Sales;subcaption=Comparison;xAxisName=Week;yAxisName=Revenue;numberPrefix=$"

  ' Set chart attributes 
  call FC.setChartParams(strParam)

  ' Add category names
  call FC.addCategory("Week 1", "", "")
  ' Add Vline
  call FC.addCategory("", "", "Color=FF0000")
  call FC.addCategory("Week 2", "", "")
  call FC.addCategory("Week 3", "", "")
  call FC.addCategory("Week 4", "", "")

  ' Create a new dataset 
  call FC.addDataset("This Month", "")
  ' Add chart values for the above dataset
  call FC.addChartData("40800", "", "")
  call FC.addChartData("31400", "", "")
  call FC.addChartData("26700", "", "")
  call FC.addChartData("54400", "", "")

  ' Create second dataset 
  call FC.addDataset("Previous Month", "")
  ' Add chart values for the second dataset
  call FC.addChartData("38300", "", "")
  call FC.addChartData("28400", "", "")
  call FC.addChartData("15700", "", "")
  call FC.addChartData("48100", "", "")

%>

<html>
  <head>
    <title>Multi-Series Chart - Add Vline -  Using FusionCharts ASP Class</title>
    <script language='javascript' src='../FusionCharts/FusionCharts.js'></script>
  </head>
  <body>

    <%
      ' Render Chart with JS Embedded Method
      call FC.renderChart(false)
    %>


</body>
</html>

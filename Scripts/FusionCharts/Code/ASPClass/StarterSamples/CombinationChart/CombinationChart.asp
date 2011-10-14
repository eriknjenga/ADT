<%@LANGUAGE="VBSCRIPT"%>
<%
  ' Include FusionCharts ASP Class
%>  
<!--#include file="../Class/FusionCharts_Gen.asp"-->
<%
   
   dim FC
   ' Create FusionCharts ASP class object
   set FC = new FusionCharts
   ' Set chart type to Column 3D + Line Dual Y-Axis Combination Chart
   Call FC.setChartType("MSColumn3DLineDY")
   ' Set chart size
   Call FC.setSize("450","350")
  
   ' Set the relative path of the swf file
   Call FC.setSWFPath("../FusionCharts/")

   dim strParam
   ' Define chart attributes
   strParam="caption=Weekly Sales;subcaption=Comparison;xAxisName=Week;pYAxisName=Revenue;sYAxisName=Total Quantity;numberPrefix=$;sNumberSuffix= U"

   ' Set chart attributes
   Call FC.setChartParams(strParam)

   ' Add category names
   Call FC.addCategory("Week 1", "", "")
   Call FC.addCategory("Week 2", "", "")
   Call FC.addCategory("Week 3", "", "")
   Call FC.addCategory("Week 4", "", "")

   ' Add a new dataset with dataset parameters 
   Call FC.addDataset("This Month","showValues=0")
   ' Add chart data for the above dataset
   Call FC.addChartData("40800", "", "")
   Call FC.addChartData("31400", "", "")
   Call FC.addChartData("26700", "", "")
   Call FC.addChartData("54400", "", "")

   ' Add another dataset with dataset parameters 
   Call FC.addDataset("Previous Month","showValues=0")
   ' Add chart data for the second dataset
   Call FC.addChartData("38300", "", "")
   Call FC.addChartData("28400", "", "")
   Call FC.addChartData("15700", "", "")
   Call FC.addChartData("48100", "", "")

   ' Add third dataset for the secondary axis
   Call FC.addDataset("Total Quantity","parentYAxis=S")
   ' Add secondary axix's data values
   Call FC.addChartData("64", "", "")
   Call FC.addChartData("70", "", "")
   Call FC.addChartData("52", "", "")
   Call FC.addChartData("81", "", "")

%>


<html>
   <head>
      <title>Column 3D + Line Dual Y-Axis Combination Chart Using FusionCharts ASP Class</title>
      <script language='javascript' src='../FusionCharts/FusionCharts.js'></script>
   </head>
   <body>

      <%
         ' Render Chart with JS Embedded Method
         Call FC.renderChart(false)
      %>

   </body>
</html>


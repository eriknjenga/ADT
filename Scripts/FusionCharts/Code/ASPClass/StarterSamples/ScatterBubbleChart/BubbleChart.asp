<%@LANGUAGE="VBSCRIPT"%>
<%
  ' Include FusionCharts ASP Class
%>  
<!--#include file="../Class/FusionCharts_Gen.asp"-->
<%
  
  dim FC
  ' Create FusionCharts ASP class object
  set FC = new FusionCharts
  ' Set chart type to Bubble Chart
  Call FC.setChartType("bubble")
  ' Set chart size
  Call FC.setSize("450","350")

    
  ' set the relative path of the swf file
  Call FC.setSWFPath("../FusionCharts/")

  dim strParam
  ' Define chart attributes
  strParam="caption=Monthly Sales;xAxisName=Number of Products;yAxisName=Revenue;numberPrefix=$"
  
  ' Set chart attributes
  Call FC.setChartParams(strParam)
  
  ' Add Category, 1st parameter take label and 2nd parameter takes x axis value 
  ' as parameter list 
  Call FC.addCategory("0","x=0;showVerticalLine=1","")
  Call FC.addCategory("20","x=20;showVerticalLine=1","")
  Call FC.addCategory("40","x=40;showVerticalLine=1","")
  Call FC.addCategory("60","x=60;showVerticalLine=1","")
  Call FC.addCategory("80","x=80;showVerticalLine=1","")
  Call FC.addCategory("100","x=100;showVerticalLine=1","")
  
  ' Add a new dataset
  Call FC.addDataSet("Previous Month","")
  ' Add chart data for the above dataset
  ' where 1st parameter for X axis value
  ' 2nd parameter take Y and Z axis as parameter list
  ' e.g y=12200;z=10
  Call FC.addChartData("20","y=72000;z=8","")
  Call FC.addChartData("43","y=42000;z=5","")
  Call FC.addChartData("70","y=90000;z=2","")
  Call FC.addChartData("90","y=75000;z=4","")
  
  ' Add another dataset
  Call FC.addDataSet("Current Month","")
  ' Add chart data for the above dataset
  ' where 1st parameter for X axis value
  ' 2nd parameter take Y and Z axis as parameter list
  ' e.g y=60000;z=20
  Call FC.addChartData("18","y=22000;z=3","")
  Call FC.addChartData("35","y=62000;z=5","")
  Call FC.addChartData("50","y=55000;z=10","")
  Call FC.addChartData("70","y=25000;z=3","")
  

%>
<html>
  <head>
    <title>Bubble Chart : Using FusionCharts ASP Class</title>
    <script language='javascript' src='../FusionCharts/FusionCharts.js'></script>
  </head>
  <body>

  <%
    ' Render Chart with JS Embedded Method
    Call FC.renderChart(false)
  %>

  </body>
</html>


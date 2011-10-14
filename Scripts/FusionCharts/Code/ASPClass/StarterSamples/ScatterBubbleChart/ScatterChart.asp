<%@LANGUAGE="VBSCRIPT"%>
<%
  ' Include FusionCharts ASP Class
%>  
<!--#include file="../Class/FusionCharts_Gen.asp"-->
<%
  
  dim FC
  ' Create FusionCharts ASP class object
  set FC = new FusionCharts
  ' Set chart type to Scatter Chart
  Call FC.setChartType("Scatter")
  ' Set chart size
  Call FC.setSize("300","250")
      
  ' set the relative path of the swf file
  Call FC.setSWFPath("../FusionCharts/")

  dim strParam
  ' Define chart attributes
  strParam="caption=Server Performance;yAxisName=Response Time (sec);xAxisName=Server Load (TPS)"
  
  ' Set chart attributes
  Call FC.setChartParams(strParam)
  
  ' Add Category, 1st parameter take label and 2nd parameter takes x axis value 
  ' as parameter list  
  Call FC.addCategory("10","x=10;showVerticalLine=1","")
  Call FC.addCategory("20","x=20;showVerticalLine=1","")
  Call FC.addCategory("30","x=30;showVerticalLine=1","")
  Call FC.addCategory("40","x=40;showVerticalLine=1","")
  Call FC.addCategory("50","x=50","")
  
  ' Add a new dataset 
  Call FC.addDataSet("Server 1","anchorRadius=6")
  ' Add chart data for the above dataset
  ' where 1st parameter for X axis value
  ' 2nd parameter take Y axis as parameter list
  ' e.g y=27
  Call FC.addChartData("21","y=2.4","")
  Call FC.addChartData("32","y=3.5","")
  Call FC.addChartData("43","y=2.5","")
  Call FC.addChartData("48","y=4.1","")
  
  ' Add another dataset
  Call FC.addDataSet("Server 2","anchorRadius=6")
  ' Add chart data for the above dataset
  ' where 1st parameter for X axis value
  ' 2nd parameter take Y axis as parameter list
  ' e.g y=30
  Call FC.addChartData("23","y=1.4","")
  Call FC.addChartData("29","y=1.5","")
  Call FC.addChartData("33","y=1.5","")
  Call FC.addChartData("41","y=1.1","")
  
  
%>
<html>
  <head>
    <title>Scatter Chart : FusionCharts ASP Class</title>
    <script language='javascript' src='../FusionCharts/FusionCharts.js'></script>
  </head>
  <body>

  <%
    ' Render Chart with JS Embedded Method
    Call FC.renderChart(false)
  %>

  </body>
</html>


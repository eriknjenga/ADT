<%@LANGUAGE="VBSCRIPT"%>
<%
  ' Include FusionCharts ASP Class
%>  
<!--#include file="../Class/FusionCharts_Gen.asp"-->
<%
  
  dim FC
  ' Create FusionCharts ASP class object
  set FC = new FusionCharts
  ' Set chart type to Multiseries Stacked Column2D Line DY
  Call FC.setChartType("MSStackedColumn2DLineDY")
  ' Set chart size
  Call FC.setSize("450","350")
 
  ' Set the relative path of the swf file
  Call FC.setSWFPath("../FusionCharts/")

  dim strParam
  ' Define chart attributes
  strParam="caption=Annual Revenue;rotateValues =1;xAxisName=Year;PYAxisName=Revenue;SYAXisName=Cost as %25 of Revenue;numberPrefix=$;numberSuffix=M;sNumberSuffix=%25;SYAxisMinValue=0;SYAxisMaxValue=100;showValues=0;useroundedges=1;showSum=1"

  ' Set chart attributes 
  Call FC.setChartParams(strParam)

  ' Add category names
  Call FC.addCategory("2001","","")
  Call FC.addCategory("2002","","")
  Call FC.addCategory("2003","","")
  Call FC.addCategory("2004","","")
  Call FC.addCategory("2005","","")

  ' Add Multi-series Dataset
  Call FC.createMSStDataset()
	  ' Add Multi-series dataset with in dataset
	  Call FC.addMSStSubDataset("Product A", "")
		  ' Add set data for plotting the chart
		  Call FC.addChartData("30","","")
		  Call FC.addChartData("26","","")
		  Call FC.addChartData("29","","")
		  Call FC.addChartData("31","","")
		  Call FC.addChartData("34","","")
	  ' Add Next Multi-series dataset with in dataset
	  Call FC.addMSStSubDataset("Product B", "")
		  ' Add set data for plotting the chart
		  Call FC.addChartData("30","","")
		  Call FC.addChartData("26","","")
		  Call FC.addChartData("29","","")
		  Call FC.addChartData("31","","")
		  Call FC.addChartData("34","","")
 
  ' Add Multi-series  Dataset
  Call FC.createMSStDataset()
	  ' Add Multi-series dataset with in dataset
	  Call FC.addMSStSubDataset("Product C", "")
		  ' Add set data for plotting the chart
		  Call FC.addChartData("30","","")
		  Call FC.addChartData("26","","")
		  Call FC.addChartData("29","","")
		  Call FC.addChartData("31","","")
		  Call FC.addChartData("34","","")
 
  ' Add Multi-series lineset for showing lines
  Call FC.addMSLineset("Cost as %25 of Revenue","lineThickness=4")
	  ' Add set data with in lineset
	  Call FC.addMSLinesetData("57","","")
	  Call FC.addMSLinesetData("68","","")
	  Call FC.addMSLinesetData("79","","")
	  Call FC.addMSLinesetData("73","","")
	  Call FC.addMSLinesetData("80","","")

%>

<html>
  <head>
    <title>Multiseries Stacked Column2D Line DY Chart Using FusionCharts ASP Class</title>
    <script language='javascript' src='../FusionCharts/FusionCharts.js'></script>
  </head>
  <body>

    <%
      ' Render Chart with JS Embedded Method
      Call FC.renderChart(false)
    %>


</body>
</html>

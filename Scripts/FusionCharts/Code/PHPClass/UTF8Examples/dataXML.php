<?php
//We've included ../Includes/FusionCharts_Gen.php, which contains FusionCharts PHP Class
//to help us easily embed the charts.
include("../Includes/FusionCharts_Gen.php");
?>
<HTML>
<HEAD>
	<TITLE>
		FusionCharts - Simple Column 2D Chart - With Multilingual characters
	</TITLE>
	<?php
	//You need to include the following JS file, if you intend to embed the chart using JavaScript.
	//Embedding using JavaScripts avoids the "Click to Activate..." issue in Internet Explorer
	//When you make your own charts, make sure that the path to this JS file is correct. Else, you 
    //would get JavaScript errors.
	?>	
	<SCRIPT LANGUAGE="Javascript" SRC="../../FusionCharts/FusionCharts.js"></SCRIPT>
	<style type="text/css">
	<!--
	body {
		font-family: Arial, Helvetica, sans-serif;
		font-size: 12px;
	}
	-->
	</style>
</HEAD>
<BODY>

<CENTER>
<h2>FusionCharts Examples</h2>
<h4>Example using XML having multilingual text</h4>
<?php
	
	//This page demonstrates the ease of generating charts containing UTF-8 encoded 
	//multilingual text using FusionCharts PHPClass.
	//For this chart, we've cread a chart  object used FusionCharts PHP Class
	//supply chart data and configurations to it and render chart using the instance
	
	//Here, we've kept this example very simple.
	
	# Create column 2d chart object 
 	$FC = new FusionCharts("Column2D","500","400"); 

	# Set Relative Path of swf file.
 	$FC->setSWFPath("../../FusionCharts/");
		
	# Set Chart attributes
 	$FC->setChartParams("caption=Monthly Sales Summary;subcaption=For the year 2008;");
	$FC->setChartParams("xAxisName=Month;yAxisName=Sales;numberPrefix=$;showNames=1;");
	$FC->setChartParams("showValues=0;showColumnShadow=1;animation=1;");
	$FC->setChartParams("baseFontColor=666666;lineColor=FF5904;lineAlpha=85;");
	$FC->setChartParams("valuePadding=10;labelDisplay=rotate;useRoundEdges=1");
	
	#add chart data values and category names
	$FC->addChartData("17400","Label=januári");
	$FC->addChartData("19800","Label=Fevruários");
	$FC->addChartData("21800","Label=مارس");
	$FC->addChartData("23800","Label=أبريل");
	$FC->addChartData("29600","Label=五月");
	$FC->addChartData("27600","Label=六月");
	$FC->addChartData("31800","Label=תִּשׁרִי");
	$FC->addChartData("39700","Label=Marešwān");
	$FC->addChartData("37800","Label=settèmbre");
	$FC->addChartData("21900","Label=ottàgono");
	$FC->addChartData("32900","Label=novèmbre");
	$FC->addChartData("39800","Label=décembre");
	
	# apply style
	$FC->defineStyle("myCaptionFont","Font","size=12");
	$FC->applyStyle("DATALABELS","myCaptionFont");
	
	# Render  Chart 
 	$FC->renderChart();

	
?>
<BR><BR>
<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
</CENTER>
</BODY>
</HTML>
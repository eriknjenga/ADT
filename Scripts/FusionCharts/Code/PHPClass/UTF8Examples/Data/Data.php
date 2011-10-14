<?php
//We've included ../../Includes/FusionCharts_Gen.php - FusionCharts PHP Class
//to help us easily embed the charts.
include("../../Includes/FusionCharts_Gen.php");
?>

<?php
	
	//This page demonstrates the ease of generating charts containing UTF-8 encoded 
	//multilingual text using FusionCharts PHPClass.
	//We creata a FusionCharts object instance
	//Set chart values and configurations and retunns the XML using getXML() funciton
	//and write it to the response stream to build the XML
	
	//Here, we've kept this example very simple.
	
	# Create column 2d chart object 
 	$FC = new FusionCharts("Column2D","500","400"); 

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
	
	# define ad apply style
	$FC->defineStyle("myCaptionFont","Font","size=12");
	$FC->applyStyle("DATALABELS","myCaptionFont");
	
	//set content type as XML
	header('Content-type: text/xml');
	#Return the chart XML for Column 3D Chart 
	print $FC->getXML();
?>

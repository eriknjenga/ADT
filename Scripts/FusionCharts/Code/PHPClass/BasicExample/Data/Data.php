<?php
//We've included ../../Includes/FusionCharts_Gen.php - FusionCharts PHP Class
//to help us easily embed the charts.
include("../../Includes/FusionCharts_Gen.php");
?>

<?php
	
	//This page demonstrates the ease of generating charts using FusionCharts PHPClass.
	//We creata a FusionCharts object instance
	//Set chart values and configurations and retunns the XML using getXML() funciton
	//and write it to the response stream to build the XML
	
	//Here, we've kept this example very simple.
	
	# Create column 3d chart object 
 	$FC = new FusionCharts("column3D","600","300"); 

	# Set Relative Path of swf file.
 	$FC->setSWFPath("../../FusionCharts/");
		
	# Define chart attributes 
	$strParam="caption=Monthly Unit Sales;xAxisName=Month;yAxisName=Units;showLabels=1";
 	#  Set chart attributes
 	$FC->setChartParams($strParam);
	
	#add chart data values and category names
	$FC->addChartData("462","Label=Jan");
	$FC->addChartData("857","Label=Feb");
	$FC->addChartData("671","Label=Mar");
	$FC->addChartData("494","Label=Apr");
	$FC->addChartData("761","Label=May");
	$FC->addChartData("960","Label=Jun");
	$FC->addChartData("629","Label=Jul");
	$FC->addChartData("622","Label=Aug");
	$FC->addChartData("376","Label=Sep");
	$FC->addChartData("494","Label=Oct");
	$FC->addChartData("761","Label=Nov");
	$FC->addChartData("960","Label=Dec");
	
	//set content type as XML
	header('Content-type: text/xml');
	#Return the chart XML for Column 3D Chart 
	print $FC->getXML();
?>

<?php
	
	//This page builds XML from database. The database contains UTF-8 encoded multilingual text.
	//We have pre encoded this file as UTF-8 encoded with BOM
	//Hence, we would just retrieve the text and relay it to the chart
	
    //We've included  ../../Includes/DBConn.php, which contains functions
    //to help us easily connect to a database.
    include("../../Includes/DBConn.php");
    //We've included ../Includes/FusionCharts_Gen.php, which FusionCharts PHP Class
    //to help us easily embed the charts.
    include("../../Includes/FusionCharts_Gen.php");

    //For the sake of ease, we've used an MySQL databases - sales and all data in a table - 'monthly_utf8'
		
    //Connect to the Database
    $link = connectToDB('sales');

	# Create column 2d chart object 
 	$FC = new FusionCharts("Column2D","500","400"); 

	# Set Chart attributes
 	$FC->setChartParams("caption=Monthly Sales Summary;subcaption=For the year 2008;");
	$FC->setChartParams("xAxisName=Month;yAxisName=Sales;numberPrefix=$;showNames=1;");
	$FC->setChartParams("showValues=0;showColumnShadow=1;animation=1;");
	$FC->setChartParams("baseFontColor=666666;lineColor=FF5904;lineAlpha=85;");
	$FC->setChartParams("valuePadding=10;labelDisplay=rotate;useRoundEdges=1");
	
   //Connect to the DB
    $link = connectToDB('sales');
	
    // Fetch all factory records
    $strQuery = "select * from monthly_utf8";
    $result = mysql_query($strQuery) or die(mysql_error());
    
	//Pass the SQL Query result to the FusionCharts PHP Class function 
	//along with field/column names that are storing chart values and corresponding category names
	//to set chart data from database
	if ($result) {
		$FC->addDataFromDatabase($result, "amount", "month_name");
	}
	
    //free the resultset
    mysql_free_result($result);
	// close database
    mysql_close($link);
	
	# define and apply style
	$FC->defineStyle("myCaptionFont","Font","size=12");
	$FC->applyStyle("DATALABELS","myCaptionFont");
		
    //Set Proper output content-type
    header('Content-type: text/xml');
	
    //Just write out the XML data
    //NOTE THAT THIS PAGE DOESN'T CONTAIN ANY HTML TAG, WHATSOEVER
    print  $FC->getXML();
	
?>
<?php
	
	//This page builds XML from database. The database contains UTF-8 encoded multilingual text.
	//We have pre encoded this file as UTF-8 encoded with BOM
	//Hence, we would just retrieve the text and relay it to the chart
	
	//We've included  ../Includes/DBConn.php, which contains functions
    //to help us easily connect to a database.
    include("../../Includes/DBConn.php");

    //For the sake of ease, we've used an MySQL databases - sales and all data in a table - 'monthly_utf8'

    //$strXML will be used to store the entire XML document generated
    //Generate the chart element
	$strXML  = "<chart caption='Monthly Sales Summary' subcaption='For the year 2008' ";
	$strXML .= " xAxisName='Month' yAxisName='Sales' numberPrefix='$' showNames='1'";	
	$strXML .= " showValues='0' showColumnShadow='1' animation='1'";	
	$strXML .= " baseFontColor='666666' lineColor='FF5904' lineAlpha='85'";	
	$strXML .= " valuePadding='10' labelDisplay='Rotate' useRoundEdges='1' >";	

    //Connect to the DB
    $link = connectToDB('sales');
	
    // Fetch all factory records
    $strQuery = "select * from monthly_utf8";
    $result = mysql_query($strQuery) or die(mysql_error());
    
    //Iterate through each month
    if ($result) {
        while($ors = mysql_fetch_array($result)) {
            //Generate <set label='..' value='..'/>     
            $strXML .= "<set label='" . $ors['month_name'] . "' value='" . $ors['amount'] . "' />";
		}
    }
	
    //free the resultset
    mysql_free_result($result);
	// close database
    mysql_close($link);
	
	// add style
	$strXML .= "<styles><definition><style name='myCaptionFont' type='font' size='12'/></definition>";
	$strXML .= "<application><apply toObject='datalabels' styles='myCaptionFont' /></application></styles>";
    
	//Finally, close <chart> element
    $strXML .= "</chart>";


    //Set Proper output content-type
    header('Content-type: text/xml');
	
    //Just write out the XML data
    echo $strXML;
	
?>
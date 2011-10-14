<?php
    //We've included  ../Includes/DBConn.php, which contains functions
    //to help us easily connect to a database.
    include("../Includes/DBConn.php");

    //This page generates the XML data for the Pie Chart contained in
    //Default.php. 	
	
    //For the sake of ease, we've used an MySQL databases containing two
    //tables.. 
		
    //Connect to the DB
    $link = connectToDB();

    //Default.php has passed us a property animate. We request that.
    $animateChart = $_GET['animate'];

    //Set default value of 1
    if ($animateChart=="")
        $animateChart = "1";
	
    //$strXML will be used to store the entire XML document generated
    //Generate the chart element
    $strXML = "<chart caption='Factory Output report' subCaption='By Quantity' pieSliceDepth='30' showBorder='1' formatNumberScale='0' numberSuffix=' Units' animation=' " . $animateChart . "'>";
	
    // Fetch all factory records
    $strQuery = "select * from Factory_Master";
    $result = mysql_query($strQuery) or die(mysql_error());
    
    //Iterate through each factory
    if ($result) {
        while($ors = mysql_fetch_array($result)) {
            //Now create a second query to get details for this factory
            $strQuery = "select sum(Quantity) as TotOutput from Factory_Output where FactoryId=" . $ors['FactoryId'];
            $result2 = mysql_query($strQuery) or die(mysql_error()); 
            $ors2 = mysql_fetch_array($result2);
            //Generate <set label='..' value='..'/>     
            $strXML .= "<set label='" . $ors['FactoryName'] . "' value='" . $ors2['TotOutput'] . "' />";
            //free the resultset
            mysql_free_result($result2);
        }
    }
    mysql_close($link);

    //Finally, close <chart> element
    $strXML .= "</chart>";
		
    //Set Proper output content-type
    header('Content-type: text/xml');
	
    //Just write out the XML data
    //NOTE THAT THIS PAGE DOESN'T CONTAIN ANY HTML TAG, WHATSOEVER
    echo $strXML;
?>

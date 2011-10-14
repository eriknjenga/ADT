<?php
    include("../Includes/DBConn.php");

    //This page is invoked from Default.php. When the user clicks on a pie
    //slice in Default.php, the factory Id is passed to this page. We need
    //to get that factory id, get information from database and then write XML.
	
    //Request the factory Id from Querystring
    $FactoryId = $_GET['factoryId'];
	
    //$strXML will be used to store the entire XML document generated
    //Generate the chart element string
    $strXML = "<chart palette='2' caption='Factory " . $FactoryId ." Output ' subcaption='(In Units)' xAxisName='Date' showValues='1' labelStep='2' >";

    // Connect to the DB
    $link = connectToDB();

    //Now, we get the data for that factory
    $strQuery = "select * from Factory_Output where FactoryId=" . $FactoryId;
    $result = mysql_query($strQuery) or die(mysql_error());
    
    //Iterate through each factory
    if ($result) {
        while($ors = mysql_fetch_array($result)) {
            //Here, we convert date into a more readable form for set label.
            $strXML .= "<set label='" . datePart("d",$ors['DatePro']) . "/" . datePart("m",$ors['DatePro']) . "' value='" . $ors['Quantity'] . "'/>";
        }
    }
    mysql_close($link);

    //Close <chart> element
    $strXML .= "</chart>";
	
    //Just write out the XML data
    //NOTE THAT THIS PAGE DOESN'T CONTAIN ANY HTML TAG, WHATSOEVER
    echo $strXML;
?>
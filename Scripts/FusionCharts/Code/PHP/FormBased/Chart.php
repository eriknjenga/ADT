<?php
//We've included ../Includes/FusionCharts.php, which contains functions
//to help us easily embed the charts.
include("../Includes/FusionCharts.php");
?>
<HTML>
<HEAD>
	<TITLE>
	FusionCharts - Form Based Data Charting Example
	</TITLE>
	<?php
	//You need to include the following JS file, if you intend to embed the chart using JavaScript.
	//Embedding using JavaScripts avoids the "Click to Activate..." issue in Internet Explorer
	//When you make your own charts, make sure that the path to this JS file is correct. Else, you would get JavaScript errors.
	?>	
	<SCRIPT LANGUAGE="Javascript" SRC="../../FusionCharts/FusionCharts.js"></SCRIPT>
	<style type="text/css">
	<!--
	body {
		font-family: Arial, Helvetica, sans-serif;
		font-size: 12px;
	}
	.text{
		font-family: Arial, Helvetica, sans-serif;
		font-size: 12px;
	}
	-->
	</style>
</HEAD>
<BODY>

<CENTER>
<h2>FusionCharts Form-Based Data Example</h2>
<h4>Restaurant Sales Chart below</h4>
<p class='text'>Click on any pie slice to see slicing effect. Or, right click on chart and choose "Enable Rotation", and then drag and rotate the chart.</p>
<?php
	//We first request the data from the form (Default.php)
	$intSoups = $_POST['Soups'];
	$intSalads = $_POST['Salads'];
	$intSandwiches = $_POST['Sandwiches'];
	$intBeverages = $_POST['Beverages'];
	$intDesserts = $_POST['Desserts'];
	
	//In this example, we're directly showing this data back on chart.
	//In your apps, you can do the required processing and then show the 
	//relevant data only.
	
	//Now that we've the data in variables, we need to convert this into XML.
	//The simplest method to convert data into XML is using string concatenation.	
	//Initialize <chart> element
	$strXML = "<chart caption='Sales by Product Category' subCaption='For this week' showPercentValues='1' pieSliceDepth='30' showBorder='1'>";
	//Add all data
	$strXML .= "<set label='Soups' value='" . $intSoups . "' />";
	$strXML .= "<set label='Salads' value='" . $intSalads . "' />";
	$strXML .= "<set label='Sandwiches' value='" . $intSandwiches . "' />";
	$strXML .= "<set label='Beverages' value='" . $intBeverages . "' />";
	$strXML .= "<set label='Desserts' value='" . $intDesserts . "' />";
	//Close <chart> element
	$strXML .= "</chart>";
	
	//Create the chart - Pie 3D Chart with data from $strXML
	echo renderChart("../../FusionCharts/Pie3D.swf", "", $strXML, "Sales", 500, 300, false, false);
?>
<br><br>
<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
<br><br>
<a href='javascript:history.go(-1);'>Enter data again</a>
<BR>
<H5><a href='../default.htm'>&laquo; Back to list of examples</a></h5>
</CENTER>
</BODY>
</HTML>
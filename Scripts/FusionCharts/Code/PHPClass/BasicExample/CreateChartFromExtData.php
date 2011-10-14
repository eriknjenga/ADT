<?php
//We've included ../Includes/FusionCharts_Gen.php, which contains FusionCharts PHP Class
//to help us easily embed the charts.
include("../Includes/FusionCharts_Gen.php");
?>
<HTML>
<HEAD>
	<TITLE>
	FusionCharts V3 - Simple Column 3D Chart (with XML data hard-coded in PHP page itself)
	</TITLE>
	<style type="text/css">
	<!--
	body {
		font-family: Arial, Helvetica, sans-serif;
		font-size: 12px;
	}
	-->
	</style>
	<?php
	//You need to include the following JS file, if you intend to embed the chart using JavaScript.
	//Embedding using JavaScripts avoids the "Click to Activate..." issue in Internet Explorer
	//When you make your own charts, make sure that the path to this JS file is correct. Else, you would get JavaScript errors.
	?>	
	<SCRIPT LANGUAGE="Javascript" SRC="../../FusionCharts/FusionCharts.js"></SCRIPT>
</HEAD>
<BODY>

<CENTER>
<h2><a href="http://www.fusioncharts.com" target="_blank">FusionCharts V3</a> Examples</h2>
<h4>Simple Column 3D Chart (with XML data hard-coded in PHP page itself)</h4>
<?php
	
	//This page demonstrates the ease of generating charts using FusionCharts PHP Class.
	//For this chart, we've used a string variable to contain our entire XML data.
	
	//Ideally, you would generate XML data documents at run-time, after interfacing with
	//forms or databases etc.Such examples are also present.
	//Here, we've kept this example very simple.
	
	//Create an XML data document in a string variable
	$strXML = "<Chart caption='Monthly Unit Sales' xAxisName='Month' yAxisName='Units' >";
	$strXML .= "<set Label='Jan' value='462' />";
	$strXML .= "<set Label='Feb' value='857' />";
	$strXML .= "<set Label='Mar' value='671' />";
	$strXML .= "<set Label='Apr' value='494' />";
	$strXML .= "<set Label='May' value='761' />";
	$strXML .= "<set Label='Jun' value='960' />";
	$strXML .= "<set Label='Jul' value='629' />";
	$strXML .= "<set Label='Aug' value='622' />";
	$strXML .= "<set Label='Sep' value='376' />";
	$strXML .= "<set Label='Oct' value='494' />";
	$strXML .= "<set Label='Nov' value='761' />";
	$strXML .= "<set Label='Dec' value='960' />";
	$strXML .=  "</Chart>";

	
	# Create object of FusionCharts class of single series 
 	$FC = new FusionCharts("Column3D","600","300"); 

	# Set Relative Path of swf file. default path is “charts/”
 	$FC->setSWFPath("../../FusionCharts/");
	//Create the chart - Column 3D Chart with data from strXML 
	# Create the Chart 
 	$FC->renderChartFromExtXML($strXML);
?>
<BR><BR>
<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
<H5 ><a href='../default.htm'>&laquo; Back to list of examples</a></h5>
</CENTER>
</BODY>
</HTML>
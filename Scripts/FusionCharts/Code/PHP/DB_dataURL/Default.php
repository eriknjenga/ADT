<?php
//We've included ../Includes/FusionCharts.php, which contains functions
//to help us easily embed the charts.
include("../Includes/FusionCharts.php");
?>
<HTML>
<HEAD>
	<TITLE>
	FusionCharts - dataURL and Database  Example
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
<h2>FusionCharts dataURL and Database</h2>
<h4>Click on any pie slice to clice it out right click to enable rotation mode.</h4>
<?php
	//In this example, we show how to connect FusionCharts to a database 
	//using dataURL method. In our other examples, we've used dataXML method
	//where the XML is generated in the same page as chart. Here, the XML data
	//for the chart would be generated in PieData.php.

	//For the sake of ease, we've used an MySQL databases containing two
	//tables.
	
	//To illustrate how to pass additional data as querystring to dataURL, 
	//we've added an animate property, which will be passed to PieData.php. 
	//PieData.php would handle this animate property and then generate the 
	//XML accordingly.
	
	//Set DataURL with animation property to 1
	//NOTE: It's necessary to encode the dataURL if you've added parameters to it
	$strDataURL = encodeDataURL("PieData.php?animate=1");
	
	//Create the chart - Pie 3D Chart with dataURL as strDataURL
	echo renderChart("../../FusionCharts/Pie3D.swf", $strDataURL, "", "FactorySum", 600, 300, false, false);
?>
<BR><BR>
<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
<H5 ><a href='../default.htm'>&laquo; Back to list of examples</a></h5>
</CENTER>
</BODY>
</HTML>
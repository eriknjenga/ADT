<?php
//We've included ../Includes/FusionCharts.php, which contains functions
//to help us easily embed the charts.
include("../Includes/FusionCharts.php");
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
	
	//This page demonstrates the ease of generating charts using FusionCharts.
	//For this chart, we've used a XML 
	//containing UTF-8 encoded multilingual text
	
	//Create an XML data document in a string variable
	$strXML  = "<chart caption='Monthly Sales Summary' subcaption='For the year 2008' ";
	$strXML .= " xAxisName='Month' yAxisName='Sales' numberPrefix='$' showNames='1'";	
	$strXML .= " showValues='0' showColumnShadow='1' animation='1'";	
	$strXML .= " baseFontColor='666666' lineColor='FF5904' lineAlpha='85'";	
	$strXML .= " valuePadding='10' labelDisplay='rotate' useRoundEdges='1'>";	
	$strXML .= "<set label='januári' value='17400' />";	
	$strXML .= "<set label='Fevruários' value='19800' />";	
	$strXML .= "<set label='مارس' value='21800' />";	
	$strXML .= "<set label='أبريل' value='23800' />";	
	$strXML .= "<set label='五月' value='29600' />";	
	$strXML .= "<set label='六月' value='27600' />";	
	$strXML .= "<set label='תִּשׁרִי' value='31800' />";	
	$strXML .= "<set label='Marešwān' value='39700' />";	
	$strXML .= "<set label='settèmbre' value='37800' />";	
	$strXML .= "<set label='ottàgono' value='21900' />";	
	$strXML .= "<set label='novèmbre' value='32900' />";	
	$strXML .= "<set label='décembre' value='39800' />";	
	$strXML .= "<styles><definition><style name='myCaptionFont' type='font' size='12'/></definition>";
	$strXML .= "<application><apply toObject='datalabels' styles='myCaptionFont' /></application></styles>";
	$strXML .= "</chart>";
	
	//Create the chart - Column 2D 
	echo renderChart("../../FusionCharts/Column2D.swf", "", $strXML, "myFirst", 500, 400, false, false);
?>
<BR><BR>
<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
</CENTER>
</BODY>
</HTML>
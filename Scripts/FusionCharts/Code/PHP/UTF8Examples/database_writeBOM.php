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
<h4>Example using multilingual text from database</h4>
<?php
	
	//This page demonstrates the ease of generating charts using FusionCharts.
	//For this chart, we've retrieved multilingual text from database 
	//through a XML relayer script file Data/getXMLFromDatabase.php
	//The file Data/getXMLFromDatabase.php is already ANSI encoded without BOM 
	//We add the BOM in the file using script
	
	//Create the chart - Column 2D Chart 
	echo renderChart("../../FusionCharts/Column2D.swf", "Data/getXMLFromDatabase_writeBOM.php", "", "myFirst", 500, 400, false, false);
?>
<BR><BR>
<a href='../NoChart.html' target="_blank">Unable to see the chart above?</a>
</CENTER>
</BODY>
</HTML>
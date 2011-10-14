<?php

  # Include FusionCharts PHP Class
  include('../Class/FusionCharts_Gen.php');

  # Create SSGrid chart Object 
  $FC = new FusionCharts("grid","300","200"); 
  # set the relative path of the swf file
  $FC->setSWFPath("../FusionCharts/");
  
  # Set grid value Percent on
  $FC->setGridParams("showPercentValues=1");
  # Set alternet row back ground color
  $FC->setGridParams("alternateRowBgColor=EAECEF");
  # number item per page
  $FC->setGridParams("numberItemsPerPage=4");
  # set grid font and font size
  $FC->setGridParams("baseFont=vardana");
  $FC->setGridParams("baseFontSize=12");
       
  # Add grid values and category names
  $FC->addChartData("40800","label=Week 1");
  $FC->addChartData("31400","label=Week 2");
  $FC->addChartData("26700","label=Week 3");
  $FC->addChartData("54400","label=Week 4");
  $FC->addChartData("88544","label=Week 5");
  $FC->addChartData("22544","label=Week 6");
  $FC->addChartData("65548","label=Week 7");
  

?>
<html>
  <head>
    <title>SSGrid with PHP Class</title>
    <script language='javascript' src='../FusionCharts/FusionCharts.js'></script>
  </head>
  <body>

  <?php
    # Render Grid
    $FC->renderChart();
  ?>

  </body>
</html>



<?php

  # Include FusionCharts PHP Class
  include("../Class/FusionCharts_Gen.php");
  
  # Create Pie3D chart Object 
  $FC = new FusionCharts("pie3D","300","250");
    
  # set the relative path of the swf file
  $FC->setSWFPath("../FusionCharts/");

  # Define chart attributes
  $strParam="caption=Weekly Sales;numberPrefix=$";
  
  # Set chart attributes
  $FC->setChartParams($strParam);

  # Add chart values and category names
  $FC->addChartData("40800","label=Week 1");
  $FC->addChartData("31400","label=Week 2");
  $FC->addChartData("26700","label=Week 3");
  $FC->addChartData("54400","label=Week 4");

?>
<html>
  <head>
    <title>First Chart - Change Type : Using FusionCharts PHP Class</title>
    <script language='javascript' src='../FusionCharts/FusionCharts.js'></script>
  </head>
  <body>

  <?php
    # Render Chart 
    $FC->renderChart();
  ?>

  </body>
</html>


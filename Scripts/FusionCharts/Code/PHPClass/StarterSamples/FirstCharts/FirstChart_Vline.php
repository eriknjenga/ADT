<?php

  # Include FusionCharts PHP Class
  include("../Class/FusionCharts_Gen.php");

  # Create Column2D chart Object 
  $FC = new FusionCharts("column2D","300","250");
      
  # set the relative path of the swf file
  $FC->setSWFPath("../FusionCharts/");

  # Define chart attributes
  $strParam="caption=Weekly Sales;xAxisName=Week;yAxisName=Revenue;numberPrefix=$";
  # Set chart attributes
  $FC->setChartParams($strParam);

  # Add chart values and category names
  $FC->addChartData("40800","label=Week 1");

  # Add first vline
  $FC->addChartData("","","color=FF0000");
  # Add chart values  
  $FC->addChartData("31400","label=Week 2");
  $FC->addChartData("26700","label=Week 3");

  # Add Second vline
  $FC->addChartData("","","color=00FF00");
  # Add chart value  
  $FC->addChartData("54400","label=Week 4");

 
?>
<html>
  <head>
    <title>First Chart -Advanded Add Vlines - Single Series : Using FusionCharts PHP Class</title>
    <script language='javascript' src='../FusionCharts/FusionCharts.js'></script>
  </head>
  <body>

  <?php
    # Render Chart 
    $FC->renderChart();
  ?>

  </body>
</html>


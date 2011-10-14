<?php
   # Include FusionCharts PHP Class
   include("../Class/FusionCharts_Gen.php");

  # Create Multiseries Column3D chart object using FusionCharts PHP Class 
  $FC = new FusionCharts("MSColumn2D","450","350");

  # Set the relative path of the swf file
  $FC->setSWFPath("../FusionCharts/");

  # Define chart attributes
  $strParam="caption=Weekly Sales;subcaption=Comparison;xAxisName=Week;yAxisName=Revenue;numberPrefix=$";

  # Set chart attributes 
  $FC->setChartParams($strParam);

  # Add category names
  $FC->addCategory("Week 1");
  # Add vline
  $FC->addCategory("", "","Color=FF0000");
  $FC->addCategory("Week 2");
  $FC->addCategory("Week 3");
  $FC->addCategory("Week 4");

  # Create a new dataset 
  $FC->addDataset("This Month");
  # Add chart values for the above dataset
  $FC->addChartData("40800");
  $FC->addChartData("31400");
  $FC->addChartData("26700");
  $FC->addChartData("54400");

  # Create second dataset 
  $FC->addDataset("Previous Month");
  # Add chart values for the second dataset
  $FC->addChartData("38300");
  $FC->addChartData("28400");
  $FC->addChartData("15700");
  $FC->addChartData("48100");

?>

<html>
  <head>
    <title>Multi-Series Chart - Add Vline -  Using FusionCharts PHP Class</title>
    <script language='javascript' src='../FusionCharts/FusionCharts.js'></script>
  </head>
  <body>

    <?php
      # Render Chart 
      $FC->renderChart();
    ?>


</body>
</html>

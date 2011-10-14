<?php
  # Include FusionCharts PHP Class
  include("../Class/FusionCharts_Gen.php");
  
  #---------- Configuring First Chart ----------
  # Create Column3D chart object 
  $FC = new FusionCharts("Column3D","300","250");
  
  # set the relative path of the swf file
  $FC->setSWFPath("../FusionCharts/");

  # Define chart attributes
  $strParam="caption=Weekly Sales;subcaption=Revenue;xAxisName=Week;yAxisName=Revenue;numberPrefix=$";

  # Set chart attributes
  $FC->setChartParams($strParam);

  # Add chart values and category names for the First Chart
  $FC->addChartData("40800","Label=Week 1");
  $FC->addChartData("31400","Label=Week 2");
  $FC->addChartData("26700","Label=Week 3");
  $FC->addChartData("54400","Label=Week 4");
  
  #--------------------------------------------------------- 

  #---------- Configuring Second Chart ----------
  # Create another Column3D chart object
  $FC2 = new FusionCharts("Column3D","300","250");
  
  # set the relative path of the swf file
  $FC2->setSWFPath("../FusionCharts/");

  # Store chart attributes in a variable 
  $strParam="caption=Weekly Sales;subcaption=Quantity;xAxisName=Week;yAxisName=Quantity;numberSuffix= U";

  # Set chart attributes
  $FC2->setChartParams($strParam);

  # Add chart values and category names for the second chart
  $FC2->addChartData("32","Label=Week 1");
  $FC2->addChartData("35","Label=Week 2");
  $FC2->addChartData("26","Label=Week 3");
  $FC2->addChartData("44","Label=Week 4");
  
  # Set Chart Caching Off for to Fix Caching error in FireFox
  $FC2->setOffChartCaching(true);
  
  //--------------------------------------------------------

?>
<html>
  <head>
    <title>Multiple Charts Using FusionCharts PHP Class</title>
    <script language='javascript' src='../FusionCharts/FusionCharts.js'></script>
  </head>
  <body>

    <?php
      # Render First Chart
      $FC->renderChart();

      # Render Second Chart
      $FC2->renderChart();

    ?>

  </body>
</html>

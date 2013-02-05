<script type="text/javascript">
jQuery(document).ready(function() {
		   var chart = new FusionCharts("<?php echo site_url()?>scripts/FusionCharts/Line.swf", "ChartId", "950", "400", "0", "0");
		   chart.setDataURL("<?php echo site_url()?>patient_statistics/monthly_new_patients/0/<?php echo date('Y');?>");
		   chart.render("chart_area"); 
		   jQuery("#filter_graph").click(function(){ 
				var selected_year = jQuery("#year").find(":selected").attr("value");
				var selected_facility = jQuery("#facility").find(":selected").attr("value"); 
				var chart = new FusionCharts("<?php echo base_url()."Scripts/FusionCharts/Charts/Line.swf"?>", "ChartId", "950", "400", "0", "0");	
				var url = '<?php echo base_url();?>patient_statistics/monthly_new_patients/'+selected_facility+'/'+selected_year; 
				chart.setDataURL(url);
				chart.render("chart_area");
		});
		   
});
</script> 
<style>
	.chart_content{
		margin:0 auto;
	}
	#filter_content{
		margin: 5px auto;
	}
	#filter_content select{ 
		border: 1px solid #ccc;
		padding: 7px 5px;
		min-width: 40%;
		background: #fcfcfc;
		-moz-border-radius: 2px;
		-webkit-border-radius: 2px;
		border-radius: 2px;
		-moz-box-shadow: inset 1px 1px 2px #ddd;
		-webkit-box-shadow: inset 1px 1px 2px #ddd;
		box-shadow: inset 1px 1px 2px #ddd;
		color: #666; 
	}
	#filter_content button {
		border: 1px solid #333;
		background: #333;
		color: #fff;
		cursor: pointer;
		padding: 7px 10px;
		font-weight: bold;
	}
</style>
<div class="notification msginfo">
                        <a class="close"></a>
                        <p>Patient Statistics</p>
</div>
<div class="contenttitle">
    <h2 class="chart"><span>National Statistics</span></h2>
</div>	
<div id="filter_content"> 
	<p>
                        <label><b>Analysis Year:</b></label> 
                        <span class="field" >
                            <select name="year" id="year" style="min-width: 100px; !important">
			<?php
$year = date('Y');
$counter = 0;
for($x=0;$x<=10;$x++){
			?>
			<option <?php
			if ($counter == 0) {echo "selected";
			}
			?> value="<?php echo $year;?>"><?php echo $year;?></option>
			<?php
			$counter++;
			$year--;
			}
			?>
                            </select>
                            </span>
                             
                            <label><b>Analysis Facility: </b></label> 
                            <span class="field">
                            <select name="select" id="facility" style="min-width: 100px; !important">
                            	<option value="0">National Statistics</option>
                            					<?php
				foreach ($facilities as $facility) {
					echo '<option value="' . $facility -> Facility_Object -> facilitycode . '">' . $facility -> Facility_Object -> name . '</option>';
				}
				?>
                            </select>
                            </span>
                            <button class="submit radius2" id="filter_graph">Filter Graph</button>
                        </p> 
                        
</div>	
<div id="chart_area" class="chart_content" style="width:950px; height: 400px;"> 
	
</div>
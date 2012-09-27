<script type="text/javascript">
		var url = "";
	$(function() {
	$("#commodity_consumption").dialog( {
	height: 150,
	width: 500,
	modal: true,
	autoOpen: false
	} );


		$('a.drug_breakdown').click(function() {
		var drug_name = $(this).attr("commodity_name");
		var month_name = $(this).attr("month_name");
		var drug_id = $(this).attr("commodity_id");
		var pack_size = $(this).attr("pack_size");
		var start_date = $(this).attr("start_period");
		var end_date = $(this).attr("end_period");
		var new_title = drug_name+" - "+month_name;
		 
		var url = "<?php echo base_url();?>commodity_management/regimen_breakdown/"+drug_id+"/"+pack_size+"/"+start_date+"/"+end_date;
	// show a spinner or something via css
	var dialog = $('<div style="display:none" class="loading"></div>').appendTo('body');
	// open the dialog
	dialog.dialog({
	height: 'auto',
	width: 'auto',
	title: new_title,
	// add a close listener to prevent adding multiple divs to the document
	close: function(event, ui) {
	// remove div with all data and events
	dialog.remove();
	},
	modal: true
	});
	// load remote content
	dialog.load(
	url,
	{}, // omit this param object to issue a GET request instead a POST request, otherwise you may provide post parameters within the object
	function (responseText, textStatus, XMLHttpRequest) {
	// remove the loading class
	dialog.removeClass('loading');
	}
	);
	//prevent the browser to follow the link
	return false;
	});

	});
</script>
<style>
	#regimen-breakdown {
		width: 980px;
		margin: 0 auto;
		overflow: hidden;
	}
	.regimen-statistics {
		width: 99%;
		margin-top: 5px;
	}
	.regimen-statistics .banner_text {
		font-size: 22px;
	}
	.data-table {
		font-size: 85%;
	}
	.data-table td {
		min-width: 40px;
		padding: 2px !important;
	}

</style>
<form style="margin: 0 auto; width:400px;" method="post" action="<?php echo site_url('commodity_management/commodity_breakdown')?>">
	<table>
		<tr>
			<td>Data From:</td>
			<!--place code here-->
			<td>
			<select id="facility" name="facility">
				<option value="0">National Statistics</option>
				<?php
				foreach ($facilities as $facility) {
					echo '<option value="' . $facility -> Facility_Object -> facilitycode . '">' . $facility -> Facility_Object -> name . '</option>';
				}
				?>
			</select></td>
			<td>
			<input type="submit" class="submit-button" value="Filter Statistics"/>
			</td>
		</tr>
	</table>
</form>
<div id="regimen-breakdown">
	<div class="regimen-statistics">
		<div class="banner_text">
			Stocks Dispensed Breakdown
		</div>
		<table class="data-table">
			<thead>
				<tr>
					<th rowspan="2">Commodity</th>
					<th colspan="12">Quantity Dispensed (Packs)</th>
				</tr>
				<tr>
					<?php
					$months = 12;
					$months_previous = 11;
					for ($current_month = 1; $current_month <= $months; $current_month++) {
						$start_date = date("Y-m-01", strtotime("-$months_previous months"));
						$current_month_name = date("M-y", strtotime("-$months_previous months"));
						echo "<th>$current_month_name</th>";
						$months_previous--;
					}
					?>
				</tr>
			</thead>
			<tbody>
				<?php
foreach ($commodities as $commodity_object) {
$commodity_quantity_data = array();
if(isset($commodity_data[$commodity_object['id']])){
$commodity_quantity_data = $commodity_data[$commodity_object['id']];
}
				?>
				<tr>
					<td><?php echo $commodity_object['Drug'];?></td>
					<?php
$months = 12;
$months_previous = 11;
for ($current_month = 1; $current_month <= $months; $current_month++) {
$start_date = date("Y-m-01", strtotime("-$months_previous months"));
$end_date = date("Y-m-t", strtotime("-$months_previous months"));
$month_name = date("M, Y", strtotime("-$months_previous months"));
if(isset($commodity_quantity_data[$start_date])){
					?>
					<td><a class="link drug_breakdown" pack_size="<?php echo $commodity_object['Pack_Size'];?>" commodity_id="<?php echo $commodity_object['id'];?>" commodity_name="<?php echo $commodity_object['Drug'];?>"  month_name="<?php echo $month_name;?>" start_period="<?php echo $start_date;?>" end_period="<?php echo $end_date;?>"> <?php echo number_format(($commodity_quantity_data[$start_date]['quantity_dispensed'] / $commodity_object['Pack_Size']), 2);?></a></td>
					<?php }
						else{
					?>
					<td>-</td>
					<?php }
						$months_previous--;
						}
					?>
				</tr>
				<?php }?>
			</tbody>
		</table>
	</div>
</div>
<div id="commodity_consumption">
	Haaa!
</div>
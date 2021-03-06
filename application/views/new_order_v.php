<style>
	table {
		border: 1px solid #DDD;
		margin: 10px auto;
		border-spacing: 0px;
	}
	#commodity-table {
		width: 70%;
		float: left;
	}
	table.order-table caption {
		letter-spacing: 1px;
		font-weight: bold;
		text-shadow: 0 1px rgba(0, 0, 0, 0.1);
		font-size: 14px;
	}
	table  th {
		border: none;
		color: #036;
		text-align: right;
		text-shadow: none;
		border: 1px solid #DDD;
		border-top: none;
		font-size: 11px;
		letter-spacing: 1.5px;
		padding: 2px;
	}
	table td {
		border: none;
		margin: 0px;
		max-width: 350px;
		border-bottom: 1px solid #DDD;
	}
	.order-table td {
		padding: 7px;
		font-size: 10px;
		letter-spacing: 1.5px;
	}
	table.order-table tr.normal_row td {
		background: white;
	}
	table.order-table tr.alternate_row td {
		background: #F1F1F1;
	}
	.order-table input {
		padding: 1px;
		height: 25px;
	}
	.regimen-table {
		margin: 0 auto;
		width: 25%;
		float: right;
	}
	.regimen-table th {
		width: 70px;
		margin: 10px;
	}
	.regimen-table input {
		margin: 5px;
	}
	.big-table th {
		text-align: center !important;
		vertical-align: middle;
		background: #F7F4FB;
	}
	.big-table input {
		width: 45px;
	}
	.big-table td.number {
		text-align: center;
	}
	th div {
		font-size: 10px;
	}
	.button{
		width:100px;
		margin:10px;
	}
	#comments-section{
		float: none;
		width:100%;
	}
	#comments-section th{ 
		text-align: left !important;
	}
	table{  
	}
	td{
		word-wrap: break-word;
	}
	.col_drug{
		width:200px !important;
	}

</style>
<script>
	$(document).ready(function() {
		initDatabase();
		$("#start_date").datepicker({
			yearRange : "-120:+0",
			maxDate : "0D",
			dateFormat : $.datepicker.ATOM,
			changeMonth : true,
			changeYear : true
		});
		$("#end_date").datepicker({
			yearRange : "-120:+0",
			maxDate : "0D",
			dateFormat : $.datepicker.ATOM,
			changeMonth : true,
			changeYear : true
		});
		$("#generate").click(function() {
			var start_date = $("#start_date").attr("value");
			var end_date = $("#end_date").attr("value");
			$.each($(".ordered_drugs"), function(i, v) {
				getPeriodDrugBalance($(this).attr("drug_id"), start_date, end_date, function(transaction, results) {
					var row = results.rows.item(0);
					var total_received = row['total_received'];
					var total_dispensed = row['total_dispensed'];
					var total_received_div = "#received_in_period_" + row['drug'];
					var total_dispensed_div = "#dispensed_in_period_" + row['drug'];
					$(total_received_div).attr("value", total_received);
					$(total_dispensed_div).attr("value", total_dispensed);
					calculateResupply($(total_dispensed_div));
				});
			});
			getPeriodRegimenPatients(start_date, end_date, function(transaction, results) {
				//Loop through all the regimen information returned and populate the appropriate fields
				for(var i = 0; i < results.rows.length; i++) {
					var row = results.rows.item(i);
					var total_patients = row['patients'];
					var total_patients_div = "#patient_numbers_" + row['regimen'];
					$(total_patients_div).attr("value", total_patients);
				}

			});
			getPeriodRegimenMos(start_date, end_date, function(transaction, results) {
				//Loop through all the regimen information returned and populate the appropriate fields
				for(var i = 0; i < results.rows.length; i++) {
					var row = results.rows.item(i);
					var total_mos = row['total_mos'];
					var total_mos_div = "#mos_" + row['regimen'];
					$(total_mos_div).attr("value", total_mos);
				}

			});
		});

		$(".pack_size").change(function() {
			calculateResupply($(this));
		});
		$(".opening_balance").change(function() {
			calculateResupply($(this));
		});
		$(".quantity_received").change(function() {
			calculateResupply($(this));
		});
		$(".quantity_dispensed").change(function() {
			calculateResupply($(this));
		});
		$(".losses").change(function() {
			calculateResupply($(this));
		});
		$(".adjustments").change(function() {
			calculateResupply($(this));
		});
		$(".physical_count").change(function() {
			calculateResupply($(this));
		});
	});
	function calculateResupply(element) {
		var row_element = element.closest("tr");
		var opening_balance = parseInt(row_element.find(".opening_balance").attr("value"));
		var quantity_received = parseInt(row_element.find(".quantity_received").attr("value"));
		var quantity_dispensed = parseInt(row_element.find(".quantity_dispensed").attr("value"));
		var losses = parseInt(row_element.find(".losses").attr("value"));
		var adjustments = parseInt(row_element.find(".adjustments").attr("value"));
		var physical_count = parseInt(row_element.find(".physical_count").attr("value"));
		var resupply = 0;
		if(!(opening_balance + 0)) {
			opening_balance = 0;
		}
		if(!(quantity_received + 0)) {
			quantity_received = 0;
		}
		if(!(quantity_dispensed + 0)) {
			quantity_dispensed = 0;
		}
		if(!(losses + 0)) {
			losses = 0;
		}

		if(!(adjustments + 0)) {
			adjustments = 0;
		}
		if(!(physical_count + 0)) {
			physical_count = 0;
		}
		calculated_physical = (opening_balance + quantity_received - quantity_dispensed - losses + adjustments);
		//console.log(calculated_physical);
		/*if(element.attr("class") == "physical_count") {
		 resupply = 0 - physical_count;
		 } else {
		 resupply = 0 - calculated_physical;
		 physical_count = calculated_physical;
		 }*/
		resupply = (quantity_dispensed * 3) - physical_count;
		row_element.find(".physical_count").attr("value", physical_count);
		row_element.find(".resupply").attr("value", resupply);
	}
</script>
<form method="post" action="<?php echo site_url('order_management/save')?>">
	<div class="header section">
		<table class="order-table">
			<tbody>
				<tr>
					<th>Facility Name:</th>
					<td><?php echo $facility_object->name;?></td>
					<th>Facility code:</th>
					<td><?php echo $facility_object->facilitycode;?></td>
				</tr>
				<tr>
					<th>Province:</th>
					<td>-</td>
					<th>District:</th>
					<td><?php echo $facility_object->Parent_District->Name;?></td>
				</tr>
				<tr>
					<th>Programme Sponsor:</th>
					<td>
					<input name="sponsors" id="Cdrr_sponsors" type="text" value="">
					</td>
					<th>Type of Service provided:</th>
					<td>
					<input name="services" id="Cdrr_services" type="text" value="">
					</td>
				</tr>
				<tr>
					<th>Period of Reporting:</th>
					<td>
					<input name="start_date" id="start_date" type="text">
					</td>
					<td>
					<input name="end_date" id="end_date" type="text">
					</td>
					<td>
						<?php
						$logged_in_facility = $this -> session -> userdata('facility_id');
						$ordering_facility = $facility_object->id; 
						if($logged_in_facility == $ordering_facility){?>
					<input name="generate" id="generate" class="action_button" value="Get Dispensing Data">
											<?php }
						?>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<?php
	$header_text = '<thead>
<tr>
<!-- label row -->
<th class="col_drug" rowspan="2">Drug Name</th>
<th class="number" rowspan="2">Pack Size</th> <!-- pack size -->

<th class="number">Beginning Balance</th>
<th class="number">Quantity Received in this period</th>

<!-- dispensed_units -->
<th class="col_dispensed_units">Total Quantity Dispensed this period</th>
<!-- dispensed_packs -->

<th class="col_adjustments">Adjustments (Borrowed from or Issued out to Other Facilities)</th>
<th class="number">End of Month Physical Count</th>

<!-- aggr_consumed/on_hand -->
<th class="number">Quantity required for RESUPPLY</th>
</tr>
<tr>
<!-- unit row -->
<th>In Units</th> <!-- balance -->
<th>In Units</th> <!-- received -->

<!-- dispensed_units -->
<th class="col_dispensed_units">In Units</th>
<!-- dispensed_packs -->

<th>In Units</th> <!-- adjustments -->
<th>In Units</th> <!-- count -->

<!-- aggr_consumed/on_hand -->

<th>In Units</th> <!-- resupply -->
</tr>
<tr>
<!-- letter row -->
<th></th> <!-- drug name -->
<th></th> <!-- packs size -->
<th>A</th> <!-- balance -->
<th>B</th> <!-- received -->
<th>C</th> <!-- dispensed_units/packs -->
<th>D</th> <!-- losses -->
<th>E</th> <!-- adjustments -->
<th>F</th> <!-- count -->

<!-- aggr_consumed/on_hand -->

</tr>
</thead>';
	?>
	<table class="order-table big-table" id="commodity-table">
		<?php echo $header_text;?>
		<tbody>
			<?php
$counter = 0;
foreach($commodities as $commodity){
$counter++;
if($counter == 10){
echo $header_text;
$counter = 0;
}
			?>
			<tr class="ordered_drugs" drug_id="<?php echo $commodity -> id;?>">
				<td class="col_drug"><?php echo $commodity -> Drug;?></td>
				<td class="number">
				<input id="pack_size" type="text" value="<?php echo $commodity -> Pack_Size;?>" class="pack_size">
				</td>
				<td class="number calc_count">
				<input name="opening_balance[]" id="opening_balance_<?php echo $commodity -> id;?>" type="text" class="opening_balance">
				</td>
				<td class="number calc_count">
				<input name="quantity_received[]" id="received_in_period_<?php echo $commodity -> id;?>" type="text" class="quantity_received">
				</td>
				<!-- dispensed_units-->
				<td class="number col_dispensed_units calc_dispensed_packs  calc_resupply calc_count">
				<input name="quantity_dispensed[]" id="dispensed_in_period_<?php echo $commodity -> id;?>" type="text" class="quantity_dispensed">
				</td>
				<td class="number calc_count">
				<input name="adjustments[]" id="CdrrItem_10_adjustments" type="text" class="adjustments">
				</td>
				<td class="number calc_resupply col_count">
				<input tabindex="-1" name="physical_count[]" id="CdrrItem_10_count" type="text" class="physical_count">
				</td>
				<!-- aggregate -->
				<td class="number col_resupply">
				<input tabindex="-1" name="resupply[]" id="CdrrItem_10_resupply" type="text" class="resupply">
				</td>
				<input type="hidden" name="commodity[]" value="<?php echo $commodity -> id;?>"/>
			</tr>
			<?php }?>
		</tbody>
	</table>
	<table class="regimen-table big-table">
		<thead>
			<tr>
				<th class="col_drug">
					Regimen
				</th>
				<th>
					Number of clients on this regimen who picked drugs this reporting period
				</th>
			</tr>
			</thead>
			<tbody>
				<?php
$counter = 1;
foreach($regimens as $regimen){

				?>
				<tr>
				<td regimen_id="<?php echo $regimen -> id;?>" class="regimen_desc col_drug"><?php echo $regimen -> Regimen_Desc;?></td>
				<td regimen_id="<?php echo $regimen -> id;?>" class="regimen_numbers"><input name="patient_numbers[]" id="patient_numbers_<?php echo $regimen -> id;?>" type="text"><input name="patient_regimens[]" value="<?php echo $regimen -> id;?>" type="hidden"></td>
				 
			</tr>
			<?php
				}
				?>
			<tr>
				<td colspan="12">
				<input type="submit" class="button" name="Submit Report" />
				</td>
			</tr>
		</tbody>
	</table>
		<table id="comments-section" class="order-table">
		 
		<tbody>
				<tr>
					<th>Comment:</th>
					<td colspan="3"><textarea rows="10" cols="30" name="comments"></textarea></td>
				</tr>
				<tr>
					<th>Action:</th>
					<td><input type="submit" class="button" value="Submit Order" name="save_changes" /></td> 
				</tr> 
			</tbody>
	</table>
</form>

<style>
	table.order-table {
		border: 1px solid #DDD;
		margin: 10px auto;
		border-spacing: 0px;
	}
	table.order-table caption {
		letter-spacing: 1px;
		font-weight: bold;
		text-shadow: 0 1px rgba(0, 0, 0, 0.1);
		font-size: 14px;
	}
	table.order-table th {
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
	table.order-table td {
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
					console.log(row);
					var total_received = row['total_received'];
					var total_dispensed = row['total_dispensed'];
					var total_received_div = "#received_in_period_" + row['drug'];
					var total_dispensed_div = "#dispensed_in_period_" + row['drug'];
					$(total_received_div).attr("value", total_received);
					$(total_dispensed_div).attr("value", total_dispensed);
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
		});
	});

</script>
<div class="header section">
	<table class="order-table">
		<tbody>
			<tr>
				<th>Facility Name:</th>
				<td>Liverpool VCT</td>
				<th>Facility code:</th>
				<td>13050</td>
			</tr>
			<tr>
				<th>Province:</th>
				<td>Nairobi</td>
				<th>District:</th>
				<td>Nairobi West</td>
			</tr>
			<tr>
				<th>Programme Sponsor:</th>
				<td>
				<input name="Cdrr[sponsors]" id="Cdrr_sponsors" type="text" value="">
				</td>
				<th>Type of Service provided:</th>
				<td>
				<input name="Cdrr[services]" id="Cdrr_services" type="text" value="ART, PMTCT">
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
				<input name="generate" id="generate" type="submit" class="action_button" value="Pre-populate">
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

<th class="number">Losses (Damages, Expiries, Missing)</th>
<th class="col_adjustments">Adjustments (Borrowed from or Issued out to Other Facilities)</th>
<th class="number">End of Month Physical Count</th>

<!-- aggr_consumed/on_hand -->

<!-- expiry_quant/date -->
<th colspan="2">Drugs with less than 6 months to expiry</th>

<th class="number" rowspan="2">Days out of stock this Month</th>
<th class="number">Quantity required for RESUPPLY</th>
</tr>
<tr>
<!-- unit row -->
<th>In Units</th> <!-- balance -->
<th>In Units</th> <!-- received -->

<!-- dispensed_units -->
<th class="col_dispensed_units">In Units</th>
<!-- dispensed_packs -->

<th>In Units</th> <!-- losses -->
<th>In Units</th> <!-- adjustments -->
<th>In Units</th> <!-- count -->

<!-- aggr_consumed/on_hand -->

<th class="number">Quantity</th> <!-- expiry_quant -->
<th class="date">Expiry Date</th> <!-- expiry_date -->
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

<th>In Units</th> <!-- expiry_quant -->
<th>mm/yyy</th> <!-- expiry_date -->

<th>G</th> <!-- out_of_stock -->
<th>H</th> <!-- resupply -->

</tr>
</thead>';
?>
<table class="order-table big-table">
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
			<input id="pack_size" type="text" value="<?php echo $commodity -> Pack_Size;?>">
			</td>
			<td class="number calc_count">
			<input name="opening_balance[]" id="opening_balance_<?php echo $commodity -> id;?>" type="text">
			</td>
			<td class="number calc_count">
			<input name="received_in_period" id="received_in_period_<?php echo $commodity -> id;?>" type="text">
			</td>
			<!-- dispensed_units-->
			<td class="number col_dispensed_units calc_dispensed_packs  calc_resupply calc_count">
			<input name="dispensed_in_period" id="dispensed_in_period_<?php echo $commodity -> id;?>" type="text">
			</td>
			<!-- dispensed_packs -->
			<td class="number calc_count">
			<input name="CdrrItem[10][losses]" id="CdrrItem_10_losses" type="text">
			</td>
			<td class="number calc_count">
			<input name="CdrrItem[10][adjustments]" id="CdrrItem_10_adjustments" type="text">
			</td>
			<td class="number calc_resupply col_count">
			<input tabindex="-1" name="CdrrItem[10][count]" id="CdrrItem_10_count" type="text">
			</td>
			<!-- aggregate -->
			<!-- expiry -->
			<td class="number">
			<input name="CdrrItem[10][expiry_quant]" id="CdrrItem_10_expiry_quant" type="text">
			</td>
			<td class="date">
			<input id="CdrrItem_10_expiry_date" name="CdrrItem[10][expiry_date]" type="text" class="hasDatepicker">
			</td>
			<td class="number">
			<input name="CdrrItem[10][out_of_stock]" id="CdrrItem_10_out_of_stock" type="text">
			</td>
			<td class="number col_resupply">
			<input tabindex="-1" name="CdrrItem[10][resupply]" id="CdrrItem_10_resupply" type="text">
			</td>
		</tr>
		<?php }?>
	</tbody>
</table>
<table class="regimen-table big-table">
	<tbody>
		<tr>
			<th>
			<div>
				No. of Patients
			</div></br>
			<div>
				MOS Dispensed
			</div></th>
			<?php
$counter = 1;
foreach($regimens as $regimen){

			?>
			<th regimen_id="<?php echo $regimen -> id;?>" class="regimen_numbers"><?php echo $regimen -> Regimen_Code;?>
			<input tabindex="-1" name="patient_numbers[]" id="patient_numbers_<?php echo $regimen -> id;?>" type="text">
			<input tabindex="-1" name="mos[]" id="mos_<?php echo $regimen -> id;?>" type="text">
			</th>
			<?php
			echo "</th>";
			if ($counter == 11) {
				echo "</tr><tr><th><div>No. of Patients</div></br><div>MOS Dispensed</div></th>";
				$counter = 0;
			}
			$counter++;

			}
			?>
	</tbody>
</table>

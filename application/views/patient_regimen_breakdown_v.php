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
</style>
<form style="margin: 0 auto; width:400px;" method="post" action="<?php echo site_url('patient_management/regimen_breakdown')?>">
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
			Optimal Regimens
		</div>
		<table class="data-table">
			<thead>
				<tr>
					<th rowspan="2">Regimen</th>
					<?php
					$months = 12;
					$months_previous = 11;
					for ($current_month = 1; $current_month <= $months; $current_month++) {
						$start_date = date("Y-m-01", strtotime("-$months_previous months"));
						$current_month_name = date("M-y", strtotime("-$months_previous months"));
						echo "<th colspan='2'>$current_month_name</th>";
						$months_previous--;
					}
					?>
				</tr>
				<tr>
					<th>P#</th>
					<th>MOS</th>
					<th>P#</th>
					<th>MOS</th>
					<th>P#</th>
					<th>MOS</th>
					<th>P#</th>
					<th>MOS</th>
					<th>P#</th>
					<th>MOS</th>
					<th>P#</th>
					<th>MOS</th>
					<th>P#</th>
					<th>MOS</th>
					<th>P#</th>
					<th>MOS</th>
					<th>P#</th>
					<th>MOS</th>
					<th>P#</th>
					<th>MOS</th>
					<th>P#</th>
					<th>MOS</th>
					<th>P#</th>
					<th>MOS</th>
				</tr>
			</thead>
			<tbody>
				<?php
foreach ($optimal_regimens as $regimen_object) {
$regimen_patient_data = array();
if(isset($regimen_data[$regimen_object->id])){
$regimen_patient_data = $regimen_data[$regimen_object->id];
}

				?>
				<tr>
					<td><?php echo $regimen_object -> Regimen_Desc;?></td>
					<?php
$months = 12;
$months_previous = 11;
for ($current_month = 1; $current_month <= $months; $current_month++) {
$start_date = date("Y-m-01", strtotime("-$months_previous months"));
if(isset($regimen_patient_data[$start_date])){
					?>
					<td><?php echo $regimen_patient_data[$start_date]['patient_numbers'];?></td>
					<td><?php echo number_format($regimen_patient_data[$start_date]['mos'],1);?></td>
					<?php }
						else{
					?>
					<td>-</td>
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
	<div class="regimen-statistics">
		<div class="banner_text">
			Sub-Optimal Regimens
		</div>
				<table class="data-table">
			<thead>
				<tr>
					<th rowspan="2">Regimen</th>
					<?php
					$months = 12;
					$months_previous = 11;
					for ($current_month = 1; $current_month <= $months; $current_month++) {
						$start_date = date("Y-m-01", strtotime("-$months_previous months"));
						$current_month_name = date("M-y", strtotime("-$months_previous months"));
						echo "<th colspan='2'>$current_month_name</th>";
						$months_previous--;
					}
					?>
				</tr>
				<tr>
					<th>P#</th>
					<th>MOS</th>
					<th>P#</th>
					<th>MOS</th>
					<th>P#</th>
					<th>MOS</th>
					<th>P#</th>
					<th>MOS</th>
					<th>P#</th>
					<th>MOS</th>
					<th>P#</th>
					<th>MOS</th>
					<th>P#</th>
					<th>MOS</th>
					<th>P#</th>
					<th>MOS</th>
					<th>P#</th>
					<th>MOS</th>
					<th>P#</th>
					<th>MOS</th>
					<th>P#</th>
					<th>MOS</th>
					<th>P#</th>
					<th>MOS</th>
				</tr>
			</thead>
			<tbody>
				<?php
foreach ($sub_optimal_regimens as $regimen_object) {
$regimen_patient_data = array();
if(isset($regimen_data[$regimen_object->id])){
$regimen_patient_data = $regimen_data[$regimen_object->id];
}
				?>
				<tr>
					<td><?php echo $regimen_object -> Regimen_Desc;?></td>
					<?php
$months = 12;
$months_previous = 11;
for ($current_month = 1; $current_month <= $months; $current_month++) {
$start_date = date("Y-m-01", strtotime("-$months_previous months"));
if(isset($regimen_patient_data[$start_date])){
					?>
					<td><?php echo $regimen_patient_data[$start_date]['patient_numbers'];?></td>
					<td><?php echo number_format($regimen_patient_data[$start_date]['mos'],1);?></td>
					<?php }
						else{
					?>
					<td>-</td>
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
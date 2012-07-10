<style type="text/css">
	#left {
		margin: 10px;
		margin-right:30px;
		float: left;
	}
	#right {
		float: left;
		margin-top: 50px;
	}

	input[type="checkbox"] {
		float:right;
	}
</style>
<div id="view_content">
	<a class="action_button" id="new_genericname" href="<?php echo base_url()."drugcode_management"?>"> &lt;&lt;Back to Listing</a>
	<?php
	$attributes = array('class' => 'input_form', 'style' => 'width:600px; margin:0 auto; border:1px solid #DDD; overflow:hidden;');
	echo form_open('drugcode_management/save', $attributes);
	echo validation_errors('<p class="error">', '</p>');
	?>

	<div id="left">
		<label> <strong class="label">Drug Name</strong>
			<input type="text" name="drug" id="drug" class="input">
		</label>
		<label> <strong class="label">Unit</strong>
			<select class="input" id="unit" name="unit">
				<?php
foreach($drug_units as $drug_unit){
				?>
				<option value="<?php echo $drug_unit -> id;?>"><?php echo $drug_unit -> Name;?></option>
				<?php }?>
			</select> </label>
		<label> <strong class="label">Pack Size</strong>
			<input type="text" class="input" id="pack_size" name="pack_size"/>
		</label>
		<label> <strong class="label">Safety Quantity</strong>
			<input type="text" class="input" id="safety_quantity" name="safety_quantity"/>
		</label>
		<label> <strong class="label">Generic Type</strong>
			<select class="input" id="generic_name" name="generic_name">
				<?php
foreach($generic_names as $generic_name){
				?>
				<option value="<?php echo $generic_name -> id;?>"><?php echo $generic_name -> Name;?></option>
				<?php }?>
			</select> </label>
		<label> <strong class="label">Supported By</strong>
			<select class="input" id="supported_by" name="supported_by">
				<?php
foreach($supporters as $supporter){
				?>
				<option value="<?php echo $supporter -> id;?>"><?php echo $supporter -> Name;?></option>
				<?php }?>
			</select> </label>
		<label> <strong class="label">Other than ARV?
			<input type="checkbox" class="input" id="none_arv" name="none_arv"/>
			</strong> </label>
		<label> <strong class="label">Or a TB drug?
			<input type="checkbox" class="input" id="tb_drug" name="tb_drug"/>
			</strong> </label>
		<label> <strong class="label">Drug in use?
			<input type="checkbox" class="input" id="drug_in_use" name="drug_in_use"/>
			</strong> </label>
	</div>
	<div id="right">
		<label> <strong class="label">Comments</strong> 			<textarea cols="30" rows="5" class="input" id="comment" name="comment"></textarea> </label>
		<fieldset>
			<legend>
				Standard Dispensing Information
			</legend>
			<table>
				<tr>
					<td>Dose</td>
					<td>
					<select class="input" id="dose" name="dose">
						<?php
foreach($doses as $dose){
						?>
						<option value="<?php echo $dose -> id;?>"><?php echo $dose -> Name;?></option>
						<?php }?>
					</select></td>
				</tr>
				<tr>
					<td>Duration</td>
					<td>
					<input type="text" class="input" id="duration" name="duration"/>
					</td>
				</tr>
				<tr>
					<td>Quantity</td>
					<td>
					<input type="text" class="input" id="quantity" name="quantity"/>
					</td>
				</tr>
			</table>
		</fieldset>
	</div>
	<input type="submit" value="Save" class="submit-button"/>
	</form>
</div>
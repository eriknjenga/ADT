<script>
	$(document).ready(function() {
		$("#entry_form").dialog({
			height : 250,
			width : 500,
			modal : true,
			autoOpen : false
		});
		$("#new_regimen_drug").click(function() {
			$("#entry_form").dialog("open");
		});
		$("#regimen_drug_listing").accordion({
			autoHeight : false,
			navigation : true
		});
	});

</script>
<style>
#regimen_drug_listing{
	width:90%;
	margin:10px auto;
}	
	
</style>

<div id="view_content">
	<a class="action_button" id="new_regimen_drug">New Regimen Drug</a>
	<?php echo validation_errors('<p class="error">', '</p>');?>

	<div id="regimen_drug_listing">
		<?php
foreach($regimens as $regimen){
		?>
		<h6><a href=""><?php echo $regimen->Regimen_Desc;?></a></h6>
		<div>
			<ul>
			<?php foreach($regimen->Drugs as $drug){?>
			<li>
				<?php echo $drug->Drug->Drug;?>
			</li>
			<?php }?>
			</ul>
		</div>
		<?php }?>
	</div>
	<div id="entry_form" title="New Regimen Drug">
		<?php
		$attributes = array('class' => 'input_form');
		echo form_open('regimen_drug_management/save', $attributes);
		?>
		<label> <strong class="label">Select Regimen</strong>
			<select class="input" id="regimen" name="regimen">
				<?php
foreach($regimens as $regimen){
				?>
				<option value="<?php echo $regimen -> id;?>"><?php echo $regimen -> Regimen_Desc;?></option>
				<?php }?>
			</select> </label>
		<label> <strong class="label">Select Drug</strong>
			<select class="input" id="drugid" name="drugid">
				<?php
foreach($drug_codes as $drug_code){
				?>
				<option value="<?php echo $drug_code -> id;?>"><?php echo $drug_code -> Drug;?></option>
				<?php }?>
			</select> </label>
		<input type="submit" value="Save" class="submit-button"/>
		</form>
	</div>
</div>
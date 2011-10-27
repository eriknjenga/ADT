<script>
	$(document).ready(function() {
		$("#entry_form").dialog({
			height : 250,
			width : 500,
			modal : true,
			autoOpen : false
		});
		$("#new_brandname").click(function() {
			$("#entry_form").dialog("open");
		});
		$("#drug_listing").accordion({
			autoHeight : false,
			navigation : true
		});
	});

</script>
<style>
#drug_listing{
	width:90%;
	margin:10px auto;
}	
	
</style>

<div id="view_content">
	<a class="action_button" id="new_brandname">New Brand Name</a>
	<?php echo validation_errors('<p class="error">', '</p>');?>

	<div id="drug_listing">
		<?php
foreach($drug_codes as $drug_code){
		?>
		<h6><a href=""><?php echo $drug_code->Drug;?></a></h6>
		<div>
			<ul>
			<?php foreach($drug_code->Brands as $brand){?>
			<li>
				<?php echo $brand->Brand;?>
			</li>
			<?php }?>
			</ul>
		</div>
		<?php }?>
	</div>
	<div id="entry_form" title="New Brandname">
		<?php
		$attributes = array('class' => 'input_form');
		echo form_open('brandname_management/save', $attributes);
		?>
		<label> <strong class="label">Select Drug</strong>
			<select class="input" id="drugid" name="drugid">
				<?php
foreach($drug_codes as $drug_code){
				?>
				<option value="<?php echo $drug_code -> id;?>"><?php echo $drug_code -> Drug;?></option>
				<?php }?>
			</select> </label>
		<strong class="label">Brand Name</strong>
		<input type="text" name="brandname" id="brandname" class="input">
		</label>

		</label>
		<input type="submit" value="Save" class="submit-button"/>
		</form>
	</div>
</div>
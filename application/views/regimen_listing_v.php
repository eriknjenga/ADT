<script>
	$(document).ready(function() {
		$("#entry_form").dialog({
			height : 600,
			width : 300,
			modal : true,
			autoOpen : false
		});
		$("#new_regimen").click(function(){ 
			$("#entry_form").dialog("open");
		});
	});

</script>
<div id="view_content">
	<a class="action_button" id="new_regimen">New Regimen</a>
	<table border="0" class="data-table">
		<th class="subsection-title" colspan="11">Regimens</th>
		<tr>
			<th>Regimen Code</th>
			<th>Description</th>
			<th>Category</th>
			<th>Line</th>
			<th>Service Type</th>
			<th>Remarks</th>
			<th>Show</th>
			<th>Action</th>
		</tr>
		<?php
foreach($regimens as $regimen){
		?>
		<tr>
			<td><?php echo $regimen -> Regimen_Code;?></td>
			<td><?php echo $regimen -> Regimen_Desc;?></td>
			<td><?php echo $regimen -> Regimen_Category->Name;?></td>
			<td><?php echo $regimen -> Line;?></td>
			<td><?php echo $regimen -> Regimen_Service_Type->Name;?></td>
			<td><?php echo $regimen -> Remarks;?></td>
			<td><?php echo $regimen -> Enabled;?></td>
			<td><a href="#" class="link">Edit</a>  | <a href="#" class="link">Combinations</a></td>
		</tr>
		<?php }?>
	</table>
<div id="entry_form" title="New Regimen">
	<?php
	$attributes = array('class' => 'input_form');
	echo form_open('regimen_management/save', $attributes);
	echo validation_errors('<p class="error">', '</p>');
	?>
	<label>
<strong class="label">Regimen Code</strong>
<input type="text" name="regimen_code" id="regimen_code" class="input">
</label>

	<label>
<strong class="label">Description</strong>
<input type="text" name="regimen_desc" id="regimen_desc" class="input">
</label>

	<label>
<strong class="label">Category</strong> 
		<select class="input" id="category" name="category">
				<?php
				foreach($regimen_categories as $regimen_category){?>
					<option value="<?php echo $regimen_category->id; ?>"><?php echo $regimen_category->Name; ?></option>
				<?php }
				?>
			</select>
</label>

	<label>
<strong class="label">Line</strong>
<input type="text" name="line" id="line" class="input">
</label>

	<label>
<strong class="label">Type of Service</strong>
			<select class="input" id="type_of_service" name="type_of_service">
				<?php
				foreach($regimen_service_types as $regimen_service_type){?>
					<option value="<?php echo $regimen_service_type->id; ?>"><?php echo $regimen_service_type->Name; ?></option>
				<?php }
				?>
			</select>
</label>
	<label>
<strong class="label">Remarks</strong>
<textarea name="remarks" id="remarks" class="input"></textarea>
</label>
	<label>
<strong class="label"><input type="checkbox" name="show" id="show" class="input"> Show</strong>

</label>
	<input type="submit" value="Save" class="submit-button"/>
	</form>
</div>
</div>
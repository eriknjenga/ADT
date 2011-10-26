<script>
	$(document).ready(function() {
		$("#entry_form").dialog({
			height : 500,
			width : 750,
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
			<th>Regimen Description</th>
			<th>Category</th>
			<th>Line</th>
			<th>Type of Service</th>
			<th>Remarks</th>
			<th>Show</th>
			<th>Action</th>
		</tr>
		<?php
foreach($regimens as $regimen){
		?>
		<tr>
			<td><?php echo $regimen -> regimen_code;?></td>
			<td><?php echo $regimen -> regimen_desc;?></td>
			<td><?php echo $regimen -> category;?></td>
			<td><?php echo $regimen -> line;?></td>
			<td><?php echo $regimen -> type_of_service;?></td>
			<td><?php echo $regimen -> remarks;?></td>
			<td><?php echo $regimen -> enabled;?></td>
			<td><a href="#" class="link">Edit</a> | <a href="#" class="link">Hide</a></td>
		</tr>
		<?php }?>
	</table>
<div id="entry_form" title="New Regimen">
	<?php
	$attributes = array('class' => 'input_form');
	echo form_open('regimen_management/save', $attributes);
	echo validation_errors('<p class="error">', '</p>');
	?>
	<table>
		<tr>
			<td>Regimen Code</td>
			<td>
			<input type="text" class="input" id="regimen_code" name="regimen_code"/>
			</td>
		</tr>
		<tr>
			<td>Regimen Description</td>
			<td>
			<input type="text" class="input" id="regimen_desc" name="regimen_desc"/>
			</td>
		</tr>
		<tr>
			<td>Category</td>
			<td>
			<select class="input" id="category" name="category">
				<option>option 1</option>
				<option>option 2</option>
			</select></td>
		</tr>
		<tr>
			<td>Line</td>
			<td>
			<input type="text" class="input" id="line" name="line"/>
			</td>
		</tr>
		<tr>
			<td>Type of Service</td>
			<td>
			<select class="input" id="type_of_service" name="type_of_service">
				<option>option 1</option>
				<option>option 2</option>
			</select></td>
		</tr>
		<tr>
			<td>Remarks</td>
			<td>
			<input type="text" class="input" id="remarks" name="remarks"/>
			</td>
		</tr>
		<tr>
			<td>Show</td>
			<td>
			<input type="checkbox" class="input" id="show" name="show"/>
			</td>
		</tr>
	</table>
	<input type="submit" value="Save"/>
	</form>
</div>
</div>
<script>
	$(document).ready(function() {
		$("#entry_form").dialog({
			height : 200,
			width : 300,
			modal : true,
			autoOpen : false
		});
		$("#new_genericname").click(function(){ 
			$("#entry_form").dialog("open");
		});
	});

</script>
<div id="view_content">
	<a class="action_button" id="new_genericname">New Generic Name</a>
		<?php echo validation_errors('<p class="error">', '</p>');?>
	<table border="0" class="data-table">
		<th class="subsection-title" colspan="11">Generic Names</th>
		<tr>
			<th>Generic Name</th>
			<th>Action</th>
		</tr>
		<?php
foreach($generic_names as $generic_name){
		?>
		<tr>
			<td><?php echo $generic_name -> Name;?></td>
			<td><a href="#" class="link">Edit</a></td>
		</tr>
		<?php }?>
	</table>
<div id="entry_form" title="New Generic Name">
	<?php
	$attributes = array('class' => 'input_form');
	echo form_open('genericname_management/save', $attributes);

	?>
	<label>
<strong class="label">Generic Name</strong>
<input type="text" name="drugname" id="drugname" class="input">
</label>
 
</label>
	<input type="submit" value="Save" class="submit-button"/>
	</form>
</div>
</div>
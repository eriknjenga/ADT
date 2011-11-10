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
		<?php echo validation_errors('<p class="error">', '</p>');
		echo $this -> table -> generate($generic_names);
		?>
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

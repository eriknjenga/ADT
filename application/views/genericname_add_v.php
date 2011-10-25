<div class="view_content">
	<?php
	$attributes = array('id' => 'entry_form');
	echo form_open('genericname_management/save', $attributes);
	echo validation_errors('
<p class="error">', '</p>
');
?>
	<table>
		<tr>
			<td>Generic Drug Name</td><td>
			<input type="text" class="input" name="drugname"/>
			</td>
		</tr>
		<tr>
			<td></td><td>
			<input type="submit" class="submission_button" name="submit"/>
			</td>
		</tr>
	</table>
	</form>
</div>
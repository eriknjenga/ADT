<!--incomplete, awaiting input from njenga!!!!--->




<div class="view_content">
	<?php
	$attributes = array('id' => 'entry_form');
	echo form_open('newuser_management/save', $attributes);
	echo validation_errors('
<p class="error">', '</p>
');
?>
	<table>
		<tr>
			<td>Names</td>
			<td>
			<input type="text" class="input" name="firstname"/>
			</td>
		</tr>
		<tr>
			<td>Username</td>
			<td>
			<input type="text" class="input" name="username"/>
			</td>
		</tr>
		<tr>
			<td>E-Mail Address</td>
			<td>
			<input type="text" class="input" name="email"/>
			</td>
		</tr>
		<tr>
			<td>Phone Number</td>
			<td>
			<input type="text" class="input" name="phone"/>
			</td>
		</tr>
		<tr>
			<td>Facility</td>
			<td>
			<!--place code here-->
			</td>
		</tr>
		<tr>
			<td>Access Level</td>
			<td>
			<!--place code here-->
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
<div class="view_content">
	<?php
	$attributes = array('id' => 'entry_form');
	echo form_open('brandname_management/save', $attributes);
	echo validation_errors('
<p class="error">', '</p>
');
?>
	<table>
		<tr>
			<td>Associated Drug</td>
			<!--place code here-->
			<td>
				<select id="drugid" name="drugid"> 
					<option value="none">Select a Drug Code</option>
					<?php
					foreach($drugcodes as $drugs){
						echo '<option value="' . $drugs->id . '">' . $drugs->drug . '</option>';
					}  
					?>
				</select>
			</td>
		</tr>
		<tr>
			<td>Brand Name</td><td>
			<input type="text" class="input" name="brandname"/>
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
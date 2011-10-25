<div id="view_content">
	<div align="center">
		<table border="1">
			<th>Regimen Code</th>
			<th>Regimen Description</th>
			<th>Category</th>
			<th>Line</th>
			<th>Type of Service</th>
			<th>Remarks</th>
			<th>Show</th>		
		</table>
		<input type="button" value="New Regimen"/>
	</div>
	<div align="center">
		<?php
		$attributes = array( 'class'=>'input_form');
		echo form_open('regimen_management/save',$attributes);
		echo validation_errors('<p class="error">','</p>'); 
		?>
		<table>
			<tr>
				<td>Regimen Code</td>
				<td><input type="text" class="input" id="regimen_code" name="regimen_code"/></td>
			</tr>
			<tr>
				<td>Regimen Description</td>
				<td><input type="text" class="input" id="regimen_desc" name="regimen_desc"/></td>
			</tr>
			<tr>
				<td>Category</td>
				<td>
					<select class="input" id="category" name="category">
						<option>option 1</option>
						<option>option 2</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>Line</td>
				<td><input type="text" class="input" id="line" name="line"/></td>
			</tr>
			<tr>
				<td>Type of Service</td>
				<td>
					<select class="input" id="type_of_service" name="type_of_service">
						<option>option 1</option>
						<option>option 2</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>Remarks</td>
				<td><input type="text" class="input" id="remarks" name="remarks"/></td>
			</tr>
			<tr>
				<td>Show</td>
				<td><input type="checkbox" class="input" id="show" name="show"/></td>
			</tr>
			
	</table>
	<input type="submit" value="Save"/>
	</form>
	</div>
	
</div>
<div id="view_content">
	<div align="center">
		<table border="1">
			<th>Drug ID</th>
			<th>Unit</th>
			<th>Pack Size</th>
			<th>Safety Quantity</th>
			<th>Generic Type</th>
			<th>Supported</th>
			<th>Other Drug (Not ARV)</th>
			<th>TB drug</th>
			<th>Drug in Use</th>
			<th>Comments</th>
			<th>Dose</th>
			<th>Duration</th>
			<th>Quantity</th>
		</table>
		<input type="button" value="New Entry"/>
	</div>
	
	<div align="center">
		<?php
		$attributes = array( 'class'=>'input_form');
		echo form_open('drugcode_management/save',$attributes);
		echo validation_errors('<p class="error">','</p>'); 
		?>
			<table>
				<tr>
					<td>Drug ID</td>
					<td><input type="text" class="input" id="drug" name="drug"/></td>
				</tr>
				<tr>
					<td>Unit</td>
					<td>
						<select class="input" id="unit" name="unit">
							<option>option 1</option>
							<option>option 2</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>Pack Size</td>
					<td><input type="text" class="input" id="pack_size" name="pack_size"/></td>
				</tr>
				<tr>
					<td>Safety Quantity</td>
					<td><input type="text" class="input" id="safety_quantity" name="safety_quantity"/></td>
				</tr>
				<tr>
					<td>Generic Type</td>
					<td>
						<select class="input" id="generic_name" name="generic_name">
							<option>option 1</option>
							<option>option 2</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>Supported</td>
					<td>
						<select class="input" id="supported_by" name="supported_by">
							<option>option 1</option>
							<option>option 2</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>Drug other than ARV?</td>
					<td><input type="checkbox" class="input" id="none_arv" name="none_arv"/></td>
				</tr>
				<tr>
					<td>Or a TB drug?</td>
					<td><input type="checkbox" class="input" id="tb_drug" name="tb_drug"/></td>
				</tr>
				<tr>
					<td>Drug in use?</td>
					<td><input type="checkbox" class="input" id="drug_in_use" name="drug_in_use"/></td>
				</tr>
				<tr>
					<td>Comments</td>
					<td><textarea cols="30" class="input" id="comment" name="comment"></textarea></td>
				</tr>
				
			</table>
		</div>
		<div align="center">
			 <fieldset>
    		<legend>Standard Dispensing Information</legend>
			<table>
				<tr>
					<td>Dose</td>
					<td>
						<select class="input" id="dose" name="dose">
							<option>option 1</option>
							<option>option 2</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>Duration</td>
					<td><input type="text" class="input" id="duration" name="duration"/></td>
				</tr>
				<tr>
					<td>Quantity</td>
					<td><input type="text" class="input" id="quantity" name="quantity"/></td>
				</tr>
			</table>
			</fieldset>
			<input type="submit" value="Save"/>
		</form>
	</div>
		
</div>
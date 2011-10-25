<div id="view_content">
	<div align="center">
		<?php
		$attributes = array( 'class'=>'input_form');
		echo form_open('regimendrug_management/save',$attributes);
		echo validation_errors('<p class="error">','</p>'); 
		?>
			<table>
				<tr>
					<td>Regimen</td>
					<td>
						<select class="input" id="regimen" name="regimen">
							<option value="1">option 1</option>
							<option value="2">option 2</option>
						</select>
					</td>
					<td></td>
				</tr>
			</table>
			<fieldset >
				<legend>New Drug combination for regimen</legend>
				<table>			
					<tr>			
						<td></td>
						<td><input type="text" class="input" size="30" id="combination" name="combination"/></td>
						<td><input type="submit" class="input" value="Add "/></td>						
					</tr>			
				</table>
			</fieldset>	
		</form>		
	</div>
</div>
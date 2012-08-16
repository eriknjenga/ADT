<style type="text/css">
	#left {
		margin: 0 auto;
		width: 90%;
	}
	input[type="checkbox"] {
		float: right;
	}

</style>
<script>
$(document).ready(function() {
					$(".add").click(function() {
					var cloned_object = $('#drugs_table tr:last').clone(true);
					var drug_row = cloned_object.attr("drug_row");
					var next_drug_row = parseInt(drug_row) + 1;
					cloned_object.attr("drug_row", next_drug_row);
					var batch_id = "batch_" + next_drug_row;
					var quantity_id = "quantity_" + next_drug_row;
					var expiry_id = "expiry_date_" + next_drug_row;
					var batch = cloned_object.find(".batch");
					var packs = cloned_object.find(".pack");
					var packs = cloned_object.find(".pack");
					var unit = cloned_object.find(".unit");
					var pack_size = cloned_object.find(".pack_size");
					var quantity = cloned_object.find(".quantity");
					var expiry_date = cloned_object.find(".expiry");
					batch.attr("id", batch_id);
					quantity.attr("id", quantity_id);
					expiry_date.attr("id", expiry_id);
					batch.attr("value", "");
					quantity.attr("value", "");
					expiry_date.attr("value", "");
					packs.attr("value", "");
					pack_size.attr("value", "");
					unit.attr("value", "");
					var expiry_selector = "#" + expiry_id;

					$(expiry_selector).datepicker({
						defaultDate : new Date(),
						changeYear : true,
						changeMonth : true
					});
					cloned_object.insertAfter('#drugs_table tr:last');
					refreshDatePickers();
					return false;
				});
	});
</script>
<div id="view_content">
	<?php
	$attributes = array('class' => 'input_form', 'style' => 'width:980px; margin:0 auto; border:1px solid #DDD; overflow:hidden;');
	echo form_open('satellite_management/save', $attributes);
	echo validation_errors('<p class="error">', '</p>');
	?>

	<div id="left">
		<label> <strong class="label">Satellite</strong>
			<select class="input" id="satellite" name="satellite">
				<option value="1">Satellite 1</option>
			</select> </label>
		<label> <strong class="label">Date Issued</strong>
			<input type="text" class="input" id="date" name="date"/>
		</label>
		<label> <strong class="label">Ref./Order Number</strong>
			<input type="text" class="input" id="order" name="order"/>
		</label>
	</div>
								<div id="drugs_section">
								<table border="0" class="data-table" id="drugs_table">
									<th class="subsection-title" colspan="13">Select Drugs</th>
									<tr>
										<th>Drug</th>
										<th>Unit</th>
										<th>Pack Size</th>
										<th>Batch No.</th>
										<th>Expr. Date</th>
										<th>Packs</th>
										<th>Quantity</th>
										<th>Unit Cost</th>
										<th>Total</th>
										<th>Comment</th>
										<th>Add New</th>
									</tr>
									<tr drug_row="1">
										<td>
										<select name="drug" class="drug"  style="max-width: 70px;">
											<option>Select Commodity</option>
											<?php foreach($commodities as $commodity){?>
												<option <?php echo $commodity -> id;?>><?php echo $commodity -> Drug;?></option>												
											<?php }
											?>
										</select></td>
										<td>
										<input type="text" name="unit" class="unit small_text" />
										</td>
										<td>
										<input type="text" name="pack_size" class="pack_size small_text" />
										</td>
										<td>
										<input type="text" name="batch" class="batch small_text validate[required]"   id="batch_1"/>
										</td>
										<td>
										<input type="text" name="expiry" class="expiry small_text" id="expiry_date"/>
										</td>
										<td>
										<input type="text" name="pack" class="pack small_text validate[required]" id="quantity_1" />
										</td>
										<td>
										<input type="text" name="quantity" class="quantity small_text" readonly=""/>
										</td>
										<td>
										<input type="text" name="unit_cost" class="unit_cost small_text" />
										</td>
										<td>
										<input type="text" name="amount" class="amount small_text" />
										</td>
										<td>
										<input type="text" name="comment" class="comment small_text" />
										</td>
										<td>
										<input type="button" class="add button" value="Add"/>
										</td>
									</tr>
								</table>
							</div>
	<input type="submit" value="Save" class="submit-button"/>
	</form>
</div>
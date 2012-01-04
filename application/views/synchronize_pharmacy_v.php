<script type="text/javascript">
	initDatabase();
	$(document).ready(function() {
		var total_drugs = 0;
		var url = "";
		countTableRecords("drugcode", function(transaction, results) {
			var row = results.rows.item(0);
			total_drugs = row['total'];
			$("#total_drugs_local").html(total_drugs);
			url = "synchronize_pharmacy/getServerDrugs";
			$.get(url, function(data) {
				var master_drugs = data;
				$("#total_drugs_master").html(data);
				if(data > total_drugs) {
					var get_all_drugs_url = "synchronize_pharmacy/getAllDrugs";
					var drugs_progress_bar = "drugs_progress";
				}	getServerData(get_all_drugs_url, total_drugs, drugs_progress_bar, saveDrugsLocally);
			});
		});
	});
	function getServerData(url, total_number, progress_bar, save_locally_callback) {
		var start_point = 0;
		var batch_size = 25;
		var records_retrieved = 0;
		//Create the progress bar
		$.progress_bar(progress_bar);
		//create a variable to store the percentage progress completed
		var percentage = 0;
		//create a loop that will fetch records using predefined batch sizes untill all records have been retrieved
		for( start_point = 0; start_point <= total_number; start_point += batch_size) {
			//Create a new url appending the offset and limit at the end
			var new_url = url + "/" + start_point + "/" + batch_size;
			//Make the get request and pass the results to the callback passed in the arguments. Update the progressbar only if the ajax request completed successfully!
			$.ajaxQueue({
				url : new_url,
				context : document.body,
				success : function(data) {
					save_locally_callback(data);
					//Increment the total number of records retrieved with the size of the batch
					records_retrieved += batch_size;
					//if the total number of batches retrieved are greater than the total number expected, equate the total number retrieved to the total number expected
					if(records_retrieved > total_number) {
						records_retrieved = total_number;
					}
					//Calculate the percentage completion
					percentage = (records_retrieved / total_number) * 100;
					//Update the progress bar
					$.progress_bar(progress_bar, 'update', percentage);
				}
			});

		}

	}

	function saveDrugsLocally(data) {
		//Retrieve the whole array of drugs from the returned json object
		var drugs_array = jQuery.parseJSON(data);
		//Loop through all the drugs in this array to save their details
		$.each(drugs_array, function() {
			var drug_object = this; 
		});
	}
</script>
<style>
	.synchronize_table {
		border: 2px solid #F1F1F1;
		width: 300px;
		height: 150px;
		float: left;
		margin: 10px;
		overflow: hidden;
	}
	.synchronize_table_title {
		font-size: 12px;
		font-weight: bold;
		letter-spacing: 1.5px;
		margin: 5px;
		border-bottom: 2px solid black;
	}
	.canvas {
		width: 300px;
		height: 60px;
	}
</style>
<div id="synchronization_frame">
	<div class="synchronize_table">
		<div class="synchronize_table_title">
			Drugs
		</div>
		<div class="synchronize_table_data">
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number Drugs Locally: <span id="total_drugs_local"></span></span>
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of Drugs in Server: <span id="total_drugs_master"></span></span>
			<canvas id="drugs_progress" class="canvas" width="500" height="150">
				Progressbar Can't Be shown.
			</canvas>
		</div>
	</div>
	<div class="synchronize_table">
		<div class="synchronize_table_title">
			Opportunistic Infections
		</div>
	</div>
	<div class="synchronize_table">
		<div class="synchronize_table_title">
			Patients
		</div>
	</div>
	<div class="synchronize_table">
		<div class="synchronize_table_title">
			Patient Appointments
		</div>
	</div>
	<div class="synchronize_table">
		<div class="synchronize_table_title">
			Patient Sources
		</div>
	</div>
	<div class="synchronize_table">
		<div class="synchronize_table_title">
			Patient Visits
		</div>
	</div>
	<div class="synchronize_table">
		<div class="synchronize_table_title">
			Regimens
		</div>
	</div>
	<div class="synchronize_table">
		<div class="synchronize_table_title">
			Regimen Change Reasons
		</div>
	</div>
	<div class="synchronize_table">
		<div class="synchronize_table_title">
			Drugs in Regimens
		</div>
	</div>
	<div class="synchronize_table">
		<div class="synchronize_table_title">
			Service Types
		</div>
	</div>
	<div class="synchronize_table">
		<div class="synchronize_table_title">
			Visit Purposes
		</div>
	</div>
</div>

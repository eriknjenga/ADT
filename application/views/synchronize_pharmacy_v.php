<script type="text/javascript">
	initDatabase();
	$(document).ready(function() {
		var total_drugs = 0;
		var url = "";
		var sync_div = "";
		var sync_table = "";
		//Create a new queue for all the synchronization functions
		var queue = new Queue([syncDrugs, syncOIs, syncPatientSources, syncRegimens, syncRegimensChangeReasons, syncRegimenDrugs]);
		//Make the first synchronization request
		queue.callNext();
		//Wait for all ajax calls to complete before making the second synchronization request. To prevent an infinite loop, also check that the table that has just been synchronized is not being synchronized again
		$("body").ajaxStop(function() {
			queue.callNext();
		});
	});
	function syncDrugs() {
		synchronizeData("drugcode", "synchronize_pharmacy/getTotalServerDrugs", "synchronize_pharmacy/getDrugs", "#total_drugs_local", "#total_drugs_master", "drugs_progress", "#drugs_sync_complete", saveDrugsLocally);
	}

	function syncOIs() {
		synchronizeData("opportunistic_infections", "synchronize_pharmacy/getTotalServerOIs", "synchronize_pharmacy/getOIs", "#total_ois_local", "#total_ois_master", "ois_progress", "#ois_sync_complete", saveOILocally);
	}

	function syncPatientSources() {
		synchronizeData("patient_source", "synchronize_pharmacy/getTotalServerPatientSources", "synchronize_pharmacy/getPatientSources", "#total_sources_local", "#total_sources_master", "sources_progress", "#sources_sync_complete", savePatientSourcesLocally);
	}

	function syncRegimens() {
		synchronizeData("regimen", "synchronize_pharmacy/getTotalServerRegimens", "synchronize_pharmacy/getRegimens", "#total_regimens_local", "#total_regimens_master", "regimens_progress", "#regimens_sync_complete", saveRegimensLocally);
	}

	function syncRegimensChangeReasons() {
		synchronizeData("regimen_change_purpose", "synchronize_pharmacy/getTotalServerRegimenChangeReasons", "synchronize_pharmacy/getRegimenChangeReasons", "#total_regimen_change_reasons_local", "#total_regimen_change_reasons_master", "regimen_change_reasons_progress", "#regimen_change_reasons_sync_complete", saveRegimenChangeReasonsLocally);
	}

	function syncRegimenDrugs() {
		synchronizeData("regimen_drug", "synchronize_pharmacy/getTotalServerRegimenDrugs", "synchronize_pharmacy/getRegimenDrugs", "#total_regimen_drugs_local", "#total_regimen_drugs_master", "regimen_drugs_progress", "#regimen_drugs_sync_complete", saveRegimenDrugsLocally);
	}

	function synchronizeData(local_table_name, check_total_url, fetch_records_url, local_container, master_container, progress_bar, sync_complete, save_local_function, synchOrder) {

		//assign the sync_div variable to the id of the div tag that will indicate that the sync is complete
		sync_div = sync_complete;
		//assign the sync_table variable to the id of the div tag that is being synchronized
		window.sync_table = "#" + local_table_name;
		//Synchronize the specified table
		countTableRecords(local_table_name, function(transaction, results) {
			var row = results.rows.item(0);
			total_records = row['total'];
			$(local_container).html(total_records);
			$.get(check_total_url, function(data) {
				$(master_container).html(data);
				if(data != total_records) {
					//This means that synchronization is neccessary. Delete all records in the local db before requesting new records
					var delete_query = "delete from " + local_table_name;
					executeStatement(delete_query);
					getServerData(fetch_records_url, data, progress_bar, save_local_function, local_container);
				} else {

					//Do something else when no synchronization is neccessary!
					show_complete(sync_div, sync_table);
				}
			});
		});
		//Create callback that calls the show_complete function when all ajax calls have been completed
		$("body").ajaxStop(function() {
			show_complete(sync_div, sync_table);
		});
	}

	function getServerData(url, total_number, progress_bar, save_locally_callback, local_quantity_div) {
		var start_point = 0;
		var batch_size = 100;
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
					//Update the value in the local_quantity_div to show that all records have now been retrieved.
					$(local_quantity_div).html(records_retrieved);
				}
			});
		}
	}

	function saveDrugsLocally(data) {
		//Retrieve the whole array of drugs from the returned json object
		var drugs_array = jQuery.parseJSON(data);
		//create an array to hold all the sql queries
		var sql_queries = Array();
		var counter = 0;
		//Loop through all the drugs in this array to save their details
		$.each(drugs_array, function() {
			var drug_object = this;
			//Create the insert query
			var query = "insert into drugcode (id, drug, unit, pack_size, safety_quantity, generic_name, supported_by, dose, duration, quantity) values ('" + drug_object['id'] + "','" + drug_object['drug'] + "','" + drug_object['unit'] + "','" + drug_object['pack_size'] + "','" + drug_object['safety_quantity'] + "','" + drug_object['generic_name'] + "','" + drug_object['supported_by'] + "','" + drug_object['dose'] + "','" + drug_object['duration'] + "','" + drug_object['quantity'] + "')";
			sql_queries[counter] = query;
			counter++;
		});
		//Call the execute function that executes batches of queries that are stored in arrays
		executeStatementArray(sql_queries);
	}

	function saveOILocally(data) {
		//Retrieve the whole array of ois from the returned json object
		var ois_array = jQuery.parseJSON(data);
		//create an array to hold all the sql queries
		var sql_queries = Array();
		var counter = 0;
		//Loop through all the drugs in this array to save their details
		$.each(ois_array, function() {
			var oi_object = this;
			//Create the insert query
			var query = "insert into opportunistic_infections (id, name) values ('" + oi_object['id'] + "','" + oi_object['name'] + "')";
			sql_queries[counter] = query;
			counter++;
		});
		//Call the execute function that executes batches of queries that are stored in arrays
		executeStatementArray(sql_queries);
	}

	function savePatientSourcesLocally(data) {
		//Retrieve the whole array of ois from the returned json object
		var sources_array = jQuery.parseJSON(data);
		//create an array to hold all the sql queries
		var sql_queries = Array();
		var counter = 0;
		//Loop through all the drugs in this array to save their details
		$.each(sources_array, function() {
			var source_object = this;
			//Create the insert query
			var query = "insert into patient_source (id, name) values ('" + source_object['id'] + "','" + source_object['name'] + "')";
			sql_queries[counter] = query;
			counter++;
		});
		//Call the execute function that executes batches of queries that are stored in arrays
		executeStatementArray(sql_queries);
	}

	function saveRegimensLocally(data) {
		//Retrieve the whole array of regimens from the returned json object
		var regimens_array = jQuery.parseJSON(data);
		//create an array to hold all the sql queries
		var sql_queries = Array();
		var counter = 0;
		//Loop through all the regimens in this array to save their details
		$.each(regimens_array, function() {
			var regimen_object = this;
			//Create the insert query
			var query = "insert into regimen (id, regimen_code, regimen_desc, category, line, type_of_service, remarks) values ('" + regimen_object['id'] + "','" + regimen_object['regimen_code'] + "','" + regimen_object['regimen_desc'] + "','" + regimen_object['category'] + "','" + regimen_object['line'] + "','" + regimen_object['type_of_service'] + "','" + regimen_object['remarks'] + "')";
			sql_queries[counter] = query;
			counter++;
		});
		//Call the execute function that executes batches of queries that are stored in arrays
		executeStatementArray(sql_queries);
	}

	function saveRegimenChangeReasonsLocally(data) {
		//Retrieve the whole array of purposes from the returned json object
		var purposes_array = jQuery.parseJSON(data);
		//create an array to hold all the sql queries
		var sql_queries = Array();
		var counter = 0;
		//Loop through all the purposes in this array to save their details
		$.each(purposes_array, function() {
			var purpose_object = this;
			//Create the insert query
			var query = "insert into regimen_change_purpose (id, name) values ('" + purpose_object['id'] + "','" + purpose_object['name'] + "')";
			sql_queries[counter] = query;
			counter++;
		});
		//Call the execute function that executes batches of queries that are stored in arrays
		executeStatementArray(sql_queries);
	}

	function saveRegimenDrugsLocally(data) {
		//Retrieve the whole array of regimen drugs from the returned json object
		var regimen_drugs_array = jQuery.parseJSON(data);
		//create an array to hold all the sql queries
		var sql_queries = Array();
		var counter = 0;
		//Loop through all the combinations in this array to save their details
		$.each(regimen_drugs_array, function() {
			var regimen_drugs_object = this;
			//Create the insert query
			var query = "insert into regimen_drug (id, regimen, drugcode) values ('" + regimen_drugs_object['id'] + "','" + regimen_drugs_object['regimen'] + "','" + regimen_drugs_object['drugcode'] + "')";
			sql_queries[counter] = query;
			counter++;
		});
		//Call the execute function that executes batches of queries that are stored in arrays
		executeStatementArray(sql_queries);
	}

	function show_complete(sync_div, sync_table) {
		$(sync_div).css("display", "block");
		$(sync_table).css("border-color", "#17C700");
		$(sync_table).css("border-width", "2px");
		$(sync_table).animate({
			opacity : 0.3,
		}, 3000);
	}

	function Queue(arr) {
		var i = 0;
		this.callNext = function() { typeof arr[i] == 'function' && arr[i++]();
		};
	}
</script>
<style>
	.synchronize_table {
		border: 3px solid #CF0000;
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
	<div class="synchronize_table" id="drugcode">
		<div class="synchronize_table_title">
			Drugs
		</div>
		<div class="synchronize_table_data" >
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of Drugs Locally: <span id="total_drugs_local"></span></span>
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of Drugs in Server: <span id="total_drugs_master"></span></span>
			<span style="display: block; font-size: 12px; margin: 5px; color:green; display: none;" id="drugs_sync_complete">Synchronization Complete!</span>
			<canvas id="drugs_progress" class="canvas" width="500" height="150">
				Progressbar Can't Be shown.
			</canvas>
		</div>
	</div>
	<div class="synchronize_table" id="opportunistic_infections">
		<div class="synchronize_table_title">
			Opportunistic Infections
		</div>
		<div class="synchronize_table_data" >
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of OIs Locally: <span id="total_ois_local"></span></span>
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of OIs in Server: <span id="total_ois_master"></span></span>
			<span style="display: block; font-size: 12px; margin: 5px; color:green; display: none;" id="ois_sync_complete">Synchronization Complete!</span>
			<canvas id="ois_progress" class="canvas" width="500" height="150">
				Progressbar Can't Be shown.
			</canvas>
		</div>
	</div>
	<div class="synchronize_table" id="patient_source">
		<div class="synchronize_table_title">
			Patient Sources
		</div>
		<div class="synchronize_table_data" >
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of Sources Locally: <span id="total_sources_local"></span></span>
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of Sources in Server: <span id="total_sources_master"></span></span>
			<span style="display: block; font-size: 12px; margin: 5px; color:green; display: none;" id="sources_sync_complete">Synchronization Complete!</span>
			<canvas id="sources_progress" class="canvas" width="500" height="150">
				Progressbar Can't Be shown.
			</canvas>
		</div>
	</div>
	<div class="synchronize_table" id="regimen">
		<div class="synchronize_table_title">
			Regimens
		</div>
		<div class="synchronize_table_data" >
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of Regimens Locally: <span id="total_regimens_local"></span></span>
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of Regimens in Server: <span id="total_regimens_master"></span></span>
			<span style="display: block; font-size: 12px; margin: 5px; color:green; display: none;" id="regimens_sync_complete">Synchronization Complete!</span>
			<canvas id="regimens_progress" class="canvas" width="500" height="150">
				Progressbar Can't Be shown.
			</canvas>
		</div>
	</div>
	<div class="synchronize_table" id="regimen_change_purpose">
		<div class="synchronize_table_title">
			Regimen Change Reasons
		</div>
		<div class="synchronize_table_data" >
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of Regimens-Change Reasons Locally: <span id="total_regimen_change_reasons_local"></span></span>
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of Regimens-Change Reasons in Server: <span id="total_regimen_change_reasons_master"></span></span>
			<span style="display: block; font-size: 12px; margin: 5px; color:green; display: none;" id="regimen_change_reasons_sync_complete">Synchronization Complete!</span>
			<canvas id="regimen_change_reasons_progress" class="canvas" width="500" height="150">
				Progressbar Can't Be shown.
			</canvas>
		</div>
	</div>
	<div class="synchronize_table" id="regimen_drug">
		<div class="synchronize_table_title">
			Drugs in Regimen
		</div>
		<div class="synchronize_table_data" >
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of Regimen-Drug Pairs Locally: <span id="total_regimen_drugs_local"></span></span>
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of Regimen-Drug Pairs in Server: <span id="total_regimen_drugs_master"></span></span>
			<span style="display: block; font-size: 12px; margin: 5px; color:green; display: none;" id="regimen_drugs_sync_complete">Synchronization Complete!</span>
			<canvas id="regimen_drugs_progress" class="canvas" width="500" height="150">
				Progressbar Can't Be shown.
			</canvas>
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
			Patient Visits
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

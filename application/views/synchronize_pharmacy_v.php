<script type="text/javascript">
	initDatabase();
	$(document).ready(function() {
		//Create array to contain all json data returned
		var total_drugs = 0;
		var url = "";
		var sync_div = "";
		var sync_table = "";
		patient_json_array = [];
		patient_appointment_json_array = [];
		patient_visit_json_array = [];

		//Create a new queue for all the synchronization functions
		var queue = new Queue([syncPatientVisits]);
		//var queue = new Queue([syncDrugs, syncOIs, syncPatientSources, syncRegimens, syncRegimensChangeReasons, syncRegimenDrugs, syncServiceTypes, syncVisitPurposes, syncPatientStatuses, syncPatients,syncPatientAppointments]);
		//Make the first synchronization request
		queue.callNext();
		//Wait for all ajax calls to complete before making the second synchronization request. To prevent an infinite loop, also check that the table that has just been synchronized is not being synchronized again
		$("body").ajaxStop(function() {
			queue.callNext();
			//If the patient array is full
			if(patient_json_array.length > 0) {
				///alert(json_array.length);
				savePatientDataLocally(patient_json_array);
				patient_json_array = [];
				//console.log(json_array);
			}
			if(patient_appointment_json_array.length > 0) {
				///alert(json_array.length);
				savePatientAppointmentDataLocally(patient_appointment_json_array);
				patient_appointment_json_array = [];
				//console.log(json_array);
			}
			if(patient_visit_json_array.length > 0) {
				///alert(json_array.length);
				savePatientVisitDataLocally(patient_visit_json_array);
				patient_visit_json_array = [];
				//console.log(json_array);
			}

		});
	});
	function syncPatients() {
		var check_total_records_url = "synchronize_pharmacy/check_patient_numbers/";
		var table = "patient";
		var total_local_records_container = "#total_patients_local";
		var total_master_records_container = "#total_patients_master";
		var get_data_url = "synchronize_pharmacy/getPatients/";
		var progress_bar = "patients_progress";
		var sync_complete_container = "#patients_sync_complete";
		var table_name = "#patient";
		getLastMachineCodeRecords(function(transaction, results) {
			var post_data = "machine_codes=";
			for(var i = 0; i < results.rows.length; i++) {
				var row = results.rows.item(i);
				post_data += row['machine_code'] + ":" + row['patient_number_ccc'] + ",";
			}
			advancedSync(check_total_records_url, table, total_local_records_container, total_master_records_container, post_data, get_data_url, progress_bar, sync_complete_container, table_name, patient_json_array);
		});
	}

	function syncPatientAppointments() {
		var check_total_records_url = "synchronize_pharmacy/check_patient_appointment_numbers/";
		var table = "patient_appointment";
		var total_local_records_container = "#total_appointments_local";
		var total_master_records_container = "#total_appointments_master";
		var get_data_url = "synchronize_pharmacy/getPatientAppointments/";
		var progress_bar = "appointments_progress";
		var sync_complete_container = "#appointments_sync_complete";
		var table_name = "#patient_appointment";
		getLastAppointmentData(function(transaction, results) {
			var post_data = "machine_codes=";
			for(var i = 0; i < results.rows.length; i++) {
				var row = results.rows.item(i);
				post_data += row['machine_code'] + ":" + row['patient'] + ":" + row['appointment'] + ",";
			}
			advancedSync(check_total_records_url, table, total_local_records_container, total_master_records_container, post_data, get_data_url, progress_bar, sync_complete_container, table_name, patient_appointment_json_array);
		});
	}

	function syncPatientVisits() {
		var check_total_records_url = "synchronize_pharmacy/check_patient_visit_numbers/";
		var table = "patient_visit";
		var total_local_records_container = "#total_visits_local";
		var total_master_records_container = "#total_visits_master";
		var get_data_url = "synchronize_pharmacy/getPatientVisits/";
		var progress_bar = "visits_progress";
		var sync_complete_container = "#visits_sync_complete";
		var table_name = "#patient_visit";
		getLastVisitData(function(transaction, results) {
			var post_data = "machine_codes=";
			for(var i = 0; i < results.rows.length; i++) {
				var row = results.rows.item(i);
				post_data += row['machine_code'] + ":" + row['patient_id'] + ":" + row['dispensing_date'] + ",";
			}
			advancedSync(check_total_records_url, table, total_local_records_container, total_master_records_container, post_data, get_data_url, progress_bar, sync_complete_container, table_name, patient_visit_json_array);
		});
	}

	function advancedSync(check_total_records_url, table, total_local_records_container, total_master_records_container, post_data, get_data_url, progress_bar, sync_complete_container, table_name, json_data_array) {
		var facility = "";
		var machine_code = "";
		//Retrieve the environment variables
		selectEnvironmentVariables(function(transaction, results) {
			var variables = results.rows.item(0);
			machine_code = variables["machine_id"];
			facility = variables["facility"];
		});
		countTableRecords(table, function(transaction, results) {
			var row = results.rows.item(0);
			total_local_records = row['total'];
			//Create the url to be used in the ajax call
			url = check_total_records_url + facility;
			$.ajaxQueue({
				url : url,
				context : document.body,
				success : function(data) {
					var total_server_records = data;
					$(total_local_records_container).html(total_local_records);
					$(total_master_records_container).html(total_server_records);

					if(total_server_records != total_local_records) {
						//Make post request to get any new records. The data in the post request is the string with machine codes
						url = get_data_url + facility;
						var start_point = 0;
						var batch_size = 500;
						var records_retrieved = total_local_records;
						//create a variable to store the percentage progress completed
						var percentage = 0;
						//total_server_patients = 0;
						//Get the number of records required
						var total_required = total_server_records - total_local_records;
						//create a loop that will fetch records using predefined batch sizes untill all records have been retrieved
						for( start_point = 0; start_point <= total_required; start_point += batch_size) {
							//Create a new url appending the offset and limit at the end
							var new_url = url + "/" + start_point + "/" + batch_size;
							//Make the get request and pass the results to the callback passed in the arguments. Update the progressbar only if the ajax request completed successfully!
							$.ajaxQueue({
								url : new_url,
								type : "POST",
								data : post_data,
								context : document.body,
								success : function(data) {
									$.merge(json_data_array, jQuery.parseJSON(data));
									//Increment the total number of records retrieved with the size of the batch
									records_retrieved += batch_size;
									//if the total number of batches retrieved are greater than the total number expected, equate the total number retrieved to the total number expected
									if(records_retrieved > total_required) {
										records_retrieved = total_required;
									}
									//Calculate the percentage completion
									percentage = (records_retrieved / total_required) * 100;
									//Update the progress bar
									$.progress_bar(progress_bar, 'update', percentage);
									//Update the value in the local_quantity_div to show that all records have now been retrieved.
									$(total_local_records_container).html(records_retrieved + total_local_records);
								}
							});
						}
					}
				}
			});
		});
		//Create callback that calls the show_complete function when all ajax calls have been completed
		$("body").ajaxStop(function() {
			show_complete(sync_complete_container, table_name);
		});
	}

	function savePatientDataLocally(data) {
		var columns = Array("medical_record_number", "patient_number_ccc", "first_name", "last_name", "other_name", "dob", "pob", "gender", "pregnant", "weight", "height", "sa", "phone", "physical", "alternate", "other_illnesses", "other_drugs", "adr", "tb", "smoke", "alcohol", "date_enrolled", "source", "supported_by", "timestamp", "facility_code", "service", "start_regimen", "machine_code");
		parseReturnedData(data, "patient", columns, true);
	}

	function savePatientAppointmentDataLocally(data) {
		var columns = Array("patient", "machine_code", "appointment");
		parseReturnedData(data, "patient_appointment", columns, true);
	}

	function savePatientVisitDataLocally(data) {
		var columns = Array("patient_id", "visit_purpose", "current_height", "current_weight", "regimen", "regimen_change_reason", "drug_id", "batch_number", "brand", "indication", "pill_count", "comment", "timestamp", "user", "facility", "dose", "dispensing_date", "dispensing_date_timestamp", "machine_code", "quantity");
		parseReturnedData(data, "patient_visit", columns, true);
	}

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

	function syncServiceTypes() {
		synchronizeData("regimen_service_type", "synchronize_pharmacy/getTotalServerRegimenServiceTypes", "synchronize_pharmacy/getRegimenServiceTypes", "#total_service_types_local", "#total_service_types_master", "service_types_progress", "#service_types_sync_complete", saveRegimenServiceTypesLocally);
	}

	function syncVisitPurposes() {
		synchronizeData("visit_purpose", "synchronize_pharmacy/getTotalServerVisitPurposes", "synchronize_pharmacy/getVisitPurposes", "#total_visit_purposes_local", "#total_visit_purposes_master", "visit_purposes_progress", "#visit_purposes_sync_complete", saveVisitPurposesLocally);
	}

	function syncPatientStatuses() {
		synchronizeData("patient_status", "synchronize_pharmacy/getTotalServerPatientStatuses", "synchronize_pharmacy/getPatientStatuses", "#total_patient_statuses_local", "#total_patient_statuses_master", "patient_statuses_progress", "#patient_statuses_sync_complete", savePatientStatusesLocally);
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
			$.ajaxQueue({
				url : check_total_url,
				context : document.body,
				success : function(data) {
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
		var columns = Array("id", "drug", "unit", "pack_size", "safety_quantity", "generic_name", "supported_by", "dose", "duration", "quantity");
		parseReturnedData(data, "drugcode", columns, false);
	}

	function saveOILocally(data) {
		var columns = Array("id", "name");
		parseReturnedData(data, "opportunistic_infections", columns, false);
	}

	function savePatientSourcesLocally(data) {
		var columns = Array("id", "name");
		parseReturnedData(data, "patient_source", columns, false);
	}

	function saveRegimensLocally(data) {
		var columns = Array("id", "regimen_code", "regimen_desc", "category", "line", "type_of_service", "remarks");
		parseReturnedData(data, "regimen", columns, false);
	}

	function saveRegimenChangeReasonsLocally(data) {
		var columns = Array("id", "name");
		parseReturnedData(data, "regimen_change_purpose", columns, false);
	}

	function saveRegimenDrugsLocally(data) {
		var columns = Array("id", "regimen", "drugcode");
		parseReturnedData(data, "regimen_drug", columns, false);
	}

	function saveRegimenServiceTypesLocally(data) {
		var columns = Array("id", "name");
		parseReturnedData(data, "regimen_service_type", columns, false);
	}

	function saveVisitPurposesLocally(data) {
		var columns = Array("id", "name");
		parseReturnedData(data, "visit_purpose", columns, false);
	}

	function savePatientStatusesLocally(data) {
		var columns = Array("id", "name");
		parseReturnedData(data, "patient_status", columns, false);
	}

	function parseReturnedData(data, table_name, columns_array, patient_data) {
		//Retrieve the whole array of key-value pairs from the returned json object
		if(patient_data) {
			var json_data = data;
		} else {
			var json_data = jQuery.parseJSON(data);
		}
		//create an array to hold all the sql queries
		var sql_queries = Array();
		var counter = 0;
		//Loop through all the table_rows in this array to save their details
		$.each(json_data, function() {
			var table_row = this;
			//Create the insert query
			var query = "insert into " + table_name + " (";

			for(column in columns_array) {
				query += columns_array[column] + " ,";
			}
			query = query.substring(0, query.length - 1);
			query += ") values (";
			for(column in columns_array) {
				if(table_row[columns_array[column]]) {
					query += " '" + table_row[columns_array[column]].replace("'", "''") + "',";
				} else {
					query += " '" + table_row[columns_array[column]] + "',";
				}
			}
			query = query.substring(0, query.length - 1);
			query += ");";
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
	<div class="synchronize_table" id="regimen_service_type">
		<div class="synchronize_table_title">
			Service Types
		</div>
		<div class="synchronize_table_data" >
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of Service Types Locally: <span id="total_service_types_local"></span></span>
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of Service Types in Server: <span id="total_service_types_master"></span></span>
			<span style="display: block; font-size: 12px; margin: 5px; color:green; display: none;" id="service_types_sync_complete">Synchronization Complete!</span>
			<canvas id="service_types_progress" class="canvas" width="500" height="150">
				Progressbar Can't Be shown.
			</canvas>
		</div>
	</div>
	<div class="synchronize_table" id="visit_purpose">
		<div class="synchronize_table_title">
			Visit Purposes
		</div>
		<div class="synchronize_table_data" >
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of Visit Purposes Locally: <span id="total_visit_purposes_local"></span></span>
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of Visit Purposes in Server: <span id="total_visit_purposes_master"></span></span>
			<span style="display: block; font-size: 12px; margin: 5px; color:green; display: none;" id="visit_purposes_sync_complete">Synchronization Complete!</span>
			<canvas id="visit_purposes_progress" class="canvas" width="500" height="150">
				Progressbar Can't Be shown.
			</canvas>
		</div>
	</div>
	<div class="synchronize_table" id="patient_status">
		<div class="synchronize_table_title">
			Patient Status
		</div>
		<div class="synchronize_table_data" >
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of Patient Statuses Locally: <span id="total_patient_statuses_local"></span></span>
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of Patient Statues in Server: <span id="total_patient_statuses_master"></span></span>
			<span style="display: block; font-size: 12px; margin: 5px; color:green; display: none;" id="patient_statuses_sync_complete">Synchronization Complete!</span>
			<canvas id="patient_statuses_progress" class="canvas" width="500" height="150">
				Progressbar Can't Be shown.
			</canvas>
		</div>
	</div>
	<div class="synchronize_table" id="patient">
		<div class="synchronize_table_title">
			Facility Patients
		</div>
		<div class="synchronize_table_data" >
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of Patients Saved Locally: <span id="total_patients_local"></span></span>
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of Drugs in Server: <span id="total_patients_master"></span></span>
			<span style="display: block; font-size: 12px; margin: 5px; color:green; display: none;" id="patients_sync_complete">Synchronization Complete!</span>
			<canvas id="patients_progress" class="canvas" width="500" height="150">
				Progressbar Can't Be shown.
			</canvas>
		</div>
	</div>
	<div class="synchronize_table" id="patient_appointment">
		<div class="synchronize_table_title">
			Patient Appointments
		</div>
		<div class="synchronize_table_data" >
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of Appointments Saved Locally: <span id="total_appointments_local"></span></span>
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of Appointments in Server: <span id="total_appointments_master"></span></span>
			<span style="display: block; font-size: 12px; margin: 5px; color:green; display: none;" id="appointments_sync_complete">Synchronization Complete!</span>
			<canvas id="appointments_progress" class="canvas" width="500" height="150">
				Progressbar Can't Be shown.
			</canvas>
		</div>
	</div>
	<div class="synchronize_table" id="patient_visit">
		<div class="synchronize_table_title">
			Patient Visits
		</div>
		<div class="synchronize_table_data" >
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of Visits Saved Locally: <span id="total_visits_local"></span></span>
			<span style="display: block; font-size: 12px; margin: 20px 5px;">Number of Visits in Server: <span id="total_visits_master"></span></span>
			<span style="display: block; font-size: 12px; margin: 5px; color:green; display: none;" id="visits_sync_complete">Synchronization Complete!</span>
			<canvas id="visits_progress" class="canvas" width="500" height="150">
				Progressbar Can't Be shown.
			</canvas>
		</div>
	</div>
</div>

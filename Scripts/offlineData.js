//main function to be called on submit
function processData(button) {
	var form = button.attr("form");
	var form_selector = "#" + form;
	var validated = $(form_selector).validationEngine('validate');
	//var validated = true;
	if(validated) {
		var target = '';
		var local_table = '';
		var facility = "";
		var user = "";
		var machine_code = "";
		//Retrieve the environment variables
		selectEnvironmentVariables(function(transaction, results) {
			var variables = results.rows.item(0);
			machine_code = variables["machine_id"];
			facility = variables["facility"];
			user = variables['operator'];

			if(form == "add_patient_form") {
				target = "patient_management/save";
				local_table = 'patient';
				var dump = retrieveFormValues();
				var beast=retrieveSelectedFormValues_Array("plan_listing");
				var beast1=retrieveSelectedFormValues_Array("other_illnesses_listing");
				//Retrieve all form input elements and their values
               
				var patient_number = dump["patient_number"];
				getPatientDetails(patient_number, function(transaction, results) {
					if(results.rows.length > 0) {
						alert("patient number id already exists");
						return
					} else {
						
						var timestamp = new Date().getTime();
						var sql = "INSERT INTO patient (medical_record_number, patient_number_ccc, first_name, last_name, other_name, dob, pob, gender, pregnant," + " weight, height, sa, phone, physical, alternate, other_illnesses, other_drugs, adr, tb, smoke, alcohol, date_enrolled, source, supported_by," + " timestamp, facility_code, service, start_regimen, machine_code,sms_consent,partner_status,fplan,tbphase,startphase,endphase,partner_type) VALUES ('" + dump["medical_record_number"] + "', '" + dump["patient_number"] + "', '" + dump["first_name"] + "', '" + dump["last_name"] + "', '" + dump["other_name"] + "', '" + dump["dob"] + "', '" + dump["pob"] + "', '" + dump["gender"] + "', '" + dump["pregnant"] + "', '" + dump["weight"] + "', '" + dump["height"] + "', '" + dump["surface_area"] + "', '" + dump["phone"] + "', '" + dump["physical"] + "', '" + dump["alternate"] + "', '" + beast1 + "', '" + dump["other_drugs"] + "', '" + dump["other_allergies_listing"] + "', '" + dump["tb"] + "', '" + dump["smoke"] + "', '" + dump["alcohol"] + "', '" + dump["enrolled"] + "', '" + dump["source"] + "', '" + dump["support"] + "', '" + timestamp + "','" + facility + "', '" + dump["service"] + "', '" + dump["regimen"] + "','" + machine_code + "','" + dump["sms_consent"] + "','" + dump["pstatus"] + "','" + beast + "','" + dump["tbphase"] + "','" + dump["fromphase"] + "','" + dump["tophase"] + "','" + dump["disco"] + "');";
						var url = "";
						if(button.attr("id") == "dispense") {
							url = "dispense.html?patient_number=" + dump["patient_number"];
						} else {
							url = "patient_management.html?message=Patient record for " + dump["first_name"] + " " + dump["last_name"] + " saved successfully";
						}
						var combined_object = {
							0 : target,
							1 : sql,
							2 : timestamp,
							3 : local_table,
							4 : url
						};
						var saved_object = JSON.stringify(combined_object);
						saveDataLocally(saved_object);

					}
				});
				//redirect();

			} else if(form == "dispense_form") {
				var timestamp = new Date().getTime();
				target = "dispensement_management/save";
				local_table = 'patient_visit';
				//Before going any further, first calculate the number of drugs being dispensed
				var drugs_count = 0;
				$.each($(".drug"), function(i, v) {
					if($(this).attr("value")) {
						drugs_count++;
					}
				});
				//If no drugs were dispensed, exit
				if(drugs_count == 0) {
					return;
				}
				//Retrieve all form input elements and their values
				var dump = retrieveFormValues();
				//Call this function to do a special retrieve function for elements with several values
				var drugs = retrieveFormValues_Array('drug');
				var batches = retrieveFormValues_Array('batch');
				var doses = retrieveFormValues_Array('dose');
				var brands = retrieveFormValues_Array('brand');
				var indications = retrieveFormValues_Array('indication');
				var pill_counts = retrieveFormValues_Array('pill_count');
				var comments = retrieveFormValues_Array('comment');
				var missed_pills = retrieveFormValues_Array('missed_pills');
				var quantities = retrieveFormValues_Array('qty_disp');
				var durations = retrieveFormValues_Array('duration');
				var next_appointment_sql = "";
				var dispensing_date_timestamp = Date.parse(dump["dispensing_date"]);
				//Check if there is a date indicated for the next appointment. If there is, schedule it!
				if($("#next_appointment_date").attr("value").length > 1) {
					next_appointment_sql = "insert into patient_appointment (patient,appointment,facility,machine_code) values ('" + dump["patient"] + "','" + dump["next_appointment_date"] + "','" + facility + "','" + machine_code + "');";
				}
				var sql = next_appointment_sql;
				//After getting the number of drugs issued, create a unique entry (sql statement) for each in the database in this loop
				for(var i = 0; i < drugs_count; i++) {
					sql += "INSERT INTO patient_visit (patient_id, visit_purpose, current_height, current_weight, regimen, regimen_change_reason, drug_id, batch_number, brand, indication, pill_count, comment, timestamp, user, facility, dose, dispensing_date, dispensing_date_timestamp,machine_code,quantity,duration,months_of_stock,adherence,missed_pills) VALUES ('" + dump["patient"] + "', '" + dump["purpose"] + "', '" + dump["height"] + "', '" + dump["weight"] + "', '" + dump["current_regimen"] + "', '" + dump["regimen_change_reason"] + "', '" + drugs[i] + "', '" + batches[i] + "', '" + brands[i] + "', '" + indications[i] + "', '" + pill_counts[i] + "', '" + comments[i] + "', '" + timestamp + "', '" + user + "', '" + facility + "', '" + doses[i] + "', '" + dump["dispensing_date"] + "', '" + dispensing_date_timestamp + "','" + machine_code + "','" + quantities[i] + "','" + durations[i] + "','" + dump["months_of_stock"] + "','" + dump["adherence"] + "','" + missed_pills[i] + "');";

				};
				console.log(sql);
				var url = "patient_management.html?message=Dispensing data for " + dump['patient'] + " saved successfully";
				var combined_object = {
					0 : target,
					1 : sql,
					2 : timestamp,
					3 : local_table,
					4 : url
				};
				var saved_object = JSON.stringify(combined_object);
				saveDataLocally(saved_object);
			} else if(form == "stock_form") {
				var timestamp = new Date().getTime();
				local_table = 'drug_stock_movement';
				//Before going any further, first calculate the number of drugs being recorded
				var drugs_count = 0;
				$.each($(".drug"), function(i, v) {
					if($(this).attr("value")) {
						drugs_count++;
					}
				});
				//If no drugs were dispensed, exit
				if(drugs_count == 0) {
					return;
				}
				//Retrieve all form input elements and their values
				var dump = retrieveFormValues();
				//Call this function to do a special retrieve function for elements with several values
				var drugs = retrieveFormValues_Array('drug');
				var batches = retrieveFormValues_Array('batch');
				var expiries = retrieveFormValues_Array('expiry');
				var quantities = retrieveFormValues_Array('quantity');
				var packs = retrieveFormValues_Array('pack');
				var unit_costs = retrieveFormValues_Array('unit_cost');
				var comments = retrieveFormValues_Array('comment');
				var amounts = retrieveFormValues_Array('amount');

				//After getting the number of drugs being recorded, create a unique entry (sql statement) for each in the database in this loop
				var sql_queries = "";
				for(var i = 0; i < drugs_count; i++) {
					var sql = "INSERT INTO drug_stock_movement (drug, transaction_date, batch_number, transaction_type, source, destination, expiry_date, packs,quantity, unit_cost, amount, remarks, operator, order_number) VALUES ('" + drugs[i] + "', '" + dump["transaction_date"] + "', '" + batches[i] + "', '" + dump["transaction_type"] + "', '" + dump["source"] + "', '" + dump["destination"] + "', '" + expiries[i] + "', '" + packs[i] + "', '" + quantities[i] + "', '" + unit_costs[i] + "', '" + amounts[i] + "', '" + comments[i] + "','" + user + "','" + dump["reference_number"] + "');";
					sql_queries += sql;
				};
				var queries = sql_queries.split(";");
				callbackExecuteStatementArray(queries, function(transaction, resultset) {
					window.location = "inventory.html?message=Stock inventory data saved successfully";
				});
				return;

			} else if(form == "edit_patient_form") {
				target = "patient_management/save";
				local_table = 'patient';
				var dump = retrieveFormValues();
				var beast2=retrieveSelectedFormValues_Array("theplan");
				var beast3=retrieveSelectedFormValues_Array("other_illnesses_listing");
				var timestamp = new Date().getTime();
				//Check if there is a date indicated for the next appointment. If there is, schedule it!
				next_appointment_sql = "update patient_appointment set appointment = '" + dump["next_appointment_date"] + "' where patient = '" + dump["patient_number"] + "' and facility = '" + facility + "' and appointment = '" + dump["next_appointment_date_holder"] + "';";

				var sql = "UPDATE patient SET medical_record_number='" + dump["medical_record_number"] + "', first_name='" + dump["first_name"] + "', last_name='" + dump["last_name"] + "', other_name='" + dump["other_name"] + "', dob='" + dump["dob"] + "', pob='" + dump["pob"] + "', gender='" + dump["gender"] + "', pregnant='" + dump["pregnant"] + "',weight='" + dump["weight"] + "', height='" + dump["height"] + "', sa='" + dump["surface_area"] + "', phone='" + dump["phone"] + "', physical='" + dump["physical"] + "', alternate='" + dump["alternate"] + "', other_illnesses='" + beast3 + "', other_drugs='" + dump["other_drugs"] + "', adr='" + dump["other_allergies_listing"] + "', tb='" + dump["tb"] + "', smoke='" + dump["smoke"] + "', alcohol='" + dump["alcohol"] + "', date_enrolled='" + dump["enrolled"] + "', source='" + dump["source"] + "', supported_by='" + dump["support"] + "',timestamp='" + timestamp + "',service='" + dump["service"] + "', start_regimen='" + dump["regimen"] + "', start_regimen_date='" + dump["service_started"] + "', machine_code='" + machine_code + "', sms_consent='" + dump["sms_consent"] + "', current_status='" + dump["current_status"] + "',partner_status='" + dump["partner_status"] + "',fplan='" + beast2+ "',tbphase='" + dump["tbphase"] + "',startphase='" + dump["fromphase"] + "',endphase='" + dump["tophase"] + "',partner_type='" + dump["disco"] + "'  WHERE patient_number_ccc='" + dump["patient_number"] + "' AND facility_code='" + facility + "';";
				sql += next_appointment_sql;
				console.log(sql);
				var combined_object = {
					0 : target,
					1 : sql,
					2 : timestamp,
					3 : local_table,
					4 : "patient_management.html?message=Edited Data for " + dump['patient_number'] + " saved successfully"
				};
				var saved_object = JSON.stringify(combined_object);
				saveDataLocally(saved_object);
			} else if(form == "edit_dispense_form") {
				target = "dispensement_management/save_edit";
				local_table = 'patient_visit';
				var dump = retrieveFormValues();
				var timestamp = new Date().getTime();
				var redirect_url = "";
				if(dump["delete_trigger"] == "1") {
					var sql = "delete from patient_visit WHERE patient_id='" + dump["patient"] + "' AND facility='" + facility + "' and dispensing_date='" + dump["original_dispensing_date"] + "' and drug_id='" + dump["original_drug"] + "';";
					redirect_url = "patient_management.html?message=Dispensing Data for " + dump['patient'] + " deleted successfully";
				} else {
					var sql = "UPDATE patient_visit SET dispensing_date = '" + dump["dispensing_date"] + "', visit_purpose = '" + dump["purpose"] + "', current_weight='" + dump["weight"] + "', current_height='" + dump["height"] + "', regimen='" + dump["current_regimen"] + "', drug_id='" + dump["drug"] + "', batch_number='" + dump["batch"] + "', dose='" + dump["dose"] + "', duration='" + dump["duration"] + "', quantity='" + dump["qty_disp"] + "', brand='" + dump["brand"] + "', indication='" + dump["indication"] + "', pill_count='" + dump["pill_count"] + "', comment='" + dump["comment"] + "' WHERE patient_id='" + dump["patient"] + "' AND facility='" + facility + "' and dispensing_date='" + dump["original_dispensing_date"] + "' and drug_id='" + dump["original_drug"] + "';";
					redirect_url = "patient_management.html?message=Edited Dispensing Data for " + dump['patient'] + " saved successfully";
				}

				//console.log(sql);
				var combined_object = {
					0 : target,
					1 : sql,
					2 : timestamp,
					3 : local_table,
					4 : redirect_url
				};
				var saved_object = JSON.stringify(combined_object);
				saveDataLocally(saved_object);

			}
		});
		//end environmental variables callback
	}
}

function retrieveFormValues() {
	//This function loops the whole form and saves all the input, select, e.t.c. elements with their corresponding values in a javascript array for processing
	var dump = Array;
	$.each($("input, select, textarea"), function(i, v) {
		var theTag = v.tagName;
		var theElement = $(v);
		var theValue = theElement.val();
		if(theElement.attr('type') == "radio") {
			var text = 'input:radio[name=' + theElement.attr('name') + ']:checked';
			dump[theElement.attr("name")] = $(text).attr("value");
		} else {
			dump[theElement.attr("name")] = theElement.attr("value");
		}
	});
	return dump;
}

function retrieveFormValues_Array(name) {
	var dump = new Array();
	var counter = 0;
	$.each($("input[name=" + name + "], select[name=" + name + "], select[name=" + name + "]"), function(i, v) {
		var theTag = v.tagName;
		var theElement = $(v);
		var theValue = theElement.val();
		dump[counter] = theElement.attr("value");
		counter++;
	});
	return dump;
}

function retrieveSelectedFormValues_Array(name) {
	var dump = new Array();
	var counter = 0;
	$.each($("input[name=" + name + "]:checked, select[name=" + name + "]:checked, select[name=" + name + "]:checked"), function(i, v) {
		var theTag = v.tagName;
		var theElement = $(v);
		var theValue = theElement.val();
		dump[counter] = theElement.attr("value");
		counter++;
	});
	return dump;
}

//called on submit if device is online from processData()
function sendDataToServer(data) {
	var separated_data = JSON.parse(data);
	var dataString = separated_data[1];
	var target = separated_data[0];
	var local_timestamp = separated_data[2];
	var local_table = separated_data[3];
	$.post(target, {
		sql : dataString
	}, function(data_returned) {
		console.log('Sent to server: ' + dataString + '');
		window.localStorage.removeItem(local_timestamp);
	});
}

//called on submit if device is offline from processData()
function saveDataLocally(data) {

	var separated_data = JSON.parse(data);
	var sql = separated_data[1];
	var timestamp = separated_data[2];
	var url = separated_data[4];

	var length = window.localStorage.length;
	document.querySelector('#local-count').innerHTML = length;
	var queries = sql.split(";");
	callbackExecuteStatementArray(queries, function(transaction, resultset) {

		//alert(transaction);
		localStorage.setItem(timestamp, data);
		window.location = url;

	});
	//
}

//called if device goes online or when app is first loaded and device is online
//only sends data to server if locally stored data exists
function sendLocalDataToServer() {

	var status = document.querySelector('#status');
	status.className = 'online';
	status.innerHTML = 'Online';

	var i = 0, dataString = '';

	for( i = 0; i <= window.localStorage.length - 1; i++) {
		dataString = localStorage.key(i);
		if(dataString) {
			sendDataToServer(localStorage.getItem(dataString));
		}
	}

	document.querySelector('#local-count').innerHTML = window.localStorage.length;
}

//called when device goes offline
function notifyUserIsOffline() {

	var status = document.querySelector('#status');
	status.className = 'offline';
	status.innerHTML = 'Offline';
}

//This function is to get the 'get' parameters passed in the url
function getQueryParams(qs) {
	qs = qs.split("+").join(" ");
	var params = {}, tokens, re = /[?&]?([^=]+)=([^&]*)/g;

	while( tokens = re.exec(qs)) {
		params[decodeURIComponent(tokens[1])] = decodeURIComponent(tokens[2]);
	}

	return params;
}

//called when DOM has fully loaded
function loaded() {

	//update local storage count
	var length = window.localStorage.length;
	document.querySelector('#local-count').innerHTML = length;

	//if online

	if(navigator.onLine) {

		//update connection status
		var status = document.querySelector('#status');
		status.className = 'online';
		status.innerHTML = 'Online';

		//if local data exists, send try post to server
		if(length !== 0) {
			sendLocalDataToServer();
		}
	}

	//listen for connection changes
	window.addEventListener('online', sendLocalDataToServer, false);
	window.addEventListener('offline', notifyUserIsOffline, false);

	//
	//document.querySelector('.submit-button').addEventListener('click', processData, true);
	$(".submit-button").click(function() {

		processData($(this));
	});
}

window.addEventListener('load', loaded, true);

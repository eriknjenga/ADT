//main function to be called on submit
function processData() {
	var form = $(this).attr("form");
	var target = '';
	var local_table = '';
	var facility = "10";
	var user = "1";
	if(form == "add_patient") {
		target = "patient_management/save";
		local_table = 'patient';
		var dump = retrieveFormValues();
		//Retrieve all form input elements and their values
		var timestamp = new Date().getTime();
		var sql = "INSERT INTO patient (medical_record_number, patient_number_ccc, first_name, last_name, other_name, dob, pob, gender, pregnant," + " weight, height, sa, phone, physical, alternate, other_illnesses, other_drugs, adr, tb, smoke, alcohol, date_enrolled, source, supported_by," + " timestamp, facility_code, service, start_regimen) VALUES ('" + dump["medical_record_number"] + "', '" + dump["patient_number"] + "', '" + dump["first_name"] + "', '" + dump["last_name"] + "', '" + dump["other_name"] + "', '" + dump["dob"] + "', '" + dump["pob"] + "', '" + dump["gender"] + "', '" + dump["pregnant"] + "', '" + dump["weight"] + "', '" + dump["height"] + "', '" + dump["surface_area"] + "', '" + dump["phone"] + "', '" + dump["physical"] + "', '" + dump["alternate"] + "', '" + dump["other_illnesses_listing"] + "', '" + dump["other_drugs"] + "', '" + dump["other_allergies_listing"] + "', '" + dump["tb"] + "', '" + dump["smoke"] + "', '" + dump["alcohol"] + "', '" + dump["enrolled"] + "', '" + dump["source"] + "', '" + dump["support"] + "', '" + timestamp + "','" + facility + "', '" + dump["service"] + "', '" + dump["regimen"] + "');";

	} else if(form == "dispense") {
		target = "dispensement_management/save";
		local_table = 'patient_visit';
		//Before going any further, first calculate the number of drugs being dispensed
		var drugs_count = 0;
		$.each($(".drug"), function(i, v) {
			if($(this).attr("value")) {
				drugs_count++;
			}
		});
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
		var timestamp = new Date().getTime();
		
		//After getting the number of drugs issued, create a unique entry (sql statement) for each in the database in this loop
		for(var i = 0; i < drugs_count; i++) {
			var sql = "INSERT INTO patient_visit (patient_id, visit_purpose, current_height, current_weight, regimen, regimen_change_reason, drug_id, batch_number, brand, indication, pill_count, comment, timestamp, user, facility, dose) VALUES ('" + dump["patient"] + "', '" + dump["purpose"] + "', '" + dump["height"] + "', '" + dump["weight"] + "', '" + dump["current_regimen"] + "', '" + dump["regimen_change_reason"] + "', '" + drugs[i] + "', '" + batches[i] + "', '" +brands[i] + "', '" + indications[i] + "', '" +pill_counts[i] + "', '" + comments[i] + "', '" + timestamp + "', '" + user + "', '" + facility + "', '" + doses[i] + "');";
			
		};

	}
	var combined_object = {
		0 : target,
		1 : sql,
		2 : timestamp,
		3 : local_table
	};
	var saved_object = JSON.stringify(combined_object);
	//Regardless of whether the user is offline or online, save the data locally.
	/*if(navigator.onLine) {
	sendDataToServer(saved_object);
	} else {*/
	saveDataLocally(saved_object);
	//}

}

function retrieveFormValues() {
	//This function loops the whole form and saves all the input, select, e.t.c. elements with their corresponding values in a javascript array for processing
	var dump = Array;
	$.each($("input, select, textarea"), function(i, v) {
		var theTag = v.tagName;
		var theElement = $(v);
		var theValue = theElement.val();
		dump[theElement.attr("name")] = theElement.attr("value");

	});
	return dump;
}

function retrieveFormValues_Array(name) {
	var dump = Array;
	var counter = 0; 
	$.each($("input[name="+name+"], select[name="+name+"], select[name="+name+"]"), function(i, v) {
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
		//We won't be deleting the local data after sending it to the database
		/*var sql = "delete from " + local_table + " where timestamp = '" + local_timestamp + "'";
		executeStatement(sql);*/
		window.localStorage.removeItem(local_timestamp);
	});
}

//called on submit if device is offline from processData()
function saveDataLocally(data) {
	var separated_data = JSON.parse(data);
	var sql = separated_data[1];
	var timestamp = separated_data[2];
	try {
		executeStatement(sql);
		localStorage.setItem(timestamp, data);
	} catch (e) {

		if(e == QUOTA_EXCEEDED_ERR) {
			console.log('Quota exceeded!');
		}
	}

	console.log(sql);

	var length = window.localStorage.length;
	document.querySelector('#local-count').innerHTML = length;
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

	document.querySelector('#submit').addEventListener('click', processData, false);
}

window.addEventListener('load', loaded, true);

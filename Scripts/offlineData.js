//main function to be called on submit
function processData() {
	var form = $(this).attr("form");
	var target = '';
	var local_table = '';
	var facility = "10";
	if(form == "add_patient") {
		target = "patient_management/save";
		local_table = 'patient';
		var dump = Array;
		$.each($("input, select, textarea"), function(i, v) {
			var theTag = v.tagName;
			var theElement = $(v);
			var theValue = theElement.val();
			dump[theElement.attr("name")] = theElement.attr("value");
		});
		var timestamp = new Date().getTime();
		var sql = "INSERT INTO patient (medical_record_number, patient_number_ccc, first_name, last_name, other_name, dob, pob, gender, pregnant," +
		 " weight, height, sa, phone, physical, alternate, other_illnesses, other_drugs, adr, tb, smoke, alcohol, date_enrolled, source, supported_by," + 
		 " timestamp, facility_code, service, start_regimen) VALUES ('" + dump["medical_record_number"] + "', '" + dump["patient_number"] + "', '" + dump["first_name"] + "', '" + 
		 dump["last_name"] + "', '" + dump["other_name"] + "', '" + dump["dob"] + "', '" + dump["pob"] + "', '" + dump["gender"] + "', '" + dump["pregnant"] + 
		 "', '" + dump["weight"] + "', '" + dump["height"] + "', '" + dump["surface_area"] + "', '" + dump["phone"] + "', '" + dump["physical"] + "', '" + 
		 dump["alternate"] + "', '" + dump["other_illnesses_listing"] + "', '" + dump["other_drugs"] + "', '" + dump["other_allergies_listing"] + "', '" + 
		 dump["tb"] + "', '" + dump["smoke"] + "', '" + dump["alcohol"] + "', '" + dump["enrolled"] + "', '" + dump["source"] + "', '" + dump["support"] + 
		 "', '" + timestamp + "','"+facility+"', '" + dump["service"] + "', '" + dump["regimen"] + "');";

	}
	var combined_object = {0:target, 1:sql, 2:timestamp, 3:local_table};
	var saved_object = JSON.stringify(combined_object);
	if(navigator.onLine) {
		sendDataToServer(saved_object);
	} else {
		saveDataLocally(saved_object);
	}

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
			var sql = "delete from "+local_table+" where timestamp = '"+local_timestamp+"'";
			executeStatement(sql);
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
 
		for(i=0;i<=window.localStorage.length-1;i++){
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



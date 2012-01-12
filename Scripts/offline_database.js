function initDatabase() {
	try {
		if(!window.openDatabase) {
			alert('Databases are not supported in this browser.');
		} else {
			var shortName = 'ADT_Database';
			var version = '1.0';
			var displayName = 'ADT LocalDatabase';
			var maxSize = 1000000000;
			//  bytes
			DEMODB = openDatabase(shortName, version, displayName, maxSize);
			createTables();
			Populate("delete from supporter");
			Populate("insert into supporter (name) values ('GOK')");
			Populate("insert into supporter (name) values ('PEPFAR')");
		}
	} catch(e) {

		if(e == 2) {
			// Version number mismatch.
			console.log("Invalid database version.");
		} else {
			console.log("Unknown error " + e + ".");
		}
		return;
	}
}

function createTables() {
	DEMODB.transaction(function(transaction) {
		transaction.executeSql('CREATE TABLE IF NOT EXISTS regimen(id INTEGER NOT NULL PRIMARY KEY, regimen_code TEXT,regimen_desc TEXT, category TEXT, line TEXT, type_of_service TEXT, remarks TEXT);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS supporter(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS regimen_service_type(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS patient_source(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS patient(id INTEGER NOT NULL PRIMARY KEY, medical_record_number TEXT, patient_number_ccc TEXT, first_name TEXT, last_name TEXT,' + 'other_name TEXT, dob TEXT, pob TEXT, gender TEXT, pregnant TEXT, weight TEXT, height TEXT,sa TEXT, phone TEXT, physical TEXT, alternate TEXT, other_illnesses TEXT, other_drugs TEXT, adr TEXT,' + 'tb TEXT, smoke TEXT, alcohol TEXT, date_enrolled TEXT, source TEXT, supported_by TEXT, timestamp TEXT, facility_code TEXT, service TEXT, start_regimen TEXT, machine_code TEXT);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS regimen_change_purpose(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS visit_purpose(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS opportunistic_infections(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS drugcode(id INTEGER NOT NULL PRIMARY KEY, drug TEXT, unit TEXT, pack_size TEXT, safety_quantity TEXT, generic_name TEXT, supported_by TEXT,dose TEXT, duration TEXT, quantity TEXT);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS regimen_drug(id INTEGER NOT NULL PRIMARY KEY, regimen TEXT, drugcode TEXT);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS scheduled_patients(id INTEGER NOT NULL PRIMARY KEY, name TEXT, universal_id TEXT, start_regimen TEXT);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS patient_visit(id INTEGER NOT NULL PRIMARY KEY, patient_id TEXT, visit_purpose TEXT, current_height TEXT, current_weight TEXT, regimen TEXT, regimen_change_reason TEXT, drug_id TEXT, batch_number TEXT, brand TEXT, indication TEXT, pill_count TEXT, comment TEXT, timestamp TEXT, user TEXT, facility TEXT, dose TEXT,  dispensing_date TEXT, dispensing_date_timestamp TEXT, machine_code TEXT, quantity TEXT);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS patient_appointment(id INTEGER NOT NULL PRIMARY KEY, patient TEXT, appointment TEXT, machine_code TEXT);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS environment_variables(id INTEGER NOT NULL PRIMARY KEY, machine_id TEXT, operator TEXT, facility_name TEXT, facility TEXT );', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS patient_status(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL);', [], nullDataHandler, errorHandler);
	});
}

function Populate(sql) {
	DEMODB.transaction(function(transaction) {
		transaction.executeSql(sql, [], nullDataHandler, errorHandler);
	});
}

function executeStatement(sql) {

	DEMODB.transaction(function(transaction) {
		transaction.executeSql(sql, [], nullDataHandler, errorHandler);
	});
}

function executeStatementArray(sql_array) {
	DEMODB.transaction(function(transaction) {
		for(sql in sql_array) {

			transaction.executeSql(sql_array[sql]);
		}
	}, transactionCallback, transactionErrorCallback);
}

function transactionCallback(transaction) {
	console.log(transaction);
}

function transactionErrorCallback(transaction) {
	console.log(transaction);
}

function errorHandler(transaction, error) {
	if(error.code == 1) {
		// DB Table already exists
	} else {
		// Error is a human-readable string.
		console.log('Oops.  Error was ' + error.message + ' (Code ' + error.code + ')');
	}
	return false;
}

function nullDataHandler() {
	console.log("SQL Query Succeeded");
}

function selectAll(table, dataSelectHandler) {
	var sql = "select * from " + table;
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function selectServiceRegimen(service, dataSelectHandler) {
	var sql = "select * from regimen where type_of_service = '" + service + "'";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}
//Get the last regimen dispensed. Along with the date of that visit
function selectPatientRegimen(source, id, dataSelectHandler) {
	var sql = "select r.id,regimen_desc,dispensing_date from patient_visit pv,regimen r where pv.patient_id = '" + id + "' and pv.regimen = r.id order by pv.id desc";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}
//Retrieve the drugs that were issued during that last visit
function selectLastVisitDetails(patient, date, dataSelectHandler) {
	var sql = "select d.drug,pv.quantity from patient_visit pv,drugcode d where pv.patient_id = '" + patient + "' and pv.dispensing_date = '"+date+"' and pv.drug_id = d.id order by pv.id desc";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function selectRegimenDrugs(regimen, dataSelectHandler) {
	var sql = "select drugcode.id, drug from drugcode, regimen_drug where regimen_drug.regimen = '" + regimen + "' and drugcode.id = regimen_drug.drugcode";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//This function is rather self-explanatory
function selectSingleFilteredQuery(table, filterColumn, filterValue, dataSelectHandler) {
	var sql = "select * from " + table + " where " + filterColumn + " = '" + filterValue + "'";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//This function returns a list of all OI Medicines
function selectOIMedicines(dataSelectHandler) {
	var sql = "select drugcode.id, drug from drugcode, regimen_drug, regimen where regimen_drug.regimen = regimen.id and regimen.regimen_code = 'OI' and drugcode.id = regimen_drug.drugcode";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//This function returns a list of all OI Medicines
function getScheduledPatients(dataSelectHandler) {
	var sql = "select drugcode.id, drug from drugcode, regimen_drug, regimen where regimen_drug.regimen = regimen.id and regimen.regimen_code = 'OI' and drugcode.id = regimen_drug.drugcode";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//This function returns details of the last visit of the patient
function getPatientLastVisit(patient_ccc, dataSelectHandler) {
	var sql = "select drugcode.id, drug from drugcode, regimen_drug, regimen where regimen_drug.regimen = regimen.id and regimen.regimen_code = 'OI' and drugcode.id = regimen_drug.drugcode";
	//SQLExecuteAbstraction(sql, dataSelectHandler);
}

//This function returns a list of patients based on the limits specified
function selectPagedPatients(search_term, offset, limit, dataSelectHandler) {
	var where_clause = "";
	if(search_term.length > 0) {
		where_clause = "where medical_record_number like '%" + search_term + "%' or patient_number_ccc like '%" + search_term + "%' or  first_name like '%" + search_term + "%' or  last_name like '%" + search_term + "%' or  other_name like '%" + search_term + "%' or  dob like '%" + search_term + "%' or  pob like '%" + search_term + "%' or  phone like '%" + search_term + "%' or  physical like '%" + search_term + "%' or  alternate like '%" + search_term + "%' or  other_illnesses  like '%" + search_term + "%' or other_drugs like '%" + search_term + "%' or  date_enrolled like '%" + search_term + "%'";
	}
	var sql = "select patient_number_ccc, first_name, last_name, other_name, dob, phone from patient " + where_clause + " limit " + offset + ", " + limit + "";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//This function loads up the patient history (paginated of course)!
function selectPagedPatientHistory(offset, limit, patient, dataSelectHandler) {
	var sql = "select * from patient_visit limit " + offset + ", " + limit + "";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//Function to retrieve the environment Variables
function selectEnvironmentVariables(dataSelectHandler) {
	var sql = "select * from environment_variables";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//Function to save the facility details in the environment variables table.
function createEnvironmentVariables(facility_code, facility_name) {
	var sql = "insert into environment_variables (facility, facility_name) values('" + facility_code + "','" + facility_name + "')";
	executeStatement(sql);
}

//Function to save the facility details in the environment variables table.
function saveFacilityDetails(facility_code, facility_name) {
	var sql = "update environment_variables set facility='" + facility_code + "', facility_name = '" + facility_name + "' where id = '1'";
	executeStatement(sql);
}

//Function to save the environment variables in the environment variables table.
function saveEnvironmentVariables(machine_code, operator) {
	var sql = "update environment_variables set machine_id='" + machine_code + "', operator = '" + operator + "' where id = '1'";
	executeStatement(sql);
}

//count the total number of records in a particular table
function countTableRecords(table, dataSelectHandler) {
	var sql = "select count(*) as total from " + table;
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//Get unique machine ids from a particular table
function getMachineCodes(table, dataSelectHandler) {
	var sql = "select distinct machine_code from " + table;
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//Get the last record for a particular machine_code in the patients recordset
function getLastMachineCodeRecords(dataSelectHandler) {
	var sql = "SELECT machine_code,patient_number_ccc from patient group by machine_code";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//Get the latest record from the patient appointment table grouped by the machine code
function getLastAppointmentData(dataSelectHandler) {
	var sql = "SELECT machine_code,patient, appointment from patient_appointment group by machine_code";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//Get the latest record from the patient visit table grouped by the machine code
function getLastVisitData(dataSelectHandler) {
	var sql = "SELECT machine_code,patient_id, dispensing_date, drug_id from patient_visit group by machine_code";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}
//count the total number of records in a search result
function countSearchedPatientRecords(search_term, dataSelectHandler) {
	var sql = "select count(*) as total from patient where medical_record_number like '%" + search_term + "%' or patient_number_ccc like '%" + search_term + "%' or  first_name like '%" + search_term + "%' or  last_name like '%" + search_term + "%' or  other_name like '%" + search_term + "%' or  dob like '%" + search_term + "%' or  pob like '%" + search_term + "%' or  phone like '%" + search_term + "%' or  physical like '%" + search_term + "%' or  alternate like '%" + search_term + "%' or  other_illnesses  like '%" + search_term + "%' or other_drugs like '%" + search_term + "%' or  date_enrolled like '%" + search_term + "%'";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}
//This function returns a list of patients based on the limits specified
function getPatientDetails(patient_number, dataSelectHandler) {
	var sql = "select patient_number_ccc, first_name, last_name, other_name from patient where patient_number_ccc = '"+patient_number+"'";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function SQLExecuteAbstraction(sql, dataSelectHandler) {
	DEMODB.transaction(function(transaction) {
		transaction.executeSql(sql, [], dataSelectHandler, errorHandler);
	});
}
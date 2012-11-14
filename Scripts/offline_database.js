//Add the logout and change password links to the top menu
$(document).ready(function() {
	$("#my_profile_link_container").hover(function() {
		var html = "<a href='user_management/change_password' class='top_menu_link temp_link'>Change Password</a> <a href='user_management/logout' class='top_menu_link temp_link'>Logout</a> ";
		$("#my_profile_link").css('display', 'none');
		$(this).append(html);
	}, function() {
		$("#my_profile_link").css('display', 'block');
		$(this).find(".temp_link").remove();
	});
});
function initDatabase() {
	try {
		if(!window.openDatabase) {
			alert('Databases are not supported in this browser.');
		} else {
			var shortName = 'ADT_Database2';
			var version = '1.0';
			var displayName = 'ADT LocalDatabase';
			var maxSize = 1000000000;
			//  bytes
			DEMODB = openDatabase(shortName, version, displayName, maxSize);
			createTables();
			Populate("delete from supporter");
			Populate("insert into supporter (name) values ('GOK')");
			Populate("insert into supporter (name) values ('PEPFAR')");
			Populate("delete from drug_source");
			Populate("insert into drug_source (name) values ('Main Store')");
			Populate("insert into drug_source (name) values ('Kenya Pharma')");
			Populate("insert into drug_source (name) values ('Outpatient')");
			Populate("insert into drug_source (name) values ('CCC Internal Adjustment')");
			Populate("insert into drug_source (name) values ('Donation')");
			Populate("delete from drug_destination");
			Populate("insert into drug_destination (name) values ('Outpatient Pharmacy')");
			Populate("insert into drug_destination (name) values ('Maternity Ward')");
			Populate("insert into drug_destination (name) values ('MCH Clinic')");
			Populate("insert into drug_destination (name) values ('CCC Internal Adjustment')");
			Populate("delete from transaction_type");
			Populate("insert into transaction_type (name,report_title,effect) values ('Received From','Drug Received Report','1')");
			Populate("insert into transaction_type (name,report_title,effect) values ('Balance Forward','Balance Forwarded','1')");
			Populate("insert into transaction_type (name,report_title,effect) values ('Returns From (+)','Returns by Clients','1')");
			Populate("insert into transaction_type (name,report_title,effect) values ('Adjustment (+)','Adjustments','1')");
			Populate("insert into transaction_type (name,report_title,effect) values ('Dispensed to Patients','Dispensed to Patients','0')");
			Populate("insert into transaction_type (name,report_title,effect) values ('Issued To','Drug Issue Report','0')");
			Populate("insert into transaction_type (name,report_title,effect) values ('Adjustment (-)','Adjustments','0')");
			Populate("insert into transaction_type (name,report_title,effect) values ('Returns To','Returns to Suppliers','0')");
			Populate("insert into transaction_type (name,report_title,effect) values ('Losses (-)','Losses','0')");
			Populate("insert into transaction_type (name,report_title,effect) values ('Expired (-)','Expiry Report','0')");
			Populate("insert into transaction_type (name,report_title,effect) values ('Starting Stock/Physical Count','Physical Count','1')");

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
	//Get the environment variables and display them appropriately
	selectEnvironmentVariables(function(transaction, results) {
		var variables = results.rows.item(0);
		$("#my_profile_link").html(variables["operator"]);
	});
}

function createTables() {
	DEMODB.transaction(function(transaction) {
		transaction.executeSql('CREATE TABLE IF NOT EXISTS regimen(id INTEGER NOT NULL PRIMARY KEY, regimen_code TEXT,regimen_desc TEXT, category TEXT, line TEXT, type_of_service TEXT, remarks TEXT);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS supporter(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS regimen_service_type(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS patient_source(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS patient(id INTEGER NOT NULL PRIMARY KEY, medical_record_number TEXT, patient_number_ccc TEXT , first_name TEXT, last_name TEXT,' + 'other_name TEXT, dob TEXT, pob TEXT, gender TEXT, pregnant TEXT, weight TEXT, height TEXT,sa TEXT, phone TEXT, physical TEXT, alternate TEXT, other_illnesses TEXT, other_drugs TEXT, adr TEXT,' + 'tb TEXT, smoke TEXT, alcohol TEXT, date_enrolled TEXT, source TEXT, supported_by TEXT, timestamp TEXT, facility_code TEXT, service TEXT, start_regimen TEXT, start_regimen_date TEXT, machine_code TEXT, current_status TEXT, sms_consent TEXT,partner TEXT,partner_status TEXT,non_commun TEXT,fplan TEXT,tbphase TEXT,startphase TEXT,endphase TEXT);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS regimen_change_purpose(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS visit_purpose(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS opportunistic_infections(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS drugcode(id INTEGER NOT NULL PRIMARY KEY, drug TEXT, unit TEXT, pack_size TEXT, safety_quantity TEXT, generic_name TEXT, supported_by TEXT,dose TEXT, duration TEXT, quantity TEXT, source TEXT);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS regimen_drug(id INTEGER NOT NULL PRIMARY KEY, regimen TEXT, drugcode TEXT);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS scheduled_patients(id INTEGER NOT NULL PRIMARY KEY, name TEXT, universal_id TEXT, start_regimen TEXT);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS patient_visit(id INTEGER NOT NULL PRIMARY KEY, patient_id TEXT, visit_purpose TEXT, current_height TEXT, current_weight TEXT, regimen TEXT, regimen_change_reason TEXT, drug_id TEXT, batch_number TEXT, brand TEXT, indication TEXT, pill_count TEXT, comment TEXT, timestamp TEXT, user TEXT, facility TEXT, dose TEXT,  dispensing_date TEXT, dispensing_date_timestamp TEXT, machine_code TEXT, quantity TEXT,duration TEXT, last_regimen TEXT, months_of_stock TEXT, adherence TEXT, missed_pill TEXT);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS patient_appointment(id INTEGER NOT NULL PRIMARY KEY, patient TEXT, appointment TEXT, machine_code TEXT,facility TEXT);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS environment_variables(id INTEGER NOT NULL PRIMARY KEY, machine_id TEXT, operator TEXT, facility_name TEXT, facility TEXT );', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS patient_status(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS drug_source(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS drug_destination(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS drug_stock_movement(id INTEGER NOT NULL PRIMARY KEY, drug TEXT, transaction_date TEXT, batch_number TEXT, transaction_type TEXT, source TEXT, destination TEXT, expiry_date TEXT, packs TEXT,quantity TEXT, unit_cost TEXT, amount TEXT, remarks TEXT, operator TEXT, order_number TEXT, machine_code TEXT, facility TEXT,);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS transaction_type(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL, report_title TEXT NOT NULL, effect TEXT NOT NULL);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS drug_unit(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS districts(id INTEGER(14) NOT NULL,name varchar(100) NOT NULL);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS drug_unit(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS generic_name (id INTEGER NOT NULL PRIMARY KEY,name TEXT NOT NULL);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE TABLE IF NOT EXISTS dose (id INTEGER NOT NULL PRIMARY KEY,name TEXT,value TEXT,frequency TEXT);', [], nullDataHandler, errorHandler)
		//Create all the necessary indexes!
		transaction.executeSql('CREATE INDEX if not exists dispensing_date_index ON patient_visit(dispensing_date);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE INDEX if not exists regimen_index ON patient_visit(regimen);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE INDEX if not exists last_regimen_index ON patient_visit(last_regimen);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE INDEX if not exists dispensing_patient_index ON patient_visit(patient_id);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE INDEX if not exists patient_id_index ON patient(id);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE INDEX if not exists drug_id_index ON patient_visit(drug_id);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE INDEX if not exists drug_code_id_index ON drugcode(id);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE INDEX if not exists drug_stock_index ON drug_stock_movement(drug);', [], nullDataHandler, errorHandler);
		transaction.executeSql('CREATE INDEX if not exists patient_regimen_index ON patient_visit(regimen);', [], nullDataHandler, errorHandler);

		/*
		 * Deactivate all patients who are inactive
		 */
		transaction.executeSql("update patient set current_status = '5' where patient_number_ccc in (SELECT patient from patient_appointment pa left join patient p on p.patient_number_ccc = pa.patient where (strftime('%s','now')-strftime('%s',appointment))/86400 >90 and p.current_status = '1' and (p.service = '1' or p.service='3') group by patient);", [], nullDataHandler, errorHandler);
		/*
		* Update the status of patients whose PMTCT days are over
		*/
		//transaction.executeSql("UPDATE patient SET current_status = '4' WHERE service='3' AND (strftime('%s','now')-strftime('%s',date_enrolled))/86400>=270;", [], nullDataHandler, errorHandler);
		/*
		 * Update the status of patients whose PEP days are over
		 */
		transaction.executeSql("UPDATE patient SET current_status = '3' WHERE service='2' AND (strftime('%s','now')-strftime('%s',date_enrolled))/86400>=30;", [], nullDataHandler, errorHandler);

		/*
		 *Alter table statements
		 */
		transaction.executeSql("alter table patient add column sms_consent text default '1';", [], nullDataHandler, errorHandler);
		transaction.executeSql("alter table patient_visit add column adherence text;", [], nullDataHandler, errorHandler);
		transaction.executeSql("alter table patient_visit add column missed_pills text;", [], nullDataHandler, errorHandler);
		transaction.executeSql("alter table drug_stock_movement add column machine_code text;", [], nullDataHandler, errorHandler);
		transaction.executeSql("alter table drug_stock_movement add column facility text;", [], nullDataHandler, errorHandler);
		transaction.executeSql("alter table patient add column sms_consent text default '1';", [], nullDataHandler, errorHandler);
		transaction.executeSql("alter table patient add column partner text default '0';", [], nullDataHandler, errorHandler);
		transaction.executeSql("alter table patient add column partner_status text default '0';", [], nullDataHandler, errorHandler);
		transaction.executeSql("alter table patient add column non_commun text;", [], nullDataHandler, errorHandler);
		transaction.executeSql("alter table patient add column fplan text;", [], nullDataHandler, errorHandler);
		transaction.executeSql("alter table patient add column tbphase text;", [], nullDataHandler, errorHandler);
		transaction.executeSql("alter table patient add column startphase text;", [], nullDataHandler, errorHandler);
		transaction.executeSql("alter table patient add column endphase text;", [], nullDataHandler, errorHandler);

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
	}, null, transactionCallback, transactionErrorCallback);
}

function callbackExecuteStatementArray(sql_array, callback) {
	DEMODB.transaction(function(transaction) {
		for(sql in sql_array) {
			if(sql_array[sql].length > 0) {
				transaction.executeSql(sql_array[sql]);
			}
		}
	}, null, callback, errorHandler);
}

function transactionCallback(transaction, result) {
	console.log(transaction);
}

function transactionErrorCallback(transaction, error) {
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

function nullDataHandler(transaction, result) {
	console.log("SQL Query Succeeded");
}

function selectAll(table, dataSelectHandler) {
	var sql = "select * from " + table;
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//Function to select all drugs and order them alphabetically
function selectAllDrugs(dataSelectHandler) {
	var sql = "select * from drugcode order by drug asc";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function selectRegimen(dataSelectHandler) {
	var sql = "select * from regimen order by regimen_desc asc";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getDrugDoses(dataSelectHandler) {
	var sql = "select id,name from dose order by name asc";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function selectDistricts(dataSelectHandler) {
	var sql = "select * from districts order by name asc";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function selectServiceRegimen(service, dataSelectHandler) {
	var sql = "select * from regimen where type_of_service = '" + service + "'";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//Get the last regimen dispensed. Along with the date of that visit
function selectPatientRegimen(source, id, dataSelectHandler) {
	var sql = "select r.id,regimen_desc,dispensing_date,pv.current_weight, pv.current_height from patient_visit pv,regimen r where pv.patient_id = '" + id + "' and pv.regimen = r.id order by pv.dispensing_date desc limit 1";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//Retrieve the drugs that were issued during that last visit
function selectLastVisitDetails(patient, date, dataSelectHandler) {
	var sql = "select d.drug,pv.quantity from patient_visit pv,drugcode d where pv.patient_id = '" + patient + "' and pv.dispensing_date = '" + date + "' and pv.drug_id = d.id order by pv.id desc";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function selectRegimenDrugs(regimen, dataSelectHandler) {
	var sql = "select d.id, UPPER(drug) as drug from drugcode d, regimen_drug rd,regimen r where (rd.regimen = '" + regimen + "' or r.regimen_code = 'OI') and d.id = rd.drugcode and rd.regimen = r.id order by UPPER(drug) asc";

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

//This function returns details of the last visit of the patient
function getPatientLastVisit(patient_ccc, dataSelectHandler) {
	var sql = "select * from patient_visit where patient_id = '" + patient_ccc + "' order by dispensing_date desc limit 1";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//This function returns a list of patients based on the limits specified
function selectPagedPatients(search_term, offset, limit, dataSelectHandler) {
	var where_clause = "";
	if(search_term.length > 0) {
		where_clause = "where medical_record_number like '%" + search_term + "%' or patient_number_ccc like '%" + search_term + "%' or  first_name like '%" + search_term + "%' or  last_name like '%" + search_term + "%' or  other_name like '%" + search_term + "%' or  dob like '%" + search_term + "%' or  pob like '%" + search_term + "%' or  phone like '%" + search_term + "%' or  physical like '%" + search_term + "%' or  alternate like '%" + search_term + "%' or  other_illnesses  like '%" + search_term + "%' or other_drugs like '%" + search_term + "%' or  date_enrolled like '%" + search_term + "%'";
	}
	var sql = "select patient_number_ccc, first_name, last_name, other_name, dob, phone from patient " + where_clause + " order by id desc limit " + offset + ", " + limit + "";
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

//count the total number of records in a particular table
function countPatientRecords(facility, dataSelectHandler) {
	var sql = "select count(*) as total from patient where facility_code = " + facility;
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

//Get the last record for a particular machine_code in the drug_stock_movement recordset
function getLastDrugTransactionRecords(dataSelectHandler) {
	var sql = "SELECT machine_code,drug,order_number,transaction_date from drug_stock_movement group by machine_code";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//Get the latest record from the patient appointment table grouped by the machine code
function getLastAppointmentData(dataSelectHandler) {
	var sql = "SELECT machine_code,patient, appointment from patient_appointment group by machine_code";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//Get the latest record from the patient visit table grouped by the machine code
function getLastVisitData(dataSelectHandler) {
	var sql = "SELECT machine_code,patient_id, dispensing_date, drug_id,current_height,current_weight from patient_visit group by machine_code";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//count the total number of records in a search result
function countSearchedPatientRecords(search_term, dataSelectHandler) {
	var sql = "select count(*) as total from patient where medical_record_number like '%" + search_term + "%' or patient_number_ccc like '%" + search_term + "%' or  first_name like '%" + search_term + "%' or  last_name like '%" + search_term + "%' or  other_name like '%" + search_term + "%' or  dob like '%" + search_term + "%' or  pob like '%" + search_term + "%' or  phone like '%" + search_term + "%' or  physical like '%" + search_term + "%' or  alternate like '%" + search_term + "%' or  other_illnesses  like '%" + search_term + "%' or other_drugs like '%" + search_term + "%' or  date_enrolled like '%" + search_term + "%'";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//This function returns a list of patients based on the limits specified
function getPatientDetails(patient_number, dataSelectHandler) {
	var sql = "select * from patient where patient_number_ccc = '" + patient_number + "'"; 
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//This function returns a list of patient visits based on the limits specified
function getPatientHistory(patient_number, offset, limit, dataSelectHandler) {
	var sql = "select patient_id as patient_number_ccc, dispensing_date, v.name as visit_purpose, r.regimen_desc, current_weight, current_height, user from patient_visit pv, visit_purpose v, regimen r where patient_id = '" + patient_number + "' and pv.visit_purpose = v.id and pv.regimen = r.id group by dispensing_date order by pv.id desc limit " + offset + ", " + limit + "";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//Function to retrieve the details of a particular patient visit!
function getPatientVisitDetails(patient_number, visit_date, dataSelectHandler) {
	var sql = "select pv.*, d.drug as drug_name, r.regimen_desc as regimen_desc, vp.name as visit_purpose_name from patient_visit pv left join drugcode d, regimen r, visit_purpose vp on pv.drug_id = d.id and pv.regimen = r.id and pv.visit_purpose = vp.id WHERE patient_id = '" + patient_number + "' AND dispensing_date = '" + visit_date + "'";
	console.log(sql);
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//count the total number of records in a search result
function countSearchedDrugRecords(search_term, dataSelectHandler) {
	var sql = "select count(*) as total from drugcode where drug like '%" + search_term + "%' or generic_name like '%" + search_term + "%'";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//This function returns a list of drugs based on the limits specified
function selectPagedDrugs(search_term, offset, limit, dataSelectHandler) {
	var where_clause = "";
	if(search_term.length > 0) {
		where_clause = "where drug like '%" + search_term + "%' or generic_name like '%" + search_term + "%'";
	}
	var sql = "select id, drug, generic_name, pack_size, supported_by, dose from drugcode " + where_clause + " order by id asc limit " + offset + ", " + limit + "";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//This function returns the details of a drug given its id
function getDrugsDetails(id, dataSelectHandler) {
	var sql = "select d.*,du.name as drug_unit from drugcode d, drug_unit du where d.id = '" + id + "' and d.unit = du.id";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//get unit name
function getUnitName(id, dataSelectHandler) {
	var sql = "select Name from drug_unit where id = '" + id + "'";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getUnits(dataSelectHandler) {
	var sql = "select * from drug_unit";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getDrugcode(dataSelectHandler) {
	var sql = "select * from drugcode";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getGenericName(dataSelectHandler) {
	var sql = "select * from generic_name";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getDose(dataSelectHandler) {
	var sql = "select * from dose";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getSupporter(dataSelectHandler) {
	var sql = "select * from supporter";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//This function returns the bin card of a drug given its id
function getDrugBinCard(id, dataSelectHandler) {
	var sql = "select * from drug_stock_movement d, where d.drug = '" + drug + "'";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getDrugTransactions(id, dataSelectHandler) {
	var sql = "select t.name as trans_type,d.drug,d.pack_size,ds.* from drug_stock_movement ds,drugcode d,transaction_type t where ds.drug = '" + id + "' and ds.drug = d.id and ds.transaction_type = t.id";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getExpectedPatients(appointment_date, dataSelectHandler) {
	var sql = "select distinct pa.patient, p.first_name, p.other_name, p.last_name, p.gender,p.dob  from patient_appointment pa, patient p where pa.appointment = '" + appointment_date + "' and pa.patient = p.patient_number_ccc";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function advancedGetLastPatientRegimen(patient, dataSelectHandler) {
	var sql = "select case when 1=1 then '" + patient + "' end as passed_patient, patient_id,r.id,regimen_desc,dispensing_date,pv.id from patient_visit pv,regimen r where pv.patient_id = '" + patient + "' and pv.regimen = r.id  union all select case when 1=1 then '" + patient + "' end as passed_patient,'','','','','' where NOT EXISTS (select case when 1=1 then '" + patient + "' end as passed_patient, patient_id,r.id,regimen_desc,dispensing_date,pv.id from patient_visit pv,regimen r where pv.patient_id = '" + patient + "' and pv.regimen = r.id) order by pv.id desc limit 2";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getRefillPatients(dispensing_date, dataSelectHandler) {
	var sql = "select distinct p.patient_number_ccc, t.name as service_type, s.name as supported_by, p.first_name, p.other_name, p.dob, pv.current_weight, p.gender,r.regimen_desc  from patient_visit pv left join patient p left join supporter s,regimen_service_type t on p.supported_by = s.id and p.service = t.id, regimen r on pv.patient_id = p.patient_number_ccc and pv.regimen = r.id where pv.dispensing_date = '" + dispensing_date + "' and pv.visit_purpose >= '2' and p.current_status = '1'";
	console.log(sql);
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getMissedAppointments(start_date, end_date, dataSelectHandler) {
	var sql = "SELECT pa.appointment, pa.patient, p.other_name,p.first_name,p.gender,p.physical,(strftime('%s','now')-strftime('%s',appointment))/86400 as days_late from patient_appointment pa left join patient p on p.patient_number_ccc = pa.patient where strftime('%Y-%m-%d',pa.appointment) between strftime('%Y-%m-%d','" + start_date + "') and strftime('%Y-%m-%d','" + end_date + "') and p.current_status = '1' group by patient;";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getChangedRegimens(start_date, end_date, dataSelectHandler) {
	var sql = "select distinct p.patient_number_ccc, p.first_name, p.other_name, p.service, pv.dispensing_date,r1.regimen_desc as current_regimen,r2.regimen_desc as last_regimen, pv.comment, pv.regimen_change_reason from patient p left join patient_visit pv on p.patient_number_ccc = pv.patient_id left join regimen r1 on pv.regimen = r1.id left join regimen r2 on pv.last_regimen = r2.id where pv.last_regimen != '' and pv.regimen != pv.last_regimen and date(pv.dispensing_date) between date('" + start_date + "') and date('" + end_date + "') and p.current_status = '1' order by last_regimen";
	console.log(sql);
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getDrugBatches(drug, dataSelectHandler) {
	var sql = "select distinct batch_number from drug_stock_movement where drug = '" + drug + "' order by id desc";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getBatchExpiry(drug, batch, dataSelectHandler) {
	var sql = "select distinct expiry_date from drug_stock_movement where drug = '" + drug + "' and batch_number = '" + batch + "' order by id desc";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//Get the stock balance for a particular batch for a particular drug
function getBatchBalance(drug, batch, dataSelectHandler) {
	var sql = "select sum(quantity) from drug_stock_movement where drug = '" + drug + "' and batch_number = '" + batch + "' order by id desc";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getTotalPatientAppointments(appointment_date, dataSelectHandler) {
	var sql = "select count(*) as total_appointments  from patient_appointment pa where pa.appointment = '" + appointment_date + "'";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getLastPatientAppointment(patient, dataSelectHandler) {
	var sql = "select appointment from patient_appointment pa where pa.patient = '" + patient + "' order by appointment desc limit 1";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getPatientsEnrolledPeriod(start_date, end_date, dataSelectHandler) {

	var sql = "SELECT " + "regimen.regimen_desc regimen," + "count(start_regimen) total," + "(SELECT count(start_regimen) FROM patient where date('now')-dob>=15 and gender=1 and patient.start_regimen = regimen.id AND strftime('%Y-%m-%d',date_enrolled) between strftime('%Y-%m-%d','" + start_date + "') and strftime('%Y-%m-%d','" + end_date + "')) adult_male," + "(SELECT count(start_regimen) FROM patient where date('now')-dob>=15 and gender=2 and patient.start_regimen = regimen.id AND strftime('%Y-%m-%d',date_enrolled) between strftime('%Y-%m-%d','" + start_date + "') and strftime('%Y-%m-%d','" + end_date + "')) adult_female," + "(SELECT count(start_regimen) FROM patient where date('now')-dob<15 and gender=1 and patient.start_regimen = regimen.id AND strftime('%Y-%m-%d',date_enrolled) between strftime('%Y-%m-%d','" + start_date + "') and strftime('%Y-%m-%d','" + end_date + "')) child_male," + "(SELECT count(start_regimen) FROM patient where date('now')-dob<15 and gender=2 and patient.start_regimen = regimen.id AND strftime('%Y-%m-%d',date_enrolled) between strftime('%Y-%m-%d','" + start_date + "') and strftime('%Y-%m-%d','" + end_date + "')) child_female " + "FROM " + "patient," + "regimen " + "WHERE " + "patient.start_regimen = regimen.id " + "AND " + "strftime('%Y-%m-%d',date_enrolled) between strftime('%Y-%m-%d','" + start_date + "') " + "AND strftime('%Y-%m-%d','" + end_date + "')" + "GROUP BY " + "start_regimen " + "ORDER BY " + "regimen.regimen_desc " + "ASC";
	console.log(sql);
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getPatientsEnrolledPeriodSummary(symbol, service, gender, start_date, end_date, dataSelectHandler) {
	var sql = "SELECT count(service) as total FROM patient where date('now')-dob" + symbol + " AND service='" + service + "' AND gender='" + gender + "' AND strftime('%Y-%m-%d',date_enrolled) between strftime('%Y-%m-%d','" + start_date + "') and strftime('%Y-%m-%d','" + end_date + "')";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getPatientsEnrolledPeriod1(start_date, end_date, dataSelectHandler) {

	var sql = "SELECT " + "regimen.regimen_desc regimen," + "count(start_regimen) total," + "(SELECT count(start_regimen) FROM patient where service=1 AND date('now')-dob>=15 and gender=1 and patient.start_regimen = regimen.id AND strftime('%Y-%m-%d',date_enrolled) between strftime('%Y-%m-%d','" + start_date + "') and strftime('%Y-%m-%d','" + end_date + "')) adult_male," + "(SELECT count(start_regimen) FROM patient where service=1 AND date('now')-dob>=15 and gender=2 and patient.start_regimen = regimen.id AND strftime('%Y-%m-%d',date_enrolled) between strftime('%Y-%m-%d','" + start_date + "') and strftime('%Y-%m-%d','" + end_date + "')) adult_female," + "(SELECT count(start_regimen) FROM patient where service=1 AND date('now')-dob<15 and gender=1 and patient.start_regimen = regimen.id AND strftime('%Y-%m-%d',date_enrolled) between strftime('%Y-%m-%d','" + start_date + "') and strftime('%Y-%m-%d','" + end_date + "')) child_male," + "(SELECT count(start_regimen) FROM patient where service=1 AND date('now')-dob<15 and gender=2 and patient.start_regimen = regimen.id AND strftime('%Y-%m-%d',date_enrolled) between strftime('%Y-%m-%d','" + start_date + "') and strftime('%Y-%m-%d','" + end_date + "')) child_female " + "FROM " + "patient," + "regimen " + "WHERE " + "patient.start_regimen = regimen.id " + "AND " + "strftime('%Y-%m-%d',date_enrolled) between strftime('%Y-%m-%d','" + start_date + "') " + "AND strftime('%Y-%m-%d','" + end_date + "') " + "AND service=1 " + "GROUP BY " + "start_regimen " + "ORDER BY " + "regimen.regimen_desc " + "ASC";
	console.log(sql);
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getPatientsEnrolledPeriodSummary1(symbol, gender, start_date, end_date, dataSelectHandler) {
	var sql = "SELECT count(service) as total FROM patient where date('now')-dob" + symbol + " AND service=1 AND gender='" + gender + "' AND strftime('%Y-%m-%d',date_enrolled) between strftime('%Y-%m-%d','" + start_date + "') and strftime('%Y-%m-%d','" + end_date + "')";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function patientListing_dateStarted(start_date, dataSelectHandler) {
	var sql = "SELECT * from patient where date_enrolled='" + start_date + "'";
	console.log(sql);
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function patientListingByRegimen(start_date, end_date, dataSelectHandler) {
	var sql = "SELECT regimen.regimen_desc regimen,count(patient.start_regimen) total FROM patient,regimen WHERE regimen.id=patient.start_regimen AND service=1 AND strftime('%Y-%m-%d',date_enrolled) between strftime('%Y-%m-%d','" + start_date + "') and strftime('%Y-%m-%d','" + end_date + "') group by regimen.id";
	console.log(sql);
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getAppointmentSummary(dataSelectHandler) {
	var sql = "SELECT distinct appointment,count(distinct patient) as patients FROM `patient_appointment` group by appointment order by appointment desc";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getCumulativePatientNumber(start_date, dataSelectHandler) {
	var sql = "SELECT distinct patient_status.Name, count(patient.current_status) as total FROM patient,patient_status WHERE patient_status.id=patient.current_status AND strftime('%Y-%m-%d',date_enrolled)<strftime('%Y-%m-%d','" + start_date + "') GROUP BY patient_status.Name";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getPeriodDrugBalance(drug, start_date, end_date, dataSelectHandler) {
	var sql = "select case when 1=1 then '" + drug + "' end as drug,stock_in.*,sum(p.quantity) as total_dispensed from (select sum(ds.quantity) as total_received from drug_stock_movement ds left join transaction_type t on ds.transaction_type = t.id where drug = '" + drug + "' and t.effect = '1' and strftime('%Y-%m-%d',transaction_date) between strftime('%Y-%m-%d','" + start_date + "') and strftime('%Y-%m-%d','" + end_date + "')) stock_in left join patient_visit p on p.drug_id = '" + drug + "' and strftime('%Y-%m-%d',dispensing_date) between strftime('%Y-%m-%d','" + start_date + "') and strftime('%Y-%m-%d','" + end_date + "')";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getPeriodRegimenPatients(start_date, end_date, dataSelectHandler) {
	var sql = "select regimen, count(distinct patient_id) as patients from patient_visit where strftime('%Y-%m-%d',dispensing_date) between strftime('%Y-%m-%d','" + start_date + "') and strftime('%Y-%m-%d','" + end_date + "') group by regimen;";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getPeriodRegimenMos(start_date, end_date, dataSelectHandler) {
	var sql = "select regimen,sum(mos) as total_mos from (select regimen, months_of_stock as mos from patient_visit where strftime('%Y-%m-%d',dispensing_date) between strftime('%Y-%m-%d','" + start_date + "') and strftime('%Y-%m-%d','" + end_date + "') group by patient_id) group by regimen;";
	console.log(sql);
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getOpeningDrugBalance(drug, start_date, dataSelectHandler) {
	var sql = "select stock_in.*,sum(p.quantity) as total_dispensed from (select sum(ds.quantity) as total_received from drug_stock_movement ds left join transaction_type t on ds.transaction_type = t.id where drug = '" + drug + "' and t.effect = '1' and strftime('%Y-%m-%d',transaction_date) <= strftime('%Y-%m-%d','" + start_date + "')) stock_in left join patient_visit p on p.drug_id = '" + drug + "' where strftime('%Y-%m-%d',dispensing_date) <= strftime('%Y-%m-%d','" + start_date + "')";
	//console.log(sql);
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//Get all patient visit records for this patient
function getPatientDispensingHistory(patient, dataSelectHandler) {
	var sql = "select * from patient_visit pv left join drugcode d on pv.drug_id = d.id left join visit_purpose v on pv.visit_purpose = v.id where pv.patient_id = '" + patient + "' order by dispensing_date desc limit 50";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getDispensingDetails(dispensing_id, dataSelectHandler) {
	var sql = "select * from patient_visit pv left join patient p on pv.patient_id = p.patient_number_ccc where pv.id = '" + dispensing_id + "'";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getStatisticNumbers(date, adult_or_child, gender, status, status_name, dataSelectHandler) {
	var sql = "";
	if(adult_or_child == "adult") {
		sql = "select case when 1=1 then '" + status + "' end as passed_status, case when 1=1 then '" + status_name + "' end as passed_status_name,'' as total,'' as name union all select test.* from (select '','',count(*) as total,r.name from patient p left join regimen_service_type r on p.service = r.id  where current_status = '" + status + "' and gender = '" + gender + "' and (((strftime('%Y', 'now') - strftime('%Y', dob))) >=15 or coalesce((strftime('%Y', 'now') - strftime('%Y', dob)),'x') = 'x') and date(date_enrolled) <= date('" + date + "')  group by service) test ";
	}
	if(adult_or_child == "child") {
		sql = "select case when 1=1 then '" + status + "' end as passed_status,case when 1=1 then '" + status_name + "' end as passed_status_name ,'' as total,'' as name union all select test.* from (select '','',  count(*) as total,r.name from patient p  left join regimen_service_type r on p.service = r.id  where current_status = '" + status + "' and gender = '" + gender + "' and (((strftime('%Y', 'now') - strftime('%Y', dob))) <15) and date(date_enrolled) <= date('" + date + "')  group by service) test ";

	}
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getRegimenStatisticNumbers(start_date, end_date, adult_or_child, gender, regimen, regimen_name, dataSelectHandler) {
	var sql = "";
	if(adult_or_child == "adult") {
		sql = "select case when 1=1 then '" + regimen + "' end as passed_regimen, case when 1=1 then '" + regimen_name + "' end as passed_regimen_name,'' as total,'' as name union all select test.* from (select '','',count(*) as total,r.regimen_desc from patient p left join regimen r on p.start_regimen = r.id  where start_regimen = '" + regimen + "' and gender = '" + gender + "' and (((strftime('%Y', 'now') - strftime('%Y', dob))) >=15 or coalesce((strftime('%Y', 'now') - strftime('%Y', dob)),'x') = 'x') and date(start_regimen_date) between date('" + start_date + "') and date('" + end_date + "') group by start_regimen) test ";
	}
	if(adult_or_child == "child") {
		sql = "select case when 1=1 then '" + regimen + "' end as passed_regimen,case when 1=1 then '" + regimen_name + "' end as passed_regimen_name ,'' as total,'' as name union all select test.* from (select '','',  count(*) as total,r.regimen_desc from patient p  left join regimen r on p.start_regimen = r.id  where start_regimen = '" + regimen + "' and gender = '" + gender + "' and (((strftime('%Y', 'now') - strftime('%Y', dob))) <15) and date(start_regimen_date) between date('" + start_date + "') and date('" + end_date + "') group by start_regimen) test ";

	}
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getEnrolledRegimenStatisticNumbers(start_date, end_date, adult_or_child, gender, regimen, regimen_name, dataSelectHandler) {
	var sql = "";
	if(adult_or_child == "adult") {
		sql = "select case when 1=1 then '" + regimen + "' end as passed_regimen, case when 1=1 then '" + regimen_name + "' end as passed_regimen_name,'' as total,'' as name union all select test.* from (select '','',count(*) as total,r.regimen_desc from patient p left join regimen r on p.start_regimen = r.id  where start_regimen = '" + regimen + "' and gender = '" + gender + "' and (((strftime('%Y', 'now') - strftime('%Y', dob))) >=15 or coalesce((strftime('%Y', 'now') - strftime('%Y', dob)),'x') = 'x') and date(date_enrolled) between date('" + start_date + "') and date('" + end_date + "') group by start_regimen) test ";
	}
	if(adult_or_child == "child") {
		sql = "select case when 1=1 then '" + regimen + "' end as passed_regimen,case when 1=1 then '" + regimen_name + "' end as passed_regimen_name ,'' as total,'' as name union all select test.* from (select '','',  count(*) as total,r.regimen_desc from patient p  left join regimen r on p.start_regimen = r.id  where start_regimen = '" + regimen + "' and gender = '" + gender + "' and (((strftime('%Y', 'now') - strftime('%Y', dob))) <15) and date(date_enrolled) between date('" + start_date + "') and date('" + end_date + "') group by start_regimen) test ";

	}
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getStatusTotals(date, dataSelectHandler) {
	var sql = "select count(p.id) as total,current_status,ps.name from patient_status ps left join patient p  on ps.id = current_status where date(date_enrolled) <= date('" + date + "')  group by ps.id";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getRegimenTotals(start_date, end_date, dataSelectHandler) {
	var sql = "select count(*) as total,start_regimen,regimen_desc from patient p left join regimen r  on p.start_regimen = r.id where date(start_regimen_date) between date('" + start_date + "') and date('" + end_date + "')  group by start_regimen";
	console.log(sql);
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getEnrolledRegimenTotals(start_date, end_date, dataSelectHandler) {
	var sql = "select count(*) as total,start_regimen,regimen_desc from patient p left join regimen r  on p.start_regimen = r.id where date(date_enrolled) between date('" + start_date + "') and date('" + end_date + "')  group by start_regimen";
	console.log(sql);
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getBasicPatientDetails(patient_id, dataSelectHandler) {
	var sql = "select patient_number_ccc,gender, first_name, last_name, other_name,dob, date_enrolled, start_regimen_date, s.name as current_status from patient p left join patient_status s on p.current_status = s.id where patient_number_ccc = '" + patient_id + "'";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getSixMonthsDispensing(patient_id, dataSelectHandler) {
	var sql = "select * from patient_visit pv left join drugcode d on pv.drug_id = d.id where patient_id = '" + patient_id + "' and date(dispensing_date) > date('now','-6 months') ";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getRegimenChangeHistory(patient_id, dataSelectHandler) {
	var sql = "select dispensing_date, r1.regimen_desc as current_regimen, r2.regimen_desc as previous_regimen, rc.name as reason from patient_visit pv left join regimen r1 on pv.regimen = r1.id left join regimen r2 on pv.last_regimen = r2.id left join regimen_change_purpose rc on pv.regimen_change_reason = rc.id   where patient_id = '" + patient_id + "' and regimen != last_regimen group by dispensing_date";
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function getAppointmentAdherence(patient_id, dataSelectHandler) {
	var sql = "select appointment,dispensing_date,(julianday(date(dispensing_date)) - julianday(date(appointment))) as days_late from patient_appointment  left join (select distinct dispensing_date,patient_id from patient_visit where patient_id = '" + patient_id + "' and date(dispensing_date) > date('now','-6 months')) visits on patient= patient_id and date(appointment) > date('now','-6 months') where patient = '" + patient_id + "' order by appointment,dispensing_date";
	console.log(sql);
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

//count the total number of records in a particular table
function countTotalPatients(date, dataSelectHandler) {
	var sql = "select count(*) as total from patient where date(date_enrolled) <= date('" + date + "')";
	console.log(sql);
	SQLExecuteAbstraction(sql, dataSelectHandler);
}

function SQLExecuteAbstraction(sql, dataSelectHandler) {
	DEMODB.transaction(function(transaction) {
		transaction.executeSql(sql, [], dataSelectHandler, errorHandler);
	});
}
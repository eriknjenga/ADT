<?php
class Synchronize_Pharmacy extends MY_Controller {
	function __construct() {
		parent::__construct();
		$this -> load -> helper('json');
	}

	public function index() {
		$data = array();
		$data['content_view'] = "synchronize_pharmacy_v";
		$this -> base_params($data);
	}

	public function base_params($data) {
		$data['title'] = "Synchronization";
		$data['banner_text'] = "Synchronization";
		$data['link'] = "synchronize";
		$data['scripts'] = array('canvas_progressbar.js', 'ajax_queue.js');
		$this -> load -> view('template', $data);
	}

	//Get the total Number of drugs in the server
	public function getTotalServerDrugs() {
		$source = $this -> session -> userdata('facility');
		$number = Drugcode::getTotalNumber($source);
		echo $number;
	}

	//Get the total Number of drug units in the server
	public function getTotalServerDrugUnits() {
		$number = Drug_Unit::getTotalNumber();
		echo $number;
	}

	//Get the total Number of doses in the server
	public function getTotalServerDoses() {
		$number = Dose::getTotalNumber();
		echo $number;
	}

	//Get the total Number of districts in the server
	public function getTotalServerDistricts() {
		$number = District::getTotalNumber();
		echo $number;
	}

	//Get the total Number of drugs in the server
	public function getTotalServerOIs() {
		$number = Opportunistic_Infection::getTotalNumber();
		echo $number;
	}

	//Get the total Number of patient sources in the server
	public function getTotalServerPatientSources() {
		$number = Patient_Source::getTotalNumber();
		echo $number;
	}

	//Get the total Number of regimens in the server
	public function getTotalServerRegimens() {
		$source = $this -> session -> userdata('facility');
		$number = Regimen::getTotalNumber($source);
		echo $number;
	}

	//Get the total Number of regimen change reasons in the server
	public function getTotalServerRegimenChangeReasons() {
		$number = Regimen_Change_Purpose::getTotalNumber();
		echo $number;
	}

	//Get the total Number of regimen change reasons in the server
	public function getTotalServerRegimenDrugs() {
		$source = $this -> session -> userdata('facility');
		$number = Regimen_Drug::getTotalNumber($source);
		echo $number;
	}

	//Get the total Number of regimen service types in the server
	public function getTotalServerRegimenServiceTypes() {
		$number = Regimen_Service_Type::getTotalNumber();
		echo $number;
	}

	//Get the total Number of visit purposes in the server
	public function getTotalServerVisitPurposes() {
		$number = Visit_Purpose::getTotalNumber();
		echo $number;
	}

	//Get the total Number of patient_statuses in the server
	public function getTotalServerPatientStatuses() {
		$number = Patient_Status::getTotalNumber();
		echo $number;
	}

	//Get total number of patients for a facility
	public function check_patient_numbers($facility) {
		$total_patients = Patient::getPatientNumbers($facility);
		echo $total_patients;
	}

	//Get total number of patient appointments for a facility
	public function check_patient_appointment_numbers($facility) {
		$total_patients = Patient_Appointment::getTotalAppointments($facility);
		echo $total_patients;
	}

	//Get total number of patient visits for a facility
	public function check_patient_visit_numbers($facility) {
		$total_patients = Patient_Visit::getTotalVisits($facility);
		echo $total_patients;
	}

	//Get total number of drug transactions for a facility
	public function check_drug_transaction_numbers($facility) {
		$total_transactions = Drug_Stock_Movement::getTotalTransactions($facility);
		echo $total_transactions;
	}

	public function getDrugs($offset, $limit) {
		$source = $this -> session -> userdata('facility');
		$drugs = Drugcode::getPagedDrugs($offset, $limit, $source);
		$counter = 0;
		$drugs_array = array();
		foreach ($drugs as $drug) {
			$drug_details = array("id" => $drug -> id, "drug" => $drug -> Drug, "unit" => $drug -> Unit, "pack_size" => $drug -> Pack_Size, "safety_quantity" => $drug -> Safety_Quantity, "generic_name" => $drug -> Generic -> Name, "supported_by" => $drug -> Supporter -> Name, "dose" => $drug -> Drug_Dose -> Name, "duration" => $drug -> Duration, "quantity" => $drug -> Quantity, "source" => $drug -> Source);
			$drugs_array[$counter] = $drug_details;
			$counter++;
		}
		echo json_encode($drugs_array);
	}

	public function getDrugUnits($offset, $limit) {
		$drug_units = Drug_Unit::getPagedDrugUnits($offset, $limit);
		$counter = 0;
		$drug_units_array = array();
		foreach ($drug_units as $unit) {
			$drug_unit_details = array("id" => $unit -> id, "name" => $unit -> Name);
			$drug_units_array[$counter] = $drug_unit_details;
			$counter++;
		}
		echo json_encode($drug_units_array);
	}

	public function getDoses($offset, $limit) {
		$doses = Dose::getPagedDoses($offset, $limit);
		$counter = 0;
		$doses_array = array();
		foreach ($doses as $dose) {
			$dose_details = array("id" => $dose -> id, "name" => $dose -> Name, "value" => $dose -> Value, "frequency" => $dose -> Frequency);
			$doses_array[$counter] = $dose_details;
			$counter++;
		}
		echo json_encode($doses_array);
	}

	public function getDistricts($offset, $limit) {
		$districts = District::getPagedDistricts($offset, $limit);
		$counter = 0;
		$districts_array = array();
		foreach ($districts as $district) {
			$district_details = array("id" => $district -> id, "name" => $district -> Name);
			$districts_array[$counter] = $district_details;
			$counter++;
		}
		echo json_encode($districts_array);
	}

	public function getOIs($offset, $limit) {
		$ois = Opportunistic_Infection::getPagedOIs($offset, $limit);
		$counter = 0;
		$ois_array = array();
		foreach ($ois as $oi) {
			$oi_details = array("id" => $oi -> id, "name" => $oi -> Name);
			$ois_array[$counter] = $oi_details;
			$counter++;
		}
		echo json_encode($ois_array);
	}

	public function getPatientSources($offset, $limit) {
		$sources = Patient_Source::getPagedSources($offset, $limit);
		$counter = 0;
		$sources_array = array();
		foreach ($sources as $source) {
			$source_details = array("id" => $source -> id, "name" => $source -> Name);
			$sources_array[$counter] = $source_details;
			$counter++;
		}
		echo json_encode($sources_array);
	}

	public function getRegimens($offset, $limit) {
		$source = $this -> session -> userdata('facility');
		$regimens = Regimen::getPagedRegimens($offset, $limit, $source);
		$counter = 0;
		$regimens_array = array();
		foreach ($regimens as $regimen) {
			$regimen_details = array("id" => $regimen -> id, "regimen_code" => $regimen -> Regimen_Code, "regimen_desc" => $regimen -> Regimen_Desc, "category" => $regimen -> Regimen_Category -> Name, "line" => $regimen -> Line, "type_of_service" => $regimen -> Type_Of_Service, "remarks" => $regimen -> Remarks, "source" => $regimen -> Source);
			$regimens_array[$counter] = $regimen_details;
			$counter++;
		}
		echo json_encode($regimens_array);
	}

	public function getRegimenChangeReasons($offset, $limit) {
		$purposes = Regimen_Change_Purpose::getPagedPurposes($offset, $limit);
		$counter = 0;
		$purposes_array = array();
		foreach ($purposes as $purpose) {
			$purpose_details = array("id" => $purpose -> id, "name" => $purpose -> Name);
			$purposes_array[$counter] = $purpose_details;
			$counter++;
		}
		echo json_encode($purposes_array);
	}

	public function getRegimenDrugs($offset, $limit) {
		$source = $this -> session -> userdata('facility');
		$regimen_drugs = Regimen_Drug::getPagedRegimenDrugs($offset, $limit, $source);
		$counter = 0;
		$regimen_drugs_array = array();
		foreach ($regimen_drugs as $regimen_drug) {
			$regimen_drug_details = array("id" => $regimen_drug -> id, "regimen" => $regimen_drug -> Regimen, "drugcode" => $regimen_drug -> Drugcode);
			$regimen_drugs_array[$counter] = $regimen_drug_details;
			$counter++;
		}
		echo json_encode($regimen_drugs_array);
	}

	public function getRegimenServiceTypes($offset, $limit) {
		$service_types = Regimen_Service_Type::getPagedTypes($offset, $limit);
		$counter = 0;
		$service_types_array = array();
		foreach ($service_types as $service_type) {
			$service_type_details = array("id" => $service_type -> id, "name" => $service_type -> Name);
			$service_types_array[$counter] = $service_type_details;
			$counter++;
		}
		echo json_encode($service_types_array);
	}

	public function getVisitPurposes($offset, $limit) {
		$visit_purposes = Visit_Purpose::getPagedPurposes($offset, $limit);
		$counter = 0;
		$visit_purposes_array = array();
		foreach ($visit_purposes as $visit_purpose) {
			$visit_purpose_details = array("id" => $visit_purpose -> id, "name" => $visit_purpose -> Name);
			$visit_purposes_array[$counter] = $visit_purpose_details;
			$counter++;
		}
		echo json_encode($visit_purposes_array);
	}

	public function getPatientStatuses($offset, $limit) {
		$patient_statuses = Patient_Status::getPagedStatuses($offset, $limit);
		$counter = 0;
		$patient_statuses_array = array();
		foreach ($patient_statuses as $patient_statuse) {
			$patient_statuses_details = array("id" => $patient_statuse -> id, "name" => $patient_statuse -> Name);
			$patient_statuses_array[$counter] = $patient_statuses_details;
			$counter++;
		}
		echo json_encode($patient_statuses_array);
	}

	public function getPatients($facility, $offset, $limit) {
		$aggregated_object = array();
		//Retrieve the machine code data from the data passed
		$machine_code_data = $this -> input -> post("machine_codes");
		//Check if the client has returned any machine code data. If not, retrieve all relevant data for that facility
		if (strlen($machine_code_data) == 0) {
			$aggregated_object = Patient::getPagedFacilityPatients($offset, $limit, $facility);
		} else {
			//Split the machine codes to separate all the discrete sets
			$split_data = explode(",", $machine_code_data);
			//Loop through each individual machine code set and retrieve it's data
			foreach ($split_data as $data_element) {
				if (strlen($data_element) > 0) {
					//Separate the machine code and the patient_number_ccc
					$separated_variables = explode(":", $data_element);
					$machine_code = $separated_variables[0];
					$patient_ccc = $separated_variables[1];
					//Get all new patients since the last synchronization
					$patients_data = Patient::getPagedPatients($offset, $limit, $machine_code, $patient_ccc, $facility);
					//Append the results to the array that will be sent back to the client machine
					$aggregated_object += $patients_data;
				}
			}
		}
		$counter = 0;
		$patients_array = array();
		foreach ($aggregated_object as $patient) {
			$patient_details = array("medical_record_number" => $patient['Medical_Record_Number'], "patient_number_ccc" => $patient['Patient_Number_CCC'], "first_name" => $patient['First_Name'], "last_name" => $patient['Last_Name'], "other_name" => $patient['Other_Name'], "dob" => $patient['Dob'], "pob" => $patient['Pob'], "gender" => $patient['Gender'], "pregnant" => $patient['Pregnant'], "weight" => $patient['Weight'], "height" => $patient['Height'], "sa" => $patient['Sa'], "phone" => $patient['Phone'], "physical" => $patient['Physical'], "alternate" => $patient['Alternate'], "other_illnesses" => $patient['Other_Illnesses'], "other_drugs" => $patient['Other_Drugs'], "adr" => $patient['Adr'], "tb" => $patient['Tb'], "smoke" => $patient['Smoke'], "alcohol" => $patient['Alcohol'], "date_enrolled" => $patient['Date_Enrolled'], "source" => $patient['Source'], "supported_by" => $patient['Supported_By'], "timestamp" => $patient['Timestamp'], "facility_code" => $patient['Facility_Code'], "service" => $patient['Service'], "start_regimen" => $patient['Start_Regimen'], "machine_code" => $patient['Machine_Code'], "current_status" => $patient['Current_Status'], "sms_consent" => $patient['SMS_Consent'], "partner" => $patient['Partner'], "fplan" => $patient['Fplan'], "tbphase" => $patient['Tbphase'], "startphase" => $patient['Startphase'], "endphase" => $patient['Endphase'], "partner_status" => $patient['Partner_Status']);
			$patients_array[$counter] = $patient_details;
			$counter++;
		}
		echo json_encode($patients_array);
	}

	public function getPatientAppointments($facility, $offset, $limit) {
		$aggregated_object = array();
		//Retrieve the machine code data from the data passed
		$machine_code_data = $this -> input -> post("machine_codes");
		//Check if the client has returned any machine code data. If not, retrieve all relevant data for that facility
		if (strlen($machine_code_data) == 0) {
			$aggregated_object = Patient_Appointment::getPagedFacilityPatientAppointments($offset, $limit, $facility);
		} else {
			//Split the machine codes to separate all the discrete sets
			$split_data = explode(",", $machine_code_data);
			//Loop through each individual machine code set and retrieve it's data
			foreach ($split_data as $data_element) {
				if (strlen($data_element) > 0) {
					//Separate the machine code and the patient_number_ccc
					$separated_variables = explode(":", $data_element);
					$machine_code = $separated_variables[0];
					$patient_ccc = $separated_variables[1];
					$appointment = $separated_variables[2];
					//Get all new patients since the last synchronization
					$patient_appointments_data = Patient_Appointment::getPagedPatientAppointments($offset, $limit, $machine_code, $patient_ccc, $facility, $appointment);
					//Append the results to the array that will be sent back to the client machine
					$aggregated_object += $patient_appointments_data;
				}
			}
		}
		$counter = 0;
		$patient_appointments_array = array();
		foreach ($aggregated_object as $patient_appointment) {
			$patient_appointment_details = array("patient" => $patient_appointment['Patient'], "appointment" => $patient_appointment['Appointment'], "machine_code" => $patient_appointment['Machine_Code'], "facility" => $patient_appointment['Facility']);
			$patient_appointments_array[$counter] = $patient_appointment_details;
			$counter++;
		}
		echo json_encode($patient_appointments_array);
	}

	public function getPatientVisits($facility, $offset, $limit) {
		$aggregated_object = array();
		//Retrieve the machine code data from the data passed
		$machine_code_data = $this -> input -> post("machine_codes");
		//Check if the client has returned any machine code data. If not, retrieve all relevant data for that facility
		if (strlen($machine_code_data) == 0) {
			$aggregated_object = Patient_Visit::getPagedFacilityPatientVisits($offset, $limit, $facility);
		} else {
			//Split the machine codes to separate all the discrete sets
			$split_data = explode(",", $machine_code_data);
			//Loop through each individual machine code set and retrieve it's data
			foreach ($split_data as $data_element) {
				if (strlen($data_element) > 0) {
					//Separate the machine code and the patient_number_ccc
					$separated_variables = explode(":", $data_element);
					$machine_code = $separated_variables[0];
					$patient_ccc = $separated_variables[1];
					$date = $separated_variables[2];
					$drug = $separated_variables[3];
					//Get all new patients since the last synchronization
					$patient_visits_data = Patient_Visit::getPagedPatientVisits($offset, $limit, $machine_code, $patient_ccc, $facility, $date, $drug);
					//Append the results to the array that will be sent back to the client machine
					$aggregated_object += $patient_visits_data;
				}
			}
		}

		$counter = 0;
		$patient_visits_array = array();
		foreach ($aggregated_object as $patient_visit) {
			$patient_visit_details = array("patient_id" => $patient_visit['Patient_Id'], "visit_purpose" => $patient_visit['Visit_Purpose'], "current_height" => $patient_visit['Current_Height'], "current_weight" => $patient_visit['Current_Weight'], "regimen" => $patient_visit['Regimen'], "regimen_change_reason" => $patient_visit['Regimen_Change_Reason'], "drug_id" => $patient_visit['Drug_Id'], "batch_number" => $patient_visit['Batch_Number'], "brand" => $patient_visit['Brand'], "indication" => $patient_visit['Indication'], "pill_count" => $patient_visit['Pill_Count'], "comment" => $patient_visit['Comment'], "timestamp" => $patient_visit['Timestamp'], "user" => $patient_visit['User'], "facility" => $patient_visit['Facility'], "dose" => $patient_visit['Dose'], "dispensing_date" => $patient_visit['Dispensing_Date'], "dispensing_date_timestamp" => $patient_visit['Current_Height'], "quantity" => $patient_visit['Quantity'], "machine_code" => $patient_visit['Machine_Code'], "last_regimen" => $patient_visit['Last_Regimen'], "duration" => $patient_visit['Duration'], "adherence" => $patient_visit['Adherence'], "missed_pills" => $patient_visit['Missed_Pills'], "months_of_stock" => $patient_visit['Months_Of_Stock']);
			$patient_visits_array[$counter] = $patient_visit_details;
			$counter++;
		}
		echo json_encode($patient_visits_array);
	}

	public function getDrugTransactions($facility, $offset, $limit) {
		$aggregated_object = array();
		//Retrieve the machine code data from the data passed
		$machine_code_data = $this -> input -> post("machine_codes");
		//Check if the client has returned any machine code data. If not, retrieve all relevant data for that facility
		if (strlen($machine_code_data) == 0) {
			$aggregated_object = Drug_Stock_Movement::getPagedFacilityTransactions($offset, $limit, $facility);
		} else {
			//Split the machine codes to separate all the discrete sets
			$split_data = explode(",", $machine_code_data);
			//Loop through each individual machine code set and retrieve it's data
			foreach ($split_data as $data_element) {
				if (strlen($data_element) > 0) {
					//Separate the machine code and the patient_number_ccc
					$separated_variables = explode(":", $data_element);
					$machine_code = $separated_variables[0];
					$drug = $separated_variables[1];
					$order_number = $separated_variables[2];
					$transaction_date = $separated_variables[3];
					//Get all new patients since the last synchronization
					$drug_transaction_data = Drug_Stock_Movement::getPagedTransactions($offset, $limit, $machine_code, $drug, $facility, $transaction_date,$order_number);
					
					//Append the results to the array that will be sent back to the client machine
					$aggregated_object += $drug_transaction_data;
				}
			}
		}
		$counter = 0;
		$drug_transactions_array = array();
		foreach ($aggregated_object as $drug_transaction) {
			$drug_transaction_details = array("machine_code" => $drug_transaction['Machine_Code'], "drug" => $drug_transaction['Drug'], "transaction_date" => $drug_transaction['Transaction_Date'], "batch_number" => $drug_transaction['Batch_Number'],"transaction_type" => $drug_transaction['Transaction_Type'], "source" => $drug_transaction['Source'], "destination" => $drug_transaction['Destination'], "expiry_date" => $drug_transaction['Expiry_date'],"packs" => $drug_transaction['Packs'], "quantity" => $drug_transaction['Quantity'], "unit_cost" => $drug_transaction['Unit_Cost'], "amount" => $drug_transaction['Amount'],"remarks" => $drug_transaction['Remarks'], "operator" => $drug_transaction['Operator'], "order_number" => $drug_transaction['Order_Number'], "facility" => $drug_transaction['Facility'],"machine_code" => $drug_transaction['Machine_Code']);
			$drug_transactions_array[$counter] = $drug_transaction_details;
			$counter++;
		}
		echo json_encode($drug_transactions_array);
	}

}

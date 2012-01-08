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
		$number = Drugcode::getTotalNumber();
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
		$number = Regimen::getTotalNumber();
		echo $number;
	}

	//Get the total Number of regimen change reasons in the server
	public function getTotalServerRegimenChangeReasons() {
		$number = Regimen_Change_Purpose::getTotalNumber();
		echo $number;
	}

	//Get the total Number of regimen change reasons in the server
	public function getTotalServerRegimenDrugs() {
		$number = Regimen_Drug::getTotalNumber();
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

	public function getDrugs($offset, $limit) {
		$drugs = Drugcode::getPagedDrugs($offset, $limit);
		$counter = 0;
		$drugs_array = array();
		foreach ($drugs as $drug) {
			$drug_details = array("id" => $drug -> id, "drug" => $drug -> Drug, "unit" => $drug -> Unit, "pack_size" => $drug -> Pack_Size, "safety_quantity" => $drug -> Safety_Quantity, "generic_name" => $drug -> Generic -> Name, "supported_by" => $drug -> Supporter -> Name, "dose" => $drug -> Drug_Dose -> Name, "duration" => $drug -> Duration, "quantity" => $drug -> Quantity);
			$drugs_array[$counter] = $drug_details;
			$counter++;
		}
		echo json_encode($drugs_array);
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
		$regimens = Regimen::getPagedRegimens($offset, $limit);
		$counter = 0;
		$regimens_array = array();
		foreach ($regimens as $regimen) {
			$regimen_details = array("id" => $regimen -> id, "regimen_code" => $regimen -> Regimen_Code, "regimen_desc" => $regimen -> Regimen_Desc, "category" => $regimen -> Regimen_Category -> Name, "line" => $regimen -> Line, "type_of_service" => $regimen -> Regimen_Service_Type -> Name, "remarks" => $regimen -> Remarks);
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
		$regimen_drugs = Regimen_Drug::getPagedRegimenDrugs($offset, $limit);
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

	public function getPatients($offset, $limit) {
		$machine_code_data = $this->input->post("machine_codes");
		$split_data = explode(",", $machine_code_data);
		foreach ($split_data as $data_element){
			if(strlen($data_element)>0){
				$separated_variables = explode(":", $data_element);
				$machine_code = $separated_variables[0];
				$patient_ccc = $separated_variables[1];
				Patient::getPagedPatients($offset, $limit,$machine_code,$patient_ccc);
			}
		}
		/*
		$patients = Patient::getPagedPatients($offset, $limit);
		$counter = 0;
		$patients_array = array();
		foreach ($patients as $patient) {
			$patient_details = array("medical_record_number" => $patient -> Medical_Record_Number, "patient_number_ccc" => $patient -> Patient_Number_CCC, "first_name" => $patient -> First_Name, "last_name" => $patient -> Last_Name, "other_name" => $patient -> Other_Name, "dob" => $patient -> Dob, "pob" => $patient -> Pob, "gender" => $patient -> Gender, "pregnant" => $patient -> Pregnant, "weight" => $patient -> Weight, "height" => $patient -> Height, "sa" => $patient -> Sa, "phone" => $patient -> Phone, "physical" => $patient -> Physical, "alternate" => $patient -> Alternate, "other_illnesses" => $patient -> Other_Illnesses, "other_drugs" => $patient -> Other_Drugs, "adr" => $patient -> Adr, "tb" => $patient -> Tb, "smoke" => $patient -> Smoke, "alcohol" => $patient -> Alcohol, "date_enrolled" => $patient -> Date_Enrolled, "source" => $patient -> Source, "supported_by" => $patient -> Supported_By, "timestamp" => $patient -> Timestamp, "facility_code" => $patient -> Facility_Code, "service" => $patient -> Service, "start_regimen" => $patient -> Start_Regimen, "machine_code" => $patient -> Machine_Code);
			$patients_array[$counter] = $patient_details;
			$counter++;
		}
		echo json_encode($patients_array);
		 * */
		 
	}

}

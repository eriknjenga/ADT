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
			$regimen_drug_details = array("id" => $regimen_drug -> id, "regimen" => $regimen_drug -> Regimen,"drugcode" => $regimen_drug -> Drugcode);
			$regimen_drugs_array[$counter] = $regimen_drug_details;
			$counter++;
		}
		echo json_encode($regimen_drugs_array);
	}

}

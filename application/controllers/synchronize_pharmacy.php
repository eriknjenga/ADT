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
		$data['scripts'] = array('canvas_progressbar.js','ajax_queue.js');
		$this -> load -> view('template', $data);
	}

	public function getServerDrugs() {
		$number = Drugcode::getTotalNumber();
		echo $number;
	}

	public function getAllDrugs($offset, $limit) {
		$drugs = Drugcode::getPagedDrugs($offset, $limit);
		$counter = 0;
		$drugs_array = array();
		foreach ($drugs as $drug) {
			$drug_details = array("drug" => $drug -> Drug, "unit" => $drug -> Unit, "pack_size" => $drug -> Pack_Size, "safety_quantity" => $drug -> Safety_Quantity, "generic_name" => $drug -> Generic->Name, "supported_by" => $drug -> Supporter->Name, "dose" => $drug -> Drug_Dose->Name, "duration" => $drug -> Duration, "quantity" => $drug -> Quantity);
			$drugs_array[$counter] = $drug_details;
			$counter++;
		}
		echo json_encode($drugs_array);
	}

}

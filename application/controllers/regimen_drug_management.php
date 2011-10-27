<?php
class Regimen_Drug_Management extends MY_Controller {
	function __construct() {
		parent::__construct();
	}

	public function index() {
		$this -> listing();
	}

	public function listing() {
		$data = array();
		$data['settings_view'] = "regimen_drug_listing_v";
		$data['styles'] = array("jquery-ui.css");
		$data['scripts'] = array("jquery-ui.js");
		$data['regimens'] = Regimen::getAll();
		$data['regimen_categories'] = Regimen_Category::getAll();
		$data['regimen_service_types'] = Regimen_Service_Type::getAll();
		$data['drug_codes'] = Drugcode::getAll();
		$this -> base_params($data);
	}

	public function save() {
		if ($this -> input -> post()) {
			$regimen_drug = new Regimen_Drug();
			$regimen_drug->Regimen = $this -> input -> post('regimen') ;
			$regimen_drug->Drugcode = $this -> input -> post('drugid');
			$regimen_drug -> save();
		}
		redirect('regimen_drug_management/listing');

	}

	public function base_params($data) {
		$data['quick_link'] = "regimen_drug";
		$data['title'] = "System Settings";
		$data['content_view'] = "settings_v";
		$data['banner_text'] = "System Settings";
		$data['link'] = "settings";
		$this -> load -> view('template', $data);
	}

}
?>
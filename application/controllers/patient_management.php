<?php
class Patient_Management extends MY_Controller {
	function __construct() {
		parent::__construct();
	}

	public function index() {
		$this -> listing();
	}

	public function listing() {
		$data = array();
		$data['content_view'] = "patient_listing_v";  
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
		$data['title'] = "Patients"; 
		$data['banner_text'] = "Facility Patients";
		$data['link'] = "patients";
		$this -> load -> view('template', $data);
	}

}
?>
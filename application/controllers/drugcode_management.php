<?php
class Drugcode_management extends MY_Controller {
	function __construct() {
		parent::__construct();
	}

	public function index() {
		$this -> listing();
	}

	public function listing() {
		$data = array();
		$data['settings_view'] = "drugcode_listing_v";
		$data['drugcodes'] = Drugcode::getAll(); 
		$this -> table -> set_heading(array('id', 'Drug', 'Unit', 'Pack Size', 'Safety Quantity', 'Generic Name', 'Supported By','Quantity','Duration','Dose'));
		$this -> base_params($data);
		
	}

	public function add() {
		$data = array();
		$data['settings_view'] = "drugcode_add_v";
		$data['drug_units'] = Drug_Unit::getAll();
		$data['generic_names'] = Generic_Name::getAll();
		$data['supporters'] = Supporter::getAll();
		$data['doses'] = Dose::getAll();
		$this -> base_params($data);
	}

	public function save() {
		$valid = $this -> _submit_validate();
		if ($valid == false) {
			$this -> add();
		} else {
			$drugcode = new Drugcode();
			$drugcode -> Drug = $this -> input -> post('drug');
			$drugcode -> Unit = $this -> input -> post('unit');
			$drugcode -> Pack_Size = $this -> input -> post('pack_size');
			$drugcode -> Safety_Quantity = $this -> input -> post('safety_quantity');
			$drugcode -> Generic_Name = $this -> input -> post('generic_name');
			$drugcode -> Supported_By = $this -> input -> post('supported_by');
			$drugcode -> None_Arv = $this -> input -> post('none_arv');
			$drugcode -> Tb_Drug = $this -> input -> post('tb_drug');
			$drugcode -> Drug_In_Use = $this -> input -> post('drug_in_use');
			$drugcode -> Comment = $this -> input -> post('comment');
			$drugcode -> Dose = $this -> input -> post('dose');
			$drugcode -> Duration = $this -> input -> post('duration');
			$drugcode -> Quantity = $this -> input -> post('quantity');

			$drugcode -> save();
			redirect('drugcode_management');
		}

	}

	private function _submit_validate() {
		// validation rules
		$this -> form_validation -> set_rules('drug', 'Drug Name', 'trim|required|min_length[2]|max_length[100]');
		$this -> form_validation -> set_rules('pack_size', 'Pack Size', 'trim|required|min_length[2]|max_length[10]');

		return $this -> form_validation -> run();
	}

	public function base_params($data) {
		$data['styles'] = array("jquery-ui.css");
		$data['scripts'] = array("jquery-ui.js");
		$data['quick_link'] = "drugcode";
		$data['title'] = "System Settings";
		$data['content_view'] = "settings_v";
		$data['banner_text'] = "System Settings";
		$data['link'] = "settings";
		$this -> load -> view('template', $data);
	}

}
?>
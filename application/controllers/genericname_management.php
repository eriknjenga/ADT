<?php
class genericname_management extends MY_Controller {

	//required
	function __construct() {
		parent::__construct();
	}

	public function index() {
		$this -> listing();
	}

	public function listing() {
		$data = array();
		$data['settings_view'] = "generic_listing_v";
		$data['generic_names'] = Generic_Name::getAllHydrated();
		$this -> table -> set_heading(array('id', 'Name'));
		$this -> base_params($data);
	}

	public function save() {

		//call validation function
		$valid = $this -> _submit_validate();
		if ($valid == false) {
			$data['settings_view'] = "generic_listing_v";
			$this -> base_params($data);
		} else {
			$drugname = $this -> input -> post("drugname");
			$generic_name = new Generic_Name();
			$generic_name -> Name = $drugname;

			$generic_name -> save();
			redirect("genericname_management/listing");
		}

	}

	private function _submit_validate() {
		// validation rules
		$this -> form_validation -> set_rules('drugname', 'Generic Name', 'trim|required|min_length[2]|max_length[100]');

		return $this -> form_validation -> run();
	}

	public function base_params($data) {
		$data['styles'] = array("jquery-ui.css");
		$data['scripts'] = array("jquery-ui.js");
		$data['quick_link'] = "generic";
		$data['title'] = "System Settings";
		$data['content_view'] = "settings_v";
		$data['banner_text'] = "System Settings";
		$data['link'] = "settings";
		
		$this -> load -> view('template', $data);
	}

}

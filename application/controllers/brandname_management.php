<?php
class brandname_management extends MY_Controller {
	function __construct() {
		parent::__construct();
	}

	public function index() {
		$this -> listing();
	}

	public function listing() {
		$data = array();
		$data['settings_view'] = "brandname_listing_v";
		$data['drug_codes'] = Drugcode::getBrands();
		$this -> base_params($data);
	}

	public function add() {
		//class::method name
		$drugsandcodes = Drugcode::getDrugCodes();					
		$data['content_view'] = "brandname_add_v";
		$data['title'] = "Add New Brand Name";
		//view data
		$data['drugcodes'] = $drugsandcodes;
		
		$this -> base_params($data);
	}

	public function save() {
		//validation call
		$valid = $this -> _validate_submission();
		if ($valid == false) {
			$data['content_view'] = "brandname_add_v";
			$this -> base_params($data);
		} else {
			$drugid = $this -> input -> post("drugid");
			$brandname = $this -> input -> post("brandname");

			$brand = new Brand();
			$brand -> Drug_Id = $drugid;
			$brand -> Brand = $brandname;

			$brand -> save();
			redirect("brandname_management/listing");
		}
	}

	private function _validate_submission() {
		//check for select
		$this -> form_validation -> set_rules('brandname', 'Brand Name', 'trim|required|min_length[2]|max_length[25]');

		return $this -> form_validation -> run();
	}

	public function base_params($data) {
		$data['styles'] = array("jquery-ui.css");
		$data['scripts'] = array("jquery-ui.js");
		$data['quick_link'] = "brand";
		$data['title'] = "System Settings";
		$data['content_view'] = "settings_v";
		$data['banner_text'] = "System Settings";
		$data['link'] = "settings";
		
		$this -> load -> view('template', $data);
	}

}

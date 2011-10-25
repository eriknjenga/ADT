<?php
class brandname_management extends MY_Controller {
	function __construct() {
		parent::__construct();
	}

	public function index() {
		$this -> brandlisting();
	}

	public function brandlisting() {
		echo "Brand Listings go here";
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

			$brand -> drug_id = $drugid;
			$brand -> brand = $brandname;

			$brand -> save();
			redirect("brandname_management/add");
		}
	}

	private function _validate_submission() {
		//check for select
		$this -> form_validation -> set_rules('brandname', 'Brand Name', 'trim|required|min_length[2]|max_length[25]');

		return $this -> form_validation -> run();
	}

	public function base_params($data) {

		$this -> load -> view('template', $data);
	}

}

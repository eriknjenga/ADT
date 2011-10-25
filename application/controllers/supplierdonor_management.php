<?php
class supplierdonor_management extends MY_Controller {
	function __construct() {
		parent::__construct();
	}

	public function index() {
		$this -> sdlisting();
	}

	public function sdlisting() {
		echo "Suppliers and Donors go here";
	}

	public function add() {
		$data['content_view'] = "supplierdonorname_add_v";
		$data['title'] = "Add New Supplier or Donor";
		$this -> base_params($data);
	}

	public function save() {
		//validation call
		$valid = $this -> _validate_submission();
		if ($valid == false) {
			$data['content_view'] = "supplierdonorname_add_v";
			$this -> base_params($data);
		} else {
			$supplierdonorname = $this -> input -> post("supplierdonorname");
			$supplier_donor = new Supplier_Donor();
			$supplier_donor -> supplier_donor = $supplierdonorname;

			$supplier_donor -> save();
			redirect("supplierdonor_management/add");
		}
	}

	private function _validate_submission() {
		$this -> form_validation -> set_rules('supplierdonorname', 'Supplier or Donor', 'trim|required|min_length[2]|max_length[100]');

		return $this -> form_validation -> run();
	}

	public function base_params($data) {

		$this -> load -> view('template', $data);
	}

}//end class

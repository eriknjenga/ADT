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
		//Add code for listing here!
		echo "Listing to go here";
	}

	public function add() {
		//holds variable name of view to be displayed
		$data['content_view'] = "genericname_add_v";
		
		//view title
		$data['title'] = "Add New Generic Name";
		
		$this -> base_params($data);
	}

	public function save() {
		//call validation function
		$valid = $this -> _submit_validate();
		if ($valid == false) {
			$data['content_view'] = "genericname_add_v";
			$this -> base_params($data);
		}
		else{
			$drugname = $this->input->post("drugname");
			$generic_name = new Generic_Name();
			$generic_name->name = $drugname;
			
			$generic_name->save();
			redirect("genericname_management/add"); 
		}

	}

	private function _submit_validate() {
		// validation rules
		$this -> form_validation -> set_rules('drugname', 'Drug Name', 'trim|required|min_length[2]|max_length[100]');

		return $this -> form_validation -> run();
	}

	public function base_params($data) {
		
		$this -> load -> view('template', $data);
	}

}

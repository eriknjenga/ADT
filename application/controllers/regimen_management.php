<?php
class Regimen_management extends MY_Controller {
	function __construct() {
		parent::__construct();
	}

	public function index() {
		$this -> listing();
	}

	public function listing() {
		$data = array();
		$data['settings_view'] = "regimen_listing_v";
		$data['styles'] = array("jquery-ui.css");
		$data['scripts'] = array("jquery-ui.js");
		$data['regimens'] = Regimen::getAllHydrated(); 
		$this -> table -> set_heading(array('id', 'Regimen_Code', 'Regimen_Desc','Line','Enabled' ,'Regimen_Category','Type_Of_Service'));
		$data['regimen_categories'] = Regimen_Category::getAll();
		$data['regimen_service_types'] = Regimen_Service_Type::getAll();
		$this -> base_params($data);
	}

	public function save() {
		$regimen = new Regimen();
		$regimen -> Regimen_Code = $this -> input -> post('regimen_code');
		$regimen -> Regimen_Desc = $this -> input -> post('regimen_desc');
		$regimen -> Category = $this -> input -> post('category');
		$regimen -> Line = $this -> input -> post('line');
		$regimen -> Type_Of_Service = $this -> input -> post('type_of_service');
		$regimen -> Remarks = $this -> input -> post('remarks');
		$regimen -> Enabled = $this -> input -> post('show');

		$regimen -> save();
		redirect('regimen_management');
	}
 

	public function base_params($data) {
		$data['quick_link'] = "regimen";
		$data['title'] = "System Settings";
		$data['content_view'] = "settings_v";
		$data['banner_text'] = "System Settings";
		$data['link'] = "settings_management";
		$this -> load -> view('template', $data);
	}

}
?>
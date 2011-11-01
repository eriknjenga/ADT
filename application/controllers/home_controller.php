<?php
if (!defined('BASEPATH'))
	exit('No direct script access allowed');

class Home_Controller extends MY_Controller {
	function __construct() {
		parent::__construct();
	}

	public function index() {
		$data['title'] = "System Home";
		$data['content_view'] = "home_v";
		$data['banner_text'] = "Dashboards";
		$data['link'] = "home";
		//Check if the user is a pharmacist. If so, update his/her local envirinment with current values
		if ($this -> session -> userdata('access_level') == "3") {
			$data['regimens'] = Regimen::getAll();
			$data['supporters'] = Supporter::getAll();
			$data['service_types'] = Regimen_Service_Type::getAll();
			$data['sources'] = Patient_Source::getAll();
			$data['drugs'] = Drugcode::getAll();
			$data['regimen_change_purpose'] = Regimen_Change_Purpose::getAll();
			$data['visit_purpose'] = Visit_Purpose::getAll();
			$data['opportunistic_infections'] = Opportunistic_Infection::getAll();
		}

		$this -> load -> view("template", $data);
	}

}

<?php
if (!defined('BASEPATH'))
	exit('No direct script access allowed');

class Home_Controller extends MY_Controller {
	function __construct() {
		parent::__construct();
	}

	public function index() {

		$this -> home();
	}

	public function home() {
		//
		$rights = User_Right::getRights($this -> session -> userdata('access_level'));
		$menu_data = array();
		$menus = array();
		$counter = 0;
		foreach ($rights as $right) {
			$menu_data['menus'][$right -> Menu] = $right -> Access_Type;
			$menus['menu_items'][$counter]['url'] = $right -> Menu_Item -> Menu_Url;
			$menus['menu_items'][$counter]['text'] = $right -> Menu_Item -> Menu_Text;
			$counter++;
		}
		$this -> session -> set_userdata($menu_data);
		$this -> session -> set_userdata($menus);

		//Check if the user is a pharmacist. If so, update his/her local envirinment with current values
		if ($this -> session -> userdata('user_indicator') == "pharmacist") {
			$facility_code = $this -> session -> userdata('facility');
			//Retrieve the Totals of the records in the master database that have clones in the clients!

			

			$today = date('m/d/Y');
			$timestamp = strtotime($today);
			$data['scheduled_patients'] = Patient_Appointment::getAllScheduled($timestamp);
		}
		$data['title'] = "System Home";
		$data['content_view'] = "home_v";
		$data['banner_text'] = "System Home";
		$data['link'] = "home";
		$this -> load -> view("template", $data);

	}

	public function synchronize_patients() {
		$data['regimens'] = Regimen::getAll();
		$data['supporters'] = Supporter::getAll();
		$data['service_types'] = Regimen_Service_Type::getAll();
		$data['sources'] = Patient_Source::getAll();
		$data['drugs'] = Drugcode::getAll();
		$data['regimen_change_purpose'] = Regimen_Change_Purpose::getAll();
		$data['visit_purpose'] = Visit_Purpose::getAll();
		$data['opportunistic_infections'] = Opportunistic_Infection::getAll();
		$data['regimen_drugs'] = Regimen_Drug::getAll();
	}

}

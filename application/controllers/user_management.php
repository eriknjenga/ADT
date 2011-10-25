<?php
if (!defined('BASEPATH'))
	exit('No direct script access allowed');

class User_Management extends MY_Controller {
	function __construct() {
		parent::__construct();
	}

	public function index() {
		$this -> login();
	}

	public function login() {
		$data = array();
		$data['title'] = "System Login";
		$this -> load -> view("login_v", $data);
	}

	public function authenticate() {
		$validated = $this -> _submit_validate();
		if ($validated) {
			$username = $this -> input -> post("username");
			$password = $this -> input -> post("password");
			$remember = $this -> input -> post("remember");
			$logged_in = Users::login($username, $password);
			//This code checks if the credentials are valid
			if ($logged_in == false) {
				$data['invalid'] = true;
				$data['title'] = "System Login";
				$this -> load -> view("login_v", $data);
			}
			//If the credentials are valid, continue
			else {
				//check to see whether the user is active
				if ($logged_in -> Active == "0") {
					$data['inactive'] = true;
					$data['title'] = "System Login";
					$this -> load -> view("login_v", $data);
				}
				//looks good. Continue!
				else {
					$session_data = array('user_id' => $logged_in -> id, 'access_level' => $logged_in -> Access_Level, 'username' => $logged_in -> Username, 'full_name' => $logged_in -> Name, 'facility' => $logged_in -> Facility_Code);
					$this -> session -> set_userdata($session_data);
					redirect("home_controller");
				}

			}

		} else {
			$data = array();
			$data['title'] = "System Login";
			$this -> load -> view("login_v", $data);
		}
	}

	private function _submit_validate() {
		// validation rules
		$this -> form_validation -> set_rules('username', 'Username', 'trim|required|min_length[6]|max_length[12]');
		$this -> form_validation -> set_rules('password', 'Password', 'trim|required|min_length[6]|max_length[12]');

		return $this -> form_validation -> run();
	}

	public function base_params($data) {
		$this -> load -> view("template", $data);
	}

}

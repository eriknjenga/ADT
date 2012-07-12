<?php
if (!defined('BASEPATH'))
	exit('No direct script access allowed');

class User_Management extends MY_Controller {
	function __construct() {
		parent::__construct();
	}

	public function index() {
		$this -> listing();
	}

	public function login() {
		$data = array();
		$data['title'] = "System Login";
		$this -> load -> view("login_v", $data);
	}

	public function listing() {
		$users = Users::getAll();
		$this -> table -> set_heading(array('id', 'Name', 'Username', 'Email Address', 'Phone Number', 'Access Level', 'Registered By'));
		$data['users'] = $users;
		$data['title'] = "System Users";
		$data['content_view'] = "users_v";
		$data['banner_text'] = "System Users";
		$data['link'] = "users";
		$actions = array(0 => array('Edit', 'edit'), 1 => array('Disable', 'disable'));
		$data['actions'] = $actions;
		$this -> load -> view("template", $data);
	}

	public function change_password() {
		$data = array();
		$data['title'] = "Change User Password";
		$data['content_view'] = "change_password_v";
		$data['link'] = "settings_management";
		$data['banner_text'] = "Change Pass";
		$this -> load -> view('template', $data);
	}

	public function save_new_password() {
		$valid = $this -> _submit_validate_password();
		if ($valid) {
			$user = Users::getUser($this -> session -> userdata('user_id'));
			$user -> Password = $this -> input -> post("new_password");
			$user -> save();
			redirect("user_management/logout");
		} else {
			$this -> change_password();
		}
	}

	private function _submit_validate_password() {
		// validation rules
		$this -> form_validation -> set_rules('old_password', 'Current Password', 'trim|required|min_length[6]|max_length[20]');
		$this -> form_validation -> set_rules('new_password', 'New Password', 'trim|required|min_length[6]|max_length[20]|matches[new_password_confirm]');
		$this -> form_validation -> set_rules('new_password_confirm', 'New Password Confirmation', 'trim|required|min_length[6]|max_length[20]');
		$temp_validation = $this -> form_validation -> run();
		if ($temp_validation) {
			$this -> form_validation -> set_rules('old_password', 'Current Password', 'trim|required|callback_correct_current_password');
			return $this -> form_validation -> run();
		} else {
			return $temp_validation;
		}

	}

	public function correct_current_password($pass) {
		$user = Users::getUser($this -> session -> userdata('user_id'));
		$dummy_user = new Users();
		$dummy_user -> Password = $pass;
		if ($user -> Password != $dummy_user -> Password) {
			$this -> form_validation -> set_message('correct_current_password', 'The current password you provided is not correct.');
			return FALSE;
		} else {
			return TRUE;
		}

	}

	public function authenticate() {
		$data = array();
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
					$session_data = array('user_id' => $logged_in -> id, 'user_indicator' => $logged_in -> Access -> Indicator, 'facility_name' => $logged_in -> Facility -> name, 'access_level' => $logged_in -> Access_Level, 'username' => $logged_in -> Username, 'full_name' => $logged_in -> Name, 'facility' => $logged_in -> Facility_Code);
					$this -> session -> set_userdata($session_data);
					//Execute queries that update the patient statuses
					$sql_pep = "update patient set current_status = '3' WHERE service='2' and current_status = '1' AND datediff(now(),date_enrolled)>=30;";
					$sql_pmtct = "update patient set current_status = '4' WHERE service='3' and current_status = '1' AND datediff(now(),date_enrolled)>=270;";
					$sql_inactive = "update patient,(SELECT patient from patient_appointment pa left join patient p on p.patient_number_ccc = pa.patient where  datediff(now(),appointment)>90 and p.current_status = '1' and p.service = '1' group by patient) patient_ids set current_status = '5' where patient_number_ccc  = patient_ids.patient ;
";
					$this -> load -> database();
					$this -> db -> query($sql_pep);
					$this -> db -> query($sql_pmtct);
					$this -> db -> query($sql_inactive);

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

	public function go_home($data) {
		$data['title'] = "System Home";
		$data['content_view'] = "home_v";
		$data['banner_text'] = "Dashboards";
		$data['link'] = "home";
		$this -> load -> view("template", $data);
	}

	public function base_params($data) {
		$this -> load -> view("template", $data);
	}

	public function logout() {
		$this -> session -> sess_destroy();
		redirect("user_management/login");
	}

}

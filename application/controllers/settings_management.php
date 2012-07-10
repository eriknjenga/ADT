<?php
if (!defined('BASEPATH'))
	exit('No direct script access allowed');

class Settings_Management extends MY_Controller {
	function __construct() {
		parent::__construct();
	}

	public function index() {
		redirect("regimen_management");
	}

	public function base_params($data) {
		$data['title'] = "System Settings";
		$data['content_view'] = "settings_v";
		$data['banner_text'] = "System Settings";
		$data['link'] = "settings_management";
		$this -> load -> view("template", $data);
	}

}

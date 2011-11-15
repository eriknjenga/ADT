<?php
class Menu_Management extends MY_Controller {
	function __construct() {
		parent::__construct();
	}

	public function index() {
		$this -> userlisting();
	}

	public function userlisting() {
		$data = array();
		$data['settings_view'] = "menu_listing_v";
		$data['menus'] = Menu::getAllHydrated();
		$this -> table -> set_heading(array('id', 'Menu Text', 'Target URL', 'Description'));
		$this -> base_params($data);
	}

	public function add() {
		$data['content_view'] = "newuser_add_v";
		$data['title'] = "Add New User";

		$this -> base_params($data);
	}

	public function save() {
		$valid = $this -> _validate_submission();
		if ($valid == FALSE) {
			$data['content_view'] = "newuser_add_v";
			$this -> base_params($data);
		} else {

		}
	}

	public function base_params($data) {
		$data['styles'] = array("jquery-ui.css");
		$data['scripts'] = array("jquery-ui.js");
		$data['quick_link'] = "menus";
		$data['title'] = "System Settings";
		$data['content_view'] = "settings_v";
		$data['banner_text'] = "System Settings";
		$data['link'] = "settings_management";

		$this -> load -> view('template', $data);
	}

}

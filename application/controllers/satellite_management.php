<?php
class Satellite_Management  extends MY_Controller {
	function __construct() {
		parent::__construct();
	}

	public function index() {
		$this -> listing();
	}

	public function listing() {
		$data = array();
		$data['content_view'] = "satellite_issues_v";
		$data['banner_text'] = "Satellite Distribution";
		$this -> base_params($data);
	}

	public function issue() {
		$data = array();
		$data['content_view'] = "new_satellite_issue_v";
		$data['banner_text'] = "Issue to Satellite";
		$data['styles'] = array(0=>"offline_css.css");
		$data['commodities'] = Drugcode::getAllObjects($this -> session -> userdata('facility'));
		$this -> base_params($data);
	}

	public function base_params($data) {
		$data['title'] = "Satellites";

		$data['link'] = "order_management";
		$this -> load -> view('template', $data);
	}

}
?>
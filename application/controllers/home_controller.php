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
		$this -> load -> view("template", $data);
	}

}

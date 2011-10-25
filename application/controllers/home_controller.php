<?php
if (!defined('BASEPATH'))
	exit('No direct script access allowed');

class Home_Controller extends MY_Controller {
<<<<<<< HEAD
    function __construct()
    {
        parent::__construct();
    }
 
public function index()
{
	$data = array();
$this->load->view("ADT_Offline_Template",$data);
=======
	function __construct() {
		parent::__construct();
	}

	public function index() {
		$data['title'] = "System Home";
		$data['content_view'] = "home_v";
		$data['banner_text'] = "Dashboards";
		$this -> load -> view("template", $data);
	}

>>>>>>> 9d73dc202a1bfeaa81e85474a0eeae4505eb6d1f
}

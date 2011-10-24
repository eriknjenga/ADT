<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Home_Controller extends MY_Controller {
    function __construct()
    {
        parent::__construct();
    }
 
public function index()
{
	$data = array();
$this->load->view("ADT_Offline_Template",$data);
}
}
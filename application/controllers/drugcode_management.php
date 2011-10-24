<?php
class Drugcode_management extends MY_Controller{
	function __construct(){
		parent::__construct();
	}
	public function index(){
		//$this->load->view('drugcode_form_v');
		$this->listing();
	}
	public function listing(){
		$this->load->view('drugcode_listing_v');
	}
	
}
?>
<?php
class genericname_management extends MY_Controller{
	 function __construct()
    {
        parent::__construct(); 
    }
	public function index(){
		$this->listing();
	}
	
	public function listing(){
		//Add code for listing here!
	}
	public function add(){
		$this->load->view('GenericName_View');
	}
}

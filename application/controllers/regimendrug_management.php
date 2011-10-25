<?php
	class Regimendrug_management extends MY_Controller{
		function __construct(){
			parent::__construct();
		}
		public function index(){
			$this->regimendrug_form();
		}
		public function regimendrug_form(){
			$this->load->view('regimendrug_listing_v');
		}
		public function save(){
			$regimen_drug=new Regimen_drug();
			$regimen_drug->regimen=$this->input->post('regimen');
			$regimen_drug->combination=$this->input->post('combination');
			
			$regimen_drug->save();
			redirect('regimendrug_management');
		}
	}
?>
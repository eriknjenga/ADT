<?php
	class Regimen_management extends MY_Controller{
		function __construct(){
			parent::__construct();
		}
		public function index(){
			$this->listing();
		}
		public function listing(){
			$this->load->view('regimen_listing_v');
		}
		public function save(){
			$regimen=new Regimen();
			$regimen->regimen_code=$this->input->post('regimen_code');
			$regimen->regimen_desc=$this->input->post('regimen_desc');
			$regimen->category=$this->input->post('category');
			$regimen->line=$this->input->post('line');
			$regimen->type_of_service=$this->input->post('type_of_service');
			$regimen->remarks=$this->input->post('remarks');
			$regimen->enabled=$this->input->post('show'); 
			
			$regimen->save();
			redirect('regimen_management');
		}
	}
?>
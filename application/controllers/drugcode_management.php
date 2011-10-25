<?php
class Drugcode_management extends MY_Controller{
	function __construct(){
		parent::__construct();
	}
	public function index(){		
		$this->listing();
	}
	public function listing(){
		$this->load->view('drugcode_listing_v');
	}
	public function save(){
		$drugcode=new Drugcode();
		$drugcode->drug=$this->input->post('drug');
		$drugcode->unit=$this->input->post('unit');
		$drugcode->pack_size=$this->input->post('pack_size');
		$drugcode->safety_quantity=$this->input->post('safety_quantity');
		$drugcode->generic_name=$this->input->post('generic_name');
		$drugcode->supported_by=$this->input->post('supported_by');
		$drugcode->none_arv=$this->input->post('none_arv');
		$drugcode->tb_drug=$this->input->post('tb_drug');
		$drugcode->drug_in_use=$this->input->post('drug_in_use');
		$drugcode->comment=$this->input->post('comment');
		$drugcode->dose=$this->input->post('dose');
		$drugcode->duration=$this->input->post('duration');
		$drugcode->quantity=$this->input->post('quantity');
		
		$drugcode->save();
		redirect('drugcode_management');
	}
	
}
?>
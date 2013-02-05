<?php
if (!defined('BASEPATH'))
	exit('No direct script access allowed');

class Pipeline_Management extends MY_Controller {
	function __construct() {
		parent::__construct();
		$data = array();
		$this -> load -> library('PHPExcel');
		ini_set("max_execution_time", "10000");
	}

	public function index() {
		$data['content_view'] = "pipeline_upload";
		$this -> base_params($data);
	}

	public function data_upload() {
		if ($_POST['btn_save']) {

            $objReader = new PHPExcel_Reader_Excel5();
			
			
			if ($_FILES['file']['tmp_name']) {
				$objPHPExcel = $objReader->load($_FILES['file']['tmp_name']);
				
			} else {
				 $this -> session -> set_userdata('upload_counter','1');
				 redirect("pipeline_management/index");

			}
			
			
            $arr = $objPHPExcel->getActiveSheet()->toArray(null,true,true,true);
			$highestColumm = $objPHPExcel->setActiveSheetIndex(0)->getHighestColumn(); 
            $highestRow = $objPHPExcel->setActiveSheetIndex(0)->getHighestRow();  
      
            
           

           for ($i = 2; $i <= $highestRow; $i++) {
				for ($j = 2; $j <=$highestColumm; $j++) {
					

				}
				
				
				$commodity_name=$arr[$i]['B'];
				$this -> load -> database();
		        $query = $this -> db -> query("SELECT id FROM drugcode WHERE drug LIKE '%$commodity_name%'");
		        $results = $query -> result_array();

                @$commodity_id=$results[0]['id'];	
				$total_issued = $arr[$i]['C'];
				$consumption = $arr[$i]['D'];
				$stock_on_hand = $arr[$i]['E'];
				$earliest_expiry_date =$arr[$i]['F'];
                $quantity_of_stock_expiring=$arr[$i]['G'];
				$central_site_stock_on_hand=$arr[$i]['H'];
				$total_stock_in_country=$arr[$i]['I'];
				$mos_on_hand_pipeline=$arr[$i]['J'];
				$mos_on_hand_central_sites=$arr[$i]['K'];
				$mos_on_hand_total=$arr[$i]['L'];
				$quantity_on_order_from_suppliers=$arr[$i]['M'];
				$source=$arr[$i]['N'];
				$expected_delivery_date=$arr[$i]['O'];
				$receipts_or_transfers=$arr[$i]['R'];
				$comments_or_actions=$arr[$i]['S'];
				$upload_date=$_POST['upload_date'];
				$pipeline_id=$_POST['pipeline_name'];
				
                //pipeline id: 1= KEMSA & 2=KENYA PHARMA
				
				Pipeline_Stock::add($commodity_id,$total_issued,$consumption,$stock_on_hand,$earliest_expiry_date,$quantity_of_stock_expiring,$central_site_stock_on_hand,$total_stock_in_country,$mos_on_hand_pipeline,$mos_on_hand_central_sites,$mos_on_hand_total,$quantity_on_order_from_suppliers,$source,$expected_delivery_date,$receipts_or_transfers,$comments_or_actions,$upload_date,$pipeline_id);
				 
				
		   }

			$this -> session -> set_userdata('upload_counter','2');
			redirect("pipeline_management/index");

		}
		
	}

	

	public function base_params($data) {
		$data['title'] = "Pipleline Stock Data";
		$data['banner_text'] = "Pipeline Monthly Stock Data Upload";
		$this -> load -> view('template', $data);
	}

}

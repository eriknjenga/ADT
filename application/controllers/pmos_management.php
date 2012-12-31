<?php
class PMOS_Management extends MY_Controller {
	function __construct() {
		parent::__construct();
	}

	public function view_interface() {
		$data = array();
		$data['content_view'] = "pmos_model_v";
		$this -> base_params($data);
	}

	public function base_params($data) {
		$this -> load -> database();
		$start_date = "2012-05-01";
		$end_date = "2012-05-30";
		$get_month_statistics_sql = "SELECT drug_id,sum(p.quantity) as quantity_dispensed, d.drug as drug FROM `patient_visit` p left join drugcode d on p.drug_id = d.id where dispensing_date between str_to_date('" . $start_date . "','%Y-%m-%d') and str_to_date('" . $end_date . "','%Y-%m-%d') group by drug_id order by drug";
		$month_statistics_query = $this -> db -> query($get_month_statistics_sql);
		
		$data['adult_options'] = Regimen_Option::getOptions("1");
		$data['paediatric_options'] = Regimen_Option::getOptions("0");
		$data['commodities'] = $month_statistics_query->result_array();
		$data['title'] = "PMoS Model";
		$data['banner_text'] = "PMoS Model";
		$data['current'] = "pmos_management";
		$this -> load -> view('platform_template', $data);
	}

}
?>
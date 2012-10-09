<?php
class Patient_Management extends MY_Controller {
	function __construct() {
		parent::__construct();
	}

	public function index() {
		$this -> listing();
	}

	public function listing() {
		$data = array();
		$data['content_view'] = "patient_listing_v";
		$this -> base_params($data);
	}
	public function save() {
		$this->load->database();
		$sql = $this->input->post("sql");
		$queries = explode(";", $sql);
		foreach($queries as $query){
			if(strlen($query)>0){
				$this->db->query($query);
			}
			
		}
	}

	public function base_params($data) {
		$data['title'] = "Patients";
		$data['banner_text'] = "Facility Patients";
		$data['link'] = "patients";
		$this -> load -> view('template', $data);
	}

	public function create_timestamps() {
		$visits = Patient_Visit::getAll();
		foreach ($visits as $visit) {
			$current_date = $visit -> Dispensing_Date;
			$changed_date = strtotime($current_date);
			$visit -> Dispensing_Date_Timestamp = $changed_date;
			$visit -> save();
		}
	}

	public function regimen_breakdown() {
		$selected_facility = $this -> input -> post('facility');
		if (isset($selected_facility)) {
			$facility = $this -> input -> post('facility');
		} 
		$this -> load -> database();
		$data = array();
		$data['current'] = "patient_management";
		$data['title'] = "Patient Regimen Breakdown";
		$data['content_view'] = "patient_regimen_breakdown_v";
		$data['banner_text'] = "Patient Regimen Breakdown";
		$data['facilities'] = Reporting_Facility::getAll();
		//Get the regimen data
		$data['optimal_regimens'] = Regimen::getOptimalityRegimens("1");
		$data['sub_optimal_regimens'] = Regimen::getOptimalityRegimens("2");
		$months = 12;
		$months_previous = 11;
		$regimen_data = array();
		for ($current_month = 1; $current_month <= $months; $current_month++) {
			$start_date = date("Y-m-01", strtotime("-$months_previous months"));
			$end_date = date("Y-m-t", strtotime("-$months_previous months"));
			//echo $start_date." to ".$end_date."</br>";
			if ($facility) {
				$get_month_statistics_sql = "SELECT regimen,count(patient_id) as patient_numbers,sum(months_of_stock) as months_of_stock FROM (select  distinct patient_id,months_of_stock,regimen,dispensing_date from `patient_visit` where facility = '" . $facility . "' and  dispensing_date between str_to_date('" . $start_date . "','%Y-%m-%d') and str_to_date('" . $end_date . "','%Y-%m-%d')) patient_visits group by regimen";
			} else {
				$get_month_statistics_sql = "SELECT regimen,count(patient_id) as patient_numbers,sum(months_of_stock) as months_of_stock FROM (select  distinct patient_id,months_of_stock,regimen,dispensing_date from `patient_visit` where dispensing_date between str_to_date('" . $start_date . "','%Y-%m-%d') and str_to_date('" . $end_date . "','%Y-%m-%d')) patient_visits group by regimen";
			}
			$month_statistics_query = $this -> db -> query($get_month_statistics_sql);
			foreach ($month_statistics_query->result_array() as $month_data) {
				$regimen_data[$month_data['regimen']][$start_date] = array("patient_numbers" => $month_data['patient_numbers'], "mos" => $month_data['months_of_stock']);
			}
			//echo $get_month_statistics_sql . "<br>";
			$months_previous--;
		}
		$data['regimen_data'] = $regimen_data;
		$this -> load -> view("platform_template", $data);
	}

	public function create_appointment_timestamps() {
		/*$appointments = Patient_Appointment::getAll();
		 foreach($appointments as $appointment){
		 $app_date = $appointment->Appointment;
		 $changed_date = strtotime($app_date);
		 //echo $app_date." currently becomes ".$changed_date." which was initially ".date("m/d/Y",$changed_date)."<br>";
		 $appointment->Appointment = $changed_date;
		 $appointment->save();
		 }*/
	}

}
?>
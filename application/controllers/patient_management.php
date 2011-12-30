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
		$this->db->query($sql);

	}

	public function base_params($data) { 
		$data['title'] = "Patients"; 
		$data['banner_text'] = "Facility Patients";
		$data['link'] = "patients";
		$this -> load -> view('template', $data);
	}
	public function check_patient_numbers($facility, $patient_number){
		$total_patients = Patient::getPatientNumbers($facility);
		echo $total_patients;
	}
	public function create_timestamps(){
		$visits = Patient_Visit::getAll();
		foreach($visits as $visit){
			$current_date = $visit->Dispensing_Date;
			$changed_date = strtotime($current_date);
			$visit->Dispensing_Date_Timestamp = $changed_date;
			$visit->save(); 
		}
	}
		public function create_appointment_timestamps(){
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
<?php
class Commodity_Management extends MY_Controller {
	function __construct() {
		parent::__construct();
	}

	public function commodity_breakdown() {
		$selected_facility = $this -> input -> post('facility');
		if (isset($selected_facility)) {
			$facility = $this -> input -> post('facility');
		}
		$this -> load -> database();
		$data = array();
		$data['current'] = "commodity_management";
		$data['title'] = "Stock Commodity Breakdown";
		$data['content_view'] = "stock_commodity_breakdown_v";
		$data['banner_text'] = "Stock Commodity Breakdown";
		$data['facilities'] = Reporting_Facility::getAll();
		//Get the regimen data
		$data['commodities'] = Drugcode::getARVs("0");
		$months = 12;
		$months_previous = 11;
		$commodity_data = array();
		for ($current_month = 1; $current_month <= $months; $current_month++) {
			$start_date = date("Y-m-01", strtotime("-$months_previous months"));
			$end_date = date("Y-m-t", strtotime("-$months_previous months"));
			//echo $start_date." to ".$end_date."</br>";
			if ($facility) {
				$get_month_statistics_sql = "SELECT drug_id,sum(quantity) as quantity_dispensed FROM `patient_visit` where facility = '" . $facility . "' and dispensing_date between str_to_date('" . $start_date . "','%Y-%m-%d') and str_to_date('" . $end_date . "','%Y-%m-%d') group by drug_id";
			} else {
				$get_month_statistics_sql = "SELECT drug_id,sum(quantity) as quantity_dispensed FROM `patient_visit` where dispensing_date between str_to_date('" . $start_date . "','%Y-%m-%d') and str_to_date('" . $end_date . "','%Y-%m-%d') group by drug_id";
			}

			$month_statistics_query = $this -> db -> query($get_month_statistics_sql);
			foreach ($month_statistics_query->result_array() as $month_data) {
				$commodity_data[$month_data['drug_id']][$start_date] = array("quantity_dispensed" => $month_data['quantity_dispensed']);
			}
			//echo $get_month_statistics_sql . "<br>";
			$months_previous--;
		}
		$data['commodity_data'] = $commodity_data;
		$this -> load -> view("platform_template", $data);
	}

	//function to get how a commodity was consumed in the various regimens
	public function regimen_breakdown($commodity, $pack_size, $start_date, $end_date) {
		$this -> load -> database();
		$breakdown_sql = "select r.regimen_desc,count(patient_id) as patients,sum(months_of_stock) as months,sum(quantity) as total_quantity from patient_visit pv left join regimen r on pv.regimen = r.id where drug_id = '" . $commodity . "' and dispensing_date between str_to_date('" . $start_date . "','%Y-%m-%d') and str_to_date('" . $end_date . "','%Y-%m-%d') group by regimen ";
		$breakdown_query = $this -> db -> query($breakdown_sql);
		$total_packs = 0;
		$total_patients = 0;
		$total_mos = 0;
		$data_table = "<table class='data-table'><thead><tr><th>Regimen</th><th>Packs Dispensed</th><th>No. of Patients</th><th>Patients MOS</th></tr></thead><tbody>";
		foreach ($breakdown_query->result_array() as $breakdown_data) {
			$packs = "N/A";
			if ($pack_size > 0 and $breakdown_data['total_quantity'] > 0) {
				$packs = $breakdown_data['total_quantity'] / $pack_size;
			}
			$total_packs += $packs;
			$total_patients += $breakdown_data['patients'];
			$total_mos += $breakdown_data['months'];
			//Display a table with the breakdown data.
			$data_table .= "<tr><td>" . $breakdown_data['regimen_desc'] . "</td><td>" . number_format($packs, 2) . "</td><td>" . number_format($breakdown_data['patients']) . "</td><td>" . number_format($breakdown_data['months'], 2) . "</td></tr>";
		}
		$data_table .= "<tr style='font-weight: bold'><td>Totals</td><td>" . number_format($total_packs, 2) . "</td><td>" . number_format($total_patients) . "</td><td>" . number_format($total_mos,2) . "</td></tr>";
		$data_table .= "</tbody></table>";
		echo $data_table;
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
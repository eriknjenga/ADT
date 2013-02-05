<?php
if (!defined('BASEPATH'))
	exit('No direct script access allowed');

class Fcdrr_Management extends MY_Controller {
	function __construct() {
		parent::__construct();
		$data = array();
		$this -> load -> library('PHPExcel');
		ini_set("max_execution_time", "10000");
	}

	public function index() {
		$data['content_view'] = "fcdrr_upload";
		$this -> base_params($data);
	}

	public function data_upload() {
		if ($_POST['btn_save']) {

			$objReader = new PHPExcel_Reader_Excel2007();

			if ($_FILES['file']['tmp_name']) {
				$objPHPExcel = $objReader -> load($_FILES['file']['tmp_name']);

			} else {
				$this -> session -> set_userdata('upload_counter', '1');
				redirect("fcdrr_management/index");

			}

			$arr = $objPHPExcel -> getActiveSheet() -> toArray(null, true, true, true);
			$highestColumm = $objPHPExcel -> setActiveSheetIndex(0) -> getHighestColumn();
			$highestRow = $objPHPExcel -> setActiveSheetIndex(0) -> getHighestRow();

			//Top Details

			$facility_name = $arr[5]['B'] . $arr[5]['C'] . $arr[5]['D'] . $arr[5]['E'];
			$province = $arr[6]['B'] . $arr[6]['C'] . $arr[6]['D'] . $arr[6]['E'];
			$facility_code = $arr[5]['R'] . $arr[5]['S'] . $arr[5]['T'];
			$district = $arr[6]['R'] . $arr[6]['S'] . $arr[6]['T'];

			$type_of_service_art = $arr[8]['C'];
			$type_of_service_pmtct = $arr[8]['E'];
			$type_of_service_pep = $arr[8]['H'];

			if ($type_of_service_art && $type_of_service_pmtct && $type_of_service_pep) {
				$services_offered = "art,pmtct,pep";
			} else if ($type_of_service_pmtct && $type_of_service_art) {
				$services_offered = "art,pmtct";
			} else if ($type_of_service_pep && $type_of_service_art) {
				$services_offered = "art,pep";
			} else if ($type_of_service_pmtct && $type_of_service_pep) {
				$services_offered = "pmtct,pep";
			} else {
				if ($type_of_service_art) {
					$services_offered = "art";
				}
				if ($type_of_service_pmtct) {
					$services_offered = "pmtct";
				}
				if ($type_of_service_pep) {
					$services_offered = "pep";
				}
			}
			@$services_offered;

			$programme_sponsor_gok = $arr[4]['D'];
			$programme_sponsor_pepfar = $arr[4]['G'];
			$programme_sponsor_msf = $arr[4]['L'];

			if ($programme_sponsor_gok) {
				$programme_sponsor = "gok";
			}
			if ($programme_sponsor_pepfar) {
				$programme_sponsor = "pepfar";
			}
			if ($programme_sponsor_msf) {
				$programme_sponsor = "msf";
			}

			$programme_sponsor;

			//Reporting Period

			@$beginning = $arr[10]['D'] . $arr[10]['E'];
			@$ending = $arr[10]['R'] . $arr[10]['S'] . $arr[10]['T'];

			//Comments

			for ($i = 105; $i <= 109; $i++) {
				for ($j = 1; $j <= $highestColumm; $j++) {
				}
				@$comments .= $arr[$i]['A'] . $arr[$i]['B'] . $arr[$i]['C'] . $arr[$i]['D'] . $arr[$i]['E'] . $arr[$i]['G'] . $arr[$i]['H'] . $arr[$i]['L'];

			}

			$this -> load -> database();
			$query = $this -> db -> query("INSERT INTO facility_order (`id`, `status`, `created`, `updated`, `code`, `period_begin`, `period_end`, `comments`, `reports_expected`, `reports_actual`, `services`, `sponsors`, `delivery_note`, `order_id`, `facility_id`) VALUES (NULL, '0', CURDATE(), '', '0', '$beginning', '$ending', '$comments', NULL, NULL, '$services_offered', '$programme_sponsor', NULL, NULL, '$facility_code');");

			$facility_order_query = $this -> db -> query("SELECT MAX(id) AS id FROM facility_order");
			$facility_order_results = $facility_order_query -> result_array();
			$facility_id = $facility_order_results[0]['id'];

			//Adult ARV Preparations
			for ($i = 18; $i <= 42; $i++) {
				for ($j = 1; $j <= $highestColumm; $j++) {
				}

				$quantity_required_for_supply = $arr[$i]['L'];
				$drug_name = $arr[$i]['A'];
				if ($quantity_required_for_supply!=0) {
					$this -> load -> database();
					$query = $this -> db -> query("SELECT id FROM drugcode WHERE drug LIKE '%$drug_name%'");
					$results = $query -> result_array();
					@$drug_id = $results[0]['id'];
					$basic_unit = $arr[$i]['B'];
					$beginning_balance = $arr[$i]['C'];
					$quantity_received_in_period = $arr[$i]['D'];
					$quantity_dispensed_in_period = $arr[$i]['E'];
					$adjustments_to_other_facilities = $arr[$i]['G'];
					$end_of_month_physical_count = $arr[$i]['H'];
					$quantity_required_for_supply = $arr[$i]['L'];
					$cdrr_query = $this -> db -> query("INSERT INTO cdrr_item (`id`, `balance`, `received`, `dispensed_units`, `dispensed_packs`, `losses`, `adjustments`, `count`, `resupply`, `aggr_consumed`, `aggr_on_hand`, `publish`, `cdrr_id`, `drug_id`) VALUES (NULL, '$beginning_balance', '$quantity_received_in_period', '$quantity_dispensed_in_period', NULL, NULL, '$adjustments_to_other_facilities', '$end_of_month_physical_count', '$quantity_required_for_supply', NULL, NULL, '0', '$facility_id', '$drug_id');");
				}
			}

			//Paediatric Preparations

			for ($i = 44; $i <= 76; $i++) {
				for ($j = 1; $j <= $highestColumm; $j++) {
				}

				$quantity_required_for_supply = $arr[$i]['L'];
				$drug_name = $arr[$i]['A'];
				if ($quantity_required_for_supply!=0) {
					$this -> load -> database();
					$query = $this -> db -> query("SELECT id FROM drugcode WHERE drug LIKE '%$drug_name%'");
					$results = $query -> result_array();
					@$drug_id = $results[0]['id'];
					$basic_unit = $arr[$i]['B'];
					$beginning_balance = $arr[$i]['C'];
					$quantity_received_in_period = $arr[$i]['D'];
					$quantity_dispensed_in_period = $arr[$i]['E'];
					$adjustments_to_other_facilities = $arr[$i]['G'];
					$end_of_month_physical_count = $arr[$i]['H'];
					$quantity_required_for_supply = $arr[$i]['L'];
					$cdrr_query = $this -> db -> query("INSERT INTO cdrr_item (`id`, `balance`, `received`, `dispensed_units`, `dispensed_packs`, `losses`, `adjustments`, `count`, `resupply`, `aggr_consumed`, `aggr_on_hand`, `publish`, `cdrr_id`, `drug_id`) VALUES (NULL, '$beginning_balance', '$quantity_received_in_period', '$quantity_dispensed_in_period', NULL, NULL, '$adjustments_to_other_facilities', '$end_of_month_physical_count', '$quantity_required_for_supply', NULL, NULL, '0', '$facility_id', '$drug_id');");

				}

			}

			//Drugs for IOs

			for ($i = 78; $i <= 99; $i++) {
				for ($j = 1; $j <= $highestColumm; $j++) {
				}

				$quantity_required_for_supply = $arr[$i]['L'];
				$drug_name = $arr[$i]['A'];
				if ($quantity_required_for_supply!=0) {
					$this -> load -> database();
					$query = $this -> db -> query("SELECT id FROM drugcode WHERE drug LIKE '%$drug_name%'");
					$results = $query -> result_array();
					@$drug_id = $results[0]['id'];
					$basic_unit = $arr[$i]['B'];
					$beginning_balance = $arr[$i]['C'];
					$quantity_received_in_period = $arr[$i]['D'];
					$quantity_dispensed_in_period = $arr[$i]['E'];
					$adjustments_to_other_facilities = $arr[$i]['G'];
					$end_of_month_physical_count = $arr[$i]['H'];
					$quantity_required_for_supply = $arr[$i]['L'];
					$cdrr_query = $this -> db -> query("INSERT INTO cdrr_item (`id`, `balance`, `received`, `dispensed_units`, `dispensed_packs`, `losses`, `adjustments`, `count`, `resupply`, `aggr_consumed`, `aggr_on_hand`, `publish`, `cdrr_id`, `drug_id`) VALUES (NULL, '$beginning_balance', '$quantity_received_in_period', '$quantity_dispensed_in_period', NULL, NULL, '$adjustments_to_other_facilities', '$end_of_month_physical_count', '$quantity_required_for_supply', NULL, NULL, '0', '$facility_id', '$drug_id');");

				}
			}

			//PMTCT Regimen 1.Pregnant Women
			for ($i = 19; $i <= 21; $i++) {
				for ($j = 19; $j <= $highestColumm; $j++) {
				}

				$regimen_code = $arr[$i]['S'];
				$regimen_desc = $arr[$i]['T'];
				$no_of_clients_dispensed_in_period = $arr[$i]['V'] . $arr[$i]['W'];
				if ($no_of_clients_dispensed_in_period) {
					$this -> load -> database();
					$query = $this -> db -> query("SELECT id FROM regimen WHERE regimen_code='$regimen_code'");
					$results = $query -> result_array();
					@$regimen_id = $results[0]['id'];
					$next_query = $this -> db -> query("INSERT INTO maps_item (`id`, `total`, `regimen_id`, `maps_id`) VALUES (NULL, '$no_of_clients_dispensed_in_period', '$regimen_id', '$facility_id');");

				}

			}

			//PMTCT Regimen 2.Infants

			for ($i = 23; $i <= 27; $i++) {
				for ($j = 19; $j <= $highestColumm; $j++) {
				}

				$regimen_code = $arr[$i]['S'];
				$regimen_desc = $arr[$i]['T'];
				$no_of_clients_dispensed_in_period = $arr[$i]['V'] . $arr[$i]['W'];
				if ($no_of_clients_dispensed_in_period) {
					$this -> load -> database();
					$query = $this -> db -> query("SELECT id FROM regimen WHERE regimen_code='$regimen_code'");
					$results = $query -> result_array();
					@$regimen_id = $results[0]['id'];
					$next_query = $this -> db -> query("INSERT INTO maps_item (`id`, `total`, `regimen_id`, `maps_id`) VALUES (NULL, '$no_of_clients_dispensed_in_period', '$regimen_id', '$facility_id');");
				}

			}

			//Adult ART First Line Regimens

			for ($i = 33; $i <= 43; $i++) {
				for ($j = 19; $j <= $highestColumm; $j++) {
				}

				$regimen_code = $arr[$i]['S'];
				$regimen_desc = $arr[$i]['T'];
				$no_of_clients_dispensed_in_period = $arr[$i]['V'] . $arr[$i]['W'];
				if ($no_of_clients_dispensed_in_period) {
					$this -> load -> database();
					$query = $this -> db -> query("SELECT id FROM regimen WHERE regimen_code='$regimen_code'");
					$results = $query -> result_array();
					@$regimen_id = $results[0]['id'];
					$next_query = $this -> db -> query("INSERT INTO maps_item (`id`, `total`, `regimen_id`, `maps_id`) VALUES (NULL, '$no_of_clients_dispensed_in_period', '$regimen_id', '$facility_id');");
				}

			}

			//Adult ART Second Line Regimens

			for ($i = 45; $i <= 58; $i++) {
				for ($j = 19; $j <= $highestColumm; $j++) {
				}

				$regimen_code = $arr[$i]['S'];
				$regimen_desc = $arr[$i]['T'];
				$no_of_clients_dispensed_in_period = $arr[$i]['V'] . $arr[$i]['W'];
				if ($no_of_clients_dispensed_in_period) {
					$this -> load -> database();
					$query = $this -> db -> query("SELECT id FROM regimen WHERE regimen_code='$regimen_code'");
					$results = $query -> result_array();
					@$regimen_id = $results[0]['id'];
					$next_query = $this -> db -> query("INSERT INTO maps_item (`id`, `total`, `regimen_id`, `maps_id`) VALUES (NULL, '$no_of_clients_dispensed_in_period', '$regimen_id', '$facility_id');");
				}

			}

			//Other Adult ART regimens

			for ($i = 60; $i <= 62; $i++) {
				for ($j = 19; $j <= $highestColumm; $j++) {
				}

				$regimen_code = $arr[$i]['S'];
				$regimen_desc = $arr[$i]['T'];
				$no_of_clients_dispensed_in_period = $arr[$i]['V'] . $arr[$i]['W'];
				if ($no_of_clients_dispensed_in_period) {
					$this -> load -> database();
					$query = $this -> db -> query("SELECT id FROM regimen WHERE regimen_code='$regimen_code'");
					$results = $query -> result_array();
					@$regimen_id = $results[0]['id'];
					$next_query = $this -> db -> query("INSERT INTO maps_item (`id`, `total`, `regimen_id`, `maps_id`) VALUES (NULL, '$no_of_clients_dispensed_in_period', '$regimen_id', '$facility_id');");
				}

			}

			//Paediatric ART First Line Regimens

			for ($i = 64; $i <= 74; $i++) {
				for ($j = 19; $j <= $highestColumm; $j++) {
				}

				$regimen_code = $arr[$i]['S'];
				$regimen_desc = $arr[$i]['T'];
				$no_of_clients_dispensed_in_period = $arr[$i]['V'] . $arr[$i]['W'];
				if ($no_of_clients_dispensed_in_period) {
					$this -> load -> database();
					$query = $this -> db -> query("SELECT id FROM regimen WHERE regimen_code='$regimen_code'");
					$results = $query -> result_array();
					@$regimen_id = $results[0]['id'];
					$next_query = $this -> db -> query("INSERT INTO maps_item (`id`, `total`, `regimen_id`, `maps_id`) VALUES (NULL, '$no_of_clients_dispensed_in_period', '$regimen_id', '$facility_id');");
				}

			}

			//Paediatric ART Second Line Regimens

			for ($i = 76; $i <= 84; $i++) {
				for ($j = 19; $j <= $highestColumm; $j++) {
				}

				$regimen_code = $arr[$i]['S'];
				$regimen_desc = $arr[$i]['T'];
				$no_of_clients_dispensed_in_period = $arr[$i]['V'] . $arr[$i]['W'];
				if ($no_of_clients_dispensed_in_period) {
					$this -> load -> database();
					$query = $this -> db -> query("SELECT id FROM regimen WHERE regimen_code='$regimen_code'");
					$results = $query -> result_array();
					@$regimen_id = $results[0]['id'];
					$next_query = $this -> db -> query("INSERT INTO maps_item (`id`, `total`, `regimen_id`, `maps_id`) VALUES (NULL, '$no_of_clients_dispensed_in_period', '$regimen_id', '$facility_id');");
				}

			}

			//Other Paediatric ART regimens

			for ($i = 86; $i <= 87; $i++) {
				for ($j = 19; $j <= $highestColumm; $j++) {
				}

				$regimen_code = $arr[$i]['S'];
				$regimen_desc = $arr[$i]['T'];
				$no_of_clients_dispensed_in_period = $arr[$i]['V'] . $arr[$i]['W'];
				if ($no_of_clients_dispensed_in_period) {
					$this -> load -> database();
					$query = $this -> db -> query("SELECT id FROM regimen WHERE regimen_code='$regimen_code'");
					$results = $query -> result_array();
					@$regimen_id = $results[0]['id'];
					$next_query = $this -> db -> query("INSERT INTO maps_item (`id`, `total`, `regimen_id`, `maps_id`) VALUES (NULL, '$no_of_clients_dispensed_in_period', '$regimen_id', '$facility_id');");
				}

			}

			//POST Exposure Prophylaxis(PEP)

			for ($i = 91; $i <= 99; $i++) {
				for ($j = 19; $j <= $highestColumm; $j++) {
				}

				$regimen_code = $arr[$i]['S'];
				$regimen_desc = $arr[$i]['T'];
				$no_of_clients_dispensed_in_period = $arr[$i]['V'] . $arr[$i]['W'];
				if ($no_of_clients_dispensed_in_period) {
					$this -> load -> database();
					$query = $this -> db -> query("SELECT id FROM regimen WHERE regimen_code='$regimen_code'");
					$results = $query -> result_array();
					@$regimen_id = $results[0]['id'];
					$next_query = $this -> db -> query("INSERT INTO maps_item (`id`, `total`, `regimen_id`, `maps_id`) VALUES (NULL, '$no_of_clients_dispensed_in_period', '$regimen_id', '$facility_id');");
				}
			}

			//ARV Data collection and Reporting Tools

			//1.Name of Data-DAR

			//a.ARVS Collection Tool

			$fifty_arv_page_requested = $arr[116]['D'];
			$three_hundred_arv_page_requested = $arr[116]['E'];
			if ($fifty_arv_page_requested) {
				$dar_arv_quantity_requested = $fifty_arv_page_requested;
			}
			if ($three_hundred_arv_page_requested) {
				$dar_arv_quantity_requested = $three_hundred_arv_page_requested;
			}

			//a.OIs Collection Tool

			$fifty_oi_page_requested = $arr[116]['G'];
			$three_hundred_oi_page_requested = $arr[116]['H'];
			if ($fifty_oi_page_requested) {
				$dar_oi_quantity_requested = $fifty_oi_page_requested;
			}
			if ($three_hundred_oi_page_requested) {
				$dar_oi_quantity_requested = $three_hundred_oi_page_requested;
			}

			//2.Name of Data-FCDRR

			$fcdrr_quantity_requested = $arr[116]['L'];

			//Prepared By details

			$report_prepared_by = $arr[119]['B'] . $arr[119]['C'] . $arr[119]['D'];
			$prepared_by_contact_telephone = $arr[121]['B'] . $arr[121]['C'] . $arr[121]['D'];
			$signature_prepared_by = $arr[119]['G'] . $arr[119]['H'] . $arr[119]['L'];
			$date_prepared_by_signature = $arr[121]['G'] . $arr[121]['H'];

			//Approved By details
			$report_approved_by = $arr[123]['B'] . $arr[123]['C'] . $arr[123]['D'];
			$approved_by_contact_telephone = $arr[126]['B'] . $arr[126]['C'] . $arr[126]['D'];
			$signature_approved_by = $arr[123]['G'] . $arr[123]['H'] . $arr[123]['L'];
			$date_approved_by_signature = $arr[126]['G'] . $arr[126]['H'];

			$this -> session -> set_userdata('upload_counter','2');
			redirect("fcdrr_management/index");

		}

	}

	public function base_params($data) {
		$data['title'] = "FCDRR Data";
		$data['banner_text'] = "(F-CDRR)DATA UPLOAD";
		$this -> load -> view('template', $data);
	}

}

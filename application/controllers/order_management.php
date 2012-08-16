<?php
class Order_Management extends MY_Controller {
	function __construct() {
		parent::__construct();
	}

	public function index() {
		$this -> listing();
	}

	public function listing() {
		$data = array();
		$data['content_view'] = "order_listing_v";
		$data['banner_text'] = "Commodity Orders";
		$this -> base_params($data);
	}

	public function new_order() {
		$data = array();
		$data['content_view'] = "new_order_v";
		$data['banner_text'] = "New Order";
		$data['commodities'] = Drugcode::getAllObjects($this -> session -> userdata('facility'));
		$data['regimens'] = Regimen::getAllObjects($this -> session -> userdata('facility'));
		$this -> base_params($data);
	}

	public function new_satellite_order() {
		$data = array();
		$data['content_view'] = "new_order_v";
		$data['banner_text'] = "New Order";
		$data['commodities'] = Drugcode::getAllObjects($this -> session -> userdata('facility'));
		$data['regimens'] = Regimen::getAllObjects($this -> session -> userdata('facility'));
		$this -> base_params($data);
	}

	public function base_params($data) {
		$data['title'] = "Commodity Orders";

		$data['link'] = "order_management";
		$this -> load -> view('template', $data);
	}

	public function save() {
		//var_dump($this -> input -> post());
		$created_on = date("Y-m-d H:i:s");
		$updated_on = date("Y-m-d H:i:s");
		$period_start = $this -> input -> post('start_date');
		$period_end = $this -> input -> post('end_date');
		$services = $this -> input -> post('services');
		$sponsors = $this -> input -> post('sponsors');
		$opening_balances = $this -> input -> post('opening_balance');
		$quantities_received = $this -> input -> post('quantity_received');
		$quantities_dispensed = $this -> input -> post('quantity_dispensed');
		$losses = $this -> input -> post('losses');
		$adjustments = $this -> input -> post('adjustments');
		$physical_count = $this -> input -> post('physical_count');
		$expiry_quantity = $this -> input -> post('expiry_quantity');
		$expiry_date = $this -> input -> post('expiry_date');
		$out_of_stock = $this -> input -> post('out_of_stock');
		$resupply = $this -> input -> post('resupply');
		$commodities = $this -> input -> post('commodity');
		$regimens = $this -> input -> post('regimen');
		$patient_numbers = $this -> input -> post('patient_numbers');
		$mos = $this -> input -> post('mos');
		$commodity_counter = 0;
		$regimen_counter = 0;
		//Save the cdrr
		$cdrr_sql = "INSERT INTO cdrr (status,created,updated,code,period_begin,period_end,comments,services,sponsors,delivery_note,facility_id)VALUES('prepared','$created_on','$updated_on','F-CDRR_units','$period_start','$period_end','','$services','$sponsors','','108'); select last_insert_id() as cdrr_id;";
		//Make database connection
		/*$connection = ssh2_connect('demo.kenyapharma.org', 22);
		 ssh2_auth_password($connection, 'ubuntu', 'Nb!23Q2([58L61D');
		 $tunnel = ssh2_tunnel($connection, 'demo.kenyapharma.org', 3306);
		 $db = mysqli_connect('demo.kenyapharma.org', 'demo', 'Ms#=T9F1@56446N', 'kenyapharma_demo', 3306) or die('Fail: ' . mysql_error());
		 */
		//Connection2
		$connection = ssh2_connect('demo.kenyapharma.org', '22');
		if (ssh2_auth_password($connection, 'ubuntu', 'Nb!23Q2([58L61D')) { echo "Authentication Successful!\n";
		} else { die('Authentication Failed...');
		}
		$command = 'echo "' . $cdrr_sql . '" | mysql -udemo -pMs#=T9F1@56446N kenyapharma_demo2';
		//echo $command;
		$stream = ssh2_exec($connection, $command);
		stream_set_blocking($stream, true);
		$cdrr_id = '';
		while ($line = fgets($stream)) { flush();
			if ($line + 0) {
				$cdrr_id = $line;
			}
		}
		echo "CDRR id ".$cdrr_id." sent to Kenya Pharma";

		//get the inserted cdrr id
		$cdrr_item_sql = "";
		//save the cdrr items
		foreach ($commodities as $commodity) {
			if ($resupply[$commodity_counter] > 0) {
				//create the sql
				$cdrr_item_sql .= "INSERT INTO cdrr_item (balance,received,dispensed_units,dispensed_packs,losses,adjustments,count,expiry_quant,expiry_date,out_of_stock,resupply,aggr_consumed,aggr_on_hand,publish,cdrr_id,drug_id)VALUES('$opening_balances[$commodity_counter]','$quantities_received[$commodity_counter]','$quantities_dispensed[$commodity_counter]','','$losses[$commodity_counter]','$adjustments[$commodity_counter]','$physical_count[$commodity_counter]','$expiry_quantity[$commodity_counter]','$expiry_date[$commodity_counter]','$out_of_stock[$commodity_counter]','$resupply[$commodity_counter]','','','0','$cdrr_id','$commodities[$commodity_counter]');";
			}
			$commodity_counter++;
		}
		$command = 'echo "' . $cdrr_item_sql . '" | mysql -udemo -pMs#=T9F1@56446N kenyapharma_demo2';
		ssh2_exec($connection, $command);

		//save the maps
		$maps_sql = "insert into maps (status,created,updated,code,period_begin,period_end,services,sponsors,facility_id) values ('prepared','$created_on','$updated_on','F-MAPS','$period_start','$period_end','$services','$sponsors','108'); select last_insert_id() as maps_id;";
		//get the maps id  
		$command = 'echo "' . $maps_sql . '" | mysql -udemo -pMs#=T9F1@56446N kenyapharma_demo2';
		//echo $command;
		$stream = ssh2_exec($connection, $command);
		stream_set_blocking($stream, true);
		$maps_id = '';
		while ($line = fgets($stream)) { flush();
			if ($line + 0) {
				$maps_id = $line;
			}
		}
		echo "MAPS id ".$maps_id." sent to Kenya Pharma";
		$maps_item_sql = "";
		//save the maps items
		foreach ($regimens as $regimen) {
			if ($patient_numbers[$regimen_counter] > 0) {
				$maps_item_sql .= "INSERT INTO maps_item(total,regimen_id,maps_id)VALUES('$patient_numbers[$regimen_counter]','$regimens[$regimen_counter]','$maps_id');";
			}
			$regimen_counter++;
		}
		$command = 'echo "' . $maps_item_sql . '" | mysql -udemo -pMs#=T9F1@56446N kenyapharma_demo2';
		ssh2_exec($connection, $command);

	}

}
?>
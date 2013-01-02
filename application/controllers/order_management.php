<?php
class Order_Management extends MY_Controller {
	function __construct() {
		parent::__construct();
	}

	public function index() {
		$this -> submitted_orders();
	}

	public function listing() {
		$data = array();
		$data['content_view'] = "order_listing_v";
		$data['banner_text'] = "Commodity Orders";
		$this -> base_params($data);
	}

	public function view_order($order) {
		//First retrieve the order and its particulars from the database
		$data = array();
		$data['order_details'] = Facility_Order::getOrder($order);
		$data['commodities'] = Cdrr_Item::getOrderItems($order);
		$data['regimens'] = Maps_Item::getOrderItems($order);
		$data['comments'] = Order_Comment::getOrderComments($order);
		$data['content_view'] = "view_order_v";
		$data['banner_text'] = "Order Particulars";
		//get all submitted orders that have not been rationalized (fresh orders)
		$this -> base_params($data);
	}

	public function edit_order($order) {
		//First retrieve the order and its particulars from the database
		$data = array();
		$data['order_details'] = Facility_Order::getOrder($order);
		$this -> load -> database();
		//Get all drugs, ordered or not
		$sql = "select d.drug,d.id as did,d.pack_size,c.* from drugcode d left join cdrr_item c on d.id = c.drug_id and c.cdrr_id = '$order' where d.supplied = '1' order by d.id";
		$query = $this -> db -> query($sql);
		$data['commodities'] = $query -> result_array();
		//Get all regimens; ordered or not
		$regimen_sql = "select r.regimen_desc,r.id as rid,m.* from regimen r left join maps_item m on r.id = m.regimen_id and m.maps_id = '$order' order by r.id";
		$regimen_query = $this -> db -> query($regimen_sql);
		$data['commodities'] = $query -> result_array();
		//var_dump($data['commodities']);
		$data['regimens'] = $regimen_query -> result_array();
		$data['comments'] = Order_Comment::getOrderComments($order);
		$data['content_view'] = "edit_order_v";
		$data['banner_text'] = "Order Particulars";
		//get all submitted orders that have not been rationalized (fresh orders)
		$this -> base_params($data);
	}

	public function submitted_orders($status = 0, $offset = 0) {
		$facility = $this -> session -> userdata('facility_id');
		$items_per_page = 20;
		$number_of_orders = Facility_Order::getTotalFacilityNumber($status, $facility);
		$orders = Facility_Order::getPagedFacilityOrders($offset, $items_per_page, $status, $facility);
		if ($number_of_orders > $items_per_page) {
			$config['base_url'] = base_url() . "order_management/submitted_orders/".$status."/";
			$config['total_rows'] = $number_of_orders;
			$config['per_page'] = $items_per_page;
			$config['uri_segment'] = 4;
			$config['num_links'] = 5;
			$this -> pagination -> initialize($config);
			$data['pagination'] = $this -> pagination -> create_links();
		}

		$data['orders'] = $orders;
		$data['quick_link'] = $status;
		$data['content_view'] = "view_facility_orders_v";
		$data['banner_text'] = "Submitted Orders";
		$data['styles'] = array("pagination.css");
		//get all submitted orders that have not been rationalized (fresh orders)
		$this -> base_params($data);
	}

	public function delete_order($order) {
		$order = Facility_Order::getOrder($order);
		$order -> delete();
		redirect("order_management/submitted_orders");
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
		$data['scripts'] = array("offline_database.js");
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
		$facility = $this -> session -> userdata('facility_id');
		$user_id = $this -> session -> userdata('user_id');
		$updated_on = date("U");
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
		$regimens = $this -> input -> post('patient_regimens');
		$patient_numbers = $this -> input -> post('patient_numbers');
		$mos = $this -> input -> post('mos');
		$comments = $this -> input -> post('comments');
		$order_number = $this -> input -> post('order_number');
		//boolean to tell if we are editing the order
		$is_editing = false;
		if ($order_number != null) {
			$is_editing = true;
		}
		$commodity_counter = 0;
		$regimen_counter = 0;

		//Save the cdrr
		if ($is_editing) {
			//Retrieve the order being edited
			$order_object = Facility_Order::getOrder($order_number);
			//Delete all items for that order
			$old_commodities = Cdrr_Item::getOrderItems($order_number);
			$old_regimens = Maps_Item::getOrderItems($order_number);
			foreach ($old_commodities as $old_commodity) {
				$old_commodity -> delete();
			}
			foreach ($old_regimens as $old_regimen) {
				$old_regimen -> delete();
			}
		} else {$order_object = new Facility_Order();
		}

		//status = 0 i.e. prepared
		$order_object -> Status = 0;
		$order_object -> Updated = $updated_on;
		//code = 0 i.e. fcdrr
		$order_object -> Code = 0;
		$order_object -> Period_Begin = $period_start;
		$order_object -> Period_End = $period_end;
		//Only for dcdrrs
		/*$order_object->Reports_Expected = 0;
		 $order_object->Reports_Actual = 0;*/
		$order_object -> Services = $services;
		$order_object -> Sponsors = $sponsors;
		$order_object -> Facility_Id = $facility;
		$order_object -> save();
		$order_id = $order_object -> id;
		//Now save the comment that has been made
		if (strlen($comments) > 0) {
			$order_comment = new Order_Comment();
			$order_comment -> Order_Number = $order_id;
			$order_comment -> Timestamp = date('U');
			$order_comment -> User = $user_id;
			$order_comment -> Comment = $comments;
			$order_comment -> save();
		}

		//Now save the cdrr items
		$commodity_counter = 0;
		if ($commodities != null) {
			foreach ($commodities as $commodity) {
				//First check if any quantitites are required for resupply to avoid empty entries
				if ($resupply[$commodity_counter] > 0) {
					$cdrr_item = new Cdrr_Item();
					$cdrr_item -> Balance = $opening_balances[$commodity_counter];
					$cdrr_item -> Received = $quantities_received[$commodity_counter];
					$cdrr_item -> Dispensed_Units = $quantities_dispensed[$commodity_counter];
					//For fcdrr, packs are not used.
					//$cdrr_item->Dispensed_Packs = $opening_balances[$commodity_counter];
					$cdrr_item -> Losses = $losses[$commodity_counter];
					$cdrr_item -> Adjustments = $adjustments[$commodity_counter];
					$cdrr_item -> Count = $physical_count[$commodity_counter];
					$cdrr_item -> Resupply = $resupply[$commodity_counter];
					//The following not required for fcdrrs
					/*$cdrr_item->Aggr_Consumed = $opening_balances[$commodity_counter];
					 $cdrr_item->Aggr_On_Hand = $opening_balances[$commodity_counter];
					 $cdrr_item->Publish = $opening_balances[$commodity_counter];*/
					$cdrr_item -> Cdrr_Id = $order_id;
					$cdrr_item -> Drug_Id = $commodities[$commodity_counter];
					$cdrr_item -> save();
					echo $cdrr_item -> id . "<br>";
				}
				$commodity_counter++;
			}
		}
		//Save the maps details
		$maps_id = $order_object -> id;
		if ($regimens != null) {
			foreach ($regimens as $regimen) {
				//Check if any patient numbers have been reported for this regimen
				if ($patient_numbers[$regimen_counter] > 0) {
					$maps_item = new Maps_Item();
					$maps_item -> Total = $patient_numbers[$regimen_counter];
					$maps_item -> Regimen_Id = $regimens[$regimen_counter];
					$maps_item -> Maps_Id = $maps_id;
					$maps_item -> save();
					echo $maps_item -> id . "<br>";
				}
				$regimen_counter++;
			}
		}
		//var_dump($this -> input -> post());
		redirect("order_management/submitted_orders");
		/*$cdrr_sql = "INSERT INTO cdrr (status,created,updated,code,period_begin,period_end,comments,services,sponsors,delivery_note,facility_id)VALUES('prepared','$created_on','$updated_on','F-CDRR_units','$period_start','$period_end','','$services','$sponsors','','108'); select last_insert_id() as cdrr_id;";
		 echo $cdrr_sql;
		 $cdrr_item_sql = "";
		 //save the cdrr items
		 $commodity_counter = 0;
		 foreach ($commodities as $commodity) {
		 if ($resupply[$commodity_counter] > 0) {
		 //create the sql
		 $cdrr_id = "1";
		 $cdrr_item_sql .= "INSERT INTO cdrr_item (balance,received,dispensed_units,dispensed_packs,losses,adjustments,count,expiry_quant,expiry_date,out_of_stock,resupply,aggr_consumed,aggr_on_hand,publish,cdrr_id,drug_id)VALUES('$opening_balances[$commodity_counter]','$quantities_received[$commodity_counter]','$quantities_dispensed[$commodity_counter]','','$losses[$commodity_counter]','$adjustments[$commodity_counter]','$physical_count[$commodity_counter]','$expiry_quantity[$commodity_counter]','$expiry_date[$commodity_counter]','$out_of_stock[$commodity_counter]','$resupply[$commodity_counter]','','','0','$cdrr_id','$commodities[$commodity_counter]');";
		 }
		 $commodity_counter++;
		 }
		 echo $cdrr_item_sql;
		 //Make database connection
		 /*$connection = ssh2_connect('demo.kenyapharma.org', 22);
		 ssh2_auth_password($connection, 'ubuntu', 'Nb!23Q2([58L61D');
		 $tunnel = ssh2_tunnel($connection, 'demo.kenyapharma.org', 3306);
		 $db = mysqli_connect('demo.kenyapharma.org', 'demo', 'Ms#=T9F1@56446N', 'kenyapharma_demo', 3306) or die('Fail: ' . mysql_error());
		 */
		//Connection2
		/*$connection = ssh2_connect('demo.kenyapharma.org', '22');
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
		 */
	}

}
?>
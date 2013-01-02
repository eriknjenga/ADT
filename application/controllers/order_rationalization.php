<?php
class Order_Rationalization extends MY_Controller {
	function __construct() {
		parent::__construct();
		$this -> load -> library('pagination');
	}

	public function index() {
		$this -> submitted_orders();
	}

	public function submitted_orders($status = 0, $offset = 0) {
		$items_per_page = 20;
		$number_of_orders = Facility_Order::getTotalNumber($status);
		$orders = Facility_Order::getPagedOrders($offset, $items_per_page, $status);
		if ($number_of_orders > $items_per_page) {
			$config['base_url'] = base_url() . "order_rationalization/submitted_orders/".$status."/";
			$config['total_rows'] = $number_of_orders;
			$config['per_page'] = $items_per_page;
			$config['uri_segment'] = 4;
			$config['num_links'] = 5;
			$this -> pagination -> initialize($config);
			$data['pagination'] = $this -> pagination -> create_links();
		}
		$data['orders'] = $orders;
		$data['quick_link'] = $status;
		$data['content_view'] = "view_orders_v";
		//If the orders being viewd are approved, display the view for generating the picking list
		if($status == 1){
			$data['content_view'] = "view_approved_orders_v";
		}
		$data['banner_text'] = "Submitted Orders";
		$data['styles'] = array("pagination.css");
		//get all submitted orders that have not been rationalized (fresh orders)
		$this -> base_params($data);
	}

	public function rationalize_order($order) {
		//First retrieve the order and its particulars from the database
		$data = array();
		$data['order_details'] = Facility_Order::getOrder($order);
		$data['commodities'] = Cdrr_Item::getOrderItems($order);
		$data['regimens'] = Maps_Item::getOrderItems($order);
		$data['comments'] = Order_Comment::getOrderComments($order);
		$data['content_view'] = "rationalize_order_v";
		$data['banner_text'] = "Order Particulars";
		//get all submitted orders that have not been rationalized (fresh orders)
		$this -> base_params($data);
	}

	public function save() { 
		//save the changes made and change the status
		$updated_on = date("U");
		$user_id = $this -> session -> userdata('user_id');
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
		$approve_order = $this -> input -> post('approve_order');
		$decline_order = $this -> input -> post('decline_order');
		$order_number = $this -> input -> post('order_number');
		$commodity_counter = 0;
		$regimen_counter = 0;
		//url to redirect after saving the record
		$url = "";
		//retrieve the order that is being edited
		$order_object = Facility_Order::getOrder($order_number);
		$status = 0;
		//Check which button was pressed
		if ($approve_order != null) {
			$url = "order_rationalization/submitted_orders/1";
			$status = 1;
		}
		if ($decline_order != null) {
			$url = "order_rationalization/submitted_orders/2";
			$status = 2;
		}
		$order_object -> Status = $status;
		$order_object -> Updated = $updated_on;
		//code = 0 i.e. fcdrr
		$order_object -> Code = 0;
		//Only for dcdrrs
		/*$order_object->Reports_Expected = 0;
		 $order_object->Reports_Actual = 0;*/
		$order_object -> save();
		$order_id = $order_object -> id;
		//Now save the comment that has been made
		$order_comment = new Order_Comment();
		$order_comment -> Order_Number = $order_id;
		$order_comment -> Timestamp = date('U');
		$order_comment -> User = $user_id;
		$order_comment -> Comment = $comments;
		$order_comment -> save();
		//Now save the cdrr items
		$commodity_counter = 0;
		if ($commodities != null) {
			foreach ($commodities as $commodity) {
				//First check if any quantitites are required for resupply to avoid empty entriesv
					$cdrr_item = Cdrr_Item::getItem($commodity);
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
					$cdrr_item -> save();
					echo $cdrr_item -> id . "<br>";
				$commodity_counter++;
			}
		}
		//Save the maps details
		$maps_id = $order_object -> id;
		if ($regimens != null) {
			foreach ($regimens as $regimen) {
				//Check if any patient numbers have been reported for this regimen
				if ($patient_numbers[$regimen_counter] > 0) {
					$maps_item = Maps_Item::getItem($regimen);
					$maps_item -> Total = $patient_numbers[$regimen_counter];
					$maps_item -> Maps_Id = $maps_id;
					$maps_item -> save();
					echo $maps_item -> id . "<br>";
				}
				$regimen_counter++;
			}
		}
		redirect($url);
	}

	public function base_params($data) {
		$data['title'] = "Commodity Orders";

		$data['link'] = "order_management";
		$this -> load -> view('template', $data);
	}

}
?>
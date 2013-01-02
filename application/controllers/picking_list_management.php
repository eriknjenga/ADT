<?php
class Picking_List_Management extends MY_Controller {
	function __construct() {
		parent::__construct();
		$this -> load -> library('pagination');
	}

	public function index() {
		$this -> submitted_lists();
	}

	public function submitted_lists($status = 0, $offset = 0) {
		$items_per_page = 20;
		$number_of_lists = Picking_List_Details::getTotalNumber($status);
		$lists = Picking_List_Details::getPagedLists($offset, $items_per_page, $status);
		if ($number_of_lists > $items_per_page) {
			$config['base_url'] = base_url() . "picking_list_management/submitted_orders/" . $status . "/";
			$config['total_rows'] = $number_of_lists;
			$config['per_page'] = $items_per_page;
			$config['uri_segment'] = 4;
			$config['num_links'] = 5;
			$this -> pagination -> initialize($config);
			$data['pagination'] = $this -> pagination -> create_links();
		}
		$data['lists'] = $lists;
		$data['quick_link'] = $status;
		$data['content_view'] = "view_lists_v";
		$data['banner_text'] = "Picking Lists";
		$data['styles'] = array("pagination.css");
		$this -> base_params($data);
	}

	public function view_orders($list) {
		//First retrieve the order and its particulars from the database
		$data = array();
		$data['list'] = Picking_List_Details::getList($list); 
		$data['content_view'] = "view_list_details_v";
		$data['banner_text'] = "Picking List Details";
		//get all submitted orders that have not been rationalized (fresh orders)
		$this -> base_params($data);
	}

	public function delete_list($list) {
		$list = Picking_List_Details::getList($list);
		//get the orders linked to this list and delink them first
		$orders = $list -> Order_Objects;
		foreach ($orders as $order) {
			$order -> Picking_List_Id = "";
			$order -> save();
		}
		//Then delete the list itself
		$list -> delete();
		redirect("picking_list_management");
	}

	public function save_list() {
		$current_user = $this -> session -> userdata('user_id');
		$orders = $this -> input -> post("orders");
		$picking_list_name = $this -> input -> post("picking_list_name");
		$selected_picking_list = $this -> input -> post("selected_picking_list");
		//First check if a name has been given to a new picking list. If so, save it first
		if (strlen($picking_list_name) > 0) {
			$picking_list = new Picking_List_Details();
			$picking_list -> Name = $picking_list_name;
			$picking_list -> Timestamp = date('U');
			$picking_list -> Created_By = $current_user;
			$picking_list -> Status = '0';
			$picking_list -> save();
			$selected_picking_list = $picking_list -> id;
		}
		//Now save the orders in with the selected/new picking list
		foreach ($orders as $order) {
			//Retrieve the order from the database and update it's picking list details
			$order_details = Facility_Order::getOrder($order);
			$order_details -> Picking_List_Id = $selected_picking_list; ;
			$order_details -> save();
		}
		redirect("picking_list_management");
	}

	public function assign_orders() {
		$data = array();
		$data['orders'] = $this -> input -> post("order");
		$data['banner_text'] = "Assign Picking List";
		$data['picking_lists'] = Picking_List_Details::getAllOpen();
		$data['content_view'] = "assign_picking_list_v";
		$this -> base_params($data);
	}

	public function base_params($data) {
		$data['title'] = "Commodity Orders";

		$data['link'] = "order_management";
		$this -> load -> view('template', $data);
	}

}
?>
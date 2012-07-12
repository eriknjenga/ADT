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

	public function base_params($data) {
		$data['title'] = "Commodity Orders";

		$data['link'] = "order_management";
		$this -> load -> view('template', $data);
	}

}
?>
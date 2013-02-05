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
		if ($status == 1) {
			$data['content_view'] = "view_closed_lists_v";
		}
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

	public function close_list($list) {
		//retrieve the list first and change its details
		$list = Picking_List_Details::getList($list);
		$list -> Status = "1";
		$list -> save();
		//Retrieve the orders in the list and change their statuses to dispatched
		$orders = $list -> Order_Objects;
		foreach ($orders as $order) {
			$order -> Status = "3";
			$order -> save();
		}
		redirect("picking_list_management/submitted_lists/1");
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
		$data['title'] = "Warehouse Picking Lists";
		$data['link'] = "order_management";
		$this -> load -> view('template', $data);
	}

	public function print_list($list) {
		//retrieve the list first and change its details
		$list = Picking_List_Details::getList($list);
		$orders = $list -> Order_Objects;
		$data = "
			<style>
			table.data-table {
			table-layout: fixed;
			width: 700px;
			border-collapse:collapse;
			border:1px solid black;
			}
			table.data-table td, th {
			width: 100px;
			border: 1px solid black;
			}
			.leftie{
				text-align: left !important;
			}
			.right{
				text-align: right !important;
			}
			.center{
				text-align: center !important;
			}
			</style> 
			";
		foreach ($orders as $order) {
			$data .= '
			<h5 style="text-align: left">'.$order->Facility_Object->name.' number '.$order->id.'</h5>
		<table class="data-table">	
<thead>
	<tr>
		<th>Commodity</th>
		<th>Quantity for Resupply</th>
		<th>Packs/Bottles/Tins</th>
	</tr>
</thead>
<tbody>';
//Retrieve the ordered commodities
$commodities = $order->Commodity_Objects;
//Loop through the commodities to display their particulars
foreach($commodities as $commodity){
	$data .= '<tr>
		<td>'.$commodity -> Drugcode_Object->Drug.'</td>
		<td>'.$commodity ->Resupply.'</td>
		<td>';
		if($commodity -> Drugcode_Object->Drug_Unit->Name == "Bottle"){$data .= 'Bottle';} else{$data .= 'Packs';}
		$data .= '</td>
	</tr>';
	 } 
	$data .= '</tbody>
</table>
';
		}
		$this -> generatePDF($data);
	}

	function generatePDF($data) {
		$current_date = date("M d, Y");

		$html_title = "
<div style='width:100px; height:100px; margin:0 auto;'><img src='Images/coat_of_arms-resized.png' style='width:96px; height:96px;'></img>
</div>
";
		$html_title .= "<h3 style='text-align:center;'>MINISTRY OF HEALTH</h3>";
		$html_title .= "<span style='text-align:left;'>Kenyatta Hospital Grounds, AIDS/TB/Leprosy Division</span>
<br/>
";
		$html_title .= "<span style='text-align:left;'>P.O. Box 19361, Nairobi</span>
<br/>
";
		$html_title .= "<span style='text-align:left;'>Telephone: 020- 2729502/49</span>
<br/>
";
		$html_title .= "<span style='text-align:left;'>Fax: 020 - 2710518</span>
<br/>
";
		$html_title .= "<span style='text-align:left;'>Email: art@lmu.co.ke</span>
<br/>
";
		$html_title .= "<h4 style='text-align:left;'>FROM: ARV Logistics Management Unit, NASCOP</h4>";
		$html_title .= "<h4 style='text-align:left;'>TO: Customer Service, KEMSA</h4>";
		$html_title .= "<h4 style='text-align:left;'>CC: Warehouse manager, KEMSA</h4>";
		$html_title .= "<h4 style='text-align:left;'>Date: $current_date</h4>";
		$html_title .= "<h3 style='text-align:left; text-decoration: underline;'>RESUPPLY OF ARV'S</h3>";
		//Create the footer 
		$current_user = $this -> session -> userdata('user_id');
		$user_object = Users::getUser($current_user);
		//retrieve user so as to get their signature
		$html_footer = "<div style='width:100%; position:fixed; bottom:0;'><h4 style='text-align:left;'>Yours Faithfully,</h4><div style='width:160px; height:100px; margin:20px; auto 0 auto;'><img src='Images/".$user_object->Signature."'></img></div>";
		$html_footer .= "<h4 style='text-align:left;'>".$user_object->Name.", Pharmacist, NASCOP's ARV Logistics Management Unit at Kemsa"."</h4></div>";
		//echo $html_footer;
		$this -> load -> library('mpdf');
		$this -> mpdf = new mPDF('c', 'A4');
		$this -> mpdf -> SetTitle('Warehouse Picking List');
		$this -> mpdf -> defaultfooterfontsize = 9;
		/* blank, B, I, or BI */
		$this -> mpdf -> defaultfooterline = 1;
		/* 1 to include line below header/above footer */
		$this -> mpdf -> mirrorMargins = 1;
		$mpdf -> defaultfooterfontstyle = B;
		$this -> mpdf -> SetFooter('Generated on: {DATE d/m/Y}|{PAGENO}|Warehouse Picking List');
		$this -> mpdf -> WriteHTML($html_title);
		$this -> mpdf -> simpleTables = true;
		$this -> mpdf -> WriteHTML($data);
		$this -> mpdf -> WriteHTML($html_footer);
		$report_name = "Warehouse Picking List.pdf";
		$this -> mpdf -> Output($report_name, 'D');
	}

}
?>
<?php
class newuser_management extends MY_Controller{
	function __construct(){
		parent::__construct();
	}
	
	public function index(){
		$this -> userlisting();
	}
	
	public function userlisting(){
		echo "List of users gooes here";
	}
	
	public function add(){
		$data['content_view'] = "newuser_add_v";
		$data['title'] = "Add New User";
		
		$this -> base_params($data);
	}
	
	public function save(){
		$valid = $this-> _validate_submission();
		if($valid == FALSE){
			$data['content_view'] = "newuser_add_v";
			$this -> base_params($data);
		}else{
			
		}
	}
}

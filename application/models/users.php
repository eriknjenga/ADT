<?php
class Users extends Doctrine_Record {

	public function setTableDefinition() {
		$this -> hasColumn('Name', 'varchar', 100);
		$this -> hasColumn('Username', 'varchar', 12);
		$this -> hasColumn('Password', 'varchar', 32);
		$this -> hasColumn('Access_Level', 'varchar', 1);
		$this -> hasColumn('Facility_Code', 'varchar', 10);
		$this -> hasColumn('Created_By', 'varchar', 5);
		$this -> hasColumn('Time_Created', 'varchar', 32);
		$this -> hasColumn('Phone_Number', 'varchar', 50);
		$this -> hasColumn('Email_Address', 'varchar', 50);
		$this -> hasColumn('Active', 'varchar', 2);
	}

	public function setUp() {
		$this -> setTableName('users');
		$this -> hasMutator('Password', '_encrypt_password');
	}

	protected function _encrypt_password($value) {
		$this -> _set('Password', md5($value));
	}

	public function login($username, $password) {

		$query = Doctrine_Query::create() -> select("*") -> from("Users") -> where("Username = '" . $username . "'");

		$user = $query -> fetchOne();
		if ($user) {

			$user2 = new Users();
			$user2 -> Password = $password;

			if ($user -> Password == $user2 -> Password) {
				return $user;
			} else {
				return false;
			}
		} else {
			return false;
		}

	}

	//added by dave
	public function getAccessLevels() {
		$levelquery = Doctrine_Query::create() -> select("id,access,level") -> from("Access_Level");
		$accesslevels = $levelquery -> execute();
		return $accesslevels;
	}
	
	//facilities...
	public function getFacilityData() {
		$facilityquery = Doctrine_Query::create() -> select("facilitycode,name") -> from("facilities");
		$accesslevels = $query -> execute();
		return $accesslevels;
	}

}

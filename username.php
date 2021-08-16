<?php

	include_once("includes/db.php");
	include_once("settings.php");
	
	$db = new database($db_name, $db_server, $db_user, $db_password, '');


if(isset($_REQUEST['u'])) {
	$userCheckResult = new usernameChecker($_REQUEST['u']);
	if(count($userCheckResult->errorList)>0) {
		echo "<error>";
		for($i = 0; $i < count($userCheckResult->errorList); $i++) {
			echo $userCheckResult->errorList[$i] . "\n";
		}
		echo "</error>";
	} else {
		echo '<success>true</success>';
	}
} else {
	echo '<error>Missing data</error>';
}
// ERR1 Username can't contain swear words.


class usernameChecker {
	var $username = "";
	var $errorList = array();
	
	
	public function __construct($username) {
		$this->username = $username;
		$this->check_swears();
		$this->check_exists();
		$this->check_size();
		$this->check_characters();
		if(count($this->errorList)>0) {
			//Errors detected.
			print_r($this->errorList);
		}
	}
	public function check_characters() {
		$pattern= "~^[a-z0-9_\p{Arabic}]+$~iu";
		if(preg_match($pattern, $this->username)==false) {
			$this->add_Error("Invalid characters in username. Please use only standard characters, no spaces are permitted");
		}
	}
	public function check_size() {
		$min_length = 2;
		$max_length = 24;
		if(strlen($this->username)<=$min_length) $this->add_Error("Username is too short. Minimum of " . $min_length . " is required.");
		if(strlen($this->username)>$max_length) $this->add_Error("Username is too long. Maximum of " . $max_length . " is required.");
	}
	public function check_swears() {
		global $db;
		$db->setQuery("SELECT name FROM `cc_swear_words`");
		$swearwordList = $db->loadResults();

		for($i=0; $i<count($swearwordList); $i++) {
			if(strpos($this->username, $swearwordList[$i]->name)!==false) {
				//echo 'Username contains cuss word ' . $swearwordList[$i]->name.'</br>';
				$this->add_Error("Username can't contain swear words. (".$swearwordList[$i]->name.")");
				return;
			}
		}
	}
	public function check_exists() {
		global $db;
		$preparedReq = $db->setQuery("SELECT count(*) as counter FROM `cc_user` WHERE username='" . mysqli_real_escape_string($db->_connection,$this->username) . "'");
		$res = $db->loadResult();
		if($res->counter>0) {
			$this->add_Error("Username already exists. Please choose another username.");
		}
	}
	public function add_Error($error) {
		array_push($this->errorList, $error);
	}
}



//$db = new database($obj->get("db_name"), $obj->get("db_server"), $obj->get("db_user"), $obj->get("db_password"), $obj->get("url_root"));




 ?>
 </data>
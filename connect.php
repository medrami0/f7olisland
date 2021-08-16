<data>
<?php

	include_once("includes/db.php");
	include_once("settings.php");


    $db = new database();

$error = "";

if(isset($_REQUEST['id'] , $_REQUEST['type'])) {
		
	$id = safeEntry($_REQUEST['id']);
	$type = safeEntry($_REQUEST['type']);
	
	$error = validateUserData($id, $type);
	
	if($error=="") {
		session_start();
		$_SESSION["social_id"] = $id;
		// check for existance of this parent.
		$db->setQuery("SELECT * FROM cc_user_parent WHERE social_id='" . ($id) . "' AND TYPE='" . $type . "' LIMIT 1");
		$parentCheck = $db->loadResults();
		
		// check for the existance of the children.
		$db->setQuery("SELECT username FROM cc_user WHERE social_id='" . $id . "' LIMIT 1");
		$userCheck = $db->loadResults();
		
		if(count($parentCheck)==0) {
			// verify their facebook account.
			// ...
			// ...
			$firstName = 'First';
			$lastName = 'Last';
			$type = "DID";
			$email = "1@cocolani.com";
			insertRecord($firstName, $lastName, $email, $id, $type);
			?><verification new="true">1</verification>
<?php
		} else {
			?><verification new="false">1</verification>
<?php
		}
		
		if(count($userCheck)>0) {
?><account>
<uid><?php echo $userCheck[0]->username;?></uid>
</account>
<?php
		} else {
?><account>
</account>
<?php
		}
		
		$db->setQuery("SELECT z.port, z.zone_name, s.ip FROM cc_zones z, cc_servers s WHERE z.enabled=1 AND z.server_id=s.id;");
		$serverList = $db->loadResults();
		if(count($serverList)>0) {
			for($i=0; $i < count($serverList); $i++) {
			?>
<server>
	<ip><?php echo $serverList[$i]->ip;?></ip>
	<port><?php echo $serverList[$i]->port;?></port>
	<zone><?php echo $serverList[$i]->zone_name;?></zone>
</server>
			<?php
			}
		}
	}
} else {
	$error = "Missing Data";
}

if($error!="") {
	// show any errors.
	?><error><?php echo $error;?></error><?php
}

function insertRecord($fn, $ln, $email, $id, $type) {
	// process sterilized values.
	global $db;
	$cmd = "INSERT INTO `cc_user_parent` (`first_name`, `last_name`, `email`, `social_id`, `type`) VALUES ('" . 
		$fn . "', '" . $ln . "', '" . $email . "', '".$id."', '". $type . "')";
	$db->setQuery($cmd);
	if(!$db->runQuery()) {
		echo 'Failed adding user!' . $db->getError();
	}
}
function validateUserData($id, $type) {
	if($type!="DID" && $type!="FB") {
		return "Invalid type requested.";
	}
	return "";
}
function safeEntry($term) {
	global $db;
	return mysqli_real_escape_string($db->_connection, $term);
}

 ?>
 </data>
  
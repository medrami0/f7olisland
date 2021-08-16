<?php
error_reporting(E_ALL);
require_once ("settings.php");
require_once ("includes/db.php");

$db = new database($db_name, $db_server, $db_user, $db_password, $url_from_root);

report_db("POST:" . addslashes(implode(getallheaders())) . " IP:" . $_SERVER["REMOTE_ADDR"] ."");
//report_db("POST:" . addslashes("GOT RESULT....") . " IP:" . $_SERVER["REMOTE_ADDR"] ."");

//echo $db->getError();
$s = new sp_test($db);

//Get Curl Sends
$myCurlInfo = getallheaders();

$landline = isset($myCurlInfo['X-EED-CUSTOMERID']) ? $myCurlInfo['X-EED-CUSTOMERID'] : NULL;
$serviceID = isset($myCurlInfo["X-EED-SERVICEID"]) ? $myCurlInfo["X-EED-SERVICEID"] : NULL;
$serviceValidity = isset($myCurlInfo["X-EED-VALIDITY"]) ? $myCurlInfo["X-EED-VALIDITY"] : NULL;
$childID = isset($myCurlInfo["X-EED-CHILDID"]) ? $myCurlInfo["X-EED-CHILDID"] : NULL;
$prepaid = $landline;

//if(!$landline || !$childID)
	//die();
	//report_db("Should not die ... landline : $landline, childID : $childID");
/*
$landline = isset($_REQUEST["X-EED-CUSTOMERID"]) ? $_REQUEST["X-EED-CUSTOMERID"] : NULL;
$prepaid = $landline;
$serviceID = isset($_REQUEST["X-EED-SERVICEID"]) ? $_REQUEST["X-EED-SERVICEID"] : NULL;
$childID = isset($_REQUEST["X-EED-CHILDID"]) ? $_REQUEST["X-EED-CHILDID"] : NULL;
*/

if($_REQUEST["action"]=="subscription") {
	$s->subscribe_product( $landline, $prepaid, $serviceID, $childID, $serviceValidity );
} else if($_REQUEST["action"]=="subscriptionActive"){
	// confirm the subscription.
	$s->activate_subscription( $landline, $serviceID);
}

function report_db($text) {
	global $db;
	$db->setQuery("INSERT INTO `cc_debug_logs` (`desc`,`reported_by`) VALUES ('" . $text . "', '1')");
	$db->runQuery();
}

class sp_test {

	const URL 			 	 = "https://stc-dev.cocolani.com/payment/m3com";
	const CONNECTION_TIMEOUT = 3;
	
	public $request;
	public $response;
	public $db;
	
	public function __construct ( $_db) {
		$this->db = $_db;
	}
	public function report_error($errtext) {
		$this->db->setQuery("INSERT INTO `cc_debug_logs` (`desc`,`reported_by`) VALUES ('Error reported:".addslashes($errtext)."', '1')");
		$this->db->runQuery();
	}
	public function subscribe_product ( $landline, $prepaid, $service_id, $child_id, $validity ) {
		$db = $this->db;
		$userFound = false;
		$packageFound = false;
		$addedPackage = false;
		$response_status = '101';
		$userData;
		
		$paymentLookup = $landline;
		if($prepaid) $paymentLookup = $prepaid;
		
		// check the user exists with this landline
		
		$db->setQuery("SELECT * from cc_user where username='".$child_id."'");
		$userData = $db->loadResults();
		if(count($userData)==1) {
			$userFound = true;
		}
		else { 
			report_db("Could not find user with child ID : " . $child_id);
		}
		
		/*$db->setQuery("SELECT * from cc_user where landline='".$paymentLookup."'");
		$userData = $db->loadResults();
		if(count($userData)==1) {
			$userFound = true;
		}
		else { 
			
			// If this landline doesn't exist, check to see if the username in the child id matches up in the table.
			// Requested by STC January 2013

			$db->setQuery("SELECT * from cc_user where username='".mysql_real_escape_string($child_id)."'");
			$userData = $db->loadResults();
			if(count($userData)==1) {
				$userFound = true;
			} else {
				$userFound = false;
			}
			
		}*/

		// check if the package / subscription already exist.
		if($userFound){ 
			$db->setQuery("SELECT * FROM `cc_payment_stc` WHERE landline_id='".$landline."' OR service_id='".$prepaid."' AND confirmed='0'");
			
			$packageRes = $db->loadResults();
			if(count($packageRes)>0) {
				$packageFound = true;
			}
			
			if($packageFound == false) {
				// add this package data.
					$db->setQuery("INSERT INTO `cc_payment_stc` (`cc_userid`, `landline_id`, `service_id`, `m3com_user`, `service_validity`)
								VALUES ('".$userData[0]->ID."', '$landline', '$service_id', '".$userData[0]->username."', '".$validity."')");
				if($db->runQuery()) {
					$addedPackage = true;
				} else {
					$addedPackage = false;
				}
			}
		}
		
		if($userFound==true && ($packageFound || $addedPackage)) {
			$response_status = 0;
			if($addedPackage) $this->report_error("Added new package for user : " . $userData[0]->username);
			if($packageFound) $this->report_error("Already had an active package for user : " . $userData[0]->username);
		} else {
			$response_status = 101;
			if(!$userFound) { 
				$this->report_error("Could not find user with userID : " . $child_id . ' & ' . $landline . ' or prepaid : ' . $prepaid);
				die();
			};
			if(!$packageFound && !$addedPackage) $this->report_error("Could not find or add new package for discovered user " . $userData[0]->username);
		}

?><xml><subscription_response>
		<status><?php echo $response_status;?></status>
		</subscription_response></xml>
<?php
	}
	
	public function activate_subscription ($landline, $serviceID) {
		$this->report_error("Activate subscription requested for landline:".$landline." and service ID: ".$serviceID);
		$amount = 1000; // how many credits to award player for this package.
		
		$packageFound = false;
		$response_status = '101';
		
		$db = $this->db;
		report_db('activate_subscription query: ' . "SELECT * FROM `cc_payment_stc` WHERE landline_id='".$landline."' AND service_id='".$serviceID."' AND confirmed='0'");
		//$db->setQuery("SELECT * FROM `cc_payment_stc` WHERE landline_id='".$landline."' AND confirmed='0'");
		$db->setQuery("SELECT * FROM `cc_payment_stc` WHERE landline_id='".$landline."' AND service_id='".$serviceID."' AND confirmed='0'");
		$packageRes = $db->loadResults();
		
		if(count($packageRes)==1) {
			$packageFound = true;
		}
		if($packageFound) {
			$db->setQuery("SELECT * FROM `cc_user` WHERE ID='".$packageRes[0]->cc_userid."'");
			$userdata = $db->loadResult();
			
			$purse = $userdata->money;
			$purse = explode(",", $purse);
			$tribeID = (int) $userdata->tribe_ID - 1;
			$purse[$tribeID] += $amount;
			// Update the user's purse with the new FB value
			$db->setQuery("UPDATE `cc_user` SET money='".implode(",",$purse)."' WHERE ID='".$userdata->ID."' LIMIT 1");
			if($db->runQuery()){ 
				$db->setQuery("INSERT INTO `cc_transactions` (`user_id`,`type`,`obj_id`,`amount`) VALUES ('".$userdata->ID."','STC_payment',NULL,'".$amount."')");
				$db->runQuery();
				$db->setQuery("INSERT INTO `cc_user_operations` (`command`,`params`) VALUES ('CURRENCY_UPDATE','".$userdata->ID."')");
				$db->runQuery();
				$db->setQuery("UPDATE `cc_payment_stc` SET confirmed=1 WHERE ID='".$packageRes[0]->ID."'");
				$db->runQuery();
				
				$response_status = '0';
				$this->report_error("Succesful payment to acct for user:" . $userdata->username);
			} else {
				$this->report_error("Error: unable to update the purse for user " . $userdata->username);
			}
		} else {
			$response_status = '1';
		}
		?><xml><subscription_response>
		<status><?php echo $response_status;?></status>
		</subscription_response></xml>
		<?php
		
	}
}
?>
<?php
	include_once("includes/db.php");
	include_once("settings.php");
    $db = new database();

	//$FROM_EMAIL = $obj->getEmailFrom();

	function generateTribeCurrency($ID, $db) {

	//	$db = new database();

		// get init purse amount
  		$db->setQuery("SELECT init_purse_amount FROM `cc_def_settings`");
		$row = $db->loadResult();
		$init_purse_amount = $row->init_purse_amount;

    		// load tribe info
		$db->setQuery("SELECT * FROM `cc_tribes`");
		$tribeinfo = $db->loadResults();

		$newstr = array();
		foreach ($tribeinfo as $i) {
			if ($ID == $i->ID) array_push($newstr, $init_purse_amount); else array_push($newstr, 0);
		}
		$newstr = implode(",", $newstr);

		return $newstr;
	}

	$hackchk = false;
  function remove_bad_symbols($s) {
    return preg_replace(
      array(0=>'#/#', 1=>'#\\\#', 2=>'#;#', 3=>'#{#', 4=>'#}#', 5=>'#<#', 6=>'#>#', 7=>'#@#', 8=>'#\'#', 9=>'# #', 10=>'#"#') // patterns
      , '' // replacements
      , $s);
  }

	$username = isset($_POST['username']) ? mysqli_real_escape_string($connect,$_POST['username']) : "";
	$password = isset($_POST['password']) ? mysqli_real_escape_string($connect,$_POST['password']) : "";
	$email = isset($_POST['email']) ? mysqli_real_escape_string($connect,$_POST['email']) : '';
	$birthdate = isset($_POST['birthdate']) ? mysqli_real_escape_string($connect,$_POST['birthdate']) : "";
	$firstname = isset($_POST['firstname']) ? mysqli_real_escape_string($connect,$_POST['firstname']) : "";
	$lastname = isset($_POST['lastname']) ? mysqli_real_escape_string($connect,$_POST['lastname']) : "";
	$sex = isset($_POST['sex']) ? mysqli_real_escape_string($connect,$_POST['sex']) : "";
	$tribeid = isset($_POST['clan']) ? mysqli_real_escape_string($connect,$_POST['clan']) : "";
	$mask = isset($_POST['mask']) ? mysqli_real_escape_string($connect,$_POST['mask']) : "";
	$mask_color = isset($_POST['maskcl']) ? mysqli_real_escape_string($connect,$_POST['maskcl']) : "";
	$lang_id = isset($_POST['lang_id']) ? addslashes($_POST['lang_id']) : 0;
	$error = '';

	 $purse = generateTribeCurrency((int) $tribeid, $db);

   // get language suffix
 	 if ($lang_id != 0) {
     $db->setQuery("SELECT * FROM `cc_extra_langs` WHERE id='{$lang_id}'");
     $res = $db->loadResult();
     $lang = "_".$res->lang;
   } else $lang = "";


   $db->setQuery("SELECT one_email_per_registration FROM `cc_def_settings`");
   $res = $db->loadResult();
   $one_registration_per_email = ($res->one_email_per_registration == 5);

   $email_check_ok = true;
   if ($one_registration_per_email == true) {
     $sql = "SELECT COUNT(*) AS counter FROM `cc_user` WHERE email='{$email}'"; // for several registrations per one email address -- no check
	   $db->setQuery($sql);
	   $res1 = $db->loadResult();
	   $email_check_ok = $res1->counter == "0";
	 }

   // first check there is no username with this name already registered.
	 $db->setQuery("SELECT COUNT(*) AS counter FROM `cc_user` WHERE username='".$username."'");
	 $res = $db->loadResult();

	 if ($username && $email && $sex && $birthdate) {
		 if ($email_check_ok) {
       if ($res->counter == "0") {
  			// check that there are no registrations from this same IP in the last 2 hours
  			$db->setQuery("SELECT COUNT(*) as counter FROM `cc_userreginfo` WHERE IP='".$_SERVER['REMOTE_ADDR']."' AND (DATE_SUB(CURDATE(), INTERVAL 2 HOUR)<register_date)");
  			$regcheck = $db->loadResult();
  			if (($regcheck != null && (int)($regcheck->counter) == 0) || $hackchk == false) {

          // get number of already registered number of registrations with this email address
          $query = $db->setQuery("SELECT count(*) as registered_num_emails FROM `cc_user` WHERE email='{$email}'");
          $row = $db->loadResult();
          $already_registered_num_emails = $row->registered_num_emails;

          // get max number of accounts per email from settings table
          $query = $db->setQuery("SELECT max_num_account_per_email from `cc_def_settings`");
          $row = $db->loadResult();
          $max_num_account_per_email = $row->max_num_account_per_email;

          if ($already_registered_num_emails < $max_num_account_per_email) {

      			  $uniqid = uniqid();
      				$newreq = "INSERT INTO `cc_user` (`ID`,`username`, `password`, `email`, `birth_date`, `first_name`, `last_name`, `sex`, `about`, `mask`, `mask_colors`, `clothing`, `tribe_ID` , `money`, `happyness`, `rank_ID`, `status_ID`, `lang_id`, `register_date`, uniqid, permission_id) VALUES ";
      				$newreq .= "(NULL, '{$username}', '{$password}', '{$email}', '{$birthdate}', '{$firstname}' , '{$lastname}', '{$sex}', '', '{$mask}', '{$mask_color}', '', '{$tribeid}', '{$purse}', 50, 0, 3, '{$lang_id}', NOW(), '{$uniqid}', 4)";
      				$db->setQuery($newreq);
      				$res = $db->runQuery();
      				if ($res) {
      				  // add registration info into the userreginfo table as well.
      					$iid = $db->mysqlInsertID();
      					$db->setQuery("INSERT INTO `cc_userreginfo` (`ID`, `user_id`, `register_IP`, `register_date`, `last_update`) VALUES (NULL, ".$iid.",'".$_SERVER['REMOTE_ADDR']."', NOW(), NOW())");
      					$res2 = $db->runQuery();

      					$counter = ($regcheck != null) ? $regcheck->counter : 0;
      					echo 'response=true&reg='.$counter;
      				} else {
      					echo 'response=false';
      				}

          } else {
            // get warning message from db
            $db->setQuery("SELECT * FROM `cc_translations` WHERE caption='MAX_NUM_REGISTRATION_REACHED'");
          	$res = $db->loadResult();
    			  echo 'error='.urlencode($res->name);
          }


  			} else {
          // get warning message from db
          $db->setQuery("SELECT * FROM `cc_translations` WHERE caption='REGISTER_LATER'");
        	$res = $db->loadResult();
  			  echo 'errorhide='.urlencode($res->name);
  			}
  		 } else {
         // get warning message from db
         $db->setQuery("SELECT * FROM `cc_translations` WHERE caption='USERNAME_IN_USE'");
         $res = $db->loadResult();
  		   echo 'error='.urlencode($res->name);
  	 	 }
     } else {
       //if ($one_registration_per_email == true)
         $sql = "SELECT * FROM `cc_translations` WHERE caption='DUPLICATED_EMAIL'"; //else $sql = "SELECT * FROM `cc_translations` WHERE caption='DUPLICATED_REGISTRATION'";
       // get warning message from db
       $db->setQuery($sql);
    	 $res = $db->loadResult();
		   echo 'error='.urlencode($res->name);
	   }
	 } else {
     // get warning message from db
     $db->setQuery("SELECT * FROM `cc_translations` WHERE caption='REGFORM_PROBLEM'");
     $res = $db->loadResult();
		 echo 'error='.urlencode($res->name);
	 }

?>

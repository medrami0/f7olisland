<?php
	include_once("includes/db.php");
	include_once("settings.php");
    $db = new database();

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
	 
   // get language suffix 
 	 if ($lang_id != 0) {
     $db->setQuery("SELECT * FROM `cc_extra_langs` WHERE id='{$lang_id}'");
     $res = $db->loadResult();
     $lang = "_".$res->lang;
   } else $lang = "";

   $reg_ok = true;

   $db->setQuery("SELECT one_email_per_registration FROM `cc_def_settings`");
   $res = $db->loadResult();
   $one_registration_per_email = ($res->one_email_per_registration == 1);

   $email_check_ok = true;
   if ($one_registration_per_email == true) {
     $sql = "SELECT COUNT(*) AS counter FROM `cc_user` WHERE email='{$email}'"; // for several registrations per one email address -- no check  
	   $db->setQuery($sql);
	   $res1 = $db->loadResult();
	   $email_check_ok = $res1->counter == "0";
	 }
   if ($email_check_ok == false) { 
     $sql = "SELECT * FROM `cc_translations` WHERE caption='DUPLICATED_EMAIL'"; 
     $db->setQuery($sql);
  	 $res = $db->loadResult();
	   echo 'error='.urlencode($res->name);
	   $reg_ok = false;
   }



	 if ($reg_ok) {
     // check for swear words     
  	 $db->setQuery("SELECT COUNT(*) as counter from `cc_swear_words` where INSTR('".$username."', `name`)");
  	 $res2 = $db->loadResult();
  	 if ((int)($res2->counter) > 0) { // swear word founded!
  	   $sql = "SELECT * FROM `cc_translations` WHERE caption='USERNAME_NOT_PERMITTED'";
       $db->setQuery($sql);
       $res = $db->loadResult();
       echo 'error='.urlencode($res->name);
       $reg_ok = false;
  	 }
   } 
	 
	 if ($reg_ok) {
     // first check there is no username with this name already registered.
  	 $db->setQuery("SELECT COUNT(*) AS counter FROM `cc_user` WHERE username='".$username."'");
  	 $res = $db->loadResult();
  	 if ((int)($res->counter) > 0 || strlen($username) <= 2) { // swear word founded!
       // get warning message from db
       $db->setQuery("SELECT * FROM `cc_translations` WHERE caption='USERNAME_IN_USE'");
       $res = $db->loadResult();
  	   echo 'error='.urlencode($res->name);
  	   $reg_ok = false;
	   }
   }
	 
   if ($reg_ok) echo 'result=true';	
   
?>
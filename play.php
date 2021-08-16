<?php

	include_once("includes/db.php");
	include_once("settings.php");
	$db = new database($obj->get("db_name"), $obj->get("db_server"), $obj->get("db_user"), $obj->get("db_password"), $obj->get("url_root"));


  $key = isset($_GET['key']) ? $_GET['key'] : ""; // moderator key
  
  $lang = isset($_GET['lang']) ? "_".$_GET['lang'] : "";
  $lang = ($lang=="_ar") ? "_ae" : $lang;  
  $cur_lang = ($lang == "") ? $lang : substr($lang, 1);
  $cur_lang = ($cur_lang=="ar") ? "ae" : $cur_lang;
  if ($cur_lang == "en") $cur_lang = "";
  
  include_once("get_translations.php");
  

  $lang = (isset($_GET['lang']) && $_GET['lang'] != "") ? "_".$_GET['lang'] : "";

  $obj->checkMyIpBanned(getIP(), $lang);

  // get all the available languages
  $sql = "SELECT * FROM {$tbl_prefix}def_lang LIMIT 0,1";
  $query = $obj->runSQL($sql);
  $row = mysql_fetch_object($query);
  $langs = array();
  array_push($langs, $row->lang);    
  $lang_ids = array(0);
  $sql = "SELECT * FROM {$tbl_prefix}extra_langs ORDER BY `lang`";
  $query = $obj->runSQL($sql);
  while ($row = mysql_fetch_object($query)) {
    array_push($langs, $row->lang);
    array_push($lang_ids, $row->id);
  }
  $lang1 = ($lang == "") ? "gb" : substr($lang, 1);
  $lang_id = array_search($lang1, $langs);

	// --------------------------------------------------------------------
	// get site offline message
	// --------------------------------------------------------------------
	$sql = "SELECT * FROM {$tbl_prefix}page WHERE id=126";
  	$query = $obj->runSQL($sql);
  	$row = mysql_fetch_object($query);
  	$msg_site_offline = htmlspecialchars_decode( $row->{"content".$lang} );
	
  // --------------------------------------------------------------------
  // get customer_id from def_settings
  // --------------------------------------------------------------------
  $sql = "SELECT customer_id, play_page_menu_items FROM {$tbl_prefix}def_settings";
  $query = $obj->runSQL($sql);
  $row = mysql_fetch_object($query);
  $customer_id = $row->customer_id;
  $play_page_menu_items = $row->play_page_menu_items; // get active menu items for the play page

  //$lang = isset($_GET["lang"]) ? $_GET["lang"] : "";
  
  $template_path = $obj->getTemplatePath();
  $template_path = ($template_path != '') ? 'templates/'.$template_path : 'templates/'.'client_'.$customer_id;

  define('SMARTY_DIR','php/includes/smarty/');
  require(SMARTY_DIR.'Smarty.class.php');
  $smarty = new Smarty (); // create Smarty object 
  $smarty->template_dir = ($cur_lang == "") ? $template_path.'/default' : $template_path.'/'.$cur_lang;
  if ($cur_lang != "" && !file_exists($smarty->template_dir)) { // if folder with current language for not def client is not found
    $smarty->template_dir = 'templates/client_'.$customer_id.'/default'; // use def language for not def client 
    if (!file_exists($smarty->template_dir)) { // if and this folder doesn't exists 
      $smarty->template_dir = 'templates/client_0/default'; // use def language for def client
    }  
  }
  
  $smarty->compile_dir = 'php/includes/smarty/tpl/templates_c/';
  $smarty->config_dir = 'tpl/configs/';
  $smarty->cache_dir = 'tpl/cache/';

  $smarty->clear_compiled_tpl();

  $smarty->assign('template_root', $obj->url_root."/".$smarty->template_dir);
  
  
  $data['footer_menu'] = array();
  $footer_menu = explode(",", $play_page_menu_items);
  if (count($footer_menu[0] == 1) && ($footer_menu[0] == "")) $footer_menu = null;   

  $obj->show_footer_menu(0, $lang, $footer_menu);

  $customer_id = $obj->getTableValue('customer_id', 'def_settings', 'id=1');
  if ($customer_id == 1) {
    $ar["li_class"] = "";
    $ar["a_selected"] = "";
    $ar["href"] = "http://mbc3forum.mbc.net/forumdisplay.php?f=41";
    $ar["title"] = ($cur_lang == "") ? "Forum" : "المنتدى"; 
    array_push($data["footer_menu"], $ar); 
  }

  if ($customer_id == 3) {
    $user = isset($_REQUEST['user']) ? $_REQUEST['user'] : '';
    $auth = isset($_REQUEST['auth']) ? $_REQUEST['auth'] : '';
    $lang = isset($_REQUEST['lang']) ? $_REQUEST['lang'] : '';
	$landline = isset($_REQUEST['ll']) ? $_REQUEST['ll'] : '';
	$prepaidID = isset($_REQUEST['pp']) ? $_REQUEST['pp'] : '';
	//$mobile = isset($_REQUEST['pp']) ? $_REQUEST['pp'] : '';
    
    if ($user != '' && $auth != '') {
    
	$lang_id = ($lang=='en') ? 0 : $lang_id;  
	$lang_id = ($lang=='ar') ? 1 : $lang_id;

	// extra params especially for this clientn
	$uid = $user;
	$uip = $auth;
	$smarty->assign('uid', $uid);
	$smarty->assign('uip', $uip);
	  
	// hard coded username & password
	$m3com_username = 'cocolani_test';
	$m3com_password = 'cocolani123';
	
	$swf_data = $user.'/'.$auth;
	
	$ch = curl_init($STC_Cocolani_UserAPI . $swf_data);
	curl_setopt ($ch, CURLOPT_POST, 1);
	curl_setopt ($ch, CURLOPT_POSTFIELDS, "username=$m3com_username&password=$m3com_password&lang=$lang");
	curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
	$str = curl_exec ($ch);
	curl_close ($ch);
	
	$decoded = json_decode($str);
	$sex = strtoupper($decoded->gender);
	
	// check user name    
	$query = $obj->runSQL("SELECT COUNT(*) AS usercount, password, mobile, fid FROM `cc_user` WHERE username='$decoded->username'");
	$res = mysql_fetch_object($query);
	
	if ($res->usercount == 0) {	
		$insertUserSQL = "INSERT INTO `cc_user` (`username`, `password`, `first_name`, `last_name`, `email`, `sex`, `birth_date`, `status_ID`, `lang_id`, `tribe_id`, `register_date`, `landline`, `fid`)
								VALUES('".$decoded->username."', '".$decoded->password."', '', '', '".$decoded->email."', '". $sex."', '".$decoded->birthdate."', '3', '1', '0', NOW(), '".$landline."', '".$prepaidID."')";
		$obj->runSQL($insertUserSQL);
			echo '<!--User account succesfully created-->';
	} else {
		if ($res->password != $auth || $res->mobile != $landline || $res->fid != $prepaidID) {
			echo ' <script type="text/javascript">alert("Password has been updated.");</script>';
			$updquery = "UPDATE `cc_user` SET password='".$auth."', landline='".$landline."', fid='".$fid."' WHERE username='$decoded->username'";
			$res = $obj->runSQL($updquery);
		} else {
			/* $TEST = 'select reg_url from cc_def_settings where id=1';
			$answer = $obj->runSQL($TEST);
			$row = mysql_fetch_object($answer); */
		}
    }
	if($decoded->username=='') {
		echo 'FATAL: IMPROPER RESPONSE FROM JSON QUERY!!!';
		exit;
	}
	}
  } // STC client
  // ---------------------------------------------------------------------------
  
  
    
  $smarty->assign('footer_menu', $data['footer_menu']);


  // Here you can get whether it's available 1 or more connections //----- echo $obj->connLimit; 
  // -----------------------
  $sql = "SELECT * FROM {$tbl_prefix}def_settings LIMIT 0,1";
  $query = $obj->runSQL($sql);
  $row = mysql_fetch_object($query);
  $moderator_key = $row->moderator_key;
  
  $flash_root = $row->base_url;
  $smarty->assign('flash_root', $flash_root);  
  
  $port = $row->smartfox_port;
  $smarty->assign('port', $port);
  
  $customer_id = $row->customer_id;
  $smarty->assign('customer_id', $customer_id);
  
  $ip = ($row->smartfox_ip != '') ? "&ip={$row->smartfox_ip}" : '';
  $smarty->assign('ip', $ip);
  
  $reg_url = $row->reg_url;
  $smarty->assign('reg_url', $reg_url);  
  
  $rand_code = "?id=".rand(10000,99999);
  $smarty->assign('rand_code', $rand_code);
  
  $swf_url = $row->swf_url;
  $smarty->assign('swf_url', $swf_url);
  
  $play_page_offline = $row->site_offline;
  $play_page_offline = ($key == $moderator_key && $play_page_offline == 'y') ? 'n' : $play_page_offline;
  $smarty->assign('play_page_offline', $play_page_offline);
  
  $redirect_to_offline_play_page = $row->redirect_to_offline_play_page;
  $redirect_to_offline_play_page = ($key == $moderator_key && $redirect_to_offline_play_page == 1) ? 0 : $redirect_to_offline_play_page;
  $smarty->assign('redirect_to_offline_play_page', $redirect_to_offline_play_page);
    
  //if ($key != $moderator_key) $obj->checkLive();
  if ($key != "") $obj->connLimit = 0;
  $smarty->assign('connLimit', $obj->connLimit);
  $smarty->assign('lang_id', $lang_id);
  
  $zoning_required = $row->zoning_required;
  $smarty->assign('zoning_required', $zoning_required);
  

  $smarty->assign('url_root', $obj->url_root);  


	// if redirect to offline play page defined
	if ($redirect_to_offline_play_page == 1) {
		// define what the message to show		 
		$smarty->assign('msg_site_offline', $msg_site_offline);  
	}

	$smartyFile = ($redirect_to_offline_play_page == 1) ? "play_offline.tpl" : "play.tpl"; 
  	$smarty->display($smartyFile);
	
?>
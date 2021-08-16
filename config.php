<?php

	include_once("includes/db.php");
	include_once("settings.php");
  
  $tbl_prefix = 'cc_';

  include_once "main_class.inc";
    $db = new database();
  
  /* Check for SQL injection */
  foreach($_REQUEST as &$value) {
	if(stristr($value, 'union all') || stristr($value, 'select ') || stristr ($value, 'information_schema') || stristr ($value, 'cc_user')) {
		$obj->checkMyIpBanned(getIP(), '');
		$banUser = $obj->runSQL("INSERT into cc_bans (`ip`, `reason`, `until`) VALUES ('".getIP()."', 'HACKED WEBSITE WITH INFO SCHEMA REQUEST', date_add(now(),INTERVAL (SELECT ban_period_days FROM `cc_def_settings` WHERE id=1) DAY));");
		exit;
	}
  }
  
  /*
   * SQL injection protection just for request
   */
  
  
  $user_photo_dir = "userimages";
  $user_photo_path = "userimages/";
  
  $photoDir = "ilust";
  $thumbs = "thumbs/";
  
  $bg = array("#F8F8F8", "#F0F0F0");
  $bg_class = array("row_1", "row_2");


/**
 * show the message of the process 
 */

function show_message($status, $text) {
  global $message_showed;
  if ($status == 0) {
    echo "<h3 id=\"message\" class=\"false\">$text</h3>";
  } else {
    echo "<h3 id=\"message\" class=\"true\">$text</h3>";
  }
  $message_showed = true;
}



  function showCaptionOrderable($url, $caption, $order_field_name, $prefix = '') {

    global $cur_order_name, $cur_orderby;
    
    $_orderby = 'desc'; 
    if ($cur_order_name == $order_field_name) {
      if ($cur_orderby == 'asc') $_orderby = 'desc'; else $_orderby = 'asc'; 
    }
    
    if ($cur_order_name == $order_field_name) {
      echo "<img src=\"images/sort_{$_orderby}.png\" alt=\"order by this field\" style=\"position: relative; top: 2px;\" />&nbsp;";
    }
    
    echo "<a href=\"{$url}&amp;{$prefix}order={$order_field_name}&amp;{$prefix}orderby={$_orderby}#main-in\">{$caption}</a>";
  }



?>
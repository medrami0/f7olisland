<?php

	include_once("includes/db.php");
	include_once("settings.php");
	
    $db = new database();
	 
	 // first check there is no username with this name already registered.
	 $db->setQuery("SELECT username, session_start, session_end, IP FROM `cc_sessions` ORDER BY `id` DESC LIMIT 0 , 20");
	 $res = $db->loadResults();

	for ($i = 0; $i < count($res); $i++) {
		echo '<tr><td>' . $res[$i]->username . '</td><td>' . $res[$i]->session_start . '</td><td>' . $res[$i]->session_end . '</td><td>' . $res[$i]->IP . '</td></tr>';
	 }

?>

<data>
	<acct>
<?php

	include_once("includes/db.php");
	include_once("settings.php");

    $db = new database();

	//$mylang = $_POST["lang"];
	if ($_REQUEST["FID"]) {
		$fid = mysql_real_escape_string($_REQUEST["FID"]);
		$pass = mysql_real_escape_string($_REQUEST["pass"]);
	}

	if($_REQUEST["usr"]) {
		$username = mysql_real_escape_string($_REQUEST["usr"]);
		$pass = mysql_real_escape_string($_REQUEST["pass"]);
	} else {
		//return;
	}

	if ($fid) {
		$db->setQuery("SELECT cc_user.username, cc_user_parent.password, cc_user.mask_colors, cc_user.mask, cc_user.sex, cc_user.tribe_ID from cc_user_parent LEFT JOIN cc_user ON cc_user_parent.fid = cc_user.fid WHERE cc_user_parent.fid = '".$fid."' LIMIT 12");
	} else {
		$db->setQuery("SELECT cc_user.username, cc_user_parent.password, cc_user.mask_colors, cc_user.mask, cc_user.sex, cc_user.tribe_ID from cc_user_parent LEFT JOIN cc_user ON cc_user_parent.email = cc_user.email WHERE cc_user_parent.username = '".$username."' LIMIT 12");
	}
	 $res = $db->loadResults();
	 if (count($res) > 0) {
		if (md5($res[0]->password."switch%") == $pass) {
			if( ! is_null($res[0]->username) ) { 
				for ($i = 0; $i < count($res); $i++) {
					?>
					<usr>
						<nm><?php echo $res[$i]->username;?></nm>
						<cl><?php echo $res[$i]->mask_colors;?></cl>
						<ms><?php echo $res[$i]->mask;?></ms>
						<s><?php echo $res[$i]->sex;?></s>
						<tb><?php echo $res[$i]->tribe_ID;?></tb>
					</usr>
					<?php
				}
			}
		 } else {
			// invalid username and password.
			?><err></err><?php
		 }
	} else {
		// no account registered
		?><err></err><?php
	}
?>
	</acct>
</data>

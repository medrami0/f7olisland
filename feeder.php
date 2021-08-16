<data>
	<zonelist>
<?php

	include_once("includes/db.php");
	include_once("settings.php");

	//echo $obj->get("db_name");
    $db = new database();

	//$mylang = $_POST["lang"];
	//$mylang = mysqli_real_escape_string($_POST["lang"]);

	 //$db->setQuery("SELECT a.zone_name, a.friendly_name, a.port, a.activity_ratio, a.safe_chat, b.id AS server_id, b.ip FROM `cc_zones` a LEFT JOIN `cc_servers` b ON a.server_id = b.id WHERE a.lang_id='".$mylang."' AND a.enabled='1' AND a.logins_active='1'");
	 $db->setQuery("SELECT a.zone_name, a.friendly_name, a.port, a.activity_ratio, a.safe_chat, b.id AS server_id, b.ip FROM `cc_zones` a LEFT JOIN `cc_servers` b ON a.server_id = b.id WHERE a.lang_id='0' AND a.enabled='1' AND a.logins_active='1' ORDER BY a.id");
	 //echo '= ' . "SELECT a.zone_name, a.friendly_name, a.port, a.activity_ratio, a.safe_chat, b.id AS server_id, b.ip FROM `cc_zones` a LEFT JOIN `cc_servers` b ON a.server_id = b.id WHERE a.lang_id='".$mylang."' AND a.enabled='1' AND a.logins_active='1'";
	 $res = $db->loadResults();
	for ($i = 0; $i < count($res); $i++) {
		?>
		<zone name="<?php echo $res[$i]->zone_name;?>">
			<fr><?php echo $res[$i]->friendly_name;?></fr>
			<pt><?php echo $res[$i]->port;?></pt>
			<rt><?php echo $res[$i]->activity_ratio;?></rt>
			<sf><?php echo $res[$i]->safe_chat;?></sf><?php if($res[$i]->server_id>1) { 
			?>
			<ip><?php echo $res[$i]->ip;?></ip><?php }?>
			
		</zone>
		<?php
	}
?>
	</zonelist>
</data>

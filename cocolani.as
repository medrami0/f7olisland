var dbase

function init()
{
   trace("Cocolani server is starting now !")
   var zone = _server.getCurrentZone()
   zone.setPubMsgInternalEvent(true);
   zone.setPrivMsgInternalEvent(true)
	// banned Code ~~
   dbase = _server.getDatabaseManager()
	var sql2 = "SELECT * FROM cc_bans WHERE username != '' " 
			var queryRes2 = dbase.executeQuery(sql2)
			var data2 = []
			for (var i = 0; i < queryRes2.size(); i++)
				{
					var tempRow2 = queryRes2.get(i);
					_server.banOfflineUser(tempRow2.getItem("username"))
				}
	// ~~
}
function destroy()
{
   delete dbase
}
function handleRequest(cmd, params, user, fromRoom)
{
	trace("cmd received: " + cmd)
}

function handleInternalEvent(evt) 
{ 
	trace("Event received: " + evt.name)
	if (evt.name == "loginRequest")
	{
   var nick = evt["nick"] 
   var pass = evt["pass"] 
   var chan = evt["chan"]
   var zone = _server.getCurrentZone()
   
   var sql = "SELECT * FROM cc_user WHERE username='"+nick+"'" 
   var response = new Object() 
   var queryRes = dbase.executeQuery(sql)
   var isAccount = queryRes.size()
   if (isAccount == 0){ 
	  trace("Faild Account")
      response.err = "مافي الحساب ذا يمنيوك" 
      response._cmd = "logKO" 
	  _server.sendResponse(response, -1, null, chan)
   }else{
		var row = queryRes.get(0)
		var username = row.getItem("username")
		var pass2 = _server.md5(_server.getSecretKey(chan)+row.getItem("password"))
		if (nick == username && pass == pass2) {
			var obj = _server.loginUser(nick, pass, chan) 
			if (obj.success == false) { 
				response.err = obj.error 
			} else if (obj.success == true) { 
				var user = _server.getUserByChannel(chan); 
				var u = _server.instance.getUserByChannel(chan);
				var sql3 = "SELECT * FROM cc_user WHERE username='"+u.getName()+"'" 
				var queryRes3 = dbase.executeQuery(sql3)
				var row3 = queryRes3.get(0)
				var statusID = Number(row3.getItem("status_ID"));
				var statusID = Number(row3.getItem("status_ID"));
				if (statusID == 7 || statusID == 8) {
					user.setAsModerator(true)
				} 
				isMod = user.isModerator();
				id = user.getUserId();
				var msg = "<msg t='sys'><body action='logOK' r='0'>";
				msg+= "<login n='"+u.getName()+"' id='"+u.getUserId()+"' mod='"+u.isModerator()+"' />";
				msg+= "</body></msg>";
				setAccountValue(nick, "IP", user.getIpAddress())
				setAccountValue(nick, "lastZone", zone.getName())
				var date = new Date();
				setAccountValue(nick, "seisson_start", (date.getTime()) / 1000)
            _server.sendGenericMessage(msg, null, [u])
			
			response._cmd = "init" 
			response.name = nick; 
			response.id = id;
			response.mail = row3.getItem("mail");
			response.had = row3.getItem("homeAddr"); 
			response.hid = row3.getItem("home_ID"); 
			response.st = row3.getItem("status_ID"); 
			lastRoom = row3.getItem("lastRoom"); 
			response.prtb = row3.getItem("previousTribe"); 
			response.invars = row3.getItem("invars");
			response.inv = row3.getItem("inventory");			
			response.pvars = row3.getItem("pzl"); 
			response.lvl = row3.getItem("level");
			response.lang = row3.getItem("lang_id");
			response.dotutorial = row3.getItem("dotutorial");
			response.hp = row3.getItem("happyness");
			response.cr = row3.getItem("money");
			var skill = new Object()
			var skillValue = row3.getItem("skill")
			var skill2 = skillValue.split(",")
			skill[0] = skill2[0]
			skill[1] = skill2[1]
			response.skill = skill;
			response.maskc = row3.getItem("mask_colors");
			response.btl = row3.getItem("btl");
			response.motd = getDefSetting("MOTD");
			response.mbr = getDefSetting("usertypes");
			response.mask = row3.getItem("mask");
			response.sex = row3.getItem("sex");
			response.prefs = row3.getItem("prefs");
			response.jd = row3.getItem("register_date");
			response.mgam = row3.getItem("mgam");
			response.gam = row3.getItem("gam");
			response.abt = row3.getItem("about");
			response.medals = row3.getItem("medals");
			response.tb = row3.getItem("tribe_ID");
			var Qchief = "SELECT * FROM cc_tribes WHERE ID="+response.tb
			var checkisChief = dbase.executeQuery(Qchief)
			var row4 = checkisChief.get(0)
				if (Number(row4.getItem("chief_id")) == Number(row3.getItem("id")) ){
					response.chief = true;
				}else{
					response.chief = false;
				}
			if(Number(lastRoom) <= 1) {
				if(Number(response.tb) == 1) {
					response.prm = "4"
				}else{
					response.prm = "14"
				}
			}else{
				response.prm = lastRoom
			}
			clothes = row3.getItem("clothing");
			var tribes = []
			var sql2 = "SELECT * FROM cc_tribes" 
			var queryRes2 = dbase.executeQuery(sql2)
			for (var i = 0; i < queryRes2.size(); i++)
				{
					var tempRow2 = queryRes2.get(i);
					var tribeInfo = {}
					tribeInfo.id 	= tempRow2.getItem("ID")
					tribeInfo.name 	= tempRow2.getItem("name")
					tribeInfo.chief = tempRow2.getItem("chief_id")
					tribes.push(tribeInfo)
				}
		response.tribeData = tribes
		var variables = {}
		variables.$trb = String(row3.getItem("tribe_ID"));
		variables.$chr = String(row3.getItem("sex")+"!"+row3.getItem("mask")+"!"+row3.getItem("mask_colors"));
		_server.setBuddyVariables(u, variables)
		_server.sendResponse(response, -1, null, [u])
		}
	}else{
			trace("Incorrect username or password error...hmmm")
			response._cmd = "logKO"
			response.err = "#ERR1"
			_server.sendResponse(response, -1, null, chan)
		}
}

}else if (evt.name == "userJoin"){
			var r = evt["room"]
			var u = evt["user"]
			trace("User: " + u.getName() + " joined room: " + r.getName())
			if (r.getId() == 1) {
				var sql3 = "SELECT * FROM cc_user WHERE username='"+ u.getName() +"'" 
				var queryRes3 = dbase.executeQuery(sql3)
				var row3 = queryRes3.get(0)
				var uVars = {}
				uVars.chr = row3.getItem("sex")+"!"+row3.getItem("mask")+"!"+row3.getItem("mask_colors");
				uVars.usr = Number(row3.getItem("status_ID"));
				uVars.clth = String(row3.getItem("clothing"));
				uVars.hpy = String(row3.getItem("happyness"));
				uVars.trb = String(row3.getItem("tribe_ID"));
				uVars.cr = 1;
				var Qchief = "SELECT * FROM cc_tribes WHERE ID="+row3.getItem("tribe_ID")
				var checkisChief = dbase.executeQuery(Qchief)
				var row4 = checkisChief.get(0)
				if (Number(row4.getItem("chief_id")) == Number(row3.getItem("id")) ){
					uVars.chief = true;
				}
				_server.setUserVariables(u, uVars, true)
			}
}else if (evt.name == "userExit")
	{
		var user = evt.user
		var room = evt.room
		var myRoomVar = {}
		myRoomVar.cr = room.getId()
		_server.setUserVariables(user, myRoomVar, true)
		trace("User: " + user.getName() + " left room : " + room.getName() )
	}else if (evt.name == "logOut"){
	var u = evt.user
	var r = evt.roomIds
	var myRoom = r[0]
	setAccountValue(u.getName(), "lastRoom", myRoom)
	var date = new Date();
	setAccountValue(u.getName(), "seisson_end", (date.getTime()) / 1000)
	trace("Player : "+u.getName()+" has logged out.")
}else if (evt.name == "userLost"){
	var u = evt.user
	var r = evt.roomIds
	var myRoom = r[0]
	setAccountValue(u.getName(), "lastRoom", myRoom)
	var date = new Date();
	setAccountValue(u.getName(), "seisson_end", (date.getTime()) / 1000)
	trace("Player : "+u.getName()+" has timeout.")
	}else if (evt.name == "pubMsg"){
		sourceRoom = evt.room		// the room object
		senderUser = evt.user		// the sender user
		message = evt.msg			// the public message
		// check swears
		var swear = checkSwears(message)
		if(swear){
			_server.kickUser(senderUser, 3, "ممنوع السب والشتم ، لقد تم طردك ، إذا حاولت السب مرة أخرى سيتم حظرك.")
			setAccountValue(senderUser.getName(), "swear", "true")
			setAccountValue(senderUser.getName(), "lastSwear", swear)
		}else{
			_server.dispatchPublicMessage(message, sourceRoom, senderUser)
		}
	}else if (evt.name == "privMsg"){
		sourceRoom = evt.room		// the room object
		sender = evt.sender		// the sender 
		recipient = evt.recipient		// the recipient
		message = evt.msg			// the public message
		var swear = checkSwears(message)
		if(swear){
			_server.kickUser(sender, 3, "ممنوع السب والشتم ، لقد تم طردك ، إذا حاولت السب مرة أخرى سيتم حظرك.")
			setAccountValue(sender.getName(), "swear", "true")
			setAccountValue(sender.getName(), "lastSwear", swear)
		}else{
		_server.dispatchPrivateMessage(message, sourceRoom, sender, recipient)
		}
	}
	else if (evt.name == "newRoom"){

}
}
//-------------------------------------------------------------------------------------
//Useful functions by MrAhmed
function getPlayerVar(user, varName)
{
	var varObj = user.getVariable(varName)
	return varObj.getValue()
}
function getRoomVar(room, varName)
{
	var varObj = room.getVariable(varName)
	return varObj.getValue()
}
function getAccountValue(userNorID, value)
{
	if(Number(userNorID)){
		var sql = "SELECT * FROM cc_user WHERE id="+ userNorID
	}else{
		var sql = "SELECT * FROM cc_user WHERE username='"+ userNorID +"'" 
	}
	var queryRes = dbase.executeQuery(sql)
	var row = queryRes.get(0)
	return row.getItem(value)
}
function setAccountValue(userNorID, colName, value)
{
	if(Number(userNorID)){
		var sql = "UPDATE cc_user SET " + colName + " = '"+ value +"' WHERE id = "+ userNorID +""
	}else{
		var sql = "UPDATE cc_user SET " + colName + " = '"+ value +"' WHERE username = '"+ userNorID +"'"
	}
	var success = dbase.executeCommand(sql)
	return success
}
function getPlayersInRoom(user, room)
{
var allUsersInRoom = room.getAllUsers()
		var sUsers = []
		for (var u in allUsersInRoom)
		{
			if (allUsersInRoom[u].getName() != user.getName()){
				sUsers.push(allUsersInRoom[u])
			}
		}
return sUsers;
}
function getAllPlayersInZone(zone)
{
		var sUsers = []
		var rooms = zone.getRooms()
		for (var r in rooms)
		{
			var allUsersInRoom = rooms[r].getAllUsers()
			for (var u in allUsersInRoom)
			{
				sUsers.push(allUsersInRoom[u])
			}
		}
		return sUsers;
}
function getChiefName(tribeID)
{
	var Qchief = "SELECT * FROM cc_tribes WHERE ID= " + tribeID
	var getChiefQuery = dbase.executeQuery(Qchief)
	var row4 = getChiefQuery.get(0)
	var sql3 = "SELECT * FROM cc_user WHERE id="+ row4.getItem("chief_id")
	var queryRes3 = dbase.executeQuery(sql3)
	var row3 = queryRes3.get(0)
	return row3.getItem("username");
}
function getDefSetting(value)
{
	var query1 = "SELECT * FROM cc_def_settings WHERE id=1" 
	var queryRes3 = dbase.executeQuery(query1)
	var rowDefs = queryRes3.get(0)
	return rowDefs.getItem(value)
}
function checkSwears(txt)
{
	var sql = "SELECT * FROM cc_swear_words" 
	var queryRes = dbase.executeQuery(sql)
	for (var i = 0; i < queryRes.size(); i++)
		{
			var tempRow = queryRes.get(i);
			if(txt.indexOf(tempRow.getItem("name")) >= 0)
			{
				return tempRow.getItem("name");
			}
		}
	return false;
}
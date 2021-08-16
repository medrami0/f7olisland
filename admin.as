/* 
* Initializion point:
* 
* this function is called as soon as the extension
* is loaded in the server.
* 
* You can add here all the initialization code
* 
*/
var dbase

function init()
{
   // get a reference to the database manager object
   // This will let you interact the database configure for this zone
   dbase = _server.getDatabaseManager()

}


/*
* This method is called by the server when an extension
* is being removed / destroyed.
* 
* Always make sure to release resources like setInterval(s)
* open files etc in this method.
* 
* In this case we delete the reference to the databaseManager
*/
function destroy()
{
   // Release the reference to the dbase manager
   delete dbase
}
function handleRequest(cmd, params, user, fromRoom)
{
	trace("cmd received: " + cmd)
	var currentZone = _server.getCurrentZone()
	var r = currentZone.getRoom(fromRoom)
	var seperator = String.fromCharCode(1)
	var seperator2 = String.fromCharCode(2)
	if(!user.isModerator() && cmd != "modChat"){
		_server.banUser(user, 1, "أنت تحاول إستخدام شيء ليس من صلاحياتك ، لقد تم حظرك !", _server.BAN_BY_NAME)
		setAccountValue(user.getName(), "hacks", "True")
	}else{
		if(cmd == "brdcast"){
			var response = new Object()
			response._cmd = "error"
			response.err = params.msg
			var usersList = getAllPlayersInZone(currentZone)
			_server.sendResponse(response, -1, null, usersList)
		}else if(cmd == "searchUsers"){
			var response = new Object()
			response._cmd = "adminFn"
			response.sub = "userList"
			var username = params.nm
			var userTarget = getUserByName(username)
			var usersArray = []
			if(userTarget){
				var targetRoom = userTarget.getRoomsConnected()
				targetRoom1 = targetRoom[0]
				usersArray[0] = getAccountValue(username, "username") + seperator + String(targetRoom1) + seperator + String(userTarget.getIpAddress()) + seperator +String(getAccountValue(username, "status_ID")) + seperator + String(getAccountValue(username, "hacks")) + seperator + String(getAccountValue(username, "about")) + seperator + String(getAccountValue(username, "register_date")) + seperator + String(userTarget.getUserId()) + seperator + String(getAccountValue(username, "lastSwear")) + seperator + String(getAccountValue(username, "swear"))
			}else if (username == "*"){
			var rooms = currentZone.getRooms()
			for (var r in rooms)
			{
				var allUsersInRoom = rooms[r].getAllUsers()
				for (var u in allUsersInRoom)
				{
					var userN = allUsersInRoom[u].getName()
					if(userN != username){
						var targetRoom2 = allUsersInRoom[u].getRoomsConnected()
						targetRoom3 = targetRoom2[0]
						usersArray.push(getAccountValue(userN, "username") + seperator + String(targetRoom3) + seperator + String(allUsersInRoom[u].getIpAddress()) + seperator +String(getAccountValue(userN, "status_ID")) + seperator + String(getAccountValue(userN, "hacks")) + seperator + String(getAccountValue(userN, "about")) + seperator + String(getAccountValue(userN, "register_date")) + seperator + String(allUsersInRoom[u].getUserId()) + seperator + String(getAccountValue(userN, "lastSwear")) + seperator + String(getAccountValue(userN, "swear")) )
					}
				}
			}
			}
			 response.users = usersArray
			_server.sendResponse(response, -1, null, [user])
		}else if(cmd == "quickIPBan"){
			var response = new Object()
			var IP = params.tgt
			var reason = params.exp
			response._cmd = "error"
			response.err = "لقد تم حظر الأيبي : " + IP + " بسبب : " + reason
			var sql = "INSERT INTO cc_bans (ip, reason) VALUES ( '"+ IP +"', '"+ reason +"')"
			var success = dbase.executeCommand(sql)
			if(success){
				_server.sendResponse(response, -1, null, [user])
			}
		}else if(cmd == "msg"){
			var response = new Object()
			response._cmd = "error"
			response.err = params.exp
			var targetUser = _server.getUserById(Number(params.id))
			_server.sendResponse(response, -1, null, [targetUser])
		}else if(cmd == "modChat"){
			var response = new Object()
			response._cmd = "mod_response"
			var target1 = params.tgt
			var tgt = new Object()
			tgt.nm = user.getName()
			tgt.id = user.getUserId()
			response.txt = params.txt
			response.tgt = tgt
			var targetUser = getUserByName(target1.nm)
			_server.sendResponse(response, -1, null, [targetUser])
		}else if(cmd == "ban"){
			var targetPlayer = _server.getUserById(Number(params.id))
			var response = new Object()
			response._cmd = "adminFn"
			response.sub = "adminMsg"
			response.type = "banned"
			var data1 = []
			data1.tgt = targetPlayer.getName()
			data1.ref = user.getName()
			data1.reason = params.exp
			response.data = data1
			_server.banUser(targetPlayer, 3, params.exp, _server.BAN_BY_NAME)
			var sql = "INSERT INTO cc_bans (username, ip, reason) VALUES ( '"+ targetPlayer.getName() +"', '"+ targetPlayer.getIpAddress() +"', '"+ params.exp +"')"
			var success = dbase.executeCommand(sql)
			_server.sendResponse(response, -1, null, [user])
		}else if(cmd == "banIP"){
			var targetPlayer = _server.getUserById(Number(params.id))
			var response = new Object()
			response._cmd = "adminFn"
			response.sub = "adminMsg"
			response.type = "banIP"
			var data1 = []
			data1.tgt = targetPlayer.getName()
			data1.ip = targetPlayer.getIpAddress()
			data1.ref = user.getName()
			data1.reason = params.exp
			response.data = data1
			_server.banUser(targetPlayer, 3, params.exp, _server.BAN_BY_IP)
			var sql = "INSERT INTO cc_bans (ip, reason) VALUES ( '"+ targetPlayer.getIpAddress() +"', '"+ params.exp +"')"
			var success = dbase.executeCommand(sql)
			if(success){
				_server.sendResponse(response, -1, null, [user])
			}
		}else if(cmd == "kick"){
			var targetPlayer = _server.getUserById(Number(params.id))
			var response = new Object()
			response._cmd = "adminFn"
			response.sub = "adminMsg"
			response.type = "kick"
			var data1 = []
			data1.tgt = targetPlayer.getName()
			data1.ref = user.getName()
			data1.reason = params.exp
			response.data = data1
			_server.kickUser(targetPlayer, 3, params.exp)
			_server.sendResponse(response, -1, null, [user])
		}else if(cmd == "ipsearchfield"){
			var response = new Object()
			response._cmd = "adminFn"
			response.sub = "userListIP"
			var sql2 = "SELECT * FROM cc_user WHERE IP = '"+ params.tgt + "' " 
			var queryRes2 = dbase.executeQuery(sql2)
			var data2 = []
			for (var i = 0; i < queryRes2.size(); i++)
				{
					var tempRow2 = queryRes2.get(i);
					var playerData = {}
					playerData.ss 	= tempRow2.getItem("seisson_start")
					playerData.se 	= tempRow2.getItem("seisson_end")
					playerData.zn = tempRow2.getItem("lastZone")
					playerData.nm = tempRow2.getItem("username")
					playerData.ip = tempRow2.getItem("IP")
					data2.push(playerData)
				}
		response.data = data2
		_server.sendResponse(response, -1, null, [user])
		}else if(cmd == "getbanlist"){
			var response = new Object()
			response._cmd = "adminFn"
			response.sub = "banList"
			var sql2 = "SELECT * FROM cc_bans WHERE username != '' " 
			var queryRes2 = dbase.executeQuery(sql2)
			var bannedUsersByName = ""
			for (var i = 0; i < queryRes2.size(); i++)
				{
					var tempRow2 = queryRes2.get(i);
					if(i != 0) {
						bannedUsersByName = seperator
					}
					bannedUsersByName = bannedUsersByName + tempRow2.getItem("username")
				}
			response.data = bannedUsersByName
			var sql3 = "SELECT * FROM cc_bans WHERE ip != '' AND username = '' " 
			var queryRes3 = dbase.executeQuery(sql3)
			var bannedByIP = ""
			for (var i = 0; i < queryRes3.size(); i++)
				{
					var tempRow3 = queryRes3.get(i);
					if(i != 0) {
						bannedByIP = seperator
					}
					bannedByIP = bannedByIP + tempRow3.getItem("ip")
				}
			response.ipban = bannedByIP
			_server.sendResponse(response, -1, null, [user])
		}else if(cmd == "getModHistory"){
			var response = new Object()
			response._cmd = "adminFn"
			response.sub = "modHistory"
			var banType = params.type
			if(banType == "usr"){
				var sql3 = "SELECT * FROM cc_bans WHERE username = '" + params.tgt + "' " 
			}else{
				var sql3 = "SELECT * FROM cc_bans WHERE ip = '" + params.tgt + "' " 
			}
			var queryRes3 = dbase.executeQuery(sql3)
			server.sendResponse(response, -1, null, [user])
		}else if(cmd == "unban"){
			var response = new Object()
			response._cmd = "adminFn"
			response.sub = "adminMsg"
			response.type = "unban"
			var banType = params.type
			if(banType == "usr"){
				var sql3 = "DELETE FROM cc_bans WHERE username = '" + params.tgt + "' " 
				_server.removeBanishment(params.tgt, _server.BAN_BY_NAME)
			}else{
				var sql3 = "DELETE FROM cc_bans WHERE ip = '" + params.tgt + "' " 
				_server.removeBanishment(params.tgt, _server.BAN_BY_IP)
			}
			var queryRes3 = dbase.executeCommand(sql3)
			var data2 = new Object
			data2.tgt = params.tgt
			data2.ref = user.getName()
			data2.reason = params.reason
			response.data = data2
			_server.sendResponse(response, -1, null, [user])
		}
		else if(cmd == "getChatHistory" || cmd == "getSwearHistory")
		{
          if (cmd == "getChatHistory")
		  { 
			  var sub = "chatHistory" 
			  var SQL_Get_Chat = "SELECT * FROM cc_chat WHERE Swear='False'"
		  }
		  else if (cmd == "getSwearHistory")
		  {
			  var sub = "swearHistory"
			  var SQL_Get_Chat = "SELECT * FROM cc_chat WHERE Swear='True'"
		  }

		  var Response_Get_Chat = dbase.executeQuery(SQL_Get_Chat)
          if (Response_Get_Chat != "[]") {
	      var response = {}
	      response._cmd = "adminFn"
	      response.sub = sub
	      response.data = []	
          for (var i = 0; i < Response_Get_Chat.size(); i++) {
   	      var Row_Get_Chat  = Response_Get_Chat.get(i)
	      var item = {}
	      item1 = Row_Get_Chat.getItem("Sender")
          item2 = Row_Get_Chat.getItem("Room_ID")
	      item3 = Row_Get_Chat.getItem("Time")
	      item4 = Row_Get_Chat.getItem("Message")
	      item = item1+""+item2+""+item3+""+item4
	      response.data.push( item ) 
	      _server.sendResponse(response, -1, null, [user]) } }

		}
	}
}

function handleInternalEvent(evt) 
{ 

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
function getUserByName(name)
{
		var zone = _server.getCurrentZone()
		var rooms = zone.getRooms()
		for (var r in rooms)
		{
			var allUsersInRoom = rooms[r].getAllUsers()
			for (var u in allUsersInRoom)
			{
				var username = allUsersInRoom[u].getName()
				if(username == name){
					return allUsersInRoom[u];
				}
			}
		}
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
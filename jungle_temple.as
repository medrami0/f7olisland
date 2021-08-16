var dbase

function init()
{
   dbase = _server.getDatabaseManager()
}
function destroy()
{
   delete dbase
}
function handleRequest(cmd, params, user, fromRoom)
{
	trace("cmd received: " + cmd)
	var currentZone = _server.getCurrentZone()
	var r = currentZone.getRoom(fromRoom)
	var test = r.getName()

	if(cmd == "door"){
        var rVars = []
		rVars.push( {name:"door", val:1, priv:true, persistent:false} )

      _server.setRoomVariables(r, user, rVars)
	  var params = {}
      params.user = user
      params.r = r
	  
	  
function delayedFunction(s,n,b)
{
   trace("I was called with the following arguments:")
   
   trace("String : " + s)
   trace("Number : " + n)
   trace("Boolean: " + b)
   
   var rVars = []
    rVars.push({
      name: "door",
      val: 0
    })
    _server.setRoomVariables(r, user, rVars)
   
}

setTimeout(this, delayedFunction, 7000, "Hello world!", 123456, true)
	  

	  

		
}
else if (cmd == "gem"){

		   var HaveBefor = getAccountValue(user.getName(), "pzl")
           var id = params.id
		   	var UserInv = getAccountValue(user.getName(), "inventory")
//--------------------------------------------
	 var ItemId = params.id
	 var id = getObjectValue(ItemId, "id")
	 var SwfID = getObjectValue(ItemId, "swfID")
	 var objectName = getObjectValue(ItemId, "name")
	 var description = getObjectValue(ItemId, "description")
	 var ObjectType = getObjectValue(ItemId, "type")
	 var Exchange = getObjectValue(ItemId, "exchange")
	 var kind = getObjectValue(ItemId, "kind")
	 var lvl = getObjectValue(ItemId, "lvl")
	 var price = getObjectValue(ItemId, "price")
//------------------------------------------------	
	 var Alone = id + "~" + ItemId + "~" + SwfID + "~" + description + "~" + objectName + "~" + ObjectType + "~" + Exchange + "~" + kind + "~" + lvl
	 var befor = "|" + id + "~" + ItemId + "~" + SwfID + "~" + description + "~" + objectName + "~" + ObjectType + "~" + Exchange + "~" + kind + "~" + lvl
	 var after = id + "~" + ItemId + "~" + SwfID + "~" + description + "~" + objectName + "~" + ObjectType + "~" + Exchange + "~" + kind + "~" + lvl + "|"

// عشان لما يحذف القطع يحذفها كويس
	 
	var HasAlone = UserInv.indexOf(Alone)
	var HasBefor = UserInv.indexOf(befor)
	var HasAfter = UserInv.indexOf(after)


	



//----------------------------------------------------------- 
 			if(HaveBefor == ''){		

var response = new Object()
response.sub = "puz"
response.pzlupd = "0"
response._cmd = "sceneRep"
 _server.sendResponse(response, -1, null, [user])
var response = new Object()
response.id = id
response._cmd = "dinv"
var NewV = Number(0)
 setAccountValue(user.getName(), "pzl", NewV)
 _server.sendResponse(response, -1, null, [user])
 
  			if (HasAlone != -1 && HasBefor == -1 && HasAfter == -1) {
			var res = UserInv.replace(Alone, "");
			setAccountValue(user.getName(), "inventory", res)
			
			}
			if (HasAlone != -1 && HasBefor != -1 && HasAfter == -1) {
			var res = UserInv.replace(befor, "");
			setAccountValue(user.getName(), "inventory", res)
			
			}
			if (HasAlone != -1 && HasBefor == -1 && HasAfter != -1) {
			var res = UserInv.replace(after, "");
			setAccountValue(user.getName(), "inventory", res)
			
			}
			if (HasAlone != -1 && HasBefor != -1 && HasAfter != -1) {
			var res = UserInv.replace(befor, "");
			setAccountValue(user.getName(), "inventory", res)
			
			}
 }
 
 
 else{
var response = new Object()
response.sub = "puz"
response.pzlupd = "0"
response._cmd = "sceneRep"
 _server.sendResponse(response, -1, null, [user])
var response = new Object()
response.id = id
response._cmd = "dinv"
var NewV = HaveBefor + "," + Number(0)
 setAccountValue(user.getName(), "pzl", NewV)
 _server.sendResponse(response, -1, null, [user])
 
  			if (HasAlone != -1 && HasBefor == -1 && HasAfter == -1) {
			var res = UserInv.replace(Alone, "");
			setAccountValue(user.getName(), "inventory", res)
			
			}
			if (HasAlone != -1 && HasBefor != -1 && HasAfter == -1) {
			var res = UserInv.replace(befor, "");
			setAccountValue(user.getName(), "inventory", res)
			
			}
			if (HasAlone != -1 && HasBefor == -1 && HasAfter != -1) {
			var res = UserInv.replace(after, "");
			setAccountValue(user.getName(), "inventory", res)
			
			}
			if (HasAlone != -1 && HasBefor != -1 && HasAfter != -1) {
			var res = UserInv.replace(befor, "");
			setAccountValue(user.getName(), "inventory", res)
			
			}
 
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
function putObject(username, value)
{
	var sql = "INSERT INTO cc_inv (username, objID, active) VALUES ( '"+ username +"', '"+ value +"', '1')"
	var success = dbase.executeCommand(sql)
	return success
}
function getObjectValue(userNorID, value)
{
		var sql = "SELECT * FROM cc_invlist WHERE objID="+ userNorID

	var queryRes = dbase.executeQuery(sql)
	var row = queryRes.get(0)
	return row.getItem(value)
}
function setTimeout(scope, fn, delay, params)
{
   var args = []
   for (var i = 3; i < arguments.length; i++)
      args.push(arguments[i])
      
   var timer = new Packages.java.util.Timer()
   var task = new Packages.java.util.TimerTask()
   {
      run:function()
      {
         fn.apply(scope, args)
      }
   }
   
   timer.schedule(task, delay)
}

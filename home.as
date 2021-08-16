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
	
        if(cmd == "getRentalInfo"){

		    var responseObj = []
            responseObj.prc="40"
            responseObj.sub="rentalData"
            responseObj._cmd="sceneRep"
			responseObj.home_crt= ""
			responseObj.day="30"
			responseObj.home_exp=""

			
			_server.sendResponse(responseObj, -1, null, [user])
		

}
        else if(cmd == "buyRent"){
		var checkHasHome = getAccountValue(user.getName(), "homeAddr")
		var checkStatus = getAccountValue(user.getName(), "status_ID")
		if(checkHasHome == -1){ 
		
		
        var response3 = new Object()
        response3._cmd = "purse"
		var NOM = params.amt
	    var playerInTribe = Number(getRoomVar(r,"tb"))
        var playerMoney = getAccountValue(user.getName(), "money")
        var moneyArray = playerMoney.split(",")
        if(playerInTribe == 1){
        moneyArray[0] = String(Number(moneyArray[0]) - (40 * Number(NOM)))
        }else if(playerInTribe == 2){
        moneyArray[1] = String(Number(moneyArray[1]) - (40 * Number(NOM)))
        }
		response3.cr = moneyArray[0] + "," + moneyArray[1]
		setAccountValue(user.getName(), "money", response3.cr)
        _server.sendResponse(response3, -1, null, [user])
		
		
		
//تاريخ انتهاء الإيجار
	         	var today = new Date();
                var dd = String(today.getDate())
                var mm = String(today.getMonth() + 1 + (Number(NOM))) //January is 0
                var yyyy = today.getFullYear();
				ExpDate = yyyy + '/' + mm + '/' + dd;


//----------------------------------------------------------------------------------------

// اللاعب id الحصول على
			var IDofPlayer = getAccountValue(user.getName(), "id")
// ---------------------------------------------------------------------------------------

// عدد أيام الإيجار

            var DOR = 30 * (Number(NOM))
// ----------------------------------------------------------------------------------------

// قبيلة اللاعب
			var TOP = getAccountValue(user.getName(), "tribe_ID")
// ----------------------------------------------------------------------------------------

//تاريخ بداية الإيجار
	         	var today = new Date();
                var dd = String(today.getDate())
                var mm = String(today.getMonth() + 1) //January is 0
                var yyyy = today.getFullYear();
				created = yyyy + '/' + mm + '/' + dd;

// -----------------------------------------------------------------------------------------



			setPlayerHome("user_id", IDofPlayer, "expiry_date", ExpDate, "tribe_ID", TOP, "home_rental_period_days", DOR, "created", created)
			
		    var responseObj = []
            responseObj.cr = response3.cr 
            responseObj.sub = "homePurchase"
		    responseObj._cmd = "sceneRep"
			
			
			responseObj.street ="1"
			responseObj.isnew ="1"
			responseObj.uLevel="4"
			var PutHome = addHomeID(IDofPlayer, "street_num")
			
		setAccountValue(user.getName(), "homeAddr", PutHome)
		if(checkStatus == 3){
		
		var NewStatus = Number(4)
		
		setAccountValue(user.getName(), "status_ID", NewStatus)

		
		
		}
			
			
			

			_server.sendResponse(responseObj, -1, null, [user])
			var uVars = {}

			uVars.usr = 4
			_server.setUserVariables(user, uVars, true)


}
}
        else if(cmd == "home"){

			// --- Room params -------------------------

            var roomObj = {}
            roomObj.name = "homeExterior_5_tb1"
            roomObj.maxU = 50
            roomObj.isTemp= "true"
            roomVars = [ 
            {name:"tribeID", val:"1"},
            {name:"tb",      val:"1"},
            {name:"addr",    val:"47"},
            {name:"data",    val:"2,45566,ROKMAN|2,460427,XAhmedRadiX|1,433383,0100000"}, ]
            New_Room = _server.createRoom(roomObj, null, true, true, roomVars)

            var New_Room_ID = New_Room.getId()

            // Joining The Created Room In Database.
            _server.joinRoom(user, -1, true, New_Room_ID)
        
	
		

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
function setUserHome(userNorID, colName, value)
{
	if(Number(userNorID)){
		var sql = "INSERT INTO cc_user " + colName + " = '"+ value +"'"
	}else{
		var sql = "INSERT INTO cc_user " + colName + " = '"+ value +"'"
	}
	var success = dbase.executeCommand(sql)
	return success
}
function setPlayerHome(Field, value, Field2, value2, Feild3, value3, Feild4, value4, Feild5, value5)
{
			var sql = "INSERT INTO cc_homes ("+ Field +", "+ Field2 +", "+ Feild3 +", "+ Feild4 +", "+ Feild5 +") VALUES ( '"+ value +"', '"+ value2 +"', '"+ value3 +"', '"+ value4 +"', '"+ value5 +"')"
			
		    var success = dbase.executeCommand(sql)
	        return success
}
function addHomeID(userNorID, value)
{
		var sql = "SELECT * FROM cc_homes WHERE user_id="+ userNorID

	var queryRes = dbase.executeQuery(sql)
	var row = queryRes.get(0)
	return row.getItem(value)
}
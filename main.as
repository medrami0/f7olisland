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
	var prevInv = getAccountValue(user.getName(), "inventory")

	if(cmd == "getUserCounts"){
		var roomTb = r.getVariable("tb")
		trace(roomTb)
		var responseObj = new Object()
		responseObj._cmd = "interface"
		responseObj.sub = "mapResponse"
		var playerInTribe = Number(getRoomVar(r,"tb"))

		var data = []
		if (Number(playerInTribe) == 1){
		
			data.push(String(currentZone.getUserCount()))
			data.push(String(0))
			responseObj.data = data

		}else if (Number(playerInTribe) == 2){
			data.push(String(0))
			data.push(String(currentZone.getUserCount()))
			responseObj.data = data

		}
		else {
			data.push(String(r.getUserCount()))
			data.push(String(0))
			responseObj.data = data

		}
		_server.sendResponse(responseObj, -1, null, [user])
	}else if(cmd == "getChief") {
			
			var responseObj = []
			responseObj._cmd = "sceneRep"
			responseObj.sub = "chief"
			if (fromRoom == 17)
			{
				tbId = 2
			}else{
				tbId = 1
			}
			responseObj.nm = getChiefName(tbId)
			_server.sendResponse(responseObj, -1, null, [user])
	}else if(cmd == "profile"){
		var targertId = params.id
		var targetU = _server.getUserById(targertId)
		var sql3 = "SELECT * FROM cc_user WHERE username='"+ targetU.getName() +"'" 
		var queryRes3 = dbase.executeQuery(sql3)
		var row3 = queryRes3.get(0)
		var hom = Number(row3.getItem("homeAddr"))
		if (hom != -1 ){
		var responseObj = new Object()
		responseObj._cmd = "profile"
		responseObj.abt = row3.getItem("about")
		responseObj.rdt = row3.getItem("register_date")
		responseObj.skl = row3.getItem("skill")
		responseObj.gam = row3.getItem("gam")
		responseObj.hom = row3.getItem("homeAddr")
			var btl = []
			var btlValue = row3.getItem("btl")
			var btl2 = btlValue.split(";")
			btl[0] = btl2[0]
			btl[1] = btl2[1]
		responseObj.btl = btl
		
			var med = []
			var medValue = row3.getItem("medals")
			var med2 = medValue.split(" ,")
			med[0] = med2[0]
			med[1] = med2[1]
			med[2] = med2[2]
			med[3] = med2[3]
			med[4] = med2[4]
			med[5] = med2[5]
			med[6] = med2[6]
			med[7] = med2[7]
			med[8] = med2[8]
			med[9] = med2[9]
			med[10] = med2[10]
			med[11] = med2[11]
			med[12] = med2[12]
			med[13] = med2[13]
			med[14] = med2[14]
			med[15] = med2[15]
			med[16] = med2[16]
			med[17] = med2[17]
		responseObj.med = med
		
		_server.sendResponse(responseObj, -1, null, [user])
		}
		else{
		var responseObj = new Object()
		responseObj._cmd = "profile"
		responseObj.abt = row3.getItem("about")
		responseObj.rdt = row3.getItem("register_date")
		responseObj.skl = row3.getItem("skill")
		responseObj.gam = row3.getItem("gam")
		responseObj.med = row3.getItem("medals")
			var btl = []
			var btlValue = row3.getItem("btl")
			var btl2 = btlValue.split(";")
			btl[0] = btl2[0]
			btl[1] = btl2[1]
		responseObj.btl = btl

			var med = []
			var medValue = row3.getItem("medals")
			var med2 = medValue.split(" ,")
			med[0] = med2[0]
			med[1] = med2[1]
			med[2] = med2[2]
			med[3] = med2[3]
			med[4] = med2[4]
			med[5] = med2[5]
			med[6] = med2[6]
			med[7] = med2[7]
			med[8] = med2[8]
			med[9] = med2[9]
			med[10] = med2[10]
			med[11] = med2[11]
			med[12] = med2[12]
			med[13] = med2[13]
			med[14] = med2[14]
			med[15] = med2[15]
			med[16] = med2[16]
			med[17] = med2[17]
		responseObj.med = med
		
		_server.sendResponse(responseObj, -1, null, [user])		
				
		}
		
		
		
	}else if(cmd == "buyINV"){
	 var ItemId = params.objid
	 var id = Number(getObjectValue(ItemId, "id"))
	 var SwfID = Number(getObjectValue(ItemId, "swfID"))
	 var objectName = getObjectValue(ItemId, "name")
	 var description = getObjectValue(ItemId, "description")
	 var ObjectType = Number(getObjectValue(ItemId, "type"))
	 var Exchange = Number(getObjectValue(ItemId, "exchange"))
	 var kind = Number(getObjectValue(ItemId, "kind"))
	 var lvl = Number(getObjectValue(ItemId, "lvl"))
	 var price = Number(getObjectValue(ItemId, "price"))
	
	var prevArray = prevInv.split("~")
			var playerInTribe = Number(getRoomVar(r,"tb"))
            var playerMoney = getAccountValue(user.getName(), "money")
            var moneyArray = playerMoney.split(",")
	
            if(playerInTribe == 1 && Number(moneyArray[0]) < price || playerInTribe == 2 && Number(moneyArray[1]) < price){
	    var response4 = new Object()
		  
	    response4.sub = "noCurrency"
        response4.popup ="store"		
        response4._cmd = "popupReply"
	    _server.sendResponse(response4, -1, null, [user])
			
			
			}
			
			
else {
if ( ItemId >= 1000 && ItemId <= 1010  ){

if ( ItemId == 1000){

lvl = 1
}
else if ( ItemId == 1001){

lvl = 2
}
else if ( ItemId == 1002){

lvl = 3
}
else if ( ItemId == 1003){

lvl = 1
}
else if ( ItemId == 1004){

lvl = 5
}
else if ( ItemId == 1005){

lvl = 2
}
else if ( ItemId == 1006){

lvl = 9
}
else if ( ItemId == 1007){

lvl = 8
}
else if ( ItemId == 1008){

lvl = 1
}
else if ( ItemId == 1009){

lvl = 1
}
else if ( ItemId == 1010){

lvl = 2
}

}

			

	 	 
	 var response = new Object()
	 response.hp = "100"
	 setAccountValue(user.getName(), "happyness", response.hp)
            if(playerInTribe == 1){
                moneyArray[0] = String(Number(moneyArray[0]) - price)
            }else if(playerInTribe == 2){
                moneyArray[1] = String(Number(moneyArray[1]) - price)
            }	 
	  response.cr = moneyArray[0] + "," + moneyArray[1]
      setAccountValue(user.getName(), "money", response.cr)
	  response._cmd = "buy"


	if(Number(prevArray[0]) >= 1){
	
			

	 response.adinv =  id + "~" + ItemId + "~" + SwfID + "~" + description + "~" + objectName + "~" + ObjectType + "~" + Exchange + "~" + kind + "~" + lvl
	 response.totalInv = prevInv + "|" + response.adinv
	 
	 setAccountValue(user.getName(), "inventory", response.totalInv)

	 }

	 

	 
	 else{
			


	 response.adinv =  id + "~" + ItemId + "~" + SwfID + "~" + description + "~" + objectName + "~" + ObjectType + "~" + Exchange + "~" + kind + "~" + lvl
	 setAccountValue(user.getName(), "inventory", response.adinv)

		  }
	 _server.sendResponse(response, -1, null, [user])

	 	 var response4 = new Object()
		  
	    response4.sub = "storeSucccess"
        response4.popup ="store"		
        response4._cmd = "popupReply"
		var data = []
			data.push(String(SwfID))
			data.push(String(objectName))
			data.push(Number(price))
			
			response4.data = data

	
			 _server.sendResponse(response4, -1, null, [user])

			  
	  
	 
}

	 	}else if(cmd == "setClth"){
		var uVars = {}
		uVars.clth = params.clthInvID
		_server.setUserVariables(user, uVars, true)
		
		
    setAccountValue(user.getName(), "clothing", params.clthInvID)
	}else if(cmd == "updatePref"){
    setAccountValue(user.getName(), "prefs", params.prefs)
	}else if(cmd == "blurb"){
    setAccountValue(user.getName(), "about", params.val)
	
    }
	else if(cmd == "getExchange"){
            var responseObj = []
            responseObj._cmd="exchangeRt"
			responseObj.rt = "1,1"
			
			
			_server.sendResponse(responseObj, -1, null, [user])

			
	
}
	else if(cmd == "convertCurrency"){
			var amt = Number(params.amt)
            var response3 = new Object()
            response3._cmd = "purse"
			var playerInTribe = Number(getRoomVar(r,"tb"))
            var playerMoney = getAccountValue(user.getName(), "money")
            var moneyArray = playerMoney.split(",")
            if(playerInTribe == 1){
                moneyArray[0] = String(Number(moneyArray[0]) + amt)
                moneyArray[1] = String(Number(moneyArray[1]) - amt)				
            }else if(playerInTribe == 2){
                moneyArray[1] = String(Number(moneyArray[1]) + amt)
                moneyArray[0] = String(Number(moneyArray[0]) - amt)				
            }
            response3.cr = moneyArray[0] + "," + moneyArray[1]
            setAccountValue(user.getName(), "money", response3.cr)
            _server.sendResponse(response3, -1, null, [user])
			
            if(playerInTribe == 2){
			
			var response3 = new Object()
			response3.crfm = "0"
			response3.crbt = "2"
			response3.ambt = amt
            response3.amfm = amt
            response3.rt = "1"			
			response3.cr = moneyArray[0] + "," + moneyArray[1]
            response3._cmd = "exchangeRsp"
			
            _server.sendResponse(response3, -1, null, [user])
			}
			else{
			
			var response3 = new Object()
			response3.crfm = "1"
			response3.crbt = "1"
			response3.ambt = amt
            response3.amfm = amt
            response3.rt = "1"			
			response3.cr = moneyArray[0] + "," + moneyArray[1]
            response3._cmd = "exchangeRsp"
			
            _server.sendResponse(response3, -1, null, [user])
			}
			
	
	

}
	else if(cmd == "getStoreItems"){
	
	var TypeOfMenue = params.locID
	
	
	
	if(TypeOfMenue == 15){
	
var sql2 = "SELECT * FROM cc_invlist WHERE H_ClothStore = '15' " 
var queryRes2 = dbase.executeQuery(sql2)
var invlist = ""
for (var i = 0; i < queryRes2.size(); i++)
{
  var tempRow2 = queryRes2.get(i);
  var ObjID = Number(tempRow2.getItem("objID"))
  var ObjName = tempRow2.getItem("name")
  var ObjDesc = tempRow2.getItem("description")
  var swfID = Number(tempRow2.getItem("swfID"))
  var ObjPrice = Number(tempRow2.getItem("price"))
  var Objkind = Number(tempRow2.getItem("kind"))
  var ObjExchange = Number(tempRow2.getItem("exchange"))
  var ObjLVL = Number(tempRow2.getItem("lvl"))
  var Objtype = Number(tempRow2.getItem("type"))
  var ObjLast = Number(tempRow2.getItem("LastNumber"))
  invlist = invlist + ObjID + "|" + ObjName + "|" + ObjDesc + "|" + swfID + "|" + ObjPrice + "|" + Objkind + "|" + ObjExchange + "|" + ObjLVL + "|" + Objtype + "|" + ObjLast + "%"
}

}

	if(TypeOfMenue == -1){
var sql2 = "SELECT * FROM cc_invlist WHERE weaponStore = '-1' " 
var queryRes2 = dbase.executeQuery(sql2)
var invlist = ""
for (var i = 0; i < queryRes2.size(); i++)
{


  var tempRow2 = queryRes2.get(i);
  var ObjID = Number(tempRow2.getItem("objID"))
  var ObjName = tempRow2.getItem("name")
  var ObjDesc = tempRow2.getItem("description")
  var swfID = Number(tempRow2.getItem("swfID"))
  var ObjPrice = Number(tempRow2.getItem("price"))
  var Objkind = Number(tempRow2.getItem("kind"))
  var ObjExchange = Number(tempRow2.getItem("exchange"))
  var ObjLVL = tempRow2.getItem("lvl")
  var Objtype = Number(tempRow2.getItem("type"))
  var ObjLast = Number(tempRow2.getItem("LastNumber"))
  invlist = invlist + ObjID + "|" + ObjName + "|" + ObjDesc + "|" + swfID + "|" + ObjPrice + "|" + Objkind + "|" + ObjLast + "|" + ObjLVL + "|" + Objtype + "|" + ObjExchange + "%"

  
}
	
	
}
	if(TypeOfMenue == 8){
	
var sql2 = "SELECT * FROM cc_invlist WHERE Y_ClothStore = '8' " 
var queryRes2 = dbase.executeQuery(sql2)
var invlist = ""
for (var i = 0; i < queryRes2.size(); i++)
{
  var tempRow2 = queryRes2.get(i);
  var ObjID = Number(tempRow2.getItem("objID"))
  var ObjName = tempRow2.getItem("name")
  var ObjDesc = tempRow2.getItem("description")
  var swfID = Number(tempRow2.getItem("swfID"))
  var ObjPrice = Number(tempRow2.getItem("price"))
  var Objkind = Number(tempRow2.getItem("kind"))
  var ObjExchange = Number(tempRow2.getItem("exchange"))
  var ObjLVL = Number(tempRow2.getItem("lvl"))
  var Objtype = Number(tempRow2.getItem("type"))
  var ObjLast = Number(tempRow2.getItem("LastNumber"))
  invlist = invlist + ObjID + "|" + ObjName + "|" + ObjDesc + "|" + swfID + "|" + ObjPrice + "|" + Objkind + "|" + ObjExchange + "|" + ObjLVL + "|" + Objtype + "|" + ObjLast + "%"
}




}
	if(TypeOfMenue == 35){
	
var sql2 = "SELECT * FROM cc_invlist WHERE H_FurnStore = '35' " 
var queryRes2 = dbase.executeQuery(sql2)
var invlist = ""
for (var i = 0; i < queryRes2.size(); i++)
{
  var tempRow2 = queryRes2.get(i);
  var ObjID = Number(tempRow2.getItem("objID"))
  var ObjName = tempRow2.getItem("name")
  var ObjDesc = tempRow2.getItem("description")
  var swfID = Number(tempRow2.getItem("swfID"))
  var ObjPrice = Number(tempRow2.getItem("price"))
  var Objkind = Number(tempRow2.getItem("kind"))
  var ObjExchange = Number(tempRow2.getItem("exchange"))
  var ObjLVL = Number(tempRow2.getItem("lvl"))
  var Objtype = Number(tempRow2.getItem("type"))
  var ObjLast = Number(tempRow2.getItem("LastNumber"))
  invlist = invlist + ObjID + "|" + ObjName + "|" + ObjDesc + "|" + swfID + "|" + ObjPrice + "|" + Objkind + "|" + ObjExchange + "|" + ObjLVL + "|" + Objtype + "|" + ObjLast + "%"
}




}
	if(TypeOfMenue == 9){
	
var sql2 = "SELECT * FROM cc_invlist WHERE Y_FurnStore = '9' " 
var queryRes2 = dbase.executeQuery(sql2)
var invlist = ""
for (var i = 0; i < queryRes2.size(); i++)
{
  var tempRow2 = queryRes2.get(i);
  var ObjID = Number(tempRow2.getItem("objID"))
  var ObjName = tempRow2.getItem("name")
  var ObjDesc = tempRow2.getItem("description")
  var swfID = Number(tempRow2.getItem("swfID"))
  var ObjPrice = Number(tempRow2.getItem("price"))
  var Objkind = Number(tempRow2.getItem("kind"))
  var ObjExchange = Number(tempRow2.getItem("exchange"))
  var ObjLVL = Number(tempRow2.getItem("lvl"))
  var Objtype = Number(tempRow2.getItem("type"))
  var ObjLast = Number(tempRow2.getItem("LastNumber"))
  invlist = invlist + ObjID + "|" + ObjName + "|" + ObjDesc + "|" + swfID + "|" + ObjPrice + "|" + Objkind + "|" + ObjExchange + "|" + ObjLVL + "|" + Objtype + "|" + ObjLast + "%"
}




}
var response3 = new Object()
response3.sub = "storeInfo"
response3.popup = "store"
response3.data = invlist
response3._cmd = "popupReply"
_server.sendResponse(response3, -1, null, [user])
}
	else if(cmd == "trade"){
	 var ItemId = params.id
	 var objectID = Number(getTradeValue(ItemId, "objID"))
	 var SwfID = Number(getTradeValue(ItemId, "swfID"))
	 var objectName = getTradeValue(ItemId, "name")
	 var description = getTradeValue(ItemId, "description")
	 var ObjectType = Number(getTradeValue(ItemId, "type"))
	 var Exchange = Number(getTradeValue(ItemId, "exchange"))
	 var kind = Number(getTradeValue(ItemId, "kind"))
	 var lvl = Number(getTradeValue(ItemId, "lvl"))
	 
	 	var targertUserId = params.uid
		var targetUser = _server.getUserById(targertUserId)
		var theSenter = Number(user.getUserId())

	 
	var response = new Object()

response.err = "لقد عرضت "+objectName+" على "+ targetUser.getName() +" "
response._cmd = "error"
_server.sendResponse(response, -1, null, [user])

	var response2 = new Object()
	response2.inv = ItemId + "~" + objectID + "~" + SwfID + "~" + objectName + "~" + description + "~" + ObjectType + "~" + Exchange + "~" + kind + "~" + lvl
    response2._cmd = "trdrq"
	response2.uid = theSenter
	_server.sendResponse(response2, -1, null, [targetUser])

}
	else if(cmd == "tradecnf"){

	var targertUserId = params.uid
	var targetUser = _server.getUserById(targertUserId)
	var theSenter = Number(user.getUserId())
	var accepted = params.rply
	var NomeOfreceiver = getAccountValue(user.getName(), "username")
	
	if (accepted == 0){
		var response = new Object()

response.err = "عرضك رفض من طرف الخنيث  "+ NomeOfreceiver +""
response._cmd = "error"
_server.sendResponse(response, -1, null, [targetUser])
	
	
	
	}
	else if (accepted == 1){
	
	 var ItemId = Number(params.id)
	 var objectID = Number(getTradeValue(ItemId, "objID"))
	 var SwfID = Number(getTradeValue(ItemId, "swfID"))
	 var objectName = getTradeValue(ItemId, "name")
	 var description = getTradeValue(ItemId, "description")
	 var ObjectType = Number(getTradeValue(ItemId, "type"))
	 var Exchange = Number(getTradeValue(ItemId, "exchange"))
	 var kind = Number(getTradeValue(ItemId, "kind"))
	 var lvl = Number(getTradeValue(ItemId, "lvl"))

//---------------------------------------------- الي استقبل الحاجة 
var response = new Object()

response.err = "لقد استلمت للتو "+objectName+" من  "+ targetUser.getName() +""
response._cmd = "error"
_server.sendResponse(response, -1, null, [user])

var response4 = new Object()

response4._cmd = "ginv"
response4.adinv = ItemId + "~" + objectID + "~" + SwfID + "~" + objectName + "~" + description + "~" + ObjectType + "~" + Exchange + "~" + kind + "~" + lvl
if(prevInv == ''){
	 setAccountValue(user.getName(), "inventory", response4.adinv)


	 }
	 else{
	 response4.totalInv = prevInv + "|" + response4.adinv
	 
	 setAccountValue(user.getName(), "inventory", response4.totalInv)

		  }
_server.sendResponse(response4, -1, null, [user])

//---------------------------------------------- الي بعت الحاجة

var response3 = new Object()

response3.err = "لقد تم قبول عرضك بواسطة "+ NomeOfreceiver +""
response3._cmd = "error"
_server.sendResponse(response3, -1, null, [targetUser])
	
var response5 = new Object()

response5._cmd = "dinv"
response5.id = ItemId

    var Alone = ItemId + "~" + objectID + "~" + SwfID + "~" + objectName + "~" + description + "~" + ObjectType + "~" + Exchange + "~" + kind + "~" + lvl
	var befor = "|" + ItemId + "~" + objectID + "~" + SwfID + "~" + objectName + "~" + description + "~" + ObjectType + "~" + Exchange + "~" + kind + "~" + lvl
	var after = ItemId + "~" + objectID + "~" + SwfID + "~" + objectName + "~" + description + "~" + ObjectType + "~" + Exchange + "~" + kind + "~" + lvl + "|"
	var GiverInv = getAccountValue(targetUser.getName(), "inventory")
	var NewGiverInv = String(GiverInv)

	 
	var HasAlone = NewGiverInv.indexOf(Alone)
	var HasBefor = NewGiverInv.indexOf(befor)
	var HasAfter = NewGiverInv.indexOf(after)
	
			if (HasAlone != -1 && HasBefor == -1 && HasAfter == -1) {
			var res = NewGiverInv.replace(Alone, "");
			setAccountValue(targetUser.getName(), "inventory", res)
			
			}
			else{
			if (HasAlone != -1 && HasBefor != -1 && HasAfter == -1) {
			var res = NewGiverInv.replace(befor, "");
			setAccountValue(targetUser.getName(), "inventory", res)
			
			}
			else{
			if (HasAlone != -1 && HasBefor == -1 && HasAfter != -1) {
			var res = NewGiverInv.replace(after, "");
			setAccountValue(targetUser.getName(), "inventory", res)
			
			}
			else{
			if (HasAlone != -1 && HasBefor != -1 && HasAfter != -1) {
			var res = NewGiverInv.replace(befor, "");
			setAccountValue(targetUser.getName(), "inventory", res)
			}
			}
			
			}
			}

_server.sendResponse(response5, -1, null, [targetUser])
	
	
}


}
	else if(cmd == "upgradeINV"){

	 var ItemId = params.objid
	 var objectID = Number(getTradeValue(ItemId, "objID"))
	 var SwfID = Number(getObjectValue(ItemId, "swfID"))
	 var objectName = getObjectValue(ItemId, "name")
	 var description = getObjectValue(ItemId, "description")
	 var ObjectType = Number(getObjectValue(ItemId, "type"))
	 var Exchange = Number(getObjectValue(ItemId, "exchange"))
	 var kind = Number(getObjectValue(ItemId, "kind"))
	 var lvl = Number(getObjectValue(ItemId, "lvl"))
	 var price = Number(getObjectValue(ItemId, "price"))
	 
	 
	 
	 	 var response = new Object()
	 
	 response._cmd = "purse"
	 
	var playerInTribe = Number(getRoomVar(r,"tb"))
    var playerMoney = getAccountValue(user.getName(), "money")
    var moneyArray = playerMoney.split(",")
            if(playerInTribe == 1){
                moneyArray[0] = String(Number(moneyArray[0]) - price)
            }else if(playerInTribe == 2){
                moneyArray[1] = String(Number(moneyArray[1]) - price)
            }	 
	  response.cr = moneyArray[0] + "," + moneyArray[1]
      setAccountValue(user.getName(), "money", response.cr)
	  _server.sendResponse(response, -1, null, [user])
	  
	  
	  
	 
	 var response1 = new Object()
	 response1.cr = moneyArray[0] + "," + moneyArray[1]
	  response1.amt = price
	  response1.sub = "upgradeSuccess"
	  response1.popup = "store"


		  
	 
	 
if ( Number(ItemId) == 1000){

    var Alone = "1000~1000~2000~كرة~كرة~7~0~0~1"

	
	var HasAlone = prevInv.indexOf(Alone)

	
	var Alone2 = "1000~1000~2000~كرة~ssssss~7~0~0~1"
	
	var HasAlone2 = prevInv.indexOf(Alone2)

	



	
	
			if (HasAlone != -1) {
	        var NewBall = ItemId + "~" + objectID + "~" + SwfID + "~" + objectName + "~" + description + "~" + ObjectType + "~" + Exchange + "~" + kind + "~" + 3
			var res = prevInv.replace(Alone, NewBall);
			setAccountValue(user.getName(), "inventory", res)
			
			}

//-------------------------------------------------------------------------------------------			
			if (HasAlone2 != -1) {
	        var NewBall = ItemId + "~" + objectID + "~" + SwfID + "~" + objectName + "~" + description + "~" + ObjectType + "~" + Exchange + "~" + kind + "~" + 5
			var res = prevInv.replace(Alone2, NewBall);
			setAccountValue(user.getName(), "inventory", res)
			
			}
			

}
else if ( ItemId == 1001){

    var Alone = "1001~1001~2001~قنبلة الكرز~قنبلة الكرز~7~0~0~2"

	
	var HasAlone = prevInv.indexOf(Alone)

	
	var Alone2 = "1001~1001~2001~قنبلة الكرصز~قنبلة الكرز~7~0~0~2"

	
	var HasAlone2 = prevInv.indexOf(Alone2)

	

	
	
			if (HasAlone != -1) {
	var NewBall = ItemId + "~" + objectID + "~" + SwfID + "~" + objectName + "~" + description + "~" + ObjectType + "~" + Exchange + "~" + kind + "~" + 5
			var res = prevInv.replace(Alone, NewBall);
			setAccountValue(user.getName(), "inventory", res)
			
			}

//-------------------------------------------------------------------------------------------			
			if (HasAlone2 != -1) {
	var NewBall = ItemId + "~" + objectID + "~" + SwfID + "~" + objectName + "~" + description + "~" + ObjectType + "~" + Exchange + "~" + kind + "~" + 10
			var res = prevInv.replace(Alone2, NewBall);
			setAccountValue(user.getName(), "inventory", res)
			
			}

			
			}
else if ( ItemId == 1002){

lvl = 3
}
else if ( ItemId == 1003){

lvl = 1
}
else if ( ItemId == 1004){

    var Alone = "1004~1004~2004~درع الحماية~درع الحماية~7~0~1~5"


	
	
			if (HasAlone != -1) {
	var NewBall = ItemId + "~" + objectID + "~" + SwfID + "~" + objectName + "~" + description + "~" + ObjectType + "~" + Exchange + "~" + kind + "~" + 8
			var res = prevInv.replace(Alone, NewBall);
			setAccountValue(user.getName(), "inventory", res)
			
			}

}
else if ( ItemId == 1005){

lvl = 2
}
else if ( ItemId == 1008){

lvl = 1
}
else if ( ItemId == 1009){

lvl = 1
}
else if ( ItemId == 1010){

lvl = 2
}
      response1.data = NewBall

	  response1._cmd = "popupReply"
	  
	  _server.sendResponse(response1, -1, null, [user])

 
	 
	  
	  




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
function getTradeValue(userNorID, value)
{
		var sql = "SELECT * FROM cc_invlist WHERE id="+ userNorID

	var queryRes = dbase.executeQuery(sql)
	var row = queryRes.get(0)
	return row.getItem(value)
}
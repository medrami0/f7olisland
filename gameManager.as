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
//----------------------------------------------------------------- خاص بلعبة جوز الهند
	var prevInv = getAccountValue(user.getName(), "inventory")
    var prevInvars = getAccountValue(user.getName(), "invars")
var ItemId = Number(58)
	 var id = Number(getObjectValue(ItemId, "id"))
	 var SwfID = Number(getObjectValue(ItemId, "swfID"))
	 var objectName = getObjectValue(ItemId, "name")
	 var description = getObjectValue(ItemId, "description")
	 var ObjectType = Number(getObjectValue(ItemId, "type"))
	 var Exchange = Number(getObjectValue(ItemId, "exchange"))
	 var kind = Number(getObjectValue(ItemId, "kind"))
	 var lvl = Number(getObjectValue(ItemId, "lvl"))
	 var price = Number(getObjectValue(ItemId, "price"))
	var takeCocoBefor = prevInvars.indexOf("66")


	 
//-----------------------------------------------------------------	خاص بالالعاب
			var prevMeds = getAccountValue(user.getName(), "medals")
            var UserPzl = getAccountValue(user.getName(), "pzl")
	        var PlayerTribe = getAccountValue(user.getName(), "tribe_ID")
			var DHSturtles = prevMeds.indexOf("4:3")
			var DHStubes = prevMeds.indexOf("17:3")
			var DHSrocks = prevMeds.indexOf("8:3")
			var DHScog = prevMeds.indexOf("11:3")
			var Ramos = UserPzl.indexOf("7") // if player already have 7 in pzl field

//------------------------------------------------------------------
	trace("cmd received: " + cmd)
	var currentZone = _server.getCurrentZone()
	var r = currentZone.getRoom(fromRoom)
	if(cmd == "list"){ // ارسال قائمة الالعاب
		var response = new Object()
		response._cmd = "interface"
		response.sub = "med"
		var listnow = ""
		var sql3 = "SELECT * FROM cc_games"
		var queryRes3 = dbase.executeQuery(sql3)
		if (queryRes3 != null)
		{
			// Cycle through all records in the ResultSet
			for (var i = 0; i < queryRes3.size(); i++)
			{
				// Get a record
				var tempRow = queryRes3.get(i)
				if(i == 0) {
					listnow = listnow + tempRow.getItem("id") + "%" + tempRow.getItem("name")
				}else{
					listnow = listnow + "#" + tempRow.getItem("id") + "%" + tempRow.getItem("name")
				}
			}
		}
		response.list = listnow
		response.act = params.act
		response.usr = Number(user.getUserId())
		_server.sendResponse(response, -1, null, [user])
	}else if(cmd == "plygame") // لعب لعبة -- مش مهم
	{
		var gid = params.id
		var prevGam = getAccountValue(user.getName(), "gam")
		var ifPlayedBefor = prevGam.indexOf(gid)
		
		if (ifPlayedBefor == -1 ){
		var responseObj = new Object()
		
		if(prevGam == ''){	
		
		responseObj.newput = gid
		responseObj._cmd = "gameRep"	
		setAccountValue(user.getName(), "gam", responseObj.newput)		
		_server.sendResponse(responseObj, -1, null, [user])

		}
		else{
		responseObj.newput = prevGam + "," + gid
		responseObj._cmd = "gameRep"
		setAccountValue(user.getName(), "gam", responseObj.newput)	
		_server.sendResponse(responseObj, -1, null, [user])
		
		}	
		}
		

	}else if(cmd == "pracBattle") // معركة تدريبية
	{
		var targertId = params.uid
		var targetU = getAccountValue(user.getName(), "username")
		var response = new Object()
		response.nm = targetU
		response.uid = targertId
        response.sub = "btlChallenge"
		response._cmd = "sceneRepAuto"
			var targetUser = _server.getUserById(Number(params.uid))
			_server.sendResponse(response, -1, null, [targetUser])			
		

	}else if(cmd == "submitHS") // انتهاء اللعبة
	{

			var gid = params.gid
			var score = params.hs
			var ifgetBronze = prevMeds.indexOf(gid + ":" + "1")
			var ifgetSilver = prevMeds.indexOf(gid + ":" + "2")
			var ifgetGold = prevMeds.indexOf(gid + ":" + "3")
//-----------------------------------------------------------------------------------------------------------------------------------------		
		    if(gid == 7){ //لعبة الدفاع الجوي
	        var S1 = 2000 // الحد الادنى للميدالية البرونزية
			var S2 = 10000 // الفضية
			var S3 = 15000 // الذهبية
			var M1 = 1200 // أقل سكور ياخد منه فلوس
			var M2 = 30000 // أعلى سكور ياخد منه فلوس
			var Average = 1001 // العدد الي يتقسم عليه السكور عشان يديله فلوس
			var Limit = 30 // أقصى فلوس ممكن يجيبها اللاعب من اللعبة مهما جاب سكور عالي
			var tribeN = 0 // 0 for yekmon , 1 for huhuloa


	}
//-------------------------------------------------------------------------------------------------------------------------------	
		    else if(gid == 13){ //تحدي الصيد
	        var S1 = 150 // الحد الادنى للميدالية البرونزية
			var S2 = 300 // الفضية
			var S3 = 700 // الذهبية
			var M1 = 20 // أقل سكور ياخد منه فلوس
			var M2 = 2000 // أعلى سكور ياخد منه فلوس
			var Average = 67 // العدد الي يتقسم عليه السكور عشان يديله فلوس
			var Limit = 30 // أقصى فلوس ممكن يجيبها اللاعب من اللعبة مهما جاب سكور عالي
			var tribeN = 0 // 0 for yekmon , 1 for huhuloa

	}
//-------------------------------------------------------------------------------------------------------------------------------	
	
		    else if(gid == 12){ //لعبة انقاذ الخراف
	        var S1 = 3
			var S2 = 7
			var S3 = 15
			var M1 = 1
			var M2 = 50
			var Average = 1
			var Limit = 50
			var tribeN = 1
	}
	
//----------------------------------------------------------------------------------------------------------------------------------------------------
	
		    else if(gid == 5){ //خلد الماء الجائع
	        var S1 = 150 // الحد الادنى للميدالية البرونزية
			var S2 = 300 // الفضية
			var S3 = 600 // الذهبية
			var M1 = 150 // أقل سكور ياخد منه فلوس
			var M2 = 1800 // أعلى سكور ياخد منه فلوس
			var Average = 60 // العدد الي يتقسم عليه السكور عشان يديله فلوس
			var Limit = 30 // أقصى فلوس ممكن يجيبها اللاعب من اللعبة مهما جاب سكور عالي
			var tribeN = 0 // 0 for yekmon , 1 for huhuloa


	}
	
//------------------------------------------------------------------------------------------------------------------------------------------			
		
			 else if(gid == 16){ //لعبة جوز الهند
	        var S1 = 1000 // الحد الادنى للميدالية البرونزية
			var S2 = 3000 // الفضية
			var S3 = 6000 // الذهبية
			var M1 = 300 // أقل سكور ياخد منه فلوس
			var M2 = 20000 // أعلى سكور ياخد منه فلوس
			var Average = 667 // العدد الي يتقسم عليه السكور عشان يديله فلوس
			var Limit = 30 // أقصى فلوس ممكن يجيبها اللاعب من اللعبة مهما جاب سكور عالي
			var tribeN = 0 // 0 for yekmon , 1 for huhuloa
			
			if(takeCocoBefor == -1 ){
			var response5 = new Object()
			response5.sub = "itemReward"
			response5._cmd = "sceneRep"
			response5.invvar = prevInvars + "," + 66
	 setAccountValue(user.getName(), "invars", response5.invvar)			
			_server.sendResponse(response5, -1, null, [user])
			
			var response4 = new Object()
            response4._cmd = "buy"
			response4.adinv = id + "~" + ItemId + "~" + SwfID + "~" + objectName + "~" + description + "~" + ObjectType + "~" + Exchange + "~" + kind + "~" + lvl
	            if(prevInv == ''){
            response4.totalInv = response4.adinv
			}
			else{
	        response4.totalInv = prevInv + "|" + response4.adinv
			
			}
	 setAccountValue(user.getName(), "inventory", response4.totalInv)			
			_server.sendResponse(response4, -1, null, [user])
			
	}


	}
//---------------------------------------------------------------------------------------------------------------------------------------------------------			
		    else if(gid == 14){ //البازل
	        var S1 = 500 // الحد الادنى للميدالية البرونزية
			var S2 = 3000 // الفضية
			var S3 = 5000 // الذهبية
			var M1 = 0 // أقل سكور ياخد منه فلوس
			var M2 = 8000 // أعلى سكور ياخد منه فلوس
			var Average = 5 // العدد الي يتقسم عليه السكور عشان يديله فلوس
			var Limit = 500 // أقصى فلوس ممكن يجيبها اللاعب من اللعبة مهما جاب سكور عالي
			var tribeN = 0 // 0 for yekmon , 1 for huhuloa
		    var ifSovledPuzzle = UserPzl.indexOf("18")
		   
			if (ifSovledPuzzle == -1){
			var id = 18
			var responseObj = []
			responseObj.sub = "puz"
			responseObj._cmd = "sceneRep"
			responseObj.pzlupd = UserPzl + "," + id
			setAccountValue(user.getName(), "pzl", responseObj.pzlupd)


		_server.sendResponse(responseObj, -1, null, [user])

}
	
	}
//---------------------------------------------------------------------------------------------------------------------------------------------------------			
		    else if(gid == 3){ //الهرم
	        var S1 = 100 // الحد الادنى للميدالية البرونزية
			var S2 = 400 // الفضية
			var S3 = 800 // الذهبية
			var M1 = 300 // أقل سكور ياخد منه فلوس
			var M2 = 1000 // أعلى سكور ياخد منه فلوس
			var Average = 50 // العدد الي يتقسم عليه السكور عشان يديله فلوس
			var Limit = 20 // أقصى فلوس ممكن يجيبها اللاعب من اللعبة مهما جاب سكور عالي
			var tribeN = 0 // 0 for yekmon , 1 for huhuloa
	
	}
//---------------------------------------------------------------------------------------------------------------------------------------------------------			
		    else if(gid == 15){ //جوهرة الغابة
	        var S1 = 5000 // الحد الادنى للميدالية البرونزية
			var S2 = 9500 // الفضية
			var S3 = 20000 // الذهبية
			var M1 = 800 // أقل سكور ياخد منه فلوس
			var M2 = 30000 // أعلى سكور ياخد منه فلوس
			var Average = 1001 // العدد الي يتقسم عليه السكور عشان يديله فلوس
			var Limit = 30 // أقصى فلوس ممكن يجيبها اللاعب من اللعبة مهما جاب سكور عالي
			var tribeN = 0 // 0 for yekmon , 1 for huhuloa


	}
//---------------------------------------------------------------------------------------------------------------------------------------------------------	
		    else if(gid == 1){ //لعبة المكعبات المتشابهة
	        var S1 = 1000 // الحد الادنى للميدالية البرونزية
			var S2 = 2000 // الفضية
			var S3 = 4000 // الذهبية
			var M1 = 1 // أقل سكور ياخد منه فلوس
			var M2 = 7500 // أعلى سكور ياخد منه فلوس
			var Average = 251 // العدد الي يتقسم عليه السكور عشان يديله فلوس
			var Limit = 30 // أقصى فلوس ممكن يجيبها اللاعب من اللعبة مهما جاب سكور عالي
			var tribeN = 0 // 0 for yekmon , 1 for huhuloa


	}
//---------------------------------------------------------------------------------------------------------------------------------------------------------
		    else if(gid == 21){ //لعبة الكرات المجنونة
	        var S1 = 4000 // الحد الادنى للميدالية البرونزية
			var S2 = 8000 // الفضية
			var S3 = 12000 // الذهبية
			var M1 = 500 // أقل سكور ياخد منه فلوس
			var M2 = 22000 // أعلى سكور ياخد منه فلوس
			var Average = 734 // العدد الي يتقسم عليه السكور عشان يديله فلوس
			var Limit = 30 // أقصى فلوس ممكن يجيبها اللاعب من اللعبة مهما جاب سكور عالي
            if (PlayerTribe == 1 ){
			var tribeN = 0 // 0 for yekmon , 1 for huhuloa
            }
			else {
			var tribeN = 1
			}

	}
//---------------------------------------------------------------------------------------------------------------------------------------------------------
		    else if(gid == 2){ //لعبة الجري إلى المعبد
	        var S1 = 1500 // الحد الادنى للميدالية البرونزية
			var S2 = 3000 // الفضية
			var S3 = 5000 // الذهبية
			var M1 = 900 // أقل سكور ياخد منه فلوس
			var M2 = 22000 // أعلى سكور ياخد منه فلوس
			var Average = 734 // العدد الي يتقسم عليه السكور عشان يديله فلوس
			var Limit = 30 // أقصى فلوس ممكن يجيبها اللاعب من اللعبة مهما جاب سكور عالي
			var tribeN = 0 // 0 for yekmon , 1 for huhuloa


	}
//---------------------------------------------------------------------------------------------------------------------------------------------------------
		    else if(gid == 9){ //لعبة الألغام الخفية
	        var S1 = 1000 // الحد الادنى للميدالية البرونزية
			var S2 = 10000 // الفضية
			var S3 = 20000 // الذهبية
			var M1 = 3000 // أقل سكور ياخد منه فلوس
			var M2 = 45000 // أعلى سكور ياخد منه فلوس
			var Average = 1501 // العدد الي يتقسم عليه السكور عشان يديله فلوس
			var Limit = 30 // أقصى فلوس ممكن يجيبها اللاعب من اللعبة مهما جاب سكور عالي
			var tribeN = 1 // 0 for yekmon , 1 for huhuloa


	}
//---------------------------------------------------------------------------------------------------------------------------------------------------------
		    else if(gid == 18){ //الجواهر البركانية المتداخلة
	        var S1 = 5000 // الحد الادنى للميدالية البرونزية
			var S2 = 9500 // الفضية
			var S3 = 20000 // الذهبية
			var M1 = 1500 // أقل سكور ياخد منه فلوس
			var M2 = 40000 // أعلى سكور ياخد منه فلوس
			var Average = 1334 // العدد الي يتقسم عليه السكور عشان يديله فلوس
			var Limit = 30 // أقصى فلوس ممكن يجيبها اللاعب من اللعبة مهما جاب سكور عالي
			var tribeN = 1 // 0 for yekmon , 1 for huhuloa


	}
//---------------------------------------------------------------------------------------------------------------------------------------------------------
		    else if(gid == 10){ //سباق السيارات المثير
	        var S1 = 10000 // الحد الادنى للميدالية البرونزية
			var S2 = 15000 // الفضية
			var S3 = 22500 // الذهبية
			var M1 = 4000 // أقل سكور ياخد منه فلوس
			var M2 = 40000 // أعلى سكور ياخد منه فلوس
			var Average = 1334 // العدد الي يتقسم عليه السكور عشان يديله فلوس
			var Limit = 30 // أقصى فلوس ممكن يجيبها اللاعب من اللعبة مهما جاب سكور عالي
			var tribeN = 1 // 0 for yekmon , 1 for huhuloa


	}
//---------------------------------------------------------------------------------------------------------------------------------------------------------
		    else if(gid == 11){ //الترس الحائر
	        var S1 = 2000 // الحد الادنى للميدالية البرونزية
			var S2 = 3500 // الفضية
			var S3 = 7000 // الذهبية
			var M1 = 2000 // أقل سكور ياخد منه فلوس
			var M2 = 11000 // أعلى سكور ياخد منه فلوس
			var Average = 551 // العدد الي يتقسم عليه السكور عشان يديله فلوس
			var Limit = 20 // أقصى فلوس ممكن يجيبها اللاعب من اللعبة مهما جاب سكور عالي
			var tribeN = 1 // 0 for yekmon , 1 for huhuloa
			if ( score >= S3 && DHStubes != -1 && DHSrocks != -1 && DHSturtles != -1 && Ramos == -1 ){
		    var response = new Object()
			response.id = "7"
			response.sub = "puz"
			response.pzlupd = UserPzl + "," + Number(7)
			response._cmd = "sceneRep"
					
		    setAccountValue(user.getName(), "pzl", response.pzlupd)
		    _server.sendResponse(response, -1, null, [user])	
			
			
				
			
			}


	}
//---------------------------------------------------------------------------------------------------------------------------------------------------------
		    else if(gid == 8){ //لعبة صيد الصخور
	        var S1 = 1000 // الحد الادنى للميدالية البرونزية
			var S2 = 3000 // الفضية
			var S3 = 6000 // الذهبية
			var M1 = 1000 // أقل سكور ياخد منه فلوس
			var M2 = 22000 // أعلى سكور ياخد منه فلوس
			var Average = 734 // العدد الي يتقسم عليه السكور عشان يديله فلوس
			var Limit = 30 // أقصى فلوس ممكن يجيبها اللاعب من اللعبة مهما جاب سكور عالي
			var tribeN = 1 // 0 for yekmon , 1 for huhuloa

			if ( score >= S3 && DHStubes != -1 && DHScog != -1 && DHSturtles != -1 && Ramos == -1 ){
		    var response = new Object()
			response.id = "7"
			response.sub = "puz"
			response.pzlupd = UserPzl + "," + Number(7)
			response._cmd = "sceneRep"
					
		    setAccountValue(user.getName(), "pzl", response.pzlupd)			
		    _server.sendResponse(response, -1, null, [user])	
		
				
			
			}


	}
//---------------------------------------------------------------------------------------------------------------------------------------------------------
		    else if(gid == 4){ //لعبة إنقاذ بيض السلحفاة
	        var S1 = 150 // الحد الادنى للميدالية البرونزية
			var S2 = 300 // الفضية
			var S3 = 600 // الذهبية
			var M1 = 100 // أقل سكور ياخد منه فلوس
			var M2 = 1750 // أعلى سكور ياخد منه فلوس
			var Average = 59 // العدد الي يتقسم عليه السكور عشان يديله فلوس
			var Limit = 30 // أقصى فلوس ممكن يجيبها اللاعب من اللعبة مهما جاب سكور عالي
			var tribeN = 1 // 0 for yekmon , 1 for huhuloa
			if ( score >= S3 && DHStubes != -1 && DHSrocks != -1 && DHScog != -1 && Ramos == -1 ){
		    var response = new Object()
			response.id = "7"
			response.sub = "puz"
			response.pzlupd = UserPzl + "," + Number(7)
			response._cmd = "sceneRep"
					
		    setAccountValue(user.getName(), "pzl", response.pzlupd)			
		    _server.sendResponse(response, -1, null, [user])	
			
				
			
			}


	}
//---------------------------------------------------------------------------------------------------------------------------------------------------------
		    else if(gid == 17){ //لعبة أنبوب الطاقة
	        var S1 = 10000 // الحد الادنى للميدالية البرونزية
			var S2 = 100000 // الفضية
			var S3 = 150000 // الذهبية
			var M1 = 5000 // أقل سكور ياخد منه فلوس
			var M2 = 300000 // أعلى سكور ياخد منه فلوس
			var Average = 10001 // العدد الي يتقسم عليه السكور عشان يديله فلوس
			var Limit = 30 // أقصى فلوس ممكن يجيبها اللاعب من اللعبة مهما جاب سكور عالي
			var tribeN = 1 // 0 for yekmon , 1 for huhuloa
			if ( score >= S3 && DHSturtles != -1 && DHSrocks != -1 && DHScog != -1 && Ramos == -1 ){
		    var response = new Object()
			response.id = "7"
			response.sub = "puz"
			response.pzlupd = UserPzl + "," + Number(7)
			response._cmd = "sceneRep"
					
		    setAccountValue(user.getName(), "pzl", response.pzlupd)			
		    _server.sendResponse(response, -1, null, [user])	
			
				
			
			}


	}
//---------------------------------------------------------------------------------------------------------------------------------------------------------		
			if(prevMeds == ''){ //معندوش ميداليات سابقة 
			if (score >= S1 && score < S2) {
			var responseObj = []
			responseObj._cmd = "interface"
		    responseObj.sub = "med"
			var tom = 1
            responseObj.newmed = gid + ":" + tom 
			responseObj.md = gid + ":" + tom
			setAccountValue(user.getName(), "medals", responseObj.md)
		_server.sendResponse(responseObj, -1, null, [user])	

			}else if (score >= S2 && score < S3) {
			var responseObj = []
			responseObj._cmd = "interface"
		    responseObj.sub = "med"
			var tom = 2
            responseObj.newmed = gid + ":" + tom 
			responseObj.md = gid + ":" + tom
			setAccountValue(user.getName(), "medals", responseObj.md)
		_server.sendResponse(responseObj, -1, null, [user])	

			}else if (score >= S3) {
			var responseObj = []
			responseObj._cmd = "interface"
		    responseObj.sub = "med"
			var tom = 3
            responseObj.newmed = gid + ":" + tom 
			responseObj.md = gid + ":" + tom
			setAccountValue(user.getName(), "medals", responseObj.md)
		_server.sendResponse(responseObj, -1, null, [user])	
			}


			}
			
			else{ // لو كان عنده ميداليات سابقة
			if (score >= S1 && score < S2 && ifgetBronze == -1 && ifgetSilver == -1 && ifgetGold == -1 ) {
			var responseObj = []
			responseObj._cmd = "interface"
		    responseObj.sub = "med"
			var tom = 1
            responseObj.newmed = gid + ":" + tom 
			responseObj.md = prevMeds + " ," + gid + ":" + tom
			setAccountValue(user.getName(), "medals", responseObj.md)
		_server.sendResponse(responseObj, -1, null, [user])

		
			}else if (score >= S2 && score < S3 && ifgetSilver == -1 && ifgetGold == -1) {
			var tom = 2
			if (ifgetBronze != -1){
			var responseObj = []
			responseObj._cmd = "interface"
		    responseObj.sub = "med"
            responseObj.newmed = gid + ":" + tom 
			var res = prevMeds.replace(gid + ":" + "1", gid + ":" + "2");
			responseObj.md = res
			setAccountValue(user.getName(), "medals", responseObj.md)
		_server.sendResponse(responseObj, -1, null, [user])	
		
			
			}else {
			var responseObj = []
			responseObj._cmd = "interface"
		    responseObj.sub = "med"
            responseObj.newmed = gid + ":" + tom 
			responseObj.md = prevMeds + " ," + gid + ":" + tom
			setAccountValue(user.getName(), "medals", responseObj.md)
		_server.sendResponse(responseObj, -1, null, [user])	
		
		}
			}else if (score >= S3 && ifgetGold == -1) {
			var tom = 3
			if (ifgetBronze != -1){
			var responseObj = []
			responseObj._cmd = "interface"
		    responseObj.sub = "med"
            responseObj.newmed = gid + ":" + tom 
			var res = prevMeds.replace(gid + ":" + "1", gid + ":" + "3");
			responseObj.md = res
			setAccountValue(user.getName(), "medals", responseObj.md)
		_server.sendResponse(responseObj, -1, null, [user])	
			
			
			}
			else if (ifgetSilver != -1){
			var responseObj = []
			responseObj._cmd = "interface"
		    responseObj.sub = "med"
            responseObj.newmed = gid + ":" + tom 
			var res = prevMeds.replace(gid + ":" + "2", gid + ":" + "3");
			responseObj.md = res
			setAccountValue(user.getName(), "medals", responseObj.md)
		_server.sendResponse(responseObj, -1, null, [user])
			
			
			}else {
			var responseObj = []
			responseObj._cmd = "interface"
		    responseObj.sub = "med"
            responseObj.newmed = gid + ":" + tom 
			responseObj.md = prevMeds + " ," + gid + ":" + tom
			setAccountValue(user.getName(), "medals", responseObj.md)
		_server.sendResponse(responseObj, -1, null, [user])	
			}
			}
				
			
    }

            if(score >= M1){
			if (score >= M1 && score < M2){
			var mfg = Math.ceil(score / Average)
			}
			else if (score >= M2){
			var mfg = Limit
			}
			var response3 = new Object()
            response3._cmd = "purse"
			var playerMoney = getAccountValue(user.getName(), "money")
            var moneyArray = playerMoney.split(",")
		    moneyArray[tribeN] = String(Number(moneyArray[tribeN]) + mfg)
            response3.cr = moneyArray[0] + "," + moneyArray[1]
            setAccountValue(user.getName(), "money", response3.cr)
            _server.sendResponse(response3, -1, null, [user])
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
	if (success){
		trace("[setAccountData] Name/ID " + userNorID + " Value Name : " + colName + " new Value : " + String(value))
	}
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
function getObjectValue(userNorID, value)
{
		var sql = "SELECT * FROM cc_invlist WHERE objID="+ userNorID

	var queryRes = dbase.executeQuery(sql)
	var row = queryRes.get(0)
	return row.getItem(value)
}
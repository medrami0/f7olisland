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
	
	
	
}

function handleInternalEvent(evt) 
{ 

}
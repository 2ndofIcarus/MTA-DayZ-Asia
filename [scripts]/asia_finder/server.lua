function hasfindVehicle(key,keyState)
	account = getAccountName(getPlayerAccount(source))
	getUserSerial = getPlayerSerial(source)
	if isObjectInACLGroup("user."..account,aclGetGroup("Staff")) then
		triggerClientEvent(source,"playerOnClick",source,key,keyState)
	end
end
addEvent("hasfindVehicle",true)
addEventHandler("hasfindVehicle",root,hasfindVehicle)

addEvent("onTele", true)
addEventHandler("onTele", root,
function(x,y,z)
	setElementPosition(source, x+2,y+2,z+2,true)
end )
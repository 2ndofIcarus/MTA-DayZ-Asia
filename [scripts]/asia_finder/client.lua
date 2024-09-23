
local screenW, screenH = guiGetScreenSize()-- // Variables needed to know the width and height.
local w = 
{ 	
	gridList = {},
	label = {},
	window = {},
    button = {}
}

-- // Window creation code --
addEventHandler("onClientResourceStart", resourceRoot,
function()
	w.main = guiCreateWindow((screenW - 564) / 2, (screenH - 349) / 2, 564, 349, "Vehicle & Tend Finder", false)
	guiWindowSetSizable(w.main, false)
	guiSetAlpha(w.main, 0.77)

	w.gridList.main = guiCreateGridList(10, 26, 544, 313, false, w.main)
	w.gridList.column1 = guiGridListAddColumn( w.gridList.main, "Name", 0.25 )
	w.gridList.column2 = guiGridListAddColumn( w.gridList.main, "Coordinates X", 0.25 )
	w.gridList.column3 = guiGridListAddColumn( w.gridList.main, "Coordinates Y", 0.25 )
	w.gridList.column4 = guiGridListAddColumn( w.gridList.main, "Coordinates Z", 0.25 )
	guiWindowSetMovable(w.main, false)
	guiSetVisible(w.main, false)

	addEventHandler( "onClientGUIClick", w.gridList.main, function( btn ) 
  	if btn ~= 'left' then return false end 
  	local row, col = guiGridListGetSelectedItem( source ) 
  	--check if we actually clicked on some row 
  	if row >= 0 and col >= 0 then 
  	  	local x = guiGridListGetItemText(w.gridList.main, guiGridListGetSelectedItem(w.gridList.main), 2)
		local y = guiGridListGetItemText(w.gridList.main, guiGridListGetSelectedItem(w.gridList.main), 3)
		local z = guiGridListGetItemText(w.gridList.main, guiGridListGetSelectedItem(w.gridList.main), 4)
		triggerServerEvent("onTele", localPlayer, x,y,z)
		guiSetVisible(w.main, true)
		showCursor(true) 
  	end 
	end, false ) 
end )


function playerOnClick(key,keyState)
	if (keyState == "down") then
		if (guiGetVisible(w.main) == false) then
			guiGridListClear ( w.gridList.main )
			for i,veh in ipairs(getElementsByType("vehicle")) do
				if veh ~= vehicle then
					local row = guiGridListAddRow ( w.gridList.main )
					local x,y,z = getElementPosition(veh)
					guiGridListSetItemText ( w.gridList.main, row, w.gridList.column1, getVehicleName ( veh ), false, false )
					guiGridListSetItemText ( w.gridList.main, row, w.gridList.column2, x, false, false )
					guiGridListSetItemText ( w.gridList.main, row, w.gridList.column3, y, false, false )
					guiGridListSetItemText ( w.gridList.main, row, w.gridList.column4, z, false, false )
				end
			end
			guiSetVisible(w.main, true)
			showCursor(true)
		else
			guiSetVisible(w.main, false)
			showCursor(false)
		end
	end
end

addEvent("playerOnClick",true)
addEventHandler("playerOnClick",root,playerOnClick)


function findVehicle(key,keyState)
	if getElementData(localPlayer, "logedin") then
		triggerServerEvent("hasfindVehicle",localPlayer,key,keyState)
	end
end
bindKey("o", "down", findVehicle)


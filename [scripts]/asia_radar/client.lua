modelX, modelY, modelZ = 219.9765, 1822.8145, 6.533 -- minimap location

showLegend = createColSphere ( modelX, modelY, modelZ, 13 ) --colshape for activating nametags

function makeMapMarker (player)
	local r, g, b = getPlayerNametagColor ( player )
	local themarker = createMarker ( modelX, modelY, modelZ, "cylinder", .05, r, g, b, 255 )
	setElementData ( player, "Radar_marker", themarker, false )
end

function ResourceStart(startedresource)
	if startedresource == getThisResource() then
		Radar_items = getElementsByType( "player" )	
		for k,v in ipairs(Radar_items) do
			makeMapMarker (v)
		end
		setTimer(Radar_check, 250, 0)
	end
end
addEventHandler( "onClientResourceStart", getRootElement(), ResourceStart )

function PlayerJoin ( )
	makeMapMarker (source)
end
addEventHandler( "onClientPlayerJoin", getRootElement(), PlayerJoin)

function PlayerQuit ( )
	destroyElement( getElementData ( source, "Radar_marker" ) )
end
addEventHandler( "onClientPlayerQuit", getRootElement(), PlayerQuit)

function deletePlayerMarkers()
	for i,v in ipairs(getElementsByType("player")) do
		local marker = getElementData(v,"Radar_marker");
		if isElement(marker) then
			destroyElement(marker);
		end
	end
end

function createPlayerMarkers()
	for i,v in ipairs(getElementsByType("player")) do
		makeMapMarker(v);
	end
end

function Radar_check()
	Radar_items = getElementsByType( "player" )
	for k,v in ipairs(Radar_items) do
		if isElement(v) then
			x,y,z = getElementPosition ( v )
			x = x / 1642.935378
			y = y / 1642.935378
			z = z / 1642.935378
			local themarker = getElementData ( v, "Radar_marker" )
			if (isElement(themarker)) then
				setElementPosition ( themarker, modelX-y, modelY+x, modelZ+z ) --Whack math is because west is north on 3d model
			end
		end
	end
end

function ColShapeHit ( theElement, matchingDimension )
	if theElement == getLocalPlayer() then
		if not mapNamesHandler then
			mapNamesHandler = addEventHandler ( "onClientRender", root, ClientRender )
		end
	end
end
addEventHandler("onClientColShapeHit",showLegend,ColShapeHit)

function ColShapeLeave ( theElement, matchingDimension )
	if theElement == getLocalPlayer() then
		if mapNamesHandler then
			removeEventHandler ( "onClientRender", root, ClientRender )
			mapNamesHandler = nil
		end
	end
end
addEventHandler("onClientColShapeLeave", showLegend, ColShapeLeave )

function getTimerDummy()
	for i,v in ipairs(getElementsByType("Object")) do
		if getElementData(v,"timerDummy") then
			return v;
		end
	end
end

addEventHandler("onClientElementDataChange",getTimerDummy(),function(dataName,oldValue)
	if (dataName == "timeleft") then
		local newValue = getElementData(source,dataName);
		if (oldValue <= 0 and newValue >= 1) then
			createPlayerMarkers();
		end
	end
end);

function ClientRender ()
	local timeleft = getElementData(getTimerDummy(),"timeleft");
	local screenX, screenY = getScreenFromWorldPosition ( modelX-7.5596, modelY+.022, modelZ+1.019 )
	if screenX ~= false and screenXX ~= false then
		dxDrawText ("Time Left: "..timeleft.." Minutes", screenX, screenY, screenX, screenY, tocolor(255,255,255) )
	end	
	if timeleft <= 0 then return deletePlayerMarkers(); end
	if trackmode == 1 then
		local Radar_items = getElementsByType( "player" )
		for k,v in pairs(Radar_items) do
			local r, g, b, a = getMarkerColor ( getElementData ( v, "Radar_marker" ) )
			local x, y, z = getElementPosition ( getElementData ( v, "Radar_marker" ) )
			local zOffset = (k/20)+.3
			
			local screenX, screenY = getScreenFromWorldPosition ( x, y, z + zOffset )
			local screenXX, screenYY = getScreenFromWorldPosition ( x, y, z ) --For the marker 
			
			if screenX ~= false and screenXX ~= false then
				local name = getPlayerName ( v )
				dxDrawText ( name, screenX, screenY, screenX, screenY, tocolor(r, g, b) )			
				dxDrawLine ( screenX, screenY+13, screenXX, screenYY, tocolor(r,g,b), 1 )
			end
		end
	end
end


trackedvehicle = nil




radarrent = {button = {},window = {},label = {}}
local screenW, screenH = guiGetScreenSize()

radarRentMarker = createMarker (modelX-7.5596, modelY+.022, modelZ-1.019, "cylinder", 1.5, 255, 255, 0, 40 )
radarrent.window[1] = guiCreateWindow((screenW - 134) / 2, (screenH - 114) / 2, 134, 114, "Radar Rent", false)
guiSetVisible ( radarrent.window[1], false )
guiWindowSetMovable(radarrent.window[1], false)
guiWindowSetSizable(radarrent.window[1], false)

radarrent.button[1] = guiCreateButton(9, 73, 90, 32, "Pay 50 PHP", false, radarrent.window[1])
radarrent.label[1] = guiCreateLabel(10, 27, 115, 45, "Pay 50 PHP to\nextend radars life\nfor 10 more minutes.", false, radarrent.window[1])
radarrent.button[2] = guiCreateButton(99, 73, 26, 32, "X", false, radarrent.window[1])



trackmode = 1
trackedplayer = nil
trackedarmor = nil
trackedlocation = nil
trackedcity = nil
trackedweapon = nil
trackedvehicle = nil

holoped = createPed ( 0, modelX, modelY, modelZ+1.4 )
setElementAlpha(holoped, 0)
setElementFrozen(holoped, true)
setElementCollisionsEnabled(holoped, false)
setPedVoice(holoped, "PED_TYPE_DISABLED")

function showRadarRent ( hitPlayer, matchingDimension )
	if (hitPlayer == getLocalPlayer()) and (isPedOnGround ( getLocalPlayer())) then
		guiSetVisible ( radarrent.window[1], true )
		guiBringToFront ( radarrent.window[1] )
		showCursor (true)
	end
end
addEventHandler ( "onClientMarkerHit", radarRentMarker, showRadarRent )

function RadarRentMarkerLeave ( hitPlayer, matchingDimension )
	if (hitPlayer == getLocalPlayer()) then
		guiSetVisible ( radarrent.window[1], false )
		showCursor ( false )
	end
end
addEventHandler ( "onClientMarkerLeave", radarRentMarker, RadarRentMarkerLeave )

function radarRentButton()
	player_money  = getPlayerMoney(source)
	if (player_money >= 50) then
		takePlayerMoney(50)
		setElementData(getTimerDummy(),"timeleft",getElementData(getTimerDummy(),"timeleft")+10);
		guiSetVisible(radarrent.window[1],false)
		showCursor(false)
		trackmode = 1
		triggerServerEvent ("onTrackModeChange",getLocalPlayer(),trackmode)
		setElementAlpha(holoped, 0)
	else
		outputChatBox("You don't have enough money (PHP)!",136,8,8)
	end
end
addEventHandler ( "onClientGUIClick", radarrent.button[1], radarRentButton)

function radarRentClose()
	guiSetVisible(radarrent.window[1],false)
	showCursor(false)
end
addEventHandler ( "onClientGUIClick", radarrent.button[2], radarRentClose)

addEvent( "onTrackerUpdated", true )
function syncTrackMode ( newtrackmode, newtrackedplayer )
	if newtrackmode == 1 then
		trackmode = 1
		setElementAlpha(holoped, 0)
		trackedarmor = nil
	elseif newtrackmode == 2 then
		trackmode = 2
		trackedplayer = newtrackedplayer
		setElementModel(holoped,getElementModel(trackedplayer))
		trackedarmor = nil
	end
end
addEventHandler( "onTrackerUpdated", getRootElement(), syncTrackMode )

function didTrackedplayerQuit()
	if source == trackedplayer then
		trackmode = 1
		setElementAlpha(holoped, 0)
		trackedarmor = nil
	end
end
addEventHandler( "onClientPlayerQuit", getRootElement(), didTrackedplayerQuit )

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

addEvent( "onTrackerInfoUpdate", true )
function syncTrackMode(vehicle, location, city, weapon, armor)
	if vehicle then trackedvehicle = vehicle end
	if location then trackedlocation = location end
	if city then trackedcity = city end
	if weapon then trackedweapon = weapon end
	if armor then trackedarmor = armor end
end
addEventHandler( "onTrackerInfoUpdate", getRootElement(), syncTrackMode )

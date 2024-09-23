-- This huge function is the most optimized way to avoid positional desyncs (player being able to roam SA as a ghost, while server/others think and see him like glue'd on a vehicle)
-- Some have said "to get rid of this bug we gotta get rid of glue", but that is history now 
local vehTable = {}
function contained(element)
	if not element then
		return false
	end
	for i, v in pairs(vehTable) do
		if v == element then
			return true
		end
	end
	return false
end

setTimer(
	function()
		if #vehTable == 0 then
			return
		end
		local index = 1
		while true do
			if index > #vehTable then
				break
			end
			if not isElement(vehTable[index]) then
				table.remove(vehTable, index)
			else
				local elements = getAttachedElements(vehTable[index])
				if #elements == 0 then
					table.remove(vehTable, index)
				else
					local vx, vy, vz = getElementPosition(vehTable[index])
					for i, v in pairs(elements) do
						local ex, ey, ez = getElementPosition(v)
						setElementPosition(v, vx, vy, vz, false)
					end
					index = index + 1
				end
			end
		end
	end, 1000, 0
)

local detachOnExit = false

addEvent("attachElements", true)

addEventHandler("attachElements", root,
	function(attachTo, offsX, offsY, offsZ, rotX, rotY, rotZ, slot)
		if isElement(attachTo) and (not isVehicleBlown(attachTo)) then
			local attX, attY, attZ = getElementRotation(attachTo)
			attachElements(source, attachTo, offsX, offsY, offsZ, rotX, rotY, rotZ)
			triggerClientEvent(source, "bindGlue", source)
			if not contained(attachTo) then
				vehTable[#vehTable + 1] = attachTo
			end
			if slot then
				setPedWeaponSlot(source, slot)
			end
		end
	end
)

addEvent("detachElements", true)
addEventHandler("detachElements", root,
	function()
		detachElements(source)
	end
)

if detachOnExit then
	addEventHandler("onVehicleExit", root,
		function(thePlayer, seat)
			if isElementAttached(source) and seat == 0 then
				detachElements(source)
			end
		end
	)
end

addEventHandler("onPlayerWasted", getRootElement(),
	function()
		if source then
			detachElements(source)
		end
	end
)
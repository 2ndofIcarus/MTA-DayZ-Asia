local screenW,screenH = guiGetScreenSize()
local resW,resH = 1980,1080
local sW,sH =  (screenW/resW), (screenH/resH)
local alwaysRenderMap = false
local alwaysRenderOxygen = false
local disableGTASAhealth = true
local disableGTASAarmor = true
local disableGTASAoxygen = true
local enableBlipDistance = true
local worldW, worldH = 3072, 3072
local blip = 14

local turn = true
local turn_gps = true
local map = true

local alpha = 255
local sRotating = 0
local rt = dxCreateRenderTarget(290, 175)


local sx, sy = guiGetScreenSize()
local top = 30

local font1 = dxCreateFont("font.otf", 11)
local font2 = dxCreateFont("font.otf", 10)

local cords = {
    {0, "N"},
    {15, 15},
    {30, 30},
    {45, "NE"},
    {60, 60},
    {75, 75},
    {90, "E"},
    {105, 105},
    {120, 120},
    {135, "SE"},
    {150, 150},
    {165, 165},
    {170, "S"},
    {195, 195},
    {210, 210},
    {225, "SW"},
    {240, 240},
    {255, 255},
    {270, "W"},
    {285, 285},
    {300, 300},
    {315, "NW"},
    {330, 330},
    {345, 345}
}

function findRotation(x1,y1,x2,y2)
  local t = -math.deg(math.atan2(x2-x1,y2-y1))
  if t < 0 then t = t + 360 end;
  return t;
end

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle);
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
    return x+dx, y+dy;
end

function drawRadar()
	if getElementData(getLocalPlayer(),"logedin") then
		if getElementData(getLocalPlayer(),"toolbelt2") >= 1 then
			if turn_gps == true then
				if exports.e_map:isPlayerMapVisible() then return; end
				if (not isPlayerMapVisible()) then
					local mW, mH = dxGetMaterialSize(rt)
					if ( alwaysRenderMap or getElementInterior(localPlayer) == 0 ) then
						dxSetRenderTarget(rt, true)
						local x, y = getElementPosition(localPlayer)
						local X, Y = mW/2 -(x/(6000/worldW)), mH/2 +(y/(6000/worldH))
						local camX,camY,camZ = getElementRotation(getCamera())
							dxDrawImage(X - worldW/2, mH/5 + (Y - worldH/2), worldW, worldH, "img/world.jpg", camZ, (x/(6000/worldW)), -(y/(6000/worldH)))
						dxSetRenderTarget()
					end	


--
					local show = 15
					local center = math.ceil(show / 2) - 1
					local _, _, r = getElementRotation(getCamera())
					local pos = math.floor(r / 15)
					local slotwidth = 40
					local smooth = ((r - (pos * 15)) / 15) * slotwidth
					local left = sx / 2 - ((show + 2) * slotwidth)/2
					for i=1, show do
						local id = i + pos - center
						if(id > #cords)then
							id = id - #cords
						end
						if(id <= 0)then
							id = #cords - math.abs(id)
						end
						if(cords[id])then
							local alpha = (tonumber(cords[id][2]) or 0 > 0) and 175 or 255
							if(i < center)then
								alpha = alpha * (i/center)
							end
							if(i > center)then
								alpha = alpha * ((show-i)/center)
							end
							dxDrawRectangle(left + slotwidth * i - smooth + (slotwidth / 2 - 1) + 1, top + 10 + 1, 2, 10, tocolor(0, 0, 0, alpha * 0.5))
							dxDrawRectangle(left + slotwidth * i - smooth + (slotwidth / 2 - 1), top + 10, 2, 10, tocolor(255, 255, 255, alpha))
							dxDrawText(cords[id][2], left + slotwidth * i - smooth + 1, top + 20, left + slotwidth * (i+1) - smooth + 2, top + 40, tocolor(0, 0, 0, alpha * 0.5), 1, font2, "center", "center")
							dxDrawText(cords[id][2], left + slotwidth * i - smooth, top + 20, left + slotwidth * (i+1) - smooth, top + 40, tocolor(255, 255, 255, alpha), 1, font2, "center", "center")
						end
					end
					dxDrawText("➤", left + 4, top + 26 + 2, left + ((show + 3) * slotwidth) + 30, 0, tocolor(0, 0, 0, 160), 1, font1, "center", "top", false, false, false, false, false, 90)
					dxDrawText("➤", left, top + 26, left + ((show + 3) * slotwidth) + 30, 0, tocolor(255, 255, 255, 255), 1, font1, "center", "top", false, false, false, false, false, 90)
--			


					dxDrawImage((18+5)*sW, screenH-((179+5))*sH, (275-10)*sW, (135)*sH, rt, 0, 0, 0, tocolor(255, 255, 255, 150))
					local _, _, c_Rot = getElementRotation( getCamera());
					local _, _, p_Rot = getElementRotation( localPlayer )		
					local rx, ry, rz = getElementRotation(localPlayer)
					local lB = (23)*sW
					local rB = (23+265)*sW
					local tB = screenH-(184)*sH
					local bB = tB + (135)*sH
					local cX, cY = (rB+lB)/2, (tB+bB)/2 +(35)*sH
					for k, v in ipairs(getElementsByType("blip")) do			
						local px, py, pz = getElementPosition(localPlayer)	
						local _,_,camZ = getElementRotation(getCamera())			
						local bx, by, bz = getElementPosition(v)
						local actualDist = getDistanceBetweenPoints2D(px, py, bx, by)
						local maxDist = getBlipVisibleDistance(v)
						if ( actualDist <= maxDist ) then
							local dist = actualDist/(6000/((worldW+worldH)/2))
							local rot = findRotation(bx, by, px, py)-camZ
							local bpx, bpy = getPointFromDistanceRotation(cX, cY, dist, rot)
							local bpx = math.max(lB, math.min(rB, bpx))
							local bpy = math.max(tB, math.min(bB, bpy))
							local blipID = getElementData(v, "customIcon") or getBlipIcon(v)
							local _, _, _, bcA = getBlipColor(v)
							local bcR, bcG, bcB = 255, 255, 255
							if getBlipIcon(v) == 0 then
								bcR, bcG, bcB = getBlipColor(v)
							end
							local bUD = "img/blip.png"
							if (bz - pz) >= 5 then
								bUD = "img/blip_up.png"
							elseif (bz - pz) <= -5 then
								bUD = "img/blip_down.png"
							end				
							local bS = getBlipSize(v)
							dxDrawImage(bpx -(blip*bS)*sW/2, bpy -(blip*bS)*sH/2, (blip*bS)*sW, (blip*bS)*sH, "img/blips/"..blipID..".png", 0, 0, 0, tocolor(bcR, bcG, bcB, bcA))
						end
					end
					if ( renderNorthBlip ) then
						local _,_,camZ = getElementRotation(getCamera())		
						local toLeft, toTop, toRight, toBottom = cX-lB, cY-tB, rB-cX, b-cY
						local bpx, bpy = getPointFromDistanceRotation(cX, cY, math.sqrt(toTop^2 + toLeft^2), -camZ+180)
						local bpx = math.max(lB, math.min(rB, bpx))
						local bpy = math.max(tB, math.min(bB, bpy))
						dxDrawImage(bpx -(blip*2)/2, bpy -(blip*2)/2, blip*2, blip*2, "img/blips/4.png", 0, 0, 0)
					end
					local _,_,camZ = getElementRotation(getCamera())
					dxDrawImage(cX -(blip*1.5)*sW/2, cY -(blip*1.5)*sH/2, (blip*1.5)*sW, (blip*1.5)*sH, "img/player.png", camZ-rz, 0, 0)		
				end
			end
		end
	end
end	
addEventHandler( "onClientRender", root, drawRadar)	
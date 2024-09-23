mark = {
	{143.39999389648,1875.4000244141,16.5},
	{143.39999389648,1875.4000244141,16.5},
	{143.39999389648,1875.4000244141,16.5},
	{143.39999389648,1875.4000244141,16.5},
	{143.39999389648,1875.4000244141,16.5},
	{143.39999389648,1875.4000244141,16.5},
	{143.39999389648,1875.4000244141,16.5},
	{143.39999389648,1875.4000244141,16.5},
	{143.39999389648,1875.4000244141,16.5},
	{143.39999389648,1875.4000244141,16.5},
	{143.39999389648,1875.4000244141,16.5},
	{143.39999389648,1875.4000244141,16.5},
	{143.39999389648,1875.4000244141,16.5},
	{143.39999389648,1875.4000244141,16.5},
	{143.39999389648,1875.4000244141,16.5},
	{143.39999389648,1875.4000244141,16.5},
	{143.39999389648,1875.4000244141,16.5},
	{143.39999389648,1875.4000244141,16.5},
	{143.39999389648,1875.4000244141,16.5},
	{143.39999389648,1875.4000244141,16.5},
	{143.39999389648,1875.4000244141,16.5},
	{143.39999389648,1875.4000244141,16.5},
	{143.39999389648,1875.4000244141,16.5},
	{143.39999389648,1875.4000244141,16.5},
}

bag = {
	{-1484.5830078125,2641.2255859375,58.78125},
	{-1783.3955078125,1479.1494140625,7.1875},
	{2784.5732421875,-1466.1904296875,30.453125},
	{2174.5849609375,-1502.818359375,23.956878662109},
	{-2388.375,1547.650390625,2.1171875},
	{301.111328125,2543.0947265625,16.819511413574},
	{153.4189453125,1392.3291015625,10.5859375},
	{2743.7646484375,-2452.8408203125,13.86225605011},
	{2430.7978515625,-2467.2958984375,13.632326126099},
	{-2729.1767578125,72.939453125,4.3359375},
	{1984.5498046875,-2155.3212890625,13.546875},
	{2512.251953125,-2073.181640625,26.5546875},
	{-2181.48828125,-205.2939453125,36.515625},
	{-1905.5556640625,220.7880859375,35.15625},
	{2107.96484375,-1876.0947265625,13.546875},
	{-2447.671875,522.552734375,30.3671875},
	{-1478.693359375,-43.5625,6},
	{988.9541015625,-1751.853515625,13.501810073853},
	{-911.96875,2686.4091796875,42.370262145996},
	{587.9296875,871.0205078125,-42.497318267822},
	{2142.5478515625,2718.3193359375,10.8203125},
	{-58.3115234375,-1112.5966796875,1.3712005615234},
	{725.626953125,-469.60546875,16.3359375},
	{910.306640625,-1235.380859375,17.218402862549},
}


function createBag()
	local mt = math.random(#bag)
	ob = createObject(1210,bag[mt][1],bag[mt][2],bag[mt][3])
	setElementCollisionsEnabled(ob,false)
	time = setTimer(roo,100,0,ob)
	mar = createMarker(bag[mt][1],bag[mt][2],bag[mt][3],"corona",0.5,136,8,8,50)
	bl = createBlipAttachedTo(mar,17)
	setElementData(mar,"num",mt)

end
addEventHandler("onResourceStart",resourceRoot,createBag)

addEventHandler("onMarkerHit",root,
	function (player)
		if ( source == mar ) then
			if getElementType(player) == "player" then
				local x,y,z = getElementPosition(player)
				local data = getElementData(mar,"num")
				local data = tonumber(data)
				destroyElement(mar)
				destroyElement(ob)
				destroyElement(bl)
				killTimer(time)
				setElementData(player,"bag",true)
				atBag = createObject(1210,x,y,z)
				setElementData(atBag,"num",data)
				exports.dayzepoch:attachElementToBone(atBag,player,12,0,0.05,0.27,0,180,0)
				bli = createBlipAttachedTo(player,23)
				outputChatBox("#880808" .. getPlayerName(player) .. "#D3D3D3 has taken the zombie infection cure",root,255,255,255,true)
				marker = createMarker(mark[data][1],mark[data][2],mark[data][3],"cylinder",1.5,255,255,0,10,player)
				marBli = createBlipAttachedTo(marker,53,2,255,0,0,255,0,99999.0,player)
			end
		end
	end
)

function roo(ele)
	local x,y,z = getElementRotation(ele)
	setElementRotation(ele,x,y,z + 5)
end

addEventHandler("onPlayerWasted",root,
	function ()
		if getElementData(source,"bag") and getElementData(source,"bag") == true then
			local data = getElementData(atBag,"num")
			local data = tonumber(data)
			local x,y,z = getElementPosition(source)
			setElementData(source,"bag",false)
			destroyElement(atBag)
			destroyElement(marker)
			destroyElement(bli)
			destroyElement(marBli)
			ob = createObject(1210,x,y,z)
			setElementCollisionsEnabled(ob,false)
			time = setTimer(roo,100,0,ob)
			mar = createMarker(x,y,z,"corona",0.5,255,0,0,120)
			setElementData(mar,"num",data)
			bl = createBlipAttachedTo(mar,17)
		end
	end
)

addEventHandler("onMarkerHit",root,
	function (player)
		if ( source == marker ) then
			if getElementType(player) == "player" then
				setElementData(player,"bag",false)
				destroyElement(marker)
				destroyElement(marBli)
				destroyElement(bli)
				destroyElement(atBag)
				outputChatBox("#880808" .. getPlayerName(player) .. "#D3D3D3 has delivered the cure and got #88080850 #D3D3D3PHP",root,255,0,0,true)
				givePlayerMoney(player,50)
				setTimer(createBag,30000,1)
			end
		end
	end
)


addEventHandler("onPlayerQuit",root,
	function ()
		if getElementData(source,"bag") and getElementData(source,"bag") == true then
			local data = getElementData(atBag,"num")
			local data = tonumber(data)
			local x,y,z = getElementPosition(source)
			setElementData(source,"bag",false)
			destroyElement(atBag)
			destroyElement(marker)
			destroyElement(bli)
			destroyElement(marBli)
			ob = createObject(1210,x,y,z)
			setElementCollisionsEnabled(ob,false)
			time = setTimer(roo,100,0,ob)
			mar = createMarker(x,y,z,"corona",0.5,255,0,0,120)
			setElementData(mar,"num",data)
			bl = createBlipAttachedTo(mar,17)
		end
	end
)

addEventHandler("kilLDayZPlayer", root, function(killer)
	local account = getPlayerAccount(source);
	if not account then return; end
	if (killer and killer ~= source and getElementType(killer) == "player") then
		givePlayerMoney ( killer, math.random(0,3) )
	end
end);
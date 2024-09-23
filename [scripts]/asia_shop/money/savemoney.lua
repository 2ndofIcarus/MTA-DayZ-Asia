addEventHandler("onPlayerLogin", getRootElement(),
function()
	local account = getPlayerAccount(source)
	if account then
		local money = getAccountData(account, "stats.money")
		setPlayerMoney(source, money)
	end
end)
addEventHandler("onPlayerQuit", getRootElement(),
function()
	local account = getPlayerAccount(source)
	if account then
		local cash = getPlayerMoney(source)
		setAccountData(account, "stats.money", cash)
	end
end)

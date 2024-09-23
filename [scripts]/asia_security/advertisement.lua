local settings
function refreshSettings()
	settings = {
		ExcludedGroups = get"ExcludedGroups" or {},
		banTime = get"banTime" or 0,
		banPrivateChatAds = get"banPrivateChatAds" == "true",
		SerialBan = get"SerialBan" == "true",
		IPBan = get"IPBan" == "true",
		blacklistedStrings = get"blacklistedStrings" or {},
		IPv6 = get"IPv6" == "true"
	}
end

function isAdvertisement(str) -- exported
	assert(type(str) == "string", "Bad argument 1 @ isAdvertisement [String expected, got " .. type(str) .. "]")

	str = str:lower()
	for i=1, #settings.blacklistedStrings do
		if str:find(settings.blacklistedStrings[i]:lower()) then
			return true
		end
	end

	if str:find("(%d+)%.(%d+)%.(%d+)%.(%d+)") then
		return true
	end

	if settings.IPv6 then
		local chunks = {str:match(("([a-fA-F0-9]*):"):rep(8):gsub(":$","$"))}
		if #chunks == 8 then
			for i = 1, 8 do
				if #chunks[i] > 0 and tonumber(chunks[i], 16) > 65535 then return false end
			end
			return true
		end
	end
	
	return false
end

function isPlayerExcluded(player)
	local size = #settings.ExcludedGroups
	if size ~= 0 then
		local accountName = getAccountName(getPlayerAccount(player))
		for i=1, size do
			if isObjectInACLGroup("user." .. accountName, aclGetGroup(settings.ExcludedGroups[i])) then
				return true
			end
		end
	end
	return false
end

addEventHandler("onPlayerChat", root, function(msg)
	if isAdvertisement(msg) then
		outputServerLog( "ADVERT: " .. getPlayerName(source) .. ": " .. msg )
		if not isPlayerExcluded(source) then
			cancelEvent()
		end
	end
end)

addEventHandler("onPlayerPrivateMessage", root, function(msg)
	if settings.banPrivateChatAds and isAdvertisement(msg) then
		outputServerLog( "PRIVATE-ADVERT: " .. getPlayerName(source) .. ": " .. msg )
		if not isPlayerExcluded(source) then
			cancelEvent()
			outputChatBox("#880808[Warning!] #D3D3D3Promoting or engaging in advertising is strictly prohibited, and continued violation may lead to a ban.", source, 211, 211, 211,true)
		end
	end
end)

local resName = getResourceName(getThisResource())
addEventHandler("onSettingChange", root, function(setting)
	local sBeg, sEnd = setting:find("*" .. resName)
	if sBeg then
		if settings[setting:sub(sEnd + 2)] ~= nil then
			refreshSettings()
		end
	end
end)
refreshSettings()

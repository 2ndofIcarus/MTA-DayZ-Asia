local db = dbConnect("sqlite", "teams.db");
dbExec(db, "CREATE TABLE IF NOT EXISTS `teams` (name TEXT, leader TEXT, officer TEXT, trusted TEXT, slots INTEGER)");
dbExec(db, "CREATE TABLE IF NOT EXISTS `team_acc` (team TEXT, username TEXT, rank TEXT)");

addEvent("creategang", true);
addEvent("team_accept", true);
addEvent("team_decline", true);

addEvent("gang.question", true);
addEvent("gang.request:datatable", true);

TEAM_slots = 10; -- max team slots per group

invitations = {} -- invitation table list

function getPlayerGang(player)
	if player then
		local p = dbPoll(dbQuery(db, "SELECT * FROM `team_acc` WHERE `username`='"..getAccountName(getPlayerAccount(player)).."'"), -1);
		if (#p > 0) then
			for _,v in ipairs(p) do
				return v["team"];
			end
		end
	end
	return "None";
end

function doesGangExist(name)
	local p = dbPoll(dbQuery(db, "SELECT * FROM `teams`"), -1);
	if (#p > 0) then
		for _,v in ipairs(p) do
			if (v["name"] == name) then
				return true;
			end
		end
	end
	return false;
end

function getPlayersInGang(gang)
	if doesGangExist(gang) then
		local members = {};
		for _,v in ipairs(getElementsByType("player")) do
			if (getPlayerGang(v) == gang) then
				table.insert(members, v);
			end
		end
		return members;
	end
	return false;
end

function countAccountsInGang(gang)
	if gang then
		local counter = 0;
		for _,a in ipairs(getAccounts()) do
			if (getAccountData(a, "gang") == gang) then
				counter = counter + 1;
			end
		end
		return counter;
	end
	return false;
end

function getPlayerAccountFromGangName(gang,nick)
	if gang then
		for _,a in ipairs(getAccounts()) do
			if (getAccountData(a, "gang") == gang and getAccountData(a, "gang.nick") == nick) then
				return a;
			end
		end
	end
	return false;
end

function getGangEmptySlots(team)
	if team then
		if doesGangExist(team) then
			return tonumber(TEAM_slots - countAccountsInGang(team));
		end
	end
	return false;
end

function deletePlayerInvite(player,theteam)
	for i, k in pairs(invitations) do
		if k[1] == player and k[2] == theteam then
			k[1] = nil
			k[2] = nil
			return true
		end
	end
end

function isPlayerGangInvited(thePlayer)
    for i, k in pairs(invitations) do
    	if k[1] == player then
        	return true, k[1], k[2] -- k[1]=player,k[2]=team
    	end
    end
end

function getGangList()
	local teams = dbPoll(dbQuery(db, "SELECT * FROM `teams`"), -1)
	if (#teams > 0) then
		return teams;
	end
end

function getPlayersFromGangss(team,row)
	if (team) then
		players = countAccountsInGang(team)
		triggerClientEvent(client,"getInfoCellBackss",client,players,row)
	end
end
addEvent("getPlayersFromGangss",true)
addEventHandler("getPlayersFromGangss",root,getPlayersFromGangss)

function receiveTeamList()
	local teams = getGangList();
	if (teams) then
		triggerClientEvent(client,"recieveTeamList",client,teams)
	end
end
addEvent("receiveTeamList",true)
addEventHandler("receiveTeamList",root,receiveTeamList)

function inviteToTeam(player, team)
	if (player and team) then
		if (getGangEmptySlots(team) >= 1) then
			if (getElementData(player,"gangteams."..team) ~= "Yes") then
				outputChatBox("#D3D3D3You have been invited to join team #008B8B"..team.."#D3D3D3. Press #008B8BF6#D3D3D3 to accept invitation!", player, 0, 0, 0, true);
				setElementData(player, "gangteams."..team, "Yes");
				table.insert(invitations,{player,team})
				triggerClientEvent(client, "gang.refreshInviteList", client);
			else
				setElementData(player, "gangteams."..team, "No");
				deletePlayerInvite(client,team)
				triggerClientEvent(client, "gang.refreshInviteList", client);
			end
		end
	end
end

function outputTeamChat(text, team)
	if team then
		for _,v in ipairs(getPlayersInGang(team)) do
			outputChatBox("#008B8B["..team.."] #D3D3D3 "..text:gsub("#%x%x%x%x%x%x", ""), v, 255, 255, 255, true);
		end
	end
end

function doesPlayerHaveGang(player)
	if player then
		local q = dbPoll(dbQuery(db, "SELECT * FROM `team_acc` WHERE `username`='"..getAccountName(getPlayerAccount(player)).."'"), -1);
		if (#q > 0) then
			return true;
		end
	end
	return false;
end

function getPlayerGangRank(player)
	if player then
		local p = dbPoll(dbQuery(db, "SELECT * FROM `team_acc` WHERE `username`='"..getAccountName(getPlayerAccount(player)).."'"), -1);
		if (#p > 0) then
			for _,v in ipairs(p) do
				return v["rank"];
			end
		end
	end
	return false;
end

function getAccountGangRank(account)
	if account then
		local p = dbPoll(dbQuery(db, "SELECT * FROM `team_acc` WHERE `username`='"..account.."'"), -1);
		if (#p > 0) then
			for _,v in ipairs(p) do
				return v["rank"];
			end
		end
	end
	return false;
end

function gangUpdate(team)
	for _,v in ipairs(getPlayersInGang(team)) do
		triggerClientEvent(v, "gang.update:client", v);
	end
end

function getTeamLeader(team)
    if doesGangExists(team) then
        local data = dbPoll(dbQuery(db, "SELECT * FROM `leader` WHERE `name`='" .. tostring(team) .. "'"))
        return tostring(data[1].gang_leader)
    else
        return false;
    end
end

addEventHandler("creategang", root, function(player,teamname)
	local name = table.concat({teamname} , " "):gsub("#%x%x%x%x%x%x", "");
	if not doesPlayerHaveGang(player) then
		if name then
			if (#name >= 3 and #name <= 12) then
				if not doesGangExist(name) then
					player_money  = getPlayerMoney(source)
					if player_money >= 100 then
						local acc = getPlayerAccount(player);
						dbExec(db, "INSERT INTO `teams` (name, leader, officer, trusted, slots) VALUES(?,?,?,?,?)", name, getAccountName(acc), "", "", TEAM_slots);
						dbExec(db, "INSERT INTO `team_acc` (team, username, rank) VALUES(?,?,?)", name, getAccountName(acc), "Leader");
						setElementData(player, "gang", name);
						setElementData(player, "gang.rank", "Leader");
						setElementData(player, "gang.nick", getPlayerName(player));
						takePlayerMoney(source, 100)	
						setAccountData(acc, "gang", name);
						setAccountData(acc, "gang.nick", getPlayerName(player));
						outputChatBox("#D3D3D3Your team #008B8B"..name.." #D3D3D3has been created, press #008B8B[F6] #D3D3D3to manage it.", player, 0, 255, 0, true);
						triggerClientEvent(client, "gang.close", client);
					else
						outputChatBox("You don't have enough money (PHP)!", player, 136,8,8, true);
					end
				else
					outputChatBox("Sorry but the name (#008B8B"..name.."#880808) is taken. Please try another one.", player, 136,8,8, true);
				end
			else
				outputChatBox("Name must be between 3 and 12 characters long", player, 136,8,8, true);
			end
		end
	else
		outputChatBox("You already have a team (#008B8B"..getPlayerGang(player).."#880808).", player, 136,8,8, true);
	end
end);

addCommandHandler("teamchat", function(player, _, ...)
	local team = getPlayerGang(player);
	local msg = table.concat({...} , " "):gsub("#%x%x%x%x%x%x", "");
	if (team ~= "None") then
		if isPlayerMuted(player) then
			outputChatBox(getLanguageTextServer("clientinfotext43",player), player, 136,8,8);
			return;
		end
		if (getElementData(player,"antichat")) then
			outputChatBox(getLanguageTextServer("clientinfotext41",player), player, 136,8,8);
			return;
		else
			setElementData(player,"antichat",true)
			setTimer(setElementData, 1000, 1, player, "antichat", false);
		end
		for _,v in pairs(getPlayersInGang(team)) do
			outputChatBox("#008B8B[Group - "..getElementData(player, "gang.rank").."] #D3D3D3"..getPlayerName(player):gsub("#%x%x%x%x%x%x", "")..": #D3D3D3"..msg, v, 255, 255, 255, true);
		end
	end
end);

addEventHandler("onPlayerLogin", root, function(pa, acc, se)
	local team = getPlayerGang(source);
	if (team ~= "None") then
		setElementData(source, "gang", team);
		setElementData(source, "gang.rank", getPlayerGangRank(source));
		setAccountData(acc, "gang.nick", getPlayerName(source));
	end
end);

addEventHandler("team_accept", root, function(player,theteam)
	if theteam then
		removeElementData(player, "gangteams."..theteam);
		setElementData(player, "gang", theteam);
		setElementData(player, "gang.rank", "Member");
		local acc = getPlayerAccount(player);
		setAccountData(acc, "gang", theteam);
		setAccountData(acc, "gang.nick", getPlayerName(player));
		dbExec(db, "INSERT INTO `team_acc` (team, username, rank) VALUES(?,?,?)", theteam, getAccountName(acc), "Member");
		outputTeamChat(getPlayerName(player):gsub("#%x%x%x%x%x%x", "").." joined the team", theteam);
		gangUpdate(theteam);
		deletePlayerInvite(client,theteam)
		triggerClientEvent(player, "gang.refreshInviteList", player);
		triggerClientEvent(player, "gang.close", player);
	end
end);

addEventHandler("team_decline", root, function(player,theteam)
	if theteam then
		outputChatBox("#880808You declined the invitation from team #008B8B"..theteam, player, 255, 255, 255, true);
		deletePlayerInvite(client,theteam)
		triggerEvent("refreshPlayerInvite",player)
		gangUpdate(theteam);
	end
end);

addEventHandler("gang.question", root, function(intention, player, nick)
	local account = getPlayerAccountFromGangName(getElementData(client,"gang"),nick);
	if (intention == "leave") then
		local team = getPlayerGang(client);
		local rank = getPlayerGangRank(client);
		if (rank == "Trusted") then
			dbExec(db, "UPDATE `teams` SET `trusted`=? WHERE `name`='"..team.."'", "");
		elseif (rank == "Officer") then
			dbExec(db, "UPDATE `teams` SET `officer`=? WHERE `name`='"..team.."'", "");
		end
		outputTeamChat(getPlayerName(client).." left the team.", team);
		removeElementData(client, "gang");
		removeElementData(client, "gang.rank");
		local acc = getPlayerAccount(client);
		setAccountData(acc, "gang", nil);
		setAccountData(acc, "gang.nick", nil);
		dbExec(db, "DELETE FROM `team_acc` WHERE `username`=?", getAccountName(acc));
		gangUpdate(team);
		deletePlayerInvite(player)
		triggerClientEvent(client, "gang.close", client);
	elseif (intention == "kick") then
		local team = getPlayerGang(client);
		if isElement(player) and getPlayerName(player) then
			outputTeamChat(getPlayerName(player).." was kicked from the team by "..getPlayerName(client), team);
			removeElementData(player, "gang");
			removeElementData(player, "gang.rank");
			local acc = getPlayerAccount(player);
			setAccountData(acc, "gang", nil);
			setAccountData(acc, "gang.nick", nil);
			dbExec(db, "DELETE FROM `team_acc` WHERE `username`=?", getAccountName(acc));
		else
			outputTeamChat(getAccountName(account).." was kicked from the team by "..getPlayerName(client), team);
			setAccountData(account, "gang", nil);
			setAccountData(account, "gang.nick", nil);
			dbExec(db, "DELETE FROM `team_acc` WHERE `username`=?", getAccountName(account));
		end
		gangUpdate(team);
	elseif (intention == "invite") then
		local gang = getPlayerGang(client);
		if (getGangEmptySlots(gang) >= 1) then
			inviteToTeam(player, gang);
		else
			outputChatBox("Your team is full "..TEAM_slots.."/"..TEAM_slots.." players.", client, 136,8,8, true);
		end
	elseif (intention == "disband_team") then
		if (players > 1) then
			outputChatBox("You must kick everyone in your team in order to disband.", client, 136,8,8, true);
		else
			local team = getPlayerGang(client);
		for _,v in pairs(getPlayersInGang(team)) do
			removeElementData(v, "gang");
			removeElementData(v, "gang.rank");
			triggerClientEvent(v, "gang.close", v);
		end
		for _,v in pairs(getAccounts()) do
			if (getAccountData(v, "gang") == team) then
				setAccountData(v, "gang", nil);
				setAccountData(v, "gang.nick", nil);
			end
		end
		dbExec(db, "DELETE FROM `team_acc` WHERE `team`=?", team);
		dbExec(db, "DELETE FROM `teams` WHERE `name`=?", team);
		outputChatBox("#D3D3D3Your team #008B8B"..team.."#D3D3D3 has been disbanded", client, 255, 25, 0, true);
		end
	elseif (intention == "set_member") then
		local team = getPlayerGang(client);
		if isElement(player) and getPlayerName(player) then
			setElementData(player, "gang.rank", "Member");
			dbExec(db, "UPDATE `teams` SET `trusted`=? WHERE `name`='"..team.."'", "");
			dbExec(db, "UPDATE `teams` SET `officer`=? WHERE `name`='"..team.."'", "");
			dbExec(db, "UPDATE `team_acc` SET `rank`=? WHERE `username`=?", "Member", getAccountName(getPlayerAccount(player)));
			outputTeamChat(getPlayerName(player).." rank now is Member.", team);
			triggerClientEvent(player, "gang.close", player);
		else
			dbExec(db, "UPDATE `teams` SET `trusted`=? WHERE `name`='"..team.."'", "");
			dbExec(db, "UPDATE `teams` SET `officer`=? WHERE `name`='"..team.."'", "");
			dbExec(db, "UPDATE `team_acc` SET `rank`=? WHERE `username`=?", "Member", getAccountName(account));
			outputTeamChat(getAccountData(account,"gang.nick").." rank now is Member.", team);
		end
		gangUpdate(team);
	elseif (intention == "set_trusted") then
		local team = getPlayerGang(client);
		if isElement(player) and getPlayerName(player) then
			local accName = getAccountName(getPlayerAccount(player))
			setElementData(player, "gang.rank", "Trusted");
			dbExec(db, "UPDATE `teams` SET `trusted`=? WHERE `name`='"..team.."'", accName);
			dbExec(db, "UPDATE `teams` SET `officer`=? WHERE `name`='"..team.."'", "");
			dbExec(db, "UPDATE `team_acc` SET `rank`=? WHERE `username`=?", "Trusted", accName);
			outputTeamChat(getPlayerName(player).." rank now is Trusted.", team);
		else
			dbExec(db, "UPDATE `teams` SET `trusted`=? WHERE `name`='"..team.."'", getAccountName(account));
			dbExec(db, "UPDATE `teams` SET `officer`=? WHERE `name`='"..team.."'", "");
			dbExec(db, "UPDATE `team_acc` SET `rank`=? WHERE `username`=?", "Trusted", getAccountName(account));
			outputTeamChat(getAccountData(account,"gang.nick").." rank now is Trusted.", team);
		end
		gangUpdate(team);
	elseif (intention == "set_officer") then
		local team = getPlayerGang(client);
		if isElement(player) and getPlayerName(player) then
			local accName = getAccountName(getPlayerAccount(player))
			setElementData(player, "gang.rank", "Officer");
			dbExec(db, "UPDATE `teams` SET `trusted`=? WHERE `name`='"..team.."'", "");
			dbExec(db, "UPDATE `teams` SET `officer`=? WHERE `name`='"..team.."'", accName);
			dbExec(db, "UPDATE `team_acc` SET `rank`=? WHERE `username`=?", "Officer", accName);
			outputTeamChat(getPlayerName(player).." rank now is Officer.", team);
		else
			dbExec(db, "UPDATE `teams` SET `trusted`=? WHERE `name`='"..team.."'", "");
			dbExec(db, "UPDATE `teams` SET `officer`=? WHERE `name`='"..team.."'", getAccountName(account));
			dbExec(db, "UPDATE `team_acc` SET `rank`=? WHERE `username`=?", "Officer", getAccountName(account));
			outputTeamChat(getAccountData(account,"gang.nick").." rank now is Officer.", team);
		end
		gangUpdate(team);
	end
end);

function refreshPlayerInvite(player)
    if not getElementData(source,"gang") == "None" then return end
    triggerClientEvent(source,"updatePlayerInvites",source,invitations)
end
addEvent("refreshPlayerInvite",true)
addEventHandler("refreshPlayerInvite",getRootElement(),refreshPlayerInvite)

addEventHandler("gang.request:datatable", root, function()
	local team = getPlayerGang(client);
	local offdata = {};
	for _,v in pairs(getAccounts()) do
		if (getAccountData(v, "gang") == team) then
			if (getAccountPlayer(v) ~= false) then
				state = 1;
			else
				state = 0;
			end
			table.insert(offdata, 1, {getAccountData(v, "gang.nick"), getAccountGangRank(getAccountName(v)), state});
		end
	end
	triggerClientEvent(client, "gang.recive:datatable", client, offdata);
end);
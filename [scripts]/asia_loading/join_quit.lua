g_Root = getRootElement()


addEventHandler('onPlayerJoin',g_Root,
function ()
    outputChatBox('#880808'..getPlayerName(source)..'#D3D3D3 joined the server.', getRootElement(), 255, 255, 255, true)
    end
)

 
addEventHandler('onPlayerQuit', g_Root,
    function(reason)
        outputChatBox('#D3D3D3[#880808' .. reason .. '#D3D3D3] #880808 ' .. getPlayerName(source) .. ' #D3D3D3 left the server.', getRootElement(), 255, 255, 255, true)
    end
)


-- Check if a nick is too long
addEventHandler( "onPlayerChangeNick", root,
	    function ( oldNick, newNick )
                if (string.find(newNick,"#%x%x%x%x%x%x")) or (string.find(newNick,"#")) then
                    cancelEvent()
			        outputChatBox("#880808[Warning!] #D3D3D3Your new nickname has a hex value.", source, 211, 211, 211,true)
                elseif ( string.len ( newNick ) < 4 ) or ( string.len ( newNick ) > 15 ) then
                    cancelEvent()
			        outputChatBox("#880808[Warning!] #D3D3D3Your new nickname is either too short, too long.", source, 211, 211, 211,true)
			        setPlayerName ( source, oldNick )
                else
                    outputChatBox('#880808' .. oldNick ..'#D3D3D3 changed their nickname to #880808' .. newNick, getRootElement(), 255, 255, 255, true)
                end
end)   




----///// anti color code & long name /////-----

-- Check the nick on connect
addEventHandler ( "onPlayerConnect", root,
    function ( playerNick, playerIP, playerUsername, playerSerial, playerVersionNumber )
        if ( playerNick == "Player" ) or ( playerNick == "player" ) then
        cancelEvent( true, "The nickname \"Player\" is not allowed, please change it to something else. You can change your nick in Settings menu Multiplayer tab." )
        elseif ( string.len ( playerNick ) > 18 ) then
		cancelEvent( true, "Your nickname is to long, please change it to something else. You can change your nick in Settings menu Multiplayer tab." )
        elseif ( string.len ( playerNick ) < 4 ) then
            cancelEvent( true, "Your nickname is to short, please change it to something else. You can change your nick in Settings menu Multiplayer tab." )
        elseif (string.find(playerNick,"#%x%x%x%x%x%x")) or (string.find(playerNick,"#")) then
            cancelEvent( true, "Using hex or color in your name is not allowed. please change it to something else. You can change your nick in Settings menu Multiplayer tab." )
        end
    end
)
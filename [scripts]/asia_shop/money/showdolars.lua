addEventHandler("onClientResourceStart", resourceRoot,
    function()    
    end
)
addEventHandler("onClientRender", root,
    function()
        if getElementData(localPlayer, "logedin") then
			local cash = getPlayerMoney( getLocalPlayer() )
			if (getElementData(localPlayer,"setting.servertheme") == 1) then -- (brown)
				dxDrawText("PHP",   855,   22,  688, 128, tocolor(142, 109, 75, 200), 0.50, "bankgothic", "left", "top", false, false, false, false, false)
			elseif (getElementData(localPlayer,"setting.servertheme") == 2) then -- (blue)
				dxDrawText("PHP",   855,   22,  688, 128, tocolor(84, 135, 177, 200), 0.50, "bankgothic", "left", "top", false, false, false, false, false)
			elseif (getElementData(localPlayer,"setting.servertheme") == 3) then -- (green)
				dxDrawText("PHP",   855,   22,  688, 128, tocolor(160, 209, 92, 200), 0.50, "bankgothic", "left", "top", false, false, false, false, false)
			end
			dxDrawText(""..cash,  920,22,796,123, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "left", "top", false, false, false, false, false)
        end
    end
)
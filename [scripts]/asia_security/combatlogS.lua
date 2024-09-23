---------------------------------------------------------------
---------------------------------------------------------------
--* Skype: guigoka                                              
---------------------------------------------------------------

function sexovaginal(quitType)
     if quitType == "Quit" or quitType == "Timed out" then
       local antirelogtimer = getElementData ( source, "antiRelogWork" )
       if antirelogtimer then
        local acon = getPlayerAccount(source)
         if (acon) then
         setAccountData(acon,'blood',-5)
         setAccountData ( acon, "antiRelogWork", false )
         end 
       end 
     end
end
--addEvent( "sexoatempo", true )
addEventHandler ( "onPlayerQuit", getRootElement(), sexovaginal )

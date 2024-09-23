
        local screenW, screenH = guiGetScreenSize()
        helpwindow = guiCreateWindow((screenW - 746) / 2, (screenH - 441) / 2, 746, 441, "Help Panel", false)
        guiWindowSetSizable(helpwindow, false)
        guiSetVisible(helpwindow, false)

        helpmemo = guiCreateMemo(205, 30, 531, 401, 
        "Main Commands\n- F1 - Help Panel\n- F2 - Settings Panel\n- F6 - Group Panel\n- T - Local Chat\n- Y - Team Chat\n- U - Global Chat\n- X - Glue to vehicles\n- Shift - Secure yourself to helicopters when in proximity.\n- Backspace - Release yourself from the helicopter.\n\nAnimation Commands\n- L - Prone\n- , - Sit\n- . - Raise Hands\n- ; - Shout - Friendly\n\nConsole Commands\n- /give playerName Amount (gives player money) - Example /give MischiefPlayer2 900\n- /kill - Take suicide or Kill yourself.\n- /report - Report Bugs/Players/Suggestions.\n- /grab - Secure yourself to helicopters when in proximity.\n- /drop - Release yourself from the helicopter."
        , false, helpwindow)
        guiMemoSetReadOnly(helpmemo, true)


        rulesbtn = guiCreateButton(9, 30, 186, 38, "Rules", false, helpwindow)
        guiSetProperty(rulesbtn, "NormalTextColour", "FFAAAAAA")
        commandsbtn = guiCreateButton(9, 78, 186, 38, "Commands", false, helpwindow)
        guiSetProperty(commandsbtn, "NormalTextColour", "FFAAAAAA")
        infbtn = guiCreateButton(9, 126, 186, 38, "Information", false, helpwindow)
        guiSetProperty(infbtn, "NormalTextColour", "FFAAAAAA")
        staffbtn = guiCreateButton(9, 174, 186, 38, "Admins Roster", false, helpwindow)
        guiSetProperty(staffbtn, "NormalTextColour", "FFAAAAAA")    


    function rules ()
        rulestxt = fileOpen("Rules.txt", true)
        rulestxt1 = fileRead(rulestxt, 50000)
        guiSetText(helpmemo, rulestxt1)
     end
        addEventHandler("onClientGUIClick", rulesbtn, rules)
        
     function commands ()
        rulestxt = fileOpen("Commands.txt", true)
        rulestxt1 = fileRead(rulestxt, 50000)
        guiSetText(helpmemo, rulestxt1)
    end
        addEventHandler("onClientGUIClick", commandsbtn, commands)
        
     function information ()
        rulestxt = fileOpen("Information.txt", true)
        rulestxt1 = fileRead(rulestxt, 50000)
        guiSetText(helpmemo, rulestxt1)
    end
        addEventHandler("onClientGUIClick", infbtn, information)
        
    function admins ()
        rulestxt = fileOpen("Admins.txt", true)
        rulestxt1 = fileRead(rulestxt, 50000)
        guiSetText(helpmemo, rulestxt1)
    end
        addEventHandler("onClientGUIClick", staffbtn, admins)






bindKey('F1','down',
        function()
        local menu = helpwindow
        guiSetVisible(menu, not guiGetVisible(menu))
        showCursor(not isCursorShowing())
        end
        )
        
    

    



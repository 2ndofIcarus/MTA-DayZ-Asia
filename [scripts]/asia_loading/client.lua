local sx, sy = guiGetScreenSize()
local px, py = sx/1920, sy/1080

local sound = false
local active = false

local function drawCurrentImage()
	if isTransferBoxActive() then
		active = true
		showChat(false)
		dxDrawImage(0, 0, 1920*px, 1080*py, "files/background.jpg")
		if not sound then
			sound = playSound("files/loading.mp3", true)
			setSoundVolume(sound, 0.2)
		end
	else
		if active then
			active = false
			removeEventHandler("onClientRender", root, drawCurrentImage)
		end
		if sound then
			stopSound(sound)
		end
	end
end

local function render()
	addEventHandler("onClientRender", root, drawCurrentImage)
end
addEventHandler("onClientResourceStart", resourceRoot, render)

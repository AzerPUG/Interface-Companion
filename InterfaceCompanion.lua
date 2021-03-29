local InterfaceCompanion = {}
local InterfaceCompanionFrame = CreateFrame("Frame", nil, UIParent)

function InterfaceCompanion:OnLoad()
    InterfaceCompanionFrame:SetSize(500, 500)
    InterfaceCompanionFrame:SetPoint("CENTER", -400, -100)
    InterfaceCompanionFrame:Show()

    CompanionModel = CreateFrame("PlayerModel", nil, InterfaceCompanionFrame)
    CompanionModel:Hide()
    CompanionModel:SetSize(200, 200)
    CompanionModel:SetPoint("CENTER")
    CompanionModel:SetPosition(-0.25, 0, 0)
    --CompanionModel:SetCustomCamera(1)
    --CompanionModel:SetCameraPosition(0, 0, 0.5)
    CompanionModel.x, CompanionModel.y, CompanionModel.z = 0, 0, 0
    CompanionModel.deltaX = 0
    CompanionModel.texture = CompanionModel:CreateTexture()
    CompanionModel.texture:Hide()
    CompanionModel.texture:SetAllPoints()
    CompanionModel:EnableMouse(true)
    CompanionModel:SetMovable(true)
    CompanionModel:SetResizable(true)
    CompanionModel:RegisterForDrag("LeftButton")
    CompanionModel:SetScript("OnDragStart", CompanionModel.StartMoving)
    CompanionModel:SetScript("OnDragStop", CompanionModel.StopMovingOrSizing)
    
    CompanionModel:Show()
    
    InterfaceCompanionFrame:SetScript("OnEvent", function(...) InterfaceCompanion:OnEvent(...) end)
    InterfaceCompanionFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	--:RegisterEvent("CINEMATIC_STOP")
	--:RegisterEvent("SCREENSHOT_SUCCEEDED")

    --InterfaceCompanion:LoadModel()
end

function InterfaceCompanion:LoadModel()
    --CompanionModel.texture:SetTexture("Character\\NightElf\\Female\\NightElfFemale.m2")
    --CompanionModel:SetModel("Interface\\Buttons\\TalkToMeQuestionMark_new.m2") --THIS WORKS!!
    InterfaceCompanion:DelayedExecution(5,
        function()
            --CompanionModel:SetModel("Interface\\Buttons\\TalkToMeQuestionMark_journey.m2")
            --CompanionModel:SetModel("Interface\\Buttons\\TalkToMeQuestionMark_new.m2") --THIS WORKS!!
            CompanionModel:SetCreature(86470) -- THIS WORKS == PEPE
            --CompanionModel:SetCreature(88807) -- THIS WORKS == ARGI
            --CompanionModel:SetItem(179339)
            --CompanionModel:SetModel(161509)
        end
    )
    --CompanionModel:SetModel("Interface\\Buttons\\TalkToMeQuestionMark_journey.m2")
    --CompanionModel:SetModel("World\\Expansion05\\doodads\\human\\doodads\\6hu_garrison_orangebird_var5.mdx")
    --CompanionModel:SetModel([[Interface\Buttons\TalkToMeQuestionMark.m2]]) --THIS WORKS!!
    --CompanionModel:SetModel([[World\Expansion05\doodads\human\doodads\6hu_garrison_orangebird.m2]])
    --CompanionModel:SetModel([[Character\NightElf\Female\NightElfFemale.m2]])
    --CompanionModel:SetModel("Character\\NightElf\\Female\\NightElfFemale.m2")
    --CompanionModel:SetItem(128827) --THIS WORKS!!
    --CompanionModel:SetModel("World/expansion05/doodads/ORC/DOODADS/6hu_garrison_orangebird.mdx") -- test both .mdx and .m2
end

function InterfaceCompanion:DelayedExecution(delayTime, delayedFunction)
	local frame = CreateFrame("Frame")
	frame.start_time = GetServerTime()
	frame:SetScript("OnUpdate", 
		function(self)
			if GetServerTime() - self.start_time > delayTime then
				delayedFunction()
				self:SetScript("OnUpdate", nil)
				self:Hide()
			end
		end
	)
	frame:Show()
end

function InterfaceCompanion:OnEvent(self, event, ...)
    print("PepeTest 1")
    if event == "PLAYER_ENTERING_WORLD" then
        print("PepeTest 2")
        InterfaceCompanion:LoadModel()
    end
end

InterfaceCompanion:OnLoad()
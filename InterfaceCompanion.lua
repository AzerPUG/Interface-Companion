if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end
if AZP.OnLoad == nil then AZP.OnLoad = {} end
if AZP.OnEvent == nil then AZP.OnEvent = {} end
if AZP.OnEvent == nil then AZP.OnEvent = {} end

AZP.VersionControl.InterfaceCompanion = 18
AZP.InterfaceCompanion = {}

local InterfaceCompanionFrame = CreateFrame("Frame", nil, UIParent)
local CompanionModel = nil

local AZPICSelfOptionPanel = nil

if AZPICCompanionFrameLocation == nil then AZPICCompanionFrameLocation = {"CENTER", 0, 0} end
if AZPICLockedAndHidden == nil then AZPICLockedAndHidden = {false, false} end

function AZP.OnLoad:InterfaceCompanion()
    InterfaceCompanionFrame:SetSize(250, 250)
    InterfaceCompanionFrame:RegisterForDrag("LeftButton")
    InterfaceCompanionFrame:SetScript("OnDragStart", InterfaceCompanionFrame.StartMoving)
    InterfaceCompanionFrame:SetScript("OnDragStop", function() InterfaceCompanionFrame:StopMovingOrSizing() AZP.InterfaceCompanion:SaveLocation() end)

    CompanionModel = CreateFrame("PlayerModel", nil, InterfaceCompanionFrame)
    CompanionModel:Hide()
    CompanionModel:SetSize(200, 200)
    CompanionModel:SetPosition(-0.25, 0, 0)
    CompanionModel:SetPoint("CENTER", 0, 0)
    CompanionModel.x, CompanionModel.y, CompanionModel.z = 0, 0, 0
    CompanionModel.deltaX = 0
    CompanionModel.texture = CompanionModel:CreateTexture()
    CompanionModel.texture:Hide()
    CompanionModel.texture:SetAllPoints()
    CompanionModel:Show()

    InterfaceCompanionFrame:SetScript("OnEvent", function(...) AZP.InterfaceCompanion:OnEvent(...) end)
    InterfaceCompanionFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    InterfaceCompanionFrame:RegisterEvent("VARIABLES_LOADED")

    AZPICSelfOptionPanel = CreateFrame("FRAME", nil)
    AZPICSelfOptionPanel.name = "|cFF00FFFFInterface Companion|r"
    InterfaceOptions_AddCategory(AZPICSelfOptionPanel)
    AZPICSelfOptionPanel.header = AZPICSelfOptionPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    AZPICSelfOptionPanel.header:SetPoint("TOP", 0, -10)
    AZPICSelfOptionPanel.header:SetText("|cFF00FFFFAzerPUG's Interface Companion Options!|r")

    AZPICSelfOptionPanel.footer = AZPICSelfOptionPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    AZPICSelfOptionPanel.footer:SetPoint("TOP", 0, -300)
    AZPICSelfOptionPanel.footer:SetText(
        "|cFF00FFFFAzerPUG Links:\n" ..
        "Website: www.azerpug.com\n" ..
        "Discord: www.azerpug.com/discord\n" ..
        "Twitch: www.twitch.tv/azerpug\n|r"
    )
    AZP.InterfaceCompanion:FillOptionsPanel(AZPICSelfOptionPanel)
end

function AZP.InterfaceCompanion:FillOptionsPanel(frameToFill)
    frameToFill.LockMoveButton = CreateFrame("Button", nil, frameToFill, "UIPanelButtonTemplate")
    frameToFill.LockMoveButton:SetSize(100, 25)
    frameToFill.LockMoveButton:SetPoint("TOP", -60, -100)
    frameToFill.LockMoveButton:SetText("Lock Companion")
    frameToFill.LockMoveButton:SetScript("OnClick", function ()
        if InterfaceCompanionFrame:IsMovable() then
            InterfaceCompanionFrame:EnableMouse(false)
            InterfaceCompanionFrame:SetMovable(false)
            frameToFill.LockMoveButton:SetText("Move Companion!")
            AZPICLockedAndHidden[1] = true
        else
            InterfaceCompanionFrame:EnableMouse(true)
            InterfaceCompanionFrame:SetMovable(true)
            frameToFill.LockMoveButton:SetText("Lock Companion")
            AZPICLockedAndHidden[1] = false
        end
    end)

    frameToFill.ShowHideButton = CreateFrame("Button", nil, frameToFill, "UIPanelButtonTemplate")
    frameToFill.ShowHideButton:SetSize(100, 25)
    frameToFill.ShowHideButton:SetPoint("TOP", 60, -100)
    frameToFill.ShowHideButton:SetText("Hide Companion!")
    frameToFill.ShowHideButton:SetScript("OnClick", function ()
        if InterfaceCompanionFrame:IsShown() then
            InterfaceCompanionFrame:Hide()
            frameToFill.ShowHideButton:SetText("Show Companion!")
            AZPICLockedAndHidden[2] = true
        else
            InterfaceCompanionFrame:Show()
            frameToFill.ShowHideButton:SetText("Hide Companion!")
            AZPICLockedAndHidden[2] = false
        end
    end)

    frameToFill:Hide()
end

function AZP.InterfaceCompanion:SaveLocation()
    local temp = {}
    temp[1], temp[2], temp[3], temp[4], temp[5] = InterfaceCompanionFrame:GetPoint()
    AZPICCompanionFrameLocation = temp
end

function AZP.InterfaceCompanion:LoadLocation()
    InterfaceCompanionFrame:SetPoint(AZPICCompanionFrameLocation[1], AZPICCompanionFrameLocation[4], AZPICCompanionFrameLocation[5])
end

function AZP.InterfaceCompanion:LoadVariables()
    if AZPICLockedAndHidden[1] then
        AZPICSelfOptionPanel.LockMoveButton:SetText("Move Companion!")
        InterfaceCompanionFrame:EnableMouse(false)
        InterfaceCompanionFrame:SetMovable(false)
    else
        AZPICSelfOptionPanel.LockMoveButton:SetText("Lock Companion!")
        InterfaceCompanionFrame:EnableMouse(true)
        InterfaceCompanionFrame:SetMovable(true)
    end

    if AZPICLockedAndHidden[2] then
        InterfaceCompanionFrame:Hide()
        AZPICSelfOptionPanel.ShowHideButton:SetText("Show Companion!")
    else
        InterfaceCompanionFrame:Show()
        AZPICSelfOptionPanel.ShowHideButton:SetText("Hide Companion!")
    end
end

function AZP.InterfaceCompanion:LoadModel()
    AZP.InterfaceCompanion:DelayedExecution(5,
        function()
            CompanionModel:SetCreature(86470)
        end
    )
end

function AZP.InterfaceCompanion:DelayedExecution(delayTime, delayedFunction)
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

function AZP.InterfaceCompanion:OnEvent(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        AZP.InterfaceCompanion:LoadModel()
    elseif event == "VARIABLES_LOADED" then
        AZP.InterfaceCompanion:LoadLocation()
        AZP.InterfaceCompanion:LoadVariables()
    end
end

AZP.OnLoad:InterfaceCompanion()
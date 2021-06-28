if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end

AZP.VersionControl["Interface Companion"] = 7
if AZP.InterfaceCompanion == nil then AZP.InterfaceCompanion = {} end
if AZP.InterfaceCompanion.Events == nil then AZP.InterfaceCompanion.Events = {} end

local InterfaceCompanionFrame = CreateFrame("Frame", nil, UIParent)
local CompanionModel = nil
local EventFrame, UpdateFrame = {}, {}

local AZPICSelfOptionPanel = nil
local optionPanel = nil
local optionHeader = "|cFF00FFFFInterface Companion|r"

local HaveShowedUpdateNotification = false

if AZPICCompanionFrameLocation == nil then AZPICCompanionFrameLocation = {"CENTER", 0, 0} end
if AZPICLockedAndHidden == nil then AZPICLockedAndHidden = {false, false, false} end

function AZP.InterfaceCompanion:OnLoadBoth()
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
end

function AZP.InterfaceCompanion:OnLoadCore()
    AZP.InterfaceCompanion:OnLoadBoth()

    AZP.Core:RegisterEvents("PLAYER_ENTERING_WORLD", function(...) AZP.InterfaceCompanion:LoadModel(...) end)
    AZP.Core:RegisterEvents("VARIABLES_LOADED", function(...) AZP.InterfaceCompanion.Events:VariablesLoaded(...) end)
    AZP.Core:RegisterEvents("GROUP_ROSTER_UPDATE", function(...) AZP.InterfaceCompanion.Events:GroupRosterUpdate(...) end)

    AZP.OptionsPanels:RemovePanel("Interface Companion")
    AZP.OptionsPanels:Generic("Interface Companion", optionHeader, function(frame)
        AZP.InterfaceCompanion:FillOptionsPanel(frame)
    end)
end

function AZP.InterfaceCompanion:OnLoadSelf()
    C_ChatInfo.RegisterAddonMessagePrefix("AZPVERSIONS")

    EventFrame = CreateFrame("FRAME", nil)
    EventFrame:RegisterEvent("CHAT_MSG_ADDON")
    EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    EventFrame:RegisterEvent("VARIABLES_LOADED")
    EventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
    EventFrame:SetScript("OnEvent", function(...) AZP.InterfaceCompanion:OnEvent(...) end)

    UpdateFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    UpdateFrame:SetPoint("CENTER", 0, 250)
    UpdateFrame:SetSize(400, 200)
    UpdateFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    UpdateFrame:SetBackdropColor(0.25, 0.25, 0.25, 0.80)
    UpdateFrame.header = UpdateFrame:CreateFontString("UpdateFrame", "ARTWORK", "GameFontNormalHuge")
    UpdateFrame.header:SetPoint("TOP", 0, -10)
    UpdateFrame.header:SetText("|cFFFF0000AzerPUG's Interface Companion is out of date!|r")

    UpdateFrame.text = UpdateFrame:CreateFontString("UpdateFrame", "ARTWORK", "GameFontNormalLarge")
    UpdateFrame.text:SetPoint("TOP", 0, -40)
    UpdateFrame.text:SetText("Error!")

    UpdateFrame:Hide()

    local UpdateFrameCloseButton = CreateFrame("Button", nil, UpdateFrame, "UIPanelCloseButton")
    UpdateFrameCloseButton:SetWidth(25)
    UpdateFrameCloseButton:SetHeight(25)
    UpdateFrameCloseButton:SetPoint("TOPRIGHT", UpdateFrame, "TOPRIGHT", 2, 2)
    UpdateFrameCloseButton:SetScript("OnClick", function() UpdateFrame:Hide() end )

    AZPICSelfOptionPanel = CreateFrame("FRAME", nil)
    AZPICSelfOptionPanel.name = optionHeader
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
    AZP.InterfaceCompanion:OnLoadBoth()
end

function AZP.InterfaceCompanion:FillOptionsPanel(frameToFill)
    optionPanel = frameToFill
    frameToFill.LockMoveButton = CreateFrame("Button", nil, frameToFill, "UIPanelButtonTemplate")
    frameToFill.LockMoveButton:SetSize(100, 25)
    frameToFill.LockMoveButton:SetPoint("TOP", -60, -100)
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
    frameToFill.ShowHideButton:SetScript("OnClick", function() AZP.InterfaceCompanion:ShowHideFrame(frameToFill) end)

    frameToFill.AutoHideGroup = CreateFrame("Button", nil, frameToFill, "UIPanelButtonTemplate")
    frameToFill.AutoHideGroup:SetSize(100, 25)
    frameToFill.AutoHideGroup:SetPoint("TOP", 60, -150)
    frameToFill.AutoHideGroup:SetText("AutoHide On")
    frameToFill.AutoHideGroup:SetScript("OnClick",
    function()
        if AZPICLockedAndHidden[3] then
            AZPICLockedAndHidden[3] = false
            frameToFill.AutoHideGroup:SetText("AutoHide On")
        else
            AZPICLockedAndHidden[3] = true
            frameToFill.AutoHideGroup:SetText("AutoHide Off")
        end
    end)

    frameToFill:Hide()
end

function AZP.InterfaceCompanion:ShowHideFrame(optionFrame)
    if InterfaceCompanionFrame:IsShown() then
        InterfaceCompanionFrame:Hide()
        optionFrame.ShowHideButton:SetText("Show Companion!")
        AZPICLockedAndHidden[2] = true
    else
        InterfaceCompanionFrame:Show()
        optionFrame.ShowHideButton:SetText("Hide Companion!")
        AZPICLockedAndHidden[2] = false
    end
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
        optionPanel.LockMoveButton:SetText("Move Companion!")
        InterfaceCompanionFrame:EnableMouse(false)
        InterfaceCompanionFrame:SetMovable(false)
    else
        optionPanel.LockMoveButton:SetText("Lock Companion!")
        InterfaceCompanionFrame:EnableMouse(true)
        InterfaceCompanionFrame:SetMovable(true)
    end

    if AZPICLockedAndHidden[2] then
        InterfaceCompanionFrame:Hide()
        optionPanel.ShowHideButton:SetText("Show Companion!")
    else
        InterfaceCompanionFrame:Show()
        optionPanel.ShowHideButton:SetText("Hide Companion!")
    end

    if IsInGroup() and AZPICLockedAndHidden[3] == true then
        InterfaceCompanionFrame:Hide()
        optionPanel.ShowHideButton:SetText("Show Companion!")
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

function AZP.InterfaceCompanion:ShareVersion()    -- Change DelayedExecution to native WoW Function.
    local versionString = string.format("|IC:%d|", AZP.VersionControl["Interface Companion"])
    AZP.InterfaceCompanion:DelayedExecution(10, function()
        if UnitInBattleground("player") ~= nil then
            -- BG stuff?
        else
            if IsInGroup() then
                if IsInRaid() then
                    C_ChatInfo.SendAddonMessage("AZPVERSIONS", versionString ,"RAID", 1)
                else
                    C_ChatInfo.SendAddonMessage("AZPVERSIONS", versionString ,"PARTY", 1)
                end
            end
            if IsInGuild() then
                C_ChatInfo.SendAddonMessage("AZPVERSIONS", versionString ,"GUILD", 1)
            end
        end
    end)
end

function AZP.InterfaceCompanion:ReceiveVersion(version)
    if version > AZP.VersionControl["Interface Companion"] then
        if (not HaveShowedUpdateNotification) then
            HaveShowedUpdateNotification = true
            UpdateFrame:Show()
            UpdateFrame.text:SetText(
                "Please download the new version through the CurseForge app.\n" ..
                "Or use the CurseForge website to download it manually!\n\n" ..
                "Newer Version: v" .. version .. "\n" ..
                "Your version: v" .. AZP.VersionControl["Interface Companion"]
            )
        end
    end
end

function AZP.InterfaceCompanion:GetSpecificAddonVersion(versionString, addonWanted)
    local pattern = "|([A-Z]+):([0-9]+)|"
    local index = 1
    while index < #versionString do
        local _, endPos = string.find(versionString, pattern, index)
        local addon, version = string.match(versionString, pattern, index)
        index = endPos + 1
        if addon == addonWanted then
            return tonumber(version)
        end
    end
end

function AZP.InterfaceCompanion.Events:VariablesLoaded()
    AZP.InterfaceCompanion:LoadLocation()
    AZP.InterfaceCompanion:LoadVariables()
    AZP.InterfaceCompanion:ShareVersion()
end

function AZP.InterfaceCompanion.Events:GroupRosterUpdate()
    if AZPICLockedAndHidden[3] then
        if IsInGroup() then
            InterfaceCompanionFrame:Hide()
            optionPanel.ShowHideButton:SetText("Show Companion!")
            AZPICLockedAndHidden[2] = true
        else
            InterfaceCompanionFrame:Show()
            optionPanel.ShowHideButton:SetText("Hide Companion!")
            AZPICLockedAndHidden[2] = false
        end
    end
end

function AZP.InterfaceCompanion:OnEvent(self, event, ...)
    if event == "CHAT_MSG_ADDON" then
        local prefix, payload, _, sender = ...
        if prefix == "AZPVERSIONS" then
            local version = AZP.InterfaceCompanion:GetSpecificAddonVersion(payload, "IC")
            if version ~= nil then
                AZP.InterfaceCompanion:ReceiveVersion(version)
            end
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        AZP.InterfaceCompanion:LoadModel()
    elseif event == "VARIABLES_LOADED" then
        AZP.InterfaceCompanion.Events:VariablesLoaded()
    elseif event == "GROUP_ROSTER_UPDATE" then
        AZP.InterfaceCompanion.Events:GroupRosterUpdate()
        AZP.InterfaceCompanion:ShareVersion()
    end
end

if not IsAddOnLoaded("AzerPUGsCore") then
    AZP.InterfaceCompanion:OnLoadSelf()
end

AZP.SlashCommands["IC"] = function()
    if InterfaceCompanionFrame ~= nil then InterfaceCompanionFrame:Show() end
end

AZP.SlashCommands["ic"] = AZP.SlashCommands["IC"]
AZP.SlashCommands["companion"] = AZP.SlashCommands["IC"]
AZP.SlashCommands["interface companion"] = AZP.SlashCommands["IC"]
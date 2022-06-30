if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end

AZP.VersionControl["Interface Companion"] = 46
if AZP.InterfaceCompanion == nil then AZP.InterfaceCompanion = {} end
if AZP.InterfaceCompanion.Events == nil then AZP.InterfaceCompanion.Events = {} end

local InterfaceCompanionFrame = CreateFrame("FRAME", nil, UIParent)
local CompanionModel = nil
local InterfaceCompanionScaleSlider = nil
local EventFrame, UpdateFrame = {}, {}

local AZPICSelfOptionPanel = nil
local optionPanel = nil
local optionHeader = "|cFF00FFFFInterface Companion|r"

local HaveShowedUpdateNotification = false

if AZPICCompanionFrameLocation == nil then AZPICCompanionFrameLocation = {"CENTER", 0, 0} end
if AZPICLockedAndHidden == nil then AZPICLockedAndHidden = {false, false, false} end
if AZPICModelIndex == nil then AZPICModelIndex = 3 end

function AZP.InterfaceCompanion:OnLoadBoth()
    InterfaceCompanionFrame:SetSize(200, 200)
    InterfaceCompanionFrame:RegisterForDrag("LeftButton")
    InterfaceCompanionFrame:SetScript("OnDragStart", InterfaceCompanionFrame.StartMoving)
    InterfaceCompanionFrame:SetScript("OnDragStop", function() InterfaceCompanionFrame:StopMovingOrSizing() AZP.InterfaceCompanion:SaveLocation() end)

    -- local creatureDisplayID, descriptionText, sourceText, isSelfMount, _, modelSceneID, animID, spellVisualKitID, disablePlayerMountPreview = C_MountJournal.GetMountInfoExtraByID(449);
    -- CompanionModel = InterfaceCompanionFrame:CreateActor()
    -- InterfaceCompanionFrame:TransitionToModelSceneID(modelSceneID, CAMERA_TRANSITION_TYPE_IMMEDIATE, CAMERA_MODIFICATION_TYPE_MAINTAIN, true) -- forceSceneChange

    -- InterfaceCompanionFrame:GetActorByTag("unwrapped")
    -- local actor = InterfaceCompanionFrame:GetActorByTag("unwrapped")

    CompanionModel = CreateFrame("PlayerModel", nil, InterfaceCompanionFrame)
    --CompanionModel:SetModelByCreatureDisplayID(41711)
    CompanionModel:Hide()
    CompanionModel:SetSize(200, 200)
    CompanionModel:SetPosition(-2, 0, 0)
    CompanionModel:SetPoint("CENTER", 0, 0)
    CompanionModel.x, CompanionModel.y, CompanionModel.z = 0, 0, 0
    CompanionModel:Show()
    CompanionModel:SetScale(1)
end

function AZP.InterfaceCompanion:OnLoadCore()
    AZP.InterfaceCompanion:OnLoadBoth()
    AZP.Core:RegisterEvents("VARIABLES_LOADED", function(...) AZP.InterfaceCompanion.Events:VariablesLoaded(...) end)
    AZP.Core:RegisterEvents("GROUP_ROSTER_UPDATE", function(...) AZP.InterfaceCompanion.Events:GroupRosterUpdate(...) end)

    AZP.OptionsPanels:RemovePanel("Interface Companion")
    AZP.OptionsPanels:Generic("Interface Companion", optionHeader, function(frame)
        AZPICSelfOptionPanel = frame
        AZP.InterfaceCompanion:FillOptionsPanel(AZPICSelfOptionPanel)
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

function AZP.InterfaceCompanion:GetPepeFromIndex(Index)
    local CurPepeIndex = AZP.InterfaceCompanion.PepeInfo.Active[Index]
    return AZP.InterfaceCompanion.PepeInfo[CurPepeIndex]
end

function AZP.InterfaceCompanion:SetValue(Index)
    local CurPepe = AZP.InterfaceCompanion:GetPepeFromIndex(Index)
    local ModelName = CurPepe.Name
    AZPICModelIndex = Index
    UIDropDownMenu_SetText(AZPICSelfOptionPanel.ModelDropDown, ModelName)
    AZP.InterfaceCompanion:LoadModel(Index)
    CloseDropDownMenus()
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

    frameToFill.ModelDropDown = CreateFrame("Button", nil, frameToFill, "UIDropDownMenuTemplate")
    frameToFill.ModelDropDown:SetPoint("TOP", -60, -150)

    UIDropDownMenu_SetWidth(frameToFill.ModelDropDown, 100)

    local ActivePepes = AZP.InterfaceCompanion.PepeInfo.Active

    UIDropDownMenu_Initialize(frameToFill.ModelDropDown, function(self, level, menuList)
        local info = UIDropDownMenu_CreateInfo()
        info.func = AZP.InterfaceCompanion.SetValue
        for i = 1, #ActivePepes do
            info.text = AZP.InterfaceCompanion:GetPepeFromIndex(i).Name
            info.arg1 = i
            UIDropDownMenu_AddButton(info, 1)
        end
    end)

    InterfaceCompanionScaleSlider = CreateFrame("SLIDER", "InterfaceCompanionScaleSlider", frameToFill, "OptionsSliderTemplate")
    InterfaceCompanionScaleSlider:SetHeight(20)
    InterfaceCompanionScaleSlider:SetWidth(500)
    InterfaceCompanionScaleSlider:SetOrientation('HORIZONTAL')
    InterfaceCompanionScaleSlider:SetPoint("TOP", 0, -200)
    InterfaceCompanionScaleSlider:EnableMouse(true)
    InterfaceCompanionScaleSlider.tooltipText = 'Scale for mana bars'
    InterfaceCompanionScaleSliderLow:SetText('small')
    InterfaceCompanionScaleSliderHigh:SetText('big')
    InterfaceCompanionScaleSliderText:SetText('Scale')

    InterfaceCompanionScaleSlider:Show()
    InterfaceCompanionScaleSlider:SetMinMaxValues(1, 3)
    InterfaceCompanionScaleSlider:SetValueStep(0.1)

    InterfaceCompanionScaleSlider:SetScript("OnValueChanged",
    function(self, value)
        AZPICScale = value
        InterfaceCompanionFrame:SetScale(value)
        CompanionModel:SetModelScale(1 / value)
    end)

    InterfaceCompanionRotationSlider = CreateFrame("SLIDER", "InterfaceCompanionRotationSlider", frameToFill, "OptionsSliderTemplate")
    InterfaceCompanionRotationSlider:SetHeight(20)
    InterfaceCompanionRotationSlider:SetWidth(500)
    InterfaceCompanionRotationSlider:SetOrientation('HORIZONTAL')
    InterfaceCompanionRotationSlider:SetPoint("TOP", 0, -250)
    InterfaceCompanionRotationSlider:EnableMouse(true)
    InterfaceCompanionRotationSlider.tooltipText = 'Rotate companion'
    InterfaceCompanionRotationSliderLow:SetText('small')
    InterfaceCompanionRotationSliderHigh:SetText('big')
    InterfaceCompanionRotationSliderText:SetText('Rotate')

    InterfaceCompanionRotationSlider:Show()
    InterfaceCompanionRotationSlider:SetMinMaxValues(math.pi, 3 * math.pi)
    InterfaceCompanionRotationSlider:SetValueStep(0.1)

    InterfaceCompanionRotationSlider:SetScript("OnValueChanged",
    function(self, value)
        AZPICRotation = value
        CompanionModel:SetRotation(value)
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
    if AZPICModelIndex == nil then AZPICModelIndex = 3 end
    if AZPICRotation == nil then AZPICRotation = math.pi * 2 end
    if AZPICScale == nil then AZPICScale = 3 end

    InterfaceCompanionScaleSlider:SetValue(AZPICScale)
    InterfaceCompanionRotationSlider:SetValue(AZPICRotation)

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

    AZP.InterfaceCompanion:LoadModel(AZPICModelIndex)

    if AZPICModelIndex ~= nil then      -- AZPICSelfOptionPanel
        local curIndex = AZP.InterfaceCompanion.PepeInfo.Active[AZPICModelIndex]
        local curPet = AZP.InterfaceCompanion.PepeInfo[curIndex]
        UIDropDownMenu_SetText(optionPanel.ModelDropDown, curPet.Name)
    else
        UIDropDownMenu_SetText(optionPanel.ModelDropDown, "Standard Pepe")
    end
end

function AZP.InterfaceCompanion:LoadModel(ModelIndex)
    InterfaceCompanionFrame:Show()
    local CurModel = AZP.InterfaceCompanion:GetPepeFromIndex(ModelIndex)
    if CurModel == nil then CurModel = AZP.InterfaceCompanion.PepeInfo[1] end
    if CurModel.ModelID ~= nil then CompanionModel:SetModel(CurModel.ModelID)
    else CompanionModel:SetCreature(CurModel.CreatureID) end
    InterfaceCompanionFrame:SetScale(AZPICScale)
    CompanionModel:SetModelScale(1 / AZPICScale)

    if AZPICRotation == nil then AZPICRotation = 0 end
    CompanionModel:SetRotation(AZPICRotation)

    InterfaceCompanionFrame:SetPoint(AZPICCompanionFrameLocation[1], AZPICCompanionFrameLocation[4], AZPICCompanionFrameLocation[5])
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
    --AZP.InterfaceCompanion:LoadLocation()
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
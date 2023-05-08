-- Frame setup
local frame = CreateFrame("FRAME", "WarlockDominationPercentage")
frame:RegisterEvent("GUILD_ROSTER_UPDATE")

-- Variables
local lastNumOnlineMembers = 0
local currentNumOnlineMembers = 0
local currentNumOnlineWarlocks = 0
local currentWarlockPercentage = 0

-- Functions
local function printWarlockDominationPercentage()
    print(string.format("|cff8787eeWarlock Domination: %.1f%% (%d/%d)|r", currentWarlockPercentage, currentNumOnlineWarlocks, currentNumOnlineMembers))
end

local function onUpdate(self, event, ...)
    if event == "GUILD_ROSTER_UPDATE" then
        local numTotalMembers = GetNumGuildMembers()
        local numOnlineMembers = 0
        local numOnlineWarlocks = 0

        for i = 1, numTotalMembers do
            local _, _, _, _, _, _, _, _, isOnline, _, classFileName = GetGuildRosterInfo(i)
            if isOnline then
                numOnlineMembers = numOnlineMembers + 1
                if classFileName == "WARLOCK" then
                    numOnlineWarlocks = numOnlineWarlocks + 1
                end
            end
        end

        if numOnlineMembers > 0 and numOnlineMembers ~= lastNumOnlineMembers then
            currentWarlockPercentage = (numOnlineWarlocks / numOnlineMembers) * 100
            currentNumOnlineMembers = numOnlineMembers
            currentNumOnlineWarlocks = numOnlineWarlocks

            printWarlockDominationPercentage()
            lastNumOnlineMembers = numOnlineMembers
        end
    end
end

-- Event handling
frame:SetScript("OnEvent", onUpdate)
C_GuildInfo.GuildRoster()

-- Slash Command
local function handleSlashCommand(msg, editbox)
    printWarlockDominationPercentage()
end

SLASH_WARLOCKDOMINATIONPERCENTAGE1 = "/wdp"
SlashCmdList["WARLOCKDOMINATIONPERCENTAGE"] = handleSlashCommand


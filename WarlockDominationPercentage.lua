-- Slash Command setup
SLASH_WDP1 = "/wdp"
SlashCmdList["WDP"] = function()
    C_GuildInfo.GuildRoster()
    onUpdate(nil, "GUILD_ROSTER_UPDATE", true)
end

-- Frame setup
local frame = CreateFrame("FRAME", "WarlockDominationPercentage")
frame:RegisterEvent("GUILD_ROSTER_UPDATE")

-- Variables
local lastNumOnlineMembers = 0

-- Functions
local function onUpdate(self, event, forcePrint, ...)
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

        if numOnlineMembers > 0 and (forcePrint or numOnlineMembers ~= lastNumOnlineMembers) then
            local warlockPercentage = 0
            if numOnlineMembers > 0 then
                warlockPercentage = (numOnlineWarlocks / numOnlineMembers) * 100
            end

            print("|cff8787eeWarlock Domination: " .. format("%.1f", warlockPercentage) .. "% (" .. format("%d/%d", numOnlineWarlocks, numOnlineMembers) .. ")")

            if not forcePrint then
                lastNumOnlineMembers = numOnlineMembers
            end
        end
    end
end

-- Event handling
frame:SetScript("OnEvent", onUpdate)
C_GuildInfo.GuildRoster()


Ext.Require("Helpers.lua")
Ext.Require("Constants.lua")
Ext.Require("PartyManager.lua")
Ext.Require("CharacterTools.lua")

local isInitialised = false
local pauseScript = false
local partyStacks = {}

local function ResetLeadershipStats(characterGuid, clearStatus)
    clearStatus = clearStatus or false
    partyStacks[characterGuid] = 0
    RemoveStatus(characterGuid, STATUS_STACKABLE_STATS)
    if clearStatus then
        RemoveStatus(characterGuid, STATUS_BEST)
        RemoveStatus(characterGuid, STATUS_LOW)
    end
    return 0
end

local function GetCurrentStacks(characterGuid)
    if partyStacks[characterGuid] == nil then
        return ResetLeadershipStats(characterGuid)
    end
    return partyStacks[characterGuid]
end

local function ApplyLeadershipStats(partyMember, hasBest)
    if not hasBest and HasActiveStatus(partyMember.guid, STATUS_LOW) == 0 then
        return ResetLeadershipStats(partyMember.guid)
    end

    local current = GetCurrentStacks(partyMember.guid)
    if partyMember.hasStacks and current == partyMember.leadership then
        return
    end

    if current > partyMember.leadership then
        current = ResetLeadershipStats(partyMember.guid)
    end

    local add = partyMember.hasStacks and (partyMember.leadership - current) or partyMember.leadership
    ApplyStackableStatus(partyMember.guid, STATUS_STACKABLE_STATS, add)
    partyStacks[partyMember.guid] = partyMember.leadership
end

local function ApplyLeadershipStatus(partyMember, status, leadershipThresold)
    if partyMember.leadership >= leadershipThresold then
        if HasActiveStatus(partyMember.guid, status) == 0 then
            ApplyStatus(partyMember.guid, status, -1, 1)
        end
        return true
    end
    RemoveStatus(partyMember.guid, status)
    return false
end

local function UpdateLeadershipStatus(partyMembers, bestLeadership)
    for _, member in pairs(partyMembers) do
        if member.leadership <= 0 then
            ResetLeadershipStats(member.guid, true)
            goto continue
        end
        local best = ApplyLeadershipStatus(member, STATUS_BEST, bestLeadership)
        if not best then
            ApplyLeadershipStatus(member, STATUS_LOW, 1)
        end
        ApplyLeadershipStats(member, best)
        ::continue::
    end
end

local function CheckLeadershipStatus()
    if pauseScript or WaitForSeconds(3) then
        return
    end
    local partyMembers, bestLeadership = GetPartyMembers()
    UpdateLeadershipStatus(partyMembers, bestLeadership)
end

function InitAuracleLeadership(gameRunning)
    pauseScript = not gameRunning
    if not isInitialised then
        Ext.Osiris.RegisterListener(PARTY_MEMBER_EVENT, 1, "before", AddPartyMember)
        Ext.Events.Tick:Subscribe(CheckLeadershipStatus)
        isInitialised = true
    end
end

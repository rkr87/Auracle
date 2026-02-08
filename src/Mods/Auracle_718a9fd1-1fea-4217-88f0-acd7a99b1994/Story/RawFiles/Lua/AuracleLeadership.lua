Ext.Require("Helpers.lua")
Ext.Require("Constants.lua")
Ext.Require("PartyManager.lua")
Ext.Require("CharacterTools.lua")

local partyStacks = {}

local function ResetLeadershipStats(characterGuid)
    partyStacks[characterGuid] = 0
    RemoveStatus(characterGuid, STATUS_STACKABLE_STATS)
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
        if HasActiveStatus(partyMember.guid, status) > 0 then
            return true
        end
        ApplyStatus(partyMember.guid, status, -1, 1)
        return true
    end
    RemoveStatus(partyMember.guid, status)
    return false
end

local function UpdateLeadershipStatus(partyMembers, bestLeadership)
    for _, member in pairs(partyMembers) do
        local best = ApplyLeadershipStatus(member, STATUS_BEST, bestLeadership)
        if not best then
            ApplyLeadershipStatus(member, STATUS_LOW, 1)
        end
        ApplyLeadershipStats(member, best)
    end
end

local function CheckLeadershipStatus()
    if WaitForSeconds(3) then
        return
    end
    local partyMembers, bestLeadership = GetPartyMembers()
    UpdateLeadershipStatus(partyMembers, bestLeadership)
end

function InitAuracleLeadership()
    Ext.Osiris.RegisterListener(PARTY_MEMBER_EVENT, 1, "before", AddPartyMember)
    Ext.Events.Tick:Subscribe(CheckLeadershipStatus)
end

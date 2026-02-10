Ext.Require("CharacterTools.lua")
Ext.Require("Constants.lua")
Ext.Require("Helpers.lua")

function GetPartyMember(char_uuid)
    local char = Ext.Entity.GetCharacter(char_uuid)
    return {
        guid = char.MyGuid,
        leadership = GetCharacterLeadership(char),
        hasStacks = HasActiveStatus(char.MyGuid, STATUS_STACKABLE_STATS) > 0
    }
end

function GetPartyMembers()
    local partyMembers = {}
    local bestLeadership = -1
    local dbPlayers = Osi.DB_IsPlayer:Get(nil)
    for _, dbChar in pairs(dbPlayers) do
        local member = GetPartyMember(dbChar[1])
        partyMembers[dbChar[1]] = member
        if member.leadership > bestLeadership then
            bestLeadership = member.leadership
        end
    end
    return partyMembers, bestLeadership
end

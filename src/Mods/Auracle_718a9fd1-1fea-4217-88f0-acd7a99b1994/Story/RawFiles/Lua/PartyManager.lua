Ext.Require("CharacterTools.lua")
Ext.Require("Constants.lua")
Ext.Require("Helpers.lua")

local partyMembers = {}
local bestLeadership = -1

function AddPartyMember(character_uuid)
    local character = Ext.Entity.GetCharacter(character_uuid)
    local leadership = GetCharacterLeadership(character)

    partyMembers[character_uuid] = {
        guid = character.MyGuid,
        leadership = leadership,
        hasStacks = HasActiveStatus(character.MyGuid, STATUS_STACKABLE_STATS) > 0
    }

    if leadership > bestLeadership then
        bestLeadership = leadership
    end
end

function GetPartyMembers()
    partyMembers = {}
    bestLeadership = -1
    local dbPlayers = Osi.DB_IsPlayer:Get(nil)
    for _, dbChar in pairs(dbPlayers) do
        AddPartyMember(dbChar[1])
    end
    return partyMembers, bestLeadership
end

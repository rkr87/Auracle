Ext.Require("CharacterTools.lua")
Ext.Require("Constants.lua")
Ext.Require("Helpers.lua")

local partyMembers = {}
local bestLeadership = -1

function AddPartyMember(character_uuid)
    if partyMembers[character_uuid] ~= nil then
        return
    end

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
    Osi.Auracle_Get_Party()
    return partyMembers, bestLeadership
end

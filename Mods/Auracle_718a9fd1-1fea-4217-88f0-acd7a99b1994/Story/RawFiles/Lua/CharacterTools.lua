function GetCharacterLeadership(character)
    if not character.Stats then
        return 0
    end
    return character.Stats.Leadership or 0
end

function ApplyStackableStatus(character_guid, status, stacks)
    for i = 1, stacks do
        ApplyStatus(character_guid, status, -1, 1)
    end
end

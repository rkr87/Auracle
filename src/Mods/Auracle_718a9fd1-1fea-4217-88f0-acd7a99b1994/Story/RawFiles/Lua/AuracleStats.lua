local AURA_RANGE = 30
local AURAS = {"GUARDIAN_ANGEL_AURA", "FAVOURABLE_WIND_AURA", "EVASION_AURA",
               "FIRE_BRAND_AURA", "VENOM_AURA", "VAMPIRISM_AURA"}
local AURA_LIKES = {{"Target_MasterOfSparks", "AreaRadius"}}

local function UpdateAuraRange(statName, rangeField)
    rangeField = rangeField or "AuraRadius"
    Ext.Stats.GetRaw(statName)[rangeField] = AURA_RANGE
end

function AuracleStatUpdates(event)
    -- Leadership
    Ext.ExtraData["LeadershipRange"] = AURA_RANGE
    -- Aura
    for _, aura in pairs(AURAS) do
        UpdateAuraRange(aura)
    end
    -- Aura-Like
    for _, auraLike in pairs(AURA_LIKES) do
        UpdateAuraRange(auraLike[0], auraLike[1])
    end
end

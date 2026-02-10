local AURA_RANGE = 30
local AURAS = {"GUARDIAN_ANGEL_AURA", "FAVOURABLE_WIND_AURA", "EVASION_AURA",
               "FIRE_BRAND_AURA", "VENOM_AURA", "VAMPIRISM_AURA"}
local AURA_LIKES = {
    Target_MasterOfSparks = "AreaRadius"
}

local function UpdateAuraRange(statName, rangeField)
    rangeField = rangeField or "AuraRadius"
    Ext.Stats.GetRaw(statName)[rangeField] = AURA_RANGE
end

function AuracleStatUpdates(event)

    Ext.ExtraData["LeadershipRange"] = AURA_RANGE

    for _, aura in pairs(AURAS) do
        UpdateAuraRange(aura)
    end

    for auraLike, rangeField in pairs(AURA_LIKES) do
        UpdateAuraRange(auraLike, rangeField)
    end
end

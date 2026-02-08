Ext.Require("AuracleLeadership.lua")

local function ReadyCheck(gameStateEvent)
    if gameStateEvent.ToState == "Running" then
        InitAuracleLeadership()
    end
end

Ext.Events.GameStateChanged:Subscribe(ReadyCheck)

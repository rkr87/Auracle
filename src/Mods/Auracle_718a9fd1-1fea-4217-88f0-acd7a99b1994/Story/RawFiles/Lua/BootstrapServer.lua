Ext.Require("AuracleLeadership.lua")

local function ReadyCheck(gameStateEvent)
    local gameRunning = gameStateEvent.ToState == "Running"
    InitAuracleLeadership(gameRunning)
end

Ext.Events.GameStateChanged:Subscribe(ReadyCheck)

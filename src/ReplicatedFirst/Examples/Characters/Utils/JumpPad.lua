local module = {}

local path = game.ReplicatedFirst.Packages.Chickynoid
local Simulation = require(path.Shared.Simulation.Simulation)
local CommandLayout = require(path.Shared.Simulation.CommandLayout)
local Enums = require(path.Shared.Enums)

type Simulation = Simulation.Class
type Command = CommandLayout.Command

--Call this on both the client and server!
function module:ModifySimulation(simulation: Simulation)
    simulation:RegisterMoveState({
        name = "JumpPad",
        alwaysThinkLate = module.AlwaysThinkLate,
        executionOrder = 100,
    })
end

--this is called inside Simulation...
function module.AlwaysThinkLate(simulation: Simulation, cmd: Command)
    if simulation.lastGround and simulation.lastGround.hullRecord and simulation.lastGround.hullRecord.instance then
        local instance = simulation.lastGround.hullRecord.instance

        --Check jumpPads
        local vec3 = instance:GetAttribute("launch")
        if typeof(vec3) == "Vector3" then
            local dir = instance.CFrame:VectorToWorldSpace(vec3)

            simulation.state.vel = dir
            simulation.state.jump = 0.2
            simulation.characterData:PlayAnimation("Jump", Enums.AnimChannel.Channel0, true, 0.2)
        end
    end
end

return module

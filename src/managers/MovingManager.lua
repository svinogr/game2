MovingManager = Object:extend()


function MovingManager:new()
    self.speed = 50000
end

function MovingManager:initialize(arrangement)
    self.managerArrangement = arrangement
end

function MovingManager:update(dt, objects, gameState)
    if (gameState == GameStates.DISCARD) then
        self:reset(dt, objects)
    end
end

function MovingManager:reset(dt, objects)
    for i = 1, #objects do
        if objects[i].isSelect then
            local dx = self.managerArrangement.zones[ZONES.DISCARD].x - objects[i].x
            local dy = self.managerArrangement.zones[ZONES.DISCARD].y - objects[i].y

            if math.abs(dx) < 1 and math.abs(dy) < 1 then
                objects[i].isSelect = false
            else
                local speed = self.speed * dt
                objects[i].x = objects[i].x + math.max(-speed * dt, math.min(speed, dx))
                objects[i].y = objects[i].y + math.max(-speed * dt, math.min(speed, dy))
            end
        end
    end
end

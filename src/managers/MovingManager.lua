MovingManager = Object:extend()


function MovingManager:new()
    self.speed = 500
    self.complete = false
end

function MovingManager:initialize(arrangement)
    self.managerArrangement = arrangement
end

function MovingManager:update(dt, objects, gameState)
    
    if (gameState == GameStates.DISCARD) then
        self:reset(dt, objects)
    end
    if (gameState == GameStates.DEALING) then
        self:dealing(dt, objects)
    end

end


function MovingManager:reset(dt, objects)
    for i = 1, #objects do
        if objects[i].isSelect then
            local dx = self.managerArrangement.discardPositions.x[i] - objects[i].x
            local dy = self.managerArrangement.discardPositions.y[i] - objects[i].y

            if math.abs(dx) < 1 and math.abs(dy) < 1 then
                objects[i].isSelect = false
            else
                local speed = self.speed * dt
                objects[i].x = objects[i].x + math.max(-speed, math.min(speed, dx))
                objects[i].y = objects[i].y + math.max(-speed, math.min(speed, dy))
            end
        end
    end

    for i = 1, #objects do
        self.complete = true
        if objects[i].isSelect then
            self.complete = false
        end
    end
end

function MovingManager:dealing(dt, knuckles)
    for i = 1, #self.managerArrangement.handPositions.x do
        if knuckles[i].isMove then
            local dx = self.managerArrangement.handPositions.x[i] - knuckles[i].x
            local dy = self.managerArrangement.handPositions.y[i] - knuckles[i].y

            if math.abs(dx) < 1 and math.abs(dy) < 1 then
                knuckles[i].isMove = false
            else
                local speed = self.speed * dt
                knuckles[i].x = knuckles[i].x + math.max(-speed, math.min(speed, dx))
                knuckles[i].y = knuckles[i].y + math.max(-speed, math.min(speed, dy))
            end
        end
    end

    for i = 1, #knuckles do
        self.complete = true
        if knuckles[i].isMove then
            self.complete = false
        end
    end
end

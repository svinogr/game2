MovingManager = Object:extend()


function MovingManager:new()
    self.speed = 500
    self.complete = false
end

function MovingManager:initialize(arrangement)
    self.managerArrangement = arrangement
end

function MovingManager:update(dt, objects, gameState)
    
    if gameState == GameStates.DISCARD then
        self:reset(dt, objects)
    end
    if gameState == GameStates.DEALING then
        self:dealing(dt, objects)
    end
    if gameState == GameStates.PLAYER_TURN then
       self:turnPositions(dt, objects)
    end
end


function MovingManager:turnPositions(dt, objects)
    local fieldIndex = 1  -- Индекс для позиций на поле
    for i = 1, #objects do
        if objects[i].isSelect then
              -- Устанавливаем поворот на 90 градусов (math.pi/2 радиан)
           objects[i].rotation = -  math.pi / 2

            local dx = self.managerArrangement.gameFieldPositions.x[i] - objects[i].x
            local dy = self.managerArrangement.gameFieldPositions.y[i] - objects[i].y

            if math.abs(dx) < 1 and math.abs(dy) < 1 then
                objects[i].isSelect = false
            else
                local speed = self.speed * dt
                objects[i].x = objects[i].x + math.max(-speed, math.min(speed, dx))
                objects[i].y = objects[i].y + math.max(-speed, math.min(speed, dy))
            end
            fieldIndex = fieldIndex + 1  -- Увеличиваем индекс только когда нашли выбранную костяшку
        end
    end
    self.complete = true
    for i = 1, #objects do
        if objects[i].isSelect then
            self.complete = false
        end
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

function MovingManager:dealing(dt, objects)
    for i = 1, #objects do
        if objects[i].isMove then
            local dx =  objects[i].toPosition.x - objects[i].x
            local dy =  objects[i].toPosition.y - objects[i].y
        print(dx..':'..dy..' i='..i..' id='..objects[i].id)
            if math.abs(dx) < 1 and math.abs(dy) < 1 then
                objects[i].isMove = false
              --  objects[i].positionInDeck = i
            else
                local speed = self.speed * dt
                objects[i].x = objects[i].x + math.max(-speed, math.min(speed, dx))
                objects[i].y = objects[i].y + math.max(-speed, math.min(speed, dy))
            end
        end
    end

    self.complete = true
    for i = 1, #objects do
       
        if objects[i].isMove then
            self.complete = false
        end
    end

--[[ 

    local freePosition = self.managerArrangement:getFreeHandPositions() 
    if #objects ~= #freePosition then
        error("несовпадение количества карт и свободных позиций")
    end
    for i = 1, #freePosition do
        if objects[i].isMove then
            local dx = freePosition.x[i] - objects[i].x
            local dy = freePosition.y[i] - objects[i].y

            if math.abs(dx) < 1 and math.abs(dy) < 1 then
                objects[i].isMove = false
                objects[i].positionInDeck = i
            else
                local speed = self.speed * dt
                objects[i].x = objects[i].x + math.max(-speed, math.min(speed, dx))
                objects[i].y = objects[i].y + math.max(-speed, math.min(speed, dy))
            end
        end
    end ]]
     

--[[ 
    for i = 1, #objects do
        if objects[i].isMove then
            local dx = self.managerArrangement.handPositions.x[i] - objects[i].x
            local dy = self.managerArrangement.handPositions.y[i] - objects[i].y

            if math.abs(dx) < 1 and math.abs(dy) < 1 then
                objects[i].isMove = false
                objects[i].positionInDeck = i
            else
                local speed = self.speed * dt
                objects[i].x = objects[i].x + math.max(-speed, math.min(speed, dx))
                objects[i].y = objects[i].y + math.max(-speed, math.min(speed, dy))
            end
        end
    end ]]
 --[[    self.complete = true
    for i = 1, #objects do
       
        if objects[i].isMove then
            self.complete = false
        end
    end ]]
end

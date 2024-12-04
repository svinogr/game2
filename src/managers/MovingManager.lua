MovingManager = Object:extend()


function MovingManager:new()
    self.speed = 500
    self.complete = false
     -- Добавляем параметры для дугообразного движения
     self.arcHeight = 100  -- Максимальная высота подъёма
     self.arcProgress = {} -- Хранит прогресс движения для каждого объекта
     self.maxScale = 1.3   -- Максимальный масштаб при подъеме
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
    self.complete = true
    local fieldIndex = 1  -- Индекс для позиций на поле
    for i = 1, #objects do
        if objects[i].isSelect then
              -- Устанавливаем поворот на 90 градусов (math.pi/2 радиан)
           objects[i].rotation = -  math.pi / 2

            local dx = self.managerArrangement.gameFieldPositions.x[i] 
            local dy = self.managerArrangement.gameFieldPositions.y[i]

            local isComplete = self:moveObject(objects[i], dx, dy)
            if isComplete then
                objects[i].isSelect = false
            else
                self.complete = false
            end
                       fieldIndex = fieldIndex + 1  -- Увеличиваем индекс только когда нашли выбранную костяшку
        end
    end
 end


function MovingManager:reset(dt, objects)
    self.complete = true
    for i = 1, #objects do
        if objects[i].isSelect then
            local dx = self.managerArrangement.discardPositions.x[i]
            local dy = self.managerArrangement.discardPositions.y[i]
            local isComplete = self:moveObject(objects[i], dx, dy)
            if isComplete then
                objects[i].isSelect = false
            else
                self.complete = false
            end
        end
    end
end

function MovingManager:dealing(dt, objects)
    self.complete = true
    for i = 1, #objects do      
        if objects[i].isMove then
           local dx =  objects[i].toPosition.x 
           local dy =  objects[i].toPosition.y 

            local isComplete = self:moveObject(objects[i], dx, dy)
            if isComplete then
                objects[i].isMove = false
            else
                self.complete = false
            end
        end
    end 
end

-- Общий метод для перемещения объекта
function MovingManager:moveObject(object, targetX, targetY)
    if not object or not targetX or not targetY then return false end
    --#region

    if not self.arcProgress[object] then
        self.arcProgress[object] = {
            startX = object.x,
            startY = object.y,
            progress = 0,
            startScale = object.scale or 1  -- Сохраняем начальный масштаб
        }
    end
    local arc = self.arcProgress[object]
    local dt = love.timer.getDelta()
    local speed = self.speed * dt

      -- Увеличиваем прогресс движения
      arc.progress = arc.progress + speed / math.sqrt((targetX - arc.startX)^2 + (targetY - arc.startY)^2)
    
      -- Ограничиваем прогресс от 0 до 1
      arc.progress = math.min(1, arc.progress)
      
      -- Вычисляем текущую позицию с учетом дуги
      local progress = arc.progress
      -- Параболическая траектория для высоты
      local heightOffset = math.sin(progress * math.pi) * self.arcHeight
       -- Изменение масштаба во время полета
    local scaleOffset = math.sin(progress * math.pi) * (self.maxScale - arc.startScale)
    object.scale = arc.startScale + scaleOffset

       -- Линейная интерполяция для X и Y
    object.x = arc.startX + (targetX - arc.startX) * progress
    object.y = arc.startY + (targetY - arc.startY) * progress - heightOffset

       -- Если достигли цели
       if arc.progress >= 1 then
        object.x = targetX
        object.y = targetY
        self.arcProgress[object] = nil -- Очищаем прогресс
        object.scale = arc.startScale  -- Возвращаем исходный масштаб
        return true
    end
    
    return false
    --#endregion
    
   --[[  local dx = targetX - object.x
    local dy = targetY - object.y
    
    if math.abs(dx) < 1 and math.abs(dy) < 1 then
        return true
    else
        local speed = self.speed * love.timer.getDelta()
        object.x = object.x + math.max(-speed, math.min(speed, dx))
        object.y = object.y + math.max(-speed, math.min(speed, dy))
        return false
    end ]]
end

require "src.lib.knife.test"
Object = require "src.lib.classic"
Knuckle = Object:extend()  -- локальное определение
local Timer = require 'src.lib.knife.timer'
-- Константы
DEFAULT_COLOR_KNUCKLE = {39/255, 193/255, 211/255}

local CONSTANTS = {
    DEFAULT_COLOR = {39/255, 193/255, 211/255},
    SHADOW_FACTOR = 0.7,
    SELECT_OFFSET = 20,
    POINT_PATTERNS = {
        ONE = {{x = 0.5, y = 0.25}},
        TWO = {{x = 0.2, y = 0.25}, {x = 0.8, y = 0.25}}
    }
}

--[[ Конструктор класса костяшки домино ]]
function Knuckle:new(id, value, radius)
    self.id = id or 0
    self.color = DEFAULT_COLOR_KNUCKLE   
    self.x = DEFAULT_START_POSITION_KNUCKLES[1]
    self.y = DEFAULT_START_POSITION_KNUCKLES[2]
    self.toPosX = self.x
    self.toPosY = self.y
    self.width = DEFAULT_SIZE_KNUCKLES[1]
    self.height = DEFAULT_SIZE_KNUCKLES[2]
    self.v1 = value[1]
    self.v2 = value[2]
    self.radius = radius or VIRTUAL_HEIGHT/100
    self.isMove = true
    self.isSelect = false
    self.isHover = false
    self.up = 0
    self.rotation = 0
    self.toPosition = {
        id = {},
        x ={},
        y ={}
    }
end

--[[ Методы обновления и взаимодействия ]]
function Knuckle:update(dt)
    -- Здесь можно добавить логику анимации движения
end

-- Выбор костяшки (подъем/опускание)
function Knuckle:select()
    self.isSelect = not self.isSelect
    local offset = self.isSelect and -CONSTANTS.SELECT_OFFSET or CONSTANTS.SELECT_OFFSET
    self.y = self.y + offset
end

-- Обработка наведения мыши
function Knuckle:hover()
    if self.isHover then
        self:highlight()
    else
        self:unhighlight()        
    end
end

-- Поворот костяшки
function Knuckle:rotate()
    self.rotation = self.rotation + math.pi/2
    self.v1, self.v2 = self.v2, self.v1
end

--[[ Методы отрисовки ]]
-- Основная функция отрисовки костяшки
function Knuckle:draw()
    local scale = self.scale or 1  -- Используем scale если есть, иначе 1
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
   
    love.graphics.rotate(self.rotation)
    love.graphics.scale(scale, scale)
    love.graphics.translate(-self.x, -self.y)
    love.graphics.setColor(self.color[1], self.color[2], self.color[3])
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.line(self.x + 8, self.y + self.height/2,
                      self.x + self.width - 8, self.y + self.height/2)
    
    self:drawPoints("up")
    self:drawPoints("down")
    self:drawShadows(self.color)
    self:hover()
    love.graphics.pop()
end

-- Отрисовка теней костяшки
function Knuckle:drawShadows(color)
    -- Края теней
    love.graphics.setColor(0, 0, 0)
    
    local topXRight1 = self.x + self.width + 1
    local topYRight1 = self.y + 1
    local topXRight2 = self.x + self.width + 2
    local topYRight2 = self.y + 2
    
    local bottomXRight1 = self.x + self.width + 1
    local bottomYRight1 = self.y + self.height + 1
    local bottomXRight2 = self.x + self.width + 2
    local bottomYRight2 = self.y + 2 + self.height
    
    local bottomXLeft1 = self.x + 1
    local bottomYLeft1 = self.y + self.height + 1
    local bottomXLeft2 = self.x + 2
    local bottomYLeft2 = self.y + 2 + self.height
    
    -- Отрисовка линий теней
    love.graphics.line(topXRight1, topYRight1, topXRight2, topYRight2)
    love.graphics.line(bottomXRight1, bottomYRight1, bottomXRight2, bottomYRight2)
    love.graphics.line(topXRight1, topYRight1, bottomXRight1, bottomYRight1)
    love.graphics.line(topXRight2, topYRight2, bottomXRight2, bottomYRight2)
    love.graphics.line(bottomXLeft1, bottomYLeft1, bottomXLeft2, bottomYLeft2)
    love.graphics.line(bottomXLeft1, bottomYLeft1, bottomXRight1, bottomYRight1)
    love.graphics.line(bottomXLeft2, bottomYLeft2, bottomXRight2, bottomYRight2)
    
    -- Нижняя и боковая грани
    local factor = CONSTANTS.SHADOW_FACTOR
    love.graphics.setColor(self.color[1] * factor, self.color[2] * factor, self.color[3] * factor)
    
    local bottomXLeft1Gran = self.x
    local bottomYLeft1Gran = self.y + self.height
    local bottomXRight1Gran = self.x + self.width 
    local bottomYRight1Gran = self.y + self.height
    local topXRight1Gran = self.x + self.width
    local topYRight1Gran = self.y
    
    love.graphics.line(bottomXLeft1Gran, bottomYLeft1Gran, bottomXRight1Gran, bottomYRight1Gran)
    love.graphics.line(topXRight1Gran, topYRight1Gran, bottomXRight1Gran, bottomYRight1Gran)
    love.graphics.setColor(1, 1, 1)
end

-- Отрисовка точек на костяшке
function Knuckle:drawPoints(direction)
    local bias = direction == "down" and self.height / 2 or 0
    local quantity = direction == "down" and self.v2 or self.v1
    
    local patterns = {
        [1] = function() self:drawOnePoints(bias) end,
        [2] = function() self:drawTwoPoints(bias) end,
        [3] = function() self:drawThreePoints(bias) end,
        [4] = function() self:drawFourPoints(bias) end,
        [5] = function() self:drawFivePoints(bias) end,
        [6] = function() self:drawSixPoints(bias) end
    }
    
    if patterns[quantity] then
        patterns[quantity]()
    end
end

--[[ Методы отрисовки точек ]]
-- Отрисовка одной точки
function Knuckle:drawOnePoints(bias)
    local c1 = self.x + self.width / 2
    local c2 = self.y + self.height / 4 + bias
    love.graphics.circle("fill", c1, c2, self.radius)
end

-- Отрисовка двух точек
function Knuckle:drawTwoPoints(bias)
    local c1 = self.x + self.radius * 3 
    local c2 = self.y + self.height / 4 + bias
    love.graphics.circle("fill", c1, c2, self.radius)
    
    c1 = self.x + self.width - self.radius * 3
    love.graphics.circle("fill", c1, c2, self.radius) 
end

-- Отрисовка трех точек
function Knuckle:drawThreePoints(bias)
    local c1 = self.x + self.radius * 3 
    local c2 = self.y + self.radius * 2 + bias
    love.graphics.circle("fill", c1, c2, self.radius)
    
    c1 = self.x + self.width - self.radius * 3  
    c2 = self.y + self.height / 2 - self.radius * 2 + bias
    love.graphics.circle("fill", c1, c2, self.radius)
    
    self:drawOnePoints(bias)
end

-- Отрисовка четырех точек
function Knuckle:drawFourPoints(bias)
    local c1 = self.x + self.radius * 3 
    local c2 = self.y + self.radius * 2 + bias
    love.graphics.circle("fill", c1, c2, self.radius)
    
    c1 = self.x + self.width - self.radius * 3  
    c2 = self.y + self.height / 2 - self.radius * 2 + bias
    love.graphics.circle("fill", c1, c2, self.radius)
    
    c1 = self.x + self.radius * 3  
    c2 = self.y + self.height / 2 - self.radius * 2 + bias
    love.graphics.circle("fill", c1, c2, self.radius)
    
    c1 = self.x + self.width - self.radius * 3 
    c2 = self.y + self.radius * 2 + bias
    love.graphics.circle("fill", c1, c2, self.radius)
end

-- Отрисовка пяти точек
function Knuckle:drawFivePoints(bias)
    self:drawFourPoints(bias)
    self:drawOnePoints(bias)
end

-- Отрисовка шести точек
function Knuckle:drawSixPoints(bias)
    self:drawFourPoints(bias)
    self:drawTwoPoints(bias)
end

--[[ Методы визуальных эффектов ]]
-- Подсветка при наведении
function Knuckle:highlight()
    self.color = {self.color[1] * 1.01, self.color[2] * 1.01, self.color[3] * 1.01}
end

-- Снятие подсветки
function Knuckle:unhighlight()
    self.color = DEFAULT_COLOR_KNUCKLE
end

function Knuckle:print()
    love.graphics.print(self.v1, self.v2)
    
end


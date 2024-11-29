Button = Object:extend()

function Button:new()
    self.x =  0
    self.y = 0
    self.width = 0
    self.height = 0
    self.text = ""
    self.isPressed = false
    self.isHover = false
    self.color = DEFAULT_COLOR_KNUCKLE
end

function Button:update(dt)

end

function Button:draw()
    -- Сохраняем текущий цвет
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(self.color[1], self.color[2], self.color[3])
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    
    -- Рисуем границу кнопки
    love.graphics.setColor(0.4, 0.4, 0.4)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    
    -- Рисуем текст
    love.graphics.setColor(0, 0, 0)
    local font = love.graphics.getFont()
    local textWidth = font:getWidth(self.text)
    local textHeight = font:getHeight()
    love.graphics.print(
        self.text,
        self.x + (self.width - textWidth) / 2,
        self.y + (self.height - textHeight) / 2
    )
    
    self:hover()
    -- Восстанавливаем исходный цвет
    love.graphics.setColor(r, g, b, a)
end

function Button:isMouseOver(x, y)
    return x >= self.x and x <= self.x + self.width and
           y >= self.y and y <= self.y + self.height
end

function Button:mousepressed(x, y, button)
    if button == 1 and self:isMouseOver(x, y) then
        self.isPressed = true
        if self.onClick then
            self:onClick()
        end
    end
end

function Button:select()
   print(self.text)
end


--[[ Методы визуальных эффектов ]]
-- Подсветка при наведении
function Button:highlight()
    self.color = {self.color[1] * 1.01, self.color[2] * 1.01, self.color[3] * 1.01}
end

-- Снятие подсветки
function Button:unhighlight()
    self.color = DEFAULT_COLOR_KNUCKLE
end

function Button:hover()
    if self.isHover then
        self:highlight()
    else
        self:unhighlight()        
    end
end
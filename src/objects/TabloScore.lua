TabloScore = Object:extend()

function TabloScore:new(neededScore)
    self.x = 0
    self.y = 0
    self.width = 0
    self.height = 0
    self.one = 0
    self.two = 0
    self.score = 0
    self.scoreNeeded = neededScore or 0
    self.isEndLevel = false
end

function TabloScore:draw()
    self:createBarNeededScore()
    self:createBarCurrentScore()
    self:createScoreValues()
    love.graphics.setColor(39 / 255, 193 / 255, 211 / 255)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

function TabloScore:update(dt, score)
    self.score = self.score + score
    if self.score >= self.scoreNeeded then
        self.isEndLevel = true
    end
end

function TabloScore:createScoreValues()
    local font = love.graphics.getFont()
    love.graphics.setFont(love.graphics.newFont(20))
    local tW = font:getWidth(self.one .. " * " .. self.two)
    local tH = font:getHeight(self.one)
    love.graphics.print(self.one .. " * " .. self.two, (self.width - tW) / 2, (self.height - tH))
    love.graphics.setFont(font)
end

function TabloScore:createBarNeededScore()
    -- Получаем текущий шрифт, используемый для рисования текста
    local font = love.graphics.getFont()

    -- Устанавливаем новый шрифт с размером 20 для рисования
    love.graphics.setFont(love.graphics.newFont(20))

    -- Получаем ширину текста, который будет отображаться (необходимый счет)
    local tW = font:getWidth(self.scoreNeeded)

    -- Получаем высоту текста, который будет отображаться (необходимый счет)
    local tH = font:getHeight(self.scoreNeeded)

    -- Устанавливаем цвет для рисования (цвет в формате RGB)
    love.graphics.setColor(39 / 255, 193 / 255, 211 / 255)

    -- Рисуем прямоугольник с рамкой, который будет представлять бар необходимого счета
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height / 4)


    -- Рисуем текст необходимого счета по центру баров
    love.graphics.print(self.scoreNeeded, (self.width - tW) / 2, (self.height / 4 - tH) / 2 + self.y)

    -- Возвращаемся к исходному шрифту
    love.graphics.setFont(font)
end

function TabloScore:createBarCurrentScore()
    local font = love.graphics.getFont()
    love.graphics.setFont(love.graphics.newFont(30))
    local tW = font:getWidth(self.score)
    local tH = font:getHeight(self.score)
    love.graphics.setColor(39 / 255, 193 / 255, 211 / 255)

    -- Устанавливаем цвет для заполнения (такой же, как и для рамки)
    love.graphics.setColor(39 / 255, 193 / 255, 211 / 255)

    -- Рисуем заполненный прямоугольник, который представляет текущий прогресс (например, 1/6 ширины)
    local progress = math.min((self.score / self.scoreNeeded) * self.width, self.width)
    love.graphics.rectangle("fill", self.x, self.y, progress, self.height / 4)


    love.graphics.print(self.score, (self.width  - tW) / 2, (self.height  - tH) / 2 + self.y)

    love.graphics.setFont(font)
end

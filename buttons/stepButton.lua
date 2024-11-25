StepButton = Object:extend()
SizeStepButton = {40, 40}
DefaultColorStepButton = {39/255, 193/255, 211/255}

function StepButton:new(x, y)
self.x = x
self.y = y
self.width = SizeStepButton[1]
self.height = SizeStepButton[2]
end


function StepButton:draw()
love.graphics.setColor(DefaultColorStepButton[1], DefaultColorStepButton[2], DefaultColorStepButton[3])
love.graphics.rectangle("fill", self.x , self.y , self.width, self.height)
end

function StepButton:isMouseOver(mx, my)
    return mx >= self.x and mx <= self.x + self.width and my >= self.y and my <= self.y + self.height
end

function StepButton:mousepressed(mx, my, button)
    if button == 1 and self:isMouseOver(mx, my) then
        self:click()
    end
end

function StepButton:click()
    print("StepButton")
end
ResetButton = Object:extend()
SizeResetButton = {40, 40}
DefaultColorResetButton = {39/255, 193/255, 211/255}

function ResetButton:new(x, y)
self.x = x
self.y = y
self.width = SizeResetButton[1]
self.height = SizeResetButton[2]
end


function ResetButton:draw()
love.graphics.setColor(DefaultColorResetButton[1], DefaultColorResetButton[2], DefaultColorResetButton[3])
love.graphics.rectangle("fill", self.x , self.y , self.width, self.height)
end

function ResetButton:isMouseOver(mx, my)
    print("isMouse")
    return mx >= self.x and mx <= self.x + self.width and my >= self.y and my <= self.y + self.height
end

function ResetButton:mousepressed(mx, my, button)
    print("press")
        if button == 1 and self:isMouseOver(mx, my) then
        self:click()
    end
end

function ResetButton:click()
    print("ResetButton")
end
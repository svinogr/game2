TabloScore = Object:extend()

function TabloScore:new(neededScore)
 self.x = 0
 self.y = 0
 self.width = 0
 self.height = 0
 self.score = 0
 self.scoreNeeded = neededScore or 0
end


function TabloScore:draw()
    self:createBarNeededScore()
    self:createBarCurrentScore()
    love.graphics.setColor(39/255, 193/255, 211/255) 
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

end

function TabloScore:update()
    
end 


function TabloScore:createBarNeededScore()
    local font = love.graphics.getFont()
    love.graphics.setFont (love.graphics.newFont (20))
    local  tW = font:getWidth(self.scoreNeeded)
    local tH = font:getHeight(self.scoreNeeded)
    love.graphics.setColor(39/255, 193/255, 211/255) 
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height/4)

    love.graphics.setColor(39/255, 193/255, 211/255) 
    love.graphics.rectangle("fill", self.x, self.y, self.width/6, self.height/4)

    love.graphics.print(self.scoreNeeded, (self.width - tW)/2  , (self.height/4 - tH)/2 + self.y)
    
    love.graphics.setFont(font)
end

function TabloScore:createBarCurrentScore()
    local font = love.graphics.getFont()
    love.graphics.setFont (love.graphics.newFont (30))
    local tW = font:getWidth(self.score)
    local  tH = font:getHeight(self.score)
    love.graphics.setColor(39/255, 193/255, 211/255) 
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height/4)

    love.graphics.setColor(39/255, 193/255, 211/255) 
    love.graphics.rectangle("fill", self.x, self.y, self.width/6, self.height/4)

    love.graphics.print(self.score, (self.width - tW)/2  , (self.height - tH)/2 + self.y)
    
    love.graphics.setFont(font)
end
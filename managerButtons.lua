ManagerButtons = Object:extend()
require "buttons/resetButton"
require "buttons/stepButton"

function ManagerButtons:new()
    self.resetButton = ResetButton(0, 0)
    self.stepButton = StepButton(0, 0)
end

function ManagerButtons:clickButton(x, y, button)
   local buttons = {self.resetButton, self.stepButton}
   for i =1, #buttons do
    buttons[i]:mousepressed(x,y, button)
   end
   
    -- if self.resetButton:isMouseOver(x, y) then
     --   self.resetButton:mousepressed()
      --  return
    --end
   -- if self.steButton:isMouseOver(x, y) then
     --   self.steButtonetButton:mousepressed()
      --  return
   -- end
end

function ManagerButtons:getResetButton()
    return self.resetButton
end

function ManagerButtons:getStepButton()
    return self.stepButton
end

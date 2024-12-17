require "src.buttons.Button"


CombinationButton = Button:extend()

function CombinationButton:new()
    CombinationButton.super:new()
     
    self.combination = nil
end
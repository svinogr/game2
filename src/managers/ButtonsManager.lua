ManagerButtons = Object:extend()
require "src.buttons.ResetButton"
require "src.buttons.TurnButton"

ButtonsTitle = {
    RESET = "reset",
    TURN = "turn"
}


function ManagerButtons:new()
    self.buttons = {}
end

function ManagerButtons:initialize(arrangement)
    -- Создаем кнопку сброса
    self.resetButton = ResetButton()
    self.resetButton.x = arrangement.zones[ZONES.GAME_BUTTONS].x
    self.resetButton.y = arrangement.zones[ZONES.GAME_BUTTONS].y
    self.resetButton.width = DEFAULT_SIZE_KNUCKLES[1]
    self.resetButton.height = DEFAULT_SIZE_KNUCKLES[2]/2
    self.resetButton.text = ButtonsTitle.RESET

    self.turnButton = TurnButton()
    self.turnButton.x = arrangement.zones[ZONES.GAME_BUTTONS].x
    self.turnButton.y = arrangement.zones[ZONES.GAME_BUTTONS].y + DEFAULT_SIZE_KNUCKLES[2]/2
    self.turnButton.width = DEFAULT_SIZE_KNUCKLES[1]
    self.turnButton.height = DEFAULT_SIZE_KNUCKLES[2]/2
    self.turnButton.text = ButtonsTitle.TURN

    table.insert(self.buttons, self.resetButton)
    table.insert(self.buttons, self.turnButton)

end

function ManagerButtons:update(dt)
    for _, button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function ManagerButtons:draw()
    for _, button in ipairs(self.buttons) do
        button:draw()
    end
end

function ManagerButtons:mousepressed(x, y, button)
    for _, btn in ipairs(self.buttons) do
        btn:mousepressed(x, y, button)
    end
end

function ManagerButtons:mousereleased(x, y, button)
    for _, btn in ipairs(self.buttons) do
        btn:mousereleased(x, y, button)
    end
end

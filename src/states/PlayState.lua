require "src.objects.Backside"
require "src.managers.ManagerKnuckles"
require "src.objects.Knuckle"
require "src.managers.DealingManager"
require "src.managers.ArrangmentMAnager"

GameStates = {
    DEALING = "dealing",      -- Раздача карт
    PLAYER_TURN = "turn",     -- Ход игрока
    DISCARD = "discard",      -- Сброс
    SCORING = "scoring"       -- Подсчет очков
}

PlayState = BaseState:extend()

function PlayState:new()
    local countKnucles = 5

    -- Создаем менеджеры
    self.backSideKnucle = BackSide(DEFAULT_SIZE_KNUCKLES, DEFAULT_START_POSITION_KNUCKLES)
  --  self.mKnucles = ManagerKnuckles(DEFAULT_SIZE_KNUCKLES, DEFAULT_START_POSITION_KNUCKLES)
    self.arrangement = ManagerArrangement()
    self.arrangement:initialize(countKnucles)  -- Инициализируем на 5 карт в руке
     self.dealingManager = DealingManager()
    self.knucklesManager = ManagerKnuckles()
    self.knucklesManager:initialize()
    self.dealingManager:initialize(self.arrangement, self.knucklesManager)
 
    self.handDeck = {}
    
    self.curentState = GameStates.DEALING

    
    -- Флаги для отладки
    self.debugMode = true
end

function PlayState:update(dt)
    if self.curentState == GameStates.DEALING then
        self.dealingManager:update(dt)
        self.handDeck = self.dealingManager.handDeck
        --и первая раздача завершена, переходим к ходу игрока
        if self.dealingManager.isFirstDealing >= 5 then
            self.curentState = GameStates.PLAYER_TURN
        end
    end
end

function PlayState:render()
    self:drawTable()
    self.backSideKnucle:draw(DEFAULT_COLOR_BACKSIDE)
    
    -- Отрисовка карт
    for _, knuckle in ipairs(self.handDeck) do
        knuckle:draw(DEFAULT_COLOR_KNUCKLE)
    end
    
    -- Отрисовка зон в режиме отладки
    if self.debugMode then
        self.arrangement:debugRender()
    end
end

function PlayState:enter()
    -- Инициализация начальной раздачи
   -- self.deckKnucles = self.
end

function PlayState:exit()
end

function PlayState:drawTable()
    love.graphics.setColor(255 / 255, 145 / 255, 43 / 255)
    love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

-- Обработка кликов мыши
function PlayState:mousepressed(x, y, button)
    if button == 1 then  -- Левый клик
        if self.curentState == GameStates.PLAYER_TURN then
            -- Проверяем, в какой зоне был клик
            if self.arrangement:isInZone(x, y, "hand") then
                -- Обработка клика по карте в руке
                -- TODO: Добавить выбор карты
            elseif self.arrangement:isInZone(x, y, "discard") then
                -- Обработка клика по зоне сброса
                -- TODO: Добавить сброс выбранной карты
            end
        end
    end
end
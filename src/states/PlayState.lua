-- Подключение необходимых модулей
require "src.objects.Backside"
require "src.managers.ManagerKnuckles"
require "src.objects.Knuckle"
require "src.managers.DealingManager"
require "src.managers.ArrangmentMAnager"

-- Состояния игры
GameStates = {
    DEALING = "dealing",      -- Раздача карт
    PLAYER_THINK = "think",   -- Игрок думает над ходом
    PLAYER_TURN = "turn",     -- Ход игрока
    DISCARD = "discard",      -- Сброс
    SCORING = "scoring"       -- Подсчет очков
}

PlayState = BaseState:extend()

--[[ Инициализация состояния игры ]]
function PlayState:new()
    local countKnucles = 5    -- Количество костяшек в руке

    -- Создание основных игровых менеджеров
    self.backSideKnucle = BackSide(DEFAULT_SIZE_KNUCKLES, DEFAULT_START_POSITION_KNUCKLES)
    self.arrangement = ManagerArrangement()
    self.arrangement:initialize(countKnucles)
    self.dealingManager = DealingManager()
    self.knucklesManager = ManagerKnuckles()
    self.knucklesManager:initialize()
    self.dealingManager:initialize(self.arrangement, self.knucklesManager)
 
    -- Инициализация колоды в руке
    self.handDeck = {}
    
    -- Установка начального состояния
    self.curentState = GameStates.DEALING
    
    -- Флаги для отладки
    self.debugMode = true
end

--[[ Обновление состояния игры ]]
function PlayState:update(dt)
    -- Обработка состояния раздачи
    if self.curentState == GameStates.DEALING then
        self.dealingManager:update(dt)
        self.handDeck = self.dealingManager.handDeck
        
        -- Если первая раздача завершена, переходим к ходу игрока
        if self.dealingManager.isFirstDealing >= 5 then
            self.curentState = GameStates.PLAYER_THINK
        end
    end

    -- Обработка состояния размышления игрока
    if self.curentState == GameStates.PLAYER_THINK then
        for i = 1, #self.handDeck do
            -- Обработка наведения мыши
            if love.keyboard.hover(self.handDeck[i]) then
                self.handDeck[i].isHover = true
            else 
                self.handDeck[i].isHover = false
            end
            
            -- Обработка выбора костяшки
            if love.mouse.isDown(1) and love.keyboard.mouseWasPressedOn(self.handDeck[i]) then  
                print("mousepressed")
                self.handDeck[i]:select()
            end
        end
    end
end

--[[ Отрисовка игрового состояния ]]
function PlayState:render()
    -- Отрисовка игрового стола
    self:drawTable()
    
    -- Отрисовка рубашки костяшек
    self.backSideKnucle:draw(DEFAULT_COLOR_BACKSIDE)
    
    -- Отрисовка костяшек в руке
    for _, knuckle in ipairs(self.handDeck) do
        knuckle:draw(DEFAULT_COLOR_KNUCKLE)
    end
    
    -- Отрисовка отладочной информации
    if self.debugMode then
        self.arrangement:debugRender()
    end
end

--[[ Вспомогательные методы ]]
-- Отрисовка игрового стола
function PlayState:drawTable()
    love.graphics.setColor(255 / 255, 145 / 255, 43 / 255)
    love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

-- Обработка входа в состояние
function PlayState:enter()
    -- TODO: Инициализация начальной раздачи
end

-- Обработка выхода из состояния
function PlayState:exit()
end

-- Обработка кликов мыши
function PlayState:mousepressed(x, y, button)
    if button == 1 then  -- Левый клик
        if self.curentState == GameStates.PLAYER_TURN then
            -- Проверка зоны клика
            if self.arrangement:isInZone(x, y, "hand") then
                -- TODO: Добавить выбор карты
            elseif self.arrangement:isInZone(x, y, "discard") then
                -- TODO: Добавить сброс выбранной карты
            end
        end
    end
end
-- Подключение необходимых модулей
require "src.objects.Backside"
require "src.managers.ManagerKnuckles"
require "src.objects.Knuckle"
require "src.managers.DealingManager"
require "src.managers.ArrangmentManager"
require "src.managers.ButtonsManager"
require "src.managers.MovingManager"

-- Состояния игры
GameStates = {
    DEALING = "dealing",    -- Раздача карт
    PLAYER_THINK = "think", -- Игрок думает над ходом
    PLAYER_TURN = "turn",   -- Ход игрока
    DISCARD = "discard",    -- Сброс
    SCORING = "scoring"     -- Подсчет очков
}

PlayState = BaseState:extend()

--[[ Инициализация состояния игры ]]
function PlayState:new()
    local countKnucles = 5 -- Количество костяшек в руке

    -- Создание основных игровых менеджеров
    self.backSideKnucle = BackSide(DEFAULT_SIZE_KNUCKLES, DEFAULT_START_POSITION_KNUCKLES)
    self.arrangement = ManagerArrangement()
    self.arrangement:initialize(countKnucles)
    self.dealingManager = DealingManager()
    self.knucklesManager = ManagerKnuckles()
    self.movingManager = MovingManager()
    self.movingManager:initialize(self.arrangement)
    self.knucklesManager:initialize()
    self.dealingManager:initialize(self.arrangement, self.knucklesManager)
    self.buttonsManager = ManagerButtons()
    self.buttonsManager:initialize(self.arrangement)

    -- Инициализация колоды в руке
    self.handDeck = {}
    self.resetKnucles = {}
    self.buttons = {}

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

        for i = 1, #self.buttons do
            if love.keyboard.hover(self.buttons[i]) then
                self.buttons[i].isHover = true
            else
                self.buttons[i].isHover = false
            end

            --нажатие на кнопку
            if love.mouse.isDown(1) and love.keyboard.mouseWasPressedOn(self.buttons[i]) then
                print("mousepressed")
                self.buttons[i]:select()

                for i = 1, #self.handDeck do
                    if self.handDeck[i].isSelect then
                        table.insert(self.resetKnucles, self.handDeck[i])
                    end
                end

                if self.buttons[i].text == ButtonsTitle.RESET and #self.resetKnucles > 0 then
                    self.curentState = GameStates.DISCARD
                elseif self.buttons[i].text == ButtonsTitle.TURN and #self.resetKnucles > 0 then
                    self.curentState = GameStates.PLAYER_TURN
                end

                self.buttons[i].isHover = false
            end
        end
    end

    if self.curentState == GameStates.DISCARD then
        print("DISCARD")
        self.movingManager:update(dt, self.resetKnucles, GameStates.DISCARD)


        local changingState = #self.resetKnucles
        for i = 1, #self.resetKnucles do
            if self.resetKnucles[i].isSelect == true then
                changingState = changingState - 1
            end

        end
        
        if changingState == #self.resetKnucles then
            self.curentState = GameStates.PLAYER_THINK
            self.resetKnucles = {}

            -- освобождение  позиции руки и удалить карты из руки
            -- выделение элемента происходит неограничено. ограничить 
          
        end
    end

    if self.curentState == GameStates.PLAYER_TURN then
        print("PLAYER_TURN")
    end
end

--[[ Отрисовка игрового состояния ]]
function PlayState:render()
    -- Отрисовка фона
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(1, 1, 1)

    -- Отрисовка игрового стола
    self:drawTable()

    -- Отрисовка рубашки костяшек
    self.backSideKnucle:draw(DEFAULT_COLOR_BACKSIDE)


    -- Отрисовка костяшек в руке
    for _, knuckle in ipairs(self.handDeck) do
        knuckle:draw(DEFAULT_COLOR_KNUCKLE)
    end

    -- Отрисовка кнопок
    if self.buttonsManager then
        self.buttonsManager:draw()
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
    self.buttons = self.buttonsManager.buttons
    -- TODO: Инициализация начальной раздачи
end

-- Обработка выхода из состояния
function PlayState:exit()
end

-- Обработка кликов мыши
function PlayState:mousepressed(x, y, button)
    if button == 1 then -- Левый клик
        if self.curentState == GameStates.PLAYER_TURN then
            -- Проверка зоны клика
            if self.arrangement:isInZone(x, y, "hand") then
                -- TODO: Добавить выбор карты
            elseif self.arrangement:isInZone(x, y, "discard") then
                -- TODO: Добавить сброс выбранной карты
            end
        end
    end

    -- Обработка нажатий кнопок
    if self.buttonsManager then
        self.buttonsManager:mousepressed(x, y, button)
    end
end

function PlayState:mousereleased(x, y, button)
    -- Обработка отпускания кнопок
    if self.buttonsManager then
        self.buttonsManager:mousereleased(x, y, button)
    end
end

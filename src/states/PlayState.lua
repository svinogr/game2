-- Подключение необходимых модулей
require "src.objects.Backside"
require "src.managers.KnuckleManager"
require "src.objects.Knuckle"
require "src.managers.DealingManager"
require "src.managers.ArrangmentManager"
require "src.managers.ButtonsManager"
require "src.managers.MovingManager"
require "src.managers.ScoreManager"
require "src.states.CombinationStates"

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
    local countKnucles = 5 -- Количество костяшек в руке/ все начальные перемнные перенсети в ентер
    local scoreStart = 100

    -- Создание основных игровых менеджеров
    self.backSideKnucle = BackSide(DEFAULT_SIZE_KNUCKLES, DEFAULT_START_POSITION_KNUCKLES)
    self.arrangement = ManagerArrangement()
    self.arrangement:initialize(countKnucles)

    self.scoreManager = ScoreManager()
    self.scoreManager:initialize(scoreStart, self.arrangement)

    self.dealingManager = DealingManager()

    self.knucklesManager = KnucklesManager()
    self.knucklesManager:initialize()

    self.movingManager = MovingManager()
    self.movingManager:initialize(self.arrangement)

    --self.dealingManager:initialize(self.arrangement, self.knucklesManager)
    self.buttonsManager = ManagerButtons()
    self.buttonsManager:initialize(self.arrangement)

    -- Инициализация колоды в руке
    self.handDeck = {}
    self.buttons = {}

    -- Установка начального состояния
    self.currentState = GameStates.DEALING



    -- Флаги для отладки
    self.debugMode = true
end

--[[ Обновление состояния игры ]]
function PlayState:update(dt)
    -- Обработка состояния раздачи
    if self.currentState == GameStates.DEALING then
        -- ролучаем свободные позиции
        local freeHandPositions = self.arrangement:getFreeHandPositions()
        local knucles = nil
        if #freeHandPositions == 0 then
            knucles = self.knucklesManager.handDeck
        else
            -- получить карты по количеству свободных позиций
            knucles = self.knucklesManager:getRandomKnucles(#freeHandPositions)
            -- назначить карты в свободные позиции
            self.knucklesManager:addKnucklesToHandDeck(knucles, freeHandPositions)
        end


        -- переместить карты на нужную позицию
        self.movingManager:update(dt, knucles, GameStates.DEALING)
        -- изменить состояние
        if self.movingManager.complete then
            self.currentState = GameStates.PLAYER_THINK
        end
    end

    -- Обработка состояния размышления игрока
    if self.currentState == GameStates.PLAYER_THINK then
        for i = 1, #self.knucklesManager.handDeck do
            -- Обработка наведения мыши
            if love.keyboard.hover(self.knucklesManager.handDeck[i]) then
                self.knucklesManager.handDeck[i].isHover = true
            else
                self.knucklesManager.handDeck[i].isHover = false
            end

            -- Обработка выбора костяшки
            if love.mouse.isDown(1) and love.keyboard.mouseWasPressedOn(self.knucklesManager.handDeck[i]) then
                print("mousepressed")
                self.knucklesManager.handDeck[i]:select()
                self.knucklesManager:addKnucklesToSelected(self.knucklesManager.handDeck[i])

                self.scoreManager.complete = false
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

                if self.buttons[i].text == ButtonsTitle.RESET and #self.knucklesManager.selectedKnucles > 0 then
                    self.currentState = GameStates.DISCARD
                elseif self.buttons[i].text == ButtonsTitle.TURN and #self.knucklesManager.selectedKnucles == 3 then
                    -- получим комбинацию в которую нужно перевернуть карты
                    local usedCombinationOrder = self.scoreManager.combinations[1].curentCombination
                    self.knucklesManager:replaceOrderKnucles(usedCombinationOrder)

                    self.currentState = GameStates.PLAYER_TURN
                end

                self.buttons[i].isHover = false
            end
        end

        print("selectede " .. #self.knucklesManager.selectedKnucles)
        if not self.scoreManager.complete then
            self.scoreManager:update(dt, self.knucklesManager.selectedKnucles, GameStates.PLAYER_THINK)
        end
    end

    if self.currentState == GameStates.DISCARD then
        print("DISCARD")
        self.movingManager:update(dt, self.knucklesManager.selectedKnucles, GameStates.DISCARD)
        self.scoreManager:update(dt, nil, GameStates.DISCARD)
        if self.movingManager.complete then
            print("change state")
            self.currentState = GameStates.DEALING
            self.arrangement:clearHandPositions(self.knucklesManager.selectedKnucles)
            self.knucklesManager:removeSelectedKnucles()
        end
    end

    if self.currentState == GameStates.PLAYER_TURN then
        print("PLAYER_TURN")
        self.movingManager:update(dt, self.knucklesManager.selectedKnucles, GameStates.PLAYER_TURN)

        if self.movingManager.complete then
            print("change state")
            self.currentState = GameStates.SCORING
            self.scoreManager:addToscoringKnucles(self.knucklesManager.selectedKnucles        ) 
            --- self.knucklesManager:removeSelectedKnucles() перенести в scoring
        end
    end


    if self.currentState == GameStates.SCORING then  -- Проверяем, находится ли текущее состояние в SCORING
        print("SCORING")  -- Выводим сообщение о текущем состоянии
        print(tostring(dt))  -- Выводим значение dt, чтобы видеть время, прошедшее с последнего кадра
    
        if not self.scoreManager.isComplete then  -- Проверяем, завершено ли состояние в ScoreManager
            local curentKnuckle = self.scoreManager.scoringKnucles[1]  -- Получаем первый объект из списка scoringKnucles

            self.movingManager:scaleUp(dt, curentKnuckle)  -- Увеличиваем масштаб текущего объекта
    
            if curentKnuckle.isScale and not curentKnuckle.isScored then  -- Проверяем, находится ли объект в состоянии масштабирования и не был ли он уже оценен
                self.scoreManager:update(dt, { curentKnuckle }, GameStates.SCORING)  -- Обновляем счет для текущего объекта
            end
    
            if curentKnuckle.isScale then  -- Проверяем, находится ли объект в состоянии масштабирования
                self.movingManager:scaleDown(dt, curentKnuckle)  -- Уменьшаем масштаб текущего объекта
                if not curentKnuckle.isScale then  -- Если объект больше не в состоянии масштабирования
                    self.scoreManager:removeScoringKnucles(curentKnuckle)  -- Удаляем объект из списка scoringKnucles в ScoreManager
                end
            end
        end
        
        if self.scoreManager.isComplete then  -- Проверяем, завершено ли состояние в ScoreManager
            print("change state scoring complete")  -- Выводим сообщение о завершении состояния SCORING
            -- self.movingManager.complete = false  -- Комментарий о том, что состояние в MovingManager может быть сброшено
            self.movingManager:update(dt, self.knucklesManager.selectedKnucles, GameStates.DISCARD)  -- Обновляем состояние объектов в MovingManager
            
            if self.movingManager.complete then  -- Проверяем, завершены ли действия в MovingManager
                self.arrangement:clearHandPositions(self.knucklesManager.selectedKnucles)  -- Очищаем позиции рук для выбранных объектов
                self.knucklesManager:removeSelectedKnucles()  -- Удаляем выбранные объекты из KnucklesManager
                self.scoreManager.isComplete = false  -- Сбрасываем состояние завершенности в ScoreManager
                self.currentState = GameStates.DEALING  -- Устанавливаем текущее состояние в DEALING
            end
        end
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
    -- отрисовка табло очков
    self.scoreManager:render()
    -- Отрисовка рубашки костяшек
    self.backSideKnucle:draw(DEFAULT_COLOR_BACKSIDE)


    -- Отрисовка кнопок
    if self.buttonsManager then
        self.buttonsManager:draw()
    end
    -- Отрисовка костяшек в руке
    for _, knuckle in ipairs(self.knucklesManager.handDeck) do
        knuckle:draw(DEFAULT_COLOR_KNUCKLE)
    end

    -- Отрисовка отладочной информации
    if self.debugMode then
        self.arrangement:debugRender()
    end
    -- Отрисовка табло очков
    self.scoreManager:render()
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
        if self.currentState == GameStates.PLAYER_TURN then
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

--[[ function PlayState:drawCombinations()
    x = VIRTUAL_WIDTH / 2
    y = VIRTUAL_HEIGHT / 2
     local str = ""
    for i = 1, #self.combinations do
         local combo = self.combinations[i]

        for j = 1, #combo do
            str = str..combo[j].v1.."-"..combo[j].v2.."_"

        end


    end
    love.graphics.print(str, x, y)
end
 ]]

DealingManager = Object:extend()
local Timer = require "src.lib.knife.timer"

function DealingManager:new()
    self.isFirstDealing = 0
    self.speed = 500
    self.isAddingNewCards = false
     self.usedNumbers = {}
    self.deck = {}
    self.handDeck = {}
end

function DealingManager:initialize( managerArrangement, managerKnuckles)
    self.managerKnuckles = managerKnuckles
    self.managerArrangement = managerArrangement
    self.deck = self.managerKnuckles.deck 
    -- получаем рандомные карты
    self.handDeck = self.managerKnuckles:getRandomKnucles(5)
end

-- Обновление состояния раздачи
function DealingManager:update(dt)
    if not self.managerArrangement then return end
    
    if self.isFirstDealing < 5 then
        self:handleFirstDealing(dt)
    end

    for i = 1, #self.handDeck do
       self.handDeck[i]:update(dt)
    end
    
--[[     if self.isAddingNewCards then
        self:handleNewCardsDealing(dt)
    end ]]
end

-- Обработка первой раздачи
function DealingManager:handleFirstDealing(dt)
       for i = 1, #self.managerArrangement.handPositions.x do
        if self.handDeck[i].isMove then
          local dx = self.managerArrangement.handPositions.x[i] - self.handDeck[i].x
          local dy = self.managerArrangement.handPositions.y[i] - self.handDeck[i].y
  
          if math.abs(dx) < 1 and math.abs(dy) < 1 then
            self.handDeck[i].isMove = false
            self.isFirstDealing = self.isFirstDealing + 1
          else
            local speed = self.speed * dt
            self.handDeck[i].x = self.handDeck[i].x + math.max(-speed * dt, math.min(speed , dx))
            self.handDeck[i].y = self.handDeck[i].y + math.max(-speed* dt, math.min(speed , dy))
          end
        end
      end

    
end



-- Добавление новых карт после сброса
function DealingManager:addNewCards(deckSize)
    if not self.managerKnuckles then return end
    self.managerKnuckles:addNewKnucles(deckSize)
    self.isAddingNewCards = true
end

-- Обработка раздачи новых карт
function DealingManager:handleNewCardsDealing(dt)
    if not self.managerKnuckles or not self.managerKnuckles.handDeck then return end
    
    local hand = self.managerKnuckles.handDeck
    local positions = self.managerArrangement.handPositions -- Исправлено с handsPositions на handPositions
    local allCardsPlaced = true

    if not positions or not positions.x then return end

    for i = 1, #positions.x do
        if hand[i] and hand[i].isMove then
            allCardsPlaced = false
            local dx = positions.x[i] - hand[i].x
            local dy = positions.y[i] - hand[i].y

            if math.abs(dx) < 1 and math.abs(dy) < 1 then
                hand[i].isMove = false
                self.managerArrangement:occupyHandPosition(i)
            else
                local speed = self.speed * dt
                hand[i].x = hand[i].x + math.max(-speed * dt, math.min(speed, dx))
                hand[i].y = hand[i].y + math.max(-speed * dt, math.min(speed, dy))
            end
        end
    end

    if allCardsPlaced then
        self.isAddingNewCards = false
    end
end

-- Сброс состояния раздачи
function DealingManager:reset()
    self.isFirstDealing = 0
    self.isAddingNewCards = false
end




return DealingManager

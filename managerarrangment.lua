ManagerArrangment = Object:extend()
require "manager_knuckles"
require "managerButtons"

function ManagerArrangment:new(deckSize, mB, mk)
  self.decksize                = deckSize
 
  self.managerButtons =  mB

  self.managerKnucle = mk

  self.isDealing = true

  self.handsPositions          = {}
  self.handsPositions.x        = {}
  self.handsPositions.y        = {}
  self.handsPositions.isFree = {}
  
  self.resetPositions = {10, 350}

  --self.handsPositions.step     = 70
  -- размер поля для розданых карт
  self.placeHandDeck           = {}
  self.placeHandDeck.size      = 500
  self.placeHandDeck.startPosx = 150
  self.placeHandDeck.startPosy = 500
  self.placeHandDeck.fon = {}
  self.placeHandDeck.fon.startx = 140
  self.placeHandDeck.fon.starty = 495
  self.placeHandDeck.fon.lenght = deckSize * 100 + 20
  self.placeHandDeck.fon.height = 110

  self.placeButtons = {}
  self.placeButtons.fon = {}
  self.placeButtons.fon.startx = 690
  self.placeButtons.fon.starty = 495
  self.placeButtons.fon.lenght = 100
  self.placeButtons.fon.height = 150
  self.placeButtons.resetButton = {700, 500}
  self.placeButtons.steButton = {700, 550}

  self.placeTable = {}
  self.placeTable.fon = {}
  self.placeTable.fon.startx = 150
  self.placeTable.fon.starty = 150
  self.placeTable.fon.lenght = deckSize * 90 + 20
  self.placeTable.fon.height = 300
  self.placeTable.startx = 170+ 20
  self.placeTable.starty = 335

  self.paddingLeftX            = 10
  self.placeBackSideDeck       = {}
  self.placeBackSideDeck.x     = 10
  self.placeBackSideDeck.y     = 500
  self.backsideIsDraw          = false
  self.deckHandIsDraw          = false
end

function ManagerArrangment:setPositionFor(knucle, x, y)
  knucle.x = x
  knucle.y = y
end

-- function ManagerArrangment:showResetKnucles(knucle)

--    self:setPositionFor(knucle, 0, 0)

-- end

-- function ManagerArrangment:showSelectedKnucles(x, y)
--   local deck = self.managerKnucle.handDeck
--     for i = 1, #deck do
--       if (deck[i]:isMouseOver(x, y)) then
--         deck[i]:select()
--             end
--     end
-- end


function ManagerArrangment:isPlaceResetButtons(x, y)
  print("isPlaceResetButtons")
  return x > self.placeButtons.resetButton[1]  and y > self.placeButtons.resetButton[2] 
  and x < self.placeButtons.resetButton[1]  + SizeResetButton[1]
  and y < self.placeButtons.resetButton[2] + SizeResetButton[2]
end

function ManagerArrangment:isPlaceSteButtons(x, y)
  print("SteButtonseButton")
  return x > self.placeButtons.steButton[1]  and y > self.placeButtons.steButton[2] 
  and x < self.placeButtons.steButton[1]  + SizeStepButton[1]
  and y < self.placeButtons.steButton[2] + SizeStepButton[2]
end


function ManagerArrangment:isPlaceDeckHand(x, y)
  print("isPlaceDeckHand")
  return  x > self.placeHandDeck.fon.startx and y > self.placeHandDeck.fon.starty 
            and x < self.placeHandDeck.fon.startx + self.placeHandDeck.fon.lenght
            and y < self.placeHandDeck.fon.starty + self.placeHandDeck.fon.height 
end

-- function ManagerArrangment:moveKnucleToResetPosition(speed, knucle)
--  -- for i = 1, #self.managerArrangment.handsPositions.x do
--    --  local isMoove = nil
--     if knucle.isMove then
--       local dx = self.resetPositions[1] - knucle.x
--       local dy = self.resetPositions[2] - knucle.y

--       if math.abs(dx) < 1 and math.abs(dy) < 1 then
--        -- knucle.isMove = false
--         --self.isFirstDealing = self.isFirstDealing + 1
--         --isMoove = false
--         knucle.isSelect = false
--       else
--         --local speed = self.speed * dt
--         knucle.x = knucle.x + math.max(-speed , math.min(speed , dx))
--         knucle.y =knucle.y + math.max(-speed, math.min(speed , dy))
--         knucle.isSelect =  true
--         -- Увеличиваем угол вращения
--         -- card.angle = card.angle + 5 * dt -- Измените 5 на любое значение для изменения скорости вращения
--       end
--     end
--  -- end
--  --return isMoove
  
-- end



-- DRAW
function ManagerArrangment:draw()
  -- self:drawTable()
  -- self:drawButtons()
  -- self:drawHandDeck()
  -- self:drawBacksideDeck()
end

function ManagerArrangment:drawTable()
  love.graphics.setColor(255 / 255, 145 / 255, 43 / 255)

  love.graphics.rectangle("fill", 
  self.placeTable.fon.startx,self.placeTable.fon.starty,self.placeTable.fon.lenght,self.placeTable.fon.height)
  love.graphics.setColor(0, 0, 0)
  love.graphics.circle("fill",self.placeTable.startx, self.placeTable.starty, 2)

end


function ManagerArrangment:drawButtons()
  love.graphics.setColor(255 / 255, 145 / 255, 43 / 255)
  love.graphics.rectangle("fill", self.placeButtons.fon.startx, self.placeButtons.fon.starty, self.placeButtons.fon.lenght, self.placeButtons.fon.height)
  local res = self.managerButtons:getResetButton()
  local ste = self.managerButtons:getStepButton()
  self:setPositionFor(res, self.placeButtons.resetButton[1], self.placeButtons.resetButton[2])
  res:draw()
  self:setPositionFor(ste, self.placeButtons.steButton[1], self.placeButtons.steButton[2])
  ste:draw()
end

function ManagerArrangment:drawHandDeck()
  love.graphics.setColor(255 / 255, 145 / 255, 43 / 255)

  love.graphics.rectangle("fill", 
  self.placeHandDeck.fon.startx,self.placeHandDeck.fon.starty,self.placeHandDeck.fon.lenght,self.placeHandDeck.fon.height)
  --отрисовываем руку
  for i = 1, #self.managerKnucle.handDeck do
    self.managerKnucle.handDeck[i]:draw(DEFAULT_COLOR_KNUCKLE)
  end
end

function ManagerArrangment:drawBacksideDeck()
  -- раздаточная обратная сторона
  local bs = self.managerKnucle:getBackside()
 -- print(bs == nil)
  self:setPositionFor(bs, self.placeBackSideDeck.x, self.placeBackSideDeck.y)
  bs:draw(DEFAULT_COLOR_BACKSIDE)
  self.backsideIsDraw = true
  -- сброс обратная сторона
  local bs = self.managerKnucle:getBackside()
 -- print(bs == nil)
  self:setPositionFor(bs, self.resetPositions[1], self.resetPositions[2])
  bs:draw(DEFAULT_COLOR_BACKSIDE)
  self.backsideIsDraw = true

end

--DRAW


function ManagerArrangment:initialize()
  print("ManagerArrangment init")
  -- расчитываем позиции руки с картами
  self:calculatePositionsForHandDeck(self.decksize)
  -- помещаем случаные карты в руку
  --self.managerKnucle:getKnucles(self.decksize)
end

function ManagerArrangment:calculatePositionsForHandDeck(qauntity)
  local sizeKnucles = DEFAULT_SIZE_KNUCKLE
  local totalSize = qauntity * sizeKnucles[1]
  local remainigSpace = self.placeHandDeck.size - totalSize
  --количество промежутков
  local gaps = qauntity - 1
  local distance = gaps > 0 and remainigSpace / gaps or 0
  --определяем позиции
  local curentPosx = self.placeHandDeck.startPosx
  local curentPosy = self.placeHandDeck.startPosy
  for i = 1, qauntity do
    self.handsPositions[i] = { x = curentPosx, y = curentPosy, free = true}
    --print(self.handsPositions.x[i])
    --print(self.handsPositions.y[i])
   -- self.handsPositions[i].isFree = true
    curentPosx = curentPosx + sizeKnucles[1] + distance
  end
end

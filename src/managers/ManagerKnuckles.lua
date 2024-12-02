ManagerKnuckles = Object:extend()
require "src.objects.Knuckle"
require "src.objects.Backside"

--создает колоду.
--карты
--руку с картами
function ManagerKnuckles:new()
  self.deck          = {}
  self.usedNumbers   = {}
  self.handDeck      = {}
  self.selectedKnucles  = {}
  self.bakside       = nil
end

function ManagerKnuckles:initialize()
self:createDeck()
end

-- добавление карт из колоды 
--[[ function ManagerKnuckles:addNewKnucles(deckSize)
     -- узнаем сколько карт нужно добавить
    local neededQyantity  = deckSize - #self.handDeck
     -- получаем карты
     print(#self.deck)
     print(#self.handDeck)
     print(deckSize)
    self:getRandomKnucles(neededQyantity)
     -- добавляем в  руку
     print(#self.deck)
     print(#self.handDeck)

  
end ]]

function ManagerKnuckles:getRandomKnucles(quantity)
  --[[  if #self.usedNumbers >= #self.deck then
        error("All numbers have been used.")
    end]]
   local deck = {} 
  for i = 1, quantity do
    local number = self:getRandomNumber()
    local kn = self.deck[number]
    --print("kn:", kn.v1, kn.v2, 50)       -- Добавьте это для отладки
    table.insert(self.handDeck, kn)
    --self.handDeck[i] = kn
  end
   return self.handDeck
end

function ManagerKnuckles: dealingKnucles(quantity)
   if #self.handDeck < quantity then
         self:getRandomKnucles(quantity)
   end
   
   return self.handDeck
  
end


function ManagerKnuckles:createDeck()
  local index = 1
  for i = 1, 6 do
    for j = 1, 6 do
      local value = { i, j }
      local kn = Knuckle(index, value, 4)
      self.deck[index] = kn
      -- print("Creating Knuckle at position:",kn.v1, kn.v2)
      index = index + 1
    end
  end
end

function ManagerKnuckles:createBackSide()
  print("create backside")
  self.bakside =  BackSide(DEFAULT_SIZE_KNUCKLE[1], DEFAULT_SIZE_KNUCKLE[2])
--  print(self.bakside == nil)
end

--[[ function ManagerKnuckles:getBackside()
  return self.bakside
end
 ]]
--[[ function ManagerKnuckles:getSelectedKnucles()
  local selected = {}
  for _, value in ipairs(self.handDeck) do
    table.insert(selected, value)
  end

  return selected
end ]]


function ManagerKnuckles:getRandomNumber()
  number = nil
  condition = true
  while condition do
    number = love.math.random(1, #self.deck)
    condition = false
    for _, element in pairs(self.usedNumbers) do
      if element == number then
        condition = true
        break
      end
    end
  end
  table.insert(self.usedNumbers, number)

  return number
end

function ManagerKnuckles:removeSelectedKnucles()
  for i =1, #self.selectedKnucles do
      for j =  #self.handDeck, 1, -1 do
         if self.selectedKnucles[i].id == self.handDeck[j].id then
          table.remove(self.handDeck, j)
          end
      end
  end

  self.selectedKnucles = {}
end




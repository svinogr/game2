require "src.objects.Knuckle"

DeckManager = Object:extend()
function DeckManager:new()
    self.usedNumbers = {}
    self.deck = {}
end


function DeckManager:getRandomNumber()
    localnumber = nil
    localcondition = true
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
  
  function ManagerKnuckles:createDeck()
    local index = 1
    for i = 1, 6 do
      for j = 1, 6 do
        local value = { i, j }
        local kn = Knuckle(value, 1)
        self.deck[index] = kn
        -- print("Creating Knuckle at position:",kn.v1, kn.v2)
        index = index + 1
      end
    end
  end
  



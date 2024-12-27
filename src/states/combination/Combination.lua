require "src.lib.classic"
local Object = require "src.lib.classic"

COMBINATION_STATES = {
    NONE = "NONE",            -- просто наибольшая костяшка
    ONE_PAIR = "One Pair",        -- подряд две. одна за другой
    THREE_OF_A_KIND = "ThreeOfKind", -- подряд три. без возрастания или убывания,
    SIMPLE_STRAIGHT = "SIMPLE STRAIGHT", -- подряд три с возрастанием или убыванием БЕЗ СЦЕПКИ
    STRAIGHT = "STRAIGHT",        -- подряд три с возрастанием или убыванием
    FLUSH = "Flush",           -- три одинаковых
}

COMBINATION_SCORE_START = {
    NONE = 0,
    ONE_PAIR = 1,
    THREE_OF_A_KIND = 2,
    SIMPLE_STRAIGHT = 3,
    STRAIGHT = 4,
    FLUSH = 5,
}


Combination = Object:extend()

function Combination:new(level, score)
    self.curentCombinationValues = 0
    self.curentCombination = {}
    self.level =  level
    self.score =  score 
    print("Initialized Combination with Score: " .. self.score .. ", Level: " .. self.level)

end

function Combination:levelUp()
    self.level = self.level + 1
end

function Combination:getScore()
    print("Score: " .. self.score .. ", Level: " .. self.level)  -- Вывод значений

    return self.score * self.level
    
end

function Combination:visualName()
    
end

function Combination:getRare()
    return 0
end

function Combination:check(combination)
    return false
end

function Combination:setCurentValues(value)
    self.curentCombinationValues = value
end

function Combination:visualCombination()

end

function Combination:draw()
 love.graphics.print(self.curentCombinationValues, 0, 0)    
end

-- NONE   просто наибольшая костяшка
NonPair = Combination:extend()

function NonPair:new()
    NonPair.super.new(self, 1, COMBINATION_SCORE_START.NONE)
end


function NonPair:getRare()
    return 1
end

function NonPair:visualName()
    return COMBINATION_STATES.NONE
end

function NonPair:check(combination)
   return true
end


--ONE_PAIR = {},        -- подряд две. одна за другой
OnePair = Combination:extend()

function OnePair:new()
    OnePair.super.new(self, 1, COMBINATION_SCORE_START.ONE_PAIR)
    end

function OnePair:getRare()
    return 2
end

function OnePair:visualName()
   return COMBINATION_STATES.ONE_PAIR 
end

function OnePair:check(combination)
    return combination[1][2] == combination[2][1] or combination[2][2] == combination[3][1]
end

--THREE_OF_A_KIND = {}, -- подряд три. без возрастания или убывания,
ThreeOfKind = Combination:extend()
function ThreeOfKind:new()
    ThreeOfKind.super.new(self, 1, COMBINATION_SCORE_START.THREE_OF_A_KIND)
end

function ThreeOfKind:getRare()
    return 3
end

function ThreeOfKind:visualName()
   return COMBINATION_STATES.THREE_OF_A_KIND 
end

function ThreeOfKind:check(combination)
    return combination[1][2] == combination[2][1] and combination[2][2] == combination[3][1]
end

-- SIMPLE_STRAIGHT = {}, -- подряд три с возрастанием или убыванием БЕЗ СЦЕПКИ
-- {{1, 2}, {3, 4}, {5, 6}}
SimpleStraight = Combination:extend()

function SimpleStraight:new()
    SimpleStraight.super.new(self, 1, COMBINATION_SCORE_START.SIMPLE_STRAIGHT)
end

function SimpleStraight:getRare()
    return 6
end

function SimpleStraight:visualName()    
    return COMBINATION_STATES.SIMPLE_STRAIGHT 
end

function SimpleStraight:check(combination)
    return combination[1][1] ==1 and combination[1][2] == 2 and combination[2][1] == 3 and  combination[2][2] == 4 and combination[3][1] == 5 and combination[3][2] == 6
end

--  STRAIGHT = {},        -- подряд три с возрастанием или убыванием
Straight = Combination:extend()

function Straight:new()
    Straight.super.new(self, 1, COMBINATION_SCORE_START.STRAIGHT)
    print("Straight "..self.score)
end

function Straight:getRare()
    return 5
end

function Straight:visualName()    
    return COMBINATION_STATES.STRAIGHT 
end

function Straight:check(combination)
    local rez = false

    if combination[1][2] - combination[1][1] == 1 and combination[2][2] - combination[2][1] == 1 and combination[3][2] - combination[3][1] == 1 then
        rez = true
    end

    if rez then
        rez = combination[1][2] == combination[2][1] and combination[2][2] == combination[3][1]
    end

    return rez
end

-- FLUSH = {},           -- три одинаковых
Flush = Combination:extend()

function Flush:new()
    Flush.super.new(self, 1, COMBINATION_SCORE_START.FLUSH)
    print("Flush "..self.score)
end
function Flush:getRare()
    return 7
end
function Flush:visualName()    
    return COMBINATION_STATES.FLUSH 
end

function Flush:check(combination)
    local rez = false
    local curValue = combination[1][1]

    if curValue == combination[1][2] then
        rez = true
    else
        rez = false
        return rez
    end

    if curValue == combination[2][1] and curValue == combination[2][2] then
        rez = true
    else
        rez = false
        return rez
    end

    if curValue == combination[3][1] and curValue == combination[3][2] then
        rez = true
    else
        rez = false
        return rez
    end

    return rez
end


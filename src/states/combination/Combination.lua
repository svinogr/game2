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


Combination = Object:extend()

function Combination:new()
    self.curentCombinationValues = 0
end

function Combination:visualName()
    
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

--ONE_PAIR = {},        -- подряд две. одна за другой
OnePair = Combination:extend()
function OnePair:visualName()
   return COMBINATION_STATES.ONE_PAIR 
end

function OnePair:check(combination)
    return combination[1][2] == combination[2][1] or combination[2][2] == combination[3][1]
end

--THREE_OF_A_KIND = {}, -- подряд три. без возрастания или убывания,
ThreeOfKind = Combination:extend()

function ThreeOfKind:visualName()
   return COMBINATION_STATES.THREE_OF_A_KIND 
end

function ThreeOfKind:check(combination)
    return combination[1][2] == combination[2][1] and combination[2][2] == combination[3][1]
end

-- SIMPLE_STRAIGHT = {}, -- подряд три с возрастанием или убыванием БЕЗ СЦЕПКИ
-- {{1, 2}, {3, 4}, {5, 6}}
SimpleStraight = Combination:extend()

function SimpleStraight:visualName()    
    return COMBINATION_STATES.SIMPLE_STRAIGHT 
end

function SimpleStraight:check(combination)
    return combination[1][1] ==1 and combination[1][2] == 2 and combination[2][1] == 3 and  combination[2][2] == 4 and combination[3][1] == 5 and combination[3][2] == 6
end

--  STRAIGHT = {},        -- подряд три с возрастанием или убыванием
Straight = Combination:extend()

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

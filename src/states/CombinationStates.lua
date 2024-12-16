Object = require "src.lib.classic"
COMBINATION_STATES = {
    NONE = {},            -- просто наибольшая костяшка
    ONE_PAIR = {},        -- подряд две. одна за другой
    THREE_OF_A_KIND = {}, -- подряд три. без возрастания или убывания,
    SIMPLE_STRAIGHT = {}, -- подряд три с возрастанием или убыванием БЕЗ СЦЕПКИ
    STRAIGHT = {},        -- подряд три с возрастанием или убыванием
    FLUSH = {},           -- три одинаковых
}
Combinations = Object:extend()

function Combinations:new()
    self.combinations = {}
    self.visualCombinations = {}
end

function Combinations:check(cards)
    if #cards < 3 then
        self.combinations = {}
        return
    end

    self:generateCombinations(cards)
    self:combinationToVisualType()

    return self.combinations
end

function Combinations:generateCombinations(objects)
    self.combinations = {}
    local valuesCards = {}
    -- получаем все значения карт
    for i = 1, #objects do
        valuesCards[i] = { objects[i].v1, objects[i].v2 }
    end

    -- получаем все варианты комбинаций из первых ДВУХ
    local twoValues = {}
    for i = 1, #valuesCards - 1 do
        for j = 1, #valuesCards - 1 do
            if i ~= j then
                table.insert(twoValues, { valuesCards[i], valuesCards[j] })
                table.insert(twoValues, { self:swap(valuesCards[i]), self:swap(valuesCards[j]) })
            end
        end
    end

    local oneValues = {}
    for i = 3, #valuesCards do
        table.insert(oneValues, { valuesCards[i] })
        table.insert(oneValues, { self:swap(valuesCards[i]) })
    end

    local merged = {}
    for i = 1, #twoValues do
        for j = 1, #oneValues do
            table.insert(merged, { twoValues[i][1], twoValues[i][2], oneValues[j][1] })
            table.insert(merged, { twoValues[i][1], oneValues[j][1], twoValues[i][2] })
            table.insert(merged, { oneValues[j][1], twoValues[i][1], twoValues[i][2] })
        end
    end
    self.combinations = merged
    print("Всего комбинаций: " .. #self.combinations .. " (должно быть 24)")
    return self.combinations
end

function Combinations:copy(combination)
    local copy = {}
    for i, v in ipairs(combination) do
        copy[i] = v
    end
    return copy
end

function Combinations:swap(val)
    return { val[2], val[1] }
end

function Combinations:combinationToVisualType()
    self.visualCombinations = {}
    local onePairCombinations = {}

    for i = 1, #self.combinations do
        -- есть комбинация [1-4] [5-5] [6-4]
        local combination = self.combinations[i]
        local pairs = self:checkOnePair(combination)
        if pairs then
            table.insert(onePairCombinations, combination)
        end

        self:checkSimpleStraight(combination)
        self:checkChainStraight(combination)
        self:checkFlush(combination)
    end
end

--ONE_PAIR = {}, -- подряд две. одна за другой
function Combinations:checkOnePair(combination)
    return combination[1][2] == combination[2][1] or combination[2][2] == combination[3][1]
end

-- SIMPLE_STRAIGHT = {}, -- подряд три с возрастанием или убыванием БЕЗ СЦЕПКИ
function Combinations:checkSimpleStraight(combination)
    return combination[2][1] - combination[1][2] == 1 and combination[3][1] - combination[2][2] == 1
end

--  THREE_OF_A_KIND = {}, -- подряд три. без возрастания или убывания,
function Combinations:checkThreeOfAKind(combination)
    return combination[1][2] == combination[2][1] and combination[2][2] == combination[3][1]
end

-- STRAIGHT = {}, -- подряд три с возрастанием или убыванием
function Combinations:checkChainStraight(combination)
    local rez = false

    if combination[1][2] - combination[1][1] == 1 and combination[2][2] - combination[2][1] == 1 and combination[3][2] - combination[3][1] == 1 then
                rez = true
    end

    if rez then
        rez = combination[1][2] == combination[2][1] and combination[2][2] == combination[3][1]
    end

    return rez
end

-- FLUSH = {}, -- три одинаковых
function Combinations:checkFlush(combination)
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

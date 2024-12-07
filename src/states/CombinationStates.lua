Object = require "src.lib.classic"
COMBINATION_STATES = {
    NONE = {},
    ONE_PAIR = {},
    TWO_PAIRS = {},
    THREE_OF_A_KIND = {},
    STRAIGHT = {},
    FLUSH = {},
    FULL_HOUSE = {},
    FOUR_OF_A_KIND = {},
    STRAIGHT_FLUSH = {}
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
                table.insert(twoValues, {valuesCards[i], valuesCards[j]})
                table.insert(twoValues, {self:swap(valuesCards[i]),self:swap(valuesCards[j])})
            end
        end
    end

    local oneValues = {}
    for i = 3, #valuesCards do
        table.insert(oneValues, {valuesCards[i]})
        table.insert(oneValues, {self:swap(valuesCards[i])})
    end
      
    local merged = {}
    for i = 1, #twoValues do
        for j = 1, #oneValues do
            table.insert(merged, {twoValues[i][1], twoValues[i][2], oneValues[j][1]})
            table.insert(merged, {twoValues[i][1],  oneValues[j][1], twoValues[i][2]})
            table.insert(merged, {oneValues[j][1], twoValues[i][1],  twoValues[i][2]})
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
        self:checkFullStraight(combination)
    end
end

function Combinations:checkOnePair(combination)
    if combination[1][2] == combination[2][1] or combination[2][2] == combination[3][1] then
       return true
    end    
   return false
 
end

function Combinations:areCompatible(pair1, pair2)
    -- Проверяем, равна ли последняя цифра первой пары первой цифре второй пары
    return pair1[2] == pair2[1]
end

function Combinations:checkSimpleStraight(inerComb)

end

function Combinations:checkChainStraight(inerComb)

end

function Combinations:checkFullStraight(inerComb)

end

local Object = require "src.lib.classic"
require "src.states.combination.Combination"


CombinationsStates = Object:extend()

function CombinationsStates:new()
    self.addedVisualCombinations = {}
    self:addStateCombinations()

    self.visualCombinations = {}

    self.allGenerationCombinations = {}
end

function CombinationsStates:check(cards)
    -- генерируем все возможные комбинации
    self:generateCombinations2(cards)
    -- создаем обьекты для визуального отоброжаения из комбинаций
    self:combinationToVisualType()

    return self.visualCombinations
end

function CombinationsStates:addStateCombinations()
    table.insert(self.addedVisualCombinations, OnePair())
    table.insert(self.addedVisualCombinations, ThreeOfKind())
    table.insert(self.addedVisualCombinations, SimpleStraight())
    table.insert(self.addedVisualCombinations, Flush())
    table.insert(self.addedVisualCombinations, Straight())
end

function CombinationsStates:generateCombinations(knuckles)
    self.allGenerationCombinations = {}
    local valuesCards = {}
    -- получаем все значения карт
    for i = 1, #knuckles do
        valuesCards[i] = { knuckles[i].v1, knuckles[i].v2 }
    end

    -- получаем все варианты для двух первых карт
    local twoValues = {}

    table.insert(twoValues, { valuesCards[1], valuesCards[2] })
    table.insert(twoValues, { self:swap(valuesCards[1]), valuesCards[2] })
    table.insert(twoValues, { valuesCards[1], self:swap(valuesCards[2]) })
    table.insert(twoValues, { self:swap(valuesCards[1]), self:swap(valuesCards[2]) })

    table.insert(twoValues, { valuesCards[2], valuesCards[1] })
    table.insert(twoValues, { self:swap(valuesCards[2]), valuesCards[1] })
    table.insert(twoValues, { valuesCards[2], self:swap(valuesCards[1]) })
    table.insert(twoValues, { self:swap(valuesCards[2]), self:swap(valuesCards[1]) })
    -- теперь варианты только третьей пары
    local oneValues = {}
    table.insert(oneValues, { valuesCards[3] })
    table.insert(oneValues, { self:swap(valuesCards[3]) })


    --  теперь соеденим
    local merged = {}
    for i = 1, #twoValues do
        for j = 1, #oneValues do
            table.insert(merged, { twoValues[i][1], twoValues[i][2], oneValues[j][1] })
            table.insert(merged, { twoValues[i][1], oneValues[j][1], twoValues[i][2] })
            table.insert(merged, { oneValues[j][1], twoValues[i][1], twoValues[i][2] })
        end
    end
    self.allGenerationCombinations = merged
    print("Всего комбинаций: " .. #self.allGenerationCombinations .. " (должно быть 24)")
end

-- работает на 0.002 быстрее
function CombinationsStates:generateCombinations2(knuckles)
    self.allGenerationCombinations = {}
    local valuesCards = {}
    -- получаем все значения карт
    for i = 1, #knuckles do
        valuesCards[i] = { knuckles[i].v1, knuckles[i].v2 }
    end

    -- получаем все варианты комбинаций из первых ДВУХ
    local twoValues = {}
    for i = 1, #valuesCards - 1 do
        for j = 1, #valuesCards - 1 do
            if i ~= j then
                table.insert(twoValues, { valuesCards[i], valuesCards[j] })
                table.insert(twoValues, { self:swap(valuesCards[i]), valuesCards[j] })
                table.insert(twoValues, { valuesCards[i], self:swap(valuesCards[j]) })
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
    self.allGenerationCombinations = merged
    print("Всего комбинаций: " .. #self.allGenerationCombinations .. " (должно быть 24)")
end

function CombinationsStates:copy(combination)
    local copy = {}
    for i, v in ipairs(combination) do
        copy[i] = v
    end
    return copy
end

function CombinationsStates:swap(val)
    return { val[2], val[1] }
end

function CombinationsStates:multiplicationResult(combination)
    return combination[1][1] * combination[1][2] + combination[2][1] * combination[2][2] +
    combination[3][1] * combination[3][2]
end

function CombinationsStates:combinationToVisualType()
    -- сброс комбинаций
    self:resetCombinations()
    -- идем по заложеным комбинациям игры
    for index, value in ipairs(self.addedVisualCombinations) do
        -- идем по полученым комбинациям
        for i = 1, #self.allGenerationCombinations do
            -- считаем мультипликацию комбинации
            local multiplication = self:multiplicationResult(self.allGenerationCombinations[i])
            if value:check(self.allGenerationCombinations[i]) then
                if value.curentCombinationValues < multiplication then
                    value.curentCombinationValues = multiplication
                end
            end
        end
    end

    for i = 1, #self.addedVisualCombinations do
        if self.addedVisualCombinations[i].curentCombinationValues > 0 then
            table.insert(self.visualCombinations, self.addedVisualCombinations[i])
        end
    end
end

function CombinationsStates:resetCombinations()
    for index, value in ipairs(self.addedVisualCombinations) do
        value.curentCombinationValues = 0
    end

    self.visualCombinations = {}
end

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
end

function Combinations:check(cards)
    self:getPermutations(cards)
end

function Combinations:getPermutations(cards)
    local qCicles = {}

    -- Определяем количество циклов
    for i = 1, #cards do
        table.insert(qCicles, true)
    end

    for i = 1, #cards do
        for j = 1, #cards do
            if j ~= i then
                if qCicles[3] ~= nil then
                    for k = 1, #cards do
                        if k ~= i and k ~= j then -- Исключаем повторение
                            -- Формируем строку комбинации и добавляем в результирующую таблицу
                            table.insert(self.combinations, { cards[i], cards[j], cards[k] })
                        end
                    end

                    else 
                        table.insert(self.combinations, { cards[i], cards[j]})
                end
                
            end
        end
    end







--[[ 
    for i = 1, #cards do
        for j = 1, #cards do
            if j ~= i then                    -- Исключаем повторение
                for k = 1, #cards do
                    if k ~= i and k ~= j then -- Исключаем повторение
                        -- Формируем строку комбинации и добавляем в результирующую таблицу
                        table.insert(self.combinations, { cards[i], cards[j], cards[k] })
                    end
                end
            end
        end
    end ]]
end

function Combinations:print()
    -- love.graphics.setFont(love.graphics.newFont(20)) -- Устанавливаем размер шрифта
        for i, combo in ipairs(self.combinations) do                
    --[[     love.graphics.print("Комбинация " .. i .. ": {" .. combo[1].v1 .. "-" .. combo[2].v1 .. combo[3].v1 .. "}", 50,
            50 * i) ]]
love.graphics.print("Комбинация ")
              combo[1]:print()  
    end
end

ManagerArrangement = Object:extend()
require "src.objects.Knuckle"
require "src.objects.Backside"

-- Константы для зон на столе
local ZONES = {
    HAND = "hand",           -- Зона руки игрока
    DISCARD = "discard",     -- Зона сброса
    DECK = "deck"           -- Зона колоды
}

function ManagerArrangement:new()
    -- Позиции для карт в руке
    self.handPositions = {
        x = {},
        y = {},
        isFree = {}  -- true если позиция свободна
    }

    -- Позиции для сброшенных карт
    self.discardPositions = {
        x = {},
        y = {},
        isFree = {}
    }

    -- Размеры и позиции зон
    local handZoneY = VIRTUAL_HEIGHT - DEFAULT_SIZE_KNUCKLES[2] - 10
    
    self.zones = {
        [ZONES.HAND] = {
            x = DEFAULT_SIZE_KNUCKLES[1] + 40,
            y = handZoneY,
            width = VIRTUAL_WIDTH - 140,
            height = DEFAULT_SIZE_KNUCKLES[2] 
        },
        [ZONES.DISCARD] = {
            x = 10,
            y = handZoneY - DEFAULT_SIZE_KNUCKLES[2] - 10,
            width = DEFAULT_SIZE_KNUCKLES[1] + 15,-- чтобы было видно из под карт
            height = DEFAULT_SIZE_KNUCKLES[2]
        },
        [ZONES.DECK] = {
            x = 10,
            y = VIRTUAL_HEIGHT- DEFAULT_SIZE_KNUCKLES[2] - 10,
            width = DEFAULT_SIZE_KNUCKLES[1] + 15, -- чтобы было видно из под карт
            height = DEFAULT_SIZE_KNUCKLES[2]
        }
    }
end

function ManagerArrangement:initialize(handSize)
    -- Инициализация позиций для карт в руке
    local spacing = 10  -- Расстояние между картами
    local cardWidth = DEFAULT_SIZE_KNUCKLES[1]
    local startX = self.zones[ZONES.HAND].x
    local y = self.zones[ZONES.HAND].y

    for i = 1, handSize do
        self.handPositions.x[i] = startX + (i-1) * (cardWidth + spacing)
        self.handPositions.y[i] = y
        self.handPositions.isFree[i] = true
    end

    -- Инициализация позиций для сброшенных карт
    local discardX = self.zones[ZONES.DISCARD].x
    local discardY = self.zones[ZONES.DISCARD].y

    for i = 1, 10 do  -- Максимум 10 карт в зоне сброса
        self.discardPositions.x[i] = discardX + (i-1) * 5  -- Небольшое смещение для эффекта стопки
        self.discardPositions.y[i] = discardY
        self.discardPositions.isFree[i] = true
    end
end

-- Проверка, находится ли точка в зоне
function ManagerArrangement:isInZone(x, y, zone)
    local z = self.zones[zone]
    return x >= z.x and x <= z.x + z.width and
           y >= z.y and y <= z.y + z.height
end

-- Получить свободную позицию в руке
function ManagerArrangement:getFreeHandPosition()
    for i = 1, #self.handPositions.isFree do
        if self.handPositions.isFree[i] then
            return i
        end
    end
    return nil
end

-- Получить свободную позицию в зоне сброса
function ManagerArrangement:getFreeDiscardPosition()
    for i = 1, #self.discardPositions.isFree do
        if self.discardPositions.isFree[i] then
            return i
        end
    end
    return nil
end

-- Занять позицию в руке
function ManagerArrangement:occupyHandPosition(index)
    if index and self.handPositions.isFree[index] then
        self.handPositions.isFree[index] = false
        return true
    end
    return false
end

-- Освободить позицию в руке
function ManagerArrangement:freeHandPosition(index)
    if index and not self.handPositions.isFree[index] then
        self.handPositions.isFree[index] = true
        return true
    end
    return false
end

-- Отрисовка зон (для отладки)
function ManagerArrangement:debugRender()
    -- Сохраняем текущий цвет
    local r, g, b, a = love.graphics.getColor()
    
    -- Отрисовка зоны руки
    love.graphics.setColor(0, 1, 0, 0.2)
    love.graphics.rectangle("fill", 
        self.zones[ZONES.HAND].x, 
        self.zones[ZONES.HAND].y,
        self.zones[ZONES.HAND].width,
        self.zones[ZONES.HAND].height
    )

    -- Отрисовка зоны сброса
    love.graphics.setColor(1, 0, 0, 0.2)
    love.graphics.rectangle("fill",
        self.zones[ZONES.DISCARD].x,
        self.zones[ZONES.DISCARD].y,
        self.zones[ZONES.DISCARD].width,
        self.zones[ZONES.DISCARD].height
    )

    -- Отрисовка зоны колоды
    love.graphics.setColor(0, 0, 1, 0.2)
    love.graphics.rectangle("fill",
        self.zones[ZONES.DECK].x,
        self.zones[ZONES.DECK].y,
        self.zones[ZONES.DECK].width,
        self.zones[ZONES.DECK].height
    )

    -- Восстанавливаем исходный цвет
    love.graphics.setColor(r, g, b, a)
end

return ManagerArrangement

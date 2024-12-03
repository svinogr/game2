require "src.objects.Knuckle"
require "src.objects.Backside"
ManagerArrangement = Object:extend()
-- Константы для зон на столе
 ZONES = {
    HAND = "hand",           -- Зона руки игрока
    DISCARD = "discard",     -- Зона сброса
    DECK = "deck",
    GAME_BUTTONS = "game_buttons", -- Зона кнопок хода
    GAME_FIELD = "game_field",
    GAME_TABLO = "game_tablo"
}

QAUNTITY_ITEMS_GAME_FIELD = 3 -- количество карт на игровом столе

function ManagerArrangement:new()
    -- Позиции для карт в руке
    self.handPositions = {
        id = {},
        x = {},
        y = {},
        isFree = {}  -- true если позиция свободна
    }

    -- Позиции для сброшенных карт
    self.discardPositions = {
        id = {},
        x = {},
        y = {},
        isFree = {}
    }

    -- позиции для выложеных карт
    self.gameFieldPositions = {
        id = {},
        x = {},
        y = {},
        isFree = {}
    }

    -- Размеры и позиции зон
    local handZoneY = VIRTUAL_HEIGHT - DEFAULT_SIZE_KNUCKLES[2] - 10
    local ofsetXY = 10
    
    self.zones = {
        [ZONES.HAND] = {
            x = DEFAULT_SIZE_KNUCKLES[1] + 40,
            y = handZoneY,
            width = DEFAULT_SIZE_KNUCKLES[1] * 6 + 5*10,
            height = DEFAULT_SIZE_KNUCKLES[2] 
        },
        [ZONES.DISCARD] = {
            x = ofsetXY,
            y = handZoneY - DEFAULT_SIZE_KNUCKLES[2] - 10,
            width = DEFAULT_SIZE_KNUCKLES[1] + 15,-- чтобы было видно из под карт
            height = DEFAULT_SIZE_KNUCKLES[2]
        },
        [ZONES.DECK] = {
            x = ofsetXY,
            y = VIRTUAL_HEIGHT- DEFAULT_SIZE_KNUCKLES[2] - 10,
            width = DEFAULT_SIZE_KNUCKLES[1] + 15, -- чтобы было видно из под карт
            height = DEFAULT_SIZE_KNUCKLES[2]
        },
        [ZONES.GAME_BUTTONS] = {
            x = VIRTUAL_WIDTH - DEFAULT_SIZE_KNUCKLES[1] - 10,
            y = VIRTUAL_HEIGHT- DEFAULT_SIZE_KNUCKLES[2] - 10,
            width = DEFAULT_SIZE_KNUCKLES[1] , -- чтобы было видно из под карт
            height = DEFAULT_SIZE_KNUCKLES[2]
        },
        [ZONES.GAME_FIELD] = {  
            x = DEFAULT_SIZE_KNUCKLES[1] + 30 + ofsetXY,
            y = DEFAULT_SIZE_KNUCKLES[2] + 20,
            width = DEFAULT_SIZE_KNUCKLES[1] * 6 + 5*10,
            height = VIRTUAL_HEIGHT - DEFAULT_SIZE_KNUCKLES[2] * 2 - 20 - 20
        },
        [ZONES.GAME_TABLO] = {  
            x = ofsetXY,
            y = ofsetXY,
            width = VIRTUAL_WIDTH - 20 ,
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
        self.handPositions.id[i] = i
        self.handPositions.x[i] = startX + (i-1) * (cardWidth + spacing)
        self.handPositions.y[i] = y
        self.handPositions.isFree[i] = true
    end

    -- Инициализация позиций для сброшенных карт
    local discardX = self.zones[ZONES.DISCARD].x
    local discardY = self.zones[ZONES.DISCARD].y

    for i = 1, handSize do  -- Максимум 10 карт в зоне сброса
        self.discardPositions.x[i] = discardX + (i-1) * 5  -- Небольшое смещение для эффекта стопки
        self.discardPositions.y[i] = discardY
        self.discardPositions.isFree[i] = true
    end

    local gameFieldDx = DEFAULT_SIZE_KNUCKLES[2]
    local gameFieldY = self.zones[ZONES.GAME_FIELD].y + self.zones[ZONES.GAME_FIELD].height / 2 + DEFAULT_SIZE_KNUCKLES[1]/2  
    for i = 0, QAUNTITY_ITEMS_GAME_FIELD - 1 do
   
    self.gameFieldPositions.x[i + 1] =  self.zones[ZONES.GAME_FIELD].x + i * (gameFieldDx + 10)
    self.gameFieldPositions.y[i + 1] =  gameFieldY
    self.gameFieldPositions.isFree =    true      
    end 
end

-- Проверка, находится ли точка в зоне
function ManagerArrangement:isInZone(x, y, zone)
    local z = self.zones[zone]
    return x >= z.x and x <= z.x + z.width and
           y >= z.y and y <= z.y + z.height
end

-- Получить свободные позиции в руке 
function ManagerArrangement:getFreeHandPositions()
    local freePosition = {}
    for i = 1, #self.handPositions.id do
        if self.handPositions.isFree[i] then
            local position = {
                id = self.handPositions.id[i],
                x = self.handPositions.x[i],
                y = self.handPositions.y[i],
            }
            -- ЗДЕСЬ МЫ СРАЗУ СТАВИМ ЧТО ПОЗИЦИЯ ОТДАНА
            self.handPositions.isFree[i] = false
            table.insert(freePosition, position)
        end
    end
    return freePosition
end

function ManagerArrangement:clearHandPositions(knuckles)
    for i = 1, #knuckles do
       for j = 1, #self.handPositions.id do
       if (knuckles[i].toPosition.id == self.handPositions.id[j]) then
            self.handPositions.isFree[j] = true
       end
    end
    end
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

--[[ -- Занять позицию в руке
function ManagerArrangement:occupyHandPosition(index)
    if index and self.handPositions.isFree[index] then
        self.handPositions.isFree[index] = false
        return true
    end
    return false
end
 ]]
-- Освободить позицию в руке
--[[ function ManagerArrangement:freeHandPosition(index)
    if index and not self.handPositions.isFree[index] then
        self.handPositions.isFree[index] = true
        return true
    end
    return false
end
 ]]
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

    love.graphics.rectangle("fill",
        self.zones[ZONES.GAME_BUTTONS].x,
        self.zones[ZONES.GAME_BUTTONS].y,
        self.zones[ZONES.GAME_BUTTONS].width,
        self.zones[ZONES.GAME_BUTTONS].height
    )

    love.graphics.rectangle("fill",
        self.zones[ZONES.GAME_FIELD].x,
        self.zones[ZONES.GAME_FIELD].y,
        self.zones[ZONES.GAME_FIELD].width,
        self.zones[ZONES.GAME_FIELD].height
    )

    love.graphics.rectangle("fill",
        self.zones[ZONES.GAME_TABLO].x,
        self.zones[ZONES.GAME_TABLO].y,
        self.zones[ZONES.GAME_TABLO].width,
        self.zones[ZONES.GAME_TABLO].height
    )

    for i = 1, #self.gameFieldPositions.x do
    love.graphics.circle("fill", self.gameFieldPositions.x[i], self.gameFieldPositions.y[i], 4)
    end
    -- Восстанавливаем исходный цвет
    love.graphics.setColor(r, g, b, a)
end



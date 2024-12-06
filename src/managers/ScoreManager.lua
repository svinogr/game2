require "src.objects.TabloScore"
require "src.states.CombinationStates"
ScoreManager = Object:extend()

function ScoreManager:new()
    self.tabloScore = {}
    self.complete = false
end

function ScoreManager:initialize(score, arrangement)
    --комбинации
    self.stateCombination = Combinations()
    self.combinations = {}
    self.arrangement = arrangement

    self.tabloScore = TabloScore(score)
    self.tabloScore.x = self.arrangement.zones[ZONES.GAME_TABLO].x
    self.tabloScore.y = self.arrangement.zones[ZONES.GAME_TABLO].y
    self.tabloScore.width = self.arrangement.zones[ZONES.GAME_TABLO].width / 4
    self.tabloScore.height = self.arrangement.zones[ZONES.GAME_TABLO].height
end

function ScoreManager:update(dt, selectedKnucles, gameState)
    if gameState == GameStates.PLAYER_THINK then
        if #selectedKnucles < 3 then
            self.combinations = {}
            return
        end

        self:checkVariantCombinations(selectedKnucles)
    end

    if gameState == GameStates.PLAYER_TURN then

    end
    -- заглушка
    self.complete = true
end

function ScoreManager:render()
    self.tabloScore:draw()
    if #self.combinations > 2 then
        self:drawVariantCombinations()
    end
end

function ScoreManager:checkVariantCombinations(knuckles)
    self.combinations = {}

    self.combinations = self.stateCombination:check(knuckles)
end

function ScoreManager:drawVariantCombinations()
    if #self.combinations > 2 then
        local x = VIRTUAL_WIDTH / 2 - 150
        local y = VIRTUAL_HEIGHT / 2 - 15

        love.graphics.rectangle("line", x, y, 300, 30)
        local str = "Комбинации: "
        for i, combination in ipairs(self.combinations) do
            str = str..tostring(combination[1].v1)
            
        end
        love.graphics.print(str, x + 10, y)
    end
end

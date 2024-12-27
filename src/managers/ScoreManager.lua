require "src.objects.TabloScore"
require "src.states.CombinationStates"
ScoreManager = Object:extend()

function ScoreManager:new()
    self.tabloScore = {}
    self.isComplete = false
    self.scoringKnucles = {}
end

function ScoreManager:initialize(score, arrangement)
    --комбинации
    self.stateCombination = CombinationsStates()
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

        self.combinations = {}
        self:checkVariantCombinations(selectedKnucles)
    end

    if gameState == GameStates.SCORING then
        self:scoring(selectedKnucles[1])
        selectedKnucles[1].isSelect = true
        -- снова ставим их выбраными чтобы мувинг менеджер убрал их
        --[[   for i = 1, #selectedKnucles do
            selectedKnucles[i].isSelect = true
        end ]]

       -- self.complete = true
    end

    if gameState == GameStates.DISCARD then
        self.combinations = {}
    end

    -- заглушка
    -- self.complete = true
end

function ScoreManager:scoring(knuckle)
    self.tabloScore.score = self.tabloScore.score + knuckle.v1 * knuckle.v2
    knuckle.isScored = true
end

function ScoreManager:render()
    -- отрисовака окна очков

    self.tabloScore:draw()

    -- отрисовка возможных комбинаций
    if #self.combinations > 0 then
        self:drawVariantCombinations()
    end
    --  self.combinations = {}
end

function ScoreManager:checkVariantCombinations(knuckles)
    if #knuckles ~= 3 then
        self.combinations = {}
        return
    end

    self.combinations = self.stateCombination:check(knuckles)
end

function ScoreManager:drawVariantCombinations()
    local x = VIRTUAL_WIDTH / 2 - 150
    local y = VIRTUAL_HEIGHT / 2 - 15

    love.graphics.rectangle("line", x, y, 300, 30) -- заменить на arrangement

    for i, combination in ipairs(self.combinations) do
        love.graphics.print(combination.visualName(), 300 + i * 60, 30)
    end
end

function ScoreManager:removeScoringKnucles(knuckle)
    for i = 1, #self.scoringKnucles do
        if self.scoringKnucles[i].id == knuckle.id then
            table.remove(self.scoringKnucles, i)
       -- self.scoringKnucles[i] = nil
            if #self.scoringKnucles == 0 then
                self.isComplete = true
                knuckle.isSelect = true
            end

            return
        end
    end
end

function ScoreManager:addToscoringKnucles(knuckles)
 for index, value in ipairs(knuckles) do
    table.insert(self.scoringKnucles, value)
 end

    
end
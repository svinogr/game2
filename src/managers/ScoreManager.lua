require "src.objects.TabloScore"
ScoreManager = Object:extend()

function ScoreManager:new()
    self.tabloScore = {}
    self.complete = false
end

function ScoreManager:initialize(score, arrangement)
    self.arrangement = arrangement
    self.tabloScore = TabloScore(score)
    self.tabloScore.x = self.arrangement.zones[ZONES.GAME_TABLO].x
    self.tabloScore.y = self.arrangement.zones[ZONES.GAME_TABLO].y   
    self.tabloScore.width = self.arrangement.zones[ZONES.GAME_TABLO].width /4
    self.tabloScore.height = self.arrangement.zones[ZONES.GAME_TABLO].height
end


function ScoreManager:update()

    -- заглушка
    self.complete = true
    
end

function ScoreManager:render()
    self.tabloScore:draw()
end
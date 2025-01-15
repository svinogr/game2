--[[
    GameOverScreenState Class
    
]]
require "src.states.BaseState"

GameOverScreenState = BaseState:extend()

function GameOverScreenState:new()
    -- nothing
end

function GameOverScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('title')
    end
end

function GameOverScreenState:render()
   
    love.graphics.setColor(107/255,25/255,27/255)
    love.graphics.printf('GAME OVER', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')
end
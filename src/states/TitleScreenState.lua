--[[
    TitleScreenState Class
    
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The TitleScreenState is the starting screen of the game, shown on startup. It should
    display "Press Enter" and also our highest score.
]]
require "src.states.BaseState"

TitleScreenState = BaseState:extend()

function TitleScreenState:new()
    -- nothing
end

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function TitleScreenState:render()
   
    love.graphics.setColor(107/255,25/255,27/255)
    love.graphics.printf('Doomino', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')
end
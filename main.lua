if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end
Object = require "src.lib.classic"
push = require "src.lib.push"
require "src.states.StateMachine"
require "src.states.BaseState"
--require 'states/CountdownState'
require "src.states.PlayState"
--require 'states/ScoreState'
require "src.states.TitleScreenState"
-- real resolution
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

-- virtual resolution dimensions
VIRTUAL_WIDTH = 600
VIRTUAL_HEIGHT = 451
DEFAULT_SIZE_KNUCKLES = {VIRTUAL_WIDTH/10, VIRTUAL_HEIGHT/4}
DEFAULT_START_POSITION_KNUCKLES = {VIRTUAL_WIDTH - (VIRTUAL_WIDTH -10), VIRTUAL_HEIGHT - 10 - DEFAULT_SIZE_KNUCKLES[2]}



function love.load()
        -- initialize our nearest-neighbor filter
        love.graphics.setDefaultFilter('nearest', 'nearest')
        math.randomseed(os.time())
    
        -- app window title
        love.window.setTitle('Doomino')
    
        -- initialize our virtual resolution
        push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
            vsync = true,
            fullscreen = false,
            resizable = true
        })
        -- initialize state machine with all state-returning functions
        gStateMachine = StateMachine {
            ["title"] = function() return TitleScreenState() end,
          --  ['countdown'] = function() return CountdownState() end,
           ["play"] = function() return PlayState() end
          --  ['score'] = function() return ScoreState() end
        }
        
        --gStateMachine:change('title') начало
        gStateMachine:change("play") 
    
        -- initialize input table
        love.keyboard.keysPressed = {}
end

function love.update(dt)

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keyboard.wasPressed(key)
	if (love.keyboard.keysPressed[key]) then
		return true
	else
		return false
	end
end

function love.keypressed(key, scancode, isrepeat)
    love.keyboard.keysPressed[key] = true
    
end



function love.draw()
    push:start()

    gStateMachine:render()
     
    push:finish()
end

function love.mousepressed(x, y, button)

end

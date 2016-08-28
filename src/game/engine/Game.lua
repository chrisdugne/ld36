
local physics = require( 'physics' )

local MIN = - display.contentHeight * 0.5 + 80
local MAX = display.contentHeight * 0.5 - 30

-- local line1 = display.newLine(-100, MIN, 100, MIN)
-- Camera:insert(line1)
-- local line2 = display.newLine(-100, MAX, 100, MAX)
-- Camera:insert(line2)

--------------------------------------------------------------------------------

Game = {
    RUNNING = 1,
    STOPPED = 2
}

--------------------------------------------------------------------------------

function Game:new()
    local game = {
        state  = Game.STOPPED,
        -- you may add any content to deal with your Game status
        -- stuff = {}
        -- other = 'plop'
    }

    setmetatable(game, { __index = Game })
    return game
end

--------------------------------------------------------------------------------

function Game:start()
    self:reset()

    physics.start()
    physics.setGravity( 0,0 )

    Camera:resetZoom()
    Camera:center()
    Camera:start()

    Score:createBar()
    Background:darken()

    self:displayTitle()
    self:render()

    Sound:start()

    self.state = Game.RUNNING
end

------------------------------------------

function Game:reset()
    Camera:empty()
    HUD:reset()
    self:resetContent()
    App.user:resetLevel()

    Score:reset()
end

function Game:resetContent()
    -- here you can reset your content
    -- utils.emptyTable(self.stuff)
    self.title = 'LD36'
end

------------------------------------------

function Game:stop(userExit)

    if(self.state == Game.STOPPED) then return end
    self.state = Game.STOPPED

    ------------------------------------------
    -- calculate score

    if(not userExit) then
        Score:calculate (self.chapter, self.level)
    end

    ------------------------------------------

    HUD:reset()
    Screen:showBands()
    Background:lighten()
    Score:display()

    ------------------------------------------

    Sound:stop()
    Effects:stop(true)
    Camera:stop()
    self.layer1:stop()
end

--------------------------------------------------------------------------------

function Game:displayTitle()
    local introText = display.newText(
        App.hud,
        self.title,
        0, 0,
        FONT, 45
    )

    introText:setFillColor( 255 )
    introText.anchorX = 0
    introText.x       = display.contentWidth * 0.1
    introText.y       = display.contentHeight * 0.18
    introText.alpha   = 0

    transition.to( introText, {
        time       = 2600,
        alpha      = 1,
        x          = display.contentWidth * 0.13,
        onComplete = function()
            transition.to( introText, {
                time  = 3200,
                alpha = 0,
                x     = display.contentWidth * 0.16
            })
        end
    })
end

--------------------------------------------------------------------------------

function Game:waitForNextBird()
    local level = self:currentLevel()
    local nextTick = Sound.TIMER / level.spawn
    timer.performWithDelay( nextTick , function()
        if(self.state == Game.RUNNING) then
            self:spawnBird()
        end
    end)
end

function Game:spawnBird()
    local bird = Bird:new({
        parent = Camera,
        x = display.contentWidth * 0.5 - 20,
        y = math.random(MIN, MAX),
        speed = 5 * self:currentLevel().speed,
        type = math.random(1, BAD_BIRD)
    })

    bird:show()
    self:waitForNextBird()
end

--------------------------------------------------------------------------------

function Game:currentLevel()
    return GLOBALS.levels[App.user.level]
end

function Game:render(next)
    local cerise = Cerise:new()
    cerise:show()

    self:spawnBird()

    Effects:restart()
end

--------------------------------------------------------------------------------
--  API
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

return Game

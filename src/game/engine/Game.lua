
local physics = require( 'physics' )
-- physics.setDrawMode( 'hybrid' )

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
    self.state = Game.RUNNING
end

------------------------------------------

function Game:reset()
    Camera:empty()
    HUD:reset()
    self:resetContent()

    Score:reset()
end

function Game:resetContent()
    -- here you can reset your content
    -- utils.emptyTable(self.stuff)
    self.title = 'New Game'
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

function Game:render(next)
    self:renderLevel(function()
        Effects:restart()
        if(next) then
            next()
        end
    end)
end

--------------------------------------------------------------------------------

function Game:renderLevel(next)
    local cerise = Cerise:new()
    cerise:show()

    self.layer1 = Layer1:new()
    self.layer1:start()

    local bird = Bird:new({
        parent = self.layer1.display
    })

    bird:show()

    next()
end

--------------------------------------------------------------------------------
--  API
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

return Game

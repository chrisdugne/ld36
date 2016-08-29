
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
    self.state = Game.RUNNING

    physics.start()
    physics.setGravity( 0,0 )

    Camera:resetZoom()
    Camera:center()
    Camera:start()

    App.score:createBar()
    Background:darken()

    self:displayTitle()
    self:render()

    Sound:start()
end

------------------------------------------

function Game:reset()
    Camera:empty()
    HUD:reset()
    self:resetContent()
    App.user:resetLevel()
    -- App.user.level = 8

    App.score:reset()
end

function Game:resetContent()
    -- here you can reset your content
    -- utils.emptyTable(self.stuff)
    self.title = 'LD36'
    self.futurBirds = {};
    self.birds = {};
end

------------------------------------------

function Game:stop(userExit)

    if(self.state == Game.STOPPED) then return end
    self.state = Game.STOPPED

    ------------------------------------------
    -- calculate score

    if(not userExit) then
        App.score:calculate (self.chapter, self.level)
    end

    ------------------------------------------

    HUD:reset()
    Screen:showBands()
    Background:lighten()
    App.score:display()

    ------------------------------------------

    Sound:stop()
    Effects:stop(true)
    Camera:stop()

    self:destoyBirds()
end

--------------------------------------------------------------------------------

function Game:destoyBirds()
    timer.cancel(self.waveChecker)

    for i=1,#self.futurBirds do
        timer.cancel(self.futurBirds[i])
    end

    for i=#self.birds, 1, -1 do
        self.birds[i]:explode()
    end
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

function Game:resetWave()
    App.score:resetStraight()
    App.score:loseLife()
    Camera:shake()

    Sound:rewind(App.user.level, function()
        self:startWave()
    end)

    self:destoyBirds()
end

function Game:startWave()
    print('startWave')
    if(self.state == Game.STOPPED) then
        print('wave cancelled')
        return
    end

    local level = self:currentLevel()
    local levelTick = Sound.TIMER / level.perTick
    local nb = level.spawn

    self.futurBirds = {};
    self.birds = {};

    self.waveChecker = timer.performWithDelay(Sound.TIMER, function ()
        if(App.score.current.straight == nb) then
            App.user:growLevel()
            App.score:refreshLevel()
            App.score:resetStraight()
            self:startWave()
        else
            self:resetWave()
        end
    end)

    for i=1,nb do
        self.futurBirds[i] = timer.performWithDelay(levelTick * (i-1), function ()
            if(self.state == Game.RUNNING) then
                self:spawnBird(GOOD_BIRD)
                local notLast = i < level.spawn
                if(notLast) then
                    self:tryToSpawnBad()
                end
            end
        end)
    end

    Sound:startWave()
end

function Game:tryToSpawnBad()
    local level = self:currentLevel()
    local levelTick = Sound.TIMER / level.perTick
     if(math.random(3,5) == BAD_BIRD) then
        timer.performWithDelay(levelTick * 0.5, function ()
            self:spawnBird(BAD_BIRD)
        end)
    end
end

function Game:spawnBird(type)
    local bird = Bird:new({
        parent = Camera,
        x = display.contentWidth * 0.5 - 20,
        y = math.random(MIN, MAX),
        speed = 12 * self:currentLevel().speed,
        type = type
    })

    bird:show()
    self.birds[#self.birds+1] = bird
end

--------------------------------------------------------------------------------

function Game:currentLevel()
    return GLOBALS.levels[App.user.level]
end

function Game:render(next)
    utils.emptyGroup(self.bg)
    self.bg = display.newGroup()
    self.bg.mist1 = display.newImageRect( self.bg, "assets/images/game/bg/bg1.png", display.contentWidth, display.contentHeight)
    self.bg.mist1.x = 0
    self.bg.mist1.y = 0
    self.bg.mist1.alpha = 0.7

    self.bg.mist2 = display.newImageRect( self.bg, "assets/images/game/bg/bg1.png", display.contentWidth, display.contentHeight)
    self.bg.mist2.x = display.contentWidth
    self.bg.mist2.y = 0
    self.bg.mist2.alpha = 0.7

    self:moveMists()
    Camera:insert(self.bg)

    local cerise = Cerise:new()
    cerise:show()

    self:startWave()
    Effects:restart()
end

function Game:moveMists()
    if(self.bg.mist1) then
        transition.cancel(self.bg.mist1)
        transition.cancel(self.bg.mist2)
    end

    transition.to( self.bg.mist2, { time=60000, x=0, onComplete= function ()
        self:replaceMists()
    end})
    transition.to( self.bg.mist1, { time=60000, x=-display.contentWidth })
end

function Game:replaceMists()
    self.bg.mist1.x = 0
    self.bg.mist2.x = display.contentWidth
    self:moveMists()
end


--------------------------------------------------------------------------------
--  API
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

return Game

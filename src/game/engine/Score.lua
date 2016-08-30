--------------------------------------------------------------------------------

Score = {}

--------------------------------------------------------------------------------

function Score:new()
    local object = {}
    setmetatable(object, { __index = Score })
    return object
end

--------------------------------------------------------------------------------
--- METRICS
--------------------------------------------------------------------------------

function Score:reset()
    self.current = {
        straight = 0,
        lives = 5,
        points = 0
    }

    self.enhancement = nil
    self.latest      = nil
end

function Score:worst()
    return {
        points = 0
    }
end

function Score:enhance(previousScore)
    self.merge = {
        points = math.max(self.current.points, previousScore.points)
    }

    self.enhancement = {
        points = self.current.points > previousScore.points
    }

    return self.merge
end

--------------------------------------------------------------------------------
--- MINI BAR
--------------------------------------------------------------------------------

function Score:createBar()
    if(self.bar) then
        display.remove(self.bar)
    end

    self.barHeight = display.contentHeight*0.07

    self.bar   = display.newGroup()
    self.bar.x = display.contentWidth*0.5
    self.bar.y = -self.barHeight*0.5
    self.bar.anchorX = 0

    App.hud:insert(self.bar)

    self.barBG = display.newRect(
        self.bar,
        0, 0,
        display.contentWidth,
        self.barHeight
    )

    self.barBG.alpha = 0
    self.barBG:setFillColor(0)

    self:createProgressBar()
    self:refreshLevel()
    self:refreshPoints()
    self:refreshLives()
    self:resetStraight()
    self:showBar()
end

--------------------------------------------------------------------------------

function Score:displayButtons()
    local back = Button:icon({
        parent = self.bar,
        type   = 'close',
        x      = display.contentWidth*0.5 - 50,
        y      = 0,
        scale  = 0.7,
        action = function ()
            App.game:stop(true)
            Router:open(Router.HOME)
        end
    })
end

--------------------------------------------------------------------------------

function Score:increment(bird)
    if(bird.type ~= BAD_BIRD) then
        self.current.straight = self.current.straight + 1
        self:refreshStraight(bird)
        self.current.points = self.current.points + App.user.level
        self:refreshPoints()
        Sound:playBip()

        local level = App.game:currentLevel()
        local reached = level and self.current.straight == level.spawn

        if(reached) then
            Sound:nextStep()
            App.game:displayTitle(level.congrats)
        end
    else
        App.game:resetWave()
    end
end

--------------------------------------------------------------------------------
-- PROGRESS BAR
--------------------------------------------------------------------------------

function Score:refreshProgressBar(percentage)
    self.lifeBar:reach({
        value = percentage,
        text = ''
    })
end

function Score:createProgressBar()
    self.lifeBar = ProgressBar:new()
    self.lifeBar:draw({
        parent = self.bar,
        x = display.contentWidth*0.5 - 300,
        y = 50,
        width = 400,
        height = 25
    })

    self:refreshProgressBar( 0)
end

--------------------------------------------------------------------------------
-- LEVEL
--------------------------------------------------------------------------------

function Score:refreshLevel()
     if(self.level) then
        display.remove(self.level)
    end

    self.level = utils.text({
        parent   = self.bar,
        value    = 'Level ' .. App.user.level,
        x        = display.contentWidth*0.5 - 395,
        y        = 0,
        font     = FONT,
        fontSize = 55
    })

    utils.grow(self.level)
    if(App.user.level > 1) then
        self:refreshProgressBar( App.user.level / #GLOBALS.levels * 100)
    else
        self:refreshProgressBar( 0)
    end

    utils.grow(self.lifeBar)

    self.level.anchorX = 0
end

--------------------------------------------------------------------------------
-- POINTS
--------------------------------------------------------------------------------

function Score:refreshPoints()
    if(self.count) then
        display.remove(self.count)
    end

    self.count = utils.text({
        parent   = self.bar,
        value    = self.current.points,
        x        = 30 - display.contentWidth * 0.5,
        y        = 0,
        font     = FONT,
        fontSize = 55
    })

    utils.grow(self.count)

    self.count.anchorX = 0
end

--------------------------------------------------------------------------------
-- STRAIGHT
--------------------------------------------------------------------------------

function Score:birdPosition(i)
    local marginLeft = display.contentWidth * 0.085
    local gap = display.contentWidth * 0.03
    return i * gap + marginLeft
end

function Score:refreshStraight(bird)
    local num = 1
    if(bird.type == BAD_BIRD) then
        num = 2
    end

    local itemX = self:birdPosition(self.current.straight) - display.contentWidth * 0.5
    local birdItem = display.newImage(
        self.straight,
        'assets/images/game/item/gem.' .. num .. '.png',
        itemX, 0
    );

    utils.grow(birdItem)
end

function Score:resetStraight()
    self.current.straight = 0
    local level = GLOBALS.levels[App.user.level]
    local reach = level.reach

    if(self.straight) then
        utils.destroyFromDisplay(self.straight)
    end

    self.straight = display.newGroup()
    self.bar:insert(self.straight)

    for i = 1, level.spawn do
        local bird = display.newImage(
            self.straight,
            'assets/images/game/item/gem.1.png',
            self:birdPosition(i) - display.contentWidth * 0.5, 0
        );

        bird.fill.effect = 'filter.desaturate'
        bird.fill.effect.intensity = 1
    end

    utils.grow(self.straight)
end

--------------------------------------------------------------------------------
-- LIVES
--------------------------------------------------------------------------------

function Score:loseLife()
    self.current.lives = self.current.lives - 1
    self:refreshLives()
    if(self.current.lives == 0) then
        App.game:stop()
    end
end

function Score:lifePosition(i)
    local marginLeft = display.contentWidth * 0.65
    local gap = display.contentWidth * 0.03
    return i * gap + marginLeft
end

function Score:refreshLives()
    if(self.lives) then
        utils.destroyFromDisplay(self.lives)
    end

    self.lives = display.newGroup()
    self.bar:insert(self.lives)

    for i = 1, self.current.lives do
        local life = display.newImage(
            self.lives,
            'assets/images/gui/items/heart.png',
            self:lifePosition(i) - display.contentWidth * 0.5, 90
        );
    end

    utils.grow(self.lives)
end

--------------------------------------------------------------------------------

function Score:showBar()
    transition.to( self.bar, {
        time  = 800,
        y     = self.barHeight*0.5
    })

    transition.to( self.barBG, {
        time  = 800,
        alpha = 0.6
    })
end

function Score:hideBar()
    transition.to( self.bar, {
        time  = 800,
        alpha = 0
    })
end

--------------------------------------------------------------------------------

function Score:calculate(chapter, level)
end

--------------------------------------------------------------------------------
--- RESULT BOARD
--------------------------------------------------------------------------------

function Score:display()
    self:hideBar()

    local board = display.newGroup()
    board.x = display.contentWidth  * 0.5
    board.y = display.contentHeight * 0.5
    App.hud:insert(board)

    local bg = Panel:vertical({
        parent = board,
        width  = display.contentWidth * 0.4,
        height = display.contentHeight * 0.35,
        x      = 0,
        y      = 0
    })

    local title = self.current.points .. ' pts'

    Banner:large({
        parent   = board,
        text     = title,
        fontSize = 44,
        width    = display.contentWidth*0.25,
        height   = display.contentHeight*0.13,
        x        = 0,
        y        = -bg.height*0.49
    })

    local thanks = 'Thanks for Playing ! \n This is our game for Ludum Dare 36, \nIdea, coding and direction by Chris @ Uralys, \nMusic and sounds by Leo @ VelvetCoffee\n Drawings by Cerise, 5 years old   <3 \n\n let us know if you want more levels : )'

    utils.text({
        parent   = board,
        value    = thanks,
        x        = 0,
        y        = 0,
        font     = FONT,
        fontSize = 20
    })

    timer.performWithDelay(800, function ()
        self:addBoardButtons(board)
    end)

    utils.easeDisplay(board)
end

--------------------------------------------------------------------------------

function Score:addBoardButtons(board)
    Button:icon({
        parent = board,
        type   = 'restart',
        x      = 0,
        y      = board.height * 0.45,
        bounce = true,
        action = function()
            App.game:stop(true)
            ---- analytics
            analytics.event('score-screen', 'restart')
            --------------
            Router:open(Router.PLAYGROUND)
        end
    })
end

--------------------------------------------------------------------------------

return Score

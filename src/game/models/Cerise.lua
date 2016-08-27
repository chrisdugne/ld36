--------------------------------------------------------------------------------

local Cerise = {}

--------------------------------------------------------------------------------

function Cerise:new(options)
    local cerise = _.extend({
        rotation = 0,
        parent = Camera
    }, options);

    setmetatable(cerise, { __index = Cerise })
    return cerise;
end

--------------------------------------------------------------------------------

function Cerise:onCollision(event)
    if(event.phase == 'began') then
        local bird = event.other
        local caught = bird:catch()
        if(caught) then
            Score:increment(bird)
        end
    end
end

--------------------------------------------------------------------------------

function Cerise:show()
    self.body = _.extend(display.newImage(
        'assets/images/game/cerise.png'
    ), self)

    self.parent:insert(self.body)

    self.body.x = 190 - display.contentWidth * 0.5
    self.body.y = self.y
    self.body.rotation = self.rotation

    --------------------

    self.focus = Focus(self.body, {
        all    = false,
        up     = true,
        bottom = true,
        type   = 'from-center'
    })

    --------------------

    local onDrag = function(event)
        self:drag(event)
    end

    self.body:addEventListener( 'touch', onDrag)

    --------------------

    physics.addBody( self.body, {
        density = 1000,
        radius = 80,
        filter = { categoryBits=2, maskBits=1 }
    })

    self.body.collision = function(body, event) self:onCollision(event) end
    self.body:addEventListener( 'collision' )
end

--------------------------------------------------------------------------------

function Cerise:drag( event )
    if event.phase == 'began' then
        display.getCurrentStage():setFocus( self.body )
        self.markY = self.body.y    -- store y location of object

    elseif event.phase == 'moved' then
        local BOTTOM = display.contentHeight*0.5 - self.body.height * 0.5 - 20;
        local TOP = - display.contentHeight*0.5 + self.body.height * 0.5 + 60;

        local y = ((event.y - event.yStart) + self.markY)
        if(y > BOTTOM) then
            y = BOTTOM
        elseif(y < TOP) then
            y = TOP
        end

        self.body.y = y

    elseif event.phase == 'ended' or event.phase == 'cancelled' then
        display.getCurrentStage():setFocus( nil )
    end

    return false
end

--------------------------------------------------------------------------------

return Cerise

--------------------------------------------------------------------------------

local Bird = {}

--------------------------------------------------------------------------------

function Bird:new(options)
    local bird = _.extend({
        caught = false,
        speed = 12
    }, options);

    setmetatable(bird, { __index = Bird })
    return bird;
end

--------------------------------------------------------------------------------

function Bird:show()
    local num = 1
    if(self.type == BAD_BIRD) then
        num = 2
    end

    self.body = _.extend(display.newImage(
        'assets/images/game/birds/bird.'.. num .. '.png'
    ), self)

    self.body.catch = function(event)
        if(not self.caught) then
            self.caught = true;
            self:destroy()
            return true
        end

        return false
    end

    self.parent:insert(self.body)

    self.body.x = self.x
    self.body.y = self.y
    utils.grow(self.body)

    self.move = function (event)
        if(self.body.x == nil) then
            Runtime:removeEventListener( 'enterFrame', self.move )
        else
            if(self.body.x < - display.contentWidth) then
                self:destroy()
            end
            self.body.x = self.body.x - self.speed
        end
    end

    Runtime:addEventListener( 'enterFrame', self.move )

    ------------

    physics.addBody( self.body, {
        density  = 0,
        radius   = self.radius,
        filter = { categoryBits=1, maskBits=2 }
    })
end

--------------------------------------------------------------------------------

function Bird:destroy()
    Runtime:removeEventListener( 'enterFrame', self.move )
    utils.destroyFromDisplay(self.body, true)
end

--------------------------------------------------------------------------------

function Bird:explode()
    self:destroy()
    Effects:explosion(Camera, self.body.x, self.body.y)
end

--------------------------------------------------------------------------------

return Bird


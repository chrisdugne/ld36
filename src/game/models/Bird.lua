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
    self.body = _.extend(display.newImage(
        'assets/images/game/avatars/profile.1.png'
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

return Bird

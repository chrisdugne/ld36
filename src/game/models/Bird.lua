--------------------------------------------------------------------------------

local Bird = {}

--------------------------------------------------------------------------------

function Bird:new(options)
    local bird = _.extend({
        speed = 21
    }, options);

    setmetatable(bird, { __index = Bird })
    return bird;
end

--------------------------------------------------------------------------------

function Bird:onCollision(event)
    local other = event.other
    self:caught()
end

--------------------------------------------------------------------------------

function Bird:show()
    self.display = display.newImage(
        'assets/images/game/avatars/profile.1.png'
    )

    self.parent:insert(self.display)

    self.display.x = self.x
    self.display.y = self.y

    self.move = function (event)
        if(self.display.x == nil) then
            Runtime:removeEventListener( 'enterFrame', self.move )
        else
            if(self.display.x < - display.contentWidth) then
                self:destroy()
            end
            self.display.x = self.display.x - self.speed
        end
    end

    Runtime:addEventListener( 'enterFrame', self.move )

    ------------

    physics.addBody( self.display, {
        density  = 0,
        bounce   = 131,
        radius   = self.radius,
        filter = { categoryBits=1, maskBits=2 }
    })

    self.display.collision = function(display, event) self:onCollision(event) end
    self.display:addEventListener( 'collision' )
end

--------------------------------------------------------------------------------

function Bird:destroy()
    Runtime:removeEventListener( 'enterFrame', self.move )
    utils.destroyFromDisplay(self.display, true)
end

function Bird:caught(event)
    self:destroy()
end

--------------------------------------------------------------------------------

return Bird

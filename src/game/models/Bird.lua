--------------------------------------------------------------------------------

local Bird = {}

--------------------------------------------------------------------------------

function Bird:new(options)
    local bird = _.extend({
        speed = 10
    }, options);

    setmetatable(bird, { __index = Bird })
    return bird;
end

--------------------------------------------------------------------------------

function Bird:show()
    self.display = display.newImage(
        'assets/images/game/avatars/profile.1.png'
    )

    self.display:scale(0.3, 0.3)
    self.parent:insert(self.display)

    self.display.x = self.x
    self.display.y = self.y

    local function move(event)
        self.display.x = self.display.x - self.speed

        if(self.display.x < - display.contentWidth) then
            Runtime:removeEventListener( 'enterFrame', move )
            utils.destroyFromDisplay(self.display)
        end
    end

    Runtime:addEventListener( 'enterFrame', move )
end

--------------------------------------------------------------------------------

return Bird

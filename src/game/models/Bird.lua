--------------------------------------------------------------------------------

local Bird = {}

--------------------------------------------------------------------------------

function Bird:new(options)
    local bird = _.extend({
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
end

--------------------------------------------------------------------------------

return Bird

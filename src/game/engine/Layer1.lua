--------------------------------------------------------------------------------

local Layer1 = {}

--------------------------------------------------------------------------------

function Layer1:new(options)
    local layer = _.extend({
        display = display.newGroup(),
        speed = 10
    }, options);

    setmetatable(layer, { __index = Layer1 })
    return layer;
end

--------------------------------------------------------------------------------

function Layer1:insert(stuff)
    self.display:insert(stuff)
end

--------------------------------------------------------------------------------

function Layer1:empty()
    utils.emptyGroup(self.display)
end

--------------------------------------------------------------------------------

function Layer1:start()
    Camera:insert(self.display)

    local function move(event)
        self.display.x = self.display.x - self.speed
    end

    Runtime:addEventListener( 'enterFrame', move )

    function Layer1:stop()
        Runtime:removeEventListener( 'enterFrame', move )
        self:empty()
    end
end

--------------------------------------------------------------------------------

return Layer1

--------------------------------------------------------------------------------

local Camera = {
    options = {},
    display = display.newGroup(),
    zoom    = 1
}

local INIT_X = display.contentWidth*0.5
local INIT_Y = display.contentHeight*0.5

--------------------------------------------------------------------------------

function Camera:insert(stuff)
    self.display:insert(stuff)
end

--------------------------------------------------------------------------------

function Camera:empty()
    utils.emptyGroup(self.display)
end

--------------------------------------------------------------------------------

function Camera:resetZoom()
    self.zoom = 1
end

--------------------------------------------------------------------------------

-- INIT_X,Y should be defined by the current level offset from level[0,0]
-- default for Doors : not offset = the center of the screen = level[0,0]
function Camera:center()
    self.display.x = INIT_X
    self.display.y = INIT_Y

    -- reset then apply
    self.display.xScale = 1
    self.display.yScale = 1
    self.display:scale(self.zoom, self.zoom)
end

--------------------------------------------------------------------------------

function Camera:start(options)

    self.options = _.extend(self.options, options)
    transition.cancel(self.display)
    self.display.alpha = 1

    App.hud:toFront()

    function Camera:stop()
        transition.to (self.display, {
            alpha = 0,
            time = 500,
            xScale = 0,
            yScale = 0
        })
    end
end

--------------------------------------------------------------------------------

return Camera

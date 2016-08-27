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
    self.zoom = App:adaptToRatio(0.45)
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

    local listen = function(event)
        self:dragScreen(event)
    end

    App.display:addEventListener( 'touch', listen)
    App.hud:toFront()

    function Camera:stop()
        App.display:removeEventListener( 'touch', listen)

        transition.to (self.display, {
            alpha = 0,
            time = 500,
            xScale = 0,
            yScale = 0
        })
    end
end

--------------------------------------------------------------------------------
---
-- Note to help understand the bounds reaching:
--    camera.display[0,0] is the top left point of the screen
--
function Camera:dragScreen( event )
    if event.phase == 'began' then
        display.getCurrentStage():setFocus( App.display )
        self.markX = self.display.x    -- store x location of object
        self.markY = self.display.y    -- store y location of object

    elseif event.phase == 'moved' then

        local x = ((event.x - event.xStart) + self.markX)
        local y = ((event.y - event.yStart) + self.markY)

        self.display.x = x
        self.display.y = y

    elseif event.phase == 'ended' or event.phase == 'cancelled' then
        display.getCurrentStage():setFocus( nil )
    end

    return false
end

--------------------------------------------------------------------------------

return Camera

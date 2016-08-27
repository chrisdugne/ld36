--------------------------------------------------------------------------------

local Cerise = {}

--------------------------------------------------------------------------------

function Cerise:new(options)
    local cerise = _.extend({
        rotation = 0
    }, options);

    setmetatable(cerise, { __index = Cerise })
    return cerise;
end

--------------------------------------------------------------------------------

function Cerise:show()
    self.display = display.newImage(
        'assets/images/game/avatars/profile.1.png'
    )

    Camera:insert(self.display)

    self.display.x = 140 - display.contentWidth * 0.5
    self.display.y = self.y
    self.display.rotation = self.rotation

    self.focus = Focus(self.display, {
        all    = false,
        up     = true,
        bottom = true,
        type   = 'from-center'
    })

    local onDrag = function(event)
        self:drag(event)
    end

    self.display:addEventListener( 'touch', onDrag)
end

--------------------------------------------------------------------------------

function Cerise:drag( event )
    if event.phase == 'began' then
        display.getCurrentStage():setFocus( self.display )
        self.markY = self.display.y    -- store y location of object

    elseif event.phase == 'moved' then
        local BOTTOM = display.contentHeight*0.5 - self.display.height * 0.5 - 20;
        local TOP = - display.contentHeight*0.5 + self.display.height * 0.5 + 60;

        local y = ((event.y - event.yStart) + self.markY)
        if(y > BOTTOM) then
            y = BOTTOM
        elseif(y < TOP) then
            y = TOP
        end

        self.display.y = y

    elseif event.phase == 'ended' or event.phase == 'cancelled' then
        display.getCurrentStage():setFocus( nil )
    end

    return false
end

--------------------------------------------------------------------------------

return Cerise

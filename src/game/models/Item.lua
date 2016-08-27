--------------------------------------------------------------------------------

local Item = {}

--------------------------------------------------------------------------------

function Item:new(options)
    local item = _.extend({
        type = 1,
        rotation = 0
    }, options);

    setmetatable(item, { __index = Item })
    return item;
end

--------------------------------------------------------------------------------

function Item:show()
    self.display = display.newImage(
        'assets/images/game/avatars/profile.' .. self.type .. '.png'
    )

    Camera:insert(self.display)

    self.display.x = self.x
    self.display.y = self.y
    self.display.rotation = self.rotation

    if(self.focus) then
        self.focus = Focus(self.display, self.focus)
    end
end

--------------------------------------------------------------------------------

return Item

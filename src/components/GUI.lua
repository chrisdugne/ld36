 --------------------------------------------------------------------------------

local GUI = {}

--------------------------------------------------------------------------------

function GUI:iconText(options)
    local icon = display.newGroup()
    icon.x = options.x
    icon.y = options.y
    options.parent:insert(icon)

    local bg = display.newImage(
        icon,
        'assets/images/gui/items/circle.container.on.png',
        0, 0
    )

    local text = utils.text({
        parent   = icon,
        value    = options.value,
        x        = 0,
        y        = 0,
        font     = options.font or FONT,
        fontSize = options.fontSize or 65
    })

    return icon
end

--------------------------------------------------------------------------------

function GUI:banner(options)
    local banner = Banner:large({
        parent   = options.parent,
        text     = options.text,
        fontSize = options.fontSize or 55,
        width    = options.width    or display.contentWidth*0.27,
        height   = options.height   or display.contentHeight*0.17,
        x        = options.x        or display.contentWidth*0.5,
        y        = options.y        or display.contentHeight*0.2
    })

    return banner
end

--------------------------------------------------------------------------------

function GUI:bigIcon(options)
    local icon = display.newGroup()
    icon.x = options.x
    icon.y = options.y
    options.parent:insert(icon)

    local bg = display.newImage(
        icon,
        'assets/images/gui/items/circle.container.on.png',
        0, 0
    )

    local picture = display.newImage(
        icon,
        options.image,
        0, 0
    )

    local scale = options.scale or 0.5
    picture:scale(scale, scale)
    return icon
end


--------------------------------------------------------------------------------

function GUI:multiplier(options)
    local icon = self:bigIcon(_.extend({
        image  = 'assets/images/gui/items/' .. options.item .. '.icon.png',
        parent = options.parent,
        x      = options.x,
        y      = options.y,
        scale  = options.scale or 1
    }, options))

    local multiply = display.newImage(
        options.parent,
        'assets/images/gui/items/multiply.png',
        options.x + icon.width * 0.55,
        options.y
    )

    utils.bounce(multiply)

    local num = utils.text({
        parent   = options.parent,
        value    = options.value,
        x        = options.x + icon.width * 1.1,
        y        = options.y,
        font     = options.font or FONT,
        fontSize = options.fontSize or 75
    })

    utils.bounce(num)
end

--------------------------------------------------------------------------------

return GUI

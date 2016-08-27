--------------------------------------------------------------------------------

local Router = {
    view = nil,

    HOME       = 'Home',
    PLAYGROUND = 'Playground',
    HEADPHONES = 'Headphones',
    SHOP       = 'Shop',
    COLLECTION = 'Collection'
}

--------------------------------------------------------------------------------

function Router:resetScreen()
    Effects:stop(true)
    utils.emptyGroup(App.hud)
    Effects:start()
    if(Screen.reset) then Screen:reset() end
end

--------------------------------------------------------------------------------

function Router:openScreen(id, class, params)
    local options = {
        params = params
    }
    self:resetScreen()
    analytics.pageview(id)

    Router.view = id
    print('Router : openScreen : ' .. Router.view )

    composer.gotoScene( class, options )
end

--------------------------------------------------------------------------------

function Router:open(id, params)
    self:openScreen(id, 'src.screens.' .. id, params)
end

--------------------------------------------------------------------------------

return Router

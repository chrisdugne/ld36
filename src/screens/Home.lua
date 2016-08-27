--------------------------------------------------------------------------------

local scene = composer.newScene()

--------------------------------------------------------------------------------

local initActionX =  display.contentWidth*0.95
local initActionY =  display.contentHeight*0.9

--------------------------------------------------------------------------------

function scene:create( event )
    Background:lighten()
    self:drawActions()

    self.title = GUI:banner({
        parent = self.view,
        text   = App.NAME
    })

    self.playButton       = self:drawPlayButton()
    self.shopButton       = self:drawShopButton()
    self.collectionButton = self:drawCollectionButton()
end

function scene:show( event )
    if ( event.phase == 'did' ) then
        utils.bounce(self.title)
        utils.bounce(self.playButton, 1.6)
        utils.bounce(self.shopButton, 1.6)
        utils.bounce(self.collectionButton, 1.6)
        utils.bounce(self.toggleActionsButton, .7)
    end
end

--------------------------------------------------------------------------------

function scene:drawActions()
    self.actions      = display.newGroup()
    self.actions.x    = initActionX
    self.actions.y    = initActionY
    self.actions.open = false
    self.actions.lock = false
    self.view:insert(self.actions)

    self.toggleActionsButton = Button:icon({
        parent = self.actions,
        type   = 'settings',
        x      = 0,
        y      = 0,
        scale  = .7,
        action = function()
            self:toggleActions()
        end
    })

    self:redrawMusicButton()

    self.infoButton = Button:icon({
        parent = self.actions,
        type   = 'info',
        x      = 110,
        y      = 0,
        scale  = .7,
        action = function()
            Screen:openCredits()
        end
    })
end

--------------------------------------------------------------------------------

function scene:toggleActions()
    if(self.actions.lock) then return end
    self.actions.lock = true

    if(self.actions.open) then
        self:closeActions()
    else
        self:openActions()
    end
end

function scene:openActions()
    transition.cancel(self.actions)
    transition.to(self.actions, {
        x = initActionX - 280,
        time = 850,
        transition = easing.inOutBack,
        onComplete = function()
            self.actions.open = true
            self.actions.lock = false
        end
    })

    self:rotateButton(self.toggleActionsButton)
    self:rotateButton(self.infoButton)
    self:rotateButton(self.musicButton)
end

function scene:closeActions()
    transition.cancel(self.actions)
    transition.to(self.actions, {
        x = initActionX,
        time = 850,
        transition = easing.inOutBack,
        onComplete = function()
            self.actions.open = false
            self.actions.lock = false
        end
    })

    self:rotateButton(self.toggleActionsButton, true)
    self:rotateButton(self.infoButton, true)
    self:rotateButton(self.musicButton, true)
end

function scene:rotateButton(button, back)
    local rotation = function() if (back) then return 0 else return -360 end end
    transition.to(button, {
        rotation = rotation(),
        time = 850,
        transition = easing.inOutBack
    })
end

--------------------------------------------------------------------------------

function scene:redrawMusicButton()
    if(self.musicButton) then
        display.remove(self.musicButton)
    end

    local musicType = 'music'
    if(Sound.isOff) then
        musicType = 'music-off'
    end

    self.musicButton = Button:icon({
        parent = self.actions,
        type   = musicType,
        x      = 220,
        y      = 0,
        scale  = .7,
        action = function()
            Sound:toggleAll()
            self:redrawMusicButton()
        end
    })
end

--------------------------------------------------------------------------------

function scene:drawButton(options)
    return Button:icon({
        parent = self.view,
        type   = 'play',
        x      = options.x,
        y      = options.y,
        scale  = 1.6,
        bounce = true,
        action = function ()
            analytics.event('game', options.analyticsEventName)
            if(self.actions.open) then
                self:closeActions()
            end
            Router:open(options.screen)
        end
    })
end

--------------------------------------------------------------------------------

function scene:drawPlayButton()
    return self:drawButton({
        analyticsEventName = 'home-play-button',
        x                  = display.contentWidth*0.5,
        y                  = display.contentHeight*0.5,
        screen             = Router.PLAYGROUND
    })
end

function scene:drawShopButton()
    return self:drawButton({
        analyticsEventName = 'home-shop-button',
        x                  = display.contentWidth*0.35,
        y                  = display.contentHeight*0.5,
        screen             = Router.SHOP
    })
end

function scene:drawCollectionButton()
    return self:drawButton({
        analyticsEventName = 'home-collection-button',
        x                  = display.contentWidth*0.65,
        y                  = display.contentHeight*0.5,
        screen             = Router.COLLECTION
    })
end

--------------------------------------------------------------------------------

function scene:hide( event )
end

function scene:destroy( event )
    Runtime:removeEventListener( 'enterFrame', self.refreshCamera )
end

--------------------------------------------------------------------------------

scene:addEventListener( 'create', scene )
scene:addEventListener( 'show', scene )
scene:addEventListener( 'hide', scene )
scene:addEventListener( 'destroy', scene )

--------------------------------------------------------------------------------

return scene

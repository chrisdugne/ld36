--------------------------------------------------------------------------------

local scene = composer.newScene()

--------------------------------------------------------------------------------

function scene:create( event )
    --------------------------------------
    -- title

    self.title = GUI:banner({
        parent = self.view,
        text   = 'Shop'
    })

    --------------------------------------
    -- close button

    self.closeButton = Button:icon({
        parent = self.view,
        type   = 'close',
        x      = display.contentWidth - 75,
        y      = 75,
        action = function ()
            Router:open(Router.HOME)
        end
    })

end

function scene:show( event )
    if ( event.phase == 'did' ) then
        utils.bounce(self.title)
        utils.bounce(self.closeButton)
    end
end

function scene:hide( event )
end

function scene:destroy( event )
end

--------------------------------------------------------------------------------

scene:addEventListener( 'create', scene )
scene:addEventListener( 'show', scene )
scene:addEventListener( 'hide', scene )
scene:addEventListener( 'destroy', scene )

--------------------------------------------------------------------------------

return scene

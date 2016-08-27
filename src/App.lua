--------------------------------------------------------------------------------

local App = {
    NAME    = 'LD36 - Uralys|VelvetCoffee',
    VERSION = '0.1',
    IOS_ID  = 'XXXXX',

    -----------------------------------------
    -- 'production', 'development', 'editor'
    ENV = 'development',
    -----------------------------------------

    display = display.newGroup(),
    hud     = display.newGroup()
}

--------------------------------------------------------------------------------

function App:start()
    print('---------------------- ' .. App.NAME .. ' [ ' .. App.ENV .. ' ] ----------------')
    self:deviceSetup()
    self:setup()
    self:loadSettings()
    self:ready()
end

--------------------------------------------------------------------------------

function App:loadSettings()
    print('---------- SETTINGS ------------')
    local path = 'env/' .. App.ENV .. '.json'
    local resource = system.pathForFile( path, system.ResourcesDirectory )

    local file     = io.open(resource, 'r')
    local contents = file:read( '*a' )
    local settings = json.decode(contents)

    utils.tprint(settings)
    print('--------------------------------')

    App.SOUND_OFF      = settings.silent
    App.EDITOR_TESTING = settings.editor
    App.EDITOR_PLAY    = settings.play
    App.VIEW_TESTING   = settings['view-testing']
    App.LEVEL_TESTING  = settings['level-testing']

    if(App.LEVEL_TESTING) then
        App.TESTING_CHAPTER = App.LEVEL_TESTING.chapter
        App.TESTING_LEVEL   = App.LEVEL_TESTING.level
        App.TESTING_STEPS   = App.LEVEL_TESTING.step
    end
end

--------------------------------------------------------------------------------

function App:ready()
    self.game = Game:new()
    self.user = User:new()
    self.user:load()

    Background:init()
    if(not App.SOUND_OFF) then
        Sound:playMusic()
    end

    if(App.VIEW_TESTING) then
        print(' --> forced view : ' .. App.VIEW_TESTING)
        print('--------------------------------')
        Router:open(App.VIEW_TESTING)

    elseif(App.EDITOR_TESTING or App.LEVEL_TESTING) then
        print(' --> forced playground')
        print('--------------------------------')
        Router:open(Router.PLAYGROUND)

    else
        local nextView = Router.HOME

        if(self.user:isNew()) then
            nextView = Router.PLAYGROUND
        end

        Router:open(Router.HEADPHONES, {
            nextView = nextView
        })
    end
end

--------------------------------------------------------------------------------
-- Setup
--------------------------------------------------------------------------------

function App:setup()

    print('Application setup...')

    ----------------------------------------------------------------------------
    ---- App globals

    GLOBALS = {
        savedData = utils.loadUserData('savedData.json'),
        options   = utils.loadUserData('options.json'),
        levels    = utils.loadFile('assets/levels.json')
    }

    ----------------------------------------------------------------------------

    FACEBOOK_PAGE_ID = 'XXXXX'
    FACEBOOK_PAGE    = 'https://www.facebook.com/uralys'

    ----------------------------------------------------------------------------

    ANALYTICS_VERSION     = 1
    ANALYTICS_TRACKING_ID = 'UA-XXXXX-XX'
    ANALYTICS_PROFILE_ID  = 'XXXXX'

    analytics.init(
        ANALYTICS_VERSION,
        ANALYTICS_TRACKING_ID,
        ANALYTICS_PROFILE_ID,
        App.NAME,
        App.VERSION
    )

    ----------------------------------------------------------------------------

    IOS         = system.getInfo( 'platformName' )  == 'iPhone OS'
    ANDROID     = system.getInfo( 'platformName' )  == 'Android'
    SIMULATOR   = system.getInfo( 'environment' )   == 'simulator'

    ----------------------------------------------------------------------------

    if(IOS or SIMULATOR) then
        display.setStatusBar( display.HiddenStatusBar )
    end

    ----------------------------------------------------------------------------

    if ANDROID then
        FONT   = 'y2kboogie'
    else
        FONT   = 'Year2000Boogie'
    end

    ----------------------------------------------------------------------------

    self.aspectRatio = display.pixelHeight / display.pixelWidth

    ----------------------------------------------------------------------------

    abs    = math.abs
    random = math.random
    round  = math.round

    ----------------------------------------------------------------------------

end

--------------------------------------------------------------------------------

function App:deviceSetup()

    print('Device setup...')

    ----------------------------------------------------------------------------
    -- prepare notifications for this session
    -- these notifications can be removed as long as the App is ON

    self.deviceNotifications = {}

    ----------------------------------------------------------------------------
    --- ANDROID BACK BUTTON

    local function onKeyEvent( event )

        local phase = event.phase
        local keyName = event.keyName
        print( event.phase, event.keyName )

        if ( 'back' == keyName and phase == 'up' ) then
        end

        if ( keyName == 'volumeUp' and phase == 'down' ) then
            local masterVolume = audio.getVolume()
            print( 'volume:', masterVolume )
            if ( masterVolume < 1.0 ) then
                masterVolume = masterVolume + 0.1
                audio.setVolume( masterVolume )
            end
        elseif ( keyName == 'volumeDown' and phase == 'down' ) then
            local masterVolume = audio.getVolume()
            print( 'volume:', masterVolume )
            if ( masterVolume > 0.0 ) then
                masterVolume = masterVolume - 0.1
                audio.setVolume( masterVolume )
            end
        end

        return true  --SEE NOTE BELOW
    end

    --add the key callback
    Runtime:addEventListener( 'key', onKeyEvent )

    ----------------------------------------------------------------------------

    local function myUnhandledErrorListener( event )

        local iHandledTheError = true

        if iHandledTheError then
            print( 'Handling the unhandled error', event.errorMessage )
        else
            print( 'Not handling the unhandled error', event.errorMessage )
        end

        return iHandledTheError
    end

    Runtime:addEventListener('unhandledError', myUnhandledErrorListener)

    ----------------------------------------------------------------------------

    -- local fonts = native.getFontNames()

    -- count = 0

    -- -- Count the number of total fonts
    -- for i,fontname in ipairs(fonts) do
    --    count = count+1
    -- end

    -- print( '\rFont count = ' .. count )

    -- local name = 'pt'     -- part of the Font name we are looking for

    -- name = string.lower( name )

    -- -- Display each font in the terminal console
    -- for i, fontname in ipairs(fonts) do

    --        print( 'fontname = ' .. tostring( fontname ) )
    -- end
end

--------------------------------------------------------------------------------

function App:deviceNotification(text, secondsFromNow, id)

    print('----> deviceNotification : [' .. id .. '] --> ' ..
            text .. ' (' .. secondsFromNow .. ')'
    )

    local options = {
        alert = text,
        badge = 1,
    }

    if(self.deviceNotifications[id]) then
        print('cancelling device notification : ', self.deviceNotifications[id])
        system.cancelNotification( self.deviceNotifications[id] )
    end

    print('scheduling : ', id, secondsFromNow)
    self.deviceNotifications[id] = system.scheduleNotification(
        secondsFromNow,
        options
    )
    print('scheduled : ', self.deviceNotifications[id])

end

--------------------------------------------------------------------------------
-- API
--------------------------------------------------------------------------------

function App:adaptToRatio(value)
    return value * self.aspectRatio * self.aspectRatio
end

--------------------------------------------------------------------------------

return App

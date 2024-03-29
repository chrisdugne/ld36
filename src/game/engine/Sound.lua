--------------------------------------------------------------------------------

local Sound = {
    isOff = false,
    options = {},
    clicks = {},
    channels = {},
    TIMER = 17454
}

-----------------------------------------------------------------------------------------

local ld = audio.loadSound('assets/sounds/music/ludumdare.mp3')
local button = audio.loadSound('assets/sounds/sfx/button.mp3')

local boos = {
    audio.loadSound('assets/sounds/sfx/boo1.mp3'),
    audio.loadSound('assets/sounds/sfx/boo2.mp3'),
    audio.loadSound('assets/sounds/sfx/boo3.mp3')
}

local bips = {
    audio.loadSound('assets/sounds/sfx/bip1.mp3'),
    audio.loadSound('assets/sounds/sfx/bip2.mp3'),
    audio.loadSound('assets/sounds/sfx/bip3.mp3'),
    audio.loadSound('assets/sounds/sfx/bip4.mp3'),
    audio.loadSound('assets/sounds/sfx/bip5.mp3'),
    audio.loadSound('assets/sounds/sfx/bip6.mp3')
}

local yeahs = {
    audio.loadSound('assets/sounds/sfx/yeah2.mp3'),
    audio.loadSound('assets/sounds/sfx/yeah4.mp3')
}

-----------------------------------------------------------------------------------------

function Sound:start()
    self.channels.music = audio.play(ld)
    audio.seek(  (App.user.level-1) * Sound.TIMER, { channel=music } )
end

function Sound:startWave()
    audio.resume(self.channels.music)
end

function Sound:stop()
    audio.stop(self.channels.music)
end

function Sound:nextStep()
    self:playYeah()
end

function Sound:rewind(level, next)
    local time = (level-1) * Sound.TIMER
    audio.pause(self.channels.music)

    audio.pause()
    audio.seek( time, { channel=self.channels.music } )

    self:playBoo(function()
        next()
    end)
end

--------------------------------------------------------------------------------

function Sound:toggleAll()
    self.isOff = not self.isOff
    self:toggleMusic()
    self:toggleEffects()
end

function Sound:toggleMusic()
    self:toggle(self.channels.music)
end

function Sound:toggleEffects()
    self:toggle(self.channels.effects)
end

--------------------------------------------------------------------------------

function Sound:off(channel)
    audio.setVolume( 0, { channel = channel } )
end

function Sound:on(channel)
    audio.setVolume( 1, { channel = channel } )
end

function Sound:toggle(channel)
    local current = audio.getVolume( { channel = channel } )
    if(current > 0 ) then
        self:off(channel)
    else
        self:on(channel)
    end
end

--------------------------------------------------------------------------------

function Sound:musicVolume(value)
    audio.setVolume( value, { channel = self.channels.music } )
end

function Sound:effectsVolume(value)
    audio.setVolume( value, { channel = self.channels.effects } )
end

--------------------------------------------------------------------------------

function Sound:effect(effect, value, onComplete)
    if(not self.isOff and not App.SOUND_OFF) then
        self.channels.effects = audio.play(effect, {
            onComplete=function() if(onComplete) then onComplete() end end
        })
        self:effectsVolume(value or 1)
    end
end

--------------------------------------------------------------------------------

function Sound:playBoo(onComplete)
    self:effect( boos[math.random(1,#boos)], 0.4, onComplete )
end

function Sound:playButton()
    self:effect( button, 0.4 )
end

function Sound:playBip()
    self:effect( bips[math.random(1,#bips)], 0.1 )
end

function Sound:playYeah()
    self:effect( yeahs[math.random(1,#yeahs)], 0.35 )
end

-----------------------------------------------------------------------------------------

return Sound

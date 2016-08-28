--------------------------------------------------------------------------------

local Sound = {
    isOff = false,
    options = {},
    clicks = {},
    channels = {},
    TIMER = 8727
}

-----------------------------------------------------------------------------------------

local ld = audio.loadSound('assets/sounds/music/ludumdare.mp3')

local boos = {
    audio.loadSound('assets/sounds/music/boo1.mp3'),
    audio.loadSound('assets/sounds/music/boo2.mp3'),
    audio.loadSound('assets/sounds/music/boo3.mp3')
}

local yeahs = {
    audio.loadSound('assets/sounds/music/yeah1.mp3'),
    audio.loadSound('assets/sounds/music/yeah2.mp3'),
    audio.loadSound('assets/sounds/music/yeah4.mp3'),
    audio.loadSound('assets/sounds/music/yeah3.mp3')
}

-----------------------------------------------------------------------------------------

function Sound:start()
    self.currentStep = 0
    self.clicks = {}
    self.channels.music = audio.play(ld)
    self:prepareClicks()
end

function Sound:stop()
    for i=1,1000 do
        timer.cancel(self.clicks[i])
    end
end

function Sound:prepareClicks()
    for i=1,1000 do
        self.clicks[i] = timer.performWithDelay(self.TIMER*i, function ()
            self:seek(self.TIMER * self.currentStep)
        end)
    end
end

function Sound:nextStep()
    self.currentStep = self.currentStep + 1
    self:playYeah()
end

function Sound:seek(time)
    audio.seek( time, { channel=self.channels.music } )
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

function Sound:effect(effect, value)
    if(not self.isOff and not App.SOUND_OFF) then
        self.channels.effect = audio.play(effect)
        self:effectsVolume(value or 1)
    end
end

--------------------------------------------------------------------------------

function Sound:playBoo()
    self:effect( boos[math.random(1,#boos)], 0.4 )
end

function Sound:playYeah()
    self:effect( yeahs[math.random(1,#yeahs)], 0.5 )
end

-----------------------------------------------------------------------------------------

return Sound

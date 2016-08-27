--------------------------------------------------------------------------------
--
-- main.lua
--
--------------------------------------------------------------------------------
--- Corona's libraries
json                = require 'json'
composer            = require 'composer'

---- Additional libs

CBE                 = require 'CBE.CBE'
_                   = require 'src.libs.Underscore'
utils               = require 'src.libs.Utils'
analytics           = require 'src.libs.google.Analytics'

--------------------------------------------------------------------------------
---- App packages

-- main
App                 = require 'src.App'
Router              = require 'src.Router'
User                = require 'src.User'

-- game engine
Game                = require 'src.game.engine.Game'
Camera              = require 'src.game.engine.Camera'
HUD                 = require 'src.game.engine.HUD'
Effects             = require 'src.game.engine.Effects'
Touch               = require 'src.game.engine.TouchController'
Score               = require 'src.game.engine.Score'
Sound               = require 'src.game.engine.Sound'

-- gui components
GUI                 = require 'src.components.GUI'
Background          = require 'src.components.Background'
Panel               = require 'src.components.Panel'
Banner              = require 'src.components.Banner'
Button              = require 'src.components.Button'
Icon                = require 'src.components.Icon'
ProgressBar         = require 'src.components.ProgressBar'
Scroller            = require 'src.components.Scroller'
Screen              = require 'src.components.Screen'
Focus               = require 'src.components.Focus'

--------------------------------------------------------------------------------
---- Models

Cerise              = require 'src.game.models.Cerise'

--------------------------------------------------------------------------------

App:start()

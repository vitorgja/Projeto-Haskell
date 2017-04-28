{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE ViewPatterns         #-}
{-# LANGUAGE QuasiQuotes       #-}
module Application where

import Foundation
import Yesod
import Handlers.Admin
import Handlers.Home
import Handlers.Widgets
import Handlers.Forms

mkYesodDispatch "App" resourcesApp

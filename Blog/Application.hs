{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE ViewPatterns         #-}
{-# LANGUAGE QuasiQuotes       #-}
module Application where

import Foundation
import Yesod

import Handlers.Post
import Handlers.Categoria
import Handlers.Usuario
import Handlers.Contato
import Site

import Helper.Widgets



mkYesodDispatch "App" resourcesApp

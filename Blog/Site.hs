{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
module Site where

import Yesod
import Foundation
import Data.Text
import Control.Applicative
import Database.Persist.Postgresql

import Handlers.Widgets



{-
  h   h    ooo  m   m   eeeee
  h   h   o   o   mm mm   e
  hhhhh   o   o   m m m   eeeee
  h   h   o   o   m   m   e
  h   h    ooo  m   m   eeeee
-}        



getPostsR :: Handler Html
getPostsR = undefined




-- http://www.yesodweb.com/book/sql-joins
-- http://www.yesodweb.com/book/sql-joins
-- http://www.yesodweb.com/book/sql-joins
-- http://www.yesodweb.com/book/sql-joins

getHomeR :: Handler Html
getHomeR = do
    categorias <- runDB $ selectList [] [Asc CategoriaNome]
    posts <- runDB $ selectList [] [Asc PostTitulo]
    
    $(logDebug) $ pack $ show posts
    
    
    -- records <- runDB $ do
    --     -- sessions <- selectList [] []
    --     -- players  <- selectList [] []
    --     -- tables   <- selectList [] []
        
    --     -- return $ joinTables3 gamingSessionPlayer gamingSessionTable sessions players tables
        
    --     categorias  <- selectList [] [Asc CategoriaNome]
    --     posts       <- selectList [] [Asc PostTitulo]
        
    --     return $ joinCategoria2 postsCategoria categorias posts
    
     
    
    defaultLayout $ do
    
        setTitle "Codemage | Blog"
        addStylesheetRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.css"
        addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css"
        addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
        addScriptRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.js"
        
        -- na função toWidgetHead você manda o que você quiser para o head da página
        
        
        -- Aqui irá o css, sempre para usar o lucius ou cassius tem que chamar a função toWidget
        toWidget $ css
        
        toWidget $ js
        
        toWidget $ $(whamletFile (tplString "home/home.hamlet") )
    
    








{-
   aaa  dddd  m   m   i   n   n
  a   a   d   d   mm mm   i   nn  n
  aaaaa   d   d   m m m   i   n n n
  a   a   d   d   m   m   i   n  nn
  a   a   dddd  m   m   i   n   n
-}  



getHomeAdminR :: Handler Html
getHomeAdminR = do
    
    
    sess <- lookupSession "_ID"
    
    defaultLayout $ do
        setTitle "Codemage | Blog - Admin"
        addStylesheetRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.css"
        addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css"
        addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
        addScriptRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.js"

        toWidget [lucius|
            ul li {
                display: inline;
            }
            a {
                color: blue;
                padding: 10px 20px
                background: #c5c4c5;
            }
        |]
        
         -- Aqui irá o css, sempre para usar o lucius ou cassius tem que chamar a função toWidget
        toWidget $ css
        -- Aqui irá o js, sempre para usar o Julious tem que chamar a função toWidget
        toWidget $ js
        
        toWidget [whamlet|
        
            <div .admin>
                
                ^{showAdminMenuLink sess}
                ^{headerAdminHome}
                
                <div .row .conteudo>
                
                    <button .button type="button" data-toggle="example-dropdown">Toggle Dropdown
                    <div .dropdown-pane id="example-dropdown" data-dropdown>Just some junk that needs to be said. Or not. Your choice.

                ^{footerHome}
        |]
        
        
       
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
module Site where

import Yesod
import Foundation
import Data.Text
import Control.Applicative
import Database.Persist.Postgresql

import Helper.Widgets



{-
  h   h    ooo    m   m   eeeee
  h   h   o   o   mm mm   e
  hhhhh   o   o   m m m   eeeee
  h   h   o   o   m   m   e
  h   h    ooo    m   m   eeeee
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
    
    defaultLayout $ do
    
        setTitle "Codemage | Blog - Home Page"
        
        toWidget $ headSite
        toWidget $ $(whamletFile (tplString "home/home.hamlet") )
    
    








{-
   aaa    dddd    m   m   i   n   n
  a   a   d   d   mm mm   i   nn  n
  aaaaa   d   d   m m m   i   n n n
  a   a   d   d   m   m   i   n  nn
  a   a   dddd    m   m   i   n   n
-}  



getHomeAdminR :: Handler Html
getHomeAdminR = do
    
    
    sess <- lookupSession "_ID"
    
    defaultLayout $ do
        setTitle "Codemage | Blog - Admin"

        toWidget $ headAdmin
        -- CSS
        toWidget [lucius|
            ul li { display: inline; }
            a { color: blue; padding: 10px 20px background: #c5c4c5;
            }
        |]
        
        
        -- HTML
        toWidget [whamlet|
            <div .admin>
                ^{showAdminMenuLink sess}
                ^{headerAdminHome}
                
                <div .row .conteudo>
                
                    <button .button type="button" data-toggle="example-dropdown">Toggle Dropdown
                    <div .dropdown-pane id="example-dropdown" data-dropdown>Just some junk that needs to be said. Or not. Your choice.

                ^{footerHome}
        |]
        
        
       
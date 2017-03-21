{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
module Handlers.Home where

import Foundation
--import Yesod.Core

import Yesod
import Data.Text
import Control.Applicative
import Database.Persist.Postgresql

import Handlers.Widgets
import Handlers.Forms

-- Blog ----------------------------------------------------------------------------------------------------------------

------- DE FORA
{-
productsAndCategories :: GHandler App App [(Categoria)]
productsAndCategories = runDB $ selectList [] [Asc ProductName] >>= mapM (\(Entity kp p) -> do
    categoryProducts <- selectList [PostCategoria ==. kp] []
    return (p, Prelude.map entityVal categoryProducts)) 
                                         
--}
------- DE FORA

vaiGoku (Entity uid _) = uid


pegarCategoriaR :: CategoriaId -> Handler Html
pegarCategoriaR cid = do
    categoria <- runDB $ get404 cid
    
    posts <- runDB $ selectList [ (PostCategoria ==. cid )] [Asc PostTitulo] 
    
    -- >>= mapM (\(Entity kp p) -> do
    --    categoryProducts <- selectList [PostCategoria ==. kp] []
   
    defaultLayout $ do
    
        setTitle "Codemage | Blog - Categoria"
        addStylesheetRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.css"
        addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css"
        addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
        addScriptRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.js"
        
        -- na função toWidgetHead você manda o que você quiser para o head da página
        
        
        -- Aqui irá o css, sempre para usar o lucius ou cassius tem que chamar a função toWidget
        toWidget $ css
        
        toWidget $ js
        
        -- toWidget $ [hamlet|          #{show categoria}       |]
        
        -- toWidget $ $(whamletFile (tplString "home/categoria.hamlet") )
    
    

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
    
    
getPostIdR :: PostId -> Handler Html
getPostIdR postId = do
    post  <- runDB $ get404 postId
    categoria <- runDB $ get404 (postCategoria post)
    
    -- let catId =
    --     optionsPairs $ fmap (\ent -> entityKey ent) categoria
    
    posts <- runDB $ selectList [] [Asc PostTitulo]
    
    --animal <- runDB $ get404 alid 
    --especies <- runDB $ get404 (animalEspecieid animal)
    
    defaultLayout $ do
        setTitle "Codemage | Blog " 
        addStylesheetRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.css"
        addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css"
        addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
        addScriptRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.js"
        
        
        toWidget $ css
        toWidget $ js
        toWidget $ $(whamletFile (tplString "home/post.hamlet") )
        
        
-- Categoria -----------------------------------------------------------------------------------------------------------
getCategoriaIdR :: CategoriaId -> Handler Html
getCategoriaIdR cid = do

    -- Current Category
    categoria <- runDB $ get404 cid
    
    -- All Category
    categorias <- runDB $ selectList [] [Asc CategoriaNome]
    
    -- let catId =
    --     optionsPairs $ fmap (\ent -> entityKey ent) categoria
    
    posts <- runDB $ selectList [ (PostCategoria ==. cid )] [Asc PostTitulo] 
    -- posts <- runDB $ selectList [] [Asc PostTitulo]
    
    defaultLayout $ do
        setTitle "Codemage | Blog " 
        addStylesheetRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.css"
        addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css"
        addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
        addScriptRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.js"
        
        toWidget $ css
        toWidget $ js
        toWidget $ $(whamletFile (tplString "home/categoria.hamlet") )


-- Contatos ------------------------------------------------------------------------------------------------------------
getContatoR :: Handler Html
getContatoR = do
            (widget, enctype) <- generateFormPost formContato
            defaultLayout $ do 
            
            setTitle "Codemage | Blog"
            addStylesheetRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.css"
            addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css"
            addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
            addScriptRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.js"            
            
            -- Aqui irá o css, sempre para usar o lucius ou cassius tem que chamar a função toWidget
            
            toWidget $ css
            toWidget $ js
            toWidget $ $(whamletFile (tplString "home/contato.hamlet") )


postContatoR :: Handler Html
postContatoR = do
            (widget, enctype) <- generateFormPost formContato
            ((result, _), _) <- runFormPost formContato
            case result of
                FormSuccess contato -> do
                    alid <- runDB $ insert contato
                    defaultLayout $ do 
            
                    setTitle "Codemage | Blog Contato Sucesso"
                    addStylesheetRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.css"
                    addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css"
                    addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
                    addScriptRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.js"            
                    
                    
                    toWidget $ css
                    toWidget $ js
                    toWidget $ $(whamletFile (tplString "home/contato.sucesso.hamlet") )
                    
                    
                _ -> defaultLayout $ do 
            
                    setTitle "Codemage | Blog Contato Erro"
                    addStylesheetRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.css"
                    addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css"
                    addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
                    addScriptRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.js"            
    
                    -- Aqui irá o css, sempre para usar o lucius ou cassius tem que chamar a função toWidget
                    toWidget $ css
                    toWidget $ js
                    toWidget $ $(whamletFile (tplString "home/contato.erro.hamlet") )
                    

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
module Handlers.Post where

import Foundation
--import Yesod.Core

import Yesod
import Data.Text
import Control.Applicative
import Database.Persist.Postgresql

import Helper.Widgets



formPost :: Form Post
formPost = renderDivs $ Post 
    <$> areq textField "Slug" Nothing
    <*> areq textField "Nome" Nothing 
    <*> areq textareaField "Idade" Nothing
    <*> areq (selectField usuarios) "Usuarios" Nothing
    <*> areq (selectField dptos) "Categoria" Nothing

dptos = do
    entidades <- runDB $ selectList [] [Asc CategoriaNome] 
    optionsPairs $ fmap (\ent -> (categoriaNome $ entityVal ent, entityKey ent)) entidades
    
usuarios = do
        entidades <- runDB $ selectList [] [Asc UsuarioNome] 
        optionsPairs $ fmap (\ent -> (usuarioNome $ entityVal ent, entityKey ent)) entidades





{-
	h   h 	 ooo 	m   m 	eeeee
	h   h 	o   o 	mm mm 	e
	hhhhh 	o   o 	m m m 	eeeee
	h   h 	o   o 	m   m 	e
	h   h 	 ooo 	m   m 	eeeee
-}        

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





{-
	 aaa 	dddd 	m   m 	i 	n   n
	a   a 	d   d 	mm mm 	i 	nn  n
	aaaaa 	d   d 	m m m 	i 	n n n
	a   a 	d   d 	m   m 	i 	n  nn
	a   a 	dddd 	m   m 	i 	n   n
-}  



-- POST --------------------------------------------------------------------------------------------------
getPostR :: Handler Html
getPostR = do
            sess <- lookupSession "_ID"
            (widget,enctype)<- generateFormPost formPost
            defaultLayout $ do
                setTitle "Admin | Blog"
                addStylesheetRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.css"
                addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css"
                addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
                addScriptRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.js"
                
                -- Aqui irá o css, sempre para usar o lucius ou cassius tem que chamar a função toWidget
                toWidget $ css
                -- Aqui irá o js, sempre para usar o Julious tem que chamar a função toWidget
                toWidget $ js
            
                toWidget $ $(whamletFile (tplString "admin/post/postadd.hamlet") )
               
                
postPostR :: Handler Html
postPostR = do
            ((resultado,_),_)<- runFormPost formPost
            case resultado of
                FormSuccess post -> do
                    uid <- runDB $ Database.Persist.Postgresql.insert post
                    defaultLayout [whamlet|
                    Post cadastrado com sucesso! #{postTitulo post}
                    |]
                _ -> redirect HomeR
                            
postDelPostR :: PostId -> Handler Html
postDelPostR alid = do 
    runDB $ Database.Persist.Postgresql.delete alid
    redirect PostListaR
                                
-- SELECT * FROM post ORDER BY nome
getPostListaR :: Handler Html
getPostListaR = do
    sess <- lookupSession "_ID"
    posts <- runDB $ selectList [] [Asc PostTitulo]
    defaultLayout $ do
        
        setTitle "Admin | Blog"
        addStylesheetRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.css"
        addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css"
        addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
        addScriptRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.js"
        
        -- Aqui irá o css, sempre para usar o lucius ou cassius tem que chamar a função toWidget
        toWidget $ css
        -- Aqui irá o js, sempre para usar o Julious tem que chamar a função toWidget
        toWidget $ js
    
        toWidget $ $(whamletFile (tplString "admin/post/postlista.hamlet") )


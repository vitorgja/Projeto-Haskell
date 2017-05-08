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
    
   
    
    posts <- runDB $ selectList [] [Asc PostTitulo]
    
    
    
    defaultLayout $ do
        setTitle $ "Codemage | Blog - POST"
        toWidget $ headSite 
        -- toWidget $ [hamlet| #{show $ postTitulo post}|]
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
                setTitle "Admin | Blog - Post"
                toWidget $ headAdmin
                toWidget $ $(whamletFile (tplString "admin/post/postadd.hamlet") )
               
                
postPostR :: Handler Html
postPostR = do
            ((resultado,_),_)<- runFormPost formPost
            case resultado of
                FormSuccess post -> do
                    uid <- runDB $ Database.Persist.Postgresql.insert post
                    defaultLayout $ do
                    	setTitle "Admin | Blog - Post Cadastrado"
                    	toWidget $ headAdmin
                    	toWidget $ $(whamletFile (tplString "admin/post/post.add.sucesso.hamlet") )
	                    
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
        
        setTitle "Admin | Blog - Lista"
        toWidget $ headAdmin
        toWidget $ $(whamletFile (tplString "admin/post/postlista.hamlet") )


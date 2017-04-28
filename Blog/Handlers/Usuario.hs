{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
module Handlers.Usuario where

import Foundation
--import Yesod.Core

import Yesod
import Data.Text
import Control.Applicative
import Database.Persist.Postgresql

import Handlers.Widgets



formUserLogin :: Form Usuario
formUserLogin = renderDivs $ Usuario
    <$> areq textField     "Nome"    Nothing 
    <*> areq emailField    "E-mail"  Nothing
    <*> areq passwordField "Senha"   Nothing

formUser :: Form Usuario
formUser = renderDivs $ Usuario
    <$> areq textField     "Nome"    Nothing 
    <*> areq emailField    "E-mail"  Nothing
    <*> areq passwordField "Senha"   Nothing




{-
	h   h 	 ooo 	m   m 	eeeee
	h   h 	o   o 	mm mm 	e
	hhhhh 	o   o 	m m m 	eeeee
	h   h 	o   o 	m   m 	e
	h   h 	 ooo 	m   m 	eeeee
-}        

      


-- Usuario -------------------------------------------------------------------------------------------------------------
getLoginR :: Handler Html
getLoginR = do
    (widget,enctype)<- generateFormPost formUserLogin
    -- sess <- lookupSession "_ID"
    defaultLayout $ do
        setTitle "Login - Codemage | Blog"
        addStylesheetRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.css"
        addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css"
        addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
        addScriptRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.js"
    
        -- Aqui irá o css, sempre para usar o lucius ou cassius tem que chamar a função toWidget
        toWidget $ css
        -- Aqui irá o js, sempre para usar o Julious tem que chamar a função toWidget
        toWidget $ js
    
        toWidget [whamlet|
            ^{showMenuLink}
            ^{headerHome}
            
            <div .row .conteudo>
                <div .medium-8 .medium-offset-2 .columns>
                    <h3> Admin
                        <small> Login
                    <hr>
            
                    <form action=@{LoginR} method=post enctype=#{enctype}>
                        ^{widget}
                        <input type="submit" value="Logar">
                        
                        
            ^{footerHome}
        |]
-- Rota de autenticação
postLoginR :: Handler Html
postLoginR = do
    ((resultado,_),_)<- runFormPost formUserLogin
    case resultado of
        FormSuccess user -> do
            usuario <- runDB $ selectFirst [UsuarioEmail ==. (usuarioEmail user),
                UsuarioSenha ==. (usuarioSenha user)] []
            case usuario of
                    Nothing -> redirect LoginR
                    Just (Entity uid _) -> do
                        setSession "_ID" (pack $ show uid)
                        redirect PerfilR
        _ -> redirect HomeR

getUsuarioR :: Handler Html
getUsuarioR = do
            (widget,enctype)<- generateFormPost formUser
            defaultLayout $ do
                [whamlet|
                    <form action=@{UsuarioR} method=post enctype=#{enctype}>
                        ^{widget}
                        <input type="submit" value="Cadastrar">
                |]

postUsuarioR :: Handler Html
postUsuarioR = do
                    ((resultado,_),_)<- runFormPost formUser
                    case resultado of
                        FormSuccess user -> do
                            uid <- runDB $ Database.Persist.Postgresql.insert user
                            defaultLayout [whamlet|
                            Usuárix cadastrado com e-mail #{usuarioEmail user}
                            |]
                        _ -> redirect HomeR


                    
getPerfilR :: Handler Html
getPerfilR = do
    userId <- lookupSession "_ID"
    case userId of
        Just str -> do
            usuario <- runDB $ get404 (read (unpack str))
            defaultLayout [whamlet|
                    <h1> Logadoooo com #{usuarioEmail usuario}!!!! 
            |]
        Nothing -> defaultLayout [whamlet|
               <h1> Não Logadoooo!!!! 
            |]
                               
postLogoutR :: Handler Html
postLogoutR = do
    deleteSession "_ID"
    redirect HomeR





{-
	 aaa 	dddd 	m   m 	i 	n   n
	a   a 	d   d 	mm mm 	i 	nn  n
	aaaaa 	d   d 	m m m 	i 	n n n
	a   a 	d   d 	m   m 	i 	n  nn
	a   a 	dddd 	m   m 	i 	n   n
-}  

    
----------------------------------------------------------------------
-- USUARIO
getUsuarioListaR :: Handler Html
getUsuarioListaR = do
    sess <- lookupSession "_ID"
    usuarios <- runDB $ selectList [] [Asc UsuarioNome]

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
    
        toWidget $ $(whamletFile (tplString "admin/usuario/usuariolista.hamlet") )
        
   
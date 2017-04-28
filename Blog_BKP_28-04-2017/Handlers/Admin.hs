{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
module Handlers.Admin where

import Foundation
import Yesod.Core

import Yesod
import Data.Text
-- import Control.Applicative
import Database.Persist.Postgresql

import Handlers.Widgets
import Handlers.Forms



import Data.List

-- Index ---------------------------------------------------------------------------------------------------------------

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

-- Categorias ----------------------------------------------------------------------------------------------------------


-- Categoria -----------------------------------------------------------------------------------------------------------

getCategoriaR :: Handler Html
getCategoriaR = do
    (widget,enctype)<- generateFormPost formCategoria
    sess <- lookupSession "_ID"
    
    defaultLayout $ do
        
        setTitle "Codemage | Blog - Admin"
        addStylesheetRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.css"
        addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css"
        addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
        addScriptRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.js"
    
        -- Aqui irá o css, sempre para usar o lucius ou cassius tem que chamar a função toWidget
        toWidget $ css
        -- Aqui irá o js, sempre para usar o Julious tem que chamar a função toWidget
        toWidget $ js
        
        toWidget $ $(whamletFile (tplString "admin/categoria/categoriaadd.hamlet") )

        
postCategoriaR :: Handler Html
postCategoriaR = do
            ((resultado,_),_) <- runFormPost formCategoria
            case resultado of
                FormSuccess post -> do
                    uid <- runDB $ Database.Persist.Postgresql.insert post
                    defaultLayout [whamlet|
                        Post cadastrado com sucesso! #{show $ uid}
                    |]
                _ -> redirect HomeR
                    
-- SELECT * FROM aluno ORDER BY nome
getCategoriaListaR :: Handler Html
getCategoriaListaR = do
    sess <- lookupSession "_ID"
    categorias <- runDB $ selectList [] [Asc CategoriaNome]
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
    
        toWidget $ $(whamletFile (tplString "admin/categoria/categorialista.hamlet") )


postDelCategoriaR :: CategoriaId -> Handler Html
postDelCategoriaR alid = do 
    runDB $ Database.Persist.Postgresql.delete alid
    redirect CategoriaListaR
                                
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


-- Contatos ------------------------------------------------------------------------------------------------------------

-- SELECT * FROM aluno ORDER BY nome
getContatoListaR :: Handler Html
getContatoListaR = do
    sess <- lookupSession "_ID"
    contatos <- runDB $ selectList [] [Asc ContatoNome]

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
        
        toWidget $ $(whamletFile (tplString "admin/contato/contatolista.hamlet") )
    
    
postDelContatoR :: ContatoId -> Handler Html
postDelContatoR alid = do 
    runDB $ Database.Persist.Postgresql.delete alid
    redirect ContatoListaR
    
  
    
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
        
   
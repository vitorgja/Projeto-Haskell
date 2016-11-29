{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
module Handlers.Admin where

import Foundation
import Yesod.Core

import Yesod
import Data.Text
import Control.Applicative
import Database.Persist.Postgresql

import Handlers.Widgets
import Handlers.Forms

-- Index ---------------------------------------------------------------------------------------------------------------

getHomeAdminR :: Handler Html
getHomeAdminR = do
    sess <- lookupSession "_ID"
    
    defaultLayout $ do
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
        toWidget [whamlet|
            <h1> Meu primeiro site em Haskell!
            <ul>
                <li> <a href=@{CategoriaR}>Cadastro de Categoria
                <li> <a href=@{CategoriaListaR}>Listagem de Categoria
                <li> <a href=@{PostR}>Cadastro de Post
                <li> <a href=@{PostListaR}>Listagem de Post
                <li> <a href=@{ContatoR}>Contato
                $maybe _ <- sess
                    <li> 
                        <form action=@{LogoutR} method=post>
                            <input type="submit" value="Logout">
                $nothing
                    <li> <a href=@{LoginR}>Login
                    
            
        |]
       
       
        


-- Usuario -------------------------------------------------------------------------------------------------------------
getLoginR :: Handler Html
getLoginR = do
    (widget,enctype)<- generateFormPost formUserLogin
    defaultLayout $ do
        [whamlet|
            <form action=@{LoginR} method=post enctype=#{enctype}>
                ^{widget}
                <input type="submit" value="Logar">
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
                            uid <- runDB $ insert user
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
    defaultLayout $ do
        [whamlet|
            <form action=@{CategoriaR} method=post enctype=#{enctype}>
                ^{widget}
                <input type="submit" value="Logar">
        |]
        
postCategoriaR :: Handler Html
postCategoriaR = do
            ((resultado,_),_) <- runFormPost formCategoria
            case resultado of
                FormSuccess post -> do
                    uid <- runDB $ insert post
                    defaultLayout [whamlet|
                        Post cadastrado com sucesso!
                    |]
                _ -> redirect HomeR
                    
-- SELECT * FROM aluno ORDER BY nome
getCategoriaListaR :: Handler Html
getCategoriaListaR = do
    categorias <- runDB $ selectList [] [Asc CategoriaNome]
    defaultLayout $ do 
    
    [whamlet|
    
        <table>
        <tr> 
            <td> id  
            <td> Nome 
           
            
        $forall Entity alid categoria <- categorias
            <tr>
                <form action=@{DelCategoriaR alid} method=post> 
                    <td> #{fromSqlKey  alid} </td>  
                    <td> #{categoriaNome categoria} </td> 
                    <td> <input type="submit"> </td>
        
    |]


postDelCategoriaR :: CategoriaId -> Handler Html
postDelCategoriaR alid = do 
                                runDB $ delete alid
                                redirect CategoriaListaR
                                
-- POST --------------------------------------------------------------------------------------------------
getPostR :: Handler Html
getPostR = do
            (widget,enctype)<- generateFormPost formPost
            defaultLayout $ do
                [whamlet|
                    <form action=@{PostR} method=post enctype=#{enctype}>
                        ^{widget}
                        <input type="submit" value="Logar">
                |]
                
postPostR :: Handler Html
postPostR = do
                    ((resultado,_),_)<- runFormPost formPost
                    case resultado of
                        FormSuccess post -> do
                            uid <- runDB $ insert post
                            defaultLayout [whamlet|
                            Post cadastrado com sucesso! #{postTitulo post}
                            |]
                        _ -> redirect HomeR
                            
postDelPostR :: PostId -> Handler Html
postDelPostR alid = do 
                                runDB $ delete alid
                                redirect PostListaR
                                
-- SELECT * FROM post ORDER BY nome
getPostListaR :: Handler Html
getPostListaR = do
    posts <- runDB $ selectList [] [Asc PostTitulo]
    defaultLayout $(whamletFile "templates/admin/post/posttable.hamlet")


-- Contatos ------------------------------------------------------------------------------------------------------------

-- SELECT * FROM aluno ORDER BY nome
getContatoListaR :: Handler Html
getContatoListaR = do
    contatos <- runDB $ selectList [] [Asc ContatoNome]
    defaultLayout $ do 

    setTitle "Admin | Blog"
    addStylesheetRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.css"
    addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css"
    addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
    addScriptRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.js"
    
    [whamlet|
    
        <table>
            <thead>
                <tr>
                    <th> id  
                    <th> Nome 
                    <th> Email 
                    <th> Assunto 
                    <th> Descrição
                    <th>
            <tbody> 
        
            $forall Entity alid contato <- contatos
                <tr>
                    <form action=@{DelContatoR alid} method=post> 
                        <td> #{fromSqlKey  alid}  
                        <td> #{contatoNome      contato} 
                        <td> #{contatoEmail     contato} 
                        <td> #{contatoAssunto   contato}
                        <td> #{contatoDescricao contato}
                        <td> <input type="submit" value="excluir">
    |]
    
postDelContatoR :: ContatoId -> Handler Html
postDelContatoR alid = do 
    runDB $ delete alid
    redirect ContatoListaR
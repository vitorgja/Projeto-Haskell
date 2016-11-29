{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
module Handler.Admin where

import Foundation
import Yesod
import Data.Text
import Control.Applicative
import Database.Persist.Postgresql

import Handler.Widgets

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
       
       
        

-- Categoria -----------------------------------------------------------------------------------------------------------

formCategoria :: Form Categoria
formCategoria = renderDivs $ Categoria <$>
    areq textField "Nome" Nothing 


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
            ((resultado,_),_)<- runFormPost formCategoria
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
    defaultLayout $(whamletFile "templates/admin/categoria/categoriatable.hamlet")

postDelCategoriaR :: CategoriaId -> Handler Html
postDelCategoriaR alid = do 
                                runDB $ delete alid
                                redirect CategoriaListaR
    
-- Postagens -----------------------------------------------------------------------------------------------------------

formPost :: Form Post
formPost = renderDivs $ Post <$>
    areq textField "Nome" Nothing <*>
    areq textareaField "Idade" Nothing <*>
    areq (selectField usuarios) "Usuarios" Nothing <*>
    areq (selectField dptos) "Categoria" Nothing

dptos = do
    entidades <- runDB $ selectList [] [Asc CategoriaNome] 
    optionsPairs $ fmap (\ent -> (categoriaNome $ entityVal ent, entityKey ent)) entidades
    
usuarios = do
        entidades <- runDB $ selectList [] [Asc UsuarioNome] 
        optionsPairs $ fmap (\ent -> (usuarioNome $ entityVal ent, entityKey ent)) entidades

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
    

-- Usuarios -----------------------------------------------------------------------------------------------------------
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


-- Contatos ------------------------------------------------------------------------------------------------------------

-- SELECT * FROM aluno ORDER BY nome
getContatoListaR :: Handler Html
getContatoListaR = do
    contatos <- runDB $ selectList [] [Asc ContatoNome]
    defaultLayout $(whamletFile "templates/contatotable.hamlet")
    
postDelContatoR :: ContatoId -> Handler Html
postDelContatoR alid = do 
    runDB $ delete alid
    redirect ContatoListaR


        
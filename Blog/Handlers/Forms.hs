{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
module Handlers.Forms where

import Foundation
import Yesod.Core

import Yesod
import Data.Text
import Control.Applicative
import Database.Persist.Postgresql

-- Admin -------------------------------------------------------------------------------------------------

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

formCategoria :: Form Categoria
formCategoria = renderDivs $ Categoria <$>
    areq textField "Nome" Nothing 

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


-- Home --------------------------------------------------------------------------------------------------

formContato :: Form Contato
formContato = renderDivs $ Contato
    <$> areq textField  "Nome"      Nothing 
    <*> areq emailField "E-mail"    Nothing
    <*> areq textField  "Assunto"   Nothing
    <*> areq textareaField  "Mensagem" Nothing
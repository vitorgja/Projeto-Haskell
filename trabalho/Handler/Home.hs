{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
module Handler.Home where

import Foundation
import Yesod
import Data.Text
import Control.Applicative
import Database.Persist.Postgresql

import Handler.Widgets

-- Blog ----------------------------------------------------------------------------------------------------------------

getHomeR :: Handler Html
getHomeR = do
    sess <- lookupSession "_ID"
    categorias <- runDB $ selectList [] [Asc CategoriaNome]
    posts <- runDB $ selectList [] [Asc PostTitulo]
    defaultLayout $ do

        [whamlet|
            <h1> Codemage Blog
            <table>
                <tr> 
                    <td> id  
                    <td> nome 
                    <td>
                $forall Entity alid categoria <- categorias
                    <tr>
                        <td> #{fromSqlKey  alid}  
                        <td> #{categoriaNome      categoria} 
            <table>
                <tr> 
                    <td> id  
                    <td> titulo 
                    <td> descricao 
                    <td> usuario 
                $forall Entity alid post <- posts
                    <tr>
                        <td> #{fromSqlKey  alid}  
                        <td> #{postTitulo     post} 
                        <td> #{postDescricao     post} 

                        
        |]

-- Contatos ------------------------------------------------------------------------------------------------------------

formContato :: Form Contato
formContato = renderDivs $ Contato
    <$> areq textField  "Nome"      Nothing 
    <*> areq emailField "E-mail"    Nothing
    <*> areq textField  "Assunto"   Nothing
    <*> areq textField  "Descricao" Nothing
    
    
getContatoR :: Handler Html
getContatoR = do
            (widget, enctype) <- generateFormPost formContato
            defaultLayout [whamlet|
             <form method=post action=@{ContatoR} enctype=#{enctype}>
                 ^{widget}
                 <input type="submit" value="Cadastrar">
            |]


postContatoR :: Handler Html
postContatoR = do
            ((result, _), _) <- runFormPost formContato
            case result of
                FormSuccess contato -> do
                    alid <- runDB $ insert contato
                    defaultLayout [whamlet|
                        Cadastradx com sucesso #{fromSqlKey alid}!
                    |]
                _ -> redirect HomeR
                
                
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
module Handler.Contato where

import Foundation
import Yesod
import Data.Text
import Control.Applicative
import Database.Persist.Postgresql

import Handler.Widgets


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
                
                

-- SELECT * FROM aluno ORDER BY nome
getContatoListaR :: Handler Html
getContatoListaR = do
            contatos <- runDB $ selectList [] [Asc ContatoNome]
            defaultLayout $(whamletFile "templates/contatotable.hamlet")
                
postDelContatoR :: ContatoId -> Handler Html
postDelContatoR alid = do 
                runDB $ delete alid
                redirect ContatoListaR
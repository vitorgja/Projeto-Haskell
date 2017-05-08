{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
module Handlers.Contato where

import Foundation
--import Yesod.Core

import Yesod
import Data.Text
import Control.Applicative
import Database.Persist.Postgresql

import Helper.Widgets


formContato :: Form Contato
formContato = renderDivs $ Contato
    <$> areq textField  "Nome"      Nothing 
    <*> areq emailField "E-mail"    Nothing
    <*> areq textField  "Assunto"   Nothing
    <*> areq textareaField  "Mensagem" Nothing




{-
	h   h 	 ooo 	m   m 	eeeee
	h   h 	o   o 	mm mm 	e
	hhhhh 	o   o 	m m m 	eeeee
	h   h 	o   o 	m   m 	e
	h   h 	 ooo 	m   m 	eeeee
-}        


-- Contatos ------------------------------------------------------------------------------------------------------------
getContatoR :: Handler Html
getContatoR = do
            (widget, enctype) <- generateFormPost formContato
            defaultLayout $ do 
            
            setTitle "Codemage | Blog"
            toWidget $ headSite
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
                    toWidget $ headSite
                    toWidget $ $(whamletFile (tplString "home/contato.sucesso.hamlet") )
                    
                    
                _ -> defaultLayout $ do 
            
                    setTitle "Codemage | Blog Contato Erro"
                    toWidget $ headSite
                    toWidget $ $(whamletFile (tplString "home/contato.erro.hamlet") )
                    




{-
	 aaa 	dddd 	m   m 	i 	n   n
	a   a 	d   d 	mm mm 	i 	nn  n
	aaaaa 	d   d 	m m m 	i 	n n n
	a   a 	d   d 	m   m 	i 	n  nn
	a   a 	dddd 	m   m 	i 	n   n
-}  

-- Contatos ------------------------------------------------------------------------------------------------------------

-- SELECT * FROM aluno ORDER BY nome
getContatoListaR :: Handler Html
getContatoListaR = do
    sess <- lookupSession "_ID"
    contatos <- runDB $ selectList [] [Asc ContatoNome]

    defaultLayout $ do 

        setTitle "Admin | Blog"
        toWidget $ headAdmin
        toWidget $ $(whamletFile (tplString "admin/contato/contatolista.hamlet") )
    
    
postDelContatoR :: ContatoId -> Handler Html
postDelContatoR alid = do 
    runDB $ Database.Persist.Postgresql.delete alid
    redirect ContatoListaR
    
  
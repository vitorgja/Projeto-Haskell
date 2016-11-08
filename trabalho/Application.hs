{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE ViewPatterns         #-}
{-# LANGUAGE QuasiQuotes       #-}
module Application where

import Foundation
import Yesod
import Handler.Usuario
import Handler.Disciplina
import Handler.Aluno
------------------
mkYesodDispatch "App" resourcesApp

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
    toWidget [lucius|
        ul li {
            display: inline;
        }
        a {
            color: blue;
        }
    |]
    [whamlet|
        <h1> Meu primeiro site em Haskell!
        <ul>
            <li> <a href=@{AlunoR}>Cadastro de aluno
            <li> <a href=@{ListAluR}>Listagem de aluno
            <li> <a href=@{DiscR}>Cadastro de disciplina
            <li> <a href=@{ListDiscR}>Listagem de disciplina
    |]
    
    
    
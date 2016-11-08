{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
module Handler.Widgets where

import Foundation
import Yesod
-- import Data.Text
-- import Control.Applicative
-- import Database.Persist.Postgresql

-- Header
headerzinho :: Widget
headerzinho = [whamlet|
                <header>
                    <div class="container">
                        <h1>Trabalho de Haskell
              |]

-- Footer
footerzinho :: Widget
footerzinho = [whamlet|
                  <footer>
                      Orgulhosamente desenvolvido em <strong>Haskell</strong>, por Henrique Fernandez, Rosilene Silva e Vitor Pereira.
              |]
              
  
{-            
-- Menu
menuzinho :: Widget
menuzinho = [whamlet|
                <ul>
                    <li> <a href=@{AlunoR}>Cadastro de aluno
                    <li> <a href=@{ListAluR}>Listagem de aluno
                    <li> <a href=@{DiscR}>Cadastro de disciplina
                    <li> <a href=@{ListDiscR}>Listagem de disciplina
                    $maybe _ <- sess
                        <li> 
                            <form action=@{LogoutR} method=post>
                                <input type="submit" value="Logout">
                    $nothing
                        <li> <a href=@{LoginR}>Login
            |]
-}
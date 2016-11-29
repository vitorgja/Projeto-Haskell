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
                      <div>
                        <p>
                            Orgulhosamente desenvolvido em <strong>Haskell</strong>, 
                            por Henrique Fernandez e Vitor Pereira.
              |]
              
  
{--         
-- Menu
menuzinho :: (a) -> Widget
menuzinho (sess) = do
        toWidget[whamlet|
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
--}
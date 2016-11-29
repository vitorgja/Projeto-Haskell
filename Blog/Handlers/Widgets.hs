{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
module Handlers.Widgets where

import Foundation
import Yesod

-- Home Widgets ----------------------------------------------------------------------------------------------------------

menuHome :: Widget
menuHome = do
        toWidget
            [hamlet|

        <div .row>
            <div .medium-12 .columns .menu-centered .top-menu>
                <ul .menu>
                    <li>
                        <a .a-top-menu href=@{HomeR}>Home
                    <li>
                        <a .a-top-menu .a-active href=@{PostsR}>Php
                    <li>
                        <a .a-top-menu href=@{PostsR}>Haskell
                    <li>
                        <a .a-top-menu href=@{PostsR}>Html
                    <li>
                        <a .a-top-menu href=@{PostsR}>Js
                    <li>
                        <a .a-top-menu href=@{PostsR}>Css
                    <li>
                        <a .a-top-menu href=@{ContatoR}>Contato
                
              |]

headerHome :: Widget
headerHome = do
        toWidget
            [hamlet|

        <div .row .header>
            <div .medium-12 .columns>
                <h1> Codemage{Blog} 
                    <i .fi-laptop>
                
              |]


footerHome :: Widget
footerHome = do
        toWidget
            [hamlet|

        <div .row .footer> footer
            <button onClick="ola()"> Click me!
                
              |]
              
-- Admin Widgets --------------------------------------------------------------------------------------------------------


menuAdmin :: Widget
menuAdmin= do
        toWidget
            [hamlet|

        <div .row>
            <div .medium-12 .columns .menu-centered .top-menu>
                <ul .menu>
                    <li>
                        <a .a-top-menu href=@{HomeR}>Home
                    <li>
                        <a .a-top-menu .a-active href=@{PostsR}>Php
                    <li>
                        <a .a-top-menu href=@{PostsR}>Haskell
                    <li>
                        <a .a-top-menu href=@{PostsR}>Html
                    <li>
                        <a .a-top-menu href=@{PostsR}>Js
                    <li>
                        <a .a-top-menu href=@{PostsR}>Css
                    <li>
                        <a .a-top-menu href=@{ContatoR}>Contato
                
              |]

headerAdmin :: Widget
headerAdmin = do
        toWidget
            [hamlet|

        <div .row .header>
            <div .medium-12 .columns>
                <h1> Codemage{Blog} 
                    <i .fi-laptop>
                
              |]


footerAdmin :: Widget
footerAdmin = do
        toWidget
            [hamlet|

        <div .row .footer> footer
            <button onClick="ola()"> Click me!
                
              |]
              
              
------------------------------------------------------------------------------------------------------------------------

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


css :: Widget
css = do
    toWidget [lucius|
            
            h1{
                color: #ffffff;
                text-shadow: 2px 2px #0a0a0a;
                font-family: monospace;
                font-size: 6em;
            }
            
            .row{
                max-width: 80rem !important;
            }
            
            .top-menu{
                padding-top: 0.5em;
                background-color: rgb(19, 19, 19);
                position: fixed;
                max-width: 80rem;
                margin-left: auto;
                margin-right: auto;
                border-bottom: 5px solid #62aaff;
            }
            
            .a-active{
                text-decoration: underline;
                transition: 0.3s;
            }
            
            .a-top-menu{
                color: #ffffff !important;
                font-size: 1.8em;
                font-family: monospace;
            }
            
            .a-top-menu:hover{
                transition: 1s;
                text-decoration: underline;
            }
            
            .a-top-menu:focus{
                background-color: rgba(46, 49, 53, 0.78);
                transition: 0.3s;            
            }
            
            .header{
                margin-top: 3.7em;
                background-color: #62aaff;
                text-align: center;
                padding: 2em;
            }
            
            .conteudo{
                border-top: 5px solid #e0e0e0;
                background-color: #fbfbfb;
                min-height: 10em;
                padding: 1em;
            }
            
            .conteudo-direito{
                border-left: 1px dotted #cacaca;
                min-height: 30em;
            }
            
            .footer{
                background-color: #ececec;
                min-height: 5em;
                padding: 1em;
            }
            
            hr{
                border-bottom: 1px dotted #cacaca;
            }
        |]
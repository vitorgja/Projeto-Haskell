{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE OverloadedStrings, TypeFamilies, QuasiQuotes,
             TemplateHaskell, GADTs, FlexibleContexts,
             MultiParamTypeClasses, DeriveDataTypeable, EmptyDataDecls,
             GeneralizedNewtypeDeriving, ViewPatterns, FlexibleInstances #-}
module Helper.Widgets where

import Foundation
import Yesod

template :: String
template = "default/"

tplString :: String -> String
tplString path = "templates/"++ template ++ path 


-- Home Widgets ----------------------------------------------------------------------------------------------------------

showMenuLink ::  Widget
showMenuLink = do
 
    categorias <- handlerToWidget $ runDB $ selectList [] [Asc CategoriaNome]
    
    toWidget
        [whamlet|
        
            <div .row>
                <div .medium-12 .columns .menu-centered .top-menu>
                    <ul .menu>
                        <li>
                            <a .a-top-menu href=@{HomeR}>Home
            
                        $forall Entity alid categoria <- categorias
                            <li>
                                <a .a-top-menu href=@{CategoriaIdR alid}> #{categoriaNome    categoria}
                        
                        <li>
                            <a .a-top-menu href=@{ContatoR}>Contato
        |]
        
--showAdminMenuLink ::  Widget
showAdminMenuLink sess = do
 
    categorias <- handlerToWidget $ runDB $ selectList [] [Asc CategoriaNome]
    
    toWidget
        [whamlet|
        
            <div .row>
                <div .medium-12 .columns .menu-centered .top-menu>

                    <ul .dropdown .menu data-dropdown-menu="">
                        <li>
                            <a .a-top-menu href=@{HomeR}>Home
                        
                        <li>
                            <a .a-top-menu href="#0">Categoria
                            <ul .menu>
                                <li>
                                    <a .a-top-menu href=@{CategoriaR}>Cadastro
                                <li>
                                    <a .a-top-menu href=@{CategoriaListaR}>Listagem
                            
                        <li>
                            <a .a-top-menu href="#0">Posts
                            <ul .menu>
                                <li>
                                    <a .a-top-menu href=@{PostR}>Cadastro
                                <li>
                                    <a .a-top-menu href=@{PostListaR}>Listagem
                        <li>
                            <a .a-top-menu href="#0">Contato
                            <ul .menu>
                                <li>
                                    <a .a-top-menu href=@{ContatoListaR}>Listagem
                        $maybe _ <- sess
                            <li> 
                                <form action=@{LogoutR} method=post>
                                    <input .a-top-menu type="submit" value="Logout">
                        $nothing
                            <li>
                                <a .a-top-menu href=@{LoginR}>Login

        |]  
        
headerAdminHome :: Widget
headerAdminHome = do
        toWidget
            [hamlet|

        <div .row .header>
            <div .medium-12 .columns>
                <h1>
                    <small>Admin
                    Codemage{Blog} 
                        <i .fi-laptop>
                
              |]
        

 

menuHome :: Widget
menuHome = do
        categorias <- handlerToWidget $ runDB $ selectList [] [Asc CategoriaNome]
        
        
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

        <div .row .footer>
            
            <div .medium-12 .columns>
                <p .text-center>© Copyright - Todos os direitos reservados à 
                    <a href=@{HomeR}>Codemage{Blog} 
                        <i .fi-laptop>
                <h6 .text-center>
                    Henrique Fernandez
                <h6 .text-center>
                    <a href="http://vitorpereira.com.br">
                        Vitor Pereira
                
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
                <h1> Codemage {Blog} 
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

js :: Widget
js = do
    toWidget [julius|
        // $(document).foundation();
    |]

css :: Widget
css = do
    toWidget [lucius|
            .admin .top-menu{
                border-bottom: 5px solid #E67E22;
            }
            .admin .header {
                background-color: #E67E22;
                padding: 0;
            }
            
            h1{
                color: #ffffff;
                text-shadow: 2px 2px #0a0a0a;
                font-family: monospace;
                font-size: 6em;
            }
            footer h6:nth-child(2) {
                margin-bottom: 0;
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
            
            input.a-top-menu{
                border: 0;
                background: none;
                text-decoration: none;
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
            
            .submenu li .a-top-menu{
                color: #000 !important;
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
        
        
        
        
showPostLink :: Entity Post -> Widget
showPostLink (Entity postid post) = do
    usuario <- handlerToWidget $ runDB $ get404 $ postUsuario post
    categoria <- handlerToWidget $ runDB $ get404 $ postCategoria post
    [whamlet|
        
        <h4>
            <a href=@{PostIdR postid}> #{postTitulo post}
                               
        <p>categoria: #{categoriaNome categoria}
        <p>por: #{usuarioNome usuario}
    |]
    
    





head :: Widget
head = do
    toWidget do
        addStylesheetRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.css"
        addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css"
        addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
        addScriptRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.js"
    
        -- addStylesheet $ StaticR css_style_admin_css
        addStylesheet $ StaticR css_style_css
        addScript     $ StaticR js_script_js

headAdmin :: Widget
headAdmin = do
    toWidget do
        addStylesheetRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.css"
        addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css"
        addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
        addScriptRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.js"
    
        addStylesheet $ StaticR css_style_admin_css
        -- addStylesheet $ StaticR css_style_css
        addScript     $ StaticR js_script_js
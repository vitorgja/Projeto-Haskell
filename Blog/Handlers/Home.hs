{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
module Handlers.Home where

import Foundation
--import Yesod.Core

import Yesod
import Data.Text
import Control.Applicative
import Database.Persist.Postgresql

import Handlers.Widgets
import Handlers.Forms

-- Blog ----------------------------------------------------------------------------------------------------------------
pegarCategoriaR :: CategoriaId -> Handler Html
pegarCategoriaR cid = do
    categoria <- runDB $ get404 cid
    defaultLayout $ do
    toWidget [hamlet|
        #{categoriaNome categoria}
    |]

getPostsR :: Handler Html
getPostsR = undefined

getHomeR :: Handler Html
getHomeR = do
    categorias <- runDB $ selectList [] [Asc CategoriaNome]
    defaultLayout $ do
    
        setTitle "Codemage | Blog"
        addStylesheetRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.css"
        addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css"
        addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
        addScriptRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.js"
        
        -- na função toWidgetHead você manda o que você quiser para o head da página
        toWidget [julius|
    
            function ola(){
                alert("ola mundo");
            }
            
        |]
        
        -- Aqui irá o css, sempre para usar o lucius ou cassius tem que chamar a função toWidget
        toWidget $ css
        
        -- toWidget [lucius|
            
        --     h1{
        --         color: #ffffff;
        --         text-shadow: 2px 2px #0a0a0a;
        --         font-family: monospace;
        --         font-size: 6em;
        --     }
            
        --     .row{
        --         max-width: 80rem !important;
        --     }
            
        --     .top-menu{
        --         padding-top: 0.5em;
        --         background-color: rgb(19, 19, 19);
        --         position: fixed;
        --         max-width: 80rem;
        --         margin-left: auto;
        --         margin-right: auto;
        --         border-bottom: 5px solid #62aaff;
        --     }
            
        --     .a-active{
        --         text-decoration: underline;
        --         transition: 0.3s;
        --     }
            
        --     .a-top-menu{
        --         color: #ffffff !important;
        --         font-size: 1.8em;
        --         font-family: monospace;
        --     }
            
        --     .a-top-menu:hover{
        --         transition: 1s;
        --         text-decoration: underline;
        --     }
            
        --     .a-top-menu:focus{
        --         background-color: rgba(46, 49, 53, 0.78);
        --         transition: 0.3s;            
        --     }
            
        --     .header{
        --         margin-top: 3.7em;
        --         background-color: #62aaff;
        --         text-align: center;
        --         padding: 2em;
        --     }
            
        --     .conteudo{
        --         border-top: 5px solid #e0e0e0;
        --         background-color: #fbfbfb;
        --         min-height: 10em;
        --         padding: 1em;
        --     }
            
        --     .conteudo-direito{
        --         border-left: 1px dotted #cacaca;
        --         min-height: 30em;
        --     }
            
        --     .footer{
        --         background-color: #ececec;
        --         min-height: 5em;
        --         padding: 1em;
        --     }
            
        --     hr{
        --         border-bottom: 1px dotted #cacaca;
        --     }
        -- |]
        
        -- Whanlet significa que você vai escrever o html aqui, a estrutura básica do html ja está feita, 
        -- Isso será renderizado dentro do body
        [whamlet|
        
            ^{menuHome}    
            ^{headerHome}
            
            <div .row .conteudo>
                <div .medium-9 .columns>
                    <h3> Ultimos
                        <small> Post's
                    <hr>
                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque blandit at magna non pellentesque. Maecenas at orci at eros maximus semper dapibus eu nisl. Donec dui felis, scelerisque ut mauris quis, vestibulum bibendum neque. Duis consectetur semper lacus id pharetra. Fusce efficitur, ex sed convallis congue, neque massa ultrices neque, vel iaculis felis enim vel nisi. Nam vel justo lectus. Etiam placerat scelerisque sapien ac consequat. Integer sollicitudin nunc ut augue fringilla, vel congue risus posuere. Vivamus lacus nisl, blandit eu blandit et, mattis eget massa. Mauris in sapien orci. Nulla ut scelerisque massa. Nam volutpat euismod lorem, id lobortis tellus pretium vel. Cras porta, ante ut cursus laoreet, metus lacus hendrerit nibh, eu laoreet diam metus ac justo. Morbi volutpat, quam et rutrum eleifend, mauris justo ullamcorper turpis, sed dictum lorem enim a erat. Integer velit magna, maximus quis porttitor id, sollicitudin id felis. Pellentesque gravida, lectus at porta commodo, leo tellus sagittis dolor, sagittis lobortis massa metus ac arcu.
    
                <div .medium-3 .columns .conteudo-direito>
                    <h3> ua
                    <ul>
                        $forall Entity alid categoria <- categorias
                            <li>
                                <i>
                                    <a href=@{CategoriaIdR alid}> #{categoriaNome    categoria} 
                    
            ^{footerHome}
    
        |]
    
    
getPostIdR :: PostId -> Handler Html
getPostIdR postId = do
    post  <- runDB $ get404 postId
    categoria <- runDB $ get404 (postCategoria post)
    
    -- let catId =
    --     optionsPairs $ fmap (\ent -> entityKey ent) categoria
    
    posts <- runDB $ selectList [] [Asc PostTitulo]
    
    --animal <- runDB $ get404 alid 
    --especies <- runDB $ get404 (animalEspecieid animal)
    
    defaultLayout $ do
        setTitle "Codemage | Blog " 
        addStylesheetRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.css"
        addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css"
        addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
        addScriptRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.js"
        
        
        -- na função toWidgetHead você manda o que você quiser para o head da página
        toWidget [julius|
    
            function ola(){
                alert("ola mundo");
            }
            
        |]
        
        -- Aqui irá o css, sempre para usar o lucius ou cassius tem que chamar a função toWidget
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
        
        -- Whanlet significa que você vai escrever o html aqui, a estrutura básica do html ja está feita, 
        -- Isso será renderizado dentro do body
        [whamlet|
        
            ^{menuHome}    
            ^{headerHome}
            
            <div .row .conteudo>
                <div .medium-9 .columns>
                    <h3> Post
                        <small> #{postTitulo post}
                    <hr>
                    <p>#{postDescricao post}
    
                <div .medium-3 .columns .conteudo-direito>
                    <h3> #{categoriaNome categoria}
                        <small> 
                    <ul>
                        $forall Entity alid post <- posts
                            <li>
                                <i>
                                    <a href=@{PostIdR alid}> #{postTitulo    post} 
                                
                
                        <li>
                            <i> 
                                <a href=@{PostsR}> Post 123/123/2006
                        <li>
                            <i> 
                                <a href=@{PostsR}> Post 123/123/2006                    
                        <li>
                            <i> 
                                <a href=@{PostsR}> Post 123/123/2006
                        <li>
                            <i> 
                                <a href=@{PostsR}> Post 123/123/2006
            ^{footerHome}
    
        |]   
-- Categoria -----------------------------------------------------------------------------------------------------------



-- Contatos ------------------------------------------------------------------------------------------------------------

getContatoR :: Handler Html
getContatoR = do
            (widget, enctype) <- generateFormPost formContato
            defaultLayout $ do 
            
            setTitle "Codemage | Blog"
            addStylesheetRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.css"
            addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css"
            addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
            addScriptRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.js"            
            
            -- Aqui irá o css, sempre para usar o lucius ou cassius tem que chamar a função toWidget
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
            [whamlet|
            
                ^{menuHome}    
                ^{headerHome}
                
                <div .row .conteudo>
                    <div .small-9 .small-centered .columns>
                        <h3> Contato
                        <p>
                            * Através do formulário você pode enviar mensagens e sugestões de conteúdo
                        <hr>
                    
                        <form method=post action=@{ContatoR} enctype=#{enctype}>
                            ^{widget}
                            <input type="submit" .button .float-right value="Enviar">
                     
                ^{footerHome}
            
            |]


postContatoR :: Handler Html
postContatoR = do
            (widget, enctype) <- generateFormPost formContato
            ((result, _), _) <- runFormPost formContato
            case result of
                FormSuccess contato -> do
                    alid <- runDB $ insert contato
                    defaultLayout $ do 
            
                    setTitle "Codemage | Blog"
                    addStylesheetRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.css"
                    addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css"
                    addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
                    addScriptRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.js"            
    
                    -- Aqui irá o css, sempre para usar o lucius ou cassius tem que chamar a função toWidget
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
    
                    [whamlet|
                
                        ^{menuHome}    
                        ^{headerHome}
                        <div .row .conteudo>
                            <div .small-9 .small-centered .columns>
                                <p .callout .success >
                                    Mensagem enviada com sucesso !
                        ^{footerHome}
                        
                    |]
                    
                _ -> defaultLayout $ do 
            
                    setTitle "Codemage | Blog"
                    addStylesheetRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.css"
                    addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css"
                    addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
                    addScriptRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.js"            
    
                    -- Aqui irá o css, sempre para usar o lucius ou cassius tem que chamar a função toWidget
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
    
                    [whamlet|
                
                        ^{menuHome}    
                        ^{headerHome}
                        <div .row .conteudo>
                            <div .small-9 .small-centered .columns>
                                <p .callout .alert >
                                    Ocorreu um erro ao enviar a mensagem !
                        ^{footerHome}
                        
                    |]
               
                

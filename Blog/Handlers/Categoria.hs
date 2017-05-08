{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
module Handlers.Categoria where

import Foundation
--import Yesod.Core

import Yesod
import Data.Text
import Control.Applicative
import Database.Persist.Postgresql

import Helper.Widgets


formCategoria :: Form Categoria
formCategoria = renderDivs $ Categoria <$>
    areq textField "Nome" Nothing 





{-
	h   h 	 ooo 	m   m 	eeeee
	h   h 	o   o 	mm mm 	e
	hhhhh 	o   o 	m m m 	eeeee
	h   h 	o   o 	m   m 	e
	h   h 	 ooo 	m   m 	eeeee
-}        



------- DE FORA
{-
productsAndCategories :: GHandler App App [(Categoria)]
productsAndCategories = runDB $ selectList [] [Asc ProductName] >>= mapM (\(Entity kp p) -> do
    categoryProducts <- selectList [PostCategoria ==. kp] []
    return (p, Prelude.map entityVal categoryProducts)) 
                                         
--}
------- DE FORA

vaiGoku (Entity uid _) = uid


pegarCategoriaR :: CategoriaId -> Handler Html
pegarCategoriaR cid = do
    categoria <- runDB $ get404 cid
    
    posts <- runDB $ selectList [ (PostCategoria ==. cid )] [Asc PostTitulo] 
    
    -- >>= mapM (\(Entity kp p) -> do
    --    categoryProducts <- selectList [PostCategoria ==. kp] []
   
    defaultLayout $ do
    
        setTitle "Codemage | Blog - Categoria"

        toWidget $ headSite
        
        
        -- toWidget $ [hamlet|          #{show categoria}       |]
        
        -- toWidget $ $(whamletFile (tplString "home/categoria.hamlet") )
    
    

        
-- Categoria -----------------------------------------------------------------------------------------------------------
-- slugField :: (RenderMessage master FormMessage) => Field sub master Slug
-- slugField = Field
--             { fieldParse = \rawVals -> case rawVals of
--                                   [s] 
--                                       | isEmpty s -> return $ Left "Empty slug forbidden"
--                                       | otherwise -> return $ Right $ Just $ Slug s
--                                   _ -> return $ Left "A value must be provided"
--             , fieldView = \idAttr nameAttr attrs eResult isReq ->
--                           (fieldView textField) idAttr nameAttr attrs (eResult >>= return . unSlug) isReq
--             }

{-
-- SLUG 3
getPostBySlug :: String -> Handler [PostData]
getPostBySlug slug = do
    allPosts <- selectPosts 0
    return $ Prelude.filter ((== slug) . postDataSlug) allPosts
-- SLUG 3

getCategoriaNomeR :: String -> Handler Html
getCategoriaNomeR slug = do

    posts <- getPostBySlug slug
    defaultLayout $ 
        toWidget [hamlet|
            #{show posts}
        |]
-}
getCategoriaNomeR :: String -> Handler Html
getCategoriaNomeR _ = undefined

    -- -- Current Category
    -- categoria <- runDB $ getBy404 $ UniqueSlug slug
    
    -- -- All Category
    -- categorias <- runDB $ selectList [] [Asc CategoriaNome]
    
    -- -- let catId =
    -- --     optionsPairs $ fmap (\ent -> entityKey ent) categoria
    
    -- posts <- runDB $ selectList [ (PostCategoria ==. cid )] [Asc PostTitulo] 
    -- -- posts <- runDB $ selectList [] [Asc PostTitulo]
    
    -- defaultLayout $ do
    --     setTitle "Codemage | Blog " 
    --     addStylesheetRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.css"
    --     addStylesheetRemote "https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css"
    --     addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"
    --     addScriptRemote "https://cdn.jsdelivr.net/foundation/6.2.4/foundation.min.js"
        
    --     toWidget $ css
    --     toWidget $ js
    --     toWidget $ $(whamletFile (tplString "home/categoria.hamlet") )


getCategoriaIdR :: CategoriaId -> Handler Html
getCategoriaIdR cid = do

    -- Current Category
    categoria <- runDB $ get404 cid
    
    -- All Category
    categorias <- runDB $ selectList [] [Asc CategoriaNome]
    
    -- let catId =
    --     optionsPairs $ fmap (\ent -> entityKey ent) categoria
    
    posts <- runDB $ selectList [ (PostCategoria ==. cid )] [Asc PostTitulo] 
    -- posts <- runDB $ selectList [] [Asc PostTitulo]
    
    defaultLayout $ do
        setTitle "Codemage | Blog " 
        toWidget $ headSite
       
        toWidget $ $(whamletFile (tplString "home/categoria.hamlet") )





{-
	 aaa 	dddd 	m   m 	i 	n   n
	a   a 	d   d 	mm mm 	i 	nn  n
	aaaaa 	d   d 	m m m 	i 	n n n
	a   a 	d   d 	m   m 	i 	n  nn
	a   a 	dddd 	m   m 	i 	n   n
-}  




getCategoriaR :: Handler Html
getCategoriaR = do
    (widget,enctype)<- generateFormPost formCategoria
    sess <- lookupSession "_ID"
    
    defaultLayout $ do
        
        setTitle "Codemage | Blog - Admin"
        toWidget $ headAdmin
      
        toWidget $ $(whamletFile (tplString "admin/categoria/categoriaadd.hamlet") )

        
postCategoriaR :: Handler Html
postCategoriaR = do
            ((resultado,_),_) <- runFormPost formCategoria
            case resultado of
                FormSuccess post -> do
                    uid <- runDB $ Database.Persist.Postgresql.insert post
                    defaultLayout $ do 
                        setTitle "Codemage | Blog - Admin"
                        toWidget $ headAdmin
        
                        toWidget [whamlet|
                            <h1>Post cadastrado com sucesso! #{show $ uid}
                        |]
                _ -> redirect HomeR
                    
-- SELECT * FROM aluno ORDER BY nome
getCategoriaListaR :: Handler Html
getCategoriaListaR = do
    sess <- lookupSession "_ID"
    categorias <- runDB $ selectList [] [Asc CategoriaNome]
    defaultLayout $ do 
    
        setTitle "Admin | Blog"
        toWidget $ headAdmin
        
        toWidget $ $(whamletFile (tplString "admin/categoria/categorialista.hamlet") )


postDelCategoriaR :: CategoriaId -> Handler Html
postDelCategoriaR alid = do 
    runDB $ Database.Persist.Postgresql.delete alid
    redirect CategoriaListaR
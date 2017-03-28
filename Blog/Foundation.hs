{-# LANGUAGE OverloadedStrings, TypeFamilies, QuasiQuotes,
             TemplateHaskell, GADTs, FlexibleContexts,
             MultiParamTypeClasses, DeriveDataTypeable, EmptyDataDecls,
             GeneralizedNewtypeDeriving, ViewPatterns, FlexibleInstances #-}
module Foundation where

import Yesod
import Data.Text
import Database.Persist
import Database.Persist.Postgresql


-- import Database.Persist.Sql
    ( ConnectionPool, SqlBackend, runSqlPool)
    

data App = App {connPool :: ConnectionPool }

-- Using a new type for Slug. Simply a wrapper around a text value.
-- newtype Slug = Slug {unSlug :: Text}
--        deriving (Show, Read, Eq, PathPiece, PersistField)

-- Slug
-- http://stackoverflow.com/questions/21347242/creating-a-url-alias-or-making-deep-urls-pretty
-- http://stackoverflow.com/questions/21347242/creating-a-url-alias-or-making-deep-urls-pretty
-- http://stackoverflow.com/questions/21347242/creating-a-url-alias-or-making-deep-urls-pretty
-- http://stackoverflow.com/questions/21347242/creating-a-url-alias-or-making-deep-urls-pretty




-- https://github.com/yesodweb/yesod/wiki/Slugs
-- share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persist|

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Usuario
    nome  Text
    email Text
    senha Text
    deriving Show
Categoria
    nome  Text
    deriving Show
Post
    slug Text
    titulo Text
    descricao Textarea
    usuario UsuarioId
    categoria CategoriaId
   deriving Show 
Contato
    nome Text
    email Text
    assunto Text
    descricao Textarea
    deriving Show

|]


data PostData = PostData
    {   slug        :: String
       ,titulo      :: Text
       ,descricao   :: Textarea
       ,usuario     :: UsuarioId
       ,categoria   :: CategoriaId
    }




mkYesodData "App" $(parseRoutesFile "routes")

type Form x = Html -> MForm Handler (FormResult x, Widget)



instance YesodPersist App where
   type YesodPersistBackend App = SqlBackend
   runDB f = do
       master <- getYesod
       let pool = connPool master
       runSqlPool f pool



instance Yesod App


       
       
       
instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage
       
       
       
       
       
       


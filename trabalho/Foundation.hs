{-# LANGUAGE OverloadedStrings, TypeFamilies, QuasiQuotes,
             TemplateHaskell, GADTs, FlexibleContexts,
             MultiParamTypeClasses, DeriveDataTypeable, EmptyDataDecls,
             GeneralizedNewtypeDeriving, ViewPatterns, FlexibleInstances #-}
module Foundation where

import Yesod
import Data.Text
import Database.Persist.Postgresql
    ( ConnectionPool, SqlBackend, runSqlPool)

data App = App {connPool :: ConnectionPool }

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

mkYesodData "App" $(parseRoutesFile "routes")

type Form a = Html -> MForm Handler (FormResult a, Widget)

--instance Yesod App

instance YesodPersist App where
   type YesodPersistBackend App = SqlBackend
   runDB f = do
       master <- getYesod
       let pool = connPool master
       runSqlPool f pool
       
instance Yesod App where
    authRoute _ = Just LoginR
    
    isAuthorized LoginR _ = return Authorized
    isAuthorized UsuarioR  _ = return Authorized
    isAuthorized HomeR _ = return Authorized
    isAuthorized ContatoR _ = return Authorized
    isAuthorized _ _ = estaAutenticado

estaAutenticado :: Handler AuthResult
estaAutenticado = do
   msu <- lookupSession "_ID"
   case msu of
       Just _ -> return Authorized
       Nothing -> return AuthenticationRequired

instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage
{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
import Foundation
import Application () -- for YesodDispatch instance
import Yesod
import Data.Text
import Control.Monad.Logger (runStdoutLoggingT)
import Database.Persist.Postgresql

conn :: ConnectionString
conn = "dbname=demhjf4a4dd7r host=ec2-54-243-200-110.compute-1.amazonaws.com user=oyakdoepmbyagw password=fVZUDBKb-pLXS0YReLz-gyQHJS port=5432"
-- conn = "dbname=vitor host=localhost user=vitor password=12345 port=5432"


main :: IO ()
main = runStdoutLoggingT $ withPostgresqlPool conn 10 $ \pool -> liftIO $ do 
       runSqlPersistMPool (runMigration migrateAll) pool 
       warp 8080 (App pool)




{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
import Foundation
import Application () -- for YesodDispatch instance
import Yesod
import Control.Monad.Logger (runStdoutLoggingT)
import Database.Persist.Postgresql

connStr :: ConnectionString
connStr = "dbname=dfbq7cgr4p1co host=ec2-23-23-208-32.compute-1.amazonaws.com user=xrusiwinjgaqhu password=uXJ8YZWDr27PxuI7DqBodGku36 port=5432"

main::IO()
main = runStdoutLoggingT $ withPostgresqlPool connStr 10 $ \pool -> liftIO $ do 
       runSqlPersistMPool (runMigration migrateAll) pool 
       warp 8080 (App pool)
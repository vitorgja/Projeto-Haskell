{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Handler.Disciplina where

import Foundation
import Yesod
-- import Data.Text
import Control.Applicative
import Database.Persist.Postgresql

formDisc :: Form Disciplina
formDisc = renderDivs $ Disciplina
    <$> areq textField "Nome da disciplina" Nothing
    <*> areq textField "Sigla"            Nothing

getDiscR :: Handler Html
getDiscR = do
            (widget, enctype) <- generateFormPost formDisc
            defaultLayout [whamlet|
             <form method=post action=@{DiscR} enctype=#{enctype}>
                 ^{widget}
                 <input type="submit" value="Cadastrar">
            |]

postDiscR :: Handler Html
postDiscR = do
            ((result, _), _) <- runFormPost formDisc
            case result of
                FormSuccess disciplina -> do
                    did <- runDB $ insert disciplina
                    defaultLayout [whamlet|
                        Disciplina cadastrada com sucesso #{fromSqlKey did}!
                    |]
                _ -> redirect HomeR

getListDiscR :: Handler Html
getListDiscR = undefined
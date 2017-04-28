{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}

module Helper.Functions where


template :: String
template = "default/"

tplString :: String -> String
tplString path = "templates/"++ template ++ path 

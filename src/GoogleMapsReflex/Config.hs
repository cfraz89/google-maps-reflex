{-# LANGUAGE NoMonomorphismRestriction #-}
module GoogleMapsReflex.Config where

import GoogleMapsReflex.Types
import Reflex
import Data.Default

newtype ApiKey = ApiKey String

data Config = Config {
    _config_mapOptions :: MapOptions,
    _config_markers :: [MarkerOptions]
} deriving (Eq, Ord)

instance Default Config where
    def = Config def []
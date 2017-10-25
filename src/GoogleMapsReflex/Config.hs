{-# LANGUAGE NoMonomorphismRestriction #-}
module GoogleMapsReflex.Config where

import GoogleMapsReflex.Types
import Reflex
import Data.Default

newtype ApiKey = ApiKey String

data Config t = Config {
    _config_mapOptions :: MapOptions,
    _config_markers :: Dynamic t [MarkerOptions]
}

instance Reflex t => Default (Config t) where
    def = Config def (constDyn [])
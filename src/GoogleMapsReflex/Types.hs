{-# LANGUAGE NoMonomorphismRestriction #-}
module GoogleMapsReflex.Types where

import GoogleMapsReflex.JSTypes
import Data.Default
import Language.Javascript.JSaddle.Value
import Reflex

newtype ApiKey = ApiKey String

data Config = Config {
    _config_mapOptions :: MapOptions,
    _config_markers :: [MarkerOptions]
} deriving (Eq, Ord)

instance Default Config where
    def = Config def []

data MapsState e = MapsState {
    _mapsState_mapElement :: e,
    _mapsState_mapVal :: JSVal,
    _mapsState_markers :: [JSVal]
}

type GoogleMaps t e = Dynamic t (Maybe (MapsState e))
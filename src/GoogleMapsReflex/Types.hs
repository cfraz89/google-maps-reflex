{-# LANGUAGE NoMonomorphismRestriction #-}
module GoogleMapsReflex.Types where

import GoogleMapsReflex.JSTypes
import GoogleMapsReflex.Values
import Data.Default
import Language.Javascript.JSaddle.Value
import Reflex
import Data.Map.Strict

newtype ApiKey = ApiKey String

data InfoWindowState = InfoWindowState {
    _infoWindowState_options :: InfoWindowOptions,
    _infoWindowState_open :: Bool
}

data Config k = Config {
    _config_mapOptions :: MapOptions,
    _config_markers :: Map k MarkerOptions,
    _config_infoWindows :: Map k InfoWindowState
}

instance Default (Config k) where
    def = Config def empty empty

data MapsState k e = MapsState {
    _mapsState_mapElement :: e,
    _mapsState_mapVal :: MapVal,
    _mapsState_markers :: Map k MarkerVal,
    _mapsState_infoWindows :: Map k InfoWindowVal
}

type GoogleMaps t k e = Dynamic t (Maybe (MapsState k e))
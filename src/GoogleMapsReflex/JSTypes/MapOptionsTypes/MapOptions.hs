{-# LANGUAGE RecordWildCards #-}

module GoogleMapsReflex.JSTypes.MapOptionsTypes.MapOptions where

import Language.Javascript.JSaddle.Object
import Data.Default
import GoogleMapsReflex.JSTypes.LatLng
import GoogleMapsReflex.JSTypes.MapOptionsTypes.FullscreenControlOptions
import GoogleMapsReflex.JSTypes.MapOptionsTypes.ControlPosition
import GoogleMapsReflex.JSTypes.MapOptionsTypes.GestureHandling
import GoogleMapsReflex.JSTypes.MapOptionsTypes.MapType

data MapOptions = MapOptions {
    _mapOptions_center :: LatLng,
    _mapOptions_zoom :: Double,
    _mapOptions_backgroundColor :: String,
    _mapOptions_clickableIcons :: Bool,
    _mapOptions_disableDefaultUI :: Bool,
    _mapOptions_draggable :: Bool,
    _mapOptions_draggableCursor :: String,
    _mapOptions_draggingCursor :: String,
    _mapOptions_fullscreenControl :: Bool,
    _mapOptions_fullscreenControlOptions :: FullscreenControlOptions,
    _mapOptions_gestureHandling :: GestureHandling,
    _mapOptions_heading :: Double,
    _mapOptions_keyboardShortcuts :: Bool,
    _mapOptions_mapTypeControl :: Bool,
    _mapOptions_mapTypeControlOptions :: MapTypeControlOptions
} deriving (Show, Eq, Ord)

instance MakeObject MapOptions where
    makeObject MapOptions{..} = do
        o <- create
        o <# "center" $ _mapOptions_center
        o <# "zoom" $ _mapOptions_zoom
        o <# "backgroundColor" $ _mapOptions_backgroundColor
        o <# "clickableIcons" $ _mapOptions_clickableIcons
        o <# "disableDefaultUI" $ _mapOptions_disableDefaultUI
        o <# "draggable" $ _mapOptions_draggable
        o <# "draggableCursor" $ _mapOptions_draggableCursor
        o <# "draggingCursor" $ _mapOptions_draggingCursor
        o <# "fullscreenControl" $ _mapOptions_fullscreenControl
        o <# "fullscreenControlOptions" $ makeObject _mapOptions_fullscreenControlOptions
        o <# "gestureHandling" $ _mapOptions_gestureHandling
        o <# "heading" $ _mapOptions_heading
        o <# "keyboardShortcuts" $ _mapOptions_keyboardShortcuts
        o <# "mapTypeControl" $ _mapOptions_mapTypeControl
        o <# "mapTypeControlOptions" $ makeObject _mapOptions_mapTypeControlOptions
        return o

instance Default MapOptions where
    def = MapOptions {
        _mapOptions_center = LatLng 0 0,
        _mapOptions_zoom = 5,
        _mapOptions_backgroundColor = "#fff",
        _mapOptions_clickableIcons = True,
        _mapOptions_disableDefaultUI = False,
        _mapOptions_draggable = True,
        _mapOptions_draggableCursor = "auto",
        _mapOptions_draggingCursor = "auto",
        _mapOptions_fullscreenControl = False,
        _mapOptions_fullscreenControlOptions = FullscreenControlOptions RightTop,
        _mapOptions_gestureHandling = Auto,
        _mapOptions_heading = 0,
        _mapOptions_keyboardShortcuts = True,
        _mapOptions_mapTypeControl = False,
        _mapOptions_mapTypeControlOptions = MapTypeControlOptions {
            _mapTypeControlOptions_mapTypeIds = [],
            _mapTypeControlOptions_position = TopRight,
            _mapTypeControlOptions_style = Default
        }
    }
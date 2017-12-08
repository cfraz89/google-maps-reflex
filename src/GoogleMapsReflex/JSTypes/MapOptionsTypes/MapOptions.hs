{-# LANGUAGE RecordWildCards #-}

module GoogleMapsReflex.JSTypes.MapOptionsTypes.MapOptions where

import Language.Javascript.JSaddle.Object
import Data.Default
import GoogleMapsReflex.JSTypes.LatLng
import GoogleMapsReflex.JSTypes.MapOptionsTypes.FullscreenControlOptions
import GoogleMapsReflex.JSTypes.MapOptionsTypes.ControlPosition
import GoogleMapsReflex.JSTypes.MapOptionsTypes.GestureHandling
import GoogleMapsReflex.JSTypes.MapOptionsTypes.MapType
import GoogleMapsReflex.JSTypes.MapOptionsTypes.PanControlOptions
import GoogleMapsReflex.JSTypes.MapOptionsTypes.RotateControlOptions
import GoogleMapsReflex.JSTypes.MapOptionsTypes.ScaleControl
import GoogleMapsReflex.JSTypes.MapOptionsTypes.ZoomControlOptions

data MapOptions = MapOptions {
    _mapOptions_backgroundColor :: String,
    _mapOptions_center :: LatLng,
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
    _mapOptions_mapTypeControlOptions :: MapTypeControlOptions,
    _mapOptions_mapTypeId :: MapTypeId,
    _mapOptions_maxZoom :: Maybe Int,
    _mapOptions_minZoom :: Maybe Int,
    _mapOptions_noClear :: Bool,
    _mapOptions_panControl :: Bool,
    _mapOptions_panControlOptions :: PanControlOptions,
    _mapOptions_rotateControl :: Bool,
    _mapOptions_rotateControlOptions :: RotateControlOptions,
    _mapOptions_scaleControl :: Bool,
    _mapOptions_scaleControlOptions :: ScaleControlOptions,
    _mapOptions_scrollwheel :: Bool,
    --TODO-- _mapOptions_streetView :: StreetViewPanorama,
    --TODO-- _mapOptions_streetViewControl :: Bool,
    --TODO-- _mapOptions_streetViewControlOptions ::  StreetViewControlOptions,
    --TODO-- _mapOptions_styles :: [MapTypeStyle],
    _mapOptions_tilt :: Int,
    _mapOptions_zoom :: Double,
    _mapOptions_zoomControl :: Bool
}

instance MakeObject MapOptions where
    makeObject MapOptions{..} = do
        o <- create
        o <# "backgroundColor" $ _mapOptions_backgroundColor
        o <# "center" $ _mapOptions_center
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
        o <# "mapTypeId" $ _mapOptions_mapTypeId
        o <# "maxZoom" $ _mapOptions_maxZoom
        o <# "minZoom" $ _mapOptions_minZoom
        o <# "noClear" $ _mapOptions_noClear
        o <# "panControl" $ _mapOptions_panControl
        o <# "panControlOptions" $ makeObject _mapOptions_panControlOptions
        o <# "rotateControl" $ _mapOptions_rotateControl
        o <# "rotateControlOptions" $ makeObject _mapOptions_rotateControlOptions
        o <# "scaleControl" $ _mapOptions_scaleControl
        o <# "scaleControlOptions" $ makeObject _mapOptions_scaleControlOptions
        o <# "scrollwheel" $ _mapOptions_scrollwheel
        --TODO-- o <# "streetView" $ makeObject _mapOptions_streetView
        --TODO-- o <# "streetViewControl" $ _mapOptions_streetViewControl
        --TODO-- o <# "streetViewControlOptions" $ _mapOptions_streetViewControlOptions
        --TODO-- o <# "styles" $ _mapOptions_styles
        o <# "tilt" $ _mapOptions_tilt
        o <# "zoom" $ _mapOptions_zoom
        o <# "zoomControl" $ _mapOptions_zoomControl
        return o

instance Default MapOptions where
    def = MapOptions {
        _mapOptions_backgroundColor = "#fff",
        _mapOptions_center = LatLng 0 0,
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
            _mapTypeControlOptions_style = Default_MapTypeControlStyle
        },
        _mapOptions_mapTypeId = Roadmap,
        _mapOptions_maxZoom = Nothing,
        _mapOptions_minZoom = Nothing,
        _mapOptions_noClear = False,
        _mapOptions_panControl = False,
        _mapOptions_panControlOptions = PanControlOptions {
            _panControlOptions_position = TopLeft
        },
        _mapOptions_rotateControl = False,
        _mapOptions_rotateControlOptions = RotateControlOptions {
            _rotateControlOptions_position = TopLeft
        },
        _mapOptions_scaleControl = False,
        _mapOptions_scaleControlOptions = ScaleControlOptions {
            _scaleControlOptions_style = Default_ScaleControlStyle
        },
        _mapOptions_scrollwheel = True,
        --TODO-- _mapOptions_streetView = ?
        --TODO-- _mapOptions_streetViewControl = False
        --TODO-- _mapOptions_streetViewControlOptions = ?
        --TODO-- _mapOptions_styles = []
        _mapOptions_tilt = 0,
        _mapOptions_zoom = 5,
        _mapOptions_zoomControl = True
    }
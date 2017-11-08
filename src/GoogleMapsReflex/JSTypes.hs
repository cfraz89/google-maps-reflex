module GoogleMapsReflex.JSTypes where
    
import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Value
import Language.Javascript.JSaddle.Types
import Data.Default
import qualified Data.Text as T

gmaps :: JSM JSVal
gmaps = jsg "google" ! "maps"

data LatLng = LatLng { 
    _latLng_lat :: Double,
    _latLng_lng :: Double
 } deriving (Show, Eq, Ord)

instance ToJSVal LatLng where
    toJSVal latLng = new (gmaps ! "LatLng") (_latLng_lat latLng, _latLng_lng latLng)

----

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
    _mapOptions_fullscreenControlOptions :: FullscreenControlOptions
} deriving (Show, Eq, Ord)

instance MakeObject MapOptions where
    makeObject options = do
        optionsVal <- create
        optionsVal <# "center" $ toJSVal (_mapOptions_center options)
        optionsVal <# "zoom" $ val (_mapOptions_zoom options)
        optionsVal <# "backgroundColor" $ val (_mapOptions_backgroundColor options)
        optionsVal <# "clickableIcons" $ val (_mapOptions_clickableIcons options)
        optionsVal <# "disableDefaultUI" $ val (_mapOptions_disableDefaultUI options)
        optionsVal <# "draggable" $ val (_mapOptions_draggable options)
        return optionsVal

instance Default MapOptions where
    def = MapOptions {
        _mapOptions_center = LatLng 0 0,
        _mapOptions_zoom = 20,
        _mapOptions_backgroundColor = "#fff",
        _mapOptions_clickableIcons = True,
        _mapOptions_disableDefaultUI = False,
        _mapOptions_draggable = True,
        _mapOptions_draggableCursor = "auto",
        _mapOptions_draggingCursor = "auto",
        _mapOptions_fullscreenControl = False,
        _mapOptions_fullscreenControlOptions = FullScreenControlOptions RightTop
    }
----

data MarkerOptions = MarkerOptions {
    _markerOptions_position :: LatLng,
    _markerOptions_title :: T.Text
} deriving (Show, Eq, Ord)

instance MakeObject MarkerOptions where
    makeObject options = do
        optionsVal <- create
        optionsVal <# "position" $ val (_markerOptions_position options)
        optionsVal <# "title" $ val (_markerOptions_title options)
        return optionsVal

data FullscreenControlOptions = FullScreenControlOptions {
    _fullscreenControlOptions_position :: ControlPosition
} deriving (Show, Eq, Ord)

data ControlPosition = BottomCenter | BottomLeft | BottomRight | LeftBottom | LeftCenter
    | LeftTop | RightBottom | RightCenter | RightTop | TopCenter | TopLeft | TopRight
    deriving (Show, Eq, Ord)
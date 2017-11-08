module GoogleMapsReflex.JSTypes where
    
import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Value
import Language.Javascript.JSaddle.Types
import Data.Default
import qualified Data.Text as T

googleMapsVal :: JSM JSVal
googleMapsVal = jsg "google" ! "maps"

data LatLng = LatLng { 
    _latLng_lat :: Double,
    _latLng_lng :: Double
 } deriving (Show, Eq, Ord)

instance ToJSVal LatLng where
    toJSVal latLng = do
        maps <- googleMapsVal
        latlngCons <- maps ! "LatLng"
        new latlngCons (val (_latLng_lat latLng), val (_latLng_lng latLng))

----

data MapOptions = MapOptions {
    _mapOptions_center :: LatLng,
    _mapOptions_zoom :: Double
} deriving (Show, Eq, Ord)

instance MakeObject MapOptions where
    makeObject options = do
        optionsVal <- create
        latLng <- toJSVal (_mapOptions_center options)
        optionsVal <# "center" $ latLng
        optionsVal <# "zoom" $ val (_mapOptions_zoom options)
        return optionsVal

instance Default MapOptions where
    def = MapOptions (LatLng 0 0) 1

----

data MarkerOptions = MarkerOptions {
    _markerOptions_position :: LatLng,
    _markerOptions_title :: T.Text
} deriving (Show, Eq, Ord)
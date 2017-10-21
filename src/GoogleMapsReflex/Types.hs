module GoogleMapsReflex.Types where
    
import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Types
import Language.Javascript.JSaddle.String
import Language.Javascript.JSaddle.Value
import Data.Default
import GoogleMapsReflex.Common

data LatLng = LatLng { 
    _latLng_lat :: Double,
    _latLng_lng :: Double
    }

instance ToJSVal LatLng where
    toJSVal latLng = do
        maps <- getMaps
        latlngCons <- maps ! "LatLng"
        new latlngCons (ValNumber (_latLng_lat latLng), ValNumber (_latLng_lng latLng))

data MapOptions = MapOptions {
    _mapOptions_center :: LatLng,
    _mapOptions_zoom :: Double
}

instance MakeObject MapOptions where
    makeObject options = do
        optionsVal <- create
        latLng <- toJSVal (_mapOptions_center options)
        optionsVal <# "center" $ latLng
        optionsVal <# "zoom" $ ValNumber (_mapOptions_zoom options)
        return optionsVal

instance Default MapOptions where
    def = MapOptions (LatLng 0 0) 1
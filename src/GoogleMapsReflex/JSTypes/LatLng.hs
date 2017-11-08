{-# LANGUAGE RecordWildCards #-}

module GoogleMapsReflex.JSTypes.LatLng where
    
import GoogleMapsReflex.Common
import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Value
import Language.Javascript.JSaddle.Types


data LatLng = LatLng { 
    _latLng_lat :: Double,
    _latLng_lng :: Double
 } deriving (Show, Eq, Ord)

instance ToJSVal LatLng where
    toJSVal LatLng{..} = new (gmaps ! "LatLng") (_latLng_lat, _latLng_lng)
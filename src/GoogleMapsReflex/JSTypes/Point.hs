{-# LANGUAGE RecordWildCards #-}

module GoogleMapsReflex.JSTypes.Point where
    
import GoogleMapsReflex.Common
import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Value

data Point = Point { 
    _point_width :: Double,
    _point_height :: Double
 }

instance ToJSVal Point where
    toJSVal Point{..} = new (gmaps ! "Point") (_point_width, _point_height)
{-# LANGUAGE RecordWildCards #-}

module GoogleMapsReflex.JSTypes.Size where
    
import GoogleMapsReflex.Common
import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Value

data Size = Size { 
    _size_width :: Double,
    _size_height :: Double,
    _size_widthUnit :: Maybe String,
    _size_heightUnit :: Maybe String
 } deriving (Show, Eq, Ord)


instance ToJSVal Size where
    toJSVal Size{..} = new (gmaps ! "Size") (_size_width, _size_height, _size_widthUnit, _size_heightUnit)
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE LambdaCase #-}

module GoogleMapsReflex.JSTypes.MapOptionsTypes.MapType(MapTypeControlOptions(..), MapTypeId(..), MapTypeControlStyle(..)) where
    
import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Value
import GoogleMapsReflex.Common
import GoogleMapsReflex.JSTypes.MapOptionsTypes.ControlPosition

data MapTypeControlOptions = MapTypeControlOptions {
    _mapTypeControlOptions_mapTypeIds :: [MapTypeId],
    _mapTypeControlOptions_position :: ControlPosition,
    _mapTypeControlOptions_style :: MapTypeControlStyle 
} deriving (Show, Eq, Ord)

instance MakeObject MapTypeControlOptions where
    makeObject MapTypeControlOptions{..} = do
        o <- create
        o <# "mapTypeIds" $ _mapTypeControlOptions_mapTypeIds
        o <# "position" $ _mapTypeControlOptions_position
        o <# "style" $ _mapTypeControlOptions_style
        return o

data MapTypeId = Hybrid | Roadmap | Satellite | Terrain
    deriving (Show, Eq, Ord)

instance ToJSVal MapTypeId where
    toJSVal typeId = gmaps ! "MapTypeId" ! case typeId of
        Hybrid -> "HYBRID"
        Roadmap -> "ROADMAP"
        Satellite -> "SATELLITE"
        Terrain -> "TERRAIN"

data MapTypeControlStyle = Default_MapTypeControlStyle | DropdownMenu | HorizontalBar
    deriving (Show, Eq, Ord) 

instance ToJSVal MapTypeControlStyle where
    toJSVal style = gmaps ! "MapTypeControlStyle" ! case style of
        Default_MapTypeControlStyle -> "DEFAULT"
        DropdownMenu -> "DROPDOWN_MENU"
        HorizontalBar -> "HORIZONTAL_BAR"
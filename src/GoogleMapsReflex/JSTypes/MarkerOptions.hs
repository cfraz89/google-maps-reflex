{-# LANGUAGE RecordWildCards #-}

module GoogleMapsReflex.JSTypes.MarkerOptions where
    
import Language.Javascript.JSaddle.Object
import Data.Text (Text)

import GoogleMapsReflex.JSTypes.LatLng

data MarkerOptions = MarkerOptions {
    _markerOptions_position :: LatLng,
    _markerOptions_title :: Text
} deriving (Show, Eq, Ord)

instance MakeObject MarkerOptions where
    makeObject MarkerOptions{..} = do
        o <- create
        o <# "position" $ _markerOptions_position
        o <# "title" $ _markerOptions_title
        return o
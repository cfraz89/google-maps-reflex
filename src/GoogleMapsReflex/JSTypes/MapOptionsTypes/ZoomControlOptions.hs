{-# LANGUAGE RecordWildCards #-}

module GoogleMapsReflex.JSTypes.MapOptionsTypes.ZoomControlOptions where
    
import Language.Javascript.JSaddle.Object

import GoogleMapsReflex.JSTypes.MapOptionsTypes.ControlPosition

data ZoomControlOptions = ZoomControlOptions {
    _zoomControlOptions_position :: ControlPosition
}

instance MakeObject ZoomControlOptions where
    makeObject ZoomControlOptions{..} = do
        o <- create
        o <# "position" $ _zoomControlOptions_position
        return o
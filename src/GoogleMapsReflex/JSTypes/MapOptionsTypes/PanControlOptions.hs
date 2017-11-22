{-# LANGUAGE RecordWildCards #-}

module GoogleMapsReflex.JSTypes.MapOptionsTypes.PanControlOptions where
    
import Language.Javascript.JSaddle.Object

import GoogleMapsReflex.JSTypes.MapOptionsTypes.ControlPosition

data PanControlOptions = PanControlOptions {
    _panControlOptions_position :: ControlPosition
} deriving (Show, Eq, Ord)

instance MakeObject PanControlOptions where
    makeObject PanControlOptions{..} = do
        o <- create
        o <# "position" $ _panControlOptions_position
        return o
{-# LANGUAGE RecordWildCards #-}

module GoogleMapsReflex.JSTypes.FullscreenControlOptions where
    
import Language.Javascript.JSaddle.Object
import GoogleMapsReflex.JSTypes.ControlPosition

newtype FullscreenControlOptions = FullscreenControlOptions {
    _fullscreenControlOptions_position :: ControlPosition
} deriving (Show, Eq, Ord)

instance MakeObject FullscreenControlOptions where
    makeObject FullscreenControlOptions{..} = do
        o <- create
        o <# "position" $ _fullscreenControlOptions_position
        return o

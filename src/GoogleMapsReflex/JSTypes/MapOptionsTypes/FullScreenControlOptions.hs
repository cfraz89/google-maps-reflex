{-# LANGUAGE RecordWildCards #-}

module GoogleMapsReflex.JSTypes.MapOptionsTypes.FullscreenControlOptions where
    
import Language.Javascript.JSaddle.Object
import GoogleMapsReflex.JSTypes.MapOptionsTypes.ControlPosition

newtype FullscreenControlOptions = FullscreenControlOptions {
    _fullscreenControlOptions_position :: ControlPosition
}

instance MakeObject FullscreenControlOptions where
    makeObject FullscreenControlOptions{..} = do
        o <- create
        o <# "position" $ _fullscreenControlOptions_position
        return o

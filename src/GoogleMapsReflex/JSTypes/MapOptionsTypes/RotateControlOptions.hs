{-# LANGUAGE RecordWildCards #-}

module GoogleMapsReflex.JSTypes.MapOptionsTypes.RotateControlOptions where
    
import Language.Javascript.JSaddle.Object

import GoogleMapsReflex.JSTypes.MapOptionsTypes.ControlPosition

data RotateControlOptions = RotateControlOptions {
    _rotateControlOptions_position :: ControlPosition
}

instance MakeObject RotateControlOptions where
    makeObject RotateControlOptions{..} = do
        o <- create
        o <# "position" $ _rotateControlOptions_position
        return o
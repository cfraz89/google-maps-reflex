{-# LANGUAGE RecordWildCards #-}

module GoogleMapsReflex.JSTypes.MapOptionsTypes.ScaleControl(ScaleControlOptions(..), ScaleControlStyle(..)) where
    
import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Value
import GoogleMapsReflex.Common

newtype ScaleControlOptions = ScaleControlOptions {
    _scaleControlOptions_style :: ScaleControlStyle
}

instance MakeObject ScaleControlOptions where
    makeObject ScaleControlOptions{..} = do
        o <- create
        o <# "style" $ _scaleControlOptions_style
        return o

data ScaleControlStyle = Default_ScaleControlStyle deriving (Show, Eq, Ord)

instance ToJSVal ScaleControlStyle where
    toJSVal _ = gmaps ! "ScaleControlStyle" ! "DEFAULT"
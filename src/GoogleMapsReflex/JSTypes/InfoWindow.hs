{-# LANGUAGE RecordWildCards #-}

module GoogleMapsReflex.JSTypes.InfoWindow where
    
import qualified JSDOM.Types as JT
import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Value
import qualified Data.Text as T

import GoogleMapsReflex.JSTypes.LatLng
import GoogleMapsReflex.JSTypes.Size

data InfoWindowOptions = InfoWindowOptions {
    _infoWindowOptions_content :: InfoWindowContent,
    _infoWindowOptions_disableAutoPan :: Bool,
    _infoWindowOptions_maxWidth :: Int,
    _infoWindowOptions_pixelOffset :: Size,
    _infoWindowOptions_position :: LatLng,
    _infoWindowOptions_zIndex :: Int
}

instance MakeObject InfoWindowOptions where
    makeObject InfoWindowOptions{..} = do
        o <- create
        o <# "content" $ _infoWindowOptions_content
        o <# "disableAutoPan" $ _infoWindowOptions_disableAutoPan
        o <# "maxWidth" $ _infoWindowOptions_maxWidth
        o <# "pixelOffset" $ _infoWindowOptions_pixelOffset
        o <# "position" $ _infoWindowOptions_position
        o <# "zIndex" $ _infoWindowOptions_zIndex
        return o

data InfoWindowContent = ContentText T.Text | ContentNode JT.Node

instance ToJSVal InfoWindowContent where
    toJSVal (ContentText t) = val t
    toJSVal (ContentNode n) = val n

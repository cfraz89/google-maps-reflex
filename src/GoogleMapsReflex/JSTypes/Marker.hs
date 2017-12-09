{-# LANGUAGE RecordWildCards #-}

module GoogleMapsReflex.JSTypes.Marker where
    
import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Value
import qualified Data.Text as T
import Data.Default

import GoogleMapsReflex.Common
import GoogleMapsReflex.JSTypes.LatLng
import GoogleMapsReflex.JSTypes.Point

data MarkerOptions = MarkerOptions {
    _markerOptions_anchorPoint :: Point,
    _markerOptions_animation :: Maybe Animation,
    _markerOptions_clickable :: Bool,
    _markerOptions_crossOnDrag :: Bool,
    _markerOptions_cursor :: Maybe String,
    _markerOptions_draggable :: Bool,
    _markerOptions_position :: LatLng,
    _markerOptions_title :: T.Text
}

instance MakeObject MarkerOptions where
    makeObject MarkerOptions{..} = do
        o <- create
        o <# "anchorPoint" $ _markerOptions_anchorPoint
        o <# "animation" $ _markerOptions_animation
        o <# "clickable" $ _markerOptions_clickable
        o <# "crossOnDrag" $ _markerOptions_crossOnDrag
        o <# "cursor" $ _markerOptions_cursor
        o <# "draggable" $ _markerOptions_draggable
        o <# "position" $ _markerOptions_position
        o <# "title" $ _markerOptions_title
        return o

data Animation = Bounce | Drop

instance ToJSVal Animation where
    toJSVal animation = gmaps ! "Animation" ! case animation of
        Bounce -> "BOUNCE"
        Drop -> "DROP"

instance Default MarkerOptions where
    def = MarkerOptions {
        _markerOptions_anchorPoint = Point 0 0,
        _markerOptions_animation = Nothing, 
        _markerOptions_clickable = True,
        _markerOptions_crossOnDrag = True,
        _markerOptions_cursor = Nothing,
        _markerOptions_draggable = False,
        _markerOptions_position = LatLng 0 0,
        _markerOptions_title = T.pack ""
    }
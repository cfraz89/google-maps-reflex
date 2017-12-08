module GoogleMapsReflex.JSTypes.MapOptionsTypes.ControlPosition where
    
import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Value

import GoogleMapsReflex.Common

data ControlPosition = BottomCenter | BottomLeft | BottomRight | LeftBottom | LeftCenter
    | LeftTop | RightBottom | RightCenter | RightTop | TopCenter | TopLeft | TopRight

instance ToJSVal ControlPosition where
    toJSVal cp = gmaps ! "ControlPosition" ! case cp of
        BottomCenter -> "BOTTOM_CENTER"
        BottomLeft -> "BOTTOM_LEFT"
        BottomRight -> "BOTTOM_RIGHT"
        LeftBottom -> "LEFT_BOTTOM"
        LeftCenter -> "LEFT_CENTER"
        LeftTop -> "LEFT_TOP"
        RightBottom -> "RIGHT_BOTTOM"
        RightCenter -> "RIGHT_CENTER"
        RightTop -> "RIGHT_TOP"
        TopCenter -> "TOP_CENTER"
        TopLeft -> "TOP_LEFT"
        TopRight -> "TOP_RIGHT"


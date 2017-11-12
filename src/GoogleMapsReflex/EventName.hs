{-# LANGUAGE OverloadedStrings #-}

module GoogleMapsReflex.EventName where
    
import Data.Text
import Language.Javascript.JSaddle.Value

data EventName = Click | MouseMove

eventNameText :: EventName -> Text 
eventNameText Click = "click"
eventNameText MouseMove = "mousemove"

instance ToJSVal EventName where
    toJSVal e = val $ eventNameText e
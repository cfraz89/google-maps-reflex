{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE LambdaCase #-}

module GoogleMapsReflex.MapsEvent(mapsEvent, MapsEvent(..)) where
    
import Data.Text
import Language.Javascript.JSaddle.Value
import Language.Javascript.JSaddle.Types
import Reflex.Dom hiding(Click)
import GoogleMapsReflex.MapsApi
import GoogleMapsReflex.Types
import GoogleMapsReflex.Widget
import Control.Monad
data MapsEvent = Click | MouseMove

mapsEventText :: MapsEvent -> Text 
mapsEventText = \case
    Click -> "click"
    MouseMove -> "mousemove"

instance ToJSVal MapsEvent where
    toJSVal e = val $ mapsEventText e

mapsEvent :: (TriggerEvent t m, PerformEvent t m, MonadJSM (Performable m)) => MapsEvent -> GoogleMaps t e -> (MapsState e -> JSVal) -> m (Event t JSVal)
mapsEvent me maps sel = performEventAsync $ withGoogleMaps maps (\m -> void . addListener (mapsEventText me) (sel m))
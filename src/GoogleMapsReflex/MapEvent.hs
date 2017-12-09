{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE LambdaCase #-}

module GoogleMapsReflex.MapEvent(mapEvent, MapEvent(..)) where
    
import Data.Text
import Language.Javascript.JSaddle.Value
import Language.Javascript.JSaddle.Types
import Reflex.Dom hiding(Click)
import GoogleMapsReflex.MapsApi
import GoogleMapsReflex.Types
import GoogleMapsReflex.Widget
import GoogleMapsReflex.Values
import Control.Monad

data MapEvent = Click | MouseMove

mapEventText :: MapEvent -> Text 
mapEventText = \case
    Click -> "click"
    MouseMove -> "mousemove"

instance ToJSVal MapEvent where
    toJSVal = val . mapEventText

mapEvent :: (TriggerEvent t m, PerformEvent t m, MonadJSM (Performable m)) => MapEvent -> GoogleMaps t k e -> m (Event t JSVal)
mapEvent me maps = performEventAsync $ withGoogleMaps maps pAddListener
    where pAddListener mapsState = void . addListener (mapEventText me) (unVal . _mapsState_mapVal $ mapsState)
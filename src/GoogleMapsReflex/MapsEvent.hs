{-# LANGUAGE OverloadedStrings #-}

module GoogleMapsReflex.MapsEvent where
    
import Data.Text
import Language.Javascript.JSaddle.Value
import Reflex.Dom hiding(Click)
import GoogleMapsReflex.MapsApi
import GoogleMapsReflex.Types

data MapsEvent = Click | MouseMove

mapsEventText :: MapsEvent -> Text 
mapsEventText Click = "click"
mapsEventText MouseMove = "mousemove"

instance ToJSVal MapsEvent where
    toJSVal e = val $ mapsEventText e

mapsEvent :: (MonadWidget t m) => MapsEvent -> GoogleMaps t e -> m (Event t JSVal)
mapsEvent eventType (GoogleMaps state) = performAddListener (mapsEventText eventType) mapEvent
    where mapEvent = push (\s -> return (_mapsState_mapVal s)) (updated state)
          performAddListener :: (MonadWidget t m) => Text -> Event t JSVal -> m (Event t JSVal)
          performAddListener eventName mapEvent = performEventAsync (unReturn <$> (addListener eventName <$> mapEvent))
          unReturn :: (Monad m) => (a -> m v) -> a -> m () --Until i can figure out what to do with the listener ref
          unReturn f a = f a >> return ()
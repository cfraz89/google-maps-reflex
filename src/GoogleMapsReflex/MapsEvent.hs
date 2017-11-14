{-# LANGUAGE OverloadedStrings #-}

module GoogleMapsReflex.MapsEvent(mapsEvent, addListenerEvent, MapsEvent(..)) where
    
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

mapsEvent :: (MonadWidget t m) => MapsEvent -> GoogleMaps t e -> (MapsState e -> Maybe JSVal) -> m (Event t JSVal)
mapsEvent eventType (GoogleMaps state) selector = addListenerEvent eventType mapEvent
    where mapEvent = push (\s -> return (selector s)) (updated state)

addListenerEvent :: (MonadWidget t m) => MapsEvent -> Event t JSVal -> m (Event t JSVal)
addListenerEvent eventType mapEvent = performEventAsync (unReturn <$> (addListener eventName <$> mapEvent))
    where unReturn :: (Monad m) => (a -> m v) -> a -> m () --Until i can figure out what to do with the listener ref
          unReturn f a = f a >> return ()
          eventName = mapsEventText eventType
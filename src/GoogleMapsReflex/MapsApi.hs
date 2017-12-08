{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
module GoogleMapsReflex.MapsApi where

import GoogleMapsReflex.JSTypes
import GoogleMapsReflex.Common
import GoogleMapsReflex.Values

import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Types
import Language.Javascript.JSaddle.Value
import qualified JSDOM.Types as JDT
import qualified Data.Text as T
import Control.Monad.IO.Class

createMap :: JDT.ToJSVal e => e -> MapOptions -> JSM MapVal
createMap mapEl mapOptions = MapVal <$> new (gmaps ! "Map") (mapEl, makeObject mapOptions)

createMarker :: MapVal -> MarkerOptions -> JSM MarkerVal
createMarker (MapVal mapVal) options = do
    optionsVal <- makeObject options
    optionsVal <# "map" $ mapVal
    MarkerVal <$> new (gmaps ! "Marker") (val optionsVal)

setOptions :: MapVal -> MapOptions -> JSM ()
setOptions (MapVal mapVal) mapOptions = () <$ (mapVal # "setOptions" $ val (makeObject mapOptions) )

addListener :: (MonadJSM m) => T.Text -> JSVal -> (JSVal -> IO ()) -> m EventListenerVal
addListener eventName listenee cb = liftJSM $ do
    listener <- asyncFunction $ \ _ _ args -> liftIO $ cb (head args)
    EventListenerVal <$> (gmaps ! "event" # "addListener" $ [val listenee, val eventName, val listener])

close :: InfoWindowVal -> JSM ()
close (InfoWindowVal infoWindow) = () <$ (infoWindow # "close" $ ())
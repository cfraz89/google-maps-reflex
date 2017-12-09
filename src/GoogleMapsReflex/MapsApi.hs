{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE TypeFamilies #-}

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

class (ValueWrapped v, MakeObject (Options v)) => SetOptions v where
    type Options v :: *
    setOptions :: v -> Options v -> JSM ()
    setOptions v options = () <$ (unVal v # "setOptions" $ val (makeObject options) )

instance SetOptions MapVal where type Options MapVal = MapOptions
instance SetOptions InfoWindowVal where type Options InfoWindowVal = InfoWindowOptions

addListener :: (MonadJSM m) => T.Text -> JSVal -> (JSVal -> IO ()) -> m EventListenerVal
addListener eventName listenee cb = liftJSM $ do
    listener <- asyncFunction $ \ _ _ args -> liftIO $ cb (head args)
    EventListenerVal <$> (gmaps ! "event" # "addListener" $ [val listenee, val eventName, val listener])

createInfoWindow :: InfoWindowOptions -> JSM InfoWindowVal
createInfoWindow options = do
    optionsVal <- makeObject options
    InfoWindowVal <$> new (gmaps ! "InfoWindow") (val optionsVal)

open ::  MapVal -> InfoWindowVal -> JSM ()
open (MapVal map) (InfoWindowVal infoWindow) = () <$ (infoWindow # "open" $ (map))

close :: InfoWindowVal -> JSM ()
close (InfoWindowVal infoWindow) = () <$ (infoWindow # "close" $ ())
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
module GoogleMapsReflex.MapsApi where

import GoogleMapsReflex.JSTypes
import GoogleMapsReflex.Common

import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Types
import Language.Javascript.JSaddle.Value
import qualified JSDOM.Types as JDT
import Reflex.Dom hiding (EventName)
import GHCJS.DOM.EventM
import qualified JSDOM.EventTargetClosures as ETC
import qualified GHCJS.DOM.Types as GDT

createMap :: JDT.Element -> MapOptions -> JSM JSVal
createMap mapEl mapOptions = new (gmaps ! "Map") (mapEl, makeObject mapOptions)

createMarker :: JSVal -> MarkerOptions -> JSM JSVal
createMarker mapVal options = do
    optionsVal <- makeObject options
    optionsVal <# "map" $ mapVal
    new (gmaps ! "Marker") (val optionsVal)


setOptions :: JSVal -> MapOptions -> JSM JSVal
setOptions mapVal mapOptions = mapVal # "setOptions" $ val (makeObject mapOptions) 

mapValClick :: (PostBuild t m, MonadJSM m, TriggerEvent t m, PerformEvent t m) => JSVal -> m (Event t ())
mapValClick mapVal = wrapDomEvent (GDT.EventTarget mapVal) (\e eventM -> on e click eventM) (return ())
    where click :: JDT.IsEventTarget t => ETC.EventName t GDT.Event
          click = ETC.EventName $ JDT.toJSString "click"
module GoogleMapsReflex.GoogleMaps where

import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Types
import Language.Javascript.JSaddle.String
import Language.Javascript.JSaddle.Value
import Control.Monad.IO.Class
import JSDOM
import JSDOM.Generated.Document (createElement, getBodyUnchecked)
import JSDOM.Generated.NonElementParentNode (getElementByIdUnchecked)
import JSDOM.Generated.Element (setAttribute)
import JSDOM.Generated.Node (appendChild)
import JSDOM.Types hiding (Function, Event)
import Data.Default
import Data.Functor

import Reflex.Dom.Core

data LatLng = LatLng { 
    _latLng_lat :: Double,
    _latLng_lng :: Double
    }

instance ToJSVal LatLng where
    toJSVal latLng = do
        maps <- getMaps
        latlngCons <- maps ! "LatLng"
        new latlngCons (ValNumber (_latLng_lat latLng), ValNumber (_latLng_lng latLng))

data MapOptions = MapOptions {
    _mapOptions_center :: LatLng,
    _mapOptions_zoom :: Double
}

instance MakeObject MapOptions where
    makeObject options = do
        optionsVal <- create
        latLng <- toJSVal (_mapOptions_center options)
        optionsVal <# "center" $ latLng
        optionsVal <# "zoom" $ ValNumber (_mapOptions_zoom options)
        return optionsVal

instance Default MapOptions where
    def = MapOptions (LatLng 0 0) 1

 --Map a trigger event to an event for when maps is ready
loadMaps :: (MonadWidget t m) => Event t () -> m (Event t ())
loadMaps event = performEventAsync (event $> insertMapsHandler)

--Insert mapsLoaded global function which will fire event trigger when maps script loaded, or immediately when alerady exists
insertMapsHandler :: (MonadJSM m) => (() -> IO()) -> m ()
insertMapsHandler eventTrigger = liftJSM $ do
    --Check if we've done this before
    mapsLoaded <- getProp (toJSString "mapsLoaded") global
    mapsLoadedUndefined <- valIsUndefined mapsLoaded
    if mapsLoadedUndefined
        then do
            global <# "mapsLoaded" $ loadHandler eventTrigger
            insertMapsScript
        else liftIO $ eventTrigger ()

--Insert the maps script 
insertMapsScript :: (MonadJSM m) => m ()
insertMapsScript = liftJSM $ do
    document <- currentDocumentUnchecked
    scriptNode <- createElement document "script"
    setAttribute scriptNode "src" "https://maps.googleapis.com/maps/api/js?key=AIzaSyAICO6iAKceOhFrLywgs77HnJWwl64frFA&callback=mapsLoaded"
    setAttribute scriptNode "async" "true"
    setAttribute scriptNode "defer" "true"
    body <- getBodyUnchecked document
    appendChild body scriptNode
    return ()

--The actual mapsloaded function - just fire the event
loadHandler :: (() -> IO ()) -> JSM Function
loadHandler eventTrigger = asyncFunction $ \ _ _ _ -> liftIO $ eventTrigger ()

getMaps :: JSM JSVal
getMaps = jsg "google" ! "maps"

-- Maps Functions

createMap :: (MonadJSM m, ToJSVal e) => e -> MapOptions -> m ()
createMap mapEl mapOptions = liftJSM $ do
    mapVal <- toJSVal mapEl
    maps <- getMaps
    options <- makeObject mapOptions
    gMapCons <- maps ! "Map"
    new gMapCons (mapVal, options)
    return ()
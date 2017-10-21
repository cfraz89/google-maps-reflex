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
import GoogleMapsReflex.Common
import GoogleMapsReflex.Types

--Map a trigger event to an event for when maps is ready
loadMaps :: (MonadWidget t m) => String -> Event t () -> m (Event t ())
loadMaps mapsKey event = performEventAsync (event $> insertMapsHandler mapsKey)

--Insert mapsLoaded global function which will fire event trigger when maps script loaded, or immediately when alerady exists
insertMapsHandler :: (MonadJSM m) => String -> (() -> IO()) -> m ()
insertMapsHandler mapsKey eventTrigger = liftJSM $ do
    --Check if we've done this before
    mapsLoaded <- getProp (toJSString "mapsLoaded") global
    mapsLoadedUndefined <- valIsUndefined mapsLoaded
    if mapsLoadedUndefined
        then do
            global <# "mapsLoaded" $ loadHandler eventTrigger
            insertMapsScript mapsKey
        else liftIO $ eventTrigger ()

--Insert the maps script 
insertMapsScript :: (MonadJSM m) => String -> m ()
insertMapsScript mapsKey = liftJSM $ do
    document <- currentDocumentUnchecked
    scriptNode <- createElement document "script"
    setAttribute scriptNode "src" $ "https://maps.googleapis.com/maps/api/js?key=" ++ mapsKey ++ "&callback=mapsLoaded"
    setAttribute scriptNode "async" "true"
    setAttribute scriptNode "defer" "true"
    body <- getBodyUnchecked document
    appendChild body scriptNode
    return ()

--The actual mapsloaded function - just fire the event
loadHandler :: (() -> IO ()) -> JSM Function
loadHandler eventTrigger = asyncFunction $ \ _ _ _ -> liftIO $ eventTrigger ()

-- Maps Functions

createMap :: (MonadJSM m, ToJSVal e) => e -> MapOptions -> m ()
createMap mapEl mapOptions = liftJSM $ do
    mapVal <- toJSVal mapEl
    maps <- getMaps
    options <- makeObject mapOptions
    gMapCons <- maps ! "Map"
    new gMapCons (mapVal, options)
    return ()
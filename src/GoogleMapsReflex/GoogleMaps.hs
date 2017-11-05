{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE RecursiveDo #-}

module GoogleMapsReflex.GoogleMaps where

import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Types
import Language.Javascript.JSaddle.String
import Language.Javascript.JSaddle.Value
import Control.Monad.IO.Class
import Control.Monad
import JSDOM
import JSDOM.Generated.Document (createElement, getBodyUnchecked)
import JSDOM.Generated.NonElementParentNode (getElementByIdUnchecked)
import JSDOM.Generated.Element (setAttribute)
import JSDOM.Generated.Node (appendChild)
import JSDOM.Types hiding (Function, Event)
import Data.Default
import Data.Functor
import Control.Monad.Fix
import qualified Data.Dependent.Map as DM
import qualified Data.Text as T

import Reflex.Dom.Core
import GoogleMapsReflex.Common
import GoogleMapsReflex.Types
import GoogleMapsReflex.Config

--Map a trigger event to an event for when maps is ready
loadMaps :: (MonadWidget t m) => ApiKey -> Event t () -> m (Event t ())
loadMaps mapsKey event = performEventAsync (event $> insertMapsHandler mapsKey)

--Insert mapsLoaded global function which will fire event trigger when maps script loaded, or immediately when alerady exists
insertMapsHandler :: MonadJSM m => ApiKey -> (() -> IO()) -> m ()
insertMapsHandler mapsKey eventTrigger = liftJSM $ do
    --Check if we've done this before
    mapsLoaded <- getProp (toJSString "mapsLoaded") global
    mapsLoadedUndefined <- valIsUndefined mapsLoaded
    if mapsLoadedUndefined
        then do
            lh <- loadHandler eventTrigger
            global <# "mapsLoaded" $ lh
            insertMapsScript mapsKey
        else liftIO $ eventTrigger ()

--Insert the maps script 
insertMapsScript :: (MonadJSM m) => ApiKey -> m ()
insertMapsScript (ApiKey mapsKey) = liftJSM $ do
    document <- currentDocumentUnchecked
    scriptNode <- createElement document "script"
    setAttribute scriptNode "src" $ "https://maps.googleapis.com/maps/api/js?key=" ++ mapsKey ++ "&callback=mapsLoaded"
    setAttribute scriptNode "async" "true"
    setAttribute scriptNode "defer" "true"
    body <- getBodyUnchecked document
    appendChild body scriptNode
    return ()

--The actual mapsloaded function - just fire the event
loadHandler :: MonadJSM m => (() -> IO ()) -> m Function
loadHandler eventTrigger = liftJSM $ asyncFunction fireEvent
    where fireEvent _ _ _ = liftIO $ eventTrigger ()

data MapsState = MapsState {
    _mapsState_mapVal :: Maybe JSVal,
    _mapsState_markers ::[JSVal]
}

-- Maps Functions
type  Mapsable t m = (MonadJSM m, MonadJSM (Performable m), PerformEvent t m, Reflex t, DomBuilder t m, MonadHold t m, MonadIO (Performable m))

makeMapManaged :: (Mapsable t m, ToJSVal e, MonadFix m) => e -> Event t Config -> m (Event t MapsState)
makeMapManaged mapEl config = mdo
    mapsStateEvent <- performEvent $ attachWith (\s c -> updateMapState mapEl c s) (current mapsStateDyn) config
    mapsStateDyn <- holdDyn (MapsState Nothing []) mapsStateEvent
    return mapsStateEvent

updateMapState :: (MonadJSM m, ToJSVal e) => e -> Config -> MapsState -> m MapsState
updateMapState mapEl config (MapsState mapVal markers) = liftJSM $ do 
        mapVal <- valForState mapVal
        markers <- manageMarkers mapVal (_config_markers config) markers
        return $ MapsState (Just mapVal) markers
    where
        valForState Nothing = createMap mapEl config
        valForState (Just val) = return val

createMap :: (ToJSVal e) => e -> Config -> JSM JSVal
createMap mapEl config = do
    mapVal <- toJSVal mapEl
    maps <- getMaps
    options <- makeObject $ _config_mapOptions config
    gMapCons <- maps ! "Map"
    new gMapCons (mapVal, options)

manageMarkers :: JSVal -> [MarkerOptions] -> [JSVal] -> JSM [JSVal]
manageMarkers mapVal markers existing = do
    forM existing $ \m -> m # "setMap" $ [JSNull]
    maps <- getMaps
    markerCons <- maps ! "Marker"
    liftIO $ putStrLn $ "Adding markers" ++ (show markers)
    forM markers $ \options -> do
        optionsVal <- create
        position <- toJSVal (_markerOptions_position options)
        optionsVal <# "position" $ position
        optionsVal <# "title" $ ValString (_markerOptions_title options)
        optionsVal <# "map" $ mapVal
        liftIO $ putStrLn "Added a marker"
        new markerCons (ValObject optionsVal)
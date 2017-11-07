{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE RecursiveDo #-}

module GoogleMapsReflex.GoogleMaps where

import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Types
import Language.Javascript.JSaddle.Value
import Control.Monad.IO.Class
import Control.Monad

import Control.Monad.Fix

import Reflex.Dom.Core
import GoogleMapsReflex.JSTypes
import GoogleMapsReflex.Config
import GoogleMapsReflex.MapsApi

data MapsState = MapsState {
    _mapsState_mapVal :: Maybe JSVal,
    _mapsState_markers ::[JSVal]
}

-- Maps Functions
type  Mapsable t m = (MonadJSM m, MonadJSM (Performable m), PerformEvent t m, Reflex t, DomBuilder t m, MonadHold t m, MonadIO (Performable m))

makeMapManaged :: (Mapsable t m, ToJSVal e, MonadFix m) => e -> Event t Config -> m (Event t MapsState)
makeMapManaged mapEl config = mdo
    mapsStateEvent <- performEvent $ attachWith (flip $ updateMapState mapEl) mapsStateBehavior config
    mapsStateBehavior <- hold (MapsState Nothing []) mapsStateEvent
    return mapsStateEvent

updateMapState :: (MonadJSM m, ToJSVal e) => e -> Config -> MapsState -> m MapsState
updateMapState mapEl config (MapsState mapVal markers) = liftJSM $ do 
        mapVal <- valForState mapVal
        markers <- manageMarkers mapVal (_config_markers config) markers
        return $ MapsState (Just mapVal) markers
    where
        valForState Nothing = createMap mapEl (_config_mapOptions config)
        valForState (Just val) = return val

manageMarkers :: JSVal -> [MarkerOptions] -> [JSVal] -> JSM [JSVal]
manageMarkers mapVal markers existing = do
    forM_ existing $ \m -> m # "setMap" $ [JSNull]
    maps <- googleMaps
    markerCons <- maps ! "Marker"
    liftIO $ putStrLn $ "Adding markers" ++ show markers
    forM markers $ \options -> do
        optionsVal <- create
        position <- toJSVal (_markerOptions_position options)
        optionsVal <# "position" $ position
        optionsVal <# "title" $ ValString (_markerOptions_title options)
        optionsVal <# "map" $ mapVal
        liftIO $ putStrLn "Added a marker"
        new markerCons (ValObject optionsVal)
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

import qualified JSDOM.Types as JDT

data MapsState = MapsState {
    _mapsState_mapVal :: Maybe JSVal,
    _mapsState_markers ::[JSVal]
}

type  Mapsable t m = (
    MonadJSM m,
    MonadJSM (Performable m),
    PerformEvent t m,
    Reflex t,
    DomBuilder t m,
    MonadHold t m,
    MonadIO (Performable m),
    MonadFix m
   )

-- Maps Functions
makeMapManaged :: Mapsable t m => JDT.Element -> Event t Config -> m (Event t MapsState)
makeMapManaged mapEl config = mdo
    mapsStateEvent <- performEvent $ attachWith (flip $ updateMapState mapEl) mapsStateBehavior config
    mapsStateBehavior <- hold (MapsState Nothing []) mapsStateEvent
    return mapsStateEvent

updateMapState :: MonadJSM m => JDT.Element -> Config -> MapsState -> m MapsState
updateMapState mapEl config (MapsState mapVal markers) = liftJSM $ do 
        newMapVal <- valForState mapVal
        newMarkers <- manageMarkers newMapVal (_config_markers config) markers
        return $ MapsState (Just newMapVal) newMarkers
    where
        valForState Nothing = createMap mapEl (_config_mapOptions config)
        valForState (Just v) = setOptions v (_config_mapOptions config) >> return v

manageMarkers :: JSVal -> [MarkerOptions] -> [JSVal] -> JSM [JSVal]
manageMarkers mapVal markers existing = do
    forM_ existing $ \m -> m # "setMap" $ [JSNull]
    forM markers $ createMarker mapVal
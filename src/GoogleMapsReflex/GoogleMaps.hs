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
import GoogleMapsReflex.Types
import GoogleMapsReflex.MapsApi
import GoogleMapsReflex.MapsEvent
import Data.Functor
import Data.Maybe
import Data.Text

import qualified JSDOM.Types as JDT
import Language.Javascript.JSaddle.Marshal.String

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
makeMapManaged :: (Mapsable t m, JDT.ToJSVal e) => e -> Event t Config -> m (GoogleMaps t e)
makeMapManaged mapEl config = mdo
    let blankState = MapsState mapEl Nothing []
    mapsStateEvent <- performEvent $ attachPromptlyDynWith updateMapState mapsStateDyn config
    mapsStateDyn <- holdDyn blankState mapsStateEvent
    return $ GoogleMaps mapsStateDyn

updateMapState :: (MonadJSM m, JDT.ToJSVal e) => MapsState e -> Config -> m (MapsState e)
updateMapState (MapsState mapEl mapVal markers) config = liftJSM $ do 
        newMapVal <- valForState mapVal
        newMarkers <- manageMarkers newMapVal (_config_markers config) markers
        return $ MapsState mapEl (Just newMapVal) newMarkers
    where
        valForState Nothing = createMap mapEl (_config_mapOptions config)
        valForState (Just v) = setOptions v (_config_mapOptions config) >> return v

manageMarkers :: JSVal -> [MarkerOptions] -> [JSVal] -> JSM [JSVal]
manageMarkers mapVal markers existing = do
    forM_ existing $ \m -> m # "setMap" $ [JSNull]
    forM markers $ createMarker mapVal


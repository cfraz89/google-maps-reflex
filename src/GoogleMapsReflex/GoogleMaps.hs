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
import GoogleMapsReflex.Values

import qualified JSDOM.Types as JDT

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
    mapsStateEvent <- performEvent $ attachPromptlyDynWithMaybe (updateMapState mapEl) mapsStateDyn config
    mapsStateDyn <- holdDyn Nothing (Just <$> mapsStateEvent)
    return mapsStateDyn

updateMapState :: (MonadJSM m, JDT.ToJSVal e) => e -> Maybe (MapsState e) -> Config -> Maybe (m (MapsState e))
updateMapState mapEl mapsState config = Just $ liftJSM $ do 
        newMapVal <- mapVal mapsState
        newMarkers <- manageMarkers newMapVal (_config_markers config) markers
        return $ MapsState mapEl newMapVal newMarkers
    where
        mapVal Nothing = createMap mapEl (_config_mapOptions config)
        mapVal (Just m) = let v = _mapsState_mapVal m in setOptions v (_config_mapOptions config) >> return v
        markers = maybe [] _mapsState_markers mapsState

manageMarkers :: MapVal -> [MarkerOptions] -> [MarkerVal] -> JSM [MarkerVal]
manageMarkers mapVal markers existing = do
    forM_ existing $ \(MarkerVal m) -> m # "setMap" $ [JSNull]
    forM markers $ createMarker mapVal


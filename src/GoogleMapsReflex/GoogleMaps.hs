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
import Data.Map.Strict
import qualified Data.Map.Strict as M

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
makeMapManaged :: (Mapsable t m, JDT.ToJSVal e, Ord k) => e -> Event t (Config k) -> m (GoogleMaps t k e)
makeMapManaged mapEl config = mdo
    mapsStateEvent <- performEvent $ attachPromptlyDynWithMaybe (updateMapState mapEl) mapsStateDyn config
    mapsStateDyn <- holdDyn Nothing (Just <$> mapsStateEvent)
    return mapsStateDyn

updateMapState :: (MonadJSM m, JDT.ToJSVal e, Ord k) => e -> Maybe (MapsState k e) -> Config k -> Maybe (m (MapsState k e))
updateMapState mapEl mapsState config = Just $ liftJSM $ do 
    mapVal' <- makeOrUpdateMap mapsState
    markers' <- manageMarkers mapVal' (_config_markers config) markerVals
    infoWindows' <- manageInfoWindows mapVal' (_config_infoWindows config) infoWindowVals
    return $ MapsState mapEl mapVal' markers' infoWindows'
    where
        makeOrUpdateMap Nothing = createMap mapEl (_config_mapOptions config)
        makeOrUpdateMap (Just m) = let v = _mapsState_mapVal m in setOptions v (_config_mapOptions config) >> return v
        markerVals = maybe empty _mapsState_markers mapsState
        infoWindowVals = maybe empty _mapsState_infoWindows mapsState

manageMarkers :: MapVal -> Map k MarkerOptions -> Map k MarkerVal -> JSM (Map k MarkerVal)
manageMarkers mapVal markers existing = do
    forM_ existing $ \(MarkerVal m) -> m # "setMap" $ (JSNull)
    forM markers $ createMarker mapVal

manageInfoWindows :: Ord k => MapVal -> Map k InfoWindowState -> Map k InfoWindowVal -> JSM (Map k InfoWindowVal)
manageInfoWindows mapVal states vals = do
    forM_ (vals `M.difference` states) close
    forM_ (intersectionWith (,) states vals) $ \((InfoWindowState options stateOpen), val) -> do
        update stateOpen val
        setOptions val options
    newVals <- forM (states `M.difference` vals) makeWindows
    return $ newVals `union` (vals `intersection` states)
    where
        makeWindows (InfoWindowState options stateOpen) = do
            infoWindow <- createInfoWindow options
            update stateOpen infoWindow
            return infoWindow
        update True = open mapVal
        update False = close


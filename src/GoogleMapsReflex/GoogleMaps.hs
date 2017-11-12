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
import qualified GoogleMapsReflex.EventName as E
import Data.Functor
import Data.Maybe
import Data.Text

import qualified JSDOM.Types as JDT
import Language.Javascript.JSaddle.Marshal.String

data MapsState e = MapsState {
    _mapsState_mapElement :: e,
    _mapsState_mapVal :: Maybe JSVal,
    _mapsState_markers :: [JSVal]
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

newtype GoogleMaps t e = GoogleMaps (Dynamic t (MapsState e))

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

mapEvent :: (MonadWidget t m) => E.EventName -> GoogleMaps t e -> m (Event t JSVal)
mapEvent eventName (GoogleMaps state) = performAddListener (E.eventNameText eventName) mapEvent
    where mapEvent = push (\s -> return (_mapsState_mapVal s)) (updated state)
          performAddListener :: (MonadWidget t m) => Text -> Event t JSVal -> m (Event t JSVal)
          performAddListener eventName mapEvent = performEventAsync (unReturn <$> (addListener eventName <$> mapEvent))
          unReturn :: (Monad m) => (a -> m v) -> a -> m () --Until i can figure out what to do with the listener ref
          unReturn f a = f a >> return ()


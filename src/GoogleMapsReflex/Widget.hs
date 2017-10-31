{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE OverloadedLists #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE FlexibleContexts #-}

module GoogleMapsReflex.Widget where

import Language.Javascript.JSaddle.Monad
import Reflex.Dom
import Control.Monad
import GoogleMapsReflex.GoogleMaps
import GoogleMapsReflex.Config
import qualified Data.Text as T
import Data.Functor
import JSDOM
import GoogleMapsReflex.Types

mapsWidget :: (MonadWidget t m, PerformEvent t m, TriggerEvent t m) => ApiKey -> Dynamic t Config -> m ()
mapsWidget apiKey config = do
    (mapEl, _) <- elAttr' "div" [
        ("id", "map"),
        ("style", "width: 300px; height: 300px;")
        ] blank
    maps <- loadMaps apiKey (updated config $> ())
    mapsLoaded <- holdDyn Nothing (maps $> (Just ()))
    let mergedConfig = zipDyn mapsLoaded config
    let configAfterMaps = fmapMaybe (\(a, b) -> a $> b) (updated mergedConfig)
    makeMapManaged (_element_raw mapEl) configAfterMaps
    return ()
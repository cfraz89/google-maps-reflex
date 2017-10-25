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

mapsWidget :: (MonadWidget t m, PerformEvent t m, TriggerEvent t m) => ApiKey -> Config t -> m ()
mapsWidget apiKey config = do
    (mapEl, _) <- elAttr' "div" [
        ("id", "map"),
        ("style", "width: 300px; height: 300px;")
        ] blank
    pb <- getPostBuild >>= delay 0.01
    pb2 <- getPostBuild >>= delay 0.02
    pbDyn <- holdDyn () pb2
    maps <- loadMaps apiKey pb
    let configAfterPB = config { 
        _config_markers = join (pbDyn $> (_config_markers config))
    }
    let mapScript = (maps $> (makeMapManaged (_element_raw mapEl) configAfterPB $> ()))
    widgetHold blank mapScript 
    return ()
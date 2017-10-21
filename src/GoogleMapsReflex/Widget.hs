{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE OverloadedLists #-}
module GoogleMapsReflex.Widget where

import Language.Javascript.JSaddle.Monad
import Reflex.Dom
import GoogleMapsReflex.GoogleMaps
import qualified Data.Text as T
import Data.Functor
import JSDOM
import GoogleMapsReflex.Types

mapsWidget :: (MonadWidget t m, PerformEvent t m, TriggerEvent t m) => String -> MapOptions -> m ()
mapsWidget mapsKey mapOptions = do
    (mapEl, _) <- elAttr' "div" [
        ("id", "map"),
        ("style", "width: 300px; height: 300px;")
        ] blank
    pb <- getPostBuild >>= delay 0.01
    maps <- loadMaps mapsKey pb
    let mapScript = (maps $> (createMap (_element_raw mapEl) def $> ()))
    widgetHold blank mapScript 
    return ()
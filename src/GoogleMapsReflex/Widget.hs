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
import qualified JSDOM.Types as JDT
import GoogleMapsReflex.Types

googleMaps :: (MonadWidget t m, PerformEvent t m, TriggerEvent t m) => JDT.Element -> ApiKey -> Dynamic t Config -> m ()
googleMaps el apiKey config = do
    maps <- loadMaps apiKey (updated config $> ())
    mapsLoaded <- holdDyn Nothing (maps $> (Just ()))
    let mergedConfig = zipDyn mapsLoaded config
    let configAfterMaps = fmapMaybe (\(a, b) -> a $> b) (updated mergedConfig)
    makeMapManaged el configAfterMaps
    return ()
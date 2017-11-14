{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
module GoogleMapsReflex.MapsApi where

import GoogleMapsReflex.JSTypes
import GoogleMapsReflex.Common

import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Types
import Language.Javascript.JSaddle.Value
import qualified JSDOM.Types as JDT
import qualified Data.Text as T
import Control.Monad.IO.Class

createMap :: JDT.ToJSVal e => e -> MapOptions -> JSM JSVal
createMap mapEl mapOptions = new (gmaps ! "Map") (mapEl, makeObject mapOptions)

createMarker :: JSVal -> MarkerOptions -> JSM JSVal
createMarker mapVal options = do
    optionsVal <- makeObject options
    optionsVal <# "map" $ mapVal
    new (gmaps ! "Marker") (val optionsVal)

setOptions :: JSVal -> MapOptions -> JSM JSVal
setOptions mapVal mapOptions = mapVal # "setOptions" $ val (makeObject mapOptions) 

addListener :: (MonadJSM m) => T.Text -> JSVal -> (JSVal -> IO()) -> m JSVal
addListener eventName mapVal cb = liftJSM $ do
    listener <- asyncFunction $ \ _ _ args -> do
        liftIO $ putStrLn ("Event" ++ T.unpack eventName)
        liftIO $ cb (head args)
    gmaps ! "event" # "addListener" $ [val mapVal, val eventName, val listener]
module GoogleMapsReflex.MapsApi where

import GoogleMapsReflex.JSTypes

import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Types
import Language.Javascript.JSaddle.Value


createMap :: (ToJSVal e) => e -> MapOptions -> JSM JSVal
createMap mapEl mapOptions = do
    mapVal <- toJSVal mapEl
    maps <- googleMaps
    options <- makeObject mapOptions
    gMapCons <- maps ! "Map"
    new gMapCons (mapVal, options)
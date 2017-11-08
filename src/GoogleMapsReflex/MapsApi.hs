module GoogleMapsReflex.MapsApi where

import GoogleMapsReflex.JSTypes

import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Types
import Language.Javascript.JSaddle.Value
import JSDOM.Types

createMap :: Element -> MapOptions -> JSM JSVal
createMap mapEl mapOptions = do
    mapVal <- toJSVal mapEl
    maps <- googleMapsVal
    options <- makeObject mapOptions
    gMapCons <- maps ! "Map"
    new gMapCons (mapVal, options)

createMarker :: JSVal -> MarkerOptions -> JSM JSVal
createMarker mapVal options = do
    maps <- googleMapsVal
    markerCons <- maps ! "Marker"
    optionsVal <- create
    position <- toJSVal (_markerOptions_position options)
    optionsVal <# "position" $ position
    optionsVal <# "title" $ val (_markerOptions_title options)
    optionsVal <# "map" $ mapVal
    new markerCons (ValObject optionsVal)


setOptions :: JSVal -> MapOptions -> JSM ()
setOptions mapVal mapOptions = do
    options <- makeObject mapOptions
    mapVal # "setOptions" $ val options
    return ()
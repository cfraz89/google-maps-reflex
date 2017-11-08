module GoogleMapsReflex.MapsApi where

import GoogleMapsReflex.JSTypes

import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Types
import Language.Javascript.JSaddle.Value
import JSDOM.Types

createMap :: Element -> MapOptions -> JSM JSVal
createMap mapEl mapOptions = new (gmaps ! "Map") (mapEl, makeObject mapOptions)

createMarker :: JSVal -> MarkerOptions -> JSM JSVal
createMarker mapVal options = do
    optionsVal <- makeObject options
    optionsVal <# "map" $ mapVal
    new (gmaps ! "Marker") (val optionsVal)


setOptions :: JSVal -> MapOptions -> JSM JSVal
setOptions mapVal mapOptions = mapVal # "setOptions" $ val (makeObject mapOptions) 
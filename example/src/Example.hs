{-# LANGUAGE OverloadedStrings #-}
module Example where

import Data.Functor
import Reflex.Dom.Core
import GoogleMapsReflex
import GHCJS.DOM.Types (JSM)
import qualified GoogleMapsReflex.MapsEvent as E

exampleMapsApp :: JSM ()
exampleMapsApp = mainWidget exampleMapsWidget

exampleMapsWidget :: MonadWidget t m => m ()
exampleMapsWidget = do
  --Unfortunately we need to delay the postbuild event as it fires before the elemnt is mounted into the DOM
  --google maps wont render correcly initially unless we delay it.
  pb <- getPostBuild >>= delay 0.1
  configDyn <- holdDyn config (pb $> config)

  --Make the dom element for the map
  (Element _ mapEl, _) <- elAttr' "div" ("style" =: "width: 500px; height: 300px;") blank

  --Create the widget
  maps <- googleMaps mapEl (ApiKey "Put key here - https://developers.google.com/maps/documentation/javascript/get-api-key") configDyn

  --Get the click event on the map
  mc <- E.mapsEvent E.Click maps _mapsState_mapVal

  d <- holdDyn "" (const "Clicked" <$> mc)
  el "div" $ dynText d

  return ()


config :: Config
config = Config {
  _config_mapOptions = def,
  _config_markers = [def {
    _markerOptions_position = LatLng 0 0,
    _markerOptions_title = "Title",
    _markerOptions_animation = Bounce
  }]
}
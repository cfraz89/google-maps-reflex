{-# LANGUAGE OverloadedStrings #-}
module Example where

import Data.Functor
import Reflex.Dom.Core
import qualified GoogleMapsReflex as G
import Data.Map
import GHCJS.DOM.Types (JSM)

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
  mc <- G.mapEvent G.Click maps 

  d <- holdDyn "" (const "Clicked" <$> mc)
  el "div" $ dynText d

  return ()


config :: G.Config Int
config = def {
  G._config_markers = fromList [(0, def {
    G._markerOptions_position = G.LatLng 0 0,
    G._markerOptions_title = "Title",
    G._markerOptions_animation = Just G.Drop
  })]
}

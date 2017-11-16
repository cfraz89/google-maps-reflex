# google-maps-reflex

A binding for google maps js api for the excellent Reflex framework.

Currently supports all options for map initialisation, placement of markers and click events.
A demo app can be found in the example folder.

## Basic usage
```haskell
  (Element _ mapEl, _) <- elAttr' "div" ("style" =: "width: 500px; height: 300px;") blank

  --Create the widget
  maps <- googleMaps mapEl (ApiKey "Your api key") configDyn
```

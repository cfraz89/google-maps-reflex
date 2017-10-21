module GoogleMapsReflex.Common where

import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Types
import Language.Javascript.JSaddle.Value

getMaps :: JSM JSVal
getMaps = jsg "google" ! "maps"
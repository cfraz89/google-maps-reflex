module GoogleMapsReflex.Common where
    
import Language.Javascript.JSaddle.Object
import Language.Javascript.JSaddle.Value
import Language.Javascript.JSaddle.Types

gmaps :: JSM JSVal
gmaps = jsg "google" ! "maps"
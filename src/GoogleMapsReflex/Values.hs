module GoogleMapsReflex.Values where

import Language.Javascript.JSaddle.Value

class ValueWrapped a where
    unVal :: a -> JSVal

newtype MapVal = MapVal JSVal
instance ValueWrapped MapVal where unVal (MapVal v) = v

newtype MarkerVal = MarkerVal JSVal
instance ValueWrapped MarkerVal where unVal (MarkerVal v) = v 

newtype EventListenerVal = EventListenerVal JSVal
instance ValueWrapped EventListenerVal where unVal (EventListenerVal v) = v 

newtype InfoWindowVal = InfoWindowVal JSVal
instance ValueWrapped InfoWindowVal where unVal (InfoWindowVal v) = v 
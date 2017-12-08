module GoogleMapsReflex.Values where

import Language.Javascript.JSaddle.Value

newtype MapVal = MapVal { _mapVal_val :: JSVal }
newtype MarkerVal = MarkerVal { _markerVal_val :: JSVal }
newtype EventListenerVal = EventListenerVal { _eventListenerVal_val :: JSVal }
newtype InfoWindowVal = InfoWindowVal { _eventWindowVal_val :: JSVal }
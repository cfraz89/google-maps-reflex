{-# LANGUAGE LambdaCase #-}

module GoogleMapsReflex.JSTypes.MapOptionsTypes.GestureHandling where

import Language.Javascript.JSaddle.Value

data GestureHandling = Cooperative | Greedy | None | Auto
    deriving (Show, Eq, Ord)

instance ToJSVal GestureHandling where
    toJSVal = val . \case
        Cooperative -> "cooperative"
        Greedy -> "greedy"
        None -> "none"
        Auto -> "auto"


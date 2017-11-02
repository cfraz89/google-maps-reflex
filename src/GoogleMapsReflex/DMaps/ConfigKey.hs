{-# LANGUAGE GADTs #-}
{-# LANGUAGE TemplateHaskell #-}

module GoogleMapsReflex.DMaps.ConfigKey where

import GoogleMapsReflex.Config
import Data.GADT.Compare.TH
import Language.Javascript.JSaddle.Value

data Phase = Creation | Update JSVal

data ConfigPhase = ConfigPhase Config Phase
 
data ConfigKey a where
    DPhase :: ConfigKey Phase
    DConfig :: ConfigKey Config

deriveGEq ''ConfigKey
deriveGCompare ''ConfigKey
import XMonad
import XMonad.Actions.CycleWS
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Layout.Magnifier
import XMonad.Layout.ThreeColumns
import XMonad.Layout.TrackFloating
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.RefocusLast
import qualified Data.Map.Strict as M
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.Paste
import System.IO

-- Data
import Data.Monoid

-- Imports for Polybar --
import qualified Codec.Binary.UTF8.String              as UTF8
import qualified DBus                                  as D
import qualified DBus.Client                           as D
import           XMonad.Hooks.DynamicLog

main :: IO ()
main = mkDbusClient >>= main'

main' :: D.Client -> IO ()
main' dbus = do
  --h <- spawnPipe "xmobar -d"
  xmonad $ ewmh $ docks def {
    terminal = "alacritty"
    , workspaces = myWorkspaces
    , manageHook = myManageHook -- <+> manageHook def
    , modMask = mod4Mask
    , borderWidth = 2
    , focusedBorderColor = "Dark Red"
    , layoutHook = myLayoutHook
    , logHook = myPolybarLogHook dbus
    , handleEventHook = myEventHook
    } `additionalKeys` myAdditionalKeys

--toggleStrutsKey XConfig { XMonad.modMask = modMask } = (modMask, xK_b)

myWorkspaces = ["y-Comms", "u-Web", "i-Code1", "o-Code2", "p-Code3", "SC-Notes"]
workSpaceShortcuts = [xK_y, xK_u, xK_i, xK_o, xK_p, xK_grave]

myAdditionalKeys =
  [ ((mod4Mask, xK_w), spawn ("qutebrowser"))
  , ((mod4Mask, xK_s), spawn ("rofi-pass"))
  , ((mod4Mask, xK_d), spawn ("rofi -modi drun,ssh,window -show drun -show-icons"))
  , ((mod4Mask, xK_g), spawn ("popupCommands"))
  , ((mod4Mask, xK_f), spawn ("alacritty -e kak"))
  , ((mod4Mask, xK_space), spawn ("alacritty"))
  , ((mod4Mask, xK_BackSpace), sendMessage NextLayout)
  , ((mod4Mask, xK_comma), sendMessage Shrink)
  , ((mod4Mask, xK_period), sendMessage Expand)
  , ((mod4Mask, xK_h), prevWS)
  , ((mod4Mask, xK_l), nextWS)
  , ((mod4Mask, xK_v ), kill)
  , ((mod4Mask, xK_equal), togglePolybar)
  ] ++
  [((m .|. mod4Mask, k), windows $ f i)
    | (i, k) <- zip myWorkspaces workSpaceShortcuts
    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

togglePolybar = spawn "polybar-msg cmd toggle &"

workspaceCodeLayout = Full ||| leftRight ||| leftRightMagnified ||| threeCol ||| underOver
  where
    threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
    leftRight = Tall nmaster delta ratio
    leftRightMagnified = magnifiercz' 1.3 $ leftRight
    underOver = Mirror leftRight
    nmaster = 1      -- Default number of windows in the master pane
    ratio   = 1/2    -- Default proportion of screen occupied by master pane
    delta   = 3/100  -- Percent of screen to increment by when resizing panes

myLayoutHook = avoidStruts
  $ refocusLastLayoutHook . trackFloating
  $ workspaceCodeLayout
  -- $ spacingRaw True (Border 0 5 5 5) True (Border 5 5 5 5) True

myEventHook = refocusLastWhen myPred
    where
        myPred = refocusingIsActive <||> isFloat
        refocusLastKeys cnf
          = M.fromList
          $ ((modMask cnf              , xK_a), toggleFocus)
          : ((modMask cnf .|. shiftMask, xK_a), swapWithLast)
          : ((modMask cnf              , xK_b), toggleRefocusing)
          : [ ( (modMask cnf .|. shiftMask, n)
              , windows =<< shiftRLWhen myPred wksp
              )
            | (n, wksp) <- zip [xK_1..xK_9] (workspaces cnf)
            ]
------------------------------------------------------------------------
-- Polybar settings (needs DBus client).
--
mkDbusClient :: IO D.Client
mkDbusClient = do
  dbus <- D.connectSession
  D.requestName dbus (D.busName_ "org.xmonad.log") opts
  return dbus
 where
  opts = [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str =
  let opath  = D.objectPath_ "/org/xmonad/Log"
      iname  = D.interfaceName_ "org.xmonad.Log"
      mname  = D.memberName_ "Update"
      signal = D.signal opath iname mname
      body   = [D.toVariant $ UTF8.decodeString str]
  in  D.emit dbus $ signal { D.signalBody = body }

polybarHook :: D.Client -> PP
polybarHook dbus =
  let wrapper c s | s /= "NSP" = wrap ("%{F" <> c <> "} ") " %{F-}" s
                  | otherwise  = mempty
      blue   = "#2E9AFE"
      gray   = "#7F7F7F"
      orange = "#ea4300"
      purple = "#9058c7"
      red    = "#722222"
  in  def { ppOutput          = dbusOutput dbus
          , ppCurrent         = wrapper blue
          , ppVisible         = wrapper gray
          , ppUrgent          = wrapper orange
          , ppHidden          = wrapper gray
          , ppHiddenNoWindows = wrapper red
          , ppTitle           = wrapper purple . shorten 90
          }

myPolybarLogHook dbus = dynamicLogWithPP (polybarHook dbus)

------------------------------------------------------------------------

myManageHook :: ManageHook
myManageHook = insertPosition Below Newer <+> composeAll
  [ className =? "Spotify"            --> doShift "y:Comms"
    , className =? "Signal"           --> doShift "y:Comms"
    , className =? "qutebrowser"      --> doShift "i:Web"
  ] <+> manageDocks

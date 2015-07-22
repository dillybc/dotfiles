--
--

import XMonad
import Data.Monoid
import System.Exit
import XMonad.Layout.IndependentScreens
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run(spawnPipe)
import System.IO

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- change the default terminal
--
myTerminal      = "urxvt -fg white -bg black"

-- change Mod key to the 'windows' key
--
myModMask       = mod4Mask

-- modify the default list of workspaces to use 2 screens, should probably
-- use countScreens instead..
--
myWorkspaces    = withScreens 2 ["1","2","3","4","5","6","7","8","9"]


------------------------------------------------------------------------
-- modify key bindings for changing and moving between workspaces to
-- something sensible. See inline comments
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    --
    -- mod+{1..9} switches to workspace {1..9}
    -- mod+shift+{1..9} moves current client to workspace {1..9}
    --
    [((m .|. modm, k), windows $ onCurrentScreen f i)
        | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1(w), 2(e), or 3(r)
    -- mod-shift-{w,e,r}, Move client to screen 1(w), 2(e), or 3(r)
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Now run xmonad with the values we've set up
-- note: we use <+> to overwrite the current assignment of mod+{1..9} and
-- mod+{w,e,r} in the default key assignment whilst keeping the other
-- defaults
-- 
main = do
    nScreens    <- countScreens
    hs          <- mapM (spawnPipe . xmobarCommand) [0..nScreens-1]
    xmonad $ defaultConfig {
        workspaces              = withScreens nScreens (map show [1..9]),
        terminal                = myTerminal,
        modMask                 = myModMask,
        keys                    = myKeys <+> keys defaultConfig,
        manageHook              = manageDocks,
        layoutHook              = avoidStruts  $  layoutHook defaultConfig,
        logHook                 = mapM_ dynamicLogWithPP $ zipWith pp hs [0..nScreens]
        }
        

-- comfigre xmobar with the correct xmobar configuration for each screen
--
xmobarCommand (S s) = unwords ["xmobar", "-x", show s, template s] where
    template 0 = "~/.xmobarrc_main"
    template _ = "~/.xmobarrc_side"
 
pp h s = marshallPP s defaultPP {
    ppOutput            = hPutStrLn h,
    ppTitle             = xmobarColor "green" ""
    }
    where color c = xmobarColor c ""


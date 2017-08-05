--
-- configuration
--

local animationDuration = 0.0
local gridSizes = { default = '30x20', interactive = '8x4' }
local gridTextSize = 100
local margins = { w = 4, h = 4 }


--
-- setup
--

local grid = require('ext.grid')

hs.window.animationDuration=animationDuration
grid.setGrid(gridSizes.default)
grid.setMargins(margins)
grid.ui.textSize = gridTextSize


--
-- helpers
--

function adjustGridWindow(x, y, w, h)
  return function()
    grid.adjustWindow(
      function(cell)
        cell.x,cell.y,cell.w,cell.h = x, y, w, h
      end
    )
  end
end


--
-- resize to grid
--

-- show interactive grid menu
hs.hotkey.bind(
  {"cmd", "ctrl"}, "4",
  function()
    grid.setGrid(gridSizes.interactive)
    grid.toggleShow(
      function()
        grid.setGrid(gridSizes.default)
      end
    )
  end
)

-- left half
hs.hotkey.bind({"cmd", "ctrl"}, "J", adjustGridWindow(0, 0, 15, 20))
-- right half
hs.hotkey.bind({"cmd", "ctrl"}, "L", adjustGridWindow(15, 0, 15, 20))
-- top half
hs.hotkey.bind({"cmd", "ctrl"}, "I", adjustGridWindow(0, 0, 30, 10))
-- bottom half
hs.hotkey.bind({"cmd", "ctrl"}, "K", adjustGridWindow(0, 10, 30, 10))

-- left narrow
hs.hotkey.bind({"ctrl", "alt"}, "U", adjustGridWindow(0, 0, 12, 20))
-- right narrow
hs.hotkey.bind({"ctrl", "alt"}, "O", adjustGridWindow(18, 0, 12, 20))

-- left wide
hs.hotkey.bind({"cmd", "ctrl"}, "U", adjustGridWindow(0, 0, 18, 20))
-- right wide
hs.hotkey.bind({"cmd", "ctrl"}, "O", adjustGridWindow(12, 0, 18, 20))

-- left fat
hs.hotkey.bind({"ctrl", "alt"}, "J", adjustGridWindow(0, 0, 21, 20))
-- right wide
hs.hotkey.bind({"ctrl", "alt"}, "L", adjustGridWindow(9, 0, 21, 20))
-- top fat
hs.hotkey.bind({"ctrl", "alt"}, "I", adjustGridWindow(0, 0, 30, 14))
-- bottom wide
hs.hotkey.bind({"ctrl", "alt"}, "K", adjustGridWindow(0, 6, 30, 14))

-- top left quarter
hs.hotkey.bind({"cmd", "ctrl", "shift"}, "J", adjustGridWindow(0, 0, 15, 10))
-- top right quarter
hs.hotkey.bind({"cmd", "ctrl", "shift"}, "I", adjustGridWindow(15, 0, 15, 10))
-- bottom right quarter
hs.hotkey.bind({"cmd", "ctrl", "shift"}, "L", adjustGridWindow(15, 10, 15, 10))
-- bottom left quarter
hs.hotkey.bind({"cmd", "ctrl", "shift"}, "K", adjustGridWindow(0, 10, 15, 10))

-- center narrow small
hs.hotkey.bind({"ctrl", "alt"}, "\\", adjustGridWindow(9, 0, 12, 20))
-- center narrow
hs.hotkey.bind({"cmd", "ctrl"}, "\\", adjustGridWindow(7, 0, 16, 20))

-- center medium small
hs.hotkey.bind({"ctrl", "alt"}, "'", adjustGridWindow(6, 0, 18, 20))
-- center medium
hs.hotkey.bind({"cmd", "ctrl"}, "'", adjustGridWindow(5, 0, 20, 20))

-- center wide small
hs.hotkey.bind({"ctrl", "alt"}, ";", adjustGridWindow(4, 0, 22, 20))
-- center wide
hs.hotkey.bind({"cmd", "ctrl"}, ";", adjustGridWindow(3, 0, 24, 20))

-- center wide
hs.hotkey.bind({"cmd", "ctrl"}, "H", function() grid.maximizeWindow() end)


--
-- move between displays
--

-- move to screen to the left
hs.hotkey.bind(
  {"cmd", "ctrl"}, ",",
  function()
    local win = hs.window.focusedWindow()
    win:moveOneScreenWest()
    grid.snap(win)
  end
)

-- move to screen to the right
hs.hotkey.bind(
  {"cmd", "ctrl"}, ".",
  function()
    local win = hs.window.focusedWindow()
    win:moveOneScreenEast()
    grid.snap(win)
  end
)

-- move to screen above
hs.hotkey.bind(
  {"cmd", "ctrl"}, "P",
  function()
    local win = hs.window.focusedWindow()
    win:moveOneScreenNorth()
    grid.snap(win)
  end
)

-- move to screen bellow
hs.hotkey.bind(
  {"cmd", "ctrl"}, "N",
  function()
    local win = hs.window.focusedWindow()
    win:moveOneScreenSouth()
    grid.snap(win)
  end
)


--
-- the end
--

-- reload config
hs.hotkey.bind(
  {"cmd", "alt", "ctrl"}, "R",
  function()
    hs.reload()
  end
)
hs.alert.show("Hammerspoon loaded")

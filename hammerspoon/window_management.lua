-- luacheck: read_globals hs

local wm = {
  grid = require('ext.grid'),

  -- configuration
  animationDuration = 0.0,
  gridSizes = { default = '30x20', interactive = '8x4' },
  gridTextSize = 50,
  margins = { w = 4, h = 4 }
}

function wm:init ()
  -- setup
  hs.window.animationDuration = self.animationDuration
  self.grid.setGrid(self.gridSizes.default)
  self.grid.setMargins(self.margins)
  self.grid.ui.textSize = self.gridTextSize


  --
  -- resize to grid
  --

  -- show interactive grid menu
  hs.hotkey.bind(
    {"cmd", "ctrl"}, "2",
    function()
      self.grid.setGrid(self.gridSizes.interactive)
      self.grid.show(
        function()
          self.grid.setGrid(self.gridSizes.default)
        end
      )
    end
  )

  -- left half
  hs.hotkey.bind({"cmd", "ctrl"}, "J", self.adjustWindow(0, 0, 15, 20))
  -- right half
  hs.hotkey.bind({"cmd", "ctrl"}, "L", self.adjustWindow(15, 0, 15, 20))
  -- top half
  hs.hotkey.bind({"cmd", "ctrl"}, "I", self.adjustWindow(0, 0, 30, 10))
  -- bottom half
  hs.hotkey.bind({"cmd", "ctrl"}, "K", self.adjustWindow(0, 10, 30, 10))

  -- left narrow
  hs.hotkey.bind({"ctrl", "alt"}, "U", self.adjustWindow(0, 0, 12, 20))
  -- right narrow
  hs.hotkey.bind({"ctrl", "alt"}, "O", self.adjustWindow(18, 0, 12, 20))

  -- left wide
  hs.hotkey.bind({"cmd", "ctrl"}, "U", self.adjustWindow(0, 0, 18, 20))
  -- right wide
  hs.hotkey.bind({"cmd", "ctrl"}, "O", self.adjustWindow(12, 0, 18, 20))

  -- left fat
  hs.hotkey.bind({"ctrl", "alt"}, "J", self.adjustWindow(0, 0, 21, 20))
  -- right wide
  hs.hotkey.bind({"ctrl", "alt"}, "L", self.adjustWindow(9, 0, 21, 20))
  -- top fat
  hs.hotkey.bind({"ctrl", "alt"}, "I", self.adjustWindow(0, 0, 30, 14))
  -- bottom wide
  hs.hotkey.bind({"ctrl", "alt"}, "K", self.adjustWindow(0, 6, 30, 14))

  -- top left quarter
  hs.hotkey.bind({"cmd", "ctrl", "shift"}, "J", self.adjustWindow(0, 0, 15, 10))
  -- top right quarter
  hs.hotkey.bind({"cmd", "ctrl", "shift"}, "I", self.adjustWindow(15, 0, 15, 10))
  -- bottom right quarter
  hs.hotkey.bind({"cmd", "ctrl", "shift"}, "L", self.adjustWindow(15, 10, 15, 10))
  -- bottom left quarter
  hs.hotkey.bind({"cmd", "ctrl", "shift"}, "K", self.adjustWindow(0, 10, 15, 10))

  -- center narrow small
  hs.hotkey.bind({"ctrl", "alt"}, "\\", self.adjustWindow(9, 0, 12, 20))
  -- center narrow
  hs.hotkey.bind({"cmd", "ctrl"}, "\\", self.adjustWindow(7, 0, 16, 20))

  -- center medium small
  hs.hotkey.bind({"ctrl", "alt"}, "'", self.adjustWindow(6, 0, 18, 20))
  -- center medium
  hs.hotkey.bind({"cmd", "ctrl"}, "'", self.adjustWindow(5, 0, 20, 20))

  -- center wide small
  hs.hotkey.bind({"ctrl", "alt"}, ";", self.adjustWindow(4, 0, 22, 20))
  -- center wide
  hs.hotkey.bind({"cmd", "ctrl"}, ";", self.adjustWindow(3, 0, 24, 20))

  -- maximized
  hs.hotkey.bind({"cmd", "ctrl"}, "H", self.grid.maximizeWindow)


  --
  -- move between displays
  --

  -- move to screen to the left
  hs.hotkey.bind(
    {"cmd", "ctrl"}, ",",
    function()
      local win = hs.window.focusedWindow()
      win:moveOneScreenWest()
      self.grid.snap(win)
    end
  )

  -- move to screen to the right
  hs.hotkey.bind(
    {"cmd", "ctrl"}, ".",
    function()
      local win = hs.window.focusedWindow()
      win:moveOneScreenEast()
      self.grid.snap(win)
    end
  )

  -- move to screen above
  hs.hotkey.bind(
    {"cmd", "ctrl"}, "P",
    function()
      local win = hs.window.focusedWindow()
      win:moveOneScreenNorth()
      self.grid.snap(win)
    end
  )

  -- move to screen bellow
  hs.hotkey.bind(
    {"cmd", "ctrl"}, "N",
    function()
      local win = hs.window.focusedWindow()
      win:moveOneScreenSouth()
      self.grid.snap(win)
    end
  )
end


--
-- private methods
--

wm.adjustWindow = function (x, y, w, h)
  return function()
    wm.grid.adjustWindow(
      function(cell)
        cell.x = x
        cell.y = y
        cell.w = w
        cell.h = h
      end
    )
  end
end


-- the end
return wm

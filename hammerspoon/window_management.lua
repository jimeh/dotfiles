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
  local bind = require('hs.hotkey').bind

  hs.window.animationDuration = self.animationDuration
  self.grid.setGrid(self.gridSizes.default)
  self.grid.setMargins(self.margins)
  self.grid.ui.textSize = self.gridTextSize

  --
  -- resize to grid
  --

  -- show interactive grid menu
  bind({'cmd', 'ctrl'}, '2',
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
  bind({'cmd', 'ctrl'}, 'J', self.adjustWindow(0, 0, 15, 20))
  -- right half
  bind({'cmd', 'ctrl'}, 'L', self.adjustWindow(15, 0, 15, 20))
  -- top half
  bind({'cmd', 'ctrl'}, 'I', self.adjustWindow(0, 0, 30, 10))
  -- bottom half
  bind({'cmd', 'ctrl'}, 'K', self.adjustWindow(0, 10, 30, 10))

  -- left narrow
  bind({'ctrl', 'alt'}, 'U', self.adjustWindow(0, 0, 12, 20))
  -- right narrow
  bind({'ctrl', 'alt'}, 'O', self.adjustWindow(18, 0, 12, 20))

  -- left wide
  bind({'cmd', 'ctrl'}, 'U', self.adjustWindow(0, 0, 18, 20))
  -- right wide
  bind({'cmd', 'ctrl'}, 'O', self.adjustWindow(12, 0, 18, 20))

  -- left fat
  bind({'cmd', 'ctrl', 'alt'}, 'J', self.adjustWindow(0, 0, 21, 20))
  -- right wide
  bind({'cmd', 'ctrl', 'alt'}, 'L', self.adjustWindow(9, 0, 21, 20))
  -- top fat
  bind({'cmd', 'ctrl', 'alt'}, 'I', self.adjustWindow(0, 0, 30, 14))
  -- bottom wide
  bind({'cmd', 'ctrl', 'alt'}, 'K', self.adjustWindow(0, 6, 30, 14))

  -- top left quarter
  bind({'cmd', 'ctrl', 'shift'}, 'J', self.adjustWindow(0, 0, 15, 10))
  -- top right quarter
  bind({'cmd', 'ctrl', 'shift'}, 'I', self.adjustWindow(15, 0, 15, 10))
  -- bottom right quarter
  bind({'cmd', 'ctrl', 'shift'}, 'L', self.adjustWindow(15, 10, 15, 10))
  -- bottom left quarter
  bind({'cmd', 'ctrl', 'shift'}, 'K', self.adjustWindow(0, 10, 15, 10))

  -- center super narrow
  bind({'cmd', 'ctrl', 'alt'}, '\\', self.adjustWindow(10, 0, 10, 20))
  -- center narrow small
  bind({'ctrl', 'alt'}, '\\', self.adjustWindow(9, 0, 12, 20))
  -- center narrow
  bind({'cmd', 'ctrl'}, '\\', self.adjustWindow(7, 0, 16, 20))

  -- center medium small
  bind({'ctrl', 'alt'}, '\'', self.adjustWindow(6, 0, 18, 20))
  -- center medium
  bind({'cmd', 'ctrl'}, '\'', self.adjustWindow(5, 0, 20, 20))

  -- center wide small
  bind({'ctrl', 'alt'}, ';', self.adjustWindow(4, 0, 22, 20))
  -- center wide
  bind({'cmd', 'ctrl'}, ';', self.adjustWindow(3, 0, 24, 20))

  -- maximized
  bind({'cmd', 'ctrl'}, 'H', self.grid.maximizeWindow)


  --
  -- resize to specific sizes
  --

  bind({'cmd', 'ctrl', 'alt'}, 'F', self.resizeWindow(770, 634))

  -- move window relative
  bind({'ctrl', 'alt'}, 'J',
    self.moveWindowOnGrid(-1, 0), nil, self.moveWindowOnGrid(-1, 0))
  bind({'ctrl', 'alt'}, 'L',
    self.moveWindowOnGrid(1, 0), nil, self.moveWindowOnGrid(1, 0))
  bind({'ctrl', 'alt'}, 'I',
    self.moveWindowOnGrid(0, -1), nil, self.moveWindowOnGrid(0, -1))
  bind({'ctrl', 'alt'}, 'K',
    self.moveWindowOnGrid(0, 1), nil, self.moveWindowOnGrid(0, 1))

  --
  -- move between displays
  --

  -- move to screen to the left
  bind({'cmd', 'ctrl'}, ',',
    function()
      local win = hs.window.focusedWindow()
      win:moveOneScreenWest()
      self.grid.snap(win)
    end
  )

  -- move to screen to the right
  bind({'cmd', 'ctrl'}, '.',
    function()
      local win = hs.window.focusedWindow()
      win:moveOneScreenEast()
      self.grid.snap(win)
    end
  )

  -- move to screen above
  bind({'cmd', 'ctrl'}, 'P',
    function()
      local win = hs.window.focusedWindow()
      win:moveOneScreenNorth()
      self.grid.snap(win)
    end
  )

  -- move to screen bellow
  bind({'cmd', 'ctrl'}, 'N',
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
  return function ()
    wm.grid.adjustWindow(
      function (cell)
        cell.x = x
        cell.y = y
        cell.w = w
        cell.h = h
      end
    )
  end
end

wm.moveWindowOnGrid = function (x, y)
  return function ()
    wm.grid.adjustWindow(
      function (cell)
        local gridSize = wm.grid.getGrid()

        if ((cell.x + x) + cell.w) <= gridSize.w then
          cell.x = cell.x + x
        end

        if ((cell.y + y) + cell.h) <= gridSize.h then
          cell.y = cell.y + y
        end
      end
    )
  end
end

wm.resizeWindow = function (w, h)
  return function ()
    local win = hs.window.focusedWindow()
    local f = win:frame()

    f.w = w
    f.h = h
    win:setFrame(f)
  end
end

wm.moveWindow = function(x, y)
  return function ()
    local win = hs.window.focusedWindow()
    local f = win:frame()

    f.x = x
    f.y = y
    win:setFrame(f)
  end
end

wm.moveWindowRelative = function (x, y)
  return function ()
    local win = hs.window.focusedWindow()
    local f = win:frame()

    f.x = f.x + x
    f.y = f.y + y
    win:setFrame(f)
  end
end


-- the end
return wm

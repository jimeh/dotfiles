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
  local bindAndRepeat = self.bindAndRepeat

  hs.window.animationDuration = self.animationDuration
  self.grid.setGrid(self.gridSizes.default)
  self.grid.setMargins(self.margins)
  self.grid.ui.textSize = self.gridTextSize

  --
  -- move and resize to preset grid locations
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
  bind({'ctrl', 'alt'}, 'J', self.adjustWindow(0, 0, 15, 20))
  -- right half
  bind({'ctrl', 'alt'}, 'L', self.adjustWindow(15, 0, 15, 20))
  -- top half
  bind({'ctrl', 'alt'}, 'I', self.adjustWindow(0, 0, 30, 10))
  -- bottom half
  bind({'ctrl', 'alt'}, 'K', self.adjustWindow(0, 10, 30, 10))

  -- left narrow
  bind({'ctrl', 'alt'}, 'U', self.adjustWindow(0, 0, 12, 20))
  -- right narrow
  bind({'ctrl', 'alt'}, 'O', self.adjustWindow(18, 0, 12, 20))

  -- left wide
  bind({'cmd', 'ctrl'}, 'U', self.adjustWindow(0, 0, 18, 20))
  -- right wide
  bind({'cmd', 'ctrl'}, 'O', self.adjustWindow(12, 0, 18, 20))

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
  -- move and resize windows
  --

  bind({'cmd', 'ctrl', 'alt'}, 'F', self.resizeWindow(770, 634))

  -- resize windows
  bindAndRepeat({'cmd', 'ctrl'}, 'J', self.resizeWindowOnGrid(-1, 0))
  bindAndRepeat({'cmd', 'ctrl'}, 'L', self.resizeWindowOnGrid(1, 0))
  bindAndRepeat({'cmd', 'ctrl'}, 'I', self.resizeWindowOnGrid(0, -1))
  bindAndRepeat({'cmd', 'ctrl'}, 'K', self.resizeWindowOnGrid(0, 1))

  -- move window relative
  bindAndRepeat({'cmd', 'ctrl', 'shift'}, 'J', self.moveWindowOnGrid(-1, 0))
  bindAndRepeat({'cmd', 'ctrl', 'shift'}, 'L', self.moveWindowOnGrid(1, 0))
  bindAndRepeat({'cmd', 'ctrl', 'shift'}, 'I', self.moveWindowOnGrid(0, -1))
  bindAndRepeat({'cmd', 'ctrl', 'shift'}, 'K', self.moveWindowOnGrid(0, 1))

  -- enlarge horizontally
  bindAndRepeat({'cmd', 'ctrl', 'shift'}, '\\',
    self.resizeWindowOnGridSymmetrically(1, 0))
  -- shrink horizontally
  bindAndRepeat({'cmd', 'ctrl', 'shift'}, '\'',
    self.resizeWindowOnGridSymmetrically(-1, 0))


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

wm.bindAndRepeat = function (mod, key, fn)
  hs.hotkey.bind(mod, key, fn, nil, fn)
end

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

wm.resizeWindowOnGrid = function (w, h)
  return function ()
    wm.grid.adjustWindow(
      function (cell)
        local gridSize = wm.grid.getGrid()

        if cell.x == 0 and cell.w == gridSize.w then
          if w < 0 then
            cell.w = cell.w + w
          else
            cell.w = cell.w - w
            cell.x = cell.x + w
          end
        elseif (cell.x + cell.w) >= gridSize.w then
          cell.w = cell.w - w
          cell.x = cell.x + w
        elseif cell.x == 0 then
          cell.w = cell.w + w
        else
          cell.w = cell.w + (w * 2)
          cell.x = cell.x - w
        end

        if cell.y == 0 and cell.h == gridSize.h then
          if h < 0 then
            cell.h = cell.h + h
          else
            cell.h = cell.h - h
            cell.y = cell.y + h
          end
        elseif (cell.y + cell.h) >= gridSize.h then
          cell.h = cell.h - h
          cell.y = cell.y + h
        elseif cell.y == 0 then
          cell.h = cell.h + h
        else
          cell.h = cell.h - (h * 2)
          cell.y = cell.y + h
        end
      end
    )
  end
end

wm.resizeWindowOnGridSymmetrically = function (w, h)
  return function ()
    wm.grid.adjustWindow(
      function (cell)
        local gridSize = wm.grid.getGrid()

        if w ~= 0 and (cell.w + (w * 2)) <= gridSize.w then
          cell.w = cell.w + (w * 2)
          cell.x = cell.x - w
        end

        if h ~= 0 and (cell.h + (h * 2)) <= gridSize.h then
          cell.h = cell.h + (h * 2)
          cell.y = cell.y - h
        end
      end
    )
  end
end


-- the end
return wm

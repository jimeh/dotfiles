-- luacheck: read_globals hs

local eventtap = require('hs.eventtap')
local grid = require('hs.grid')
local hotkey = require('hs.hotkey')
local mouse = require('hs.mouse')
local timer = require('hs.timer')
local window = require('hs.window')

-- configuration
local wm = {
  animationDuration = 0.0,
  gridSizes = { default = '30x20', interactive = '8x4' },
  gridTextSize = 50,
  margins = { w = 4, h = 4 }
}

-- initialize and register keybindings
function wm:init()
  -- setup
  local bind = require('hs.hotkey').bind
  local bindAndRepeat = self.bindAndRepeat

  window.animationDuration = self.animationDuration
  grid.setGrid(self.gridSizes.default)
  grid.setMargins(self.margins)
  grid.ui.textSize = self.gridTextSize

  --
  -- move and resize to preset grid locations
  --

  -- show interactive grid menu
  bind({ 'cmd', 'ctrl' }, '§',
    function()
      grid.setGrid(self.gridSizes.interactive)
      grid.show(
        function()
          grid.setGrid(self.gridSizes.default)
        end
      )
    end
  )

  -- left half
  bind({ 'cmd', 'ctrl' }, 'J', self.adjustWindow(0, 0, 15, 20))
  -- right half
  bind({ 'cmd', 'ctrl' }, 'L', self.adjustWindow(15, 0, 15, 20))
  -- top half
  bind({ 'cmd', 'ctrl' }, 'I', self.adjustWindow(0, 0, 30, 10))
  -- bottom half
  bind({ 'cmd', 'ctrl' }, 'K', self.adjustWindow(0, 10, 30, 10))

  -- left narrow
  bind({ 'ctrl', 'alt' }, 'U', self.adjustWindow(0, 0, 12, 20))
  -- left super narrow
  bind({ 'cmd', 'ctrl', 'alt' }, 'U', self.adjustWindow(0, 0, 9, 20))
  -- right narrow
  bind({ 'ctrl', 'alt' }, 'O', self.adjustWindow(18, 0, 12, 20))
  -- right super narrow
  bind({ 'cmd', 'ctrl', 'alt' }, 'O', self.adjustWindow(21, 0, 9, 20))

  -- left wide
  bind({ 'cmd', 'ctrl' }, 'U', self.adjustWindow(0, 0, 18, 20))
  -- right wide
  bind({ 'cmd', 'ctrl' }, 'O', self.adjustWindow(12, 0, 18, 20))

  -- center super narrow
  bind({ 'cmd', 'ctrl', 'alt' }, '\\', self.adjustWindow(10, 0, 10, 20))
  -- center narrow small
  bind({ 'ctrl', 'alt' }, '\\', self.adjustWindow(9, 0, 12, 20))
  -- center narrow
  bind({ 'cmd', 'ctrl' }, '\\', self.adjustWindow(7, 0, 16, 20))

  -- center medium small
  bind({ 'ctrl', 'alt' }, '\'', self.adjustWindow(6, 0, 18, 20))
  -- center medium
  bind({ 'cmd', 'ctrl' }, '\'', self.adjustWindow(5, 0, 20, 20))

  -- center wide small
  bind({ 'ctrl', 'alt' }, ';', self.adjustWindow(4, 0, 22, 20))
  -- center wide
  bind({ 'cmd', 'ctrl' }, ';', self.adjustWindow(3, 0, 24, 20))

  -- maximized
  bind({ 'cmd', 'ctrl' }, 'H', grid.maximizeWindow)


  --
  -- move and resize windows
  --

  bind({ 'cmd', 'ctrl', 'alt' }, 'F', self.resizeWindow(770, 634))
  bind({ 'cmd', 'ctrl', 'alt' }, 'X', self.adjustWindow(0, 3, 10, 14))

  -- resize windows
  bindAndRepeat({ 'cmd', 'ctrl', 'alt' }, 'J', self.resizeWindowOnGrid(-1, 0))
  bindAndRepeat({ 'cmd', 'ctrl', 'alt' }, 'L', self.resizeWindowOnGrid(1, 0))
  bindAndRepeat({ 'cmd', 'ctrl', 'alt' }, 'I', self.resizeWindowOnGrid(0, -1))
  bindAndRepeat({ 'cmd', 'ctrl', 'alt' }, 'K', self.resizeWindowOnGrid(0, 1))

  -- move window relative
  bindAndRepeat({ 'ctrl', 'alt' }, 'J', self.moveWindowOnGrid(-1, 0))
  bindAndRepeat({ 'ctrl', 'alt' }, 'L', self.moveWindowOnGrid(1, 0))
  bindAndRepeat({ 'ctrl', 'alt' }, 'I', self.moveWindowOnGrid(0, -1))
  bindAndRepeat({ 'ctrl', 'alt' }, 'K', self.moveWindowOnGrid(0, 1))

  -- enlarge horizontally
  bindAndRepeat({ 'cmd', 'ctrl', 'shift' }, '\\',
    self.resizeWindowOnGridSymmetrically(1, 0))
  -- shrink horizontally
  bindAndRepeat({ 'cmd', 'ctrl', 'shift' }, '\'',
    self.resizeWindowOnGridSymmetrically(-1, 0))


  --
  -- move windows between spaces
  --

  bind({ 'ctrl', 'alt' }, 'left', self.moveWindowToSpace('left'))
  bind({ 'ctrl', 'alt' }, 'right', self.moveWindowToSpace('right'))
  bind({ 'ctrl', 'alt' }, '1', self.moveWindowToSpace('1'))
  bind({ 'ctrl', 'alt' }, '2', self.moveWindowToSpace('2'))
  bind({ 'ctrl', 'alt' }, '3', self.moveWindowToSpace('3'))
  bind({ 'ctrl', 'alt' }, '4', self.moveWindowToSpace('4'))
  bind({ 'ctrl', 'alt' }, '5', self.moveWindowToSpace('5'))
  bind({ 'ctrl', 'alt' }, '6', self.moveWindowToSpace('6'))
  bind({ 'ctrl', 'alt' }, '7', self.moveWindowToSpace('7'))
  bind({ 'ctrl', 'alt' }, '8', self.moveWindowToSpace('8'))
  bind({ 'ctrl', 'alt' }, '9', self.moveWindowToSpace('9'))
  bind({ 'ctrl', 'alt' }, '0', self.moveWindowToSpace('0'))


  --
  -- move windows between displays
  --

  -- move to screen to the left
  bind({ 'cmd', 'ctrl' }, ',',
    function()
      local win = window.focusedWindow()
      win:moveOneScreenWest()
      grid.snap(win)
    end
  )

  -- move to screen to the right
  bind({ 'cmd', 'ctrl' }, '.',
    function()
      local win = window.focusedWindow()
      win:moveOneScreenEast()
      grid.snap(win)
    end
  )

  -- move to screen above
  bind({ 'cmd', 'ctrl', 'alt' }, '.',
    function()
      local win = window.focusedWindow()
      win:moveOneScreenNorth()
      grid.snap(win)
    end
  )

  -- move to screen bellow
  bind({ 'cmd', 'ctrl', 'alt' }, ',',
    function()
      local win = window.focusedWindow()
      win:moveOneScreenSouth()
      grid.snap(win)
    end
  )
end

--
-- private methods
--

wm.bindAndRepeat = function(mod, key, fn)
  hotkey.bind(mod, key, fn, nil, fn)
end

wm.adjustWindow = function(x, y, w, h)
  return function()
    grid.adjustWindow(
      function(cell)
        cell.x = x
        cell.y = y
        cell.w = w
        cell.h = h
      end
    )
  end
end

wm.resizeWindow = function(w, h)
  return function()
    local win = window.focusedWindow()
    local f = win:frame()

    f.w = w
    f.h = h
    win:setFrame(f)
  end
end

wm.moveWindow = function(x, y)
  return function()
    local win = window.focusedWindow()
    local f = win:frame()

    f.x = x
    f.y = y
    win:setFrame(f)
  end
end

wm.moveWindowRelative = function(x, y)
  return function()
    local win = window.focusedWindow()
    local f = win:frame()

    f.x = f.x + x
    f.y = f.y + y
    win:setFrame(f)
  end
end

wm.moveWindowOnGrid = function(x, y)
  return function()
    grid.adjustWindow(
      function(cell)
        local max = grid.getGrid()

        if ((cell.x + x) + cell.w) <= max.w then
          cell.x = cell.x + x
        end

        if ((cell.y + y) + cell.h) <= max.h then
          cell.y = cell.y + y
        end
      end
    )
  end
end

wm.resizeWindowOnGrid = function(w, h)
  return function()
    grid.adjustWindow(
      function(cell)
        local max = grid.getGrid()

        if cell.x == 0 and cell.w == max.w then
          if w < 0 then
            cell.w = cell.w + w
          else
            cell.w = cell.w - w
            cell.x = cell.x + w
          end
        elseif (cell.x + cell.w) >= max.w then
          cell.w = cell.w - w
          cell.x = cell.x + w
        elseif cell.x == 0 then
          cell.w = cell.w + w
        else
          cell.w = cell.w + (w * 2)
          cell.x = cell.x - w
        end

        if cell.y == 0 and cell.h == max.h then
          if h < 0 then
            cell.h = cell.h + h
          else
            cell.h = cell.h - h
            cell.y = cell.y + h
          end
        elseif (cell.y + cell.h) >= max.h then
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

wm.resizeWindowOnGridSymmetrically = function(w, h)
  return function()
    grid.adjustWindow(
      function(cell)
        local max = grid.getGrid()

        if w ~= 0 and cell.w + (w * 2) >= 2 then
          if (cell.w + (w * 2)) <= max.w then
            cell.w = cell.w + (w * 2)
            cell.x = cell.x - w
          elseif cell.w + w == max.w then
            cell.w = max.w
            cell.x = 0
          end
        end

        if h ~= 0 and cell.h + (h * 2) >= 2 then
          if (cell.h + (h * 2)) <= max.h then
            cell.h = cell.h + (h * 2)
            cell.y = cell.y - h
          elseif cell.h + h == max.h then
            cell.h = max.h
            cell.y = 0
          end
        end
      end
    )
  end
end

-- moveWindowToSpace
---
-- Requires ctrl+<left>/<right> and ctrl+<num> system keybindings, originally
-- from:
-- https://github.com/Hammerspoon/hammerspoon/issues/235#issuecomment-101069303
wm.moveWindowToSpace = function(direction)
  return function()
    local mouseOrigin = mouse.absolutePosition()
    local win = window.focusedWindow()
    local clickPoint = win:zoomButtonRect()

    -- click and hold next to the zoom button close to the top of the window
    clickPoint.x = clickPoint.x + clickPoint.w + 2
    clickPoint.y = win:frame().y + 7

    local mouseClickEvent = eventtap.event.newMouseEvent(
      eventtap.event.types.leftMouseDown, clickPoint
    )
    mouseClickEvent:post()
    timer.usleep(150000)

    local nextSpaceDownEvent = eventtap.event.newKeyEvent(
      { "ctrl" }, direction, true
    )
    nextSpaceDownEvent:post()
    timer.usleep(150000)

    local nextSpaceUpEvent = eventtap.event.newKeyEvent(
      { "ctrl" }, direction, false
    )
    nextSpaceUpEvent:post()
    timer.usleep(150000)

    local mouseReleaseEvent = eventtap.event.newMouseEvent(
      eventtap.event.types.leftMouseUp, clickPoint
    )
    mouseReleaseEvent:post()
    timer.usleep(150000)

    mouse.absolutePosition(mouseOrigin)
  end
end

-- the end
return wm

local hyper = {'shift', 'cmd'}
local hyper2 = {'ctrl', 'cmd'}
local hyper3 = {'ctrl', 'alt', 'cmd'}
local hyper4 = {'ctrl', 'alt', 'shift'}

-- fullscreen
hs.hotkey.bind(hyper3,'M', function()
    local win = hs.window.focusedWindow()
    local screen = win:screen()
    local max = screen:frame()
    win:setFrame(max)
end)

-- left half screen
hs.hotkey.bind(hyper3,'Left', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

-- right half screen
hs.hotkey.bind(hyper3,'Right', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.w / 2
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

-- up half screen
hs.hotkey.bind(hyper3,'Up', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x
  f.y = max.y
  f.w = max.w 
  f.h = max.h / 2
  win:setFrame(f)
end)

-- down half screent
hs.hotkey.bind(hyper3,'Down', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x
  f.y = max.h / 2
  f.w = max.w 
  f.h = max.h
  win:setFrame(f)
  hs.alert.show("down half")
end)

-- upper left
hs.hotkey.bind(hyper4,'Left', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x
  f.y = max.y / 2
  f.w = max.w / 2
  f.h = max.h / 2
  win:setFrame(f)
end)

-- upper right
hs.hotkey.bind(hyper4,'Up', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.w / 2
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h / 2
  win:setFrame(f)
end)

-- down left
hs.hotkey.bind(hyper4,'Down', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x
  f.y = max.h / 2
  f.w = max.w / 2
  f.h = max.h / 2
  win:setFrame(f)
end)

-- down right
hs.hotkey.bind(hyper4,'Right', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.w / 2
  f.y = max.h / 2
  f.w = max.w / 2
  f.h = max.h / 2
  win:setFrame(f)
end)

hs.hotkey.bind(hyper, "Right", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

moveto = function(win, n)
  local screens = hs.screen.allScreens()
  if n > #screens then
    hs.alert.show("No enough screens " .. #screens)
  else
    local toWin = hs.screen.allScreens()[n]:name()
    hs.alert.show("Move " .. win:application():name() .. " to " .. toWin)

    hs.layout.apply({{nil, win:title(), toWin, hs.layout.maximized, nil, nil}})
    
  end
end
hs.hotkey.bind(hyper2, "1", function()
  local win = hs.window.focusedWindow()
  moveto(win, 1)
end)
hs.hotkey.bind(hyper2, "2", function()
  local win = hs.window.focusedWindow()
  moveto(win, 2)
end)
hs.hotkey.bind(hyper2, "3", function()
  local win = hs.window.focusedWindow()
  moveto(win, 3)
end)


hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
  hs.reload()
end)
hs.alert.show("Config loaded")

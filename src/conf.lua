git_hash,git_count = "missing git.lua",-1
pcall( function() return require("git") end );
game_scale = 2

function love.conf(t)
  t.identity = "DMOSS"
  t.window.width = 640
  t.window.height = 360
  t.window.title = "DMOSS"
  t.window.resizable = true
end

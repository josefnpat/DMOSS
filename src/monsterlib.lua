local monsterlib = {}

function monsterlib.new(init)
  init = init or {}
  local self = require("entitylib").new()

  self.getPerspectiveImage = monsterlib.getPerspectiveImage

  self._name = init.name

  self._images = {}
  local dir = "assets/monsters/"..self._name.."/"
  for i,perspective in pairs(love.filesystem.getDirectoryItems(dir)) do
    self._images[i] = love.graphics.newImage(dir..perspective)
  end

  return self
end

function monsterlib:getPerspectiveImage(pers)
  return self._images[pers]
end

return monsterlib

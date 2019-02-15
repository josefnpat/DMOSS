local tilelib = {}

function tilelib.new(init)
  init = init or {}
  local self = {}

  self.getType = tilelib.getType
  self.setType = tilelib.setType
  self._type = init.type

  self.getMonster = tilelib.getMonster
  self.setMonster = tilelib.setMonster
  self._monster = init.monster

  return self
end

function tilelib:getType()
  return self._type
end

function tilelib:setType(val)
  self._type = val
end

function tilelib:getMonster()
  return self._monster
end

function tilelib:setMonster(val)
  self._monster = val
end

return tilelib

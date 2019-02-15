local playerlib = {}

function playerlib.new(init)
  init = init or {}
  local self = {}

  self._map = init.map
  self._characters = init.characters

  self.getX = playerlib.getX
  self.setX = playerlib.setX
  self._x = init.x

  self.getY = playerlib.getY
  self.setY = playerlib.setY
  self._y = init.y

  self.getRotation = playerlib.getRotation
  self.setRotation = playerlib.setRotation
  self._rotation = init.rotation

  self.draw = playerlib.draw
  self.getPerspectiveVector = playerlib.getPerspectiveVector
  self.move = playerlib.move
  self.moveForward = playerlib.moveForward
  self.moveLeft = playerlib.moveLeft
  self.moveRight = playerlib.moveRight
  self.moveBackwards = playerlib.moveBackwards
  self.turnLeft = playerlib.turnLeft
  self.turnRight = playerlib.turnRight

  return self
end

function playerlib:getX()
  return self._x
end

function playerlib:setX(val)
  self._x = val
end

function playerlib:getY()
  return self._y
end

function playerlib:setY(val)
  self._y = val
end

function playerlib:getRotation()
  return self._rotation
end

function playerlib:setRotation(val)
  self._rotation = val
end

function playerlib:draw(x,y)
  for cx = 0,1 do
    for cy = 0,1 do
      local char_index = cx+cy*2+1
      local char = self._characters[char_index]
      if char then
        char:drawHud(x+cx*96,y+cy*96)
      else
        print('char_index:',char_index)
      end
    end
  end
  --[[
  for char_index,char in pairs(self._characters) do
    char:drawHud(coff,32)
    coff = coff + char:getWidth()
  end
  --]]
end

function playerlib:getPerspectiveVector(r)
  r = r or self._rotation
  local rotation = r%4
  if rotation == 0 then
    return 1,0
  elseif rotation == 1 then
    return 0,1
  elseif rotation == 2 then
    return -1,0
  elseif rotation == 3 then
    return 0,-1
  end
end

function playerlib:move(ox,oy)
  local tx,ty = self._x + ox, self._y + oy
  if self._map:getTile(tx,ty):getType() == 0 then
    self._x,self._y = tx,ty
  end
end

function playerlib:moveForward()
  self:move(self:getPerspectiveVector(self._rotation))
end

function playerlib:moveLeft()
  self:move(self:getPerspectiveVector(self._rotation-1))
end

function playerlib:moveRight()
  self:move(self:getPerspectiveVector(self._rotation+1))
end

function playerlib:moveBackwards()
  self:move(self:getPerspectiveVector(self._rotation+2))
end

function playerlib:turnLeft()
  self._rotation = (self._rotation - 1)%4
end

function playerlib:turnRight()
  self._rotation = (self._rotation + 1)%4
end

return playerlib

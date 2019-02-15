local mathlib = require"mathlib"
local tilelib = require"tilelib"

local maplib = {}

function maplib.new(init)
  init = init or {}
  local self = {}

  self.getTile = maplib.getTile
  self.setTile = maplib.setTile
  self.getTileFromPerspective = maplib.getTileFromPerspective

  self._data = {}
  for i,v in pairs(init.data) do
    self._data[i] = {}
    for j,value in pairs(v) do
      local tile
      if type(value) == "table" then
        tile = value
      elseif type(value) == "number" then
        tile = tilelib.new{
          type = value,
        }
      else
        print("warning: invalid tile type \""..type(value).."\"")
      end
      self._data[i][j] = tile
    end
  end
  return self
end

function maplib:getTile(x,y)
  return self._data[y] and self._data[y][x] or tilelib.new{type=0}
end

function maplib:setTile(x,y,val)
  self._data[x] = self._data[x] or {}
  self._data[x][y] = val
end

function maplib:getTileFromPerspective(player,distance,sideOffset)
  local pvx,pvy = player:getPerspectiveVector()
  local sx,sy = player:getPerspectiveVector(player:getRotation()+mathlib.sign(sideOffset))
  --print("pvx,y:",pvx,pvy)
  --print("player.x,y:",player:getX(),player:getY())
  --print("distance:",distance)
  local tx = pvx * distance + player:getX() + sx * math.abs(sideOffset)
  local ty = pvy * distance + player:getY() + sy * math.abs(sideOffset)
  --print("tx,y:",tx,ty)
  local tile = self:getTile(tx,ty)
  --print(tile)
  return tile
end

return maplib

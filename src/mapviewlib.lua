local mapviewlib = {}

mapviewlib.image = {
  player = love.graphics.newImage("assets/player.png"),
}

function mapviewlib.new(init)
  init = init or {}
  local self = {}

  self.drawTile = mapviewlib.drawTile
  self.draw = mapviewlib.draw
  self.update = mapviewlib.update

  self._map = init.map
  self._player = init.player

  return self
end

function mapviewlib:drawTile(dx,dy,x,y,rotation,asset,size)
  love.graphics.setColor(1,1,1)
  if type(asset) == "string" then
    love.graphics.printf(asset,dx+(x-1)*size,dy+(y-1)*size,size,"center")
  elseif type(asset) == "table" then -- assume tile
    local mode = asset:getType() == 0 and "line" or "fill"
    love.graphics.rectangle(mode,dx+(x-1)*size,dy+(y-1)*size,size,size)
    love.graphics.setColor(0,0,0)
    love.graphics.printf(asset:getType(),dx+(x-1)*size,dy+(y-1)*size,size,"center")
  elseif type(asset) == "userdata" then
    love.graphics.rectangle("line",dx+(x-1)*size,dy+(y-1)*size,size,size)
    local angle = math.pi/2*rotation
    local offset = size/2
    love.graphics.draw(
      asset,
      dx+(x-1)*size+offset,
      dy+(y-1)*size+offset,
      angle,
      1,1,
      offset,offset
    )
  else
    print('warning: unrenderable type "'..type(asset)..'"')
  end
end

--192x88
function mapviewlib:draw(dx,dy,horiz,vert)

  local size = 16
  horiz,vert = horiz or 3, vert or horiz or 3

  local offx = size/2
  local offy = size/2
  local px,py = self._player:getX(),self._player:getY()

  dx,dy = (dx or 0)+offx,(dy or 0)+offy

  for x = px-horiz,px+horiz do
    for y = py-vert,py+vert do
      local tile = self._map:getTile(x,y)
      self:drawTile(dx,dy,x-px,y-py,0,tile,size)
    end
  end

  self:drawTile(dx,dy,0,0,self._player:getRotation(),mapviewlib.image.player,size)

end

function mapviewlib:update(dt)
end

return mapviewlib

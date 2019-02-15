local dungeonviewlib = {}

dungeonviewlib.images = {
  background = love.graphics.newImage("assets/background.png"),
  tiles = {},
  tiles_map = {},
}

local walldir = "assets/walls/"
for _,walltype in pairs(love.filesystem.getDirectoryItems(walldir)) do
  local wall = {
    {
      pers=love.graphics.newImage(walldir..walltype.."/pers0.png"),
    },
    {
      pers=love.graphics.newImage(walldir..walltype.."/pers1.png"),
      front=love.graphics.newImage(walldir..walltype.."/front1.png"),
    },
    {
      pers=love.graphics.newImage(walldir..walltype.."/pers2.png"),
      front=love.graphics.newImage(walldir..walltype.."/front2.png"),
    },
    {
      pers=love.graphics.newImage(walldir..walltype.."/pers3.png"),
      front=love.graphics.newImage(walldir..walltype.."/front3.png"),
    },
    {
      pers=love.graphics.newImage(walldir..walltype.."/pers4.png"),
      front=love.graphics.newImage(walldir..walltype.."/front4.png"),
    },
  }
  if walltype == "debug" then
    dungeonviewlib.images.tile_debug = wall
  else
    table.insert(dungeonviewlib.images.tiles_map,wall)
  end
end

function dungeonviewlib.new(init)
  init = init or {}
  local self = {}

  self.getWalltype = dungeonviewlib.getWalltype
  self.draw = dungeonviewlib.draw
  self.update = dungeonviewlib.update
  self.getWidth = dungeonviewlib.getWidth
  self.getHeight = dungeonviewlib.getHeight

  self._map = init.map
  self._player = init.player

  self.getScale = dungeonviewlib.getScale
  self.setScale = dungeonviewlib.setScale
  self._scale = init.scale or 1

  self._renderCone = init.renderCone or {1,1,1,1,2}
  self._background = init.background or dungeonviewlib.images.background

  return self
end

function dungeonviewlib:getWalltype(tile,coneIndex)
  local walltype = dungeonviewlib.images.tile_debug[coneIndex]
  if tile == nil then
    return walltype
  end
  if dungeonviewlib.images.tiles_map[tile:getType()] then
    walltype = dungeonviewlib.images.tiles_map[tile:getType()][coneIndex]
  end
  return walltype
end

function dungeonviewlib:draw(rx,ry)
  local w,h = self._background:getWidth(),self._background:getHeight()
  local dx,dy = rx/game_scale+self._background:getWidth()/2,ry/game_scale

  love.graphics.setScissor(rx,ry,w*self._scale,h*self._scale)
  love.graphics.push()
  love.graphics.scale(self._scale)

  local flip = (self._player:getX() + self._player:getY() + self._player:getRotation() ) % 2 == 0

  if flip then
    love.graphics.draw(self._background,rx/game_scale,ry/game_scale)
  else
    love.graphics.draw(self._background,
      rx/game_scale+self._background:getWidth(),
      ry/game_scale,
      0,-1,1)
  end

  for coneIndex = #self._renderCone, 1, -1 do

    local coneValue = self._renderCone[coneIndex]

    for i = -coneValue,coneValue do

      local frontTile = self._map:getTileFromPerspective(player,coneIndex-1,i)
      local walltype = self:getWalltype(frontTile,coneIndex)

      if walltype then

        local ww,wh
        if walltype.front then
          ww,wh = walltype.front:getWidth(),walltype.front:getHeight()
          if frontTile:getType() ~= 0 then
            love.graphics.draw(walltype.front,dx-ww/2+ww*i,dy)
          end
          --love.graphics.rectangle("line",dx-ww/2+ww*i,dy,ww,wh)
        else
          ww,wh = self._background:getWidth(),self._background:getHeight()
        end

        if frontTile:getType() == 0 then

          if i <= 0 then
            local leftTile = self._map:getTileFromPerspective(player,coneIndex-1,i-1)
            local leftWalltype = self:getWalltype(leftTile,coneIndex)
            if leftTile:getType() ~= 0 then
              love.graphics.draw(leftWalltype.pers,
                dx-ww/2+ww*i,
                dy,
                0,1,1)
            end
          end

          if i >= 0 then
            local rightTile = self._map:getTileFromPerspective(player,coneIndex-1,i+1)
            local rightWalltype = self:getWalltype(rightTile,coneIndex)
            if rightTile:getType() ~= 0 then
              love.graphics.draw(rightWalltype.pers,
                dx+ww/2+ww*i,
                dy,
                0,-1,1)
            end
          end

          if frontTile:getMonster() then
            local image = frontTile:getMonster():getPerspectiveImage(coneIndex-1)
            if image then
              love.graphics.draw(image,
              dx+ww*i-image:getWidth()/2,
              dy)
            end
          end


        end

      end

    end

  end

  love.graphics.pop()
  love.graphics.setScissor()

end

function dungeonviewlib:update(dt)
end

function dungeonviewlib:getWidth()
  return self._background:getWidth()*self._scale
end

function dungeonviewlib:getHeight()
  return self._background:getHeight()*self._scale
end

function dungeonviewlib:getScale()
  return self._scale
end

function dungeonviewlib:setScale(val)
  self._scale = val
end

return dungeonviewlib

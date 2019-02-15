local characterlib = {}

function characterlib.new(init)
  init = init or {}
  local self = require("entitylib").new()

  self.drawVertBar = characterlib.drawVertBar
  self.drawHud = characterlib.drawHud
  self.getWidth = characterlib.getWidth
  self.getHeight = characterlib.getHeight

  self._avatar = init.avatar
  self._hudSize = init.hudSize or 96

  return self
end

function characterlib:drawVertBar(x,y,w,h,color,val,valMax)
  local ratio = val/valMax
  love.graphics.setColor(color)
  love.graphics.rectangle("fill",x,y+h*(1-ratio),w,h*ratio)
  love.graphics.setColor(1,1,1)
end

function characterlib:drawHud(x,y)
  local sx = self._hudSize/self._avatar:getWidth()
  local sy = self._hudSize/self._avatar:getHeight()
  love.graphics.draw(self._avatar,x,y,0,sx,sy)
  local barWidth = 12
  local bars = {
    {val=self._health,max=self._healthMax,color={1,0,0}},
    {val=self._stamina,max=self._staminaMax,color={0,1,0}},
    {val=self._mana,max=self._manaMax,color={0,0,1}},
  }
  for i,bar in pairs(bars) do
    self:drawVertBar(
      x+self._hudSize-barWidth*(#bars-i+1),
      y,
      barWidth,
      self._hudSize,
      bar.color,
      bar.val,bar.max)
  end
  --self:drawVertBar(x,y+128+16,self:getWidth(),{0,1,0,0.5},self._stamina,self._staminaMax)
  --self:drawVertBar(x,y+128+32,self:getWidth(),{0,0,1,0.5},self._mana,self._manaMax)
  love.graphics.rectangle("line",x,y,self._hudSize,self._hudSize)
end

function characterlib:getWidth()
  return self._hudSize
end

function characterlib:getHeight()
  return self._hudSize+16*3
end

return characterlib

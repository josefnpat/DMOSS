local entitylib = {}

function entitylib.new(init)
  init = init or {}
  local self = {}

  self._health = init.health or 100
  self._healthMax = init.healthMax or self._health
  self._stamina = init.stamina or 10
  self._staminaMax = init.staminaMax or self._stamina
  self._mana = init.mana or 10
  self._manaMax = init.manaMax or self._mana

  self._health = math.random(1,self._healthMax)
  self._stamina = math.random(1,self._staminaMax)
  self._mana = math.random(1,self._manaMax)


  return self
end

return entitylib

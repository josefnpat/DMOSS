local mathlib = {}

function mathlib.sign(x)
  return x>0 and 1 or x<0 and -1 or 0
end

return mathlib

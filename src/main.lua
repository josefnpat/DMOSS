io.stdout:setvbuf("no")
love.graphics.setDefaultFilter("nearest","nearest")

playerlib = require"playerlib"
maplib = require"maplib"
dungeonviewlib = require"dungeonviewlib"
mapviewlib = require"mapviewlib"
characterlib = require"characterlib"
monsterlib = require"monsterlib"
loglib = require"loglib"

function love.load()

  love.graphics.setFont(love.graphics.newFont("assets/fonts/VT323-Regular.ttf",18))

  background = love.graphics.newImage("assets/fullbackground.png")

  local map = maplib.new{
    data = {
      {1,1,1,1,1,1,1,1,1,1},
      {1,2,0,0,0,0,0,0,0,1},
      {1,0,0,0,0,0,0,0,0,1},
      {1,0,0,0,0,9,0,1,0,1,1,1,1,1,1,1,1},
      {1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1},
      {1,0,0,0,0,0,0,1,0,0,1,1,0,1,1,0,1},
      {1,1,0,0,1,1,0,1,0,1,0,0,1,0,0,0,0},
      {1,1,0,1,0,1,0,0,0,1},
      {1,1,0,0,0,1,0,0,0,1},
      {1,1,0,1,1,1,1,1,1,1},
      {1,0,0,1,0,0,0,0,0,1},
      {1,0,1,1,0,0,0,1,0,1},
      {1,0,0,0,0,0,0,0,0,1},
      {1,1,1,1,1,1,1,1,1,1},
    },
  }

  local monsters = {}
  for monster_index,monster_name in pairs(love.filesystem.getDirectoryItems("assets/monsters")) do
    local monster = monsterlib.new{
      name=monster_name,
    }
    local x,y = 3+monster_index,2
    local tile = map:getTile(x,y)
    if tile then
      tile:setMonster(monster)
    else
      print("warning: unknown tile at "..x..","..y)
    end
  end

  local characters = {}
  local char_assets = "assets/characters/"
  for _,char_asset in pairs(love.filesystem.getDirectoryItems(char_assets)) do
    local char = characterlib.new{
      avatar = love.graphics.newImage(char_assets..char_asset),
    }
    table.insert(characters,char)
  end

  player = playerlib.new{
    x = 3,
    y = 3,
    rotation = 0,
    map = map,
    characters = characters,
  }

  dungeonview = dungeonviewlib.new{
    map = map,
    player = player,
    scale = game_scale,
  }

  mapview = mapviewlib.new{
    map = map,
    player = player,
  }

  log = loglib.new{}

  log:add("You have entered herm's scary dungeon.")
  log:add("You hear the moan of a monster.")

end

function love.draw()
  love.graphics.draw(background)
  dungeonview:draw(0,0)
    --(love.graphics.getWidth()-dungeonview:getWidth())/2,
    --(love.graphics.getHeight()-dungeonview:getHeight())/2)
  local mw,mh = 192,88
  local mx,my = dungeonview:getWidth()+mw/2,dungeonview:getHeight()+mh/2
  mapview:draw(mx,my,5,2)
  player:draw(dungeonview:getWidth(),0)
  log:draw(
    0,
    dungeonview:getHeight(),
    dungeonview:getWidth(),
    love.graphics.getHeight()-dungeonview:getHeight())
end

function love.update(dt)
  dungeonview:update(dt)
  mapview:update(dt)
end

function love.keypressed(key)
  if key == "w" then
    player:moveForward()
  elseif key == "a" then
    player:moveLeft()
  elseif key == "d" then
    player:moveRight()
  elseif key == "s" then
    player:moveBackwards()
  elseif key == "q" then
    player:turnLeft()
  elseif key == "e" then
    player:turnRight()
  elseif key == "-" then
    game_scale = math.max(1,game_scale-1)
    dungeonview:setScale(game_scale)
  elseif key == "=" then
    game_scale = game_scale + 1
    dungeonview:setScale(game_scale)
  end
end

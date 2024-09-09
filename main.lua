local anim8 = require "lib.anim8"
local sti = require "lib.sti"
local camera = require "lib.camera"
local player = require "player"
local enemy = require "enemy"

local grid
local cam = camera()
local platforms = {}

love.load = function ()
  World = love.physics.newWorld(0,500,false) -- platformers need a gravity - y - value like sup.mario it's always applied
  load_map()
  Sprites= {}
  Sprites.player_sheet = love.graphics.newImage('sprites/playerSheet.png')

  -- grid is we split sprite sheet into individual image
  -- arg_1 : the width of each image on the sprite sheet - the width of this one is 9210 divided by 15 numb of image per columun
  -- arg_2 : the height  of each image on the sprite sheet - the width of this one is 1692 divided by 3 numb of rows
  grid = anim8.newGrid(614,564,Sprites.player_sheet:getWidth(),Sprites.player_sheet:getHeight())

  -- arg_1 : column and row included in this animation
  -- arg_2 : time between each frame ,i.e: how fast we want this animation to run
  -- follow up : each frame of the image gonna stick for X seconds
  Animations  = {}
  Animations.idle = anim8.newAnimation(grid('1-15',1),0.05)
  Animations.jump = anim8.newAnimation(grid('1-7',2),0.05)
  Animations.run = anim8.newAnimation(grid('1-15',3),0.05)

  player:load()
  enemy:load(1100,384)
end

love.update = function (dt)
  World:update(dt)
  GameMap:update(dt)
  -- World:setCallbacks(begin_contact,end_contact,pre_solve,post_solve)
  player:update(dt)
  enemy:update(dt)

  cam:lookAt(player.body:getX(),love.graphics.getHeight()/2)
end

love.draw = function ()
  cam:attach()
    GameMap:drawLayer(GameMap.layers['Tile Layer 1'])
    player:draw()
    enemy:draw()
    love.graphics.polygon("line",player.body:getWorldPoints(player.shape:getPoints()))
    for _, p in pairs(platforms) do
      love.graphics.polygon("line",p.body:getWorldPoints(p.shape:getPoints()))
    end
  cam:detach()



end

love.keypressed = function (key) -- pressed once
  if key == "up" and player.grounded then
      player.body:applyLinearImpulse(0,-2000)
  end
end

begin_contact = function (a,b,col)
  player.begin_contact(a,b,col)
end

end_contact = function (a,b,col)
  player.end_contact(a,b,col)
end

function queryBoxArea(x1,y1,x2,y2,collider)
  -- local col_1,col_2 = table.unpack(colliders)
  local colls = {}
  local function callback(fixture)
    if fixture:getUserData() == collider then
      table.insert(colls,fixture:getUserData())
    end
    return true
  end
  World:queryBoundingBox(x1,y1,x2,y2,callback) --
  return colls
end

function spawn_platform(x,y,width,height)
  local platform = {}
  if width > 0 and height > 0 then
    platform.body = love.physics.newBody(World,x,y,"static") -- not affected by gravity
    --- we change the origin to upper left because that's where tile draw to change that Maybe change H.O & V.O in Tile Layer
    platform.shape = love.physics.newRectangleShape(width/2,height/2,width,height)
    platform.fixture = love.physics.newFixture(platform.body,platform.shape)
    platform.fixture:setUserData("platform")

    table.insert(platforms,platform)
  end
end

function load_map()
  GameMap = sti("map/level_1.lua")
  for _, object in pairs(GameMap.layers['platforms'].objects) do
    spawn_platform(object.x,object.y,object.width,object.height)
  end
end

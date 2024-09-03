local anim8 = require "lib.anim8"

local world
local grid
local player = {}
local wall = {}
local sprites={}
local animations = {}

love.load = function ()
  world = love.physics.newWorld(0,500,false) -- platformers need a gravity - y - value like sup.mario it's always applied

  sprites.player_sheet = love.graphics.newImage('sprites/playerSheet.png')

  -- grid is we split sprite sheet into individual image
  -- arg_1 : the width of each image on the sprite sheet - the width of this one is 9210 divided by 15 numb of image per columun
  -- arg_2 : the height  of each image on the sprite sheet - the width of this one is 1692 divided by 3 numb of rows
  grid = anim8.newGrid(614,564,sprites.player_sheet:getWidth(),sprites.player_sheet:getHeight())

  -- arg_1 : column and row included in this animation
  -- arg_2 : time between each frame ,i.e: how fast we want this animation to run
  -- follow up : each frame of the image gonna stick for X seconds
  animations.idle = anim8.newAnimation(grid('1-15',1),0.05)
  animations.jump = anim8.newAnimation(grid('1-7',2),0.05)
  animations.run = anim8.newAnimation(grid('1-15',3),0.05)

  player.body = love.physics.newBody(world,300,100,"dynamic")
  player.shape = love.physics.newRectangleShape(0,0,50,50) -- x,y  within the body -up-
  player.fixture = love.physics.newFixture(player.body,player.shape)
  player.body:setFixedRotation(true) -- so the player doesn't rotate when leaving the platform
  player.fixture:setUserData("player")
  player.animation = animations.idle

  wall.body = love.physics.newBody(world,300,300,"static") -- not affected by gravity
  wall.shape = love.physics.newRectangleShape(0,0,200,50) -- x,y  within the body -up-
  wall.fixture = love.physics.newFixture(wall.body,wall.shape)
  wall.fixture:setUserData("wall")
end

love.update = function (dt)
  world:update(dt)
  world:setCallbacks(begin_contact,end_contact,pre_solve,post_solve)

  local px,py = player.body:getPosition()
  if love.keyboard.isDown("right") then
    player.body:setX(px + 100*dt)
  end
  if love.keyboard.isDown("left") then
    player.body:setX(px - 100*dt)
  end

  if love.keyboard.isDown("space") then
    local x1,x2,y1,y2 = player.fixture:getBoundingBox()
  end

  player.animation:update(dt)
end

love.draw = function ()
  -- scale (sx,sy) is by percentage
  player.animation:draw(sprites.player_sheet,10,10,nil,0.25)

  -- love.graphics.polygon("line",player.body:getWorldPoints(player.shape:getPoints()))
  -- love.graphics.polygon("fill",wall.body:getWorldPoints(wall.shape:getPoints()))
end

love.keypressed = function (key) -- pressed once
  if key == "up" then
    -- we want to query right underneath the player to see if he can jump (grounded)
    local data = queryBoxArea(world,player.body:getX(),player.body:getY(),player.body:getX()+50,player.body:getY()+50,"wall")
    if #data > 0 then
      player.body:applyLinearImpulse(0,-1000)
    end
  end
end

begin_contact = function (a,b,col) -- gets called when two fixtures start overlapping (two objects collide).

  local x,y = col:getNormal()
  --print("collision between "..a:getUserData().." and "..b:getUserData().." with vector normal of x:"..x..",y:"..y)
end

end_contact = function (a,b,col) -- gets called when two fixtures stop overlapping (two objects disconnect).

  --print("end of collision between"..a:getUserData().." and "..b:getUserData())
end

pre_solve = function (a,b,col) --  is called just before a frame is resolved for a current collision (while the objects are touching)
  --print("object "..a:getUserData().." and "..b:getUserData().." are touching ")
end

post_solve = function (a,b,col) -- is called just after a frame is resolved for a current collision.

end

function queryBoxArea(world,x1,y1,x2,y2,collider)
  -- local col_1,col_2 = table.unpack(colliders)
  local colls = {}
  local function callback(fixture)
    if fixture:getUserData() == collider then
      table.insert(colls,fixture:getUserData())
    end
    return true
  end
  world:queryBoundingBox(x1,y1,x2,y2,callback) --
  return colls
end

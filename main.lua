local world
local player = {}
local wall = {}

love.load = function ()
  world = love.physics.newWorld(0,500,false) -- platformers need a gravity - y - value like sup.mario it's always applied

  player.body = love.physics.newBody(world,300,100,"dynamic")
  player.shape = love.physics.newRectangleShape(0,0,50,50) -- x,y  within the body -up-
  player.fixture = love.physics.newFixture(player.body,player.shape)
  player.body:setFixedRotation(true) -- so the player doesn't rotate when leaving the platform
  player.fixture:setUserData("player")

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
end

love.draw = function ()
  love.graphics.polygon("line",player.body:getWorldPoints(player.shape:getPoints()))
  love.graphics.polygon("fill",wall.body:getWorldPoints(wall.shape:getPoints()))
end

love.keypressed = function (key) -- pressed once
  if key == "up" then
    player.body:applyLinearImpulse(0,-1000) -- be aware of the double/infinit jumps
  end
end

begin_contact = function (a,b,col) -- gets called when two fixtures start overlapping (two objects collide).

  local x,y = col:getNormal()
  print("collision between "..a:getUserData().." and "..b:getUserData().." with vector normal of x:"..x..",y:"..y)
end

end_contact = function (a,b,col) -- gets called when two fixtures stop overlapping (two objects disconnect).

  print("end of collision between"..a:getUserData().." and "..b:getUserData())
end

pre_solve = function (a,b,col) --  is called just before a frame is resolved for a current collision (while the objects are touching)
   print("object "..a:getUserData().." and "..b:getUserData().." are touching ")
end

post_solve = function (a,b,col) -- is called just after a frame is resolved for a current collision.

end

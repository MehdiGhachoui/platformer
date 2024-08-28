local world
local player = {}
local wall = {}
love.load = function ()
  world = love.physics.newWorld(0,500) -- platformers need a gravity - y - value like sup.mario it's always applied

  player.body = love.physics.newBody(world,300,100,"dynamic")
  player.shape = love.physics.newRectangleShape(0,0,50,50) -- x,y  within the body -up-
  player.fixture = love.physics.newFixture(player.body,player.shape)

  wall.body = love.physics.newBody(world,300,300,"static") -- not affected by gravity
  wall.shape = love.physics.newRectangleShape(0,0,200,50) -- x,y  within the body -up-
  wall.fixture = love.physics.newFixture(wall.body,wall.shape)
end

love.update = function (dt)
  world:update(dt)

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

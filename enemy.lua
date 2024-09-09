local Enemy = {}

function Enemy:load(x,y)
  self.body = love.physics.newBody(World,x,y,"dynamic")
  self.shape = love.physics.newRectangleShape(70,90) -- only  need the width and height , create the offset at center
  self.fixture = love.physics.newFixture(self.body,self.shape)
  self.fixture:setUserData('enemy')
  self.body:setFixedRotation(true) -- so the self doesn't rotate when leaving the platform

  self.direction = 1
  self.speed = 10

  table.insert(Enemy,self)
end

function Enemy:update(dt)
    for _, e in ipairs(Enemy) do
    local ex,ey = e.body:getPosition()

    local data = queryBoxArea(ex+(35*e.direction) ,ey+40,ex+(40*e.direction),ey+45,"platform")
    if #data == 0 then
      e.direction = e.direction * -1
    end

    e.body:setX(ex+e.speed*dt*e.direction)
  end
end


function Enemy:draw()
  love.graphics.polygon('line',self.body:getWorldPoints(self.shape:getPoints()))
end


return Enemy

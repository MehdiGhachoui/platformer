local Enemy = {}

function Enemy:load(x,y)
  self.body = love.physics.newBody(World,x,y,"dynamic")
  self.shape = love.physics.newRectangleShape(70,90) -- only  need the width and height , create the offset at center
  self.fixture = love.physics.newFixture(self.body,self.shape)
  self.fixture:setUserData('enemy')
  self.body:setFixedRotation(true) -- so the self doesn't rotate when leaving the platform

  self.direction = 1
  self.speed = 100
  self.animation = Animations.enemy

  table.insert(Enemy,self)
end

function Enemy:update(dt)
    print(#self)
    for _, e in ipairs(self) do
      e.animation:update(dt)

      local ex,ey = e.body:getPosition()
      local data = queryBoxArea(ex+(35*e.direction) ,ey+40,ex+(40*e.direction),ey+45,"platform")
      if #data == 0 then
        e.direction = e.direction * -1
      end

      e.body:setX(ex+e.speed*dt*e.direction)
  end
end


function Enemy:draw()
    for _, e in ipairs(self) do
      local ex,ey = e.body:getPosition()
      e.animation:draw(Sprites.enemy_sheet,ex,ey,nil,e.direction,1,50,65)
      love.graphics.polygon('line',e.body:getWorldPoints(e.shape:getPoints()))
    end
end


return Enemy

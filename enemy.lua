local Enemy = {}

function Enemy:load(x,y)
  local enemy = setmetatable({},Enemy)
  enemy.body = love.physics.newBody(World,x,y,"dynamic")
  enemy.shape = love.physics.newRectangleShape(70,90) -- only  need the width and height , create the offset at center
  enemy.fixture = love.physics.newFixture(enemy.body,enemy.shape)
  enemy.fixture:setUserData('enemy')
  enemy.body:setFixedRotation(true) -- so the enemy doesn't rotate when leaving the platform

  enemy.direction = 1
  enemy.speed = 100
  enemy.animation = Animations.enemy

  table.insert(Enemy,enemy)
end

function Enemy:update(dt)
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
      -- love.graphics.polygon('line',e.body:getWorldPoints(e.shape:getPoints()))
    end
end


return Enemy

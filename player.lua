local Player = {}


function Player:setPosition(x,y)
  Player.x = x
  Player.y = y
end

function Player:load()
  self.body = love.physics.newBody(World,self.x,self.y,"dynamic")
  self.shape = love.physics.newRectangleShape(50,100) -- only  need the width and height , create the offset at center
  self.fixture = love.physics.newFixture(self.body,self.shape)
  self.body:setFixedRotation(true) -- so the self doesn't rotate when leaving the platform
  self.fixture:setUserData("player")

  self.animation = Animations.idle
  self.direction = 1
  self.isMoving = false
  self.grounded = true
end

function Player:update(dt)
  self.isMoving = false

  -- we want to query right underneath the player to see if he can jump (grounded)
  local data = queryBoxArea(self.body:getX()-25,self.body:getY()+50,self.body:getX()+25,self.body:getY()+50,"platform") -- offset already at the center
  if #data > 0 then
    self.grounded = true
  else
    self.grounded = false
  end
  local px,py = self.body:getPosition()
  if love.keyboard.isDown("right") then
    self.body:setX(px + 300*dt)
    self.direction = 1
    self.isMoving = true
  end
  if love.keyboard.isDown("left") then
    self.body:setX(px - 300*dt)
    self.direction = -1
    self.isMoving = true
  end

  if self.grounded then
    if self.isMoving then
      self.animation = Animations.run
    else
      self.animation = Animations.idle
    end
  else
    self.animation = Animations.jump
  end


  self.animation:update(dt)
end


function Player:draw()
  local px,py = self.body:getPosition()
  -- scale (sx,sy) is by percentage
  self.animation:draw(Sprites.player_sheet,px,py,nil,0.25*self.direction,0.25,130,300)
end

Player.begin_contact= function(a,b,col) -- gets called when two fixtures start overlapping (two objects collide).

  -- local x,y = col:getNormal()
  --print("collision between "..a:getUserData().." and "..b:getUserData().." with vector normal of x:"..x..",y:"..y)
end

Player.end_contact = function (a,b,col) -- gets called when two fixtures stop overlapping (two objects disconnect).

  --print("end of collision between"..a:getUserData().." and "..b:getUserData())
end

Player.pre_solve = function (a,b,col) --  is called just before a frame is resolved for a current collision (while the objects are touching)
  --print("object "..a:getUserData().." and "..b:getUserData().." are touching ")
end

Player.post_solve = function (a,b,col) -- is called just after a frame is resolved for a current collision.

end

return Player



local function drawBody(world)
  for _, body in pairs(world:getBodies()) do
    for _, fixture in pairs(body:getFixtures()) do
        local shape = fixture:getShape()

        if shape:typeOf("CircleShape") then
            local cx, cy = body:getWorldPoints(shape:getPoint())
            love.graphics.circle("line", cx, cy, shape:getRadius())
        elseif shape:typeOf("PolygonShape") then
            love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
        else
            love.graphics.line(body:getWorldPoints(shape:getPoints()))
        end
    end
  end
end

local function drawContact(world)
   for _, contact in pairs(world:getContacts()) do
      local x1, y1, x2, y2 = contact:getPositions()
      if x1 then
          love.graphics.rectangle('line', x1, y1, 30, 30)
      end
      if x2 then
          love.graphics.rectangle('line', x2, y2, 30, 30)
      end
    end
end

return function ()
  return {
  drawBody = drawBody,
  drawContact = drawContact
}
end

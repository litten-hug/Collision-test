function love.load()
    Object = require "classic"
    require "entity"
    require "player"
    require "wall"
    require "box"

    player = Player(100, 100)
    wall = Wall(200, 100)
    box = Box(400, 150)

    objects = {}
    table.insert(objects, player)
    table.insert(objects, wall)
    table.insert(objects, box)
end

function love.update(dt)
    for i, object in pairs(objects) do
        object:update(dt)
    end

    for i=1,#objects-1 do
        for j=i+1,#objects do
            objects[i]:resolveCollision(objects[j])
        end
    end
end

function love.draw()
    for i, object in pairs(objects) do
        object:draw()
    end
end
function love.load()
    Object = require "classic"
    require "entity"
    require "player"
    require "wall"
    require "box"

    objects = {
        Player(100, 100),
        Wall(200, 100),
        Box(400, 150),
    }
end

function love.update(dt)
    for i, object in pairs(objects) do
        object:update(dt)
    end

    local loop = true
    local limit = 0

    while loop do
        loop = false
        limit = limit + 1
        if limit > 100 then
            break
        end

        for i=1,#objects-1 do
            for j=i+1,#objects do
                loop = objects[i]:resolveCollision(objects[j])
            end
        end
    end
end

function love.draw()
    for i, object in pairs(objects) do
        object:draw()
    end
end
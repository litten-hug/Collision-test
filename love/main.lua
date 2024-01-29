function love.load()
    Object = require "classic"
    require "entity"
    require "player"
    require "wall"
    require "box"

    objects = {
        Player(100, 100),
        Box(400, 150),
    }

    walls = {}

    map = {
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1},
        {1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
    }

    for i,v in ipairs(map) do
        for j,w in ipairs(v) do
            if w == 1 then
                table.insert(walls, Wall((j-1)*50, (i-1)*50))
            end
        end
    end
end

function love.update(dt)
    for i, object in pairs(objects) do
        object:update(dt)
    end

    for i,wall in ipairs(walls) do
        wall:update(dt)
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
        for i,wall in ipairs(walls) do
            for j,object in ipairs(objects) do
                loop = object:resolveCollision(wall)
            end
        end

    end

end

function love.draw()
    for i, object in pairs(objects) do
        object:draw()
    end

    for i,wall in ipairs(walls) do
        wall:draw()
    end
end
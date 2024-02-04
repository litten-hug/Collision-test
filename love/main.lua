function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    Object = require "classic"
    require "entity"
    require "player"
    require "wall"
    require "box"
    player = Player(100, 100)
    objects = {
        player, Box(400, 150)
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

function love.keypressed(key)
    if key == "space" then
        player:jump()
    end
end

function love.update(dt)
    for i, object in pairs(objects) do
        object:update(dt)
    end

    for i,wall in ipairs(walls) do
        wall:update(dt)
    end

    local keepChecking = true
    local limit = 0

    while keepChecking do
        keepChecking = false
        limit = limit + 1
        if limit > 100 then
            break
        end

        for i=1,#objects-1 do
            for j=i+1,#objects do
                keepChecking = objects[i]:resolveCollision(objects[j])
            end
        end
        for i,wall in ipairs(walls) do
            for j,object in ipairs(objects) do
                keepChecking = keepChecking or object:resolveCollision(wall)
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
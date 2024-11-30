function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    Object = require "code/classic"
    require "code/entity"
    require "code/player"
    require "code/wall"
    require "code/background"
    require "code/box"
    require "code/platform"
    require "code/roomWarp"
    player = Player(100, 100)
    objects = {
        player, Box(500, 150)
    }

    walls = {}

    map1 = {
        {2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 4, 9},
        {2, 0, 0, 0, 0, 4, 4, 0, 0, 0, 0, 0, 0, 3, 3, 2, 0},
        {2, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 3, 3, 2, 0},
        {2, 0, 0, 0, 0, 2, 2, 0, 0, 1, 1, 1, 1, 1, 1, 4, 0},
        {2, 0, 0, 0, 0, 2, 2, 0, 0, 3, 3, 3, 3, 3, 3, 2, 0},
        {2, 4, 4, 4, 4, 2, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0}
    }

    map2 = {
        {2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2}
    }

    drawMap(map1)
end

function drawMap(map)
    for i,v in ipairs(map) do
        for j, wallType in ipairs(v) do
            if wallType > 0 then
                if wallType == 3 then
                    table.insert(walls, Background((j-1)*50, (i-1)*50, wallType))
                elseif wallType == 1 then
                    table.insert(walls, Platform((j-1)*50, (i-1)*50, wallType))
                elseif wallType == 2 or wallType == 4 then
                    table.insert(walls, Wall((j-1)*50, (i-1)*50, wallType))
                elseif wallType == 9 then
                    table.insert(walls, Warp((j-1)*50, (i-1)*50, wallType))
                end
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
                collision = objects[i]:resolveCollision(objects[j])
                if collision then
                    keepChecking = true
                end
            end
        end
        for i,wall in ipairs(walls) do
            for j,object in ipairs(objects) do
                collision = object:resolveCollision(wall)
                if collision then
                    keepChecking = true
                end
            end
        end

    end

end

function love.draw()
    for i,wall in ipairs(walls) do
        wall:draw()
    end

    for i, object in pairs(objects) do
        object:draw()
    end
end
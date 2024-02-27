Entity = Object:extend()

function Entity:new(x, y, image_path, imageScale)
    self.imageScale = imageScale
    self.x = x
    self.y = y
    self.image = love.graphics.newImage(image_path)
    self.width = self.image:getWidth() * self.imageScale
    self.height = self.image:getHeight() * self.imageScale

    self.last = {}
    self.last.x = self.x
    self.last.y = self.y

    self.strength = 0
    self.tempStrength = 0
    self.gravity = 0
    self.weight = 400
end

function Entity:update(dt)
    self.last.x = self.x
    self.last.y = self.y
    self.tempStrength = self.strength
    self.gravity = self.gravity + self.weight * dt * 2
    self.y = self.y + self.gravity * dt
end

function Entity:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, self.imageScale, self.imageScale)
end

function Entity:checkCollision(other)
    return self.x + self.width > other.x
    and self.x < other.x + other.width
    and self.y + self.height > other.y
    and self.y < other.y + other.height
end

function Entity:wasVerticallyAligned(other)
    return self.last.y < other.last.y + other.height and self.last.y + self.height > other.last.y
end

function Entity:wasHorizontallyAligned(other)
    return self.last.x < other.last.x + other.width and self.last.x + self.width > other.last.x
end

function Entity:resolveCollision(other)
    if self.tempStrength > other.tempStrength then
        return other:resolveCollision(self)
    end
    if self:checkCollision(other) then
        self.tempStrength = other.tempStrength
        if self:wasVerticallyAligned(other) then
            if self.x + self.width/2 < other.x + other.width/2 then
                -- TODO: add this check on the other 3 directions
                if self:shouldCollideWith(other, "left") and other:shouldCollideWith(self, "right") then
                    self:collide(other, "left")
                end
            else
                -- here
                self:collide(other, "right")
            end
        elseif self:wasHorizontallyAligned(other) then
            if self.y + self.height/2 < other.y + other.height/2 then
                -- here
                self:collide(other, "above")
            else
                -- and here
                self:collide(other, "below")
            end
        end
        return true
    end
    return false
end

function Entity:shouldCollideWith(other, fromDirection)
    return true
end

function Entity:collide(other, fromDirection)
    if fromDirection == "above" then
        local pushback = self.y + self.height - other.y
        self.y = self.y - pushback
        self.gravity = 0
    elseif fromDirection == "below" then
        local pushback = other.y + other.height - self.y
        self.y = self.y + pushback
    elseif fromDirection == "left" then
        local pushback = self.x + self.width - other.x
        self.x = self.x - pushback
    elseif fromDirection == "right" then
        local pushback = other.x + other.width - self.x
        self.x = self.x + pushback
    end
end
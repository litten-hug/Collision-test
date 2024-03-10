Player = Entity:extend()

function Player:new(x, y)
    Player.super.new(self, x, y, "assets/xavier_right.png", 5.5)
    self.strength = 50
    self.jumpsLeft = 2
end

function Player:update(dt)
    Player.super.update(self, dt)
    if love.keyboard.isDown("left", "a") then
        self.x = self.x - 200 * dt
        self.image = love.graphics.newImage("assets/xavier_left.png")
    elseif love.keyboard.isDown("right", "d") then
        self.x = self.x + 200 * dt
        self.image = love.graphics.newImage("assets/xavier_right.png")
    end
     self.y = self.y + 200 * dt
end

function Player:jump()
    if self.jumpsLeft > 0 then
        self.gravity = -700
        self.jumpsLeft = self.jumpsLeft - 1
    end
end

function Player:collideWithFloor()
    self.jumpsLeft = 2
end
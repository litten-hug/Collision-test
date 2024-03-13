Player = Entity:extend()

function Player:new(x, y)
    Player.super.new(self, x, y, "assets/xavier_right.png", 5.5)
    self.strength = 50
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
    self.gravity = -700
end
Player = Entity:extend()

function Player:new(x, y)
    Player.super.new(self, x, y, "assets/player.png")
    self.strength = 50
end

function Player:update(dt)
    Player.super.update(self, dt)
    if love.keyboard.isDown("left", "a") then
        self.x = self.x - 200 * dt
    elseif love.keyboard.isDown("right", "d") then
        self.x = self.x + 200 * dt
    end
     self.y = self.y + 200 * dt
end

function Player:jump()
    self.gravity = -700
end
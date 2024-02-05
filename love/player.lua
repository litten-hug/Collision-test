Player = Entity:extend()

function Player:new(x, y)
    Player.super.new(self, x, y, "assets/xavier_right.png", 5.5)
    self.strength = 50
    self.jumpsLeft = 2
    self.idleCount = 0
    self.currentFrame = 1
    self.idleFrames = {}
    for i = 1, 11 do
        table.insert(self.idleFrames, love.graphics.newImage("assets/Animations/Xavier_idle_Frame" .. i .. ".png"))
    end
end

function Player:update(dt)
    Player.super.update(self, dt)
    self.idleCount = self.idleCount + 1 * dt
    self.y = self.y + 200 * dt
    if love.keyboard.isDown("left", "a") then
        self.x = self.x - 200 * dt
        self.image = love.graphics.newImage("assets/xavier_left.png")
        self.idleCount = 0
        self.currentFrame = 1
    elseif love.keyboard.isDown("right", "d") then
        self.x = self.x + 200 * dt
        self.image = love.graphics.newImage("assets/xavier_right.png")
        self.idleCount = 0
        self.currentFrame = 1
    end
    if self.idleCount >= 3 then
        self.image = self.idleFrames[math.floor(self.currentFrame)]
        self.currentFrame = self.currentFrame + dt * 5
        if self.currentFrame > 12 then
          self.currentFrame = 1
          self.idleCount = 0
        end
    end
end

function Player:jump()
    if self.jumpsLeft > 0 then
        self.gravity = -700
        self.jumpsLeft = self.jumpsLeft - 1
        self.idleCount = 0
        self.currentFrame = 1
    end
end

function Player:collideWithFloor()
    self.jumpsLeft = 2
end
Player = Entity:extend()

function Player:new(x, y)
    Player.super.new(self, x, y, "assets/xavier_right.png", 5.5)
    self.strength = 50
    self.jumpsLeft = 2
    self.idleCount = 0
    self.currentFrame = 1
    self.facingRight = true
    self.rightIdleFrames = {}
    for i = 1, 11 do
        table.insert(self.rightIdleFrames, love.graphics.newImage("assets/Animations/xavier_rightIdle_Frame" .. i .. ".png"))
    end
    self.leftIdleFrames = {}
    for i = 1, 11 do
        table.insert(self.leftIdleFrames, love.graphics.newImage("assets/Animations/xavier_leftIdle_Frame" .. i .. ".png"))
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
        self.facingRight = false
    elseif love.keyboard.isDown("right", "d") then
        self.x = self.x + 200 * dt
        self.image = love.graphics.newImage("assets/xavier_right.png")
        self.idleCount = 0
        self.currentFrame = 1
        self.facingRight = true
    end
    if self.idleCount >= 3 then
        if self.facingRight == true then
            self.image = self.rightIdleFrames[math.floor(self.currentFrame)]
            self.currentFrame = self.currentFrame + dt * 5
            if self.currentFrame > 12 then
                self.currentFrame = 1
                self.idleCount = 0
            end
        elseif self.facingRight == false then
            self.image = self.leftIdleFrames[math.floor(self.currentFrame)]
            self.currentFrame = self.currentFrame + dt * 5
            if self.currentFrame > 12 then
                self.currentFrame = 1
                self.idleCount = 0
            end
        end
    end
end

function Player:jump()
    if self.jumpsLeft > 0 then
        self.gravity = -700
        self.jumpsLeft = self.jumpsLeft - 1
        self.idleCount = 0
        self.currentFrame = 1
        if self.facingRight == true then
            self.image = love.graphics.newImage("assets/xavier_right.png")
        elseif self.facingRight == false then
            self.image = love.graphics.newImage("assets/xavier_left.png")
        end
    end
end

function Player:collide(e, fromDirection)
    Player.super.collide(self, e, fromDirection)
    if fromDirection == "above" then
        self.jumpsLeft = 2
    end
end

function Player:shouldCollideWith(other, fromDirection)
    return not other:is(Background)
end
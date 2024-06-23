Player = Entity:extend()

function Player:new(x, y)
    Player.super.new(self, x, y, "assets/xavier_right.png", 5.5)
    self.state = "standing"
    self.facing = "right"
    self.strength = 50
    self.jumpsLeft = 2
    self.idleCount = 0
    self.currentIdleFrame = 1
    self.currentWalkingFrame = 1
    self.currentJumpingFrame = 1
    self.rightIdleFrames = {}
    for i = 1, 11 do
        table.insert(self.rightIdleFrames, love.graphics.newImage("assets/Animations/Idles/xavier_rightIdle_Frame" .. i .. ".png"))
    end
    self.leftIdleFrames = {}
    for i = 1, 11 do
        table.insert(self.leftIdleFrames, love.graphics.newImage("assets/Animations/Idles/xavier_leftIdle_Frame" .. i .. ".png"))
    end
    self.rightWalkingFrames = {}
    for i = 1, 16 do
        table.insert(self.rightWalkingFrames, love.graphics.newImage("assets/Animations/Walking/xavier_walkRight_frame" .. i .. ".png"))
    end
    self.leftWalkingFrames = {}
    for i = 1, 16 do
        table.insert(self.leftWalkingFrames, love.graphics.newImage("assets/Animations/Walking/xavier_walkLeft_frame" .. i .. ".png"))
    end
    self.leftJumpingFrames = {}
    for i = 1, 4 do
        table.insert(self.leftJumpingFrames, love.graphics.newImage("assets/Animations/Jumping/xavier_jumpLeft_frame" .. i .. ".png"))
    end
end

function Player:update(dt)
    Player.super.update(self, dt)
    self.idleCount = self.idleCount + 1 * dt
    self.y = self.y + 200 * dt
    if love.keyboard.isDown("left", "a") then
        self.state = "moving"
        self.facing = "left"
        self.x = self.x - 200 * dt
        self.image = self.leftWalkingFrames[math.floor(self.currentWalkingFrame)]
        self.currentWalkingFrame = self.currentWalkingFrame + dt * 20
        if self.currentWalkingFrame > 17 then
            self.currentWalkingFrame = 5
        end
        self.idleCount = 0
        self.currentIdleFrame = 1
    elseif self.state == "moving" and self.facing == "left" then
        self.state = "standing"
        self.image = love.graphics.newImage("assets/xavier_Left.png")
        self.currentWalkingFrame = 1
    end
    if love.keyboard.isDown("right", "d") then
        self.state = "moving"
        self.facing = "right"
        self.x = self.x + 200 * dt
        self.image = self.rightWalkingFrames[math.floor(self.currentWalkingFrame)]
        self.currentWalkingFrame = self.currentWalkingFrame + dt * 20
        if self.currentWalkingFrame > 17 then
            self.currentWalkingFrame = 5
        end
        self.idleCount = 0
        self.currentIdleFrame = 1
    elseif self.state == "moving" and self.facing == "right" then
        self.image = love.graphics.newImage("assets/xavier_Right.png")
        self.state = "standing"
        self.facing = "right"
        self.currentWalkingFrame = 1
    end
    if love.keyboard.isDown("down", "s") then
        self.image = love.graphics.newImage("assets/xavier_crouch"..self.facing..".png")
        self.idleCount = 0
        self.currentIdleFrame = 1
        self.state = "crouching"
    elseif self.state == "crouching" then
        self.image = love.graphics.newImage("assets/xavier_"..self.facing..".png")
        self.state = "standing"
    end
    if self.state == "standing" and self.idleCount >= 3 then
        if self.facing == "right" then
            self.image = self.rightIdleFrames[math.floor(self.currentIdleFrame)]
        elseif self.facing == "left" then
            self.image = self.leftIdleFrames[math.floor(self.currentIdleFrame)]
        end
        self.currentIdleFrame = self.currentIdleFrame + dt * 5
        if self.currentIdleFrame > 12 then
            self.currentIdleFrame = 1
            self.idleCount = 0
        end
    end
end

function Player:jump(dt)
    if self.jumpsLeft > 0 then
        self.gravity = -700
        self.jumpsLeft = self.jumpsLeft - 1
        self.idleCount = 0
        self.currentIdleFrame = 1
        self.image = love.graphics.newImage("assets/xavier_"..self.facing..".png")
        self.state = "jumping"
    end
end

function Player:shouldCollideWith(other, fromDirection)
    if other:is(Background) then
        return false
    end
    if other:is(Wall) then
        if fromDirection == "below" then
            self.gravity = self.gravity + 150
        end
        return true
    end
    if other:is(Platform) then
        return fromDirection == "above"
    end
    return true
end

function Player:collide(e, fromDirection)
    Player.super.collide(self, e, fromDirection)
    if fromDirection == "above" then
        self.jumpsLeft = 2
        if self.state == "jumping" then
            self.state = "standing"
        end
    end
end

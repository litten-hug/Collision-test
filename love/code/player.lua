require "code/frames"
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
    self.rightIdleFrames = Frames("Idles/xavier_rightIdle_Frame", {loopEnd = 15, animationSpeed = 10})
    self.leftIdleFrames = Frames("Idles/xavier_leftIdle_Frame", {loopEnd = 15, animationSpeed = 10})
    self.rightWalkingFrames = Frames("Walking/xavier_walkRight_frame", {loopStart = 5, loopEnd = 16, animationSpeed = 20})
    self.leftWalkingFrames = Frames("Walking/xavier_walkLeft_frame", {loopStart = 5, loopEnd = 16, animationSpeed = 20})
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
        self.state = "walking"
        self.facing = "left"
        self.x = self.x - 200 * dt
        self.leftWalkingFrames:update(dt)
        self.image = self.leftWalkingFrames:getFrame()
    elseif self.state == "walking" and self.facing == "left" then
        self:standStill()
    end
    if love.keyboard.isDown("right", "d") then
        self.state = "walking"
        self.facing = "right"
        self.x = self.x + 200 * dt
        self.rightWalkingFrames:update(dt)
        self.image = self.rightWalkingFrames:getFrame()
    elseif self.state == "walking" and self.facing == "right" then
        self:standStill()
    end
    if love.keyboard.isDown("down", "s") then
        self.image = love.graphics.newImage("assets/xavier_crouch"..self.facing..".png")
        self.state = "crouching"
        self.idleCount = 0
    elseif self.state == "crouching" then
        self.image = love.graphics.newImage("assets/xavier_"..self.facing..".png")
        self.state = "standing"
    end
    if self.state == "standing" and self.idleCount >= 3 then
        if self.facing == "right" then
            self.rightIdleFrames:update(dt)
            self.image = self.rightIdleFrames:getFrame()
            if self.rightIdleFrames:isLastFrame() then
                self.idleCount = 0
                self.rightIdleFrames:reset()
            end
        elseif self.facing == "left" then
            if self.leftIdleFrames:isLastFrame() then
                self.idleCount = 0
                self.leftIdleFrames:reset()
            end
            self.leftIdleFrames:update(dt)
            self.image = self.leftIdleFrames:getFrame()
        end
    end
end

function Player:standStill()
    self.state = "standing"
    self.image = love.graphics.newImage("assets/xavier_"..self.facing..".png")
    self.currentWalkingFrame = 1
    self.idleCount = 0
    self.currentIdleFrame = 1
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

function Player:collide(other, fromDirection)
    Player.super.collide(self, other, fromDirection)
    if fromDirection == "above" then
        self.jumpsLeft = 2
        if self.state == "jumping" then
            self.state = "standing"
        end
    end
end
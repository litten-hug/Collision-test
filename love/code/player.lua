Player = Entity:extend()

function Player:new(x, y)
    Player.super.new(self, x, y, "assets/xavier_right.png", 5.5)
    self.strength = 50
    self.jumpsLeft = 2
    self.idleCount = 0
    self.currentIdleFrame = 1
    self.currentWalkingFrame = 1
    self.facingRight = true
    self.crouching = false
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
end

function Player:update(dt)
    Player.super.update(self, dt)
    self.idleCount = self.idleCount + 1 * dt
    self.y = self.y + 200 * dt
    if love.keyboard.isDown("left", "a") then
        self.x = self.x - 200 * dt
        self.image = self.leftWalkingFrames[math.floor(self.currentWalkingFrame)]
        self.currentWalkingFrame = self.currentWalkingFrame + dt * 15
        if self.currentWalkingFrame > 17 then
            self.currentWalkingFrame = 5
        end
        self.idleCount = 0
        self.currentIdleFrame = 1
        self.facingRight = false
    elseif love.keyboard.isDown("right", "d") then
        self.x = self.x + 200 * dt
        self.image = self.rightWalkingFrames[math.floor(self.currentWalkingFrame)]
        self.currentWalkingFrame = self.currentWalkingFrame + dt * 15
        if self.currentWalkingFrame > 17 then
            self.currentWalkingFrame = 5
        end
        self.idleCount = 0
        self.currentIdleFrame = 1
        self.facingRight = true
    end
    if love.keyboard.isDown("down", "s") then
        if self.facingRight == true then
            self.image = love.graphics.newImage("assets/xavier_crouchRight.png")
        elseif self.facingRight == false then
            self.image = love.graphics.newImage("assets/xavier_crouchLeft.png")
        end
        self.idleCount = 0
        self.currentIdleFrame = 1
        self.crouching = true
    elseif self.crouching then
        if self.facingRight == true then
            self.image = love.graphics.newImage("assets/xavier_right.png")
        elseif self.facingRight == false then
            self.image = love.graphics.newImage("assets/xavier_left.png")
        end
        self.crouching = false
    end
    if self.idleCount >= 3 then
        if self.facingRight == true then
            self.image = self.rightIdleFrames[math.floor(self.currentIdleFrame)]
            self.currentIdleFrame = self.currentIdleFrame + dt * 5
            if self.currentIdleFrame > 12 then
                self.currentIdleFrame = 1
                self.idleCount = 0
            end
        elseif self.facingRight == false then
            self.image = self.leftIdleFrames[math.floor(self.currentIdleFrame)]
            self.currentIdleFrame = self.currentIdleFrame + dt * 5
            if self.currentIdleFrame > 12 then
                self.currentIdleFrame = 1
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
        self.currentIdleFrame = 1
        if self.facingRight == true then
            self.image = love.graphics.newImage("assets/xavier_right.png")
        elseif self.facingRight == false then
            self.image = love.graphics.newImage("assets/xavier_left.png")
        end
    end
end

function Player:shouldCollideWith(other, fromDirection)
    if other:is(Background) then
        return false
    end
    if other:is(Wall) then
        if fromDirection == "below" then
            return false
        elseif fromDirection == "left" then
            return false
        elseif fromDirection == "right" then
            return false
        elseif fromDirection == "above" then
            return true
        end
    end
    return true
end

function Player:collide(e, fromDirection)
    Player.super.collide(self, e, fromDirection)
    if fromDirection == "above" then
        self.jumpsLeft = 2
    end
end

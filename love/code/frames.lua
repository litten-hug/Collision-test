Frames = Object:extend()

function Frames:new(filePath, loopStart, loopEnd, animationSpeed)
    self.frames = {}
    self.currentFrame = 1
    self.animationSpeed = animationSpeed
    self.loopEnd = loopEnd
    self.loopStart = loopStart
    for i = 1, loopEnd do
        table.insert(self.frames, love.graphics.newImage("assets/Animations/" .. filePath .. i .. ".png"))
    end
end

function Frames:update(dt)
    self.currentFrame = self.currentFrame + dt * self.animationSpeed
    if self.currentFrame > self.loopEnd + 1 then
        self.currentFrame = self.loopStart
    end
end

function Frames:getFrame()
    return self.frames[math.floor(self.currentFrame)]
end

function Frames:isLastFrame()
    return self.currentFrame == self.loopEnd
end

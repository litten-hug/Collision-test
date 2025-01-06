Frames = Object:extend()

function Frames:new(filePath, options)
    if options.loopEnd == nil then
        error("loopEnd is manadatory")
    end
    self.loopEnd = options.loopEnd
    self.animationSpeed = options.animationSpeed or 5
    self.loopStart = options.loopStart or 1
    self.frames = {}
    self.currentFrame = 1
    for i = 1, self.loopEnd do
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
    return self.currentFrame >= self.loopEnd
end

function Frames:reset()
    self.currentFrame = self.loopStart
end

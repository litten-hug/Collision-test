Frames = Object:extend()

function Frames:new(file_path, loop_start, loop_end)
    self.frames = {}
    self.loop_end = loop_end
    self.loop_start = loop_start
    for i = 1, loop_end do
        table.insert(self.frames, love.graphics.newImage("assets/Animations/" .. file_path .. i .. ".png"))
    end
end

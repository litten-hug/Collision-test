Warp = Entity:extend()

function Warp:new(x, y, wallType)
    Warp.super.new(self, x, y, "assets/wall" .. wallType ..".png", 4.6)
    self.strength = 10,000,000,000
    self.weight = 0
end

function Warp:collide(other, fromDirection)
    self.sfx = love.audio.newSource("assets/audio/dry-fart.mp3", "static")
    self.sfx:play()
    drawMap(map2)
end


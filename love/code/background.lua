Background = Entity:extend()

function Background:new(x, y, wallType)
    Background.super.new(self, x, y, "assets/wall" .. wallType ..".png", 4.6)
    self.strength = 100
    self.weight = 0
end
Wall = Entity:extend()

function Wall:new(x, y)
    Wall.super.new(self, x, y, "assets/wall.png", 4.6)
    self.strength = 100
    self.weight = 0
end
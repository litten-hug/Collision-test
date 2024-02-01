Box = Entity:extend()

function Box:new(x, y)
    Box.super.new(self, x, y, "assets/box.png", 1)
    self.strength = 25
end
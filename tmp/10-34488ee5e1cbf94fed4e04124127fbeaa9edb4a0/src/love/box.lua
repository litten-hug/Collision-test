Box = Entity:extend()

function Box:new(x, y)
    Box.super.new(self, x, y, "assets/box.png", 5.5)
    self.strength = 25
end
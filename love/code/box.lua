Box = Entity:extend()

function Box:new(x, y)
    Box.super.new(self, x, y, "assets/box.png", 5.5)
    self.strength = 25
end

function Box:shouldCollideWith(other, fromDirection)
    if other:is(Background) then
        return false
    end
    if other:is(Platform) then
        if fromDirection == "above" then
            return true
        else
            return false
        end
    end
    if other:is(Wall) then
        return true
    end
    return true
end
-- This is `bounce.lua` from the "Are We Fast Yet" benchmark suite, merged into
-- one file so that it can be easily run and reduced.

local band = assert(load'--[[band]] return function (a, b) return a & b end')()

local Random = {_CLASS = 'Random'} do

function Random.new ()
    local obj = {seed = 74755}
    return setmetatable(obj, {__index = Random})
end

function Random:next ()
  self.seed = band(((self.seed * 1309) + 13849), 65535);
  return self.seed;
end

end -- class Random

local Ball = {_CLASS = 'Ball'} do
local abs = math.abs
function Ball.new (random)
    local obj = {
        x = random:next() % 500,
        y = random:next() % 500,
        x_vel = (random:next() % 300) - 150,
        y_vel = (random:next() % 300) - 150,
    }
    return setmetatable(obj, {__index = Ball})
end

function Ball:bounce ()
    local x_limit, y_limit = 500, 500
    local bounced = false
    self.x = self.x + self.x_vel
    self.y = self.y + self.y_vel
    if self.x > x_limit then
        self.x = x_limit
        self.x_vel = 0 - abs(self.x_vel)
        bounced = true
    end
    if self.x < 0 then
        self.x = 0
        self.x_vel = abs(self.x_vel)
        bounced = true
    end
    if self.y > y_limit then
        self.y = y_limit
        self.y_vel = 0 - abs(self.y_vel)
        bounced = true
    end
    if self.y < 0 then
        self.y = 0
        self.y_vel = abs(self.y_vel)
        bounced = true
    end
    return bounced
end

end -- class Ball

local bounce = {} do
setmetatable(bounce, {})

function bounce:benchmark ()
    local random     = Random.new()
    local ball_count = 100
    local bounces    = 0
    local balls      = {}

    for i = 1, ball_count do
        balls[i] = Ball.new(random)
    end

    for _ = 1, 50 do
        for i = 1, #balls do
            local ball = balls[i]
            if ball:bounce() then
                bounces = bounces + 1
            end
        end
    end
    return bounces
end

function bounce:verify_result (result)
    return 1331 == result
end

end -- object bounce

if #arg ~= 1 then
    print("usage: " .. arg[0] .. " <iterations>")
    os.exit(1)
end

for i = 1,tonumber(arg[1]) do
  bounce:verify_result(bounce:benchmark())
end

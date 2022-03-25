Paddle = Class{}

function Paddle:init(x, y, width , height)
    self.x = x;
    self.y = y;
    self.width = width;
    self.height = height;
    self.PADDLE_SPEED = 1000;
end

function Paddle:SetPaddleSpeed(PADDLE_SPEED)
    self.PADDLE_SPEED = PADDLE_SPEED;
end

function Paddle:InterActive(dt, key1, key2)
    if love.keyboard.isDown(key1) then
        self.y = math.max(0 ,self.y - (self.PADDLE_SPEED * dt))
    end
    if love.keyboard.isDown(key2) then
        self.y = math.min(1000, self.y + (self.PADDLE_SPEED * dt))
    end
end

function Paddle:reset()
    self.y = (WINDOW_HEIGHT - 80) / 2
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
ball = Class {}
function ball:init(x, y, width, height)
    self.BALL_X = x;
    self.BALL_Y = y;
    self.width = width;
    self.height = height;
    self.gameState = 'start';
    self.serve = 1;
    self.balldy = math.random(10, -14);
end

function ball:render()
    love.graphics.circle('fill', self.BALL_X, self.BALL_Y, self.width)
end

function ball:Move()
    if self.serve == 1 then
        self.balldx = math.random(10, 14)
    elseif self.serve == 2 then
        self.balldx = math.random(-10, -14)
    end
    if self.balldy == 0 then
        self.balldy = 10;
    end
    if self.gameState == 'play' then
        self.BALL_X = self.BALL_X + self.balldx;
        self.BALL_Y = self.BALL_Y + self.balldy;
    end
end

function ball:collides(Paddle)
    if self.BALL_X > Paddle.x + Paddle.width or self.BALL_X < Paddle.x then
        return false
    end
    if self.BALL_Y > Paddle.y + Paddle.height or self.BALL_Y < Paddle.y then
        return false
    end
    return true
end
function ball:reset()
    self.gameState = 'serve'
    -- Reseting The ball position
    self.BALL_X = (WINDOW_WIDTH - 80) / 2;
    self.BALL_Y = 653;

    -- Changing the balldx and balldy
    self.balldx = math.random(14, -14)
    self.balldy = math.random(7, -7)
end

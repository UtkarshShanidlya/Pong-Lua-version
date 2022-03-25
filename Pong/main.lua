push = require 'push'

Class = require 'Class'

require 'Paddle'

require 'Ball'

WINDOW_HEIGHT = 1280;
WINDOW_WIDTH = 1280;

PLAYER_1_SCORE = 0;
PLAYER_2_SCORE = 0;

Paddle2 = Paddle(15, (WINDOW_HEIGHT - 80) / 2, 12, 200)
Paddle1 = Paddle(1172, (WINDOW_HEIGHT - 80) / 2, 12, 200)

Ball = ball((WINDOW_WIDTH - 80) / 2, 653, 8);
function love.load()
    math.randomseed(os.time())
    Tamma = love.graphics.newFont('BalooTamma2-Regular.ttf', 70)
    SmallTamma = love.graphics.newFont('BalooTamma2-Regular.ttf', 35)
    LargeTamma = love.graphics.newFont('BalooTamma2-Regular.ttf', 200)
    love.graphics.setFont(Tamma)
    love.window.setTitle('Pong')
    push:setupScreen(WINDOW_HEIGHT - 80, WINDOW_WIDTH - 80, WINDOW_HEIGHT, WINDOW_WIDTH, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
    sounds = {
        ['Paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav','static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav','static')
    }
end

function love.update(dt)
    -- Paddle Movement
    Paddle1:InterActive(dt, 'up', 'down')
    Paddle2:InterActive(dt, 'w', 's')
    -- Ball Movement
    Ball:Move()
    if PLAYER_1_SCORE == 10 then
        Ball.gameState = 'victory2'
    elseif PLAYER_2_SCORE == 10 then
        Ball.gameState = 'victory'
    end
end
-- Printing hello Pong and the paddles and ball on the game
function love.draw()
    push:apply('start')
    -- Content Starts

    love.graphics.clear(5 / 255, 19 / 255, 46 / 255, 1)
    if Ball.gameState == 'start' then
        love.graphics.setFont(SmallTamma)
        love.graphics.printf('Hello Pong!', 0, 42, WINDOW_WIDTH - 80, 'center')
        love.graphics.printf('Press enter to continue', 0, 77, WINDOW_WIDTH - 80, 'center')
    elseif Ball.gameState == 'serve' then
        -- Printing The scores

        -- First Player's Score
        love.graphics.setFont(Tamma)
        love.graphics.print(tostring(PLAYER_1_SCORE), ((WINDOW_WIDTH - 80) / 5) - 100, 42)
        -- Second Player's Score
        love.graphics.print(tostring(PLAYER_2_SCORE), (((WINDOW_WIDTH - 80) / 5) * 4) + 60, 42)
        love.graphics.setFont(SmallTamma)
        if Ball.serve == 1 then
            love.graphics.printf('Player 1s serve', 0, 42, WINDOW_WIDTH - 80, 'center')
            love.graphics.printf('Press enter to continue', 0, 77, WINDOW_WIDTH - 80, 'center')
        else
            love.graphics.printf('Player 2s serve', 0, 42, WINDOW_WIDTH - 80, 'center')
            love.graphics.printf('Press enter to continue', 0, 77, WINDOW_WIDTH - 80, 'center')
        end
    elseif Ball.gameState == 'play' then
        -- Printing The scores

        -- First Player's Score
        love.graphics.setFont(Tamma)
        love.graphics.print(tostring(PLAYER_1_SCORE), ((WINDOW_WIDTH - 80) / 5) - 100, 42)
        -- Second Player's Score
        love.graphics.print(tostring(PLAYER_2_SCORE), (((WINDOW_WIDTH - 80) / 5) * 4) + 60, 42)
    elseif Ball.gameState == 'victory2' then
        love.graphics.setFont(LargeTamma)
        love.graphics.printf('Player2 wins!', 0, ((WINDOW_HEIGHT - 80) / 2) - 200, WINDOW_WIDTH - 80, 'center')
        love.graphics.setFont(SmallTamma)
        love.graphics.printf('Press enter or space to restart', 0, ((WINDOW_HEIGHT - 80 ) / 2) + 42, WINDOW_WIDTH -80, 'center')
        Paddle1:reset()
        Paddle2:reset()
    elseif Ball.gameState == 'victory' then
        love.graphics.setFont(LargeTamma)
        love.graphics.printf('Player1 wins!', 0, ((WINDOW_HEIGHT - 80) / 2) - 200, WINDOW_WIDTH - 80, 'center')
        love.graphics.setFont(SmallTamma)
        love.graphics.printf('Press enter or space to restart', 0, ((WINDOW_HEIGHT - 80) / 2) + 42, WINDOW_WIDTH -80, 'center')
        Paddle1:reset()
        Paddle2:reset()
    end
    if Ball.gameState == 'victory' or Ball.gameState == 'victory2' then
        -- Nothing to be rendered
    else
        -- Rendering the first Player paddle
        Paddle2:render()
        -- Making The ball

        Ball:render()

        -- Rendering the first Player paddle

        Paddle1:render()

        -- Printing the FPS
    end
    FPS()
    -- Paddle collision update
    if Ball:collides(Paddle1) then
        Ball.BALL_X = Paddle1.x - 12
        Ball.balldx = -Ball.balldx * 1.03
        Ball.serve = 2;
        sounds.Paddle_hit:play()
    elseif Ball:collides(Paddle2) then
        Ball.x = Paddle1.x + 12
        Ball.balldx = -Ball.balldx * 1.03
        Ball.serve = 1;
        sounds.Paddle_hit:play()
    end
    -- Wall collision update
    if Ball.BALL_Y <= 0 then
        Ball.balldy = -Ball.balldy * 1.03;
        sounds.wall_hit:play()
    elseif Ball.BALL_Y >= WINDOW_WIDTH - 80 then
        Ball.balldy = -Ball.balldy * 1.03;
        sounds.wall_hit:play()
    end

    -- Score update
    if Ball.BALL_X < 0 then
        PLAYER_2_SCORE = PLAYER_2_SCORE + 1
        Ball:reset()
        Ball.serve = 1;
    end

    if Ball.BALL_X > WINDOW_WIDTH - 80 then
        PLAYER_1_SCORE = PLAYER_1_SCORE + 1
        Ball:reset()
        Ball.serve = 2;
    end

    -- Content Ends
    push:apply('end')

end

-- Keystrokes that will end the game
function love.keypressed(key)
    -- keys can be accessed by string name
    if key == 'escape' then
        -- function LÖVE gives us to terminate application
        love.event.quit()
    end
    if key == 'return' or key == 'space' then
        if Ball.gameState == 'start' then
            Ball.gameState = 'serve'
        elseif Ball.gameState == 'serve' then
            Ball.gameState = 'play'
        elseif Ball.gameState == 'play' then
            Ball.gameState = 'serve'
            Ball:reset()
        elseif Ball.gameState == 'victory' or Ball.gameState == 'victory2' then
            Ball.gameState = 'serve'
            PLAYER_1_SCORE = 0;
            PLAYER_2_SCORE = 0;
        end
    end
end

function FPS()
    Roboto = love.graphics.newFont('Roboto-Black.ttf', 20)
    love.graphics.setFont(Roboto)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS:' .. tostring(love.timer.getFPS()), 22, 22)
    love.graphics.setFont(Tamma)
    love.graphics.setColor(1, 1, 1, 1)
end

local ball = {}

function ball.load()
    ball.x = 240
    ball.y = 240
    ball.raio = 10
    ball.vx = 200
    ball.vy = 200
end

function ball.update(dt, player, cpu, som_pong)
    ball.x = ball.x + ball.vx * dt
    ball.y = ball.y + ball.vy * dt

    -- Colisões
    -- Jogador
    if ball.y + ball.raio >= player.y and
       ball.x + ball.raio > player.x and
       ball.x - ball.raio < player.x + player.largura and
       ball.vy > 0 then
        ball.y = player.y - ball.raio
        ball.vy = -ball.vy
        love.audio.stop(som_pong)
        love.audio.play(som_pong)
    end

    -- CPU
    if ball.y - ball.raio <= cpu.y + cpu.altura and
       ball.x + ball.raio > cpu.x and
       ball.x - ball.raio < cpu.x + cpu.largura and
       ball.vy < 0 then
        ball.y = cpu.y + cpu.altura + ball.raio
        ball.vy = -ball.vy
        love.audio.stop(som_pong)
        love.audio.play(som_pong)
    end

    -- Paredes laterais
    if ball.x - ball.raio < 0 then
        ball.x = ball.raio
        ball.vx = -ball.vx
        love.audio.stop(som_pong)
        love.audio.play(som_pong)
    elseif ball.x + ball.raio > love.graphics.getWidth() then
        ball.x = love.graphics.getWidth() - ball.raio
        ball.vx = -ball.vx
        love.audio.stop(som_pong)
        love.audio.play(som_pong)
    end

    -- Aumenta velocidade com o tempo
    local aumento = 5 * dt
    if ball.vx > 0 then
        ball.vx = ball.vx + aumento
    else
        ball.vx = ball.vx - aumento
    end
    if ball.vy > 0 then
        ball.vy = ball.vy + aumento
    else
        ball.vy = ball.vy - aumento
    end
end

function ball.getPlatformSpeed()
    local velocidade_base = (math.abs(ball.vx) + math.abs(ball.vy)) / 2
    return math.max(300, velocidade_base * 0.8)
end

function ball.reset()
    ball.x = love.graphics.getWidth()/2
    ball.y = love.graphics.getHeight()/2
    ball.vx = 0
    ball.vy = 0
end

function ball.resetDirection()
    ball.vx = 200 * (math.random(0,1) == 0 and 1 or -1)
    ball.vy = 200 * (math.random(0,1) == 0 and 1 or -1)
end

function ball.draw()
    love.graphics.setColor(0,0,1,1)
    love.graphics.circle("fill", ball.x, ball.y, ball.raio)
end

return ball

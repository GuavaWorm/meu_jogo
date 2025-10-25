local player = {}

function player.load()
    player.largura = 80
    player.altura = 20
    player.x = 200
    player.y = love.graphics.getHeight() - player.altura - 10
end

function player.update(dt)
    local velocidade_plataforma = ball.getPlatformSpeed()
    if love.keyboard.isDown("right") then
        player.x = player.x + velocidade_plataforma * dt
    elseif love.keyboard.isDown("left") then
        player.x = player.x - velocidade_plataforma * dt
    end
    player.x = math.max(0, math.min(player.x, love.graphics.getWidth() - player.largura))
end

function player.draw()
    love.graphics.setColor(1,0,0,1)
    love.graphics.rectangle("fill", player.x, player.y, player.largura, player.altura)
end

return player

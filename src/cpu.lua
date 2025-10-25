local cpu = {}

function cpu.load()
    cpu.largura = 80
    cpu.altura = 20
    cpu.x = 200
    cpu.y = 10
end

function cpu.update(dt, ball)
    if ball.vy < 0 then
        local tempo = (cpu.y + cpu.altura - ball.y) / ball.vy
        local destino = ball.x + ball.vx * tempo
        destino = math.max(cpu.largura/2, math.min(destino, love.graphics.getWidth() - cpu.largura/2))
        local centro_cpu = cpu.x + cpu.largura/2
        local margem = 5
        local velocidade_plataforma = ball.getPlatformSpeed()
        if destino > centro_cpu + margem then
            cpu.x = cpu.x + velocidade_plataforma * dt
        elseif destino < centro_cpu - margem then
            cpu.x = cpu.x - velocidade_plataforma * dt
        end
    end
    cpu.x = math.max(0, math.min(cpu.x, love.graphics.getWidth() - cpu.largura))
end

function cpu.draw()
    love.graphics.setColor(0,0,1,1)
    love.graphics.rectangle("fill", cpu.x, cpu.y, cpu.largura, cpu.altura)
end

return cpu

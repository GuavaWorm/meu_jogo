cpu_direita = true

function love.load()
    som_pong = love.audio.newSource("pong.mp3", "static")
    love.window.setTitle("Meu Primeiro Jogo")
    cpu_largura = 80
    cpu_altura = 20
    cpu_x = 200
    cpu_y = 10
    largura = 80
    altura = 20
    x = 200
    y = love.graphics.getHeight() - altura - 10
    bola_x = 240
    bola_y = 240
    bola_raio = 10
    bola_vx = 200
    bola_vy = 200
    pontos_jogador = 0
    pontos_cpu = 0
    jogo_acabou = false 
    vencedor = ""
    tempo_espera = 0
    aguardando = false
end

function love.update(dt)
    if jogo_acabou then return end

    -- Pausa o jogo durante a contagem regressiva
    if aguardando then
        tempo_espera = tempo_espera - dt
        if tempo_espera <= 0 then
            bola_vx = 200 * (math.random(0,1) == 0 and 1 or -1)
            bola_vy = 200 * (math.random(0,1) == 0 and 1 or -1)
            aguardando = false
        end
        return
    end

    -- Calcula a velocidade das plataformas baseada na velocidade da bola
    local velocidade_base = (math.abs(bola_vx) + math.abs(bola_vy)) / 2
    local velocidade_plataforma = math.max(300, velocidade_base * 0.8) -- 0.8 é um fator, posso ajustar se for necessário

    -- Movimento do jogador
    if love.keyboard.isDown("right") then
        x = x + velocidade_plataforma * dt
    elseif love.keyboard.isDown("left") then
        x = x - velocidade_plataforma * dt
    end
    if x < 0 then x = 0 end
    if x > love.graphics.getWidth() - largura then
        x = love.graphics.getWidth() - largura
    end

    -- CPU segue a bola prevendo onde ela vai chegar
    if bola_vy < 0 then
        local tempo = (cpu_y + cpu_altura - bola_y) / bola_vy
        local destino = bola_x + bola_vx * tempo
        destino = math.max(cpu_largura/2, math.min(destino, love.graphics.getWidth() - cpu_largura/2))
        local centro_cpu = cpu_x + cpu_largura/2
        local margem = 5
        if destino > centro_cpu + margem then
            cpu_x = cpu_x + velocidade_plataforma * dt
        elseif destino < centro_cpu - margem then
            cpu_x = cpu_x - velocidade_plataforma * dt
        end
    end
    if cpu_x < 0 then cpu_x = 0 end
    if cpu_x > love.graphics.getWidth() - cpu_largura then
        cpu_x = love.graphics.getWidth() - cpu_largura
    end

    -- Movimento da bola
    bola_x = bola_x + bola_vx * dt
    bola_y = bola_y + bola_vy * dt

    -- Colisão com a plataforma do jogador
    if bola_y + bola_raio >= y and
       bola_x + bola_raio > x and
       bola_x - bola_raio < x + largura and
       bola_vy > 0 then
        bola_y = y - bola_raio
        bola_vy = -bola_vy
        love.audio.stop(som_pong)
        love.audio.play(som_pong)
    end

    -- Colisão com a plataforma do cpu
    if bola_y - bola_raio <= cpu_y + cpu_altura and
       bola_x + bola_raio > cpu_x and
       bola_x - bola_raio < cpu_x + cpu_largura and
       bola_vy < 0 then
        bola_y = cpu_y + cpu_altura + bola_raio
        bola_vy = -bola_vy
        love.audio.stop(som_pong)
        love.audio.play(som_pong)
    end

    -- Colisão com as paredes laterais
    if bola_x - bola_raio < 0 then
        bola_x = bola_raio
        bola_vx = -bola_vx
        love.audio.stop(som_pong)
        love.audio.play(som_pong)
    elseif bola_x + bola_raio > love.graphics.getWidth() then
        bola_x = love.graphics.getWidth() - bola_raio
        bola_vx = -bola_vx
        love.audio.stop(som_pong)
        love.audio.play(som_pong)
    end

    -- Aumenta a velocidade da bola aos poucos
    local aumento = 5 * dt
    if bola_vx > 0 then
        bola_vx = bola_vx + aumento
    else
        bola_vx = bola_vx - aumento
    end
    if bola_vy > 0 then
        bola_vy = bola_vy + aumento
    else
        bola_vy = bola_vy - aumento
    end

    -- Pontuação e reinício da bola
    if bola_y - bola_raio > love.graphics.getHeight() then
        pontos_cpu = pontos_cpu + 1
        if pontos_cpu >= 5 then
            jogo_acabou = true
            vencedor = "CPU"
        else
            bola_x = love.graphics.getWidth()/2
            bola_y = love.graphics.getHeight()/2
            bola_vx = 0
            bola_vy = 0
            tempo_espera = 3
            aguardando = true
        end
    end
    if bola_y + bola_raio < 0 then
        pontos_jogador = pontos_jogador + 1
        if pontos_jogador >= 5 then
            jogo_acabou = true
            vencedor = "Jogador"
        else
            bola_x = love.graphics.getWidth()/2
            bola_y = love.graphics.getHeight()/2
            bola_vx = 0
            bola_vy = 0
            tempo_espera = 3
            aguardando = true
        end
    end
end

function love.draw()
    love.graphics.setColor(1,0,0,1)
    love.graphics.rectangle("fill", x, y, largura, altura)
    love.graphics.setBackgroundColor(255,203,219)
    love.graphics.setColor(0,0,1,1)
    love.graphics.rectangle("fill", cpu_x, cpu_y, cpu_largura, cpu_altura)
    love.graphics.setColor(0,0,1,1)
    love.graphics.circle("fill", bola_x, bola_y, bola_raio)

    -- Placar e mensagem de vitória
    love.graphics.setColor(0,0,0,1)
    love.graphics.print("Jogador: "..pontos_jogador, 10, love.graphics.getHeight()-30)
    love.graphics.print("CPU: "..pontos_cpu, 10, 10)
    if jogo_acabou then
        love.graphics.setColor(0,0,0,1)
        love.graphics.printf("Vencedor: "..vencedor, 0, love.graphics.getHeight()/2-20, love.graphics.getWidth(), "center")
    end

    if aguardando then
        love.graphics.setColor(0,0,0,1)
        love.graphics.printf(
            "Prepare-se: " .. math.ceil(tempo_espera),
            0,
            love.graphics.getHeight()/2 - 40,
            love.graphics.getWidth(),
            "center"
        )
    end
end

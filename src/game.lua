player = require("src.player")
cpu = require("src.cpu")
ball = require("src.ball")

game = {}

function game.load()
    som_pong = love.audio.newSource("assets/sounds/pong.mp3", "static")
    love.window.setTitle("Meu Primeiro Jogo")

    -- Estado do jogo
    game.pontos_jogador = 0
    game.pontos_cpu = 0
    game.jogo_acabou = false
    game.vencedor = ""
    game.tempo_espera = 0
    game.aguardando = false

    player.load()
    cpu.load()
    ball.load()
end

function game.update(dt)
    if game.jogo_acabou then return end

    if game.aguardando then
        game.tempo_espera = game.tempo_espera - dt
        if game.tempo_espera <= 0 then
            ball.resetDirection()
            game.aguardando = false
        end
        return
    end

    player.update(dt)
    cpu.update(dt, ball)
    ball.update(dt, player, cpu, som_pong)

    -- Pontuação
    if ball.y - ball.raio > love.graphics.getHeight() then
        game.pontos_cpu = game.pontos_cpu + 1
        game.newRound("cpu")
    elseif ball.y + ball.raio < 0 then
        game.pontos_jogador = game.pontos_jogador + 1
        game.newRound("player")
    end
end

function game.newRound(marcador)
    if game.pontos_jogador >= 5 then
        game.vencedor = "Jogador"
        game.jogo_acabou = true
    elseif game.pontos_cpu >= 5 then
        game.vencedor = "CPU"
        game.jogo_acabou = true
    else
        ball.reset()
        game.aguardando = true
        game.tempo_espera = 3
    end
end

function game.draw()
    love.graphics.setBackgroundColor(255,203,219)

    player.draw()
    cpu.draw()
    ball.draw()

    love.graphics.setColor(0,0,0,1)
    love.graphics.print("Jogador: "..game.pontos_jogador, 10, love.graphics.getHeight()-30)
    love.graphics.print("CPU: "..game.pontos_cpu, 10, 10)

    if game.jogo_acabou then
        love.graphics.printf("Vencedor: "..game.vencedor, 0, love.graphics.getHeight()/2-20, love.graphics.getWidth(), "center")
    elseif game.aguardando then
        love.graphics.printf("Prepare-se: "..math.ceil(game.tempo_espera), 0, love.graphics.getHeight()/2 - 40, love.graphics.getWidth(), "center")
    end
end

return game

player = require("src.player")
cpu = require("src.cpu")
ball = require("src.ball")
levels = require("src.levels") -- Importa as fases

game = {}
currentLevel = 1

-- ====================
-- Carrega uma fase
-- ====================
function game.loadLevel(levelNum)
    local level = levels[levelNum]
    ball.speed = level.ballSpeed
    cpu.speed = level.cpuSpeed
    game.maxScore = level.maxScore

    -- Reseta placar da fase
    game.pontos_jogador = 0
    game.pontos_cpu = 0
    game.jogo_acabou = false
    game.vencedor = ""
    game.aguardando = true
    game.tempo_espera = 3
end

-- ====================
-- Inicializa o jogo
-- ====================
function game.load()
    som_pong = love.audio.newSource("assets/sounds/pong.mp3", "static")
    love.window.setTitle("Meu Primeiro Jogo")

    player.load()
    cpu.load()
    ball.load()

    game.loadLevel(currentLevel)
end

-- ====================
-- Atualiza o jogo
-- ====================
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

-- ====================
-- Novo round
-- ====================
function game.newRound(marcador)
    -- Aumenta dificuldade a cada ponto
    game.increaseDifficulty()

    if game.pontos_jogador >= game.maxScore then
        game.vencedor = "Jogador"
        game.jogo_acabou = true
        game.nextLevel()
    elseif game.pontos_cpu >= game.maxScore then
        game.vencedor = "CPU"
        game.jogo_acabou = true
        game.nextLevel()
    else
        ball.reset()
        game.aguardando = true
        game.tempo_espera = 3
    end
end

-- ====================
-- Próxima fase
-- ====================
function game.nextLevel()
    if currentLevel < #levels then
        currentLevel = currentLevel + 1
        game.loadLevel(currentLevel)
    else
        -- Todas as fases completadas
        game.aguardando = false
        print("Parabéns! Você completou todas as fases!")
    end
end

-- ====================
-- Aumenta dificuldade dentro da fase
-- ====================
function game.increaseDifficulty()
    -- Pequeno aumento de velocidade a cada ponto
    ball.speed = ball.speed + 5
    cpu.speed = cpu.speed + 3
end

-- ====================
-- Desenha o jogo
-- ====================
function game.draw()
    -- Fundo da fase
    local bg = levels[currentLevel].backgroundColor
    love.graphics.setBackgroundColor(bg[1]/255, bg[2]/255, bg[3]/255)

    player.draw()

    -- CPU com cor da fase
    local cpuCol = levels[currentLevel].cpuColor
    love.graphics.setColor(cpuCol[1]/255, cpuCol[2]/255, cpuCol[3]/255)
    cpu.draw()
    love.graphics.setColor(0,0,0,1) -- volta cor padrão

    ball.draw()

    love.graphics.setColor(0,0,0,1)
    love.graphics.print("Fase: "..currentLevel.." - "..levels[currentLevel].name, 10, love.graphics.getHeight()/2 - 60)
    love.graphics.print("Jogador: "..game.pontos_jogador, 10, love.graphics.getHeight()-30)
    love.graphics.print("CPU: "..game.pontos_cpu, 10, 10)

    if game.jogo_acabou then
        love.graphics.printf("Vencedor: "..game.vencedor, 0, love.graphics.getHeight()/2-20, love.graphics.getWidth(), "center")
    elseif game.aguardando then
        love.graphics.printf("Prepare-se: "..math.ceil(game.tempo_espera), 0, love.graphics.getHeight()/2 - 40, love.graphics.getWidth(), "center")
    end
end

return game

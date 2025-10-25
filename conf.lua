local love

function love.conf(t)
    t.identity = "pong-boss"           -- Nome da pasta de save (opcional)
    t.version = "11.5"                 -- Versão do LÖVE usada
    t.console = false                  -- Mostra console (true se quiser ver prints)

    t.window.title = "Pong Boss"
    t.window.width = 640
    t.window.height = 480
    t.window.resizable = false
    t.window.vsync = 1
    t.window.msaa = 0
end

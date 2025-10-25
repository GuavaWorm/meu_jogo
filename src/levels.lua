local levels = {
    [1] = {
        name = "Fase 1",
        ballSpeed = 200,
        cpuSpeed = 150,
        maxScore = 5,
        backgroundColor = {255,203,219},  -- rosa
        cpuColor = {0,0,0}               -- preto
    },
    [2] = {
        name = "Fase 2",
        ballSpeed = 250,
        cpuSpeed = 180,
        maxScore = 7,
        backgroundColor = {200,230,255}, -- azul claro
        cpuColor = {255,0,0}             -- vermelho
    },
    [3] = {
        name = "Fase 3",
        ballSpeed = 300,
        cpuSpeed = 210,
        maxScore = 10,
        backgroundColor = {220,255,200}, -- verde claro
        cpuColor = {0,0,255}             -- azul
    }
}

return levels

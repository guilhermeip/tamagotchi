function love.load()
    --Carregando animações
    animationSleep = newAnimation(love.graphics.newImage("Sprites/pikachu_dormindo.png"), 344, 344, 2)
    animationNormal = newAnimation(love.graphics.newImage("Sprites/pikachu_normal.png"), 344, 344, 1.5)
    animationBad = newAnimation(love.graphics.newImage("Sprites/pikachu_triste.png"), 344, 344, 2)
    animationSick = newAnimation(love.graphics.newImage("Sprites/pikachu_doente.png"), 344, 344, 2)
    animationTired = newAnimation(love.graphics.newImage("Sprites/pikachu_cansado.png"), 344, 344, 2)
    animationEgg = newAnimation(love.graphics.newImage("Sprites/Egg.png"), 344, 344, 1.5)
    animationVaccione = newAnimation(love.graphics.newImage("Sprites/Vaccine.png"), 344, 344, 2)

    --Imagens do Mini-Game
    game_base = love.graphics.newImage("MiniGame/game_base.png")
    game_paper = love.graphics.newImage("MiniGame/game_paper.png")
    game_rock = love.graphics.newImage("MiniGame/game_rock.png")
    game_scissors = love.graphics.newImage("MiniGame/game_scissors.png")

    --Ajustando a janela (tamanho, titulo e fixa)
    love.window.setMode(688, 688, {resizable=false, vsync=false}) 
    love.graphics.setBackgroundColor(255,255,255)
    love.window.setTitle( "Tamagotchi" )
    
    --Inicializando Interface gráfica
    UI = love.graphics.newImage("UI/UIIconsActions.png");
    fonteName = love.graphics.newFont("Fonte/Roboto-Medium.ttf", 32)
    name = {{0,0,0}, "PIKACHU"} -- MUDAR
    animation = animationNormal --MUDAR
    math.randomseed(os.time())
    
    --Carregando imagens do mouse
    normalCursor =  love.mouse.newCursor(love.image.newImageData("Imagens/normalCursor.png"), 1, 1)
    appleCursor =  love.mouse.newCursor(love.image.newImageData("Imagens/appleCursor.png"), 27, 31)
    spongeCursor =  love.mouse.newCursor(love.image.newImageData("Imagens/spongeCursor.png"), 27, 31)
    love.mouse.setCursor(normalCursor)
    mouseStatus = "normal"
        
    -- carregar imagens
    poop = love.graphics.newImage("Imagens/poop.png")


    -- variaveis de controle
    --poop
    hasPoop = true --MUDAR
    hasPoopAux = hasPoop

    --controle gerais
    isSleep = false
    healthIsPress = false

    --controle game
    imageGame = game_base
    pontos = 0
    showPontos = {{0,0,0}, pontos}

    --Status VPET 
    hungryRate = 5/100
    healthPercent = 100 --MUDAR
    happyPercent = 100 --MUDAR
    hungryPercent = 100 --MUDAR
    hungryPercentFloat = hungryPercent
end

function love.update(dt)
    animation.currentTime = animation.currentTime + dt
    if animation.currentTime >= animation.duration then
        animation.currentTime = animation.currentTime - animation.duration
        if healthIsPress then
            hasPoop = hasPoopAux
            animation = animationNormal -- MUDAR
            healthIsPress = false
        end
    end
    hungryPercentFloat = hungryPercentFloat - (hungryRate * randomFloat(0.8,1.1)) * dt
    hungryPercent = string.format("%.0f", hungryPercentFloat)
end

function love.draw()
    love.graphics.draw(UI, 0, 0, 0, 1)
    love.graphics.setFont(fonteName)
    love.graphics.printf(name, love.graphics.getWidth() / 2  - 66, 135, 135, "center")
    love.graphics.printf({{0,0,0},"Health: \n" .. healthPercent .. "%"}, 0, 0, 200, "center")
    love.graphics.printf({{0,0,0},"Happiness: \n" .. happyPercent .. "%"}, 210, 0, 250, "center")
    love.graphics.printf({{0,0,0},"Hunger: \n" .. hungryPercent .. "%"}, 440, 0, 250, "center")
    if mouseStatus ~= "game" then
        local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
        love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], middleX(344), middleY(344), 0, 1)
    end    

    if hasPoop then
        love.graphics.draw(poop, 188, 448, 0, 1)
    end
    
    if mouseStatus == "game" then
        love.graphics.draw(imageGame, middleX(344), middleY(344), 0, 1)
    end

end

function newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};
    
    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end
    
    animation.duration = duration or 1
    animation.currentTime = 0
    
    return animation
end

function middleX(imageX)
    return (love.graphics.getWidth() / 2) - (imageX / 2)
end

function middleY(imageY)
    return (love.graphics.getHeight() / 2) - (imageY / 2)
end

function love.mousepressed(mx, my, button)
    --COMIDA
    if button == 1 and my >= 552 and my < 552 + 100 and  mx >= 21 and mx < 21 + 100 and isSleep == false then
        if mouseStatus ~= "eat" then
            UI = love.graphics.newImage("UI/UIHungrySelected.png");
            love.mouse.setCursor(appleCursor)
            mouseStatus = "eat"
        else
            UI = love.graphics.newImage("UI/UIIconsActions.png");
            mouseStatus = "normal"
            love.mouse.setCursor(normalCursor)
        end

     --BANHEIRO  
    elseif button == 1 and my >= 552 and my < 552 + 100 and  mx >= 159 and mx < 159 + 100 and isSleep == false then
        if mouseStatus ~= "toilet" then
            UI = love.graphics.newImage("UI/UIToiletSelected.png");
            love.mouse.setCursor(spongeCursor)
            mouseStatus = "toilet"
        else
            UI = love.graphics.newImage("UI/UIIconsActions.png");
            mouseStatus = "normal"
            love.mouse.setCursor(normalCursor)
        end
        
    --CURAR
    elseif button == 1 and my >= 552 and my < 552 + 100 and  mx >= 297 and mx < 297 + 100 and isSleep == false then
        mouseStatus = "normal"
        love.mouse.setCursor(normalCursor)
        UI = love.graphics.newImage("UI/UIHealthCareSelected.png");

    --GAME
    elseif button == 1 and my >= 552 and my < 552 + 100 and  mx >= 435 and mx < 435 + 100 and isSleep == false then
        mouseStatus = "game"
        love.mouse.setCursor(normalCursor)
        UI = love.graphics.newImage("UI/UIGameSelected.png");

    --DORMIR
    elseif button == 1 and my >= 552 and my < 552 + 100 and  mx >= 572 and mx < 572 + 100 then
        love.mouse.setCursor(normalCursor)
        if mouseStatus ~= "sleep" then
            UI = love.graphics.newImage("UI/UISleepSelected.png");
            isSleep = true
            animation = animationSleep
            mouseStatus = "sleep"
        else
            isSleep = false
            UI = love.graphics.newImage("UI/UIIconsActions.png");
            animation = animationNormal -- MUDAR
            mouseStatus = "normal"
        end
    end
    --COMER
    if button == 1 and my >= 173 and my < 516 and mx >= 173 and mx < 516 and mouseStatus == "eat" then
        if healthPercent < 100 then
            hungryPercent = hungryPercent + 10
        end
    end
    --LIMPAR
    if button == 1 and my >= 450 and my < 506 and mx >= 188 and mx < 232 and mouseStatus == "toilet" then
        if hasPoop then
            if healthPercent < 100 then
                healthPercent = healthPercent + 10
            end
            hasPoop = false
        end
    end
    -- JOGAR
    if button == 1 and my >= 173 and my < 516 and  mx >= 173 and mx < 333 and isSleep == false then
        -- entrar no primeiro botão do jogo (pedra)
        if my < 276 then
            if randomImageMiniGame == 1 then
            end
        end
    end
end

function love.mousereleased( mx, my, button )
--     if button == 1 and my >= 537 and my < 537 + 100 and  mx >= 37 and mx < 37 + 100 then
--         UI = love.graphics.newImage("UI/UIIconsActions.png");
    -- if button == 1 and my >= 552 and my < 552 + 100 and  mx >= 159 and mx < 159 + 100 and isSleep == false then
    --      UI = love.graphics.newImage("UI/UIIconsActions.png");
    
    --CURAR
    if button == 1 and my >= 552 and my < 552 + 100 and  mx >= 297 and mx < 297 + 100 and isSleep == false then
         UI = love.graphics.newImage("UI/UIIconsActions.png")
         animation = animationVaccione
         healthIsPress = true
         hasPoopAux = hasPoop
         hasPoop = false
--     elseif button == 1 and my >= 537 and my < 537 + 100 and  mx >= 450 and mx < 450 + 100 then
--         UI = love.graphics.newImage("UI/UIIconsActions.png");
--     elseif button == 1 and my >= 537 and my < 537 + 100 and  mx >= 587 and mx < 587 + 100 then
--         UI = love.graphics.newImage("UI/UIIconsActions.png");
     end
 end

 function randomFloat(lower, greater)
    return lower + math.random()  * (greater - lower);
end

function randomImageMiniGame()
    local numeroRandom = math.random(1,3)
    if numeroRandom == 1 then
        imageGame = game_rock
    elseif numeroRandom == 2 then
        imageGame = game_paper
    else
        imageGame = game_scissors
    end
    return numeroRandom
end
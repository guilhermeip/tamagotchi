function love.load()
    --Carregando animações
    animationSleep = newAnimation(love.graphics.newImage("Sprites/pikachu_dormindo.png"), 344, 344, 2)
    animationNormal = newAnimation(love.graphics.newImage("Sprites/pikachu_normal.png"), 344, 344, 1.5)
    animationBad = newAnimation(love.graphics.newImage("Sprites/pikachu_triste.png"), 344, 344, 2)
    animationSick = newAnimation(love.graphics.newImage("Sprites/pikachu_doente.png"), 344, 344, 2)
    animationTired = newAnimation(love.graphics.newImage("Sprites/pikachu_cansado.png"), 344, 344, 2)
    animationEgg = newAnimation(love.graphics.newImage("Sprites/Egg.png"), 344, 344, 1.5)
    animationVaccione = newAnimation(love.graphics.newImage("Sprites/Vaccine.png"), 344, 344, 2)
    animation = animationNormal --MUDAR
    animationLast = animation

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
    UINormal = love.graphics.newImage("UI/UIIconsActions.png");
    UIHungry =love.graphics.newImage("UI/UIHungrySelected.png");
    UIHealth = love.graphics.newImage("UI/UIHealthCareSelected.png");
    UISleep = love.graphics.newImage("UI/UISleepSelected.png");
    UIGame = love.graphics.newImage("UI/UIGameSelected.png");
    UIToilet = love.graphics.newImage("UI/UIToiletSelected.png");
    UI = UINormal
    --fonte
    fonteName = love.graphics.newFont("Fonte/Roboto-Medium.ttf", 32)


    name = {{0,0,0}, "PIKACHU"} 
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
    isSick = false

    --controle game
    imageGame = game_base
    winGame = {{0,0,0}, "WIN"}
    loseGame = {{0,0,0}, "LOSE"}
    aTieGame = {{0,0,0}, "A TIE"}
    resultGame = {{0,0,0,}, "----"}

    --Status VPET
    state = "normal" -- MUDAR
    numberRateHealth = 2/100 
    healthRate = numberRateHealth -- MUDAR
    healthPercent = 60 --MUDAR
    healthPercentFloat = healthPercent

    numberRateHappy = 5/100
    happyRate = numberRateHappy -- MUDAR
    happyPercent = 65 -- MUDAR
    happyPercentFloat = happyPercent
    
    numberRateHungry = 6/100
    hungryRate = numberRateHungry -- MUDAR
    hungryPercent = 65 --MUDAR
    hungryPercentFloat = hungryPercent

    numberRateEnergy = 5/100
    energyRate = numberRateEnergy
    energyPercent = 98
    energyPercentFloat = energyPercent

    selected = ""
end

function love.update(dt)
    animation.currentTime = animation.currentTime + dt
    if animation.currentTime >= animation.duration then
        animation.currentTime = animation.currentTime - animation.duration
        if healthIsPress then
            hasPoop = hasPoopAux
            animation = animationLast
            healthIsPress = false
        end
    end
    --hungry decremento
    hungryPercentFloat = hungryPercentFloat - (hungryRate * randomFloat(0.8,1.1)) * dt
    hungryPercent = math.floor( hungryPercentFloat)
    --health decremento
    healthPercentFloat = healthPercentFloat - (healthRate * randomFloat(0.8,1.1)) * dt
    healthPercent = math.floor(healthPercentFloat)
    --health decremento
    happyPercentFloat = happyPercentFloat - (happyRate * randomFloat(0.8,1.1)) * dt
    happyPercent = math.floor(happyPercentFloat)

    if not isSleep then
        --energy decremento
        energyPercentFloat = energyPercentFloat - (energyRate * randomFloat(0.8,1.1)) * dt
        energyPercent = math.floor(energyPercentFloat)
    else
        --energy incremento (dormindo)
        if energyPercent <= 98 then
            energyPercentFloat = energyPercentFloat + (energyRate * randomFloat(1.1,1.4)) * dt
            energyPercent = math.floor(energyPercentFloat)
        else
            energyPercentFloat = 100
            isSleep = false
            UI = UINormal
            mouseStatus = "normal"
            animation = animationLast
        end
    end

    if hasPoop then
        healthRate = numberRateHealth * 2
    else
        healthRate = numberRateHealth
    end

    if state == "normal"  then
        if selected ~= "normal" then 
            animation = animationNormal
            animationLast = animation
            selected = "normal"
        end
        energyRate = numberRateEnergy
        happyRate = numberRateHappy
        healthRate = numberRateHealth
        hungryRate = numberRateHungry
        
        if healthPercent < 60 then
            state = "sick" 
        end
        if happyPercent < 50 then
            state = "sad"
        end 
        if energyPercent < 30 then
            state = "tired"
        end
        if energyPercent <= 0 or happyPercent <= 0 or healthPercent <= 0 or hungryPercent <= 0 then
            state = "dead"
        end
        
    elseif state == "sick" then
        if selected ~= "sick" then
            animation = animationSick
            animationLast = animation
            selected = "sick"
            isSick = true
        end
        energyRate = numberRateEnergy * 2
        happyRate = numberRateHappy * 2
        healthRate = numberRateHealth * 3
        hungryRate = numberRateHungry

        if not isSick then
            state = "normal"
        end
        if energyPercent <= 0 or happyPercent <= 0 or healthPercent <= 0 or hungryPercent <= 0 then
            state = "dead"
        end

    elseif state == "sad" then
        if selected ~= "sad" then
            animation = animationBad
            animationLast = animation
            selected = "sad"
        end
        energyRate = numberRateEnergy
        happyRate = numberRateHappy * 3
        healthRate = numberRateHealth * 2
        hungryRate = numberRateHungry

        if happyPercent >= 50 then
            state = "normal"
        end
        if energyPercent <= 0 or happyPercent <= 0 or healthPercent <= 0 or hungryPercent <= 0 then
            state = "dead"
        end
    
    elseif state == "tired" then
        if selected ~= "tired" then
            animation = animationTired
            animationLast = animation
            selected = "tired"
        end
        energyRate = numberRateEnergy * 3
        happyRate = numberRateHappy * 2
        healthRate = numberRateHealth 
        hungryRate = numberRateHungry * 3

        
        if energyPercent >= 99 then
            state = "normal"
        end
        
        
        if energyPercent <= 0 or happyPercent <= 0 or healthPercent <= 0 or hungryPercent <= 0 then
            state = "dead"
        end

    elseif state == "dead" then
        print ("morreu")
    end

end

function love.draw()
    love.graphics.draw(UI, 0, 0, 0, 1)
    love.graphics.setFont(fonteName)
    love.graphics.printf(name, love.graphics.getWidth() / 2  - 66, 135, 135, "center")
    love.graphics.printf({{0,0,0},"Health: \n" .. healthPercent .. "%"}, 0, 0, 200, "center")
    love.graphics.printf({{0,0,0},"Happiness: \n" .. happyPercent .. "%"}, 172, 0, 200, "center")
    love.graphics.printf({{0,0,0},"Hunger: \n" .. hungryPercent .. "%"}, 344, 0, 200, "center")
    love.graphics.printf({{0,0,0},"Energy: \n" .. energyPercent .. "%"}, 516, 0, 200, "center")
    if mouseStatus ~= "game" then
        local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
        love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], middleX(344), middleY(344), 0, 1)
    end    

    if hasPoop then
        love.graphics.draw(poop, 188, 448, 0, 1)
    end
    
    if mouseStatus == "game" then
        love.graphics.draw(imageGame, middleX(344), middleY(344), 0, 1)
        love.graphics.printf(resultGame, love.graphics.getWidth() / 2  + 10, 210, 100, "center")
    end
end

function love.mousepressed(mx, my, button)
    --COMIDA
    if button == 1 and my >= 552 and my < 552 + 100 and  mx >= 21 and mx < 21 + 100 and isSleep == false then
        if mouseStatus ~= "eat" then
            UI = UIHungry;
            love.mouse.setCursor(appleCursor)
            mouseStatus = "eat"
        else
            UI = UINormal;
            mouseStatus = "normal"
            love.mouse.setCursor(normalCursor)
        end

     --BANHEIRO  
    elseif button == 1 and my >= 552 and my < 552 + 100 and  mx >= 159 and mx < 159 + 100 and isSleep == false then
        if mouseStatus ~= "toilet" then
            UI = UIToilet;
            love.mouse.setCursor(spongeCursor)
            mouseStatus = "toilet"
        else
            UI = UINormal;
            mouseStatus = "normal"
            love.mouse.setCursor(normalCursor)
        end
        
    --CURAR
    elseif button == 1 and my >= 552 and my < 552 + 100 and  mx >= 297 and mx < 297 + 100 and isSleep == false then
        mouseStatus = "heal"
        love.mouse.setCursor(normalCursor)
        UI = UIHealth;
        if isSick then
            isSick = false
            healthPercentFloat = 100
        else
            healthPercentFloat = healthPercentFloat - 10
        end

    --GAME
    elseif button == 1 and my >= 552 and my < 552 + 100 and  mx >= 435 and mx < 435 + 100 and isSleep == false then
        love.mouse.setCursor(normalCursor)
        if mouseStatus ~= "game" then
            UI = UIGame;
            mouseStatus = "game"
        else
            UI = UINormal;
            mouseStatus = "normal"
            imageGame = game_base
            resultGame = {{0,0,0,}, "----"}
        end

    --DORMIR
    elseif button == 1 and my >= 552 and my < 552 + 100 and  mx >= 572 and mx < 572 + 100 then
        love.mouse.setCursor(normalCursor)
        if mouseStatus ~= "sleep" then
            animationLast = animation
            UI = UISleep;
            isSleep = true
            animation = animationSleep
            mouseStatus = "sleep"
        else
            if energyPercent >= 10 then
                isSleep = false
                UI = UINormal;
                animation = animationLast
                mouseStatus = "normal"
            end
        end
    end
    --COMER
    if button == 1 and my >= 173 and my < 516 and mx >= 173 and mx < 516 and mouseStatus == "eat" then
        if hungryPercent <= 95 then
            hungryPercentFloat = hungryPercentFloat + 5
            if healthPercent <= 98 then
                healthPercentFloat = healthPercentFloat + 2
            end
        else
            healthPercentFloat = healthPercentFloat - 3
            hasPoop = true
        end
    end
    --LIMPAR
    if button == 1 and my >= 450 and my < 506 and mx >= 188 and mx < 232 and mouseStatus == "toilet" then
        if hasPoop then
            if healthPercent <= 90 then
                healthPercent = healthPercent + 10
            end
            hasPoop = false
        end
    end
    -- JOGAR
    if button == 1 and my >= 173 and my < 516 and  mx >= 173 and mx < 333 and mouseStatus == "game" then
        local randomNumber = math.random(1,3)
        -- entrar no primeiro botão do jogo (pedra)
        if my < 276 and mx >= 173 and mx < 333 then
            if randomNumber == 1 then
                resultGame = aTieGame
                imageGame = game_rock
            elseif randomNumber == 2 then
                resultGame = loseGame
                imageGame = game_paper
            else
                resultGame = winGame
                imageGame = game_scissors 
            end
        -- (papel)
        elseif my >= 277 and my < 383 and mx >= 173 and mx < 333 then
            if randomNumber == 2 then
                resultGame = aTieGame
                imageGame = game_paper
            elseif randomNumber == 3 then
                resultGame = loseGame
                imageGame = game_scissors
            else
                resultGame = winGame
                imageGame = game_rock
            end
        --(tesoura)
        elseif my >= 384 and my <= 516 and mx >= 173 and mx < 333 then
            if randomNumber == 3 then
                resultGame = aTieGame
                imageGame = game_scissors
            elseif randomNumber == 1 then
                resultGame = loseGame
                imageGame = game_rock
            else
                resultGame = winGame
                imageGame = game_paper
            end
        end
        -- controle da felicidade de acordo com o resultado
        energyPercentFloat = energyPercentFloat - 1
        if resultGame == winGame and happyPercent <= 90 then
            happyPercentFloat = happyPercentFloat + 10
        elseif resultGame == loseGame and happyPercent <= 98 then
            happyPercentFloat = happyPercentFloat + 2
        elseif resultGame == aTieGame and happyPercent <= 95 then
            happyPercentFloat = happyPercentFloat + 5
        elseif happyPercent == 99 then
            happyPercentFloat = 100
        end
    end
end

function love.mousereleased( mx, my, button )
    if button == 1 and my >= 552 and my < 552 + 100 and  mx >= 297 and mx < 297 + 100 and isSleep == false then
         UI = UINormal;
         animationLast = animation
         animation = animationVaccione
         healthIsPress = true
         hasPoopAux = hasPoop
         hasPoop = false
     end
 end

 function randomFloat(lower, greater)
    return lower + math.random()  * (greater - lower);
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
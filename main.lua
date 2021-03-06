local deadMusic = love.audio.newSource("/Audios/Music/dead.mp3", "stream")
local sleepMusic = love.audio.newSource("/Audios/Music/sleep.mp3", "stream")
local mainMusic = love.audio.newSource("/Audios/Music/main.mp3", "stream")
local gameMusic = love.audio.newSource("/Audios/Music/game.mp3", "stream")
local healAudio = love.audio.newSource("/Audios/Audios/heal.mp3", "static")
local winGameAudio = love.audio.newSource("/Audios/Audios/winGame.mp3", "static")

function love.load()
    --Carregando valores da altura e largura da tela
    loveWidth = love.graphics.getWidth()
    loveHeight = love.graphics.getHeight()
    
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
    love.window.setMode(688, 688, {resizable=false, vsync=true}) 
    love.graphics.setBackgroundColor(255,255,255)
    
    --Inicializando Interface gráfica
    UINormal = love.graphics.newImage("UI/UIIconsActions.png");
    UIHungry =love.graphics.newImage("UI/UIHungrySelected.png");
    UIHealth = love.graphics.newImage("UI/UIHealthCareSelected.png");
    UISleep = love.graphics.newImage("UI/UISleepSelected.png");
    UIGame = love.graphics.newImage("UI/UIGameSelected.png");
    UIToilet = love.graphics.newImage("UI/UIToiletSelected.png");
    UIGameOver = love.graphics.newImage("UI/UIIcons.png");
    UI = UINormal
    
    --fonte
    fonteName = love.graphics.newFont("Fonte/Roboto-Medium.ttf", 32)

    --audios
    deadMusic:setLooping(true)
    deadMusic:setVolume(0.5)
    sleepMusic:setLooping(true)
    sleepMusic:setVolume(0.5)
    mainMusic:setLooping(true)
    mainMusic:setVolume(0.5)
    gameMusic:setLooping(true)
    gameMusic:setVolume(0.5)
    love.audio.stop(gameMusic)
    love.audio.stop(deadMusic)
    love.audio.stop(sleepMusic)
    love.audio.play(mainMusic)

    name = {{0,0,0}, "PIKACHU"}
    deadText = {{0,0,0}, "RESET"} 
    math.randomseed(os.time())
    
    --Carregando imagens do mouse
    normalCursor =  love.mouse.newCursor(love.image.newImageData("Imagens/normalCursor.png"), 1, 1)
    appleCursor =  love.mouse.newCursor(love.image.newImageData("Imagens/appleCursor.png"), 27, 31)
    spongeCursor =  love.mouse.newCursor(love.image.newImageData("Imagens/spongeCursor.png"), 27, 31)
    love.mouse.setCursor(normalCursor)
    mouseStatus = "normal"
        
    -- carregar imagens
    poop = love.graphics.newImage("Imagens/poop.png")
    dead = love.graphics.newImage("Imagens/pikachuDead.png")
    deadButtonImage = love.graphics.newImage("UI/resetButton.png")

    --controle gerais
    healthIsPress = false
    timeSave = 2
    
    timeToSave = 0
    --controle game
    imageGame = game_base
    winGame = {{0,0,0}, "WIN"}
    loseGame = {{0,0,0}, "LOSE"}
    aTieGame = {{0,0,0}, "A TIE"}
    resultGame = {{0,0,0,}, "----"}

    --Status VPET
    numberRateHealth = 2/100 
    healthRate = numberRateHealth

    numberRateHappy = 5/100
    happyRate = numberRateHappy 
    
    
    numberRateHungry = 6/100
    hungryRate = numberRateHungry 
    

    numberRateEnergy = 5/100
    energyRate = numberRateEnergy
    selected = ""    

    carregarDados()
    --tempo
    
    deltatime = os.difftime(os.time(),t1)
    if deltatime > 0 then
        petUpdate(deltatime)
    end
    if hungryPercent <= 0 or energyPercent <= 0 or happyPercent <= 0 or healthPercent <= 0 then
        energyPercent = 0
        happyPercent = 0
        healthPercent = 0
        hungryPercent = 0
    end
end
function escreverDados()
    local data = getAnimation() .. "\n" ..
                tostring(hasPoop) .. "\n" ..
                tostring(isSleep) .. "\n" ..
                tostring(isSick) .. "\n" ..
                state .. "\n" .. 
                healthPercent .. "\n" ..
                happyPercent .. "\n" .. 
                hungryPercent .. "\n" ..
                energyPercent .. "\n" .. 
                tonumber(os.time())
    
    love.filesystem.write("data.txt", data)
end
function getAnimation()
    if animation == animationNormal then
        return "animationNormal"
    elseif animation == animationSleep then
        return "animationSleep"
    elseif animation == animationBad then
        return "animationBad"
    elseif animation == animationSick then
        return "animationSick"
    elseif animation == animationTired then
        return "animationTired"
    elseif animation == animationVaccione then
        return getAnimationLast()
    end
end

function getAnimationLast()
    if animationLast == animationNormal then
        return "animationNormal"
    elseif animationLast == animationSleep then
        return "animationSleep"
    elseif animationLast == animationBad then
        return "animationBad"
    elseif animationLast == animationSick then
        return "animationSick"
    elseif animationLast == animationTired then
        return "animationTired"
    end
end
function setAnimation(animacao)
    if animacao == "animationNormal" then
        return animationNormal
    elseif animacao == "animationSleep" then
        return animationSleep
    elseif animacao == "animationBad" then
        return animationBad
    elseif animacao == "animationSick" then
        return animationSick
    elseif animacao == "animationTired" then
        return animationTired
    end
end

function carregarDados()
    -- 1-animation
    -- 2-coco
    -- 3-dormindo
    -- 4-doente
    -- 5-estado
    -- 6-vida
    -- 7-felicidade
    -- 8-fome
    -- 9-energia
    -- 10-tempo

    if love.filesystem.exists("data.txt") then
        i = 1
        for line in love.filesystem.lines("data.txt") do
            if i == 1 then
              animation = setAnimation(tostring(line))  
              animationLast = animation
            elseif i == 2 then
                if tostring(line) == "true" then
                    hasPoop = true
                else
                    hasPoop = false
                end
                hasPoopAux = hasPoop
            elseif i == 3 then
                if tostring(line) == "true" then
                    isSleep = true
                else
                    isSleep = false
                end
                
            elseif i == 4 then
                if tostring(line) == "true" then
                    isSick = true
                else
                    isSick = false
                end
    
            elseif i == 5 then
                state = tostring(line)

            elseif i == 6 then
                healthPercent = tonumber(line)
                healthPercentFloat = healthPercent
                
            elseif i == 7 then
                happyPercent = tonumber(line)
                happyPercentFloat = happyPercent
                
            elseif i == 8 then
                hungryPercent = tonumber(line)
                hungryPercentFloat = hungryPercent

            elseif i == 9 then
                energyPercent = tonumber(line)
                energyPercentFloat = energyPercent
            elseif i == 10 then
                t1 = tonumber(line)
            end
            i = i+1
        end
    else
        print("Não foi possivel abrir o arquivo")
    end
end

function petUpdate(dt)
    if hungryPercent > 0 or energyPercent > 0 or happyPercent > 0 or healthPercent > 0 then
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
                love.audio.stop(sleepMusic)
                energyPercentFloat = 100
                isSleep = false
                UI = UINormal
                mouseStatus = "normal"
                animation = animationLast
            end
        end
    end
end

function love.update(dt)
    timeToSave = timeToSave + dt
    if timeToSave >= timeSave then
        escreverDados()
        timeToSave = 0
    end
    animation.currentTime = animation.currentTime + dt
    if animation.currentTime >= animation.duration then
        animation.currentTime = animation.currentTime - animation.duration
        if healthIsPress then
            hasPoop = hasPoopAux
            animation = animationLast
            healthIsPress = false
        end
    end
    petUpdate(dt)

    if hasPoop then
        healthRate = numberRateHealth * 2
    else
        healthRate = numberRateHealth
    end

    if state == "normal"  then
        if selected ~= "normal" and not isSleep then 
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
        
    elseif state == "sick" and not isSleep then
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

    elseif state == "sad" and not isSleep then
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
    
    elseif state == "tired" and not isSleep then
        if selected ~= "tired" then
            animation = animationTired
            animationLast = animation
            selected = "tired"
        end
        energyRate = numberRateEnergy * 3
        happyRate = numberRateHappy * 2
        healthRate = numberRateHealth 
        hungryRate = numberRateHungry * 3

        
        if energyPercent >= 30 then
            state = "normal"
        end
        
        
        if energyPercent <= 0 or happyPercent <= 0 or healthPercent <= 0 or hungryPercent <= 0 then
            state = "dead"
        end

    elseif state == "dead" then
        UI = UIGameOver
        mouseStatus = "normal"
        love.audio.stop(mainMusic)
        love.audio.stop(sleepMusic)
        love.audio.stop(gameMusic)
        love.audio.play(deadMusic)
    end        

end

function love.draw()
    love.graphics.draw(UI, 0, 0, 0, 1)
    love.graphics.setFont(fonteName)
    love.graphics.printf(name, love.graphics.getWidth() / 2  - 66, 135, 135, "center")
    if state ~= "dead" then
        love.graphics.printf({{0,0,0},"Health: \n" .. healthPercent .. "%"}, 0, 0, 200, "center")
        love.graphics.printf({{0,0,0},"Happiness: \n" .. happyPercent .. "%"}, 172, 0, 200, "center")
        love.graphics.printf({{0,0,0},"Hunger: \n" .. hungryPercent .. "%"}, 344, 0, 200, "center")
        love.graphics.printf({{0,0,0},"Energy: \n" .. energyPercent .. "%"}, 516, 0, 200, "center")
    else
        love.mouse.setCursor(normalCursor)
        love.graphics.printf({{0,0,0},"Infelizmente seu Pikachu morreu!"}, 70, 50, 516, "center")
    end
    if mouseStatus ~= "game" then
        local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
        love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], middleX(344), middleY(344), 0, 1)
    end    

    if hasPoop then
        love.graphics.draw(poop, 188, 448, 0, 1)
    end

    if state == "dead" then
        love.graphics.draw(dead, middleX(344), middleY(344), 0, 1)
        love.graphics.draw(deadButtonImage, 300, 190, 0, 1)
    end

    if mouseStatus == "game" then
        love.graphics.draw(imageGame, middleX(344), middleY(344), 0, 1)
        love.graphics.printf(resultGame, love.graphics.getWidth() / 2  + 10, 210, 100, "center")
    end
end

function love.mousepressed(mx, my, button)
    if state ~= "dead" then
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
            love.audio.pause(mainMusic)
            love.audio.play(healAudio)
            love.audio.play(mainMusic)
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
                love.audio.pause(mainMusic)
                love.audio.play(gameMusic)
                mouseStatus = "game"
            else
                UI = UINormal;
                mouseStatus = "normal"
                imageGame = game_base
                love.audio.stop(gameMusic)
                love.audio.play(mainMusic)
                resultGame = {{0,0,0,}, "----"}
            end

        --DORMIR
        elseif button == 1 and my >= 552 and my < 552 + 100 and  mx >= 572 and mx < 572 + 100 then
            if mouseStatus == "game" then
                love.audio.stop(gameMusic)
            end
            love.mouse.setCursor(normalCursor)
            if mouseStatus ~= "sleep" and energyPercent <= 98 then
                animationLast = animation
                UI = UISleep;
                isSleep = true
                animation = animationSleep
                love.audio.pause(mainMusic)
                love.audio.play(sleepMusic)
                mouseStatus = "sleep"
            else
                if energyPercent >= 10 then
                    isSleep = false
                    UI = UINormal;
                    animation = animationLast
                    love.audio.stop(sleepMusic)
                    love.audio.play(mainMusic)
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
                    love.audio.play(winGameAudio)
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
                    love.audio.play(winGameAudio)
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
                    love.audio.play(winGameAudio)
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
    elseif button == 1 and mx >= loveWidth/2 - 90 and mx < loveWidth/2 + 10 and my >= 190 and my < 225 then
        energyPercent = 100
        happyPercent = 100
        healthPercent = 100
        hungryPercent = 100
        isSleep = false
        isSick = false
        hasPoop = false
        state = "normal"
        animation = animationNormal
        escreverDados()
        love.load()
    end
end

function love.mousereleased( mx, my, button )
    if state ~= "dead" then
        if button == 1 and my >= 552 and my < 552 + 100 and  mx >= 297 and mx < 297 + 100 and isSleep == false then
            UI = UINormal;
            animationLast = animation
            animation = animationVaccione
            healthIsPress = true
            hasPoopAux = hasPoop
            hasPoop = false
        end
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
function love.load()
    --Carregando animações
    animationSleep = newAnimation(love.graphics.newImage("Sprites/pikachu_dormindo.png"), 344, 344, 2)
    animationNormal = newAnimation(love.graphics.newImage("Sprites/pikachu_normal.png"), 344, 344, 1.5)
    animationBad = newAnimation(love.graphics.newImage("Sprites/pikachu_triste.png"), 344, 344, 2)
    animationSick = newAnimation(love.graphics.newImage("Sprites/pikachu_doente.png"), 344, 344, 2)
    animationEgg = newAnimation(love.graphics.newImage("Sprites/Egg.png"), 344, 344, 1.5)

    --Ajustando a janela (tamanho, titulo e fixa)
    love.window.setMode(688, 688, {resizable=false, vsync=false}) 
    love.graphics.setBackgroundColor(255,255,255)
    love.window.setTitle( "Tamagotchi" )

    --Inicializando Interface gráfica
    UI = love.graphics.newImage("UI/UIIconsActions.png");
    fonteName = love.graphics.newFont("Fonte/fonte.ttf", 32)
    name = {{0,0,0}, "PIKACHU"} -- MUDAR
    animation = animationNormal --MUDAR

    --Carregando imagens do mouse
    normalCursor =  love.mouse.newCursor(love.image.newImageData("Imagens/normalCursor.png"), 1, 1)
    appleCursor =  love.mouse.newCursor(love.image.newImageData("Imagens/appleCursor.png"), 27, 31)
    love.mouse.setCursor(normalCursor)
    mouseStatus = "normal"

    -- carregar imagens
    poop = love.graphics.newImage("Imagens/poop.png")

    -- variaveis de controle
    hasPoop = false --MUDAR
    isSleep = false 
end

function love.update(dt)
    animation.currentTime = animation.currentTime + dt
    if animation.currentTime >= animation.duration then
        animation.currentTime = animation.currentTime - animation.duration
    end
end

function love.draw()
    love.graphics.draw(UI, 0, 0, 0, 1)
    love.graphics.setFont(fonteName)
    love.graphics.printf(name, 174, 120, 150, "center")
    local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
    love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], middleX(344), middleY(344), 0, 1)
    if hasPoop then
        love.graphics.draw(poop, 188, 448, 0, 1)
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
        
    elseif button == 1 and my >= 552 and my < 552 + 100 and  mx >= 159 and mx < 159 + 100 and isSleep == false then
        love.mouse.setCursor(normalCursor)
        mouseStatus = "normal"
        UI = love.graphics.newImage("UI/UIToiletSelected.png");
        
    elseif button == 1 and my >= 552 and my < 552 + 100 and  mx >= 297 and mx < 297 + 100 and isSleep == false then
        mouseStatus = "normal"
        love.mouse.setCursor(normalCursor)
        UI = love.graphics.newImage("UI/UIHealthCareSelected.png");
    elseif button == 1 and my >= 552 and my < 552 + 100 and  mx >= 435 and mx < 435 + 100 and isSleep == false then
        mouseStatus = "normal"
        love.mouse.setCursor(normalCursor)
        UI = love.graphics.newImage("UI/UIGameSelected.png");
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
end

function setAnimation(status)
    if(status == "normal")then
        return animationNormal
    elseif status == "eat" then
        return 
    elseif status == "heal" then
        return
    elseif status == "toilet" then
        return
    elseif status == "sleep" then
        return animationSleep
    end
end

function love.mousereleased( mx, my, button )
--     if button == 1 and my >= 537 and my < 537 + 100 and  mx >= 37 and mx < 37 + 100 then
--         UI = love.graphics.newImage("UI/UIIconsActions.png");
    if button == 1 and my >= 552 and my < 552 + 100 and  mx >= 159 and mx < 159 + 100 and isSleep == false then
         UI = love.graphics.newImage("UI/UIIconsActions.png");
    elseif button == 1 and my >= 552 and my < 552 + 100 and  mx >= 297 and mx < 297 + 100 and isSleep == false then
         UI = love.graphics.newImage("UI/UIIconsActions.png");
--     elseif button == 1 and my >= 537 and my < 537 + 100 and  mx >= 450 and mx < 450 + 100 then
--         UI = love.graphics.newImage("UI/UIIconsActions.png");
--     elseif button == 1 and my >= 537 and my < 537 + 100 and  mx >= 587 and mx < 587 + 100 then
--         UI = love.graphics.newImage("UI/UIIconsActions.png");
     end
 end
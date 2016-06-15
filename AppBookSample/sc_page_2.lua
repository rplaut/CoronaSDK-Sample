local composer = require( "composer" )
local widget   = require( "widget" )
local json     = require "json"

local scene = composer.newScene()

local snd_back_music = audio.loadSound("sounds/snd_back_1.mp3")

local img_bg, img_cona
local btn_previous_page, btn_next_page, btn_main_page
local particle_emitter
local channel_snd_back_music

local function goMainPage()
    local options = {
        effect = "zoomOutIn",
        time   = 450  
    }
    composer.gotoScene( "sc_main_menu", options)
end

local function goPreviousPage()
    local options = {
        effect = "slideRight",
        time   = 600  
    }
    composer.gotoScene( "sc_page_1", options)
end

local function goNextPage()
    local options = {
        effect = "slideLeft",
        time   = 600  
    }
    composer.gotoScene( "sc_page_3", options)
end

local function moveConaLitener( event )
    local target = event.target
    local phase  = event.phase

    if phase == "began" then 
        print('TOUCH BEGAN!!')
    elseif phase == "moved" then 
        print('TOUCH MOVED!!')
    elseif phase == "ended" or phase == "canceled" then
        print('TOUCH ENDED!!')

        local rand_num = math.random( 1, 2 )

        if rand_num == 1 then 
            transition.to( img_cona, { time = 800, x = display.contentWidth + 300, transition = easing.inBack, onComplete = function()
                img_cona.x = -300
                transition.to( img_cona, { time = 800, x = display.contentCenterX, transition = easing.outBack } )
            end } )
        else        
            transition.to( img_cona, { time = 400, yScale = 1, y = display.contentCenterY - 200, transition = easing.outQuart, onComplete = function()
                transition.to( img_cona, { time = 500, y = display.contentCenterY, transition = easing.outBounce } )
            end } )            
        end

    end
end

function scene:create( event )
    local sceneGroup = self.view

    img_bg   = display.newImage( "images/game_bg.png" )
    img_bg.x = display.contentCenterX 
    img_bg.y = display.contentCenterY
    img_bg:setFillColor( 1, 1, 1 )
    sceneGroup:insert( img_bg )  

    btn_main_page = widget.newButton( {                
        defaultFile = "images/btn_main_page.png",
        over        = "images/btn_main_page.png",
        onRelease   = goMainPage
    } )
    btn_main_page.anchorX = 1
    btn_main_page.anchorY = 0
    btn_main_page.x       = display.contentWidth - 20
    btn_main_page.y       = 20
    sceneGroup:insert( btn_main_page )

    btn_previous_page = widget.newButton( {                
        defaultFile = "images/btn_previous_page.png",
        over        = "images/btn_previous_page.png",
        onRelease   = goPreviousPage
    } )
    btn_previous_page.anchorX = 0
    btn_previous_page.anchorY = 1
    btn_previous_page.x       = 20
    btn_previous_page.y       = display.contentHeight - 20
    sceneGroup:insert( btn_previous_page )

    btn_next_page = widget.newButton( {                
        defaultFile = "images/btn_next_page.png",
        over        = "images/btn_next_page.png",
        onRelease   = goNextPage
    } )
    btn_next_page.anchorX = 1
    btn_next_page.anchorY = 1
    btn_next_page.x       = display.contentWidth - 20
    btn_next_page.y       = display.contentHeight - 20
    sceneGroup:insert( btn_next_page )

    img_cona       = display.newImage( "images/img_cona.png" )
    img_cona.x     = display.contentCenterX   
    img_cona.y     = display.contentCenterY
    img_cona.alpha = 1
    sceneGroup:insert( img_cona )   

    img_cona:addEventListener( "touch", moveConaLitener )
    
    local filePath        = system.pathForFile( "particle_params.json" )
    local f               = io.open( filePath, "r" )
    local particle_data   = f:read( "*a" ); f:close()
    local particle_params = json.decode( particle_data )
    
    particle_emitter   = display.newEmitter( particle_params )    
    particle_emitter.x = display.contentCenterX
    particle_emitter.y = -100  
    sceneGroup:insert( particle_emitter )

end


function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    
    if ( phase == "will" ) then        
        particle_emitter:start()
        channel_snd_back_music = audio.play( snd_back_music, { channel=1, loops=-1, fadein=5000 } )
    elseif ( phase == "did" ) then        
        
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then        
        particle_emitter:stop()
        audio.stop( channel_snd_back_music )        
    elseif ( phase == "did" ) then        
        
    end
end

function scene:destroy( event )
    local sceneGroup = self.view
    
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
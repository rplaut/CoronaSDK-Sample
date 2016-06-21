local composer = require( "composer" )
local widget   = require( "widget" )
local json     = require "json"

local scene = composer.newScene()

--mp3파일 로드
local snd_back_music = audio.loadStream("sounds/snd_back_1.mp3") -- 배경음악, 채널설정 불가
-- local snd_back_music = audio.loadSound("sounds/snd_back_1.mp3") -- 짧고 자주 재생되는 사운드( 총소리, 칼소리, 점프소리 ), 채널설정 가능

--파티클 설정값 가져오기
local filePath          = system.pathForFile( "particle_property.json" )
local f                 = io.open( filePath, "r" )
local particle_data     = f:read( "*a" ); f:close()
local particle_property = json.decode( particle_data )

local img_bg, img_cona
local btn_previous_page, btn_next_page, btn_main_page
local particle_emitter
local channel_snd_back_music

--메인 페이지로 이동
local function goMainPage()
    local options = {
        effect = "zoomOutIn",
        time   = 450  
    }
    composer.gotoScene( "sc_main_menu", options)
end

--이전 페이지로 이동
local function goPreviousPage()
    local options = {
        effect = "slideRight",
        time   = 600  
    }
    composer.gotoScene( "sc_page_1", options)
end

--다음 페이지로 이동
local function goNextPage()
    local options = {
        effect = "slideLeft",
        time   = 600  
    }
    composer.gotoScene( "sc_page_3", options)
end

local function conaTouchListener( event )
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
    img_cona:addEventListener( "touch", conaTouchListener )--코나에게 터치 리스너 달기

    particle_emitter   = display.newEmitter( particle_property )    
    particle_emitter.x = display.contentCenterX
    particle_emitter.y = -100  
    sceneGroup:insert( particle_emitter )
end


function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    
    if ( phase == "will" ) then
        --파티클 시작
        particle_emitter:start()
        --백그라운드 뮤직 플레이
        channel_snd_back_music = audio.play( snd_back_music, { loops = -1 } )
    elseif ( phase == "did" ) then        
        
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase      = event.phase

    if ( phase == "will" ) then        
        --파티클 중지
        particle_emitter:stop()
        --오디오 중지
        audio.stop( channel_snd_back_music )
    elseif ( phase == "did" ) then        
        
    end
end

function scene:destroy( event )
    local sceneGroup = self.view
    --오디오는 필요없을 경우 반드시 메모리 해제를 해야함
    audio.stop( channel_snd_back_music ); channel_snd_back_music = nil
    audio.dispose( snd_back_music ); snd_back_music = nil
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
local composer = require( "composer" )
local widget   = require( "widget" )
local physics  = require( 'physics' ); --physics.setDrawMode( "hybrid" )

local snd_back_music = audio.loadStream( "sounds/snd_back_2.mp3" )
local snd_cona       = audio.loadSound( "sounds/pong.wav" )

physics.start()

local scene = composer.newScene()

local img_bg, img_cona
local btn_previous_page, btn_next_page, btn_main_page
local channel_back_music, channel_snd_eft

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
    composer.gotoScene( "sc_page_2", options)
end

local function goNextPage()
    local options = {
        effect = "slideLeft",
        time   = 600  
    }
    composer.gotoScene( "sc_page_4", options)
end

--코로나 공식 샘플에 포함된 리스너 입니다.
function dragBody( event, params )
    local body = event.target
    local phase = event.phase
    local stage = display.getCurrentStage()

    if "began" == phase then
        stage:setFocus( body, event.id )
        body.isFocus = true

        channel_snd_eft = audio.play( snd_cona, { channel = audio.findFreeChannel() } )

        if params and params.center then
            body.tempJoint = physics.newJoint( "touch", body, body.x, body.y )
        else
            body.tempJoint = physics.newJoint( "touch", body, event.x, event.y )
        end

        if params then
            local maxForce, frequency, dampingRatio

            if params.maxForce then
                body.tempJoint.maxForce = params.maxForce
            end
            
            if params.frequency then
                body.tempJoint.frequency = params.frequency
            end
            
            if params.dampingRatio then
                body.tempJoint.dampingRatio = params.dampingRatio
            end
        end
    
    elseif body.isFocus then
        if "moved" == phase then
        
            body.tempJoint:setTarget( event.x, event.y )

        elseif "ended" == phase or "cancelled" == phase then
            stage:setFocus( body, nil )
            body.isFocus = false
            
            body.tempJoint:removeSelf()
            
        end
    end

    return true
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
    img_cona:addEventListener( "touch", dragBody )
    sceneGroup:insert( img_cona )

    --벽 생성( 물리적용된 코나가 화면 밖으로 빠져나가지 못하게 )
    local wall_left     = display.newRect( sceneGroup, 0, display.contentCenterY, 50, display.contentHeight )
    wall_left.isVisible = false  
    physics.addBody( wall_left, "static", { friction=0.5, bounce=0.3 } )    

    local wall_right     = display.newRect( sceneGroup, display.contentWidth, display.contentCenterY, 50, display.contentHeight )    
    wall_right.isVisible = false  
    physics.addBody( wall_right, "static", { friction=0.5, bounce=0.3 } )

    local wall_top     = display.newRect( sceneGroup, display.contentCenterX, 0, display.contentWidth, 50 )    
    wall_top.isVisible = false  
    physics.addBody( wall_top, "static", { friction=0.5, bounce=0.3 } )

    local wall_bottom     = display.newRect( sceneGroup, display.contentCenterX, display.contentHeight, display.contentWidth, 50 )
    wall_bottom.isVisible = false  
    physics.addBody( wall_bottom, "static", { friction=0.5, bounce=0.3 } )

    physics.addBody( img_cona, { density=0.9, friction=0.3, bounce=0.3 } )
end


function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    
    if ( phase == "will" ) then  
        physics.start()      
        channel_back_music = audio.play( snd_back_music, { channel=1, loops=-1, fadein=5000 } )
    elseif ( phase == "did" ) then        
        
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then        
       audio.stop( channel_back_music )
       audio.stop( channel_snd_eft )       
       physics.pause()
    elseif ( phase == "did" ) then        
 
    end
end

function scene:destroy( event )
    local sceneGroup = self.view

    --오디오는 필요없을 경우 반드시 메모리 해제를 해야함
    audio.stop( channel_back_music ); channel_back_music = nil
    audio.dispose( snd_back_music ); snd_back_music = nil
    audio.stop( channel_snd_eft ); channel_snd_eft = nil
    audio.dispose( snd_cona ); snd_cona = nil
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
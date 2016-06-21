--컴포저 임포트
local composer = require( "composer" )

--새로운 장면 생성
local scene = composer.newScene()

local img_bg, img_cona

local function goMainMenu()    
    composer.gotoScene( "sc_main_menu" )            
end

function scene:create( event )
    local sceneGroup = self.view    

    --흰색 배경 생성
    img_bg       = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    img_bg.alpha = 0
    img_bg:setFillColor( 1, 1, 1 )
    sceneGroup:insert( img_bg )

    -- 코나 캐릭터 생성
    img_cona       = display.newImage( "images/img_cona.png" )
    img_cona.x     = display.contentCenterX
    img_cona.y     = display.contentCenterY
    img_cona.alpha = 0
    sceneGroup:insert( img_cona )

end


function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        
    elseif ( phase == "did" ) then       

        --Fade in 효과
        transition.to( img_bg, { delay = 1000, time = 1000, alpha = 1  } )
        transition.to( img_cona, { delay = 1000, time = 1000, alpha = 1  } )

        --Fade out 효과
        transition.to( img_bg, { delay = 4000, time = 1000, alpha = 0  } )
        transition.to( img_cona, { delay = 4000, time = 1000, alpha = 0  } )        

        --5초 뒤에 goMainMenu 실행
        timer.performWithDelay( 5000, goMainMenu, 1 )
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then        
        
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
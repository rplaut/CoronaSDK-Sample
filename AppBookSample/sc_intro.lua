--컴포저 임포트
local composer = require( "composer" )

--새로운 장면 생성
local scene = composer.newScene()

local img_bg, img_cona

function scene:create( event )
    local sceneGroup = self.view    

    img_bg       = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    img_bg.alpha = 0
    img_bg:setFillColor( 1, 1, 1 )
    sceneGroup:insert( img_bg )

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

        transition.to( img_bg, { delay = 1000, time = 1000, alpha = 1  } )
        transition.to( img_cona, { delay = 1000, time = 1000, alpha = 1  } )

        transition.to( img_bg, { delay = 4000, time = 1000, alpha = 0  } )
        transition.to( img_cona, { delay = 4000, time = 1000, alpha = 0  } )

        local function goMainMenu()
            local options = {
                effect = "zoomOutInFade",
                time   = 600  
            }
            composer.gotoScene( "sc_main_menu", options )
            
        end

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
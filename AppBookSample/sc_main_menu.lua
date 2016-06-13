local composer = require( "composer" )
local widget   = require( "widget" )


local scene = composer.newScene()

local img_title, img_bg
local btn_start, btn_end

local function goFirstPage()
    local options = {
        effect = "slideLeft",
        time   = 600  
    }
    composer.gotoScene( "sc_page_1", options)
end

local function exitApp()
    local function listener( event )
        if ( event.action == "clicked" ) then            
            if ( event.index == 1 ) then                
                native.requestExit( )
            end
        end
    end
    native.showAlert( "CONA", "정말 종료 하시겠어요?", { "네", "아니요" }, listener )
end

function scene:create( event )
    local sceneGroup = self.view

    img_bg   = display.newImage( "images/main_bg.png" )
    img_bg.x = display.contentCenterX 
    img_bg.y = display.contentCenterY
    img_bg:setFillColor( 1, 1, 1 )
    sceneGroup:insert( img_bg )

    img_title   = display.newImage( "images/title_img.png" )   
    img_title.x = display.contentCenterX 
    img_title.y = display.contentCenterY
    sceneGroup:insert( img_title )

    btn_start = widget.newButton( {        
        width      = 400,
        height     = 100,
        label      = "시작",
        emboss     = false,
        shape      = "roundedRect",
        fillColor  = { default={252/255, 111/255, 83/255}, over={222/255, 81/255, 53/255} },        
        labelColor = { default={1,1,1,1}, over={1,1,1,0.4} },
        font       = "배달의민족 주아",
        fontSize   = 40,
        onRelease    = goFirstPage
    } )
    btn_start.x = display.contentCenterX
    btn_start.y = display.contentCenterY + 300
    sceneGroup:insert( btn_start )

    btn_end = widget.newButton( {        
        width      = 400,
        height     = 100,
        label      = "종료",
        emboss     = false,
        shape      = "roundedRect",
        fillColor  = { default={252/255, 111/255, 83/255}, over={222/255, 81/255, 53/255} },        
        labelColor = { default={1,1,1,1}, over={1,1,1,0.4} },
        font       = "배달의민족 주아",
        fontSize   = 40,
        onRelease    = exitApp
    } )
    btn_end.x = display.contentCenterX
    btn_end.y = display.contentCenterY + 450
    sceneGroup:insert( btn_end )

end


function scene:show( event )
    local sceneGroup = self.view
    local phase      = event.phase

    if ( phase == "will" ) then
        
    elseif ( phase == "did" ) then            

    end
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase      = event.phase

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
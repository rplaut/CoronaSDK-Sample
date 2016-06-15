local composer = require( "composer" )
local widget   = require( "widget" )

local scene = composer.newScene()


local img_bg, img_cona, txt_script
local btn_exit
local scroll_view

local function goMainPage()
    local options = {
        effect = "zoomOutIn",
        time   = 450  
    }
    composer.gotoScene( "sc_main_menu", options)
end

function scene:create( event )
    local sceneGroup = self.view    

    img_bg   = display.newImage( "images/game_bg.png" )
    img_bg.x = display.contentCenterX 
    img_bg.y = display.contentCenterY
    img_bg:setFillColor( 1, 1, 1 )
    sceneGroup:insert( img_bg )  
    
    img_cona       = display.newImage( "images/img_cona.png" )
    img_cona.x     = display.contentWidth/4   
    img_cona.y     = display.contentCenterY    
    sceneGroup:insert( img_cona )

    scroll_view = widget.newScrollView{
        width           = 1000,
        height          = 600,
        backgroundColor = { 1, 1, 1 },
        bottomPadding   = 100,
    }
    scroll_view.anchorX = 1
    scroll_view.x       = display.contentWidth - 100
    scroll_view.y       = display.contentCenterY
    sceneGroup:insert( scroll_view )

    local back_scroll_view   = display.newRect( sceneGroup, 0, 0, scroll_view.contentWidth + 4, scroll_view.contentHeight + 4 )    
    back_scroll_view.anchorX = 1
    back_scroll_view.x       = scroll_view.x + 2
    back_scroll_view.y       = scroll_view.y
    back_scroll_view:setFillColor( 0.4,0.4,0.4 )
    
    scroll_view:toFront()

    local txt_madeby   = display.newText{
        text     = "만든사람들",
        width    = back_scroll_view.contentWidth,
        height   = 0,
        font     = "배달의민족 주아",
        fontSize = 40,
        align    = "center",
    }
    txt_madeby.anchorY = 0
    txt_madeby.x       = scroll_view.contentWidth/2
    txt_madeby.y       = 50       
    txt_madeby:setFillColor( 0, 0, 0 )
    scroll_view:insert( txt_madeby )

    local str_content  = "자료준비,총괄 - 정자연\n\n디자인,개발 - 김성우\n\nLua강의 - 전영대\n\n개발,강의 - 김상호\n\n초상권 제공 - 코나\n\n그룹장 - 원강민\n\nBGM제공 - 바야바\n\n효과음 제공 - 김상호\n\n디자인 제공 - 김성우\n\n모임공간 제공 - MicroSoft\n\n식사제공 - 김성우\n\n도움1 - 노트북\n\n도움2 - 데스크탑\n\n도움3 - Corona with Lua"

    local txt_content   = display.newText{
        text     = str_content,
        width    = back_scroll_view.contentWidth,
        height   = 0,
        font     = "배달의민족 주아",
        fontSize = 30,        
        align    = "center",
    }
    txt_content.anchorY = 0
    txt_content.x       = scroll_view.contentWidth/2
    txt_content.y       = txt_madeby.y + txt_madeby.contentHeight + 75       
    txt_content:setFillColor( 0.5, 0.5, 0.5 )
    scroll_view:insert( txt_content )

    btn_exit  = widget.newButton( {        
        width      = display.contentWidth - 100,
        height     = 100,
        label      = "메인메뉴로",
        emboss     = false,
        shape      = "roundedRect",
        fillColor  = { default={252/255, 111/255, 83/255}, over={222/255, 81/255, 53/255} },        
        labelColor = { default={1,1,1,1}, over={1,1,1,0.4} },
        font       = "배달의민족 주아",
        fontSize   = 40,
        onRelease    = goMainPage
    } )
    btn_exit.x = display.contentCenterX
    btn_exit.y = display.contentHeight - btn_exit.contentHeight/2 - 50
    sceneGroup:insert( btn_exit )

end


function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        
    elseif ( phase == "did" ) then        
        
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
local composer = require( "composer" )
local widget   = require( "widget" )

local scene = composer.newScene()

local script_index = 1
local arr_sript = {
    "안녕? 나는 코나라고해!",
    "나는 똑똑한 바나나야~",
    "나는 아이들을 좋아해!",
    "그래서 아이들을 가르치는 일 을 하고있어!",
}

local img_bg, img_cona, txt_script
local btn_previous_page, btn_next_page, btn_main_page

local function goMainPage()
    local options = {
        effect = "zoomOutIn",
        time   = 450  
    }
    composer.gotoScene( "sc_main_menu", options)
end

local function goNextPage()
    local options = {
        effect = "slideLeft",
        time   = 600  
    }
    composer.gotoScene( "sc_page_2", options)
end

local function showScript()

    script_index = script_index + 1

    if script_index <= #arr_sript then 
        txt_script.text = arr_sript[ script_index ]
    else
        local function listener( event )
            if ( event.action == "clicked" ) then            
                if ( event.index == 1 ) then                
                    goNextPage()
                end
            end
        end
        native.showAlert( "CONA", "다음 페이지로 이동하시겠습니까?", { "네", "아니요" }, listener )
    end
end

local function startInit()
    txt_script.alpha      = 1
    img_msg_balloon.alpha = 1

    function img_bg:touch( event )
        local t     = event.target
        local phase = event.phase

        if event.phase == "ended" then
            showScript()
        end

        return true

    end

    img_bg:addEventListener( "touch", img_bg )
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
    img_cona.x     = -100   
    img_cona.y     = display.contentCenterY
    img_cona.alpha = 0
    sceneGroup:insert( img_cona )

    img_msg_balloon         = display.newImage( "images/img_msg_balloon.png" )
    img_msg_balloon.x       = display.contentCenterX + 80
    img_msg_balloon.y       = display.contentCenterY - 100
    img_msg_balloon.alpha   = 0
    img_msg_balloon.xScale  = -0.6;img_msg_balloon.yScale  =0.6   
    sceneGroup:insert( img_msg_balloon )

    txt_script   = display.newText{
        text     = arr_sript[ script_index ],
        width    = img_msg_balloon.contentWidth * 0.8,
        height   = 0,
        font     = "배달의민족 주아",
        fontSize = 25,
        align    = "center",
    }
    txt_script.x     = img_msg_balloon.x
    txt_script.y     = img_msg_balloon.y-10
    txt_script.alpha = 0    
    txt_script:setFillColor( 0, 0, 0 )
    sceneGroup:insert( txt_script )

end


function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        
    elseif ( phase == "did" ) then        
        transition.to( img_cona, { delay = 1000, time = 700, x = display.contentCenterX - 100, alpha = 1, transition = easing.outBack, onComplete = function()            
            startInit() 
        end  } )
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
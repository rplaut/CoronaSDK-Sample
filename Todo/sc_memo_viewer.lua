local composer = require( "composer" )
local widget   = require( "widget" )

--새로운 장면 생성
local scene = composer.newScene()

local i, memo_index, memo_data
local bg_background, bg_topbar, btn_back, txt_title
local txt_memeo_title, txt_memo_content
local margin_left, margin_right = 40, 40

--메모리스트 화면으로 이동한다.
local function goPreviousScene()
    local options ={
        effect = "fade",
        time   = 150,
    }
    composer.gotoScene( "sc_memo_list", options )
end

--메모수정 화면으로 이동한다.
local function goEditScene()
    local options ={
        effect = "fade",
        time   = 150,
        params = {
            index = memo_index,
        }
    }
    composer.gotoScene( "sc_memo_edit", options )
end

function scene:create( event )
    local sceneGroup = self.view

    --백그라운드 생성
    bg_topbar         = display.newRect( sceneGroup, 0, 0, _G.w, _G.h )    
    bg_topbar.x       = _G.centerX
    bg_topbar.y       = _G.centerY
    bg_topbar:setFillColor( 0.9,0.9,0.90 )

    --탑바 생성
    bg_topbar         = display.newRect( sceneGroup, 0, 0, _G.w, 200 )
    bg_topbar.anchorY = 0
    bg_topbar.x       = _G.centerX
    bg_topbar.y       = 0

    --화면 타이틀 생성
    txt_title = display.newText{
        parent   = sceneGroup,
        text     = "메모뷰어",
        font     = "배달의민족 주아",
        fontSize = 60,
        align    = "center",
    }
    txt_title.x = bg_topbar.x
    txt_title.y = bg_topbar.y + bg_topbar.contentHeight/2
    txt_title:setTextColor( 0,0,0 )

    --뒤로가기 버튼
    btn_back = widget.newButton( {                
        defaultFile = "images/btn_back.png",
        over        = "images/btn_back.png",
        onRelease   = goPreviousScene
    } )
    btn_back.anchorX = 0    
    btn_back.x       = 25
    btn_back.y       = bg_topbar.y + bg_topbar.contentHeight/2
    sceneGroup:insert( btn_back )

    -- 타이틀 생성
    txt_memeo_title = display.newText{
        parent   = sceneGroup,        
        text     = "",
        font     = "배달의민족 주아",
        width    = _G.w - margin_left - margin_right,
        fontSize = 50,
        align    = "left",
    }
    txt_memeo_title.anchorY = 0
    txt_memeo_title.x       = _G.centerX
    txt_memeo_title.y       = bg_topbar.y + bg_topbar.contentHeight + 100
    txt_memeo_title:setTextColor( 0,0,0 )

    --수정 버튼
    btn_edit = widget.newButton( {                
        defaultFile = "images/btn_edit.png",
        over        = "images/btn_edit.png",
        onRelease   = goEditScene
    } )
    btn_edit.anchorX = 1    
    btn_edit.x       = _G.w - 25
    btn_edit.y       = bg_topbar.y + bg_topbar.contentHeight/2
    sceneGroup:insert( btn_edit )

    -- 메모 본문 생성
    txt_memeo_content = display.newText{
        parent   = sceneGroup,
        text     = "",
        font     = "배달의민족 주아",
        width    = _G.w - margin_left - margin_right,
        fontSize = 40,
        align    = "left",
    }
    txt_memeo_content.anchorY = 0
    txt_memeo_content.x       = _G.centerX
    txt_memeo_content.y       = txt_memeo_title.y + txt_memeo_title.contentHeight + 50
    txt_memeo_content:setTextColor( 0.3,0.3,0.3 )
    
end


function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        
        if composer.getSceneName( "previous" ) == "sc_memo_edit" then --이전화면이 메모수정 화면이면 메모데이터를 다시 가져온다.
            memo_data = MemoManager:getMemo( memo_index )            
        elseif composer.getSceneName( "previous" ) == "sc_memo_list" then --이전화면이 메모리스트 화면이면 inbex를 받아와서 메모데이터를 가져온다.
            memo_data  = MemoManager:getMemo( event.params.index )
            memo_index = event.params.index           
        end

        txt_memeo_title.text   = memo_data.title --제목 텍스트 변경
        txt_memeo_content.text = memo_data.content --본문 텍스트 변경

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

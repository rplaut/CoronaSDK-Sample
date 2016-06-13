local composer = require( "composer" )
local widget   = require( "widget" )

--새로운 장면 생성
local scene = composer.newScene()

local memo_index, memo_data, is_new
local bg_background, bg_topbar, btn_back, txt_title, btn_save
local field_title, field_content
local margin_left, margin_right = 40, 40

local function goPreviousScene()
    local options ={
        effect = "fade",
        time   = 150,
    }
    composer.gotoScene( composer.getSceneName( "previous" ), options )
end

--메모를 저장한다.
--새 메모면 데이터를 추가하고, 메모수정 이면 저장한다.
local function saveMemo()
    if is_new == true then 
        MemoManager:addMemo( field_title.text, field_content.text )
    else
        MemoManager:saveMemo( memo_index, field_title.text, field_content.text )
    end
    goPreviousScene()
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

    --화면 타이틀 생성
    txt_title = display.newText{
        parent   = sceneGroup,
        text     = "메모수정",
        font     = "배달의민족 주아",
        fontSize = 60,
        align    = "center",
    }
    txt_title.x = bg_topbar.x
    txt_title.y = bg_topbar.y + bg_topbar.contentHeight/2
    txt_title:setTextColor( 0,0,0 )

    --저장 버튼
    btn_save = widget.newButton( {                
        defaultFile = "images/btn_save.png",
        over        = "images/btn_save.png",
        onRelease   = saveMemo
    } )
    btn_save.anchorX = 1    
    btn_save.x       = _G.w - 25
    btn_save.y       = bg_topbar.y + bg_topbar.contentHeight/2
    sceneGroup:insert( btn_save )    

    --제목 필드생성
    field_title             = native.newTextField( 0, 0, _G.w - margin_left - margin_right, 100 )    
    field_title.anchorY     = 0
    field_title.x           = _G.centerX
    field_title.placeholder = "제목을 입력해주세요"
    field_title.font        = native.newFont( "배달의민족 주아", 50 )    
    field_title.y           = bg_topbar.y + bg_topbar.contentHeight + 100
    field_title.isVisible   = false
    field_title:setTextColor(0,0,0)    
    sceneGroup:insert( field_title )


    --본문 텍스트박스 필드생성
    field_content             = native.newTextBox( 0, 0, _G.w - margin_left - margin_right, _G.h/2 )    
    field_content.anchorY     = 0
    field_content.x           = _G.centerX
    field_content.placeholder = "메모 내용을 입력해주세요"    
    field_content.font        = native.newFont( "배달의민족 주아", 40 )    
    field_content.y           = field_title.y + field_title.contentHeight + 50
    field_content.isVisible   = false
    field_content.isEditable  = true
    field_content:setTextColor(0.3,0.3,0.3)
    sceneGroup:insert( field_content )
    
end


function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

        if event.params.is_new == true then 
            txt_title.text = "새 메모" --화면타이틀 변경
            is_new         = true
        else
            txt_title.text     = "메모수정" --화면타이틀 변경
            is_new             = false
            memo_data          = MemoManager:getMemo( event.params.index )
            memo_index         = event.params.index
            field_title.text   = memo_data.title --제목 필드의 텍스트 변경
            field_content.text = memo_data.content --본문 필드의 텍스트 변경
        end


    elseif ( phase == "did" ) then

        --텍스트 필드와 텍스트박스( 그 외 대다수 navtive객체 )는 화면 이동간에 애니메이션 처리가 매끄럽게 되지 않는다.
        --그래서 화면 완전히 올라온후 표시한다.
        field_title.isVisible   = true
        field_content.isVisible = true
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then   
        --텍스트 필드와 텍스트박스( 그 외 대다수 navtive객체 )는 화면 이동간에 애니메이션 처리가 매끄럽게 되지 않는다.
        --그래서 화면이 사라지기 전에 숨긴다.
        field_title.isVisible   = false
        field_content.isVisible = false

        --입력필드 초기화
        field_title.text        = ""
        field_content.text      = ""

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

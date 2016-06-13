local composer = require( "composer" )
local widget   = require( "widget" )

--새로운 장면 생성
local scene = composer.newScene()

local i
local bg_background, bg_topbar, txt_title
local list_memo, btn_add_memo
local arr_memo_data

--Row를 터치했을때 실행됨
local function onRowTouch( event )
    
    if event.phase == "release" then 

        local options ={
            effect = "fade",
            time = 150,
            params = {
                index = event.row.index,
            }
        }
        composer.gotoScene( "sc_memo_viewer", options )

    end
end

--메모작성 화면으로 이동
local function goAddMemo(  )
    local options ={
        effect = "fade",
        time   = 150,
        params = {
            is_new = true,
        }
    }
    composer.gotoScene( "sc_memo_edit", options )
end

local function lodeMemoList()

    --메모 데이터를 읽어들인다.
    arr_memo_data = MemoManager:getMemoList()

    --기존에 Row가 있으면 모두 삭제한다.
    if list_memo:getNumRows() > 0 then 
        list_memo:deleteAllRows( )
    end

    --메모데이터를 테이블뷰에 insert한다.
    for i = 1, #arr_memo_data, 1 do
        list_memo:insertRow{            
            rowHeight  = 200,
            rowColor   = { default = { 0.95,0.95,0.95 }, over = { 30/255, 144/255, 1 } },
            lineColor  = { 0.8,0.8,0.8 }            
        }
    end
end

local function deleteMemo( index )

    local function alertListener( event )
        if event.action == "clicked" and event.index == 1 then
            MemoManager:removeMemo( index )
            lodeMemoList()
        end
    end
    
    native.showAlert( "경고", "정말 메모를 삭제 하시겠습니까?", { "네", "아니오" },  alertListener)

end

--Row 렌더러
local function onRowRender(event)
    local phase  = event.phase
    local row    = event.row    
    local index  = event.row.index    

    local margin_left   = 40
    local margin_right  = 120
    local margin_top    = 20
    local margin_bottom = 20

    local txt_row_title = display.newText{
        parent   = row,
        text     = MemoManager:getMemo(index).title,
        width    = row.contentWidth - margin_left - margin_right,        
        font     = "배달의민족 주아",
        fontSize = 50,
        align    = "left",
    }
    txt_row_title.anchorX = 0
    txt_row_title.x       = margin_left
    txt_row_title.y       = row.contentHeight/2
    txt_row_title:setTextColor( 0,0,0 )

    --메모 삭제 버튼
    local btn_delete = widget.newButton( {                
        defaultFile = "images/btn_delete.png",
        over        = "images/btn_delete.png",
        onRelease   = function()
            deleteMemo( index )
        end
    } )
    btn_delete.anchorX = 1    
    btn_delete.x       = row.contentWidth - 20
    btn_delete.y       = row.contentHeight/2
    row:insert( btn_delete )
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
        text     = "메모리스트",
        font     = "배달의민족 주아",
        fontSize = 60,
        align    = "center",
    }
    txt_title.x = bg_topbar.x
    txt_title.y = bg_topbar.y + bg_topbar.contentHeight/2
    txt_title:setTextColor( 0,0,0 )
    
    --메모리스트를 보여줄 테이블뷰 생성
    list_memo = widget.newTableView{      
        width          = _G.w, 
        height         = _G.h - bg_topbar.contentHeight,
        hideBackground = true,        
        onRowRender    = onRowRender,        
        onRowTouch     = onRowTouch,
    }
    list_memo.anchorY = 0
    list_memo.x       = _G.centerX
    list_memo.y       = bg_topbar.contentHeight
    sceneGroup:insert( list_memo )

    --메모 생성 버튼
    btn_add_memo = widget.newButton( {                
        defaultFile = "images/btn_add_memo.png",
        over        = "images/btn_add_memo.png",
        onRelease   = goAddMemo
    } )
    btn_add_memo.anchorX = 1    
    btn_add_memo.x       = _G.w - 25
    btn_add_memo.y       = bg_topbar.y + bg_topbar.contentHeight/2
    sceneGroup:insert( btn_add_memo )

end


function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

        --메모 리스트를 갱신한다.
        lodeMemoList()
        
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

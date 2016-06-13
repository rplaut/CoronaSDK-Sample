--[[
지인의 부탁으로 이지고에사용된 슬라이드뷰를 공유하게 되었습니다.

스크롤뷰(혹은 테이블뷰)에 속한 객체의 터치 이벤트를 어떻게 콘트롤 하는지 확인하고 싶다면
SlideView.lua의 thouchListener를 확인해보세요

즐코로나 하세요~^^
]]--


--위젯 임포트
local widget = require( "widget" )

--라이브러리 임포트
local widgetSlideView = require( "SlideView" )

--스크롤뷰 생성
local scrollView = widget.newScrollView{ 
	width                    = display.contentWidth,
	height                   = display.contentHeight,
	horizontalScrollDisabled = true,
	backgroundColor          = {0.5,0.5,0.5}
}
scrollView.x = display.contentWidth/2
scrollView.y = display.contentHeight/2

--슬라이드뷰 객체 생성
local slideView = widgetSlideView:newSlideView{ 		
	width  = display.contentWidth-50,    --슬라이드뷰 넓이 
	height = 320,    --슬라이드뷰 높이
	gap    = 10,     --각 슬라이드들의 간격		
}
slideView.x = display.contentWidth/2
slideView.y = display.contentHeight/2

--슬라이드 5개 추가
local i
for i = 1, 5, 1 do
	local slideImage = display.newRect( 0, 0, slideView.contentWidth - 40, slideView.contentHeight )		
	slideImage:setFillColor( math.random(1,255)/255, math.random(1,255)/255, math.random(1,255)/255 )

	slideView:addSlide( slideImage, i, function()
		print(" 현재 슬라이드는 " .. i .. "번째 슬라이드 입니다.")
	end )
end

--슬라이드뷰 스크롤뷰 안에 넣기
scrollView:insert( slideView )

--슬라이드뷰가 스크롤뷰 안에 insert 되었을때 대응
--세로로 드래그 하면 스크롤뷰가 터치에 반응하고
--가로로 드래그 하면 슬라이드뷰가 터치에 반응한다.
slideView:setParentScroll( scrollView )

-- 이전 슬라이드 이동 버튼
local btn_previous = widget.newButton{
	width  = 100,
	height = 50,
	label  = "<<",
	onRelease = function()
		slideView:goPrevious()
	end
}
btn_previous.anchorX = 0
btn_previous.anchorY = 1
btn_previous.x       = 0
btn_previous.y       = display.contentHeight

-- 다음 슬라이드 이동 버튼
local btn_previous = widget.newButton{
	width  = 100,
	height = 50,
	label  = ">>",
	onRelease = function()
		slideView:goNext()
	end
}
btn_previous.anchorX = 1
btn_previous.anchorY = 1
btn_previous.x       = display.contentWidth
btn_previous.y       = display.contentHeight


--페이지 인덱스 만들기
local index = slideView:newIndicatorText( 12, " of " )
index.x     = display.contentWidth/2
index.y     = display.contentHeight - 25


--자동 롤링
--이지고 메인의 상당 롤링배너에 사용됨~
-- slideView:startAutoSlide( )	
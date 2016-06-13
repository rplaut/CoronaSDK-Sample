
-- 기본 백그라운드 컬러를 흰색으로 설정
display.setDefault( "background", 0.95, 0.95, 0.95 )

-- 상태바 hidden 설정 
display.setStatusBar( display.HiddenStatusBar ) 

--컴포저 임포트
local composer = require( "composer" )

--데이터 매니저 
MemoManager = require( "MemoManager" )
MemoManager:init()

--글로벌 변수 설정( 편의를 위해 선언 했습니다. )
_G.w       = display.contentWidth
_G.h       = display.contentHeight
_G.centerX = display.contentCenterX
_G.centerY = display.contentCenterY

--리스트 화면으로 이동
composer.gotoScene( "sc_memo_list" )

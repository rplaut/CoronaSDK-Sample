--컴포저 임포트
local composer = require( "composer" )

--새로운 장면 생성
local scene = composer.newScene()

--[[
    @ 장면이 처음 로드 될때 실행
    @ 장면에서 정적인 객체들을 여기서 생성함
    @ ex = 배경, 나무, 집, 등등
--]]
function scene:create( event )
    local sceneGroup = self.view    

end

--[[
    @ 장면이 생성되고 실제 화면에 보여질때 호출됨
    @ 장면 초기화, 새로고침 등등
--]]
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase


    if ( phase == "will" ) then    --화면에 보여지기 직전
        
    elseif ( phase == "did" ) then --화면에 완전하게 보여진 후  
       
    end
end


--[[
    @ 장면이 화면에서 숨겨질 때 호출됨
    @ 정리, 삭제 등등
--]]
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then    --숨겨지기 직전
        
    elseif ( phase == "did" ) then --숨겨진 후 

    end
end


--장면이 삭제 될때 
function scene:destroy( event )
    local sceneGroup = self.view 

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
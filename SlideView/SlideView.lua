local Class = {}

local abs = math.abs
--[[
	
	--라이브러리 임포트
	local widgetSlideView = require( "SlideView" )

	--슬라이드뷰 객체 생성
	local slideView = widgetSlideView:newSlideView{ 		
		width           = 640,    --슬라이드뷰 넓이 
		height          = 320,    --슬라이드뷰 높이
		gap             = 10,     --각 슬라이드들의 간격
		number_of_load  = 2,      --슬라이드 추가 되었을때 callBack이 먼저 실행될 갯수 ( 2면 첫번째 두번쨰 슬라이드의 콜백이 추가되자마자 실행됨 )
		is_sequens_load = true    --슬라이드들이 차례대로 로드 될 것인지 설정
	}
	slideView.x = display.contentWidth/2
	slideView.y = display.contentHeight/2
	
	--슬라이드뷰 추가
	local i
	for i = 1, 5, 1 do
		local slideImage = display.newImage( "images/slide_" .. i .. ".png" )

		slideView:addSlide( slideImage, i, function()
			print(" 현재 슬라이드는 " .. i .. "번째 슬라이드 입니다.")
		end )
	end

	--슬라이드뷰가 스크롤뷰 안에 insert 되었을때 대응
	slideView:setParentScroll( scrollView )

]]--

function Class:newSlideView( options )
	local current_index      = 1
	local parentScroll       = nil
	local gap                = options.gap or 0
	local width              = options.width or display.contentWidth
	local height             = options.height or display.contentHeight		
	local number_of_load     = options.number_of_load or 0
	local is_sequens_load    = options.is_sequens_load or false

	local target_indicator = nil
	local target_indexText = nil
	
	--최상위 그룹 생성
	--콘테이너 그룹을 사용하여 마스킹 
	local group = display.newContainer( width, height )

	--백그라운드 생성 
	group.bg = display.newRect( group, 0, 0, width, height )
	group.bg:setFillColor( 0,0,0,0.01 )	
	
	group.slide          = {} --슬라이드 관리 배열	
	group.slideGroup     = display.newGroup( ); group:insert(group.slideGroup); --슬라이드 그룹

	group.indicator      = {}
	group.indicatorGroup = display.newGroup( ); group:insert(group.indicatorGroup); group.indicatorGroup.anchorChildren = true -- 인디케이터 그룹

	-----------PRIVITE-------------------------------------------------------------
	-- group.slide 에 추가된 순서대로 슬라이드들을 정렬함
	local function alignSlide()
		local i

		local move_pos  = {}
		local sum_x_pos = 0

		for i = 1, #group.slide, 1 do
			if i == 1 then 
				move_pos[i] = 0
			else
				move_pos[i] = move_pos[i-1] + group.slide[i-1].contentWidth/2 + gap + group.slide[i].contentWidth/2
			end
		end

		for i = 1, #group.slide, 1 do
			group.slide[i].x =  move_pos[i]
		end
	end

	-----------PUBLIC-------------------------------------------------------------
	-- 1 / 5 <----이것과 같은 객체를 리턴해줌
	-- e.g > slide:newIndicatorText( 15, "of" )
	function group:newIndicatorText( fontSize, separator )

		local separator = separator or "/"

		local indexGroup = display.newGroup( )
		indexGroup.anchorChildren = true

		indexGroup.txt = display.newText{
			text     = "",   
			fontSize = fontSize,
			-- font     = _G.FONT['NORMAL'],    
			align    = "left",
		}
		indexGroup:insert( indexGroup.txt )

		function indexGroup:setIndex( index )
			indexGroup.txt.text = tostring(index) .. tostring(separator) .. tostring( #group.slide )
		end
		indexGroup:setIndex( current_index )
		target_indexText = indexGroup

		return indexGroup
	end

	-- 페이지 인덱스 인디케이터를 리턴해줌
	-- e.g > slide:newIndicator( "images/indicator_on.png", "images/indicator_of.png", 20 )	
	function group:newIndicator( image_on, image_off, gap )
		local indicatorGroup = display.newGroup( )
		indicatorGroup.anchorChildren = true
		indicatorGroup.indicator = {}

		local function getIndicator( image_on, image_off )
			local indicator = display.newGroup( )
			
			indicator.obj_off = _G.newImage( image_off )
			indicator:insert( indicator.obj_off )

			indicator.obj_on       = _G.newImage( image_on )
			indicator.obj_on.alpha = 1
			indicator:insert( indicator.obj_on )

			function indicator:on()
				indicator.obj_on.alpha = 1
			end

			function indicator:off()
				indicator.obj_on.alpha = 0
			end

			indicator:off()
			return indicator
		end

		for i = 1,  #group.slide, 1 do
			indicatorGroup.indicator[i] = getIndicator( image_on, image_off )
			indicatorGroup:insert(indicatorGroup.indicator[i]  )
			if i == 1 then 
				indicatorGroup.indicator[i].x = 0
			else
				indicatorGroup.indicator[i].x = indicatorGroup.indicator[i-1].x + indicatorGroup.indicator[i-1].contentWidth/2 + indicatorGroup.indicator[i].contentWidth/2 + ( gap or _G.CVT("h", 20) )
			end
		end

		function indicatorGroup:changeIndex( index )
			local i
			for i = 1, #indicatorGroup.indicator, 1 do
				local indi = indicatorGroup.indicator[i]

				if index == i then 
					indi:on()
				else
					indi:off()
				end
			end
		end

		target_indicator = indicatorGroup
		indicatorGroup:changeIndex( current_index )
		return indicatorGroup
	end

	--슬라이드를 해당 인덱스로 이동함
	-- e.g > slide:goSlide( 3, { trans = easing.outBack, animTime = 500 } )
	function group:goSlide( index, options )
		local options  = options or {}
		local is_fast  = options.is_fast or false
		local trans    = options.trans or easing.outExpo
		local animTime = options.animTime or 300

		current_index = index

		if is_fast then 
			group.slideGroup.x = -group.slide[current_index].x
			if group.slide[current_index].callBack then 
				group.slide[current_index].callBack( )
			end
			if is_sequens_load and group.slide[current_index+2] then 
				group.slide[current_index+2].callBack( )
			end
		else
			if group.slideGroup.insert then 
				group.transId = transition.to( group.slideGroup, { time = animTime, x = -group.slide[current_index].x, transition = trans, onComplete = function()
					if group.slide[current_index].callBack then 
					group.slide[current_index].callBack( )
					end
					if is_sequens_load and group.slide[current_index+2] then 
						group.slide[current_index+2].callBack( )
					end
				end } )
			end
		end

		if target_indicator then 
			target_indicator:changeIndex( current_index )
		end
		if target_indexText then 
			target_indexText:setIndex( current_index )
		end
	end

	--다음슬라이드로 이동
	function group:goNext(  )
		if current_index + 1 <= #self.slide then 
			 self:goSlide( current_index + 1 )
		end
	end

	--이전 슬라이드로 이동
	function group:goPrevious(  )
		if current_index - 1 >= 1 then 
			 self:goSlide( current_index - 1 )
		end
	end

	-- 슬라이드 그룹에 슬라이드를 추가
	--[[
	
	local image = display.newImage( "images/field.png" ) -- 슬라이드에 포함될 객체 

	slide:addSlide( image, 1, function(  )
		print(" 해당 슬라이드가 현재 슬라이드가 될때 호출될 콜백을 이 곳에 정의 되어야 합니다. ")
	end, false)

	]]--
	function group:addSlide( g_slide, add_index, callBack )
		
		group.slideGroup:insert( g_slide )

		table.insert( group.slide, add_index,  g_slide)

		if callBack then 
			g_slide.callBack = callBack
		end

		alignSlide()

		if #group.indicator > 0 then 
			onIndicator( current_index )
		end

		if is_sequens_load then 
			if add_index <= number_of_load then 
				callBack( event )
			end
		end
	end

	-- 슬라이드의 겟수를 리턴
	function group:getNumOfSlide()
		return #group.slide
	end

	-- 자동 롤링 관련
	group.autoSlideState = false
	function group:startAutoSlide( is_resume )		
		if self.autoSlideState == false or is_resume == true then 
			self.autoSlideState = true
			local function run()
				local temp_index = current_index + 1

				if temp_index > #self.slide then 
					temp_index = 1
				end

				self:goSlide( temp_index, {
					trans    = easing.inOutQuart,
					animTime = 800
				} )	
			end

			if self.autoSlideTimerId then timer.cancel( self.autoSlideTimerId ) end
			
			self.autoSlideTimerId = timer.performWithDelay( 5000, run, -1 )
		end
	end
	function group:stopAutoSlide()
		if self.autoSlideState == true then 
			self.autoSlideState = false
			if self.autoSlideTimerId then timer.cancel( self.autoSlideTimerId ) end
			self:goSlide( current_index, { is_fast = true } )	
		end
	end
	function group:cancelAutoSlide()
		if self.autoSlideTimerId then timer.cancel( self.autoSlideTimerId ) end		
	end
	function group:resumeAutoSlide()
		group:startAutoSlide( true )	
	end


	--터치 관련
	function group:setParentScroll( obj_scroll )
		parentScroll = obj_scroll
	end	

	local function touchListener(event)
		local phase = event.phase
		local t     = group.slideGroup

	    if phase == "began" then	    		    	
	    	display.getCurrentStage():setFocus(event.target)
	    	event.target.isFocus = true

	        if #group.slide > 0 then				

				t.x0 = event.x - t.x
				t.y0 = event.y - t.y

				t.scroll_state = "began"
			end

			if parentScroll then 
				if parentScroll.id == "widget_tableView" then
	                parentScroll._view:touch(event)
	                t.parentScrollType = "table"
	            else 
	                t.parentScrollType = "scroll"
	            end
			end
	    elseif event.target.isFocus then
	    	
	        if phase == "moved" then

	       		if #group.slide > 0 then 
	       			
					local dx = abs( ( event.x - event.xStart ) )
					local dy = abs( ( event.y - event.yStart ) )

					local t = group.slideGroup

					if dy > 10 and t.scroll_state == "began"  then 
						if parentScroll then 
							t.scroll_state = "scroll"
						end
					end

					if dx > 5 and t.scroll_state == "began" then 
						if group.transId then transition.cancel( group.transId ) end
						if group.autoSlideState == true then 
							group:cancelAutoSlide()
						end
						t.scroll_state = "slide"
					end

					if t.scroll_state == "slide" then 
						local t = group.slideGroup
						t.x = event.x - t.x0 
					elseif t.scroll_state == "scroll" then 
						if parentScroll then 
							if t.parentScrollType == "scroll" then 
								parentScroll:takeFocus( event )
							else
								parentScroll._view:touch(event)
							end
						end 
					end
				end
	        elseif phase == "ended" or phase == "cancelled" then
		        display.getCurrentStage():setFocus(nil)
	            event.target.isFocus = false
	       		if group.autoSlideState == true then 
					group:resumeAutoSlide()
				end

				if #group.slide > 0 then
					local t = group.slideGroup
					if t.scroll_state == "slide" then 
						local dx = ( event.xStart - event.x  )

						local goIndex = current_index
						
						if dx > 30 then --다음 슬라이드
							goIndex = goIndex + 1
							if goIndex >= #group.slide then 		
								goIndex = #group.slide				
							end
						elseif dx < -30 then -- 이전 슬라이드 			
							goIndex = goIndex - 1				
							if goIndex <= 1 then 			
								goIndex = 1
							end
						end				
						group:goSlide( goIndex )
					elseif t.scroll_state ~= "scroll" then 
						group:goSlide( current_index )
					end

					t.scroll_state = nil
				end
	        end
	    end
	    return true
	end

	group.bg:addEventListener( "touch", touchListener )
	return group
end

return Class
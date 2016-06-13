local json = require ("json");

local Class     = {}

--어플리케이션 내부에 저장될 파일의 이름
local file_name = "memo_data"

--메모리스트를 담을 테이블(배열)
local arr_memo_data = {}

--최초에 기본으로 생성되는 메모 데이터
local first_memo = {  
    {  
        title   = "코로나의 세계로 오신것을 환영합니다.",
        content = "코로나는 크로스플랫폼 2D게임 엔진입니다.\n하지만 코로나로 일반 앱을 만들기에 부족함이 없습니다. "
    }
}

------------------------------------------------------------------------------
--PRIVATE FUNCTION
------------------------------------------------------------------------------

--새로운 JSON 파일을 만듬
function makeMemoFile( )
    local path = system.pathForFile( file_name .. ".json", system.DocumentsDirectory ) 
    local file = io.open( path, "r" ) 

    if not file then 
        fh = io.open( path, "w" )

        if fh then             
            fh:write( json.encode( first_memo ) )
            
        else
            print("NOT CREATED FILE : " .. file_name)
        end

    elseif file then 
        print("ERROR : A file that already exists")
    end

    io.close( fh )
end

--파일을 수정함
local function updateMemoFile( ) 

    local write_data = json.encode(arr_memo_data)

    local path = system.pathForFile( file_name .. ".json", system.DocumentsDirectory ) 
    local file = io.open( path, "w" ) 

    if file then 
        file:write(write_data)         
    end

    io.close(file)
end

--메모 데이터를 읽고 Json -> lua테이블 형식으로 변환하여 리턴
local function readMemoFile( )
    local result
    local path = system.pathForFile(file_name .. ".json", system.DocumentsDirectory ) 
    local file = io.open( path, "r" ) 

    if file then 
        result =  json.decode( file:read("*a") ) 
        io.close(file) 
        return result
    else
        print("ERROR : 파일이 존재하지 않습니다")
        io.close(file)
        return false
    end 
end

--메모 파일이 있는지 확인한다
local function isExistMemoFIle()
    local path = system.pathForFile( file_name .. ".json", system.DocumentsDirectory ) 
    local file = io.open( path, "r" ) 

    if file then 
        io.close( file )
        return true
    else
        -- io.close( file )
        return false
    end    
end


------------------------------------------------------------------------------
--PUBLIC FUNCTION
------------------------------------------------------------------------------

--메모 전체리스트를 리턴한다.
function Class:getMemoList( )
    return arr_memo_data
end

--인덱스에 해당하는 메모 데이터를 리턴한다.
function Class:getMemo( memo_index )
    return arr_memo_data[memo_index]
end

--메모 삭제
function Class:removeMemo( memo_index )
    table.remove( arr_memo_data, memo_index)
    updateMemoFile()
end

--메모 저장
function Class:saveMemo( memo_index, str_title, str_content )
    arr_memo_data[memo_index].title   = str_title
    arr_memo_data[memo_index].content = str_content

    updateMemoFile()
end

--메모 추가
function Class:addMemo( str_title, str_content )
    local memo = {
        title   = str_title,
        content = str_content
    }
    table.insert( arr_memo_data, 1, memo )
    updateMemoFile()
end

--초기화
function Class:init()
    if isExistMemoFIle() then --이미 메모JSON파일이 존재하면 바로 읽는다
        arr_memo_data = readMemoFile()
    else
        makeMemoFile()
        return self:init() 
    end

end

return Class




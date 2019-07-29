-- encrypt.lua
-- Author: cndy1860
-- Date: 2019-07-14
-- Descrip: 加密相关

local function decode(str64)
	local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
	local temp={}
	for i=1,64 do
		temp[string.sub(b64chars,i,i)] = i
	end
	temp['=']=0
	local str=''
	for i=1,#str64,4 do
		if i>#str64 then
			break
		end
		local data = 0
		local str_count=0
		for j=0,3 do
			local str1=string.sub(str64,i+j,i+j)
			if not temp[str1] then
				return
			end
			if temp[str1] < 1 then
				data = data * 64
			else
				data = data * 64 + temp[str1]-1
				str_count = str_count + 1
			end
		end
		for j=16,0,-8 do
			if str_count > 0 then
				str=str..string.char(math.floor(data/math.pow(2,j)))
				data=math.mod(data,math.pow(2,j))
				str_count = str_count - 1
			end
		end
	end
	local last = tonumber(string.byte(str, string.len(str), string.len(str)))
	if last == 0 then
		str = string.sub(str, 1, string.len(str) - 1)
	end
	return str
end

--加载加密过的文件
function encrequire(modName)
	local decStr = decode(require(modName.."_"))
	if not decStr then
		dialog("解码失败!")
		lua_exit()
	end
	
	local f = loadstring(decStr)
	if not f then
		dialog("加载文件失败!")
		lua_exit()
	end
	
	f()
end


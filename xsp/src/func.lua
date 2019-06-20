-- func.lua
-- Author: cndy1860
-- Date: 2018-12-25
-- Descrip: 功能函数 

--复制表
function tbCopy(tb)
	local tmp = {}
	for k, v in pairs(tb) do
		if type(v) == "table" then
			tmp[k] = tbCopy(v)
		else
			tmp[k] = v
		end
	end
	return tmp
end

--比较比是否相等
function compareTb(srcTb, dstTb)
	local getAbsLen = function (tb)
		local count = 0
		for k, _ in pairs(tb) do
			count = count + 1
		end
		return count
	end
	
	if srcTb == nil or dstTb == nil then
		return false
	end
	
	if getAbsLen(srcTb) ~= getAbsLen(dstTb) then
		return false
	end
	
	equalFlag = false
	
	for k, v in pairs(srcTb) do
		if type(v) == "table" then
			local exsitFlag = false
			for _k, _v in pairs(dstTb) do
				if _k == k and type(_v) == "table" then
					exsitFlag = true
					if not compareTb(v, _v) then
						return false
					end
					break
				end
			end
			
			if not exsitFlag then
				return false
			end
		else
			if v ~= dstTb[k] then
				return false
			end
		end
	end
	
	return true
end

function setValueByStrKey(keyStr, value)
	local keysTb = {}
	for keyStr, keyIndex in string.gmatch(keyStr, "([%a_]+)%[?(%d*)%]?%.?") do
		table.insert(keysTb, keyStr)
		if string.len(keyIndex) > 0 then
			table.insert(keysTb, tonumber(keyIndex))
		end
	end
	
	local iteratorTb = _G
	for k, v in pairs(keysTb) do
		if k < #keysTb then
			iteratorTb = iteratorTb[v]
		end
	end
	
	iteratorTb[keysTb[#keysTb]] = value
end

--处理初始化界面，主要用于自动重启后，跳过初始化界面的相关流程
function processInitPage()
	local startTime = os.time()
	while true do
		local currentPage = page.getCurrentPage(true)
		if currentPage == "初始化界面" then
			Log("catch init page")
			local _startTime = os.time()
			while true do
				local _currentPage = page.getCurrentPage(true)
				if _currentPage ~= "初始化界面" then
					sleep(2000)
					if page.getCurrentPage(true) ~= "初始化界面" then
						Log("skiped init page")
						return
					end
				end
				
				if os.time() - _startTime > CFG.DEFAULT_TIMEOUT then
					catchError(ERR_TIMEOUT, "cant catch init next page!")
				end
				
				if (os.time() - _startTime) % 2 == 0 then
					ratioTap(30, 60)
				end
				
				sleep(500)
			end			
		end
		
		if os.time() - startTime > CFG.DEFAULT_TIMEOUT then
			catchError(ERR_TIMEOUT, "cant catch init page!")
		end
		
		sleep(200)
	end
end

--检测当前游戏应用是否还在前端运行中
function isAppInFront()
	local appName = runtime.getForegroundApp()
	if appName == CFG.APP_ID then
		return true
	end
	
	return false
end

--万能输出
function prt(...)
	if CFG.LOG ~= true then
		return
	end
	
	local con={...}
	for key,value in ipairs(con) do
		if(type(value)=="table")then
			--打印输出table,请注意不要传入对象,会无限循环卡死
			printTbl = function(tbl)
				local function prt(tbl,tabnum)
					tabnum=tabnum or 0
					if not tbl then return end
					for k,v in pairs(tbl)do
						if type(v)=="table" then
							print(string.format("%s[%s](%s) = {",string.rep("\t",tabnum),tostring(k),"table"))
							prt(v,tabnum+1)
							print(string.format("%s}",string.rep("\t",tabnum)))
						else
							print(string.format("%s[%s](%s) = %s",string.rep("\t",tabnum),tostring(k),type(v),tostring(v)))
						end
					end
				end
				print("Print Table = {")
				prt(tbl,1)
				print("}")
			end
			printTbl(value)
			con[key]=""
		else
			con[key]=tostring(value)
		end
	end
	sysLog(table.concat(con,"  "))
end

--将LOG信息写入日志文件,不受CFG.LOG的影响
local function writeLog(content)		--写日志文件
	if content == nil then
		return
	end
	
	local logFile = xmod.getPublicPath()..CFG.LOG_FILE_NAME
	local file = io.open(logFile, "a")
	if file then
		file:write("["..os.date("%H:%M:%S", os.time()).."]"..content.."\r\n")
		io.close(file)
	end
end

--打印LOG信息至调试信息板，允许content = nil的情况，用于排错
function Log(content)
	if CFG.WRITE_LOG == true then
		writeLog(content)
	end
	
	if CFG.LOG ~= true then
		return
	end
	
	log(content)
end

--清除日志文件
function dropLog()
	local logFile = xmod.getPublicPath()..CFG.LOG_FILE_NAME
	local file = io.open(logFile, "w")
	if file then
		io.close(file)
	end	
end

--保存重启脚本状态
function setRestartedScript()
	setStringConfig("PREV_RESTARTED_SCRIPT", "TRUE")
end

--获取重启脚本状态
function getPrevRestartedScript()
	if getStringConfig("PREV_RESTARTED_SCRIPT", "FALSE") == "TRUE" then
		Log("脚本重启状态")
		setStringConfig("PREV_RESTARTED_SCRIPT", "FALSE") 	--读取之后重置
		return true
	else
		return false
	end	
end

--保存重启应用状态
function setRestartedAPP()
	setStringConfig("PREV_RESTARTED_APP", "TRUE")
end

--获取重启应用状态
function getPrevRestartedAPP()
	if getStringConfig("PREV_RESTARTED_APP", "FALSE") == "TRUE" then
		Log("应用重启状态")
		setStringConfig("PREV_RESTARTED_APP", "FALSE") 	--读取之后重置
		return true
	else
		return false
	end	
end

--捕获捕获处理函数
function catchError(errType, errMsg, forceContinueFlag)
	local etype = errType or ERR_UNKOWN
	local emsg = errMsg or "some error"
	local eflag = forceContinueFlag or false
	
	--catchError专用Log函数，不受CFG.LOG的影响
	local LogError = function(content)
		if CFG.WRITE_LOG == true then
			writeLog(content)
		end
		
		log(content)
	end
	
	--打印错误类型和具体信息
	if etype == ERR_MAIN or etype == ERR_TASK_ABORT then
		LogError("CORE ERR------->> "..emsg)
	elseif etype == ERR_NORMAL then
		LogError("NORMAL ERR------->> "..emsg)
	elseif etype == ERR_FILE then
		LogError("FILE ERR------->> "..emsg)
	elseif etype == ERR_PARAM then
		LogError("PARAM ERR------->> "..emsg)
	elseif etype == ERR_TIMEOUT then
		LogError("TIME OUT ERR------->> "..emsg)
	elseif etype == ERR_WARNING then
		LogError("WARNING ERR------->> "..emsg)
	else
		LogError("UNKOWN ERR------->> "..emsg)
	end
	
	LogError("Interrupt time-------------->> "..os.date("%Y-%m-%d %H:%M:%S", os.time()))
	
	--强制忽略错误处理
	if forceContinueFlag then
		LogError("WARNING:  ------!!!!!!!!!! FORCE CONTINUE !!!!!!!!!!------")
		return
	end
	
	--错误处理模块
	if etype == ERR_MAIN or etype == ERR_TASK_ABORT then	--核心错误仅允许exit
		dialog(errMsg.."\r\n即将退出")
		LogError("!!!cant recover task, program will end now!!!")
		xmod.exit()
	elseif etype == ERR_FILE or etype == ERR_PARAM then	--关键错误仅允许exit
		dialog(errMsg.."\r\n即将退出")
		LogError("!!!cant recover task, program will endlater!!!")
		xmod.exit()
	elseif etype == ERR_WARNING then		--警告任何时候只提示
		LogError("!!!maybe some err in here, care it!!!")
	elseif etype == ERR_TIMEOUT then		--超时错误允许exit，restart
		if runtime.getForegroundApp() == CFG.APP_ID then
			LogError("TIME OUT BUT APP STILL RUNNING！")
		else
			LogError("TIME OUT AND APP NOT RUNNING YET！")
		end
		
		if USER.RESTART_SCRIPT or USER.RESTART_APP then	--允许重启
			if USER.RESTART_APP then			--激进模式，APP和script同时重启
				if PREV.restartedAPP then
					Log("已重启过APP，未能解决，即将退出!")
					dialog("已重启过APP，未能解决，即将退出!")
					xmod.exit()
				end
				if PREV.restartedScript then	--已单独重启过脚本
					Log("已尝试过单独重启脚本，未能解决，即将重启应用和脚本")
					dialog("已尝试过单独重启脚本，未能解决，即将重启应用和脚本", 3)
					if xmod.PROCESS_MODE == xmod.PROCESS_MODE_STANDALONE then	--极客模式需要重启应用
						LogError("close app: "..CFG.APP_ID)
						runtime.killApp(CFG.APP_ID);
						sleep(1000)
						LogError("restart app: "..CFG.APP_ID)
						runtime.launchApp(CFG.APP_ID)
			
						--记录重启状态，重启之后会直接读取上一次保存的设置信息和相关变量，并不会弹出UI以实现自动续接任务
						local startTime = os.time()
						while true do
							if runtime.getForegroundApp() == CFG.APP_ID then	--重启应用成功
								LogError("restart app success!")
								sleep(CFG.WAIT_RESTART * 1000)
								break
							end
							
							if os.time() - startTime > CFG.DEFAULT_TIMEOUT then
								dialog("重启失败，即将退出")
								xmod.exit()
							end
						end
						setRestartedAPP()
						setRestartedAPP()
						setRestartedScript()
						LogError("restart script")
						xmod.restart()
					else		--通用模式只需关闭应用，会自动重启应用和脚本
						LogError("restart app & script")
						setRestartedAPP()
						setRestartedScript()
						runtime.killApp(CFG.APP_ID);	--沙盒模式下，killApp会强行结束掉脚本，因此不能在此后做任何操作，延时放到重启中
					end					
				else
					Log("超时，将尝试重启脚本")
					dialog("超时，将尝试重启脚本", 3)
					setRestartedScript()
					xmod.restart()
				end
			elseif USER.RESTART_SCRIPT	then	--安全模式，仅允许重启script
				if PREV.restartedScript then	--已重启过脚本
					LogError("已重启过脚本，仍未解决，即将退出!")
					dialog("已重启过脚本，仍未解决，即将退出!")
					xmod.exit()
				end
				
				setRestartedScript()
				xmod.restart()
			end
		else	--不允许重启直接退出
			dialog(errMsg.."\r\n等待超时，即将退出")
			LogError("!!!not allow restart, script will exit later!!!")
			xmod.exit()
		end
	else
		LogError("some err in task\r\n -----!!!program will exit later!!!-----")
		xmod.exit()
	end
end

--点击操作
function tap(x, y, delay)
	local d = delay or CFG.DEFAULT_TAP_TIME
	
	if x == nil or y == nil then
		x = 0
		y = 0
	end
	
	touch.down(1, x, y)
	sleep(d)
	touch.up(1, x, y)
	
	Log("Tap at------ x:"..x.." y:"..y)
end

function tapCenter()
	local d = CFG.DEFAULT_TAP_TIME
	local x = CFG.DEV_RESOLUTION.width / 2
	local y = CFG.DEV_RESOLUTION.height / 2
	
	touch.down(1, x, y)
	sleep(d)
	touch.up(1, x, y)
	
	Log("Tap Center at------ x:"..x.." y:"..y)
end

--点击，坐标按传入坐标在有效区所占位置比例缩放
function ratioTap(x, y, delay)
	local d = delay or CFG.DEFAULT_TAP_TIME
	if x == nil or y == nil then
		catchError(ERR_PARAM, "nil xy in proportionallyTap")
	end
	local x1, y1 = scale.getRatioPoint(x, y)
	
	tap(x1, y1, d)
end

--滑动，从(x1, y1)到(x2, y2)
function slide(x1, y1, x2, y2)
	if x1 ~= x2 then	--非竖直滑动
		--将x,y移动距离按移动步长CFG.TOUCH_MOVE_STEP分解为步数
		local stepX = x2 > x1 and CFG.TOUCH_MOVE_STEP or -CFG.TOUCH_MOVE_STEP
		local stepY = (y2 - y1) / math.abs((x2 - x1) / stepX)
		--Log("x1="..x1.." y1="..y1.." x2="..x2.." y2="..y2)
		
		touch.down(1, x1, y1)
		sleep(200)
		for i = 1, math.abs((x2 - x1) / stepX), 1 do
			touch.move(1, x1 + i * stepX, y1 + i * stepY)
			sleep(50)
		end
		touch.move(1, x2, y2)
		sleep(50)
		touch.up(1, x2, y2)
	else	--竖直滑动，0不能作为除数所以单独处理
		touch.down(1, x1, y1)
		sleep(200)
		local stepY = y2 > y1 and CFG.TOUCH_MOVE_STEP or -CFG.TOUCH_MOVE_STEP
		for i = 1, math.abs((y2 - y1) / stepY), 1 do
			touch.move(1, x2, y1 + i * stepY)
			sleep(50)
		end
		touch.move(1, x2, y2)
		sleep(50)
		touch.up(1, x2, y2)
	end	
end

function ratioSlide(x1, y1, x2, y2)
	srcX, srcY = scale.getRatioPoint(x1, y1)
	dstX, dstY = scale.getRatioPoint(x2, y2)
	slide(srcX, srcY, dstX, dstY)
end

function resetTaskData()
	lastPlayingPageTime = 0
	lastPenaltyPageTime = 0
	isPlayerRedCard = false
	
end

function resetPrevStatus()
	PREV.restartedAPP = false
	PREV.restartedScript = false
end
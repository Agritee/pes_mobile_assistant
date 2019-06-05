-- randSim.lua
-- Author: cndy1860
-- Date: 2019-01-24
-- Descrip: 自动刷巡回手动模式

local _task = {
	tag = "手动巡回",
	processes = {
		{tag = "其他", mode = "firstRun"},
		{tag = "比赛", nextTag = "活动模式", mode = "firstRun"},
		{tag = "活动模式", nextTag = "控制球员", mode = "firstRun"},
		
		{tag = "巡回模式", nextTag = "next"},
		{tag = "选择电脑级别", nextTag = "超巨"},
		{tag = "阵容展示", nextTag = "next"},
		{tag = "主场开球", },
		{tag = "比赛中", timeout = 60},
		{tag = "终场统计", nextTag = "next", timeout = 900, checkInterval = 1000},
	},
}

local function insertFunc(processTag, fn)
	for _, v in pairs(_task.processes) do
		if v.tag == processTag then
			v.actionFunc = fn
			return true
		end
	end
end

local function insertWaitFunc(processTag, fn)
	for _, v in pairs(_task.processes) do
		if v.tag == processTag then
			v.waitFunc = fn
			return true
		end
	end
end


local fn = function()
	switchMainPage("比赛")
end
insertFunc("其他", fn)

local fn = function()
	sleep(1000)		--可能在联赛教练模式界面后的一瞬间弹出球队精神提升或任务奖励的确定按钮
	if page.isExsitNavigation("comfirm") then		--球队精神提升确定
		Log("确定！")
		page.tapNavigation("comfirm")
		sleep(1000)
	end
	
	refreshUnmetCoach()
end
insertFunc("巡回模式", fn)


local fn = function()
	if page.matchWidget("阵容展示", "身价溢出") then
		dialog("身价溢出，精神低迷\r\n即将退出")
		xmod.exit()
	end
	
	if USER.ALLOW_SUBSTITUTE then
		switchPlayer()
	end
end
insertFunc("阵容展示", fn)

local wfn = function(taskIndex)
	sleep(200)
	local posTb = screen.findColors(scale.getAnchorArea("RB"),
		scale.scalePos("1059|440|0xfafcfa,987|434|0x335a26-0x232117,1123|475|0x335a26-0x232117,1016|500|0x335a26-0x232117,1098|379|0x335a26-0x232117"),
		95)
	if #posTb ~= 0 then	
		local buttonPot = {}
		--同样位置会有多个点，x、y坐标同时小于offset时判定为同位置的坐标，以20像素/短边750为基准
		local offset = (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) / 750 * 20
		for k, v in pairs(posTb) do
			local exsitFlag = false
			for _k, _v in pairs(buttonPot) do
				if math.abs(v.x - _v.x) < offset and math.abs(v.y - _v.y) < offset then
					exsitFlag = true
					break
				end
			end
			
			if not exsitFlag then
				table.insert(buttonPot, {x = v.x, y = v.y})
			end
		end
		
		local sortMethod = function(a, b)
			if a.x == nil or a.y == nil or b.x == nil or b.y == nil then
				return
			end
			
			if a.y == b.y then
				return a.x < b.x
			else
				return a.y < b.y
			end
		end
		
		sortMethod(buttonPot)
		--prt(buttonPot)
		
		if #buttonPot > 0 then
			--补足三个按钮
			if #buttonPot == 1 then
				table.insert(buttonPot, buttonPot[1])
				table.insert(buttonPot, buttonPot[1])
			elseif #buttonPot == 2 then
				table.insert(buttonPot, buttonPot[1])
			end
			
			tap(buttonPot[2].x, buttonPot[2].y)	--开球
			tap(buttonPot[3].x, buttonPot[3].y)	--开球
			sleep(300)
		else
			catchError(ERR_NORMAL, "未检测到传球按钮")
		end
	end
end
insertWaitFunc("主场开球", wfn)

local wfn = function(taskIndex)
	local posTb = screen.findColors(scale.getAnchorArea("RB"),
		scale.scalePos("1059|440|0xfafcfa,987|434|0x335a26-0x232117,1123|475|0x335a26-0x232117,1016|500|0x335a26-0x232117,1098|379|0x335a26-0x232117"),
		95)
	if #posTb ~= 0 then	
		local buttonPot = {}
		--同样位置会有多个点，x、y坐标同时小于offset时判定为同位置的坐标，以20像素/短边750为基准
		local offset = (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) / 750 * 20
		for k, v in pairs(posTb) do
			local exsitFlag = false
			for _k, _v in pairs(buttonPot) do
				if math.abs(v.x - _v.x) < offset and math.abs(v.y - _v.y) < offset then
					exsitFlag = true
					break
				end
			end
			
			if not exsitFlag then
				table.insert(buttonPot, {x = v.x, y = v.y})
			end
		end
		
		local sortMethod = function(a, b)
			if a.x == nil or a.y == nil or b.x == nil or b.y == nil then
				return
			end
			
			if a.y == b.y then
				return a.x < b.x
			else
				return a.y < b.y
			end
		end
		
		sortMethod(buttonPot)
		--prt(buttonPot)
		
		if #buttonPot > 0 then
			--补足三个按钮
			if #buttonPot == 1 then
				table.insert(buttonPot, buttonPot[1])
				table.insert(buttonPot, buttonPot[1])
			elseif #buttonPot == 2 then
				table.insert(buttonPot, buttonPot[1])
			end
			
			local tmp = os.time() % 10
			if tmp == 0 or tmp == 2 or tmp == 5 or tmp == 7 or tmp == 8 then
				tap(buttonPot[2].x, buttonPot[2].y)
			else
				tap(buttonPot[3].x, buttonPot[3].y)
			end
		end
	end
end
insertWaitFunc("比赛中", wfn)

local wfn = function()
	if page.matchPage("比赛中") then
		lastPlayingPageTime = os.time()
	end
	
	if lastPlayingPageTime == 0 then	--未检测到起始playing界面，跳过
		return
	end

	local posTb = screen.findColors(scale.getAnchorArea("RB"),
		scale.scalePos("1059|440|0xfafcfa,987|434|0x335a26-0x232117,1123|475|0x335a26-0x232117,1016|500|0x335a26-0x232117,1098|379|0x335a26-0x232117"),
		95)
	if #posTb ~= 0 then	
		local buttonPot = {}
		--同样位置会有多个点，x、y坐标同时小于offset时判定为同位置的坐标，以20像素/短边750为基准
		local offset = (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) / 750 * 20
		for k, v in pairs(posTb) do
			local exsitFlag = false
			for _k, _v in pairs(buttonPot) do
				if math.abs(v.x - _v.x) < offset and math.abs(v.y - _v.y) < offset then
					exsitFlag = true
					break
				end
			end
			
			if not exsitFlag then
				table.insert(buttonPot, {x = v.x, y = v.y})
			end
		end
		
		local sortMethod = function(a, b)
			if a.x == nil or a.y == nil or b.x == nil or b.y == nil then
				return
			end
			
			if a.y == b.y then
				return a.x < b.x
			else
				return a.y < b.y
			end
		end
		
		sortMethod(buttonPot)
		--prt(buttonPot)
		
		if #buttonPot > 0 then
			--补足三个按钮
			if #buttonPot == 1 then
				table.insert(buttonPot, buttonPot[1])
				table.insert(buttonPot, buttonPot[1])
			elseif #buttonPot == 2 then
				table.insert(buttonPot, buttonPot[1])
			end
			
			local tmp = os.time() % 10
			if tmp == 0 or tmp == 2 or tmp == 5 or tmp == 7 or tmp == 8 then
				tap(buttonPot[2].x, buttonPot[2].y)
			else
				tap(buttonPot[3].x, buttonPot[3].y)
			end
		end
	end
	
	if page.matchWidget("比赛中", "门球") then
		ratioSlide(800,700,850,500)
		sleep(1000)
	end
	
	if os.time() - lastPlayingPageTime > CFG.DEFAULT_TIMEOUT + 10 then		--长时间为检测到比赛界面，判定为异常
		catchError(ERR_TIMEOUT, "异常:未检测到比赛界面!")
	elseif os.time() - lastPlayingPageTime >= 3 then	--3秒内为检测到比赛界面，跳过过长动画
		Log("try skip replay!")
		ratioTap(900,30)
		sleep(500)
		ratioTap(900,30)
		sleep(500)
	end
	
	Log("timeAfterLastPlayingPage = "..(os.time() - lastPlayingPageTime).."s yet")
end
insertWaitFunc("终场统计", wfn)




--将任务添加至taskList
exec.loadTask(_task)
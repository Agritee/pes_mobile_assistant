-- tourSim.lua
-- Author: cndy1860
-- Date: 2018-12-28
-- Descrip: 自动刷巡回赛教练模式

local _task = {
	tag = "自动巡回",
	processes = {
		{tag = "其他", mode = "firstRun"},
		{tag = "比赛", nextTag = "活动模式", mode = "firstRun"},
		{tag = "活动模式", nextTag = "自动比赛", mode = "firstRun"},
		
		{tag = "巡回模式", nextTag = "next"},
		{tag = "阵容展示", nextTag = "next"},
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
	--先跳过所有的确定（领取奖励，精神提升什么的，有可能是先检测到界面后弹出的确定窗口）
	local lastCheckTime = os.time()
	while true do
		if page.isExsitNavigation("comfirm") then
			lastCheckTime = os.time()
			page.tapNavigation("comfirm")
			sleep(200)
		end
		if os.time() - lastCheckTime >= 2 then
			break
		end
		sleep(50)
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

local wfn = function()
	if page.matchPage("比赛中") then
		lastPlayingPageTime = os.time()
	end
	
	if lastPlayingPageTime == 0 then	--还未检测到比赛开始过，不进入流程。注意，需每轮任务重置时清零
		return
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
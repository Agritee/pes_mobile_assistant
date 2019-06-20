-- randSim.lua
-- Author: cndy1860
-- Date: 2018-06-19
-- Descrip: 自动刷联赛赛教练模式
--1.联赛教练模式中，替换红牌伤病球员，是通过"联赛教练模式"中的actionFunc，检测设置上的异常红点后点击自动设置实现。（异常对应两种状态：可能是
--教练合约到期或者球员红牌伤病，因此不使用一键替换功能）

local _task = {
	tag = "国际服季节赛SIM",
	processes = {
		{tag = "其他", mode = "firstRun"},
		{tag = "比赛", nextTag = "联赛", mode = "firstRun"},
		{tag = "联赛", nextTag = "教练模式联赛", mode = "firstRun"},
		
		{tag = "国际服季节赛", nextTag = "next"},
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
	sleep(200)
	skipComfirm("国际服季节赛")		--检测到界面后又弹出了确定提示按钮，如领取奖励，精神提升，点击所有的确定
	
	if page.isExsitCommonWidget("球队异常") and not isPlayerRedCard then
		refreshUnmetCoach("国际服季节赛")
	end
end
insertFunc("国际服季节赛", fn)

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
		ratioTap(900,70)
		sleep(500)
		ratioTap(900,70)
		sleep(500)
	end
	
	Log("timeAfterLastPlayingPage = "..(os.time() - lastPlayingPageTime).."s yet")
end
insertWaitFunc("终场统计", wfn)




--将任务添加至taskList
exec.loadTask(_task)
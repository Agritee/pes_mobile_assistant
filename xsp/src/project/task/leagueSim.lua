-- randSim.lua
-- Author: cndy1860
-- Date: 2018-12-28
-- Descrip: 自动刷联赛赛教练模式
--1.联赛教练模式中，替换红牌伤病球员，是通过"联赛教练模式"中的actionFunc，检测设置上的异常红点后点击自动设置实现。（异常对应两种状态：可能是
--教练合约到期或者球员红牌伤病，因此不使用一键替换功能）

local _task = {
	tag = "自动联赛",
	processes = {
		{tag = "其他", mode = "firstRun"},
		{tag = "比赛", nextTag = "联赛", mode = "firstRun"},
		{tag = "联赛", nextTag = "教练模式联赛", mode = "firstRun"},
		
		{tag = "联赛教练模式", nextTag = "next"},
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
	sleep(1000)		--可能在联赛教练模式界面后的一瞬间弹出球队精神提升随随机任务奖励的确定按钮
	if page.isExsitNavigation("comfirm") then		--球队精神提升确定
		Log("球队精神提升确定！")
		page.tapNavigation("comfirm")
		sleep(1000)
	end
	
	if page.matchWidget("联赛教练模式", "跳过余下比赛") then
		Log("checked need skip league level")
		page.tapWidget("联赛教练模式", "跳过余下比赛")
		sleep(1000)

		--多个确定(联赛升级奖励)，循环导航处理
		local cnt = 0
		local lastCheckTime = os.time()
		while true do
			if page.isExsitNavigation("comfirm") then
				lastCheckTime = os.time()
				page.tapNavigation("comfirm")
				sleep(1000)
				cnt = cnt + 1 
			end
			if (os.time() - lastCheckTime > 2) or cnt >= 3 then
				break
			end
			sleep(50)
		end
	end
	
	refreshUnmetCoach()
end
insertFunc("联赛教练模式", fn)

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
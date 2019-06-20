-- main.lua
-- Author: cndy1860
-- Date: 2018-12-25
-- Descrip: 程序入口，注意require顺序会影响各文件的init，后续添加任务依次require
require("api")
require("config")
require("global")
require("func")
require("init")
require("scale")
require("page")
require("exec")
require("project/projFunc")
require("project/projPage")
require("project/task/rankSim")
require("project/task/leagueSim")
require("project/task/tourSim")
require("project/task/tourManuel")
require("project/task/championSim")
require("project/task/sezonSim")
require("ui")
require("zui/base_ui")

function main()
	screen.keep(false)
	dispUI()
	
	if USER.DROP_CACHE then
		page.dropPageCache()
	end
	CFG.CACHING_MODE = false

	if PREV.restartedAPP then
		if xmod.PROCESS_MODE == xmod.PROCESS_MODE_STANDALONE then	--通用模式的延时只能放在重启时
			sleep(CFG.WAIT_RESTART * 1000)
		end
		
		processInitPage()	--先跳过未定义界面
	end

	exec.run(USER.TASK_NAME, USER.REPEAT_TIMES)
	xmod.exit()
end

main()

screen.init(screen.LANDSCAPE_RIGHT)
sleep(2000)


page.checkCurrentPage()



--refreshUnmetCoach()

--page.matchPage("冠军杯分组")
--page.tapWidget("阵容展示", "切换状态")


--page.tapWidget("标准经纪人", "中场")
--page.tapNavigation("notice")

--page.tapWidget("比赛", "联赛")

--page.tryNavigation()

--获取一个区域内某种状态的所有球员位置信息
--sleep(2000)
--switchPlayer()

--prt(scale.offsetPos("343|308|0xffffff,343|315|0x007aff,324|312|0x007aff,363|313|0x007aff,324|355|0x007aff,362|355|0x007aff", Point(342, 306)))
--storage.purge()
--storage.put("test", "123")
--storage.commit()
--prt(storage.get("test", "noda"))

--tap(293,852)
--ratioSlide(30, 700, 30, 153, 200)

--switchPlayer()


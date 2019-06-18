-- config.lua
-- Author: cndy1860
-- Date: 2018-12-24
-- Descrip: 参数配置表，注册在_G

CFG = {}	--脚本配置表

-----------------版本信息-----------------
CFG.VERSION = "v0.0.1"
CFG.BIULD_TIME = "20190104"

-----------------引擎属性-----------------
CFG.COMPATIBLE = (string.sub(xmod.VERSION_NAME, 1, 3) == "1.9" and {true} or {false})[1]		--兼容1.9引擎
CFG.ALLOW_CACHE = false
CFG.LOW_CONFIGURATION = false		--低配硬件兼容

-----------------调试参数-----------------
CFG.LOG = true				--是否允许输出LOG信息
CFG.WRITE_LOG = false		--是否将LOG写入log.txt文件, 不受CFG.LOG影响

-----------------分辨率参数-----------------
CFG.SUPPORT_RESOLUTION = {max = {width = 5040, height = 2160}, min = {width = 600, height = 450}}	--分辨率支持范围
CFG.DEV_RESOLUTION = {width = 1334, height = 750}	--开发分辨率，开发人员设置
CFG.DST_RESOLUTION = {--[[width = w, height = h]]}		--运行设备分辨率，由init设置
CFG.SCALING_RATIO = 1		--短边缩放比率，由init设置
CFG.EFFECTIVE_AREA = {--[[x0, y0, x1, y1]]}		--界面有效区，由init设置
CFG.BLACK_BORDER = {		--黑边参数
	limitRatio = {leftRight = 16/9, topBottom = 4/3},	--出现黑边的临界比例（仅限上下、左右分别相等的情况）
	borderList = {		--width >= height，此处预设项优先级大于由imitRatio生成的项
		--{width = 2340, height = 1080, left = 210, right = 210, top = 0, bottom = 0}
	},
}

-----------------线性插值取色-----------------
CFG.BILINEAR = false		--开启线性二次插值

-----------------重启脚本及应用参数-----------------
--CFG.ALLOW_RESTART = true			--是否允许重启脚本来解决异常
CFG.APP_ID = "com.netease.pes"		--应用名称
CFG.DEFAULT_APP_ID = "com.netease.pes"

-----------------找色参数-----------------
CFG.DEFAULT_FUZZY = 95		--默认颜色模糊相似度


CFG.DEFAULT_REPEAT_TIMES = 10		--任务默认运行次数

-----------------文件-----------------
CFG.LOG_FILE_NAME = "log.dat"	--Log文件名

-----------------任务参数-----------------
CFG.DEFAULT_REPEAT_TIMES = 50

-----------------延时参数-----------------
CFG.DEFAULT_TIMEOUT = 40		--/s
CFG.NAVIGATION_DELAY = 200		--/ms

CFG.WAIT_RESTART = 15		

CFG.WAIT_CHECK_SKIP = 3		--/s
CFG.WAIT_CHECK_SKIP_NEXT = 5
CFG.WAIT_CHECK_NAVIGATION = 1 	--/s

-----------------touch参数-----------------
CFG.TOUCH_MOVE_STEP = 50	--touchMoveTo的移动步长
CFG.DEFAULT_TAP_TIME = 50		--默认tap时间/ms
CFG.DEFAULT_LONG_TAP_TIME = 800	--默认longtap时间/ms

CFG.DEFAULT_PAGE_CHECK_INTERVAL = 100


CFG.TO_DO_LIST = {		--TODO,会提示未开放
	"国际服联赛SIM",
	"领取奖励",
}


--前一次运行的部分信息
PREV = {}

PREV.restarted = false			--是否发生过重启
PREV.restartedScript = false	--是否发生过脚本重启
PREV.restartedAPP = false		--是否发生过应用重启




USER = {}	--用户配置表，主要有UI设置
-----------------用户设置-----------------
USER.TASK_NAME = "自动联赛"					--任务名称

USER.RESTART_SCRIPT = false			--是否允许重启脚本来解决异常
USER.RESTART_APP = false			--是否允许重启应用来解决异常

USER.REFRESH_CONCTRACT = false		--自动续约合同
USER.REPEAT_TIMES = 0				--任务循环次数
USER.DEFAULT_REPEAT_TIMES = 10		--任务默认运行次数
USER.ALLOW_SUBSTITUTE = true		--是否允许开场换人
USER.SUBSTITUTE_INDEX_LIST = {--[[{fieldIndex = 1, substituteCondition = 1},{},{},{},{},{},{}]]
	{fieldIndex = 1, substituteCondition = 1},
	{fieldIndex = 2, substituteCondition = 1},
	{fieldIndex = 3, substituteCondition = 1},
	{fieldIndex = 4, substituteCondition = 1},
	{fieldIndex = 5, substituteCondition = 1},
	{fieldIndex = 9, substituteCondition = 1},
	{fieldIndex = 10, substituteCondition = 1},
}		--替补席对应关系表

USER.DROP_CACHE = false				--清空缓存



require("zui/Z_ui")

if not CFG.COMPATIBLE then
	return
end


local feildPositionStr = "不换,位置1,位置2,位置3,位置4,位置5,位置6,位置7,位置8,位置9,位置10,位置11"
local feildPositionSubstituteCondition = "主力红才换,好一档就换,好两档才换"


local DevScreen={--开发设备的参数
	Width=CFG.DEV_RESOLUTION.width,--注意Width要大于Height,开发机分辨率是啥就填啥
	Height=CFG.DEV_RESOLUTION.height, --注意Width要大于Height,开发机分辨率是啥就填啥
	countdown = 30
}

local myui=ZUI:new(DevScreen,{align="left",w=90,h=90,size=40,cancelname="取消",okname="OK",countdown=(IS_BREAKING_TASK == true and 3 or 0),config="zui.dat",bg="bk.png"})--在page中传入的size会成为所有page中所有控件的默认字体大小,同时也会成为所有page控件的最小行距
local pageBaseSet = Page:new(myui,{text = "基本设置", size = 24})
pageBaseSet:nextLine()
pageBaseSet:nextLine()
pageBaseSet:addLabel({text="任务选择",size=32})
--pageBaseSet:addComboBox({id="comboBoxTask",list="自动天梯,自动联赛,自动巡回,手动巡回,特殊抽球,标准抽球,箱式抽球",select=0,w=30,h=12, size = 28})
pageBaseSet:addComboBox({id="comboBoxTask",list="自动天梯,自动联赛,自动巡回,手动巡回,自动冠军赛,领取奖励,国际服联赛SIM",select=0,w=40,h=12, size = 28})

pageBaseSet:nextLine()
pageBaseSet:nextLine()
pageBaseSet:addLabel({text="通用功能",size=30})
--pageBaseSet:addCheckBoxGroup({id="checkBoxFunc", list = "开场换人,自动续约,购买体力,恢复体力",select="1@3",w=80,h=12})
pageBaseSet:addCheckBoxGroup({id="checkBoxFunc", list = "开场换人,自动续约",select="1",w=80,h=12})

pageBaseSet:nextLine()

pageBaseSet:nextLine()
pageBaseSet:addLabel({text="崩溃重启",size=30})
pageBaseSet:addRadioGroup({id="radioRestart",list="开启,关闭",select=1,w=35,h=12})

pageBaseSet:nextLine()
pageBaseSet:addLabel({text="任务次数",size=30})
pageBaseSet:addEdit({id="editerCircleTimes",prompt="提示文本1",text=tostring(CFG.DEFAULT_REPEAT_TIMES),color="0,0,255",w=20,h=10,align="right",size=24})



local pageSubstituteSet = Page:new(myui,{text = "换人设置",size = 24})
--pageSubstituteSet:addLabel({text="    替补席按从上到下分别编号为1-7号位，球场上11个球员按从上到下，从左到右为1-11号为，可",size=15})
pageSubstituteSet:nextLine()
pageSubstituteSet:nextLine()
pageSubstituteSet:addLabel({text="替补1 ->",size=32})
pageSubstituteSet:addComboBox({id="comboBoxBench1",list=feildPositionStr,select=0,w=17,h=10, size = 18})
pageSubstituteSet:addLabel({text=" ",size=24})
pageSubstituteSet:addComboBox({id="comboBoxBenchCondition1",list=feildPositionSubstituteCondition,select=0,w=24,h=10, size = 18})
pageSubstituteSet:addLabel({text="                  换人说明",size=24})
pageSubstituteSet:nextLine()
pageSubstituteSet:addLabel({text="替补2 ->",size=32})
pageSubstituteSet:addComboBox({id="comboBoxBench2",list=feildPositionStr,select=0,w=17,h=10, size = 18})
pageSubstituteSet:addLabel({text=" ",size=24})
pageSubstituteSet:addComboBox({id="comboBoxBenchCondition2",list=feildPositionSubstituteCondition,select=0,w=24,h=10, size = 18})
pageSubstituteSet:addLabel({text="            对位换人，替补席从上到下",size=20})
pageSubstituteSet:nextLine()
pageSubstituteSet:addLabel({text="替补3 ->",size=32})
pageSubstituteSet:addComboBox({id="comboBoxBench3",list=feildPositionStr,select=0,w=17,h=10, size = 18})
pageSubstituteSet:addLabel({text=" ",size=24})
pageSubstituteSet:addComboBox({id="comboBoxBenchCondition3",list=feildPositionSubstituteCondition,select=0,w=24,h=10, size = 18})
pageSubstituteSet:addLabel({text="        依次为替补1-7号，场上球员严",size=20})
pageSubstituteSet:nextLine()
pageSubstituteSet:addLabel({text="替补4 ->",size=32})
pageSubstituteSet:addComboBox({id="comboBoxBench4",list=feildPositionStr,select=0,w=17,h=10, size = 18})
pageSubstituteSet:addLabel({text=" ",size=24})
pageSubstituteSet:addComboBox({id="comboBoxBenchCondition4",list=feildPositionSubstituteCondition,select=0,w=24,h=10, size = 18})
pageSubstituteSet:addLabel({text="        格按照从上到下（请参考编号",size=20})
pageSubstituteSet:nextLine()
pageSubstituteSet:addLabel({text="替补5 ->",size=32})
pageSubstituteSet:addComboBox({id="comboBoxBench5",list=feildPositionStr,select=0,w=17,h=10, size = 18})
pageSubstituteSet:addLabel({text=" ",size=24})
pageSubstituteSet:addComboBox({id="comboBoxBenchCondition5",list=feildPositionSubstituteCondition,select=0,w=24,h=10, size = 18})
pageSubstituteSet:addLabel({text="        图示），从左到右的顺序编为",size=20})
pageSubstituteSet:nextLine()
pageSubstituteSet:addLabel({text="替补6 ->",size=32})
pageSubstituteSet:addComboBox({id="comboBoxBench6",list=feildPositionStr,select=0,w=17,h=10, size = 18})
pageSubstituteSet:addLabel({text=" ",size=24})
pageSubstituteSet:addComboBox({id="comboBoxBenchCondition6",list=feildPositionSubstituteCondition,select=0,w=24,h=10, size = 18})
pageSubstituteSet:addLabel({text="        1-11号位置，自行对应，可设",size=20})
pageSubstituteSet:nextLine()
pageSubstituteSet:addLabel({text="替补7 ->",size=32})
pageSubstituteSet:addComboBox({id="comboBoxBench7",list=feildPositionStr,select=0,w=17,h=10, size = 18})
pageSubstituteSet:addLabel({text=" ",size=24})
pageSubstituteSet:addComboBox({id="comboBoxBenchCondition7",list=feildPositionSubstituteCondition,select=0,w=24,h=10, size = 18})
pageSubstituteSet:addLabel({text="        置每个位置的换人条件。",size=20})


local pageSubstitutePic = Page:new(myui,{text = "编号图示",size = 24})
pageSubstitutePic:addLabel({text="        ",size=20})
pageSubstitutePic:addImage({src="substitute.jpg",w=70,h=100,xpos=0,align="cnter"})


local pageProSet = Page:new(myui,{text = "高级设置",size = 24})
pageProSet:nextLine()
pageProSet:addLabel({text="    因稳定性原因以下高级功能暂未开放，后续开放后再行通知",size=24})
pageProSet:nextLine()
pageProSet:addLabel({text="    本脚本提供了界面缓存的高级功能（默认开启），即将所有匹配过的界面的数据缓存在本地，",size=24})
pageProSet:nextLine()
pageProSet:addLabel({text="用于提高页面匹配效率和脚本运行速度。",size=24})
pageProSet:nextLine()
pageProSet:addLabel({text="    正常情况下请保持默认的开启性能模式，并不要清空缓存。仅当经常出现脚本超时时，可以",size=24})
pageProSet:nextLine()
pageProSet:addLabel({text="先尝试运行一次清空缓存数据（下次运行时请关闭选项），如果依然不能解决，请关闭缓存模式",size=24})
pageProSet:nextLine()
pageProSet:nextLine()

pageProSet:addLabel({text="缓存模式",size=30})
pageProSet:addRadioGroup({id="radioAllowCache",list="开启,关闭",select=1,w=25,h=12})

pageProSet:nextLine()
pageProSet:addLabel({text="清空缓存",size=30})
pageProSet:addRadioGroup({id="radioDropCache",list="开启,关闭",select=1,w=25,h=12})

pageProSet:nextLine()
pageProSet:addLabel({text="低配兼容",size=30})
pageProSet:addRadioGroup({id="radioLowConfiguration",list="开启,关闭",select=1,w=25,h=12})

local pageBuyCDKEY = Page:new(myui,{text = "脚本购买",size = 24})
pageBuyCDKEY:nextLine()
pageBuyCDKEY:addLabel({text="   购买方式:",size=22, align="cnter"})
pageBuyCDKEY:nextLine()
pageBuyCDKEY:addLabel({text="      群内经常有优惠和折扣",size=20, align="cnter"})
pageBuyCDKEY:nextLine()
pageBuyCDKEY:addLabel({text="      1.叉叉助手直接购买(安卓)",size=20, align="cnter"})
pageBuyCDKEY:nextLine()
pageBuyCDKEY:addLabel({text="      2.叉叉小精灵直接购买(安卓)",size=20, align="cnter"})
pageBuyCDKEY:nextLine()
pageBuyCDKEY:addLabel({text="      3.IPA精灵直接购买(IOS)",size=20, align="cnter"})
pageBuyCDKEY:nextLine()
pageBuyCDKEY:addLabel({text="      4.在线购买激活码(安卓+IOS)",size=20, align="cnter"})

pageBuyCDKEY:nextLine()
pageBuyCDKEY:nextLine()
pageBuyCDKEY:addUrl({text="购买激活码",url="http://cndy1860.linso.pw"})


local pageTestting = Page:new(myui,{text = "脚本说明",size = 24})
pageTestting:nextLine()
pageTestting:addLabel({text="                                ------------------------脚本特性说明------------------------",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:addLabel({text="    1.一定要原版背景才能使用，换了背景有些界面不能识别。",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:addLabel({text="    2.只支持经典按键模式，不要选划屏模式。",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:addLabel({text="    3.开启脚本的小球请拖到右边中间部分，任何手机的游戏中心的小球也拖到右边中间部分避免干扰。",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:addLabel({text="    4.刘海屏不要留黑边，不要有导航栏，让游戏铺满整个屏幕。",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:addLabel({text="    5.HOME键(导航栏)放在右边，运行过程中不要让手机旋转方向。",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:addLabel({text="    6.脚本操作的过程中，尽量不要手动操作，或先使用音量键停止脚本运行后再行操作，操作完成后直接重开脚本。",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:addLabel({text="    7.按照稳定性，优先使用手机，模拟器长时间运行可能会导致游戏崩溃(闪退)等状况。",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:addLabel({text="    8.脚本自动重启(续接任务)功能仅安卓有效。",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:nextLine()
pageTestting:addLabel({text="                                ------------------------脚本功能说明------------------------",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:addLabel({text="    1.脚本功能主要是模拟点击，实现教练模式自动循环挂机。脚本不是AI，不能手动天梯上分的。",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:addLabel({text="    2.目前可挂机的任务有：教练天梯赛、教练联赛、教练巡回赛、手动巡回赛(简单AI主要混失败奖励点数)。",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:addLabel({text="    3.需要开场自动按状态换人的，请在换人设置里设置好换人规则。",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:addLabel({text="    4.需要下半场换人体力的不足时换人的，请打开游戏自动换人。",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:addLabel({text="    5.建议所有模式下都关闭自动铲球防止红黄牌。",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:addLabel({text="    6.启动脚本前请先切换至游戏主界面-其他(或挂机流程中的任何一个界面)。",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:addLabel({text="    7.任务次数是指挂机场数。",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:addLabel({text="    8.另外不喜欢XX助手的用户，可以进群下载本脚本专用小精灵应用。",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:addLabel({text="    9.年卡和永久卡有专用的VIP微信群，可进Q群让管理邀请加入。",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:addLabel({text="    10.详细说明书请点击脚本教程。",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:addLabel({text="    11.有任何问题及建议请反馈给作者，Q群：574025168 ",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:nextLine()
pageTestting:addLabel({text="                                ------------------------问题反馈说明------------------------",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:addLabel({text="        出现任何问题，请一定先看脚本说明和脚本教程，能解决95%的问题，另外如果你遇到的问题处于“最新",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:addLabel({text="    公告”中的BugList，意味着作者正在解决中。",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:addLabel({text="        若依然不能解决请进群反馈，同时请一定提供以下信息:",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:addLabel({text="        a.手机系统和型号 b.正在运行的任务 c.脚本报错信息截图）",size=20, align="cnter"})
pageTestting:nextLine()
pageTestting:nextLine()
pageTestting:addLabel({text="    ",size=20, align="cnter"})


local pageNotice = Page:new(myui,{text = "最新公告",size = 24})
pageNotice:addWeb({id="noticeWebView", url="http://www.zybuluo.com/cndy1860/note/1497294", xpos = 0, ypos = 0, w = 100, h = 100})


--将位置*转换成对应的数字
local function _convertIndex(posation)
	if type(posation) ~= "string" then
		return 0
	end
	
	if posation == "位置1" then
		return 1
	elseif posation == "位置2" then
		return 2
	elseif posation == "位置3" then
		return 3
	elseif posation == "位置4" then
		return 4
	elseif posation == "位置5" then
		return 5
	elseif posation == "位置6" then
		return 6
	elseif posation == "位置7" then
		return 7
	elseif posation == "位置8" then
		return 8
	elseif posation == "位置9" then
		return 9
	elseif posation == "位置10" then
		return 10
	elseif posation == "位置11" then
		return 11
	elseif posation == "不换" then
		return 0
	else
		return 0
	end
end

--将换人条件转为为数字
local function _convertCondition(condition)
	if type(condition) ~= "string" then
		return 0
	end
	
	if condition == "主力红才换" then
		return 0
	elseif condition == "好一档就换" then
		return 1
	elseif condition == "好两档才换" then
		return 2
	else
		return 0
	end
end

local function getRadioKey(tb)
	for k, v in pairs(tb) do
		if v == true then
			return k
		end
	end
end

function dispUI()
	local uiRet = myui:show(3)
	if uiRet._cancel then
		xmod.exit()
	end
	--prt(uiRet)
	
	USER.TASK_NAME = uiRet.comboBoxTask
	USER.REPEAT_TIMES = tonumber(uiRet.editerCircleTimes or CFG.DEFAULT_REPEAT_TIMES)
	
	USER.ALLOW_SUBSTITUTE = uiRet.checkBoxFunc.开场换人
	
	USER.ALLOW_RESTART = uiRet.radioRestart.开启
	if xmod.PLATFORM == xmod.PLATFORM_IOS then
		USER.ALLOW_RESTART = false
	end
	--prt(USER)
	
	
	CFG.ALLOW_CACHE = uiRet.radioAllowCache.开启
	USER.DROP_CACHE = uiRet.radioDropCache.开启
	CFG.LOW_CONFIGURATION = uiRet.radioLowConfiguration.开启
	
	for i = 1, 7, 1 do
		USER.SUBSTITUTE_INDEX_LIST[i].fieldIndex = _convertIndex(uiRet[string.format("comboBoxBench%d",i)])
		USER.SUBSTITUTE_INDEX_LIST[i].substituteCondition = _convertCondition(uiRet[string.format("comboBoxBenchCondition%d",i)])
	end
	
	for k, v in pairs(USER.SUBSTITUTE_INDEX_LIST) do
		for _k, _v in pairs(USER.SUBSTITUTE_INDEX_LIST) do
			if _k ~= k and v.fieldIndex ~= 0 and _v.fieldIndex ~= 0 then
				if _v.fieldIndex == v.fieldIndex then
					dialog("请将替补和场上球员一一对应")
					dispUI()
					return
				end
			end
		end
	end
	
	--prt(USER)
end
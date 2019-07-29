-- login.lua
-- Author: cndy1860
-- Date: 2019-07-25
-- Descrip: 在线验证
require("zui/Z_ui")
local json = require("Zlibs/class/Json")


----------------------------------UI-----------------------------
local DevScreen={--开发设备的参数
	Width=CFG.DEV_RESOLUTION.width,--注意Width要大于Height
	Height=CFG.DEV_RESOLUTION.height, --注意Width要大于Height
}

---------激活授权---------
local activateUI=ZUI:new(DevScreen,{align="left",w=90,h=90,size=40,cancelname="取消",okname="激活",countdown=0,config="zui.dat",bg="bk.png"})
local pageActivate = Page:new(activateUI,{text = "默认", size = 24, align="center"})
pageActivate:nextLine()
pageActivate:nextLine()
pageActivate:nextLine()
pageActivate:nextLine()
pageActivate:nextLine()
pageActivate:addLabel({text="请输入激活码",w=90,h=20,align="center",color="25,25,112",size=40})
pageActivate:nextLine()
pageActivate:addLabel({text="",w=15,h=20,align="center",size=30})
pageActivate:addEdit({id="editerActivate",color="255,0,0",w=60,h=15,align="center",size=30})

local activateUIData = {}
local function showActivateUI()
	activateUIData = {}
	local uiRet = activateUI:show(3)
	if uiRet._cancel then
		xmod.exit()
	end
	
	activateUIData.cdkey = tostring(uiRet.editerActivate)
end

---------登录账户---------
local loginUI=ZUI:new(DevScreen,{align="left",w=90,h=90,size=40,cancelname="取消",okname="登录",countdown=0,config="zui.dat",bg="bk.png"})
local pageLogin = Page:new(loginUI,{text = "默认", size = 24, align="center"})
pageLogin:nextLine()
pageLogin:nextLine()
pageLogin:nextLine()
pageLogin:addLabel({text="用户登录",w=90,h=20,color="25,25,112",align="center",size=40})
pageLogin:nextLine()
pageLogin:addLabel({text="",w=15,h=20,align="center",size=28})
pageLogin:addLabel({text="用户名",w=10,h=20,align="center",size=28})
pageLogin:addEdit({id="editerUid",color="0,0,255",w=40,h=15,align="left",size=26})
pageLogin:nextLine()
pageLogin:addLabel({text="",w=15,h=20,align="center",size=28})
pageLogin:addLabel({text="密  码",w=10,h=20,align="center",size=28})
pageLogin:addEdit({id="editerPwd",color="0,0,255",w=40,h=15,align="left",size=26})

local loginUIData = {}
local function showLoginUI()
	loginUIData = {}
	local uiRet = loginUI:show(3)
	if uiRet._cancel then
		xmod.exit()
	end
	
	loginUIData.uid = tostring(uiRet.editerUid)
	loginUIData.pwd = tostring(uiRet.editerPwd)
end

---------注册账户---------
local registUI=ZUI:new(DevScreen,{align="left",w=90,h=90,size=40,cancelname="取消",okname="注册",countdown=0,config="zui.dat",bg="bk.png"})
local pageRegist = Page:new(registUI,{text = "默认", size = 24, align="center"})
pageRegist:nextLine()
pageRegist:nextLine()
pageRegist:nextLine()
pageRegist:addLabel({text="注册账号",w=90,h=20,color="25,25,112",align="center",size=40})
pageRegist:nextLine()
pageRegist:addLabel({text="",w=15,h=20,align="center",size=28})
pageRegist:addLabel({text="用户名",w=10,h=20,align="center",size=28})
pageRegist:addEdit({id="editerRegistUid",color="0,0,255",w=40,h=15,align="left",size=26})
pageRegist:nextLine()
pageRegist:addLabel({text="",w=15,h=20,align="center",size=28})
pageRegist:addLabel({text="  密码",w=10,h=20,align="center",size=28})
pageRegist:addEdit({id="editerRegistPwd",color="0,0,255",w=40,h=15,align="left",size=26})

local registUIData = {}
local function showRegistUI()
	registUIData = {}
	local uiRet = registUI:show(3)
	if uiRet._cancel then
		xmod.exit()
	end
	
	registUIData.uid = tostring(uiRet.editerRegistUid)
	registUIData.pwd = tostring(uiRet.editerRegistPwd)
end

----------------------------------UI-----------------------------

--保存用户ID
local function setUid(uid)
	return setStringConfig("UID", uid)
end

--获取用户ID
function getUid()
	return getStringConfig("UID", "NULL")
end

--保存用户密码
local function setPwd(pwd)
	return setStringConfig("PWD", pwd)
end

--获取用户密码
local function getPwd()
	return getStringConfig("PWD", "NULL")
end

--保存登陆码
local function setLoggedCode(code)
	setStringConfig("LOGGED_CODE", code)
end

--获取用户ID登陆码
local function getLoggedCode()
	return getStringConfig("LOGGED_CODE", "NULL")
end

--保存登录时间
local function setLoggedDate()
	setStringConfig("LOGGED_DATA", os.time())
end

--获取上一次登录时间
local function getLoggedDate()
	return getStringConfig("LOGGED_DATA", "NULL")
end


--心跳包
local  heartBeatFaildTimes = 0
function onlineHeartBeat()
	local send = {}
	
	send.ReqType = "heartBeat"
	send.Uid = loginUIData.uid or getUid()
	send.DevCode = getDeviceIMEI()..getDeviceIMSI()
	send.Script = CFG.SCRIPT_ID
	send.LoggedCode = getLoggedCode()
	send.ReqTime = tostring(os.time())

	local http = require("Zlibs/class/Http")
	local rspData = http.Post.tableByJson(CFG.HOST, send)
	if rspData == "" then
		--dialog("链接到服务器出错！")
		heartBeatFaildTimes = heartBeatFaildTimes + 1
		if heartBeatFaildTimes >= 3 then		--连续3次链接失败则视为心跳失败
			return "fail"
		end
		
		return "ignore"
	end
	
	heartBeatFaildTimes = 0		--只要成功链接就清零
	
	Log("heart beat recv:"..rspData)
	
	local recv = json.decode(rspData)
	--[[recv = {
	RspType,
	Uid,
	RspTime,
	RspCode
	RspMsg,
	}]]
	--prt(recv)
	if recv.RspType ~= send.ReqType or recv.Uid ~= send.Uid then
		return "fail"
	end
	
	if recv.RspCode ~= "success" then
		if recv.rspCode == "err_login_repeated" then
			return "relogin"
		else
			return "fail"
		end
	end
	
	Log("心跳成功")
	return "success"
end

--在线登录
local function onlineLogin()
	local send = {}
	
	send.ReqType = "login"
	send.Uid = loginUIData.uid or getUid()
	send.Pwd = loginUIData.pwd or getPwd()
	send.DevCode = getDeviceIMEI()..getDeviceIMSI()
	send.Script = CFG.SCRIPT_ID
	send.LoggedCode = getLoggedCode()
	send.ReqTime = tostring(os.time())
	
	local http = require("Zlibs/class/Http")
	local rspData = http.Post.tableByJson(CFG.HOST, send)
	if rspData == "" then
		dialog("链接到服务器出错！")
		return "exit"
	end
	
	Log("login recv:"..rspData)
	
	local recv = json.decode(rspData)
	--[[recv = {
	RspType,
	Uid,
	RspTime,
	RspCode
	RspMsg,
	LoginCode,
	AuthType,
	AuthRemaining,
	}]]
	--prt(recv)
	if recv.RspType ~= send.ReqType then
		dialog("返回数据校验失败！")
		return "exit"
	end
	
	if recv.Uid ~= send.Uid then
		dialog("账户校验失败！")
		return "exit"
	end
	
	if math.abs(recv.RspTime - os.time()) > 60 * 30 then		--服务器时间与本地相差不超过30分钟
		dialog("本地时间和服务器时间不符，请同步本地时间！")
		return "exit"
	end
	
	if recv.LoginCode == nil then
		dialog("获取登陆码失败！")
		return "exit"
	end
	
	setLoggedCode(recv.LoginCode)		--更新登陆码
	setLoggedDate()
	
	if recv.RspCode == "success" or recv.RspCode == "err_auth_not" then
		if loginUIData.uid and loginUIData.pwd then 	--更新输入的用户信息
			setUid(loginUIData.uid)
			setPwd(loginUIData.pwd)
		end	
	end
	
	if recv.RspCode ~= "success" then
		Log("recv.RspCode="..recv.RspCode)
		if recv.RspCode == "err_uid" then
			dialog(recv.RspMsg or "账号或密码错误，请重新登录！")
			return "loginUI"
		elseif recv.RspCode == "err_baned_uid" then
			dialog(recv.RspMsg or "账号异常，请联系管理员！")
			return "exit"
		elseif recv.RspCode == "act_relogin" then
			dialog(recv.RspMsg or "已更换设备，请重新登录！")
			return "loginUI"
		elseif recv.RspCode == "err_auth_not" then
			dialog(recv.RspMsg or "当前脚本未激活，请使用激活码激活！")
			return "activateUI"
		elseif recv.RspCode == "act_expired" then
			dialog(recv.RspMsg or "授权已过期，请重新使用激活码激活！")
			return "activateUI"
		else
			dialog(recv.RspMsg or "登录异常，请联系管理员！")
			return "exit"
		end
	end
	
	if recv.AuthType == "trial" or recv.AuthType == "day" or recv.AuthType == "week" then
		if tonumber(recv.AuthRemaining) < 60 * 60 then
			dialog("授权即将结束，请尽快购买激活码激活！", 5)
		end
	elseif recv.AuthType == "month" or recv.AuthType == "sezon" or recv.AuthType == "year" then
		if tonumber(recv.AuthRemaining) < 24 * 60 * 60 then
			dialog("授权即将结束，请尽快购买激活码激活！", 5)
		end
	elseif recv.AuthType == "unlimited" then
		--
	elseif recv.AuthType == "special" then
		dialog("欢迎特权大佬！", 5)
	elseif recv.AuthType == "expired" then
		dialog("授权已结束，请重新激活！")
		return "activateUI"
	else
		dialog("当前脚本未授权！请激活！")
		return "activateUI"
	end
	
	return "authorized"
end

local function onlineRegist()
	if not registUIData.uid or not registUIData.pwd then
		dialog("输入的注册账号信息异常！")
		return "exit"
	end
	
	local send = {}
	
	send.ReqType= "regist"
	send.Uid = registUIData.uid
	send.Pwd = registUIData.pwd
	send.DevCode = getDeviceIMEI()..getDeviceIMSI()
	send.Script = CFG.SCRIPT_ID
	send.LoggedCode = getLoggedCode()
	send.ReqTime = tostring(os.time())
	
	local http = require("Zlibs/class/Http")
	local rspData = http.Post.tableByJson(CFG.HOST, send)
	if rspData == "" then
		dialog("链接到服务器出错！")
		return "exit"
	end
	
	local recv = json.decode(rspData)
	--[[recv = {
	RspType,
	Uid,
	RspTime,
	RspCode
	RspMsg,
	LoginCode,
	AuthType,
	AuthRemaining,
	}]]
	
	if recv.RspType ~= send.ReqType then
		dialog("返回数据校验失败！")
		return "exit"
	end
	
	if recv.Uid ~= send.Uid then
		dialog("账户校验失败！")
		return "exit"
	end
	
	if math.abs(recv.RspTime - os.time()) > 60 * 30 then		--服务器时间与本地相差不超过30分钟
		dialog("本地时间和服务器时间不符，请同步本地时间！")
		return "exit"
	end
	
	if recv.RspCode ~= "success" then
		Log("recv.RspCode="..recv.RspCode)
		if recv.RspCode == "err_existed_uid" then
			dialog(recv.RspMsg or "账号已存在，请重新注册！")
			return "registUI"
		elseif recv.RspCode == "err_regist" then
			dialog(recv.RspMsg or "注册账户出错，请重新注册！")
			return "registUI"
		elseif recv.RspCode == "err_regist_trial" then
			dialog(recv.RspMsg or "注册账户成功，但未发放试用资格！")
			return "login"
		else
			dialog(recv.RspMsg or "注册失败！")
			return "exit"
		end
	end
	
	dialog("恭喜，注册成功！")
	setUid(registUIData.uid)
	setPwd(registUIData.pwd)
	
	return "login"
end

local function onlineActivate()
	if not activateUIData.cdkey then
		dialog("输入的激活码异常！")
		return "exit"
	end

	local send = {}
	
	send.ReqType = "activate"
	send.Uid = getUid()
	send.Pwd = getPwd()
	send.DevCode = getDeviceIMEI()..getDeviceIMSI()
	send.Script = CFG.SCRIPT_ID
	send.LoggedCode = getLoggedCode()
	send.ReqTime = tostring(os.time())
	send.Cdkey = activateUIData.cdkey
	
	local http = require("Zlibs/class/Http")
	local rspData = http.Post.tableByJson(CFG.HOST, send)
	if rspData == "" then
		dialog("链接到服务器出错！")
		return "exit"
	end
	
	local recv = json.decode(rspData)
	--[[recv = {
	RspType,
	Uid,
	RspTime,
	RspCode
	RspMsg,
	LoginCode,
	AuthType,
	AuthRemaining,
	}]]
	
	if recv.RspType ~= send.ReqType then
		dialog("返回数据校验失败！")
		return "exit"
	end
	
	if recv.Uid ~= send.Uid then
		dialog("账户校验失败！")
		return "exit"
	end
	
	if math.abs(recv.RspTime - os.time()) > 60 * 30 then		--服务器时间与本地相差不超过30分钟
		dialog("本地时间和服务器时间不符，请同步本地时间！")
		return "exit"
	end
	
	if recv.RspCode ~= "success" then
		Log("recv.RspCode="..recv.RspCode)
		if recv.RspCode == "err_not_exist_cdkey" then
			dialog(recv.RspMsg or "激活码无效！")
			return "activateUI"
		elseif recv.RspCode == "err_used_cdkey" then
			dialog(recv.RspMsg or "激活码已使用过，请重新输入！")
			return "activateUI"
		else
			dialog(recv.RspMsg or "激活出错，请联系管理员！")
			return "exit"
		end
	end
	
	dialog("恭喜，激活成功!")
	
	return "login"
end

function login()
	if PREV.restarted then return end
	
	local action = "login"
	
	if getUid() == "NULL" or getPwd() == "NULL" then		--检测账户信息是否存在
		Log("not exsit user info!")
		local ret = dialogRet("欢迎使用萝卜脚本！", "登录账号", "注册账号", "", 0)
		if ret == 0 then
			action = "loginUI"
		elseif ret == 1 then
			action = "registUI"
		end
	elseif getLoggedCode() == "NULL" or getLoggedDate() == "NULL" then		--检测登录码是否存在
		Log("not exsit loggedCode or loggedDate!")
		action = "loginUI"
	elseif math.abs(os.time() - tonumber(getLoggedDate())) > 30 * 24 * 60 * 60 then		--检测登录码是否过期
		Log("Logged expired!")
		action = "loginUI"
	end
	
	while true do
		if action == "loginUI" then
			showLoginUI()
			action = "login"
		elseif action == "login" then
			action = onlineLogin()
		elseif action == "registUI" then
			showRegistUI()
			action = "regist"
		elseif action == "regist" then
			action = onlineRegist()
		elseif action == "activateUI" then
			showActivateUI()
			action = "activate"
		elseif action == "activate" then
			action = onlineActivate()
		elseif action == "exit" then
			lua_exit()
		elseif action == "authorized" then
			break
		end
	end
	
	Log("login success!")
end

--setUid("NULL")
--setPwd("NULL")
--setLoggedCode("NULL")
--setLoggedDate("NULL")

login()





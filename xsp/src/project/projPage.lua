-- projPage.lua
-- Author: cndy1860
-- Date: 2018-12-28
-- Descrip: 开发项目的界面信息，初始化时将插入pageList总表

--备注:
--所有dstArea只有在dstArea == Rect.ZERO时候才会在初始化时进行getAnchorArea，否则使用预设的数据
--所有dstPos只有在dstPos == ""时候才会在初始化时进行scalePos，否则使用预设的数据
--在执行点击widgetList或者进行navigation时，存在actionFunc的时候优先执行actionFunc，否则点击dstPos的第一个点
--page.enable标识当前界面是否加入getCurrentPage判定，在exec.run里根据任务设置（丢掉所有非当前任务的界面）
--widget.enable仅仅标识在matchPage/matchWidgets时，是否作为匹配项，其他操作不受影响，如Init时的缩放、matchWidget、tapWidget

--界面
local _pageList = {
	{
		tag = "其他",
		widgetList = {
			{
				tag = "玩家信息",
				enable = true,
				anchor = "LM",
				srcPos = "343|308|0xffffff,343|315|0x007aff,324|312|0x007aff,363|313|0x007aff,324|355|0x007aff,362|355|0x007aff",
				--dstPos = "",
				--dstArea = Rect.ZERO
			},
			{
				tag = "游戏帮助",
				enable = true,
				anchor = "LB",
				srcPos = "343|308|0xffffff,343|315|0x007aff,324|312|0x007aff,363|313|0x007aff,324|355|0x007aff,362|355|0x007aff",
			},
			{
				tag = "设置",
				enable = true,
				anchor = "RM",
				srcPos = "962|334|0x007aff,1009|352|0x007aff,1008|315|0x007aff,989|318|0xffffff,974|334|0xffffff,989|348|0xffffff",
			},
			{
				tag = "支持",
				enable = true,
				anchor = "RB",
				srcPos = "985|575|0x007aff,1016|575|0x007aff,1017|594|0x007aff,993|589|0xffffff,965|606|0xffffff,979|598|0x007aff",
			},
		},
	},
	{
		tag = "比赛",
		widgetList = {
			{
				tag = "活动模式",
				enable = true,
				anchor = "LM",
				srcPos = "331|312|0x007aff,356|311|0x007aff,326|323|0xffffff,361|322|0xffffff,343|348|0x007aff,338|354|0xffffff,350|354|0xffffff,344|362|0x007aff",
			},
			{
				tag = "联赛",
				enable = true,
				anchor = "LB",
				srcPos = "327|579|0x007aff,316|569|0xffffff,358|579|0x007aff,368|569|0xffffff,336|611|0x007aff,327|619|0xffffff,361|617|0xffffff,353|609|0x007aff",
			},
			{
				tag = "线上对战",
				enable = true,
				anchor = "RM",
				srcPos = "985|310|0x007aff,987|302|0xffffff,1005|324|0xffffff,997|334|0x007aff,982|332|0x007aff,974|343|0xffffff",
			},
			{
				tag = "本地比赛",
				enable = true,
				anchor = "RB",
				srcPos = "979|581|0xffffff,991|571|0x007aff,1007|601|0xffffff,1003|614|0x007aff,989|611|0xffffff,977|614|0x007aff,992|595|0x007aff",
			},
		},
	},
	{
		tag = "线上对战",
		widgetList = {
			{
				tag = "控制球员",
				enable = true,
				anchor = "LM",
				srcPos = "293|346|0x007aff,297|408|0x007aff,285|371|0x007aff,300|371|0x007aff,292|357|0xf8f9fb,277|390|0xf8f9fb,308|389|0xf8f9fb",
			},
			{
				tag = "自动比赛",
				enable = true,
				anchor = "MTB",
				srcPos = "668|346|0x007aff,661|372|0x007aff,676|370|0x007aff,668|356|0xf8f9fb,673|408|0x007aff,523|140|0xE74C75-0x0F1C13,608|140|0xE74C75-0x0F1C13,655|391|0xf8f9fb",
			},
			{
				tag = "在线比赛",
				enable = true,
				anchor = "RM",
				srcPos = "1039|343|0xf8f9fb,1038|357|0x007bfd,1018|374|0x007bfd,1010|375|0xf8f9fb,1063|392|0x007bfd,1068|399|0xf8f9fb,1035|377|0x007bfd,1051|375|0x007bfd",
			},
		},
	},
	{
		tag = "活动模式",	--巡回赛
		widgetList = {
			{
				tag = "控制球员",
				enable = true,
				anchor = "L",
				srcPos = "447|345|0xf8f9fb,459|346|0x444444,482|335|0x444444,494|345|0xf8f8fa,498|333|0xf8f9fb,485|325|0xf8f9fb,491|357|0xf9f9fb,470|358|0x444444",
			},
			{
				tag = "自动比赛",
				enable = true,
				anchor = "R",
				srcPos = "447|345|0xf8f9fb,459|346|0x444444,482|335|0x444444,494|345|0xf8f8fa,498|333|0xf8f9fb,485|325|0xf8f9fb,491|357|0xf9f9fb,470|358|0x444444",
			},
		},
	},
	{
		tag = "天梯教练模式",
		widgetList = {
			{
				tag = "球队管理",
				enable = true,
				anchor = "LB",
				srcPos = "71|406|0x0079fd,63|406|0xffffff,103|405|0x0079fd,109|402|0xffffff,111|438|0x12a42b,111|442|0x12a42b",
			},
			{
				tag = "赛季信息",
				enable = true,
				anchor = "T",
				srcPos = "280|101|0x1f1f1f,269|137|0x1f1f1f,885|99|0x1f1f1f,893|135|0x1f1f1f,792|119|0xfc3979,468|119|0x1f1f1f",
			},
			{
				tag = "奖励信息",
				enable = true,
				anchor = "R",
				srcPos = "958|103|0x1f1f1f,1286|102|0x1f1f1f,958|623|0x1f1f1f,1283|621|0x1f1f1f,980|261|0x363636,1261|134|0x363636",
			},
		},
	},
	{
		tag = "巡回模式",		--教练和手动都一样
		widgetList = {
			{
				tag = "球队管理",
				enable = true,
				anchor = "LT",
				srcPos = "123|175|0x12a42b,123|167|0xffffff,102|168|0x0079fd,67|169|0x0079fd,75|133|0x0079fd,110|132|0x0079fd,94|180|0xffffff",
			},
			{
				tag = "比赛历史",
				enable = true,
				anchor = "LM",
				srcPos = "77|303|0xc0c7c7-0x141214,72|328|0x55bd74-0x441a4a,61|329|0x0079fe,93|328|0x0079fe,110|329|0x55bd74-0x441a4a,124|327|0x0079fe",
			},
			{
				tag = "巡回信息",
				enable = true,
				anchor = "A",
				srcPos = "527|224|0xf44189,491|107|0x2a2a2a,500|588|0x323232,1243|107|0x2a2a2a,1238|582|0x323232",
			},
		},
	},
	{
		tag = "选择电脑级别",		--教练和手动都一样
		widgetList = {
			{
				tag = "超巨",
				enable = true,
				anchor = "B",
				srcPos = "385|607|0xff9500,307|606|0xff9500,248|613|0xffffff,187|608|0xff9500,187|210|0xff9500,386|214|0xb2b2b2,387|370|0xb2b2b2",
			},
		},
	},
	{
		tag = "阵容展示",
		widgetList = {
			{
				tag = "主客场球衣",
				enable = true,
				anchor = "CLB",
				srcPos = "175|697|0x000000,175|713|0x000000,137|698|0x353e5f,157|698|0x353e5f,198|718|0x353e5f,207|718|0x353e5f",
			},
			{
				tag = "替补席",
				enable = true,
				anchor = "LM",
				srcPos = "95|398|0xfefefe,79|401|0x0079fe,114|400|0x0079fe,106|420|0xfefefe,74|409|0x0079fe,76|455|0x0079fe,116|456|0x0079fe",
			},
			{
				tag = "比赛设置",
				enable = true,
				anchor = "LB",
				srcPos = "96|581|0xfdfdfd,90|586|0x007aff,101|586|0x007aff,91|575|0x007aff,100|575|0x007aff,82|581|0xfdfdfd,109|580|0xfdfdfd",
			},
			{
				tag = "切换状态",
				enable = true,
				anchor = "RB",
				srcPos = "840|697|0xDDE0C3-0x221F3C,805|684|0xDDE0C3-0x221F3C,886|679|0xDDE0C3-0x221F3C",
				dstArea = Rect(		--要规避巡回赛切到声望时，对判定有干扰
					math.floor(CFG.EFFECTIVE_AREA[1] + (CFG.EFFECTIVE_AREA[3] - CFG.EFFECTIVE_AREA[1]) * 1 / 2 + 50 * (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2])/750),
					math.floor(CFG.EFFECTIVE_AREA[2] + (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) * 5 / 6),
					math.floor((CFG.EFFECTIVE_AREA[3] - CFG.EFFECTIVE_AREA[1]) / 4),
					math.floor((CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) / 6)
				)
			},
			{
				tag = "身价溢出",	--用于判断是否身价溢出而精神低迷
				enable = false,
				anchor = "R1/3",
				srcPos = "1161|514|0xfd3830,1087|514|0xfd3830,1220|514|0xfd3830,1093|497|0x1f1f1f,1267|610|0x1f1f1f,1080|603|0x1f1f1f,1079|201|0x1f1f1f,1259|219|0x1f1f1f",
			},
		},
	},
	{
		tag = "比赛中",
		widgetList = {
			{
				tag = "比赛信息",
				enable = true,
				anchor = "dLT",
				srcPos = "186|22|0xeac278,184|42|0xeac278,289|22|0xeac278,290|39|0xeac278,45|63|0x001e30,153|83|0x001e30,322|60|0x001e30,430|80|0x001e30",
			},
			{
				tag = "门球",
				enable = false,
				anchor = "RT",
				srcPos = "1086|138|0xffffff,1086|168|0xffffff,1084|245|0xffffff,1087|273|0xffffff,1173|127|0xffffff,1175|285|0xffffff",
			},
		},
	},
	{
		tag = "终场统计",
		widgetList = {
			{
				tag = "比赛事件",
				enable = true,
				anchor = "M",
				srcPos = "491|317|0xc6ced3-0x21191d,500|317|0x5fabfe-0x603201,510|344|0x5fabfe-0x603201,523|315|0x5fabfe-0x603201,530|315|0xffffff,537|315|0x5fabfe-0x603201,529|321|0x5fabfe-0x603201",
			},
			{
				tag = "抢断区域",
				enable = true,
				anchor = "M1/3",
				srcPos = "511|510|0xffffff,505|505|0x12a42b,529|541|0x12a42b,519|494|0xc6ced3-0x21191d,532|494|0x5fabfe-0x603201",
			},
			{
				tag = "球员评价",
				enable = true,
				anchor = "RM",
				srcPos = "945|323|0x36b24b-0x240e21,930|306|0x0079fe,957|309|0x0079fe,927|350|0x0079fe,960|350|0x0079fe,944|351|0xffffff,943|339|0x0079fe",
			},
		},
	},
	
	--联赛
	{
		tag = "联赛",
		widgetList = {
			{
				tag = "手动联赛",
				enable = true,
				anchor = "LT",
				srcPos = "106|124|0x0079fe,86|123|0xfefefe,125|124|0xfefefe,80|196|0xfefefe,129|198|0xfefefe,106|198|0x0079fe,87|157|0x0079fe,122|158|0x0079fe",
			},
			{
				tag = "教练模式联赛",
				enable = true,
				anchor = "RT",
				srcPos = "751|129|0x0079fe,752|123|0xfefefe,782|130|0x0079fe,752|198|0x0079fe,731|194|0xfefefe,772|194|0xfefefe,714|153|0xfefefe,790|155|0xfefefe",
			},
			{
				tag = "手动联赛战绩",
				enable = true,
				anchor = "LB",
				srcPos = "144|458|0xfefefe,106|451|0x12a12b,90|471|0x0079fe,77|419|0xfefefe,82|430|0x0079fe,95|421|0x0079fe,110|415|0xfefefe,104|428|0x0079fe",
			},
			{
				tag = "教练模式联赛战绩",
				enable = true,
				anchor = "RB",
				srcPos = "790|458|0xfefefe,750|455|0x12a12b,738|473|0x0079fe,716|423|0x0079fe,762|424|0x0079fe,718|414|0xfefefe,739|414|0xfefefe,762|414|0xfefefe",
			},
		},
	},
	{
		tag = "联赛教练模式",
		widgetList = {
			{
				tag = "球队管理",
				enable = true,
				anchor = "LT",
				srcPos = "65|171|0x0079fd,55|169|0xffffff,65|180|0xffffff,92|172|0x0079fd,91|180|0xffffff,124|176|0x12a42b",
			},
			{
				tag = "联赛信息框",
				enable = true,
				anchor = "A",
				srcPos = "545|226|0x27ba36,480|170|0x2a2a2a,484|206|0x323232,1281|174|0x2a2a2a,1280|213|0x323232,515|570|0x484848,513|609|0x323232,1274|599|0x323232",
			},
			{
				tag = "跳过余下比赛",		--仅用于跳过余下比赛，enable == false，不参与matchPage/matchWidgets
				enable = false,
				anchor = "MTB",
				srcPos = "652|707|0x52a1f9-0x522904,526|689|0xeeeef4,528|724|0xeeeef4,799|691|0xeeeef4,801|718|0xeeeef4,667|662|0xdfdfe1,482|705|0xdfdfe1,861|708|0xdfdfe1",
			},
			{
				tag = "跳过余下比赛-未激活",
				enable = false,
				anchor = "MTB",
				srcPos = "652|708|0x98989c-0x0b0b0b,526|690|0xc5c5c8,527|719|0xc5c5c8,807|689|0xc5c5c8,804|722|0xc5c5c8",
			},
		},
	},
	{
		tag = "点球",
		widgetList = {
			{
				tag = "比分综合特征",
				enable = true,
				anchor = "BM",
				--srcPos = "103|654|0x001e30,222|663|0x001e30,1169|596|0x001e30,1168|714|0x001e30,421|652|0x001e30,909|652|0x001e30",
				srcPos = "622|626|0xf0ca8a,710|685|0xf0ca8a,590|646|0x001e30,742|623|0x001e30,1065|636|0x001e30,1218|653|0x001e30,1163|714|0x001e30,114|654|0x001e30,157|601|0x001e30",
			},
		},
	},
	{
		tag = "初始化界面",
		widgetList = {
			{
				tag = "综合特征",
				enable = true,
				anchor = "A",
				srcPos = "134|302|0xdc0014,182|352|0xdc0014,311|337|0xdc0014,413|329|0xdc0014,555|312|0xdc0014,553|345|0xdc0014,353|445|0xffffff",
			},
		},
	},
	{
		tag = "合同",
		widgetList = {
			{
				tag = "经纪人",
				enable = true,
				anchor = "LM",
				srcPos = "343|337|0x007aff,335|340|0xffffff,351|340|0xffffff,357|332|0xffffff,329|332|0xffffff,343|326|0x007aff,322|354|0x007aff,360|343|0x007aff",
			},
			{
				tag = "拍卖",
				enable = true,
				anchor = "LB",
				srcPos = "339|587|0x007aff,326|587|0xffffff,339|600|0xffffff,334|580|0x007aff,345|591|0x007aff,345|581|0x007aff,319|607|0x007aff,316|594|0xffffff",
			},
			{
				tag = "球探",
				enable = true,
				anchor = "RM",
				srcPos = "979|341|0x007aff,999|341|0x007aff,969|334|0xffffff,1008|333|0xffffff,983|350|0xffffff,996|350|0xffffff,965|356|0x007aff,1006|355|0x007aff",
			},
			{
				tag = "主教练",
				enable = true,
				anchor = "RB",
				srcPos = "990|603|0xffffff,982|607|0x007aff,973|605|0x007aff,966|597|0xffffff,966|616|0x007aff,966|625|0xffffff,980|616|0x007aff,989|616|0xffffff,1014|615|0x007aff",
			},
		},
	},
	{
		tag = "决战32强",
		widgetList = {
			{
				tag = "报名",
				enable = true,
				anchor = "RB",
				srcPos = "926|645|0x0079fe,666|645|0xf5f5f5,630|639|0xcbdef1,700|650|0xcbdef1,216|634|0xcbdef1,1102|663|0xcbdef1,205|92|0x1b0b38,1135|82|0x1a0b38",
			},
		},
	},
	{
		tag = "冠军赛",
		widgetList = {
			{
				tag = "球队管理",
				enable = true,
				anchor = "LT",
				srcPos = "65|171|0x0079fd,55|169|0xffffff,65|180|0xffffff,92|172|0x0079fd,91|180|0xffffff,124|176|0x12a42b",
			},
			{
				tag = "比赛历史",
				enable = true,
				anchor = "LM",
				srcPos = "77|303|0xc0c7c7-0x141214,72|328|0x55bd74-0x441a4a,61|329|0x0079fe,93|328|0x0079fe,110|329|0x55bd74-0x441a4a,124|327|0x0079fe",
			},
			{
				tag = "信息框",
				enable = true,
				anchor = "RT",
				srcPos = "1281|207|0x323232,487|210|0x323232,489|603|0x323232,1275|605|0x323232",
			},
		}
	},
	{
		tag = "冠军赛结束",
		widgetList = {
			{
				tag = "冠军杯标题",
				enable = true,
				anchor = "CLT",
				srcPos = "75|30|0xf9f9fb,76|55|0xfbfbfd,61|44|0x494780-0x181c2a,213|49|0x021e30,632|29|0x021e30",
			},
			{
				tag = "重置",
				enable = true,
				anchor = "BM",
				srcPos = "681|701|0xf9665f-0x042c30,531|693|0xeeeef4,525|720|0xeeeef4,811|695|0xeeeef4,802|722|0xeeeef4",
			},
			{
				tag = "下一步未激活",
				enable = true,
				anchor = "CRB",
				srcPos = "1278|706|0x8d8d92,1287|687|0x5d5d5e,1039|720|0x5d5d5e,1039|691|0x5d5d5e,1280|722|0x5d5d5e",
			},
		},
	},
	{
		tag = "国际服季节赛",
		widgetList = {
			{
				tag = "球队管理",
				enable = true,
				anchor = "LT",
				srcPos = "65|171|0x0079fd,55|169|0xffffff,65|180|0xffffff,92|172|0x0079fd,91|180|0xffffff,124|176|0x12a42b",
			},
			{
				tag = "比赛历史",
				enable = true,
				anchor = "LM",
				srcPos = "77|303|0xc0c7c7-0x141214,72|328|0x55bd74-0x441a4a,61|329|0x0079fe,93|328|0x0079fe,110|329|0x55bd74-0x441a4a,124|327|0x0079fe",
			},
			{
				tag = "信息框",
				enable = true,
				anchor = "LT",
				srcPos = "494|104|0x2a2a2a,514|577|0x323232,1271|108|0x2a2a2a,1250|591|0x323232,525|479|0xffc000,544|396|0x27ba36",
			},
		}
	},
}

--公共导航控件，如下一步、返回、确认、取消、通知
local _navigationList = {
	{
		tag = "next",
		enable = true,
		caching = false,
		anchor = "CRB",
		srcPos = "1277|705|0xC8E2FD-0x361C01,1192|683|0x0079fd,1187|727|0x0079fd,1091|705|0x0079fd",
		dstArea = Rect(
			math.floor(CFG.EFFECTIVE_AREA[1] + (CFG.EFFECTIVE_AREA[3] - CFG.EFFECTIVE_AREA[1]) * 3 / 4),
			math.floor(CFG.EFFECTIVE_AREA[2] + (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) * 7 / 8),
			math.floor(CFG.DST_RESOLUTION.width - (CFG.EFFECTIVE_AREA[1] + (CFG.EFFECTIVE_AREA[3] - CFG.EFFECTIVE_AREA[1]) * 3 / 4)),
			math.floor(CFG.DST_RESOLUTION.height - (CFG.EFFECTIVE_AREA[2] + (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) * 7 / 8))
		)
	},
	{
		tag = "comfirm",
		enable = true,
		caching = false,
		anchor = "MTB",
		--srcPos = "843|449|0xcaddf0,884|405|0xcaddf0,507|457|0xcaddf0,409|407|0xcaddf0,487|379|0xf5f5f5,804|491|0xf5f5f5,328|436|0xf5f5f5,1007|435|0xf5f5f5",
		--兼容手机联赛界面的确定按钮过小的问题
		srcPos = "864|497|0xcaddf0,861|467|0xcaddf0,415|475|0xcaddf0,554|499|0xcaddf0,329|486|0xf5f5f5,997|481|0xf5f5f5,502|549|0xf5f5f5,831|427|0xf5f5f5",
	},
	{
		tag = "notice",
		enable = true,
		anchor = "RT",
		srcPos = "1279|54|0x55a4f9-0x562b06,1269|45|0x55a4f9-0x562b06,1289|44|0x55a4f9-0x562b06,1268|65|0x55a4f9-0x562b06,1288|64|0x55a4f9-0x562b06,\
		1268|55|0xccdff2,1278|44|0xccdff2,1289|54|0xccdff2,1198|66|0xffffff",
	},
	{
		tag = "back",
		enable = true,
		anchor = "CLB",
		srcPos = "56|706|0xc8e2fd-0x361c01,72|707|0x0079fe,173|690|0x0079fe,218|719|0x0079fe",
		dstArea = Rect(
			CFG.EFFECTIVE_AREA[1],
			math.floor(CFG.EFFECTIVE_AREA[2] + (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) * 7 / 8),
			math.floor(CFG.DST_RESOLUTION.width - (CFG.EFFECTIVE_AREA[1] + (CFG.EFFECTIVE_AREA[3] - CFG.EFFECTIVE_AREA[1]) * 3 / 4)),
			math.floor(CFG.DST_RESOLUTION.height - (CFG.EFFECTIVE_AREA[2] + (CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) * 7 / 8))
		)
	},
	{
		tag = "球员续约-球员列表",
		enable = true,
		anchor = "TL",
		srcPos = "279|175|0xffffff,279|167|0xff3b2f,267|184|0xff3b2f,290|184|0xff3b2f,278|198|0xff3b2f,100|189|0xffffff,1224|204|0xffffff",
		actionFunc = refreshContract	--续约合同,
	},
	{
		tag = "教练签约-满足条件",	--不满足条件的，放在巡回赛界面点击续约处理
		enable = true,
		anchor = "MTB",
		srcPos = "651|698|0x66abf9-0x673204,517|689|0xeeeef4,803|721|0xeeeef4,531|353|0x7391af-0x534130,564|230|0x7391af-0x534130",
	},
	{
		tag = "国际服教练签约-满足条件",	--不满足条件的，放在巡回赛界面点击续约处理
		enable = true,
		anchor = "MTB",
		srcPos = "651|700|0x2f90fb-0x2f1702,659|682|0xeeeef4,658|666|0xe2e2e4,659|637|0xffffff,530|690|0xeeeef4,800|722|0xeeeef4,1002|700|0xe2e2e4,1035|699|0x5d5d5e",
	},
}

--全局导航优先级
local _navigationPriorityList = {
	"球员续约-球员列表",
	"comfirm",
	"next",
	"notice",
	"教练签约-满足条件",
	"国际服教练签约-满足条件",
}


--公用控件，不参与流程检测，只在特殊界面下出现后，进行点击操作
local _commonWidgetList = {
	{
		tag = "球员续约-点击签约",
		enable = true,
		anchor = "A",
		srcPos = "822|698|0x0079fd,487|709|0x0079fd,614|702|0xeeeef4,728|707|0xeeeef4,1078|706|0x0079fd",
	},
	{
		tag = "球员续约-续约",
		enable = true,
		anchor = "A",
		srcPos = "640|212|0x4a9ffa-0x4b2603,558|211|0x4a9ffa-0x4b2603,784|208|0x4a9ffa-0x4b2603,671|121|0x4a9ffa-0x4b2603,536|536|0xf5f5f5,525|652|0xcbdef1",
	},
	{
		tag = "付款确认",
		enable = true,
		anchor = "A",
		--IOS和安卓偏色不一样，注意取色
		--srcPos = "519|395|0xa0c3fb-0x0b0804,502|394|0x2361d8-0x211f26,476|395|0x2361d8-0x211f26,532|394|0x2361d8-0x211f26,506|339|0xe6e6ed",(只兼容国服)
		--以下改为兼容国际服偏色
		srcPos = "519|395|0xaac7fb-0x0f0804,502|394|0x2258d3-0x222829,476|395|0x2258d3-0x222829,532|394|0x2258d3-0x222829,506|339|0xe6e6ed"
	},
	{
		tag = "球队异常",		--教练合约失效或球员红牌、伤病
		enable = true,
		anchor = "LT",
		srcPos = "429|81|0xffffff,428|72|0xff3b2f,422|81|0xff3b2f,438|82|0xff3b2f,397|101|0xffffff,462|63|0xe1e1e3,370|123|0xffffff",
	},
	{
		tag = "教练合约失效",		--教练合约失效
		enable = true,
		anchor = "CLT",
		srcPos = "146|92|0xffffff,145|84|0xff8a82-0x004f54,134|95|0xff8a82-0x004f54,155|95|0xff8a82-0x004f54,145|111|0xff8a82-0x004f54",
		dstArea = Rect(
			CFG.EFFECTIVE_AREA[1],
			CFG.EFFECTIVE_AREA[2],
			(CFG.EFFECTIVE_AREA[3] - CFG.EFFECTIVE_AREA[1]) / 8,
			(CFG.EFFECTIVE_AREA[4] - CFG.EFFECTIVE_AREA[2]) / 4
		)
	},
	{
		tag = "教练续约",		--点击教练续约
		enable = true,
		anchor = "A",
		srcPos = "687|346|0x6db0f9-0x6e3804,711|242|0x6db0f9-0x6e3804,705|150|0x6db0f9-0x6e3804,683|444|0x6db0f9-0x6e3804",
	},
	{
		tag = "罚点球员",
		enable = true,
		caching = false,
		anchor = "A",
		srcPos = "934|331|0x00f8ff,930|325|0x00f8ff,938|325|0x00f8ff",
	},
	{
		tag = "球队菜单",		--只在球队取了首点，后边的是点在替补席的球衣上，注意锚点
		enable = true,
		caching = false,
		anchor = "LT",
		srcPos = "52|329|0x1d3753-0x060605,106|422|0xfefefe,93|418|0x0079fe,107|408|0x0079fe,118|422|0x0079fe,113|452|0x0079fe,126|439|0xfefefe,63|440|0xfefefe",
	},
	{
		tag = "保存",
		enable = true,
		caching = false,
		anchor = "LB",
		srcPos = "478|697|0xffffff,448|692|0xffffff,512|694|0xffffff,480|666|0xffffff,481|726|0xffffff,237|699|0x0079fe",
	},
	{
		tag = "切换小队",
		enable = true,
		caching = false,
		anchor = "T",
		srcPos = "715|159|0x3694fb-0x361c02,694|185|0xf5f5f5,770|244|0x3694fb-0x361c02,765|278|0xf5f5f5,784|592|0xf5f5f5,798|626|0x3694fb-0x361c02",
	},
	{
		tag = "设为主力阵容",
		enable = true,
		caching = false,
		anchor = "TM",
		srcPos = "651|211|0x3694fb-0x361c02,654|126|0xfa766e-0x033b3f,736|294|0x3694fb-0x361c02,672|39|0x3d3d3d-0x3e3e3e",
	},
}



--将项目的pageList、navigationList和_navigationPriorityList,_commonWidgetList插入page总表
page.loadPagesData(_pageList, _navigationList, _navigationPriorityList, _commonWidgetList)


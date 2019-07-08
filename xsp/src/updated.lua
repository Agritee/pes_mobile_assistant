-- updated.lua
-- Author: cndy1860
-- Date: 2019-07-06
-- Descrip: 代码更新记录

--2019/07/06
--增加登录奖励选择，默认选择金币
--增加自动重启时，初始化界面(库鸟)的等待时间，防止过早超时，点击点右移
--增加公告显示功能，默认每则index的公告只显示一次，首行格式-index-*****-，次行-exclude-****-，移除原来白名单tips弹窗
--修改比赛中跳过回放的点击位置为右上角(-150,-150)，防止因点击到弹窗而切换至其他应用的问题
--移除最新公告栏
--手动巡回赛中，增加缓存按钮位置和排除干扰点的机制，以防止主场不开球和长时间没有有效点击的问题，更低概率使用射门键防止吃牌
--修改了prt函数，但愿没坑
--重写了timeout时，记录应用运行状态的代码
--timeout时，再重启之前截图
--增加了续约时tap的delay，防止点击失败了
--增加一键抽球探功能，但目前云手机运行缓慢

--2019/07/07
--DEFAULT_TAP_TIME修改为80ms，防止偶尔导致的续约失败
--国际服自动重启时可能出现网络错误，在processInitPage里增加了跳过comfirm

--2019/07/08
--个别点球界面点往外移，避免球队图标过大时挡住判定点
--兼容在比赛开始界面的球员续约：
---"球员续约-点击签约",最右边的下一步上的蓝点移除，并指定B/4，这样在比赛开始界面发生的续约也能识别(国服)，同时修改续约函数，有"back"的时候返回
---国际服机型二次续约
--点击换人图标时，增加一次判定防止“状态”二字未消影响判定
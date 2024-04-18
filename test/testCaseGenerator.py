import random
import datetime
import numpy as np
import hashlib

colleges = [
    ("哲学社会学院", "哲学"), ("哲学社会学院", "社会学"),
    ("新闻与传播学院", "新闻与传播学"), ("国际语言学院", "国际语言学"),
    ("考古学院", "考古学"), ("外国语学院", "外国语"),
    ("艺术学院", "艺术"), ("体育学院", "体育"),
    ("经济学院", "经济学"), ("法学院", "法学"),
    ("行政学院", "行政学"), ("商学与管理学院", "工商管理"),
    ("马克思主义学院", "马克思主义"), ("东北亚学院", "东北亚学"),
    ("公共外交学院", "外交学"), ("数学学院", "数学"),
    ("物理学院", "物理学"), ("化学学院", "化学"),
    ("生命科学学院", "生命科学"), ("机械与航空航天工程学院", "机械与航空航天工程"),
    ("汽车工程学院", "汽车工程"), ("材料科学与工程学院", "材料科学与工程"),
    ("交通学院", "交通学"), ("生物与农业工程学院", "生物与农业工程"),
    ("仿生科学与工程学院", "仿生科学与工程"), ("管理学院", "管理学"),
    ("食品科学与工程学院", "食品科学与工程"), ("电子科学与工程学院", "电子科学与工程"),
    ("通信工程学院", "通信工程"), ("计算机科学与技术学院", "计算机科学与技术"),
    ("软件学院", "软件工程"), ("地球科学学院", "地球科学"),
    ("地球探测科学与技术学院", "地球探测科学与技术"), ("建设工程学院", "建设工程"),
    ("新能源与环境学院", "新能源与环境学"), ("仪器科学与电气工程学院", "仪器科学"),
    ("基础医学院", "基础医学"), ("公共卫生学院", "公共卫生学"),
    ("药学院", "药学"), ("护理学院", "护理学"),
    ("白求恩第一临床医学院", "临床医学"), ("白求恩第二临床医学院", "临床医学"),
    ("白求恩第三临床医学院", "临床医学"), ("白求恩口腔医学院", "口腔医学"),
    ("动物医学学院", "动物医学"), ("植物科学学院", "植物科学"),
    ("网络安全学院", "网络空间安全"), ("人工智能学院", "人工智能"),
]

names = [
    "张吉惟", "林国瑞", "林玫书", "林雅南", "江奕云", "刘柏宏", "阮建安", "林子帆", "夏志豪", "吉茹定", "李中冰", "黄文隆",
    "谢彦文", "傅智翔", "洪振霞", "刘姿婷", "荣姿康", "昌致盈", "方一强", "黎芸贵", "郑伊雯", "雷进宝", "吴美降", "吴心真",
    "王美珠", "郭芳天", "李雅惠", "陈文婷", "曹敏有", "王依婷", "陈婉璇", "吴美玉", "蔡依婷", "郑昌梦", "林家纶", "黄丽昆",
    "李育泉", "黄芸欢", "吴韵如", "李肇芬", "卢木仲", "李成白", "方兆玉", "刘翊惠", "丁汉臻", "吴佳瑞", "舒绿巩", "周白芷",
    "张姿好", "张虹伦", "周琼攻", "倪怡芳", "郭贵妃", "杨佩芳", "黄文旺", "黄盛玫", "郑丽青", "许智云", "张孟涵", "李小爱",
    "王恩龙", "朱政廷", "邓诗涵", "陈政倩", "吴俊伯", "阮馨学", "翁惠珠", "吴思翰", "林佩玲", "邓海来", "陈翊依", "李建智",
    "武淑芬", "金雅琪", "赖怡宜", "黄育霖", "张仪湖", "王俊民", "张诗刚", "林慧颖", "沈俊君", "陈淑好", "李姿伶", "高咏钰",
    "黄彦宜", "周孟儒", "潘欣臻", "李祯韵", "叶洁启", "梁哲宇", "黄晓萍", "杨雅萍", "卢志铭", "张茂以", "林婉婷", "蔡宜芸",
    "林瑜", "黄柏仪", "周逸现", "夏雅惠", "王采现", "林孟霖", "林竹水", "王怡乐", "王爱乐", "金佳蓉", "韩健毓", "李士杰",
    "陈萱珍", "苏姿婷", "张政霖", "李志宏", "陈索达", "陈虹荣", "何美玲", "李仪琳", "张俞幸", "黄秋萍", "潘吉维", "陈智筠",
    "蔡书玮", "陈信峰", "林培伦", "查瑜舜", "黎慧首", "郑士易", "陈建豪", "吴怡婷", "徐紫富", "张博海", "黎宏儒", "柯乔喜",
    "胡睿纯", "王淑月", "陈百菁", "王雅娥", "董佩珊", "李必辰", "吴耀华", "彭郁婷", "王秀玲", "谢佳儒", "罗静摹", "杨舒南",
    "蔡政琳", "杨绍瑜", "金育木", "杨韦成", "韩宁政", "蒋廷湖", "毛展霞", "廖婉宏", "黄怡强", "郭冰宇", "黄伟依", "叶元映",
    "林智超", "李姿婷", "李莉火", "邱雅要", "王淑芳", "陈枝盈", "高成彦", "徐采伶", "杨大雪", "林彦韦", "李升毓", "邱宜瑶",
    "陈政文", "李直豪", "陈直宁", "陈志宏", "阮柔治", "林乐妹", "简健昀", "廖推君", "梁佩芬", "苏玮伦", "秦娇真", "谢佳委",
    "李仁杰", "李佳和", "郭贤青", "吴怡伶", "陈怡婷", "阮晴桦", "辛翔坤", "林孟富", "刘美玲", "涂的", "白凯修", "黄蓉芳",
    "赵吟琪", "张裕忠", "石春紫", "方美君", "潘右博", "俞星如", "张冠杰", "钟庭玮", "叶茜彦", "陈伯薇", "陈昭祥", "陈伟伦",
    "黄雅慧", "郭子豪", "黄彦霖", "宋合", "许雅婷", "王圣如", "何伶元", "钟伦军", "蔡佳蓉", "溥康柔", "冯成轩", "陈嘉惠",
    "吴惠劲", "谢健铭", "林怡婷", "廖佳蓉", "李佩伯", "何巩甄", "谢晓玲", "许彦霖", "林威强", "周佳勋", "林静怡", "周筠亚",
    "陈仲宜", "胡东贵", "陈绍翰", "梁炯来", "陈雅吉", "张莉雯", "陈韦荣", "林素伦", "李善芷", "蔡玉婷", "郑智钧", "吴孟钰",
    "蔡国伟", "连俊达", "李雅婷", "李礼娇", "李忆孝", "黄静雯", "陈淳宝", "李文育", "林佳蓉", "罗依茂", "李淑佩", "谢怡君",
    "王美玲", "黄慧学", "邓幸韵", "陈秀碗", "许岳平", "许爱礼", "谢一忠", "简志雪", "赵若喜", "许承翰", "姚哲维", "苏俊安",
    "郭礼钰", "姜佩珊", "张鸿信", "秦欣瑜", "李旺劲", "陈怡爱", "陈秀德", "张佳伶", "郑凯婷", "郑雅任", "黄国妹", "林芳江",
    "江骏生", "黄儒纯", "王培伦", "陈蕙", "蔡宜慧", "陈信意", "陈惠要", "张诱纶", "黄碧仪", "陈志文", "谢懿富", "杨凡靖",
    "蔡秀琴", "温惠玲", "林宗其", "林绍泰", "何佳慧", "蔡辰纶", "王雅雯", "叶怡财", "冯雅筑", "李伦圣", "彭正仁", "刘小紫",
    "温燕达", "刘佳雨", "吴婷婷", "杨怡君", "黄康刚", "林辰和", "陈世人", "吴佩霖", "张伟杰", "刘友淳", "张瑞群", "洪紫芬",
    "邓家伟", "谢佩任", "李治火", "林石美", "郑雅茜", "胡台泰", "陈怡盈", "阙石意", "林盈威", "林志嘉", "李秀玲", "王彦霖",
    "叶惟芷", "郑星钰", "邱贞伟", "姚扬云", "涂武盛"
]

competitions = [
    ("中国“互联网+”大学生创新创业大赛", "A"),
    ("“挑战杯”全国大学生课外学术科技作品竞赛", "A"),
    ("“挑战杯”中国大学生创业计划大赛", "A"),
    ("中国大学生电动方程式汽车大赛", "A"),
    ("中国大学生方程式汽车大赛", "A"),
    ("国际基因工程机器大赛（iGEM）", "A"),
    ("国际生物分子与设计大赛（BIOMOD）", "A"),
    ("中国大学生医学技术技能大赛", "A"),
    ("中国大学生工程实践与创新能力大赛（全国大学生工程训练综合能力竞赛）", "A"),
    ("ACM-ICPC国际大学生程序设计竞赛", "B"),
    ("全国大学生数学建模竞赛", "B"),
    ("全国大学生电子设计竞赛", "B"),
    ("全国大学生化学实验邀请赛", "B"),
    ("全国大学生机械创新设计大赛", "B"),
    ("全国大学生结构设计竞赛", "B"),
    ("全国大学生广告艺术大赛", "B"),
    ("全国大学生智能汽车竞赛", "B"),
    ("全国大学生交通科技大赛", "B"),
    ("全国大学生电子商务“创新、创意及创业”挑战赛", "B"),
    ("全国大学生节能减排社会实践与科技竞赛", "B"),
    ("全国大学生物流设计大赛", "B"),
    ("“外研社杯”Uchallenge全国英语演讲大赛", "B"),
    ("全国大学生机器人大赛RoboMaster机甲大师赛", "B"),
    ("\"西门子杯\"中国智能制造挑战赛", "B"),
    ("全国大学生化工设计竞赛", "B"),
    ("全国大学生先进成图技术与产品信息建模创新大赛", "B"),
    ("全国三维数字化创新设计大赛（大学生组）", "B"),
    ("中国大学生计算机设计大赛", "B"),
    ("全国大学生市场调查与分析大赛", "B"),
    ("中国大学生服务外包创新创业大赛", "B"),
    ("两岸新锐设计竞赛“华灿奖”", "B"),
    ("长江钢琴-全国高校钢琴大赛", "B"),
    ("中国高校计算机大赛（大数据挑战赛、*团体程序设计天梯赛、*移动应用创新赛、*网络技术挑战赛、*人工智能创意赛）", "B"),
    ("全国大学生动物医学专业（本科）技能大赛", "B"),
    ("全国大学生铸造工艺大赛", "B"),
    ("全国大学生地质技能竞赛", "B"),
    ("iCAN全国大学生创新创业大赛", "B"),
    ("全国大学生数学竞赛", "B"),
    ("全国高校讲思政课大赛", "B"),
    ("全国大学生生命科学竞赛", "B"),
    ("全国大学生物理实验竞赛", "B"),
    ("中国日报社“21世纪杯”全国英语演讲比赛", "B"),
    ("全国基础医学创新论坛及实验设计竞赛", "B"),
    ("“东方杯”全国大学生勘探地球物理大赛", "B"),
    ("全国食品类专业工程实践训练综合能力竞赛", "B"),
    ("国际大学生智能农业装备创新大赛", "B"),
    ("*全国周培源大学生力学竞赛", "B"),
    ("*全国大学生嵌入式芯片与系统设计竞赛", "B"),
    ("*“学创杯”全国大学生创业综合模拟大赛", "B"),
    ("*中国大学生机械工程创新创意大赛-智能制造大赛", "B"),
    ("*全国大学生信息安全竞赛", "B"),
    ("*中国机器人大赛", "B"),
    ("*中国高校智能机器人创意大赛", "B"),
    ("*全国高校数字艺术设计大赛（未来设计师NCDA大赛）", "B"),
    ("*米兰设计周——中国高校设计学科师生优秀作品展", "B"),
    ("*中国机器人及人工智能大赛", "B"),
    ("*全国大学生金相技能大赛", "B"),
    ("*华为ICT大赛", "B"),
    ("*全国大学生交通运输科技大赛", "B"),
    ("*蓝桥杯全国软件和信息技术专业人才大赛", "B"),
    ("*全国大学生光电设计竞赛", "B"),
    ("*全国大学生集成电路创新创业大赛", "B"),
    ("*“中国软件杯”大学生软件设计大赛", "B"),
    ("*中美青年创客大赛", "B"),
    ("*RoboCom机器人开发者大赛", "B"),
    ("*“大唐杯”全国大学生移动通信5G技术大赛", "B"),
    ("*全国高校BIM毕业设计创新大赛", "B"),
    ("*全国高校商业精英挑战赛-品牌策划竞赛、会展专业创新创业实践竞赛、国际贸易竞赛、创新创业竞赛", "B"),
    ("*中国好创意暨全国数字艺术设计大寨", "B"),
    ("全国大学生不动产估价技能大赛", "C"),
    ("全国大学生测井技能大赛", "C"),
    ("全国高等学校大学生测绘技能大赛", "C"),
    ("全国大学生GIS应用技能大赛", "C"),
    ("SuperMap杯全国高校GIS大赛", "C"),
    ("ESRI杯中国大学生GIS软件开发大赛", "C"),
    ("全国高校GIS技能大赛（MAPGIS）", "C"),
    ("中国（国际）传感器创新创业大赛", "C"),
    ("“雄鹰杯”小动物医师技能大赛", "C"),
    ("“理律杯”全国高校模拟法庭竞赛", "C"),
    ("“贸仲杯”国际商事仲裁模拟仲裁庭辩论赛", "C"),
    ("国际刑事法院（ICC）模拟法庭审判竞赛（英文）", "C"),
    ("Philip_C._Jessup杰赛普国际法模拟法庭大赛", "C"),
    ("国际人道法（IHL）模拟法庭竞赛", "C"),
    ("法兰克福国际投资模拟仲裁庭-贸仲中国（内地）赛", "C"),
    ("美国大学生数学建模竞赛", "C"),
    ("全国大学生英语竞赛", "C"),
    ("Uchallenge全国英语写作大赛", "C"),
    ("Uchallenge全国英语阅读大赛", "C"),
    ("金蝶云管理创新杯互联网+管理应用大赛", "C"),
    ("IE亮剑全国大学生工业工程案例大赛", "C"),
    ("中国“TRIZ”杯大学生创新方法大赛", "C"),
    ("全国企业创新方法大赛", "C"),
    ("BICES中国-国际工程机械及专用车创意设计大赛", "C"),
    ("机构与机器科学大学生国际奥林匹克竞赛", "C"),
    ("CCSP大学生计算机系统与程序设计竞赛(CCSP，The_College_Computer_Systems_&_Programming_Contest)", "C"),
    ("全国大学生物联网设计竞赛", "C"),
    ("CCPC中国大学生程序设计竞赛", "C"),
    ("全国大学生计算机应用能力与信息素养大赛", "C"),
    ("全国高校智能交通创新与创业大赛", "C"),
    ("全国大学生农业建筑环境与能源工程相关专业创新创业竞赛", "C"),
    ("全国大学生包装结构设计大赛", "C"),
    ("德国红点奖", "C"),
    ("HONDA中国节能竞技大赛", "C"),
    ("中国大学生巴哈越野汽车大赛", "C"),
    ("国际企业管理挑战赛(Global_Management_Challenge,简称GMC)", "C"),
    ("全国大学生金融投资模拟交易大赛", "C"),
    ("全国高等院校企业竞争模拟大赛", "C"),
    ("“用友新道杯”全国大学生ERP沙盘模拟经营大赛", "C"),
    ("全国高校密码数学挑战赛", "C"),
    ("世界机器人大赛", "C"),
    ("国际水中机器人大赛", "C"),
    ("全国口译大赛", "C"),
    ("CCTV“希望之星”英语风采大赛", "C"),
    ("全国高校俄语大赛", "C"),
    ("CCTV西班牙语大赛", "C"),
    ("上海外国语大学CASIO杯中国大学生﹒研究生日语演讲、辩论大赛", "C"),
    ("中华全国日语演讲比赛", "C"),
    ("\"笹川杯\"全国高校日本知识大赛", "C"),
    ("中国人日语作文大赛", "C"),
    ("多语种全国口译大赛", "C"),
    ("笹川杯日本研究论文大赛", "C"),
    ("全国大学生日语演讲及综合技能大赛", "C"),
    ("纽约全美模拟联合国大会", "C"),
    ("视友杯中国高校电视奖", "C"),
    ("全国大学生主持人大赛", "C"),
    ("时报金犊奖", "C"),
    ("One_Show中华青年创意奖", "C"),
    ("戛纳国际创意节戛纳幼狮中国区选拔赛", "C"),
    ("靳埭强设计奖", "C"),
    ("全球华语朗诵大赛暨“曹灿杯”朗诵大赛", "C"),
    ("语文朗读大会", "C"),
    ("夏青杯朗诵大赛", "C"),
    ("中国大学生物理学术竞赛", "C"),
    ("全国大学生水利创新设计大赛", "C"),
    ("全国环境友好科技竞赛", "C"),
    ("全国大学生电子设计竞赛嵌入式邀请赛", "C"),
    ("全国大学生电气与自动化大赛", "C"),
    ("国际大学生雪雕大赛", "C"),
    ("全国高校企业价值创造实战竞赛", "C"),
    ("全国大学生信息安全竞赛（信息安全作品赛；创新实践能力赛）", "C"),
    ("“华为杯”中国大学生智能设计竞赛", "C"),
    ("全国高校大数据应用创新大赛", "C"),
    ("中国高校计算机大赛（微信小程序开发赛）", "C"),
    ("盼盼食品杯烘焙食品创意大赛", "C"),
    ("“三菱电机杯”全国大学生电气与自动化大赛", "C"),
    ("全国高校海洋法模拟法庭邀请赛", "C"),
    ("国际刑事法院（ICC）模拟法庭审判竞赛（中文）", "C"),
    ("金企鹅网络模拟法庭竞赛", "C"),
    ("全国大学生化学实验创新设计竞赛", "C"),
    ("北京国际电影节·大学生电影节", "C"),
    ("中国国际大学生纪录片大赛", "C"),
    ("全国大学生中华经典美文诵读大赛", "C"),
    ("全国大学生有声阅读大赛", "C"),
    ("今日头条新写作大赛", "C"),
    ("中国数据新闻大赛", "C"),
    ("《中国日报》（CHINADAILY）“大学新闻奖”", "C"),
    ("全国日语专业配音大赛", "C"),
    ("韩素音国际翻译大赛", "C"),
    ("\"俄罗斯文艺\"文学翻译奖全球俄汉互译大赛", "C"),
    ("全国校园冰雪创意设计大赛", "C"),
    ("中国大学生广告艺术节学院奖", "C"),
    ("模拟国际投资仲裁深圳杯（FDIMootShenzhen）", "C"),
    ("“从法杯”全国大学生“法治中国”调研大赛", "C"),
    ("全国大学生物流仿真设计大赛", "C"),
    ("全国大学生人力资源管理知识技能竞赛（精创教育杯）", "C"),
    ("全国大学生房地产策划大赛", "C"),
    ("全国大学生数智人力大赛", "C"),
    ("“尖烽时刻”全国商业模拟大赛（“尖烽时刻”全球商业模拟赛中国选拔赛）", "C"),
    ("“我心中的思政课”——全国高校大学生微电影展示", "C"),
    ("全国大学生化工实验大赛", "C"),
    ("全国大学生化工安全设计大赛", "C"),
    ("中国国际飞行器设计挑战赛", "C"),
    ("SAE国际航空设计大赛", "C"),
    ("中国壳牌汽车环保马拉松挑战赛", "C"),
    ("中国优秀工业设计奖", "C"),
    ("中国大学生无人驾驶汽车大赛", "C"),
    ("好设计", "C"),
    ("全国机械工业设计创新大赛", "C"),
    ("中国制冷空调行业大学生竞赛", "C"),
    ("上汽设计国际汽车设计大赛", "C"),
    ("全国大学生焊接创新大赛", "C"),
    ("“天食杯”食品研究与开发创新创意大赛", "C"),
    ("全国大学生机器人大赛（ROBOCOM）", "C"),
    ("无人飞行器智能感知技术竞赛", "C"),
    ("全国高校网安联赛XNUCA", "C"),
    ("全国大学生FPGA创新设计竞赛", "C"),
    ("中国大学生计算机博弈大赛", "C"),
    ("全国大学生土地国情调查大赛", "C"),
    ("全国大学生国土空间规划技能大赛", "C"),
    ("全国大学生自然资源科技作品大赛", "C"),
    ("全国油气地质大赛", "C"),
    ("“创新杯”全国大学生地球物理知识竞赛", "C"),
    ("中国虚拟现实大赛", "C"),
    ("“中科星图杯”国际高分遥感图像解译大赛", "C"),
    ("全国大学生测绘创新开发大赛", "C"),
    ("全国大学生工程地质创新实践大赛", "C"),
    ("国际大学生钻探机器人大赛", "C"),
    ("水科学数值模拟创新大赛", "C"),
    ("全国大学生市政环境类创新实践能力大赛", "C"),
    ("全国虚拟仪器设计大赛", "C"),
    ("全国高校电力电子应用设计大赛", "C"),
    ("全国大学生植物保护专业能力大赛", "C"),
    ("全国青年科普创新实验暨作品大赛", "C"),
    ("全国农科学子创新创业大赛", "C"),
    ("全国大学生动物科学专业技能大赛", "C"),
    ("全国高校军事课教学展示比赛", "C"),
    ("国际青年人工智能大赛", "C")
]

grade_mapping = {"20": "大四", "21": "大三", "22": "大二", "23": "大一"}
class_mapping = {f"{i:02}": f"{i}班" for i in range(0, 17)}
credit_to_studyHour = {
    1: 12,
    2: 24,
    2.5: 36,
    3: 48,
    4: 72
}
paperLevel_to_bonusPoints = {
    "业界公认学科综合顶级期刊": 0.4,
    "CCF-A期刊": 0.2,
    "CCF-A会议长文": 0.2,
    "CCF-B会议的最佳论文/最佳学生论文": 0.2,
    "CCF-B期刊论文": 0.1,
    "中科院期刊分区一区论文": 0.1,
    "CCF-C会议的最佳论文/最佳学生论文": 0.1,
    "CCF-C期刊论文": 0.05,
    "CCF-B会议长文": 0.05,
    "中科院期刊分区二区论文": 0.05,
    "计算机学报、软件学报发表的学术论文": 0.05,
    "影响因子非0的SCI检索期刊论文": 0.02,
    "CCF-C会议长文": 0.02,
    "中国科学：信息科学、计算机研究与发展、计算机辅助设计与图形学学报、电子学报中文版、自动化学报发表的学术论文": 0.02,
    "EI检索期刊": 0.01
}
college_prefix_mapping = {
    "哲学社会学院": "01",
    "新闻与传播学院": "02",
    "国际语言学院": "03",
    "考古学院": "04",
    "外国语学院": "05",
    "艺术学院": "06",
    "体育学院": "07",
    "经济学院": "08",
    "法学院": "09",
    "行政学院": "10",
    "商学与管理学院": "11",
    "马克思主义学院": "12",
    "东北亚学院": "13",
    "公共外交学院": "14",
    "数学学院": "15",
    "物理学院": "16",
    "化学学院": "17",
    "生命科学学院": "18",
    "机械与航空航天工程学院": "19",
    "汽车工程学院": "20",
    "材料科学与工程学院": "21",
    "交通学院": "22",
    "生物与农业工程学院": "23",
    "仿生科学与工程学院": "24",
    "管理学院": "25",
    "食品科学与工程学院": "26",
    "电子科学与工程学院": "27",
    "通信工程学院": "28",
    "计算机科学与技术学院": "29",
    "软件学院": "30",
    "地球科学学院": "31",
    "地球探测科学与技术学院": "32",
    "建设工程学院": "33",
    "新能源与环境学院": "34",
    "仪器科学与电气工程学院": "35",
    "基础医学院": "36",
    "公共卫生学院": "37",
    "药学院": "38",
    "护理学院": "39",
    "白求恩第一临床医学院": "40",
    "白求恩第二临床医学院": "41",
    "白求恩第三临床医学院": "42",
    "白求恩口腔医学院": "43",
    "动物医学学院": "44",
    "植物科学学院": "45",
    "网络安全学院": "46",
    "人工智能学院": "47",
}

# 生成学号
generated_student_ids = set()

# 生成唯一学号
def generate_unique_student_id(college):
    while True:
        prefix = college_prefix_mapping[college]
        grade = random.choice(["20", "21", "22", "23"])
        class_num = f"{random.randint(1, 16):02}"
        student_num = f"{random.randint(1, 35):02}"
        student_id = prefix + grade + class_num + student_num
        if student_id not in generated_student_ids:
            generated_student_ids.add(student_id)
            return student_id

# 根据学号解析年级和班级
def parse_grade_class(student_id):
    grade_code = student_id[2:4]
    class_code = student_id[4:6]
    grade = grade_mapping[grade_code]
    class_num = class_mapping[class_code]
    return grade, class_num

# 生成学业成绩信息
def generate_academic_record():
    score_level = np.random.choice(['high', 'highest', 'normal', 'unnormal'], p=[0.5, 0.2, 0.2, 0.1])
    # 根据成绩级别生成成绩
    if score_level == 'high':  # 50% 的总成绩在75-90分之间
        totalGrade = random.randint(75, 90)
    elif score_level == 'highest':  # 20% 的总成绩在90分以上
        totalGrade = random.randint(90, 100)
    elif score_level == 'normal': # 20% 的总成绩在60-75分之间
        totalGrade = random.randint(60,75)
    else:  # 剩下 10% 的成绩在0-59分之间
        totalGrade = random.randint(0, 59)
    academicYear = random.choice(["2023-2024学年第1学期", "2023-2024学年第2学期"])
    courseName = f"课程{random.randint(1, 100)}"
    courseID = np.random.choice([f"MOOC{random.randint(100000, 999999)}", f"ae{random.randint(10000000, 99999999)}"], p=[0.2, 0.8])
    courseSeq = f"{random.randint(1, 300):03}"
    courseNature = np.random.choice(["必修", "选修", "限选"],p=[0.6,0.3,0.1])
    credit = random.choice(list(credit_to_studyHour.keys()))
    studyHour = credit_to_studyHour[credit]
    # 根据总成绩计算绩点
    gradePoints = {59.5: 0, 63: 1.0, 66: 1.3, 69: 1.7, 73: 2.0, 76: 2.3, 79: 2.7, 83: 3.0, 86: 3.3, 89: 3.7, 100: 4.0}
    gradePoint = next(value for key, value in sorted(gradePoints.items()) if totalGrade <= key)
    retakeType = np.random.choice(['初修', '重修', '重考'], p=[0.8, 0.1, 0.1])
    return (totalGrade, academicYear, courseName, courseID, courseSeq, courseNature, credit, studyHour, gradePoint, retakeType)
    # return f"{totalGrade} {academicYear} {courseName} {courseID} {courseSeq} {courseNature} {credit} {studyHour} {gradePoint} {retakeType}"

def generate_random_date(start_year, end_year):
    start_date = datetime.date(start_year, 1, 1)
    end_date = datetime.date(end_year, 12, 31)
    time_between_dates = end_date - start_date
    days_between_dates = time_between_dates.days
    random_number_of_days = random.randrange(days_between_dates)
    random_date = start_date + datetime.timedelta(days=random_number_of_days)
    return random_date.strftime('%Y-%m-%d')  # 返回格式化的日期字符串

# 生成创新创业计划项目信息
def generate_research_outcome(current_student_name):
    projectID = f"PID{random.randint(1000, 9999)}"
    projectName = f"项目{random.randint(1, 100)}"
    mentorName = random.choice(names)
    if random.random() > 0.5:
        # 当前学生为第一位
        members = [current_student_name] + random.sample([name for name in names if name != current_student_name], random.randint(1, 4))
        bonusPoints = 0.1
    else:
        # 当前学生为第二位
        other_member = random.choice([name for name in names if name != current_student_name])
        members = [other_member, current_student_name] + random.sample([name for name in names if name not in [current_student_name, other_member]], random.randint(0, 3))
        bonusPoints = 0.05
    memberCount = len(members)
    memberNames = "、".join(members)
    startDate = generate_random_date(2020, 2022)
    endDate = generate_random_date(2023, 2024)
    return f"0 {projectName},{mentorName},{memberCount},{memberNames},{startDate},{endDate},{bonusPoints:.2f}"

# 生成学术论文成果信息
def generate_academic_paper(current_student_name):
    paperName = f"论文{random.randint(1, 100)}"
    authors = [current_student_name] + random.sample([name for name in names if name != current_student_name], random.randint(0, 2))  # 确保包含当前学生
    authorCount = len(authors)
    authorNames = "、".join(authors)
    journalOrConferenceName = f"会议/期刊{random.randint(1, 50)}"
    publicationDate = generate_random_date(2020, 2023)
    paperNumber = f"NO{random.randint(1000, 9999)}"
    volumeIssue = f"Vol{random.randint(1, 10)}.Issue{random.randint(1, 4)}"
    pageRange = f"{random.randint(1, 100)}-{random.randint(101, 200)}"
    paperLevel = random.choice(list(paperLevel_to_bonusPoints.keys()))
    bonusPoints = paperLevel_to_bonusPoints[paperLevel]
    return f"1 {paperName} {authorCount} {authorNames} {journalOrConferenceName} {publicationDate} {paperNumber} {volumeIssue} {pageRange} {paperLevel} {bonusPoints:.2f}"

# 生成竞赛获奖信息
def generate_competition_award(current_student_name, CompetitionID):
    competitionName, competitionLevel = random.choice(competitions)
    organizer = f"主办单位{random.randint(1, 50)}"
    awardees = [current_student_name] + random.sample([name for name in names if name != current_student_name], random.randint(0, 4))  # 确保包含当前学生
    awardeeCount = len(awardees)
    awardeeNames = "、".join(awardees)
    awardLevel = random.choice(["国家级金奖", "国家级一等奖", "国家级银奖", "国家级二等奖", "国家级铜奖", "国家级三等奖"])
    awardDate = generate_random_date(2020, 2023)
    if awardLevel in ["国家级金奖", "国家级一等奖"] and competitionLevel == "A":
        base_bonusPoints = 0.4
    elif awardLevel in ["国家级银奖", "国家级二等奖"] or (awardLevel in ["国家级金奖", "国家级一等奖"] and competitionLevel == "B"):
        base_bonusPoints = 0.2
    elif awardLevel in ["国家级铜奖", "国家级三等奖"] or (awardLevel in ["国家级银奖", "国家级二等奖"] and competitionLevel == "B") or (awardLevel in ["国家级金奖", "国家级一等奖"] and competitionLevel == "C"):
        base_bonusPoints = 0.1
    elif awardLevel in ["国家级铜奖", "国家级三等奖"] and competitionLevel in ["B", "C"]:
        base_bonusPoints = 0.05
    elif awardLevel in ["国家级铜奖", "国家级三等奖"] and competitionLevel == "C":
        base_bonusPoints = 0.02
    else:
        base_bonusPoints = 0  # 默认值
    
    # 特殊竞赛减半逻辑
    special_competitions = [
        "ACM-ICPC国际大学生程序设计竞赛", "中国大学生服务外包创新创业大赛", "中国高校计算机大赛（大数据挑战赛、*团体程序设计天梯赛、*移动应用创新赛、*网络技术挑战赛、*人工智能创意赛）", "CCSP大学生计算机系统与程序设计竞赛",
        "全国大学生物联网设计竞赛", "CCSP大学生计算机系统与程序设计竞赛(CCSP，The College Computer Systems & Programming Contest)", "全国大学生信息安全竞赛（信息安全作品赛；创新实践能力赛）", "全国大学生信息安全竞赛（信息安全作品赛；创新实践能力赛）",
        "中国高校计算机大赛（团体程序设计天梯赛，移动应用创新赛，网络技术挑战赛，人工智能创意赛，微信小程序开发赛）", "全国大学生数学建模竞赛",
        "美国大学生数学建模竞赛", "全国高校密码数学挑战赛", "全国大学生数学竞赛"
    ]
    if competitionName not in special_competitions:
        bonusPoints = base_bonusPoints / 2
    else:
        bonusPoints = base_bonusPoints

    return f"2 {CompetitionID} {competitionName} {competitionLevel} {organizer} {awardeeCount} {awardeeNames} {awardLevel} {awardDate} {bonusPoints:.2f}"

def generate_user():
    usr_file = open("user.txt","w",encoding="utf-8")
    usr_file.write("0,管理员,21232f297a57a5a743894a0e4a801fc3,3,0\n")
    sid = []
    tid = []
    teacher_idx = 1
    for _ in range(10):
        name = random.choice(names)
        usr_file.write(f"{teacher_idx},{name},{hashlib.md5(str(teacher_idx).encode()).hexdigest()},2,0\n")
        teacher_idx += 1
        tid.append(teacher_idx)
    for _ in range(60):
        name = random.choice(names)
        college, major = random.choice(colleges)
        student_id = generate_unique_student_id(college)
        usr_file.write(f"{student_id},{name},{hashlib.md5(student_id.encode()).hexdigest()},1,{student_id[:2]}\n")
        sid.append(student_id)
    usr_file.close()
    return sid,tid
# 主函数
def main():
    student,teacher = generate_user()
    generate_score(student,teacher)
    # for _ in range(100):
    #     name = random.choice(names)
    #     college, major = random.choice(colleges)
    #     student_id = generate_unique_student_id(college)
    #     grade, class_num = parse_grade_class(student_id)
    #     student_info = f"{student_id} {name} {grade} {class_num} {college} {major}"
    #     print(student_info)
    #     r = generate_academic_record() for _ in range(10)
    #     competition_id_counter = 1
    #     quality_projects = []
    #     for _ in range(2):
    #         project_type = random.choice([generate_research_outcome, generate_academic_paper, generate_competition_award])
    #         if project_type == generate_competition_award:
    #             quality_projects.append(project_type(name, competition_id_counter))
    #             competition_id_counter += 1
    #         else:
    #             quality_projects.append(project_type(name))
    #     quality_projects = " ".join(quality_projects)
    #
    #     full_record = f"{student_info} | {academic_records} | {quality_projects} |"
    #     students_data.append(full_record)
    
    # 写入到文件
    # with open("data.txt", "w", encoding="utf-8") as file:
    #     for record in students_data:
    #         file.write(record + "\n")
    #     file.write("!")

main()
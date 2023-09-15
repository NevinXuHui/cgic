[[000 Home]]

# Planning&Review | 计划与复盘
*这里是关于存量的一切，是现状，是计划，是展望*

**DAILY SUMMARY**
```dataviewjs

function isWithinWeek(page) {	
	
	let filemoment = moment(page.file.name, 'YYYY年MM月DD日')
	let today = moment().startOf('day');
	let tomorrow = today.clone().add(1, 'days').startOf('day');
	let weekago = today.clone().subtract(7, 'days').startOf('day');

	// 如果在本周里，且有总结
	if (filemoment.isAfter(weekago) && filemoment.isBefore(tomorrow)) { if (page.总结) { return true; } }
	else return false;

 }


dv.table(["Date","Summary"], dv.pages('"journals"')
	.filter(isWithinWeek)
	.sort(b => b.file.name,'desc')
	.map(b =>[dv.fileLink(b.file.name, false, moment(b.file.name,'YYYY年MM月DD日').format("ddd")),"<span id='summary1'>"+b.总结+"</span>"])
	)
```

### 今年
- [[2023 - 年度大事件]]
- [[2023 - 年度关键词]]
- [[2023|2023 - 年度计划]]
- [[2023 - 自我对话]]
  
---
### 往年
#### 2022
- [[2022 - 年度大事件]]
- [[2022 - 年度关键词]]
- [[2022|2022 - 年度计划]]
- [[2022 - 自我对话]]
---
Link: [[050 Reporting System·报告系统 MOC]]
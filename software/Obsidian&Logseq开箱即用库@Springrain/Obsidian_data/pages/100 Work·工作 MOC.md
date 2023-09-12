[[000 Home]]

# Working | 工作
*这里是关于工作的一切，工作不是用时间和劳动力来换钱，而是用时间产品，工作要能对个人成长提供价值，而不仅仅是活着，因此金钱不是衡量工作的唯一标准，工作的价值衡量要与个人的价值观相符合*

## 库内代码
```dataviewjs
let excludeFolderChoicePath = "template"

dv.table(["名称","语言","框架","简述","创建时间"], dv.pages('#code_snippet')
	.filter(b => !b.file.path.includes(excludeFolderChoicePath))
	.sort(b => b.file.ctime,'desc')
	.map(b =>[dv.fileLink(b.file.name, false, b.代码名称),b.语言,b.框架, b.简述, b.file.cday])
	)
```
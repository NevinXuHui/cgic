---
url: https://blog.csdn.net/shanghaibao123/article/details/46005873
title: Android 添加 onKeyLongPress 事件_当走的路甚远的博客 - CSDN 博客
date: 2023-05-19 10:25:32
tag: 
banner: "undefined"
banner_icon: 🔖
---
在应用开发当中，有的时候需要捕捉按键的长按事件，从 android2.0 开始，activity 当中就包含 public 方法 boolean onKeyLongPress(int keyCode, KeyEvent event)；按照正常的开发流程，为了响应 onKeyLongPress 事件，我们需要重载 onKeyLongPress() 方法，测试发现 onKeyLongPress 并不能被正常的调用，为何？

经过查看 android api 才发现，为了能让系统调用 onKeyLongPress 方法，我们必须要在 onKeyDown 方法中调用 event.startTracking() 方法并返回 true 才可以。

接下来，我们就可以添加长按事件的业务代码了。

**[Android](http://www.2cto.com/kf/yidong/Android/) 获取长按按键响应**  

Android 项目中有不少地方需要对按键的长按操作进行 响应；例如长按物理菜单按键 / 音量上下按键等。

在 Activity 以及 View 中均有一个方法 onKeyLongPress()；但重载该方法之后，并不能对长按操作进行响应。

onKeyLongPress() 方法：  

```
	public boolean onKeyLongPress(int keyCode, KeyEvent event) {
		// TODO Auto-generated method stub
		return super.onKeyLongPress(keyCode, event);
	}
```

不能正常响应的原因：

onKeyDown() 中没有对短按，长按事件进行识别。如要对长按事件进行响应，要在 onKeyDown() 中添加如下代码：

```
	  if (event.getRepeatCount() == 0) {
	       	event.startTracking();
	    	isLongPressKey = false;
	  }else{
	       	isLongPressKey = true;
	  }
```

onKeyDown() 代码示例如下：

```
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		// TODO Auto-generated method stub
		Log.d(TAG,"---->>onKeyDown():keyCode="+keyCode);
		switch(keyCode){
		     case KeyEvent.KEYCODE_MENU://需要识别长按事件
		     case KeyEvent.KEYCODE_ENTER:
		     case KeyEvent.KEYCODE_DPAD_CENTER: 
       			if (event.getRepeatCount() == 0) {//识别长按短按的代码
       				event.startTracking();
    				isLongPressKey = false;
       			}else{
       				isLongPressKey = true;
       			}
		    	 return true;
		     case KeyEvent.KEYCODE_VOLUME_UP:
		     case KeyEvent.KEYCODE_DPAD_UP: 	    	 
 
		    	 return true;
		     case KeyEvent.KEYCODE_VOLUME_DOWN:
		     case KeyEvent.KEYCODE_DPAD_DOWN: 
 
		    	 return true;
		}
		return super.onKeyDown(keyCode, event);
	}
```

要处理 onKeyLongPress 和 onKeyUp 的冲突事件

1、添加变量

```
	private boolean lockLongPressKey;//是否长按

```

2、在 onKeyLongPress 中

```
	public boolean onKeyLongPress(int keyCode, KeyEvent event) {
		// TODO Auto-generated method stub
		lockLongPressKey = true;
		return super.onKeyLongPress(keyCode, event);
	}
```

3、在 onKeyUp() 中要添加冲突处理，如下：

```
	public boolean onKeyUp(int keyCode, KeyEvent event) {
		// TODO Auto-generated method stub
		Log.d(TAG,"---->> onKeyDown():keyCode="+keyCode);
		switch(keyCode){
		     case KeyEvent.KEYCODE_MENU:
		     case KeyEvent.KEYCODE_ENTER:
		     case KeyEvent.KEYCODE_DPAD_CENTER: 
		 	if(lockLongPressKey){
				lockLongPressKey = false;
				return true;
			}
 
		    	return true;
		     case KeyEvent.KEYCODE_VOLUME_UP:
		     case KeyEvent.KEYCODE_DPAD_UP: 		    	 
 
		    	 return true;
		     case KeyEvent.KEYCODE_VOLUME_DOWN:
		     case KeyEvent.KEYCODE_DPAD_DOWN: 
 
		    	 return true;
		}
		return super.onKeyUp(keyCode, event);
	}
```

注意问题：

添加长按响应以后要在 onKeyUp() 中添加长按冲突处理，否则长按事件和 UP 事件响应会同时起作用。
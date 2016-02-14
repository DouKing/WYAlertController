# WYAlertController

### `WYAlertController`是干什么的
统一系统控件`UIAlertView`、`UIActionSheet`、`UIAlertController`，解决`UIAlertController`无法在iOS8以下使用的问题。

### 如何使用
- 手动导入:
  - 将`WYAlertController`文件夹拖拽到项目中
  - 导入头文件`#import "WYAlertController"`
  
- 使用Cocoapod安装: 在`Podfile`文件中加入一行`pod 'WYAlertController', '~> 0.0.1'`

### 封装逻辑

参考系统控件`UIAlertController`的API，将`UIAlertView`、`UIActionSheet`、`UIAlertController`封装到一起。iOS8以上会调用`UIAlertController`，以下会调用`UIAlerView`或者`UIActionSheet`。

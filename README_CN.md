<p align="center">
<img src="./design/image/logo.png" width="1000" height="250"/>
</p>

# MagiEye

[![CI Status](https://img.shields.io/travis/AnRanScheme/MagiEye.svg?style=flat)](https://travis-ci.org/AnRanScheme/MagiEye)
[![Version](https://img.shields.io/cocoapods/v/MagiEye.svg?style=flat)](https://cocoapods.org/pods/MagiEye)
[![License](https://img.shields.io/cocoapods/l/MagiEye.svg?style=flat)](https://cocoapods.org/pods/MagiEye)
[![Platform](https://img.shields.io/cocoapods/p/MagiEye.svg?style=flat)](https://cocoapods.org/pods/MagiEye)


Automaticly display Log,Crash,Network,ANR,Leak,CPU,RAM,FPS,NetFlow,Folder and etc with one line of code based on Swift. Just like God opened his eyes.

**[ENGLISH README](./README.md)**

为了尽量复用代码，这个项目中的某些组件之间有比较强的依赖关系。为了方便其他开发者使用，我从中拆分出以下独立组件:

* [Log4G](https://github.com/zixun/Log4G) — Simple, lightweight logging framework written in Swift.
* [AssistiveButton](https://github.com/zixun/AssistiveButton) — Simple Assistive Button.
* [AppBaseKit](https://github.com/zixun/AppBaseKit) — A handy kit of Swift extensions and wrapped class to boost your productivity.
* [AppSwizzle](https://github.com/zixun/AppSwizzle) — lightweight and flexible method swizzling wrapped by swift.
* [LeakEye](https://github.com/zixun/LeakEye) — LeakEye is a memory leak monitor.
* [NetworkEye](https://github.com/zixun/NetworkEye) — NetworkEye is a network monitor,automatic catch the request and response infomation of all kinds of request send.
* [ANREye](https://github.com/zixun/ANREye) — ANREye is an ANR (Application Not Responding) monitor,automatic catch the ANR and return stacktrace of all threads.
* [ASLEye](https://github.com/zixun/ASLEye) — ASLEye is an ASL(Apple System Log) monitor, automatic catch the log from NSLog by asl module.
* [CrashEye](https://github.com/zixun/CrashEye) — CrashEye is an ios crash monitor，automatic catch exception crash & signal crash and return the stacktrace.
* [SystemEye](https://github.com/zixun/SystemEye) — SystemEye is a system monitor,automatic catch the infomation of cpu,memory....etc.

## 功能

- [x] 监控日志并区分日志类型.
- [x] 监控崩溃, 包括Uncatched Exception和Signal崩溃.
- [x] 监控网络, 包括请求和响应的所有信息.
- [x] 监控卡顿, 并告诉你卡顿时候的所有线程的堆栈.
- [x] 监控内存泄露, 告诉你泄露的对象的类名.
- [x] 提供一个可以自定义指令和输出的控制台.
- [x] 监控系统和应用自身的CPU使用率.
- [x] 监控系统与应用自身的内存使用率.
- [x] 监控帧率FPS.
- [x] 监控系统和应用自身的网络流量. 
- [x] 提供一个文件浏览器可用于查看沙盒，.app 以及系统根目录的文件.
- [x] 运行时自定义设置

## 特点

- [x] 丰富: 功能全面
- [x] 方便: 一行代码接入
- [x] 自动: 零代码入侵
- [x] 安全: Release包可不打入一行代码


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MagiEye is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MagiEye'
```

## Author

AnRanScheme, 541437674@qq.com

## License

MagiEye is available under the MIT license. See the LICENSE file for more info.

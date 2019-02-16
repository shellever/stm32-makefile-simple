
README: [English](https://github.com/shellever/stm32-makefile-simple/blob/master/README.md) | [中文](https://github.com/shellever/stm32-makefile-simple/blob/master/README_zh.md)

Supported chip: STM32F103C8T6

## 目录说明
```
cmsis       - cortex-m3内核相关(启动脚本，链接脚本等)
firmware    - stm32f10x固件库
hardware    - 板子外设驱动库(led)
system      - 系统相关函数
user        - 用户应用程序
```

## 编译stm32工程
```
$ make
```

## 清理中间文件
```
$ make clean
or
$ make distclean
```

## 烧写bin文件 (使用stlink工具进行烧写)
```
$ make burn
```

## 参考文章
[Ubuntu下使用Makefile开发STM32（合集）](http://www.stmcu.org.cn/module/forum/thread-603753-1-1.html)

[stlink](https://github.com/texane/stlink)


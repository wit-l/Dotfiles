## Install

winget install --id=chrisant996.Clink -e

## 配置文件

%LocalAppData%\clink\starship.lua中写入：

```lua
load(io.popen('starship init cmd'):read("*a"))()
```

## 让clink使用starship命令

```cmd
clink config prompt use starship
```

## clink切换快捷键风格为bash命令

```cmd
clink set clink.default_bindings bash
```

## 启动clink自动建议 (Auto-Suggestions)

```cmd
clink set autosuggest.enable true
```

## 让clink根据历史命令生成自动建议规则

```cmd
clink set autosuggest.strategy history completion
```

## 让clink在命令行行内显示建议

```cmd
clink set autosuggest.inline true
```

# clink安装与配置

## Install

```cmd
winget install --id=chrisant996.Clink -e
```

## 让 clink 使用 starship 提示符

安装 Starship 后执行（会写入 `clink.customprompt`，加载 Clink 自带的 `starship.clinkprompt`）：

```cmd
clink config prompt use starship
```

不要再创建 `%LocalAppData%\clink\starship.lua`；旧写法与 `.clinkprompt` 重复，可能造成提示符异常。

若 `starship.exe` 不在 `PATH` 中：

```cmd
clink set starship.exepath "完整路径\starship.exe"
```

## clink切换快捷键风格为bash命令

```cmd
clink set clink.default_bindings bash
```

## 启动clink自动建议 (Auto-Suggestions)（默认）

```cmd
clink set autosuggest.enable true
```

## 让clink根据历史命令生成自动建议规则（默认）

```cmd
clink set autosuggest.strategy match_prev_cmd history completion
```

## 让clink在命令行行内显示建议

```cmd
clink set autosuggest.inline true
```

## 关闭启动cmd时的clink信息输出

```cmd
clink set clink.logo none
```

## 自定义脚本（放到 `%LocalAppData%\clink\`）

别名与函数分目录存放；根目录的 `load_custom.lua` 负责加载（Clink 不会递归扫描子目录）。

```
clink/
  load_custom.lua          # 加载器
  aliases/
    aliases.lua            # doskey 别名（含 spr/gpr/cpr/elt/dlt）
  functions/
    register_cmds.lua      # Lua 命令着色/补全注册
    fnm.lua                # fnm env --use-on-cd --version-file-strategy=recursive + onbeginedit
    path_linux.lua         # enable-linux-tools / disable-linux-tools
    utils.lua              # mkcd / which / rm
    proxy.lua              # proxy_on / proxy_off / proxy_status
```

```cmd
mkcd mydir
rm file.txt
rm -r dir
rm -rf dir
which spr
which set-proxy
proxy_on
proxy_on http://127.0.0.1:7890
spr
proxy_status
gpr
proxy_off
cpr
elt
dlt
```

## 配置 `z.lua`

### 将 `%LocalAppData%\clink` 加入环境变量 `PATH`

### 克隆 `https://github.com/skywind3000/z.lua` 仓库到本地

### 将 `z.lua` 和 `z.cmd` 移至 `%LocalAppData%\clink` 下

## 启用快捷键 `ctrl` + `d` 退出

```cmd
clink set cmd.ctrld_exits true
```

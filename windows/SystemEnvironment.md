# 系统环境变量

## 手动添加部分（不指明情况下默认用户变量）

### 配置仓库路径

```cmd
// 系统变量
DOTDIR=%USERPROFILE%\Documents\dotfiles
```

### 默认编辑器

```cmd
// 系统变量
EDITOR=nvim
```

### Git 相关

```cmd
GIT=C:\Program Files\Git
GITHUB_TOKEN=ghp_***
```

### Komorebi 配置目录

```cmd
KOMOREBI_CONFIG_HOME=%DOTDIR%\windows\komorebi
```

### Miniforge 路径

```cmd
MINIFORGE=C:\Software\miniforge3
```

### fnm 版本文件查找策略（与 WSL 对齐；Clink / pwsh 共用）

```cmd
FNM_VERSION_FILE_STRATEGY=recursive
```

### Starship 配置文件

```cmd
STARSHIP_CONFIG=%DOTDIR%\windows\starship\starship.toml
```

### 默认C语言编译器

```cmd
CC=gcc
```

### Ollama

```cmd
OLLAMA_HOST=0.0.0.0:11434
OLLAMA_ORIGINS=*
```

### Java

```cmd
JAVA_HOME=%JAVA8%
JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8
JAVA8=C:\Program Files\Java\jdk1.8.0_202
```

### Clink 配置目录

```cmd
CLINK_PROFILE=%DOTDIR%\clink
```

## 自动添加部分

### pnpm 路径

```cmd
PNPM_HOME=C:\Users\witty\AppData\Local\pnpm （pnpm setup）
```

### Clink 安装目录

```cmd
CLINK_DIR=C:\Program Files (x86)\clink （clink安装程序）
```

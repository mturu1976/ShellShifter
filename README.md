# ShellShifter

ShellShifter は Powershell から容易に他のシェルを容易に呼び出す事が出来る PowerShell モジュールです。

# Description

コマンドラインで他の各種コマンドを使いたい時、実行ファイルが環境変数 Path に含まれている必要がありますが、
Windows では多様な bash が存在し諸々衝突するので必要に応じて専用の起動用バッチファイルを実行する事になります。
これらのバッチファイルは残念な事にコマンドライン操作をし続けるような用途には向いていません。

ShellShifter はシェルへのエリアスのように動作しコマンドラインから容易にシェルを呼び出すことが可能になります。

## Usage

```
cmd32 /c 'dir'
cmd64 /c 'dir'
posh32 -c 'dir'
posh64 -c 'dir'
msys -c 'ls'
mingw32 -c 'ls'
mingw64 -c 'ls'
cygwin -c 'ls'
gitbash -c 'ls'
```

## Support Shells

- Cmd (x86, x64)
- PowerShell (x86, x64)
- [Bash on Ubuntu on Windows](https://msdn.microsoft.com/commandline/wsl/about) / Bash
- [Cygwin](https://cygwin.com/) / Bash 
- [Msys2](http://www.msys2.org/) / Bash
- [GitBash](https://git-for-windows.github.io/) / Bash

# License

[MIT License](https://github.com/m5knt/ShellShifter/blob/master/LICENSE) (C) Yukio 'm5knt' KANEDA

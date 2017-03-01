# ShellShifter

ShellShifter は Powershell から容易に他のシェルを容易に呼び出す事が出来る PowerShell モジュールです。

# Description

コマンドラインで他の各種コマンドを使いたい時、実行ファイルが環境変数 Path に含まれている必要がありますが、
Windows では多様な bash が存在し諸々衝突するので必要に応じて専用の起動用バッチファイルを実行する事になります。
これらのバッチファイルは残念な事にコマンドライン操作をし続けるような用途には向いていません。

ShellShifter はシェルへのエリアスのように動作しコマンドラインから容易にシェルを呼び出すことが可能になります。

## Usage

コマンドラインから次のように呼び出す事が出来ます。

```
>msys

>msys -c 'ls'
```

Explorer のアドレス入力などコマンドを受け付ける所で powershell -c 'msys' 等で呼び出すことができます。

## Support Shells

| Shells                          | Command | SeeAlso |
|---------------------------------|---------|---------|
| Cmd (x86)                       | cmd32   | |
| Cmd (x64)                       | cmd64   | |
| Powershell (x86)                | posh32  | |
| Powershell (x64)                | posh64  | |
| Bash on Ubuntu On Windows (WSL) | bow     | https://msdn.microsoft.com/commandline/wsl/about |
| Msys2                           | msys    | http://www.msys2.org/ |
| Msys2 (Mingw32)                 | mingw32 | |
| Msys2 (Mingw64)                 | mingw64 | |
| Git for Windows (GitBash)       | gitbash | https://git-for-windows.github.io/ |
| Cygwin                          | cygwin  | https://cygwin.com/ |
| | |

# License

[MIT License](https://github.com/m5knt/ShellShifter/blob/master/LICENSE) (C) Yukio "m5knt" KANEDA

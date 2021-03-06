﻿#
# モジュール 'ShellSwitch' のモジュール マニフェスト
#
# 生成者: Yukio Kaneda
#
# 生成日: 2016/12/08
#

@{

# このマニフェストに関連付けられているスクリプト モジュール ファイルまたはバイナリ モジュール ファイル。
RootModule = 'ShellShifter.psm1'

# このモジュールのバージョン番号です。
ModuleVersion = '0.0.1'

# サポートされている PSEditions
# CompatiblePSEditions = @()

# このモジュールを一意に識別するために使用される ID
GUID = '4ed9b2db-d742-408f-b11a-405ccd860557'

# このモジュールの作成者
Author = 'Yukio Kaneda'

# このモジュールの会社またはベンダー
CompanyName = '--'

# このモジュールの著作権情報
Copyright = 'Yukio Kaneda.'

# このモジュールの機能の説明
Description = 'invoke specific shells'

# このモジュールに必要な Windows PowerShell エンジンの最小バージョン
PowerShellVersion = '5.0'

# このモジュールに必要な Windows PowerShell ホストの名前
# PowerShellHostName = ''

# このモジュールに必要な Windows PowerShell ホストの最小バージョン
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# このモジュールに必要なプロセッサ アーキテクチャ (なし、X86、Amd64)
# ProcessorArchitecture = ''

# このモジュールをインポートする前にグローバル環境にインポートされている必要があるモジュール
# RequiredModules = @()

# このモジュールをインポートする前に読み込まれている必要があるアセンブリ
# RequiredAssemblies = @()

# このモジュールをインポートする前に呼び出し元の環境で実行されるスクリプト ファイル (.ps1)。
# ScriptsToProcess = @()

# このモジュールをインポートするときに読み込まれる型ファイル (.ps1xml)
# TypesToProcess = @()

# このモジュールをインポートするときに読み込まれる書式ファイル (.ps1xml)
# FormatsToProcess = @()

# RootModule/ModuleToProcess に指定されているモジュールの入れ子になったモジュールとしてインポートするモジュール
# NestedModules = @()

# このモジュールからエクスポートする関数です。最適なパフォーマンスを得るには、ワイルドカードを使用せず、エクスポートする関数がない場合は、エントリを削除しないで空の配列を使用してください。
FunctionsToExport = @(
    'Get-ShellShifter'
    # 'Get-PowerShell'
    # 'Get-Cmd'  
    # 'Get-Cygwin'
    # 'Get-Msys'

    'Invoke-PowerShell32', 'Invoke-PowerShell64'
    'Invoke-Cmd32', 'Invoke-Cmd64'
    'Invoke-BashOnWindows', 

    'Invoke-Msys', 'Invoke-MsysShell', 'Invoke-Mingw32', 'Invoke-Mingw64'
    'Invoke-GitBash'
    'Invoke-Cygwin'
    )

# このモジュールからエクスポートするコマンドレットです。最適なパフォーマンスを得るには、ワイルドカードを使用せず、エクスポートするコマンドレットがない場合は、エントリを削除しないで空の配列を使用してください。
CmdletsToExport = @()

# このモジュールからエクスポートする変数
VariablesToExport = '*'

# このモジュールからエクスポートするエイリアスです。最適なパフォーマンスを得るには、ワイルドカードを使用せず、エクスポートするエイリアスがない場合は、エントリを削除しないで空の配列を使用してください。
AliasesToExport = @(
    'posh32', 'posh64', 'admin'
    'cmd32', 'cmd64'
    'bow'

    'msys', 'mingw32', 'mingw64'
    'gitbash'

    'cygwin'
    )

# このモジュールからエクスポートする DSC リソース
# DscResourcesToExport = @()

# このモジュールに同梱されているすべてのモジュールのリスト
# ModuleList = @()

# このモジュールに同梱されているすべてのファイルのリスト
# FileList = @()

# RootModule/ModuleToProcess に指定されているモジュールに渡すプライベート データ。これには、PowerShell で使用される追加のモジュール メタデータを含む PSData ハッシュテーブルが含まれる場合もあります。
PrivateData = @{

    PSData = @{

        # このモジュールに適用されているタグ。オンライン ギャラリーでモジュールを検出する際に役立ちます。
        Tags = @('bash', 'msys', 'msys2', 'mingw', 'cygwin')

        # このモジュールのライセンスの URL。
        LicenseUri = 'https://github.com/m5knt/ShellShifter/blob/master/LICENSE'

        # このプロジェクトのメイン Web サイトの URL。
        ProjectUri = 'https://github.com/m5knt/ShellShifter'

        # このモジュールを表すアイコンの URL。
        # IconUri = ''

        # このモジュールの ReleaseNotes
        # ReleaseNotes = ''

    } # PSData ハッシュテーブル終了

} # PrivateData ハッシュテーブル終了

# このモジュールの HelpInfo URI
# HelpInfoURI = ''

# このモジュールからエクスポートされたコマンドの既定のプレフィックス。既定のプレフィックスをオーバーライドする場合は、Import-Module -Prefix を使用します。
# DefaultCommandPrefix = ''

}


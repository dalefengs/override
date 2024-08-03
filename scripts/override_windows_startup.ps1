# 获取当前目录
$scriptDir = Get-Location
$workDir = Split-Path -Path $scriptDir -Parent

# 配置文件的路径
$configFilePath = Join-Path $workDir "config.json"

try {
    Write-Output "Current Working Directory $workDir"
    Write-Output "Use config path $configFilePath `n`n"

    # 设置批处理文件的路径和内容
    $batFilePath = [System.IO.Path]::Combine($env:APPDATA, "Microsoft\Windows\Start Menu\Programs\Startup", "override.vbs")

    # 设置 VBS 脚本的内容
    $batContent = @"
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run """$workDir\override.exe"" -c ""$configFilePath""", 0, False
"@

    # 创建批处理文件并写入内容
    Set-Content -Path $batFilePath -Value $batContent -Force

    Write-Output "Setup complete. override.exe will run at startup with configuration from $configFilePath."

    # 执行 VBS 脚本
    Start-Process -FilePath $batFilePath

    Write-Output "Backend start override succeeded. `n"
}
catch {
    Write-Error "`nAn error occurred: $_"
    Read-Host -Prompt "Press Enter to exit"
}

# 暂停，等待用户按任意键
Read-Host -Prompt "Press Enter to exit"

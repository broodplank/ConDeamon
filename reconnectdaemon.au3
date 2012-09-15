#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=csgoicon.ico
#AutoIt3Wrapper_Outfile=ConDeamon.exe
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_Description=Reconnect Daemon
#AutoIt3Wrapper_Res_Fileversion=1.0.0.2
#AutoIt3Wrapper_Res_LegalCopyright=Copyright 2012 broodplank.net
#AutoIt3Wrapper_Run_Obfuscator=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

$skipcheck = 0
For $i = 1 to $CmdLine[0]
 If $CmdLine[$i] = "/skipcheck" Then $skipcheck= 1
Next
If $skipcheck = 0 Then
Endif

#include <Misc.au3>
#include <Process.au3>

Local $hDLL = DllOpen("user32.dll")
$getdir = RegRead("HKEY_CURRENT_USER\Software\Valve\Steam", "SteamPath")
$newdir = $getdir&"/steamapps/common/Counter-Strike Global Offensive"
$gamedir = $newdir&"/csgo"


Func _checkinstallation()
	if $getdir = "" Then
		ConsoleWrite(@CRLF&"A valid Steam installation has not been found! Exiting."&@CRLF)
		sleep(3000)
		Exit
	Else
		ConsoleWrite(@CRLF&"A valid Steam installation has beend found! Checking for CS:GO Installation..."&@CRLF)
		If FileExists($newdir&"\csgo.exe") = 1 then
			ConsoleWrite("CS:GO Installation has been found!, starting ConDeamon..."&@CRLF)
		Else
			ConsoleWrite("CS:GO Installation has not been found!, Exiting ConDeamon..."&@CRLF)
			sleep(3000)
			Exit
		EndIf
EndIf
EndFunc

ConsoleWrite("************************************"&@CRLF)
ConsoleWrite("***   -   Reconnect Deamon   -   ***"&@CRLF)
ConsoleWrite("***   -   v1.0.0.2           -   ***"&@CRLF)
ConsoleWrite("***   -   www.broodplank.net -   ***"&@CRLF)
ConsoleWrite("************************************"&@CRLF)
$title = WinGetTitle("[active]")
WinSetTitle($title, "", "Reconnect Deamon - by broodplank")

_checkinstallation()

if $skipcheck = 0 then
	if ProcessExists("csgo.exe") Then
		ConsoleWrite(@CRLF&"CS:GO is running, proceeding..."&@CRLF)
	Else
		ConsoleWrite(@CRLF&"CS:GO is not running, press enter to start it now or press escape to skip"&@CRLF)
	EndIf
		While 1
		If _IsPressed("0D", $hDLL) Then
			ConsoleWrite("Launching CS:GO..." & @CRLF&@CRLF)
			_RunDos("start steam://run/730")
			ExitLoop
			While _IsPressed("0D", $hDLL)
				Sleep(20)
			WEnd
		ElseIf _IsPressed("1B", $hDLL) Then
			ConsoleWrite("Skip..."&@CRLF&@CRLF)
			ExitLoop
		EndIf
	WEnd
Else
	;
EndIf

ConsoleWrite(@CRLF&"************************************"&@CRLF)
ConsoleWrite("*** Reconnect Deamon Initialized ***"&@CRLF)
ConsoleWrite("************************************"&@CRLF)

ConsoleWrite("Cleaning..."&@CRLF)
ConsoleWrite("- Deleting old condumps.."&@CRLF)
For $i = 0 To 9
	FileDelete($gamedir & "\condump00" & $i & ".txt")
	FileDelete($gamedir & "\condump01" & $i & ".txt")
Next
ConsoleWrite("- Deleting connect.cfg.."&@CRLF)
If FileExists($gamedir & "\cfg\connect.cfg") Then FileDelete($gamedir & "\cfg\connect.cfg")
ConsoleWrite("Done!"&@CRLF&@CRLF)

ConsoleWrite(@CRLF&"************************************"&@CRLF)
ConsoleWrite("***   Reconnect Deamon Running   ***"&@CRLF)
ConsoleWrite("************************************"&@CRLF)
ConsoleWrite("Waiting for first condump..."&@CRLF)
While 1
	AutoItWinSetTitle("ConDaemon")
	Sleep(10)

	If FileExists($gamedir & "\condump000.txt") Then
		ConsoleWrite("- Condump found!"&@CRLF)
		$readline = FileReadLine($gamedir & "\condump000.txt", 2)
		$ip = StringMid($readline, 13, 21) ; max lenght of ip + port string = 18 chars (255.255.255.255:27015)
		ConsoleWrite("- Extracting IP..."&@CRLF)
		If FileExists($gamedir & "\cfg\connect.cfg") Then FileDelete($gamedir & "\cfg\connect.cfg")
		If $ip = "" Then
			;
		Else
			FileWrite($gamedir & "\cfg\connect.cfg", "connect" & $ip)
			ConsoleWrite("- Saving to file..."&@CRLF)
		EndIf
		FileDelete($gamedir & "\condump000.txt")
		ConsoleWrite("- Deleting condump"&@CRLF)
	EndIf

WEnd
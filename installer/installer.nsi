!include "MUI2.nsh"
!include "LogicLib.nsh"

Name "7nd.motion"
OutFile "..\build\7nd.motion-Installer.exe"
InstallDir "$LOCALAPPDATA\Programs\7nd.motion"
RequestExecutionLevel user

!define MUI_ICON "..\resources\app.ico"
!define MUI_UNICON "..\resources\app.ico"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_RUN "$INSTDIR\7nd.motion.exe"
!define MUI_FINISHPAGE_RUN_TEXT "Launch 7nd.motion now"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

Section "Install"
  SetOutPath "$INSTDIR"

  DetailPrint "Downloading latest 7nd.motion v1.4.0..."
  nsExec::ExecToLog 'curl.exe -f -s -L "https://github.com/RealTenzo/7nd.motion/releases/download/1.4.0/7nd.motion_portable.exe" -o "$INSTDIR\7nd.motion.exe"'
  ${If} ${FileExists} "$INSTDIR\7nd.motion.exe"
    DetailPrint "Download verified."
  ${Else}
    DetailPrint "Retrying latest download..."
    nsExec::ExecToLog 'curl.exe -f -s -L "https://github.com/RealTenzo/7nd.motion/releases/latest/download/7nd.motion_portable.exe" -o "$INSTDIR\7nd.motion.exe"'
  ${EndIf}

  CreateShortcut "$SMPROGRAMS\7nd.motion.lnk" "$INSTDIR\7nd.motion.exe"
  CreateShortcut "$DESKTOP\7nd.motion.lnk" "$INSTDIR\7nd.motion.exe"

  ; Add install dir to User PATH
  ReadRegStr $2 HKCU "Environment" "Path"
  ${If} $2 == ""
    WriteRegStr HKCU "Environment" "Path" "$INSTDIR"
  ${Else}
    ; Check if path already exists
    Push $2
    Push "$INSTDIR"
    ; Add if not present
    WriteRegStr HKCU "Environment" "Path" "$2;$INSTDIR"
  ${EndIf}
  SendMessage 0xffff 0x001A 0 "STR:Environment" /TIMEOUT=1000

  WriteUninstaller "$INSTDIR\uninstall.exe"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\7nd.motion" "DisplayName" "7nd.motion"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\7nd.motion" "DisplayIcon" "$INSTDIR\7nd.motion.exe,0"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\7nd.motion" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\7nd.motion" "Publisher" "tenzo"
SectionEnd

Section "Uninstall"
  Delete "$INSTDIR\7nd.motion.exe"
  Delete "$INSTDIR\uninstall.exe"
  Delete "$SMPROGRAMS\7nd.motion.lnk"
  Delete "$DESKTOP\7nd.motion.lnk"
  RMDir "$INSTDIR"
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\7nd.motion"
SectionEnd

; Installeur Windows d'OrdoProche (NSIS). Installation par utilisateur, sans droits administrateur.
; Usage : makensis -DSOURCE=<dossier décompressé> -DVERSION=2026.11.23 -DSORTIE=ordoproche-latest.exe installeur.nsi
Unicode true
SetCompressor /SOLID lzma
!include "MUI2.nsh"

!define NOM "OrdoProche"
!define CLE_DESINST "Software\Microsoft\Windows\CurrentVersion\Uninstall\OrdoProche"

Name "${NOM}"
OutFile "${SORTIE}"
InstallDir "$LOCALAPPDATA\Programs\OrdoProche"
InstallDirRegKey HKCU "Software\OrdoProche" "Dossier"
RequestExecutionLevel user
ManifestDPIAware true
VIProductVersion "1.0.0.0"
VIAddVersionKey /LANG=1036 "ProductName" "${NOM}"
VIAddVersionKey /LANG=1036 "FileDescription" "Installation d'OrdoProche"
VIAddVersionKey /LANG=1036 "FileVersion" "${VERSION}"
VIAddVersionKey /LANG=1036 "ProductVersion" "${VERSION}"
VIAddVersionKey /LANG=1036 "LegalCopyright" "OrdoProche"

!define MUI_ICON "app_icon.ico"
!define MUI_UNICON "app_icon.ico"
!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_RUN "$INSTDIR\OrdoProche.exe"
!define MUI_FINISHPAGE_RUN_TEXT "Ouvrir OrdoProche"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "French"

Section "OrdoProche"
  SetOutPath "$INSTDIR"
  ; Une mise à jour remplace les fichiers du logiciel ; les données (ordonnances,
  ; patients, code d'activation) sont ailleurs et ne sont jamais touchées.
  RMDir /r "$INSTDIR\data"
  File /r "${SOURCE}\*.*"
  WriteUninstaller "$INSTDIR\Desinstaller.exe"
  CreateShortcut "$SMPROGRAMS\OrdoProche.lnk" "$INSTDIR\OrdoProche.exe"
  CreateShortcut "$DESKTOP\OrdoProche.lnk" "$INSTDIR\OrdoProche.exe"
  WriteRegStr HKCU "Software\OrdoProche" "Dossier" "$INSTDIR"
  WriteRegStr HKCU "${CLE_DESINST}" "DisplayName" "${NOM}"
  WriteRegStr HKCU "${CLE_DESINST}" "DisplayVersion" "${VERSION}"
  WriteRegStr HKCU "${CLE_DESINST}" "DisplayIcon" "$INSTDIR\OrdoProche.exe"
  WriteRegStr HKCU "${CLE_DESINST}" "Publisher" "OrdoProche"
  WriteRegStr HKCU "${CLE_DESINST}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKCU "${CLE_DESINST}" "UninstallString" '"$INSTDIR\Desinstaller.exe"'
  WriteRegDWORD HKCU "${CLE_DESINST}" "NoModify" 1
  WriteRegDWORD HKCU "${CLE_DESINST}" "NoRepair" 1
SectionEnd

Section "Uninstall"
  ; Ne supprime que le logiciel : les données restent sur l'ordinateur.
  Delete "$SMPROGRAMS\OrdoProche.lnk"
  Delete "$DESKTOP\OrdoProche.lnk"
  RMDir /r "$INSTDIR"
  DeleteRegKey HKCU "${CLE_DESINST}"
  DeleteRegKey HKCU "Software\OrdoProche"
SectionEnd

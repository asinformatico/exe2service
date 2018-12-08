#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=service.ico
#AutoIt3Wrapper_Res_File_Add=instsrv.exe, rt_rcdata, instsrv
#AutoIt3Wrapper_Res_File_Add=srvany.exe, rt_rcdata, srvany
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "resources.au3"

_ResourceSaveToFile("instsrv.exe", "instsrv", $RT_RCDATA, 0, 1)
_ResourceSaveToFile("srvany.exe", "srvany", $RT_RCDATA, 0, 1)

#Region ### START Koda GUI section ###
$Form1 = GUICreate("Exe2Srv", 348, 228, 867, 448)
$crear = GUICtrlCreateButton("Crear Servicio", 24, 152, 99, 57)
$ruta = GUICtrlCreateInput("ruta", 24, 40, 305, 21)
$Label1 = GUICtrlCreateLabel("Ruta del Ejecutable:", 24, 16, 100, 17)
$Label2 = GUICtrlCreateLabel("Nombre del Servicio", 24, 88, 99, 17)
$nombre = GUICtrlCreateInput("servicio", 24, 112, 305, 21)
$ayuda = GUICtrlCreateButton("Acerca de", 232, 152, 99, 57)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $crear
			_crearservicio(GUICtrlRead($nombre),GUICtrlRead($ruta))
		Case $ayuda
			MsgBox(64,"Acerca de Exe2Srv","Convertir ejecutable común en un Servicio de Windows." & @CRLF & @CRLF & "INSTALACIÓN:" & @CRLF & "- Colocar este programa en la misma carpeta del exe a convertir antes de ejecutar." & @CRLF & "- Después del proceso no borrar de la carpeta el archivo srvany.exe o el servicio dejará de funcionar." )

	EndSwitch
WEnd

Func _crearservicio($servicio,$aplicacion)
	RunWait(@Comspec&" /c " & @ScriptDir & "\instsrv.exe " & $servicio & " " & @ScriptDir & "\srvany.exe", "", @SW_SHOW)
	If @error <> 0 Then
		MsgBox(16,"ERROR", "El servicio no ha sido creado. No se ha encontrado el .exe de creación.")
	EndIf
	Sleep(100)
	RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\" & $servicio & "\Parameters")
	RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\" & $servicio & "\Parameters", "Application", "REG_SZ", $aplicacion)
	Sleep(100)
	RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\" & $servicio & "\Parameters", "Application")
	If @error <> 0 Then
		MsgBox(16,"ERROR", "El servicio no ha sido creado. Error al acceder al Registro de Windows.")
	Else
		MsgBox(64,"Servicio Creado", "El servicio ha sido creado correctamente.")
	EndIf
	RunWait(@Comspec&" /c " & "net start " & $servicio, "", @SW_SHOW)
	If @error <> 0 Then
		MsgBox(16,"ERROR", "El servicio ha sido creado pero no ha podido iniciarse.")
	EndIf
EndFunc

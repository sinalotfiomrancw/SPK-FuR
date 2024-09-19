'-------------------------------------------------------------------------------------
' Title:		SK-FuR - Import Routine pre
' CIR:		SK-FuR - Import Routine
' Customer:	Sparkassen
' Created by:	AS
' Created on:	22.01.2021
' Version:		1.00
'-------------------------------------------------------------------------------------
' Decription:	
'-------------------------------------------------------------------------------------
' Files:		
'-------------------------------------------------------------------------------------
' Change History
'-------------------------------------------------------------------------------------
' Changed by:	
' Changed on:	
' Requested by:	
' Comment:		
'------------------
' Changed by:
' Changed on:
' Requested by:
' Comment:
'-------------------------------------------------------------------------------------

Option Explicit

' Constants for UniqueFileName and CreateResultObject functions
Const INPUT_DATABASE As Long = 1
Const INTERMEDIATE_RESULT As Long = 2
Const FINAL_RESULT As Long = 4

' Excecution status constants
Const EXEC_STATUS_FAILED As Long = 0
Const EXEC_STATUS_SUCCEEDED = 1
Const EXEC_STATUS_CANCELED As Long = 3

' Common SmartAnalyzer variables
Dim oSC As Object
Dim oMC As Object
Dim oTM As Object
Dim oLog As Object
Dim oProtectIP As Object
Dim oPara As Object

Dim sourceFileName As String

' IDEA standard variables
Dim db As Object
Dim dbName As String
Dim eqn As String
Dim task As Object
Dim field As Object

' Dialog Output User Mode
dim iUserMode as integer
dim bStandardUser as boolean
dim bExpertUser as boolean

' Dialog Output Parameters
dim sPrevGJAHR as string
Dim sGeschäftsjahr As String
dim sNichtausgriffsgrenze as string
dim sPfadOBR as string
dim sPfadUmsätze as string

' Dialoghandler
dim bParametersSet as boolean

' Error Logging
Dim lErrorNumber As Long
Dim sErrorDescripton As String
Dim lErrorLine As Long

Dim m_checkpointName As String

' Select Folder
'Dim oPageSettingsService As Object
'Dim oSelectAuditFolderPageSettings As Object

Sub Main
'On Error GoTo ErrorHandler
SetCheckpoint "Begin of Main"
	'IgnoreWarning (True)
	Set oLog = SmartContext.Log
	Set oMC = SmartContext.MacroCommands
	Set oSC = SmartContext.MacroCommands.SimpleCommands
	'Set oTM = SmartContext.MacroCommands.TagManagement
	Set oPara = SmartContext.MacroCommands.GlobalParameters

	'Set ExecutionStatus (failure at the beginning).
	SmartContext.ExecutionStatus =EXEC_STATUS_FAILED

	oLog.LogMessage "Import Routine Name: " & SmartContext.TestName
	oLog.LogMessage "Import Routine Version: " & SmartContext.TestVersion
	oLog.LogMessage "Execution Time Start: " & Now()
	
SetCheckpoint "Get Project Parameters"
oLog.LogMessage m_checkpointName
	sPrevGJAHR = oPara.Get4Project ("sGeschäftsjahr")
	bParametersSet = false
'-----------------------------------------------------------------------------------------
' Funtion Calls
'-----------------------------------------------------------------------------------------
SetCheckpoint "Begin of Functions"
	Call UserMode
	If bStandardUser = true And bExpertUser = false Then Call Parameters
	If bStandardUser = false And bExpertUser = true Then Call Parameters
	if bParametersSet = false then
		SmartContext.AbortImport = True
		SmartContext.Log.LogMessage "Es wurden keine Parameter gesetzt."
		oLog.LogMessage "Execution Time End: " & Now()
		Set oLog = Nothing
		Set oMC = Nothing
		Set oSC = Nothing
		Set oPara = Nothing
	end if
SetCheckpoint "End of Functions"
'-----------------------------------------------------------------------------------------
' End Funtion Calls
'-----------------------------------------------------------------------------------------
SetCheckpoint "Set Project Parameters"
oLog.LogMessage m_checkpointName

	oPara.Set4Project "sNichtausgriffsgrenze", sNichtausgriffsgrenze
	oPara.Set4Project "sGeschäftsjahr", sGeschäftsjahr
	oPara.Set4Project "sPfadOBR", sPfadOBR
	oPara.Set4Project "sPfadUmsätze", sPfadUmsätze
	
'	Set oPageSettingsService = SmartContext.GetServiceById("CirWizardPageSettingsService")
'	Set oSelectAuditFolderPageSettings = oPageSettingsService.GetCirWizardPageSettings("SelectAuditFolder")	
'	
'	If oSelectAuditFolderPageSettings is Nothing Then
'		SmartContext.Log.LogWarning "The settings object for the page SelectAuditFolder was not found."        
'	Else	
'		oSelectAuditFolderPageSettings.Enabled = true		
'		'oSelectAuditFolderPageSettings.Inputs.Add "PeriodStart", ""
'		'oSelectAuditFolderPageSettings.Inputs.Add "PeriodEnd", ""
'	End If
'	set oSelectAuditFolderPageSettings = Nothing   
'	set oPageSettingsService = Nothing

SetCheckpoint "User Message"
	msgbox "Ihr Auswahl wurde gespeichert." & Chr(13) & "Bitte klicken Sie auf Importieren, um die Aufbereitung zu starten."

	oLog.LogMessage "Execution Time End: " & Now()
	
	SmartContext.ExecutionStatus = EXEC_STATUS_SUCCEEDED

	Set oLog = Nothing
	Set oMC = Nothing
	Set oSC = Nothing
	Set oPara = Nothing
	
	Exit Sub
ErrorHandler:
	Call LogSmartAnalyzerError("")
End Sub
'-----------------------------------------------------------------------------------------
' Import - UserMode
'-----------------------------------------------------------------------------------------
Function UserMode
Dim dialogInvoker As Object
Dim result As Object
Dim args As Object
Dim dict As Object
Dim returnedValues As Object

	Set dialogInvoker = SmartContext.GetServiceById("MacroDialogInvoker")
	If dialogInvoker is Nothing Then
		SmartContext.Log.LogError "Der Dialog für den Pfad der Datei konnte nicht angezeigt werden, da der MacroDialogInvoker Service nicht vorhanden ist."
		Exit Sub
	End If

	Set args = dialogInvoker.NewTaskParameters
	Set dict = oSC.CreateHashtable

	args.Inputs.Add "smartDataExchanger1", dict
    
	Set result = dialogInvoker.PerformTask("UserMode", args)
    
	If result.AllOK Then
SetCheckpoint "Get Dialog Varibles"
		iUserMode = result.Outputs.Item("smartOptionGroup1").Selection
		Select Case iUserMode
			Case 1
			bStandardUser = true
			bExpertUser = false
			Case 2
			bStandardUser = false
			bExpertUser = true
		End Select
	Else
SetCheckpoint "Get Dialog Varibles - Dialog failed"
		MsgBox "Die Aufbereitung wurde beendet."
		SmartContext.ExecutionStatus = EXEC_STATUS_CANCELED
		SmartContext.AbortImport = True
		oLog.LogWarning "Vorgang wurde vom Anwender abgebrochen (Dialog: UserMode)"
		oLog.LogWarning "Execution Time End: " & Now()
		Stop
	End If
	bParametersSet = true
End Function

'-----------------------------------------------------------------------------------------
' Import - Parameters
'-----------------------------------------------------------------------------------------
Function Parameters
Dim dialogInvoker As Object
Dim sFilePathStandard As String
Dim result As Object
Dim args As Object
Dim dict As Object
Dim returnedValues As Object

	sFilePathStandard = Client.WorkingDirectory
	
	Set dialogInvoker = SmartContext.GetServiceById("MacroDialogInvoker")
	If dialogInvoker is Nothing Then
		SmartContext.Log.LogError "Der Dialog für den Pfad der Datei konnte nicht angezeigt werden, da der MacroDialogInvoker Service nicht vorhanden ist."
		Exit Sub
	End If
    
	Set args = dialogInvoker.NewTaskParameters
	Set dict = oSC.CreateHashtable
	dict.Add "FilePathStandard", sFilePathStandard
	dict.Add "aktuellesGeschäftsjahr", sPrevGJAHR

	args.Inputs.Add "smartDataExchanger1", dict
    
	Set result = dialogInvoker.PerformTask("Parameter", args)
    
	If result.AllOK Then
SetCheckpoint "Get Dialog Varibles"

		sNichtausgriffsgrenze = result.Outputs.Item("smartTextBox1")
		sGeschäftsjahr = result.Outputs.Item("smartTextBox2")
		sPfadOBR = result.Outputs.Item("smartTextBox3")
		sPfadUmsätze = result.Outputs.Item("smartTextBox4")

		Set returnedValues = Nothing
	Else
SetCheckpoint "Get Dialog Varibles - Dialog failed"
		MsgBox "Die Aufbereitung wurde beendet."
		SmartContext.ExecutionStatus = EXEC_STATUS_CANCELED
		SmartContext.AbortImport = True
		oLog.LogWarning "Vorgang wurde vom Anwender abgebrochen (Dialog: FileChoice)"
		oLog.LogWarning "Execution Time End: " & Now()
		Stop
	End If	
End Function
'-----------------------------------------------------------------------------------------
' Standard Funtions - Error Handling
'-----------------------------------------------------------------------------------------
Sub LogSmartAnalyzerError(ByVal extraInfo As String)
On Error Resume Next
	If SmartContext.IsCancellationRequested Then
		SmartContext.ExecutionStatus = EXEC_STATUS_CANCELED
		SmartContext.AbortImport = True
		
		SmartContext.Log.LogMessage "Excecution was stopped by user."
		oLog.LogMessage "Execution Time End: " & Now()

		Set oLog = Nothing
		Set oMC = Nothing
		Set oSC = Nothing
		Set oPara = Nothing
		Stop		
	Else
		SmartContext.ExecutionStatus = EXEC_STATUS_FAILED
		SmartContext.AbortImport = True
		
		SmartContext.Log.LogError "An error occurred in during the data preparation of '{0}'.{1}Error #{2}, Error Description: {3}{1}" + _
		                          "The last passed checkpoint was: {4}", _
		                          SmartContext.TestName, Chr(10), Err.Number, Err.Description, m_checkpointName

		If Len(extraInfo) > 0 Then
			SmartContext.Log.LogError "Additional error information: " & extraInfo
		End If
		
		oLog.LogMessage "Execution Time End: " & Now()

		Set oLog = Nothing
		Set oMC = Nothing
		Set oSC = Nothing
		Set oPara = Nothing
		Stop	
	End If
End Sub

Sub SetCheckpoint(ByVal checkpointName As String)
	m_checkpointName = checkpointName
End Sub

'-------------------------------------------------------------------------------------
' Title:		SKA_FuR - Import Routine OBR Vergleich
' CIR:		SKA_FuR
' Customer:	Sparkassen
' Created by:	AS
' Created on:	28.10.2020
' Version:		1.00
'-------------------------------------------------------------------------------------
' Description:	Imports a second OBR Konten file and Umsetzungen to compare a previous year the the current year.
'				It is possible to you an existing OBR Konten file from the current or a different IDEA project
'-------------------------------------------------------------------------------------
' Files:		Requires 4 Input files
'			- OBR Konten current year
'			- OBR Konten previous year
'			- Umsetzungen current year
'			- Umsetzungen previous year
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
Dim CompareResult As Long

Dim sourceFileName As String

' IDEA standard variables
Dim db As Object
Dim dbName As String
Dim eqn As String
Dim task As Object
Dim field As Object

' Dialog Output
Dim sAktuelleGJAHR As String
Dim sPrevAktuelleGJAHR As String
dim bOverride as boolean
Dim sVorherigesGJAHR As String
		
Dim bAktuellesGJAHRCSV As Boolean
Dim bAktuellesGJAHRCurrentProject As Boolean
Dim bAktuellesGJAHRDifferentProject As Boolean
Dim bVorherigesGJAHRCSV As Boolean
Dim bVorherigesGJAHRCurrentProject As Boolean
Dim bVorherigesGJAHRDifferentProject As Boolean

Dim sPathCurrentYearOBR As String
Dim sPathPreviousYearOBR As String
Dim sPathCurrentYearUmsetzungen As String
Dim sPathPreviousYearUmsetzungen As String

' Error Logging
Dim lErrorNumber As Long
Dim sErrorDescripton As String
Dim lErrorLine As Long

Dim m_checkpointName As String

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

	oLog.LogMessage "Standard SK_001 Routine Name: " & SmartContext.TestName
	oLog.LogMessage " Standard SK_001 Routine Version: " & SmartContext.TestVersion
	oLog.LogMessage "Execution Time Start: " & Now()
	
SetCheckpoint "Get Project Parameters"
oLog.LogMessage m_checkpointName
	sPrevAktuelleGJAHR = oPara.Get4Project ("sAktuelleGJAHR")
	
'-----------------------------------------------------------------------------------------
' Funtion Calls
'-----------------------------------------------------------------------------------------
SetCheckpoint "Begin of Functions"
	Call ImportBaseFiles
SetCheckpoint "End of Functions"
'-----------------------------------------------------------------------------------------
' End Funtion Calls
'-----------------------------------------------------------------------------------------
SetCheckpoint "Set Project Parameters"
oLog.LogMessage m_checkpointName
	If bOverride Or sPrevAktuelleGJAHR = "" Then 
		oPara.Set4Project "sAktuelleGJAHR", sAktuelleGJAHR
	Else
		oPara.Set4Project "sAktuelleGJAHR", sPrevAktuelleGJAHR	
	End If
	oPara.Set4Project "sVorherigesGJAHR", sVorherigesGJAHR
	
	oPara.Set4Project "bAktuellesGJAHRCSV", bAktuellesGJAHRCSV 
	oPara.Set4Project "bAktuellesGJAHRCurrentProject", bAktuellesGJAHRCurrentProject
	oPara.Set4Project "bAktuellesGJAHRDifferentProject", bAktuellesGJAHRDifferentProject
	oPara.Set4Project "bVorherigesGJAHRCSV", bVorherigesGJAHRCSV
	oPara.Set4Project "bVorherigesGJAHRCurrentProject", bVorherigesGJAHRCurrentProject
	oPara.Set4Project "bVorherigesGJAHRDifferentProject", bVorherigesGJAHRDifferentProject
	
	oPara.Set4Project "sPathCurrentYearOBR", sPathCurrentYearOBR
	oPara.Set4Project "sPathPreviousYearOBR", sPathPreviousYearOBR
	oPara.Set4Project "sPathCurrentYearUmsetzungen", sPathCurrentYearUmsetzungen
	oPara.Set4Project "sPathPreviousYearUmsetzungen", sPathPreviousYearUmsetzungen

SetCheckpoint "User Massage"
	'msgbox "Ihr Auswahl wurde gespeichert." & Chr(13) & "Bitte klicken Sie auf Importieren, um die Aufbereitung zu starten."	
	If oSC.TryCompareVersions("12.0.0", oSC.IDEAVersion, CompareResult) Then
		Select Case CompareResult
			Case -1, 0
			SmartContext.TriggerImport = True
			Case Else
			MsgBox("Ihre Eingaben wurden gespeichert." & Chr(13) & _
			"Bitte klicken Sie auf Importieren.")
		End Select
	End If
	
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
' Import - Dialog Call
'-----------------------------------------------------------------------------------------
Function ImportBaseFiles
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
	dict.Add "aktuellesGeschäftsjahr", sPrevAktuelleGJAHR

	args.Inputs.Add "smartDataExchanger1", dict
    
	Set result = dialogInvoker.PerformTask("FileChoice", args)
    
	If result.AllOK Then
SetCheckpoint "Get Dialog Varibles"
		Set returnedValues = result.Outputs.Item("smartDataExchanger1").Value
		
		sAktuelleGJAHR = result.Outputs.Item("aktuellesGeschäftsjahr")
		bOverride = result.Outputs.Item("overrideGJAHRaktuell").Checked
		sVorherigesGJAHR = result.Outputs.Item("vorherigesGeschäftsjahr")
	
		bAktuellesGJAHRCSV = returnedValues.Item("bAktuellesGJAHRCSV").Checked
		bAktuellesGJAHRCurrentProject = returnedValues.Item("bAktuellesGJAHRCurrentProject").Checked
		bAktuellesGJAHRDifferentProject = returnedValues.Item("bAktuellesGJAHRDifferentProject").Checked
		bVorherigesGJAHRCSV = returnedValues.Item("bVorherigesGJAHRCSV").Checked
		bVorherigesGJAHRCurrentProject = returnedValues.Item("bVorherigesGJAHRCurrentProject").Checked
		bVorherigesGJAHRDifferentProject = returnedValues.Item("bVorherigesGJAHRDifferentProject").Checked
		
		if bAktuellesGJAHRCurrentProject then
			sPathCurrentYearOBR = returnedValues.Item("sCurrentProjektFile")
		else
			sPathCurrentYearOBR = result.Outputs.Item("aktuellesGJAHROBR")
		end if
		if bVorherigesGJAHRCurrentProject then
			sPathPreviousYearOBR = returnedValues.Item("sPrevProjektFile")
		else
			sPathPreviousYearOBR = result.Outputs.Item("vorherigesGJAHROBR")
		end if
		sPathCurrentYearUmsetzungen = result.Outputs.Item("aktuellesGJAHRUmsetzungen")
		sPathPreviousYearUmsetzungen = result.Outputs.Item("vorherigesGJAHRUmsetzungen")
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
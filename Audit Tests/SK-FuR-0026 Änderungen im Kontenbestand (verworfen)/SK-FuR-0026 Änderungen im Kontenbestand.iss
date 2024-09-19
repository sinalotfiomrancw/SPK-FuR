'-------------------------------------------------------------------------------------
' Title:		SKA-FuR-0026 Änderungen im Kontenbestand
' CIR:		SKA_FuR
' Customer:	Sparkassen
' Created by:	AS
' Created on:	05.11.2020
' Version:		1.00
'-------------------------------------------------------------------------------------
' Decription:	
'-------------------------------------------------------------------------------------
' Files:		Requires 1 Input file(s)
'			- "Vergleich OBR Konten " & sAktuelleGJAHR & " zu " & sVorherigesGJAHR &".IMD"
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

Dim sInputFile As String

' IDEA standard variables
Dim db As Object
Dim dbName As String
Dim eqn As String
Dim task As Object
Dim field As Object
Dim ProjectManagement As Object

' Results
dim sNichtAktuell as string
dim sNichtVorherig as string

' Temp

' Error Logging
Dim lErrorNumber As Long
Dim sErrorDescripton As String
Dim lErrorLine As Long

Dim m_checkpointName As String

Sub Main
On Error GoTo ErrorHandler
SetCheckpoint "Begin of Main"
	IgnoreWarning (True)
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
	sInputFile = SmartContext.PrimaryInputFile

'-----------------------------------------------------------------------------------------
' Funtion Calls
'-----------------------------------------------------------------------------------------
SetCheckpoint "Begin of Functions"
	Call analysis(sInputFile)
	call registerResult(sNichtAktuell, FINAL_RESULT)
	Call registerResult(sNichtVorherig, FINAL_RESULT)
SetCheckpoint "End of Functions"
	Client.RefreshFileExplorer
'-----------------------------------------------------------------------------------------
' End Funtion Calls
'-----------------------------------------------------------------------------------------

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
'-------------------------------------------------------------------------------------------------------------
' Analyse
'-------------------------------------------------------------------------------------------------------------
function analysis(byval sBase as string)
SetCheckpoint "analysis, Checkpoint 1.0"
	Set db = Client.OpenDatabase(sBase)
	Set task = db.Extraction
	task.AddFieldToInc "KONTO1"
	task.AddFieldToInc "UNR1"
	task.AddFieldToInc "RAHMENNR1"
	task.AddFieldToInc "BEZEICHNUNG1"
	task.AddFieldToInc "WKZ1"
	task.AddFieldToInc "NABU_NR1"
	task.AddFieldToInc "POSITIONEN1"
	task.AddFieldToInc "AZ9_SALDO1"
	task.AddFieldToInc "OBR_SALDO1"
	task.AddFieldToInc "AZ9_SALDO_IN_WÄHR1"
	task.AddFieldToInc "BV_SCHL1"
	task.AddFieldToInc "BESCHREIBUNG_PRIMÄRE_POSITION1"
	task.AddFieldToInc "SYSTEMPOSITION1"
	task.AddFieldToInc "ART1"
	task.AddFieldToInc "GUV_MKML1"
	task.AddFieldToInc "STEUERPOS_AKT_JAHR1"
	task.AddFieldToInc "STEUERL_LAT1"
	task.AddFieldToInc "STEUERL_LAT21"
	task.AddFieldToInc "POSITION_AKT_JAHR1"
	task.AddFieldToInc "POSITION_VORJAHR1"
	task.AddFieldToInc "ÄNDERUNG1"
	task.AddFieldToInc "ERÖFFNUNG1"
	task.AddFieldToInc "AUFLÖSUNG1"
	sNichtAktuell = oSC.UniqueFileName("nicht mehr im aktuellen Geschäftsjahr enthalten.IMD", FINAL_RESULT)
	task.AddExtraction sNichtAktuell, "", "KONTO == """""
	task.CreateVirtualDatabase = False
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sNichtAktuell & " created."
SetCheckpoint "analysis, Checkpoint 1.1"
	Set db = Client.OpenDatabase(sBase)
	Set task = db.Extraction
	task.AddFieldToInc "KONTO"
	task.AddFieldToInc "UNR"
	task.AddFieldToInc "RAHMENNR"
	task.AddFieldToInc "BEZEICHNUNG"
	task.AddFieldToInc "WKZ"
	task.AddFieldToInc "NABU_NR"
	task.AddFieldToInc "POSITIONEN"
	task.AddFieldToInc "AZ9_SALDO"
	task.AddFieldToInc "OBR_SALDO"
	task.AddFieldToInc "AZ9_SALDO_IN_WÄHR"
	task.AddFieldToInc "BV_SCHL"
	task.AddFieldToInc "BESCHREIBUNG_PRIMÄRE_POSITION"
	task.AddFieldToInc "SYSTEMPOSITION"
	task.AddFieldToInc "ART"
	task.AddFieldToInc "GUV_MKML"
	task.AddFieldToInc "STEUERPOS_AKT_JAHR"
	task.AddFieldToInc "STEUERL_LAT"
	task.AddFieldToInc "STEUERL_LAT2"
	task.AddFieldToInc "POSITION_AKT_JAHR"
	task.AddFieldToInc "POSITION_VORJAHR"
	task.AddFieldToInc "ÄNDERUNG"
	task.AddFieldToInc "ERÖFFNUNG"
	task.AddFieldToInc "AUFLÖSUNG"
	sNichtVorherig = oSC.UniqueFileName("nicht im vorherigen Geschäftsjahr enthalten.IMD", FINAL_RESULT)
	task.AddExtraction sNichtVorherig, "", "KONTO1 == """""
	task.CreateVirtualDatabase = False
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sNichtVorherig & " created."
end function
'-------------------------------------------------------------------------------------------------------------
' Ergebnisse registrieren
'-------------------------------------------------------------------------------------------------------------
Function registerResult(ByVal dbNameResult As String, ByVal sResultType)
Dim oList As Object
	Set oList = oSC.CreateResultObject(dbNameResult, sResultType, True, 1)
	SmartContext.TestResultFiles.Add oList
	'oList.Extravalues.Add "Alias", dbNameResult
oLog.LogMessage dbNameResult & " registered."
	Set oList = Nothing
End Function
'-----------------------------------------------------------------------------------------
' Standard Funtions - Error Handling
'-----------------------------------------------------------------------------------------
Sub LogSmartAnalyzerError(ByVal extraInfo As String)
On Error Resume Next
	If SmartContext.IsCancellationRequested Then
		SmartContext.ExecutionStatus = EXEC_STATUS_CANCELED
		'SmartContext.AbortImport = True
		
		SmartContext.Log.LogMessage "Excecution was stopped by user."
		oLog.LogMessage "Execution Time End: " & Now()

		Set oLog = Nothing
		Set oMC = Nothing
		Set oSC = Nothing
		Set oPara = Nothing
		Stop		
	Else
		SmartContext.ExecutionStatus = EXEC_STATUS_FAILED
		'SmartContext.AbortImport = True
		
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

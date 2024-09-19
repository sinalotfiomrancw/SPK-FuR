'-------------------------------------------------------------------------------------
' Title:		SKA-FuR-0027 Änderungen der Bilanzposition
' CIR:		SKA_FuR
' Customer:	Sparkassen
' Created by:	AS
' Created on:	05.11.2020
' Version:		1.00
'-------------------------------------------------------------------------------------
' Decription:	
'-------------------------------------------------------------------------------------
' Files:		Requires 1 Input file(s)
'			- "OBR Konten " & sAktuelleGJAHR & ".IMD"
'-------------------------------------------------------------------------------------
' Change History
'-------------------------------------------------------------------------------------
' Changed by:	AS
' Changed on:	21.07.2022
' Requested by:	AG
' Comment:		final result are marked with a flag. this should help finding the files,
' 				if an auditer has to look into the idea files but did not perform the audit test and transfer owner ship is not available
'------------------
' Changed by:	AS
' Changed on:	03.08.2022
' Requested by:	AG (GK)
' Comment:		changed filter to not include new and closed accounts
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
dim sBilanzpositionsänderung as string

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

	oLog.LogMessage "Audit Test Name: " & SmartContext.TestName
	oLog.LogMessage "Audit Test Version: " & SmartContext.TestVersion
	oLog.LogMessage "Execution Time Start: " & Now()
	
SetCheckpoint "Get Project Parameters"
oLog.LogMessage m_checkpointName
	sInputFile = SmartContext.PrimaryInputFile

'-----------------------------------------------------------------------------------------
' Funtion Calls
'-----------------------------------------------------------------------------------------
SetCheckpoint "Begin of Functions"
	Call analysis(sInputFile)
	call registerResult(sBilanzpositionsänderung, FINAL_RESULT)
SetCheckpoint "End of Functions"
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
	task.AddFieldToInc "KONTO"
	task.AddFieldToInc "RAHMENNR"
	task.AddFieldToInc "BEZEICHNUNG"
	task.AddFieldToInc "OBR_SALDO"
	task.AddFieldToInc "BESCHREIBUNG_PRIMÄRE_POSITION"
	task.AddFieldToInc "BUCHUNGSKATEGORIE_BV"
	task.AddFieldToInc "POSITION_AKT_JAHR"
	task.AddFieldToInc "POSITION_VORJAHR"
	task.AddFieldToInc "ERÖFFNUNG"
	task.AddFieldToInc "AUFLÖSUNG"
	task.AddFieldToInc "POSITION_SHORT"
	sBilanzpositionsänderung = oSC.UniqueFileName("andere OBR-Position als im Vorjahr.IMD", FINAL_RESULT)
	'task.AddExtraction sBilanzpositionsänderung, "", " POSITION_AKT_JAHR  <>  POSITION_VORJAHR  " ' 03.08.2022
	task.AddExtraction sBilanzpositionsänderung, "", "POSITION_AKT_JAHR <> POSITION_VORJAHR .AND. POSITION_AKT_JAHR <> """" .AND. POSITION_VORJAHR <> """""
	task.CreateVirtualDatabase = False
	task.PerformTask 1, db.Count
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sBilanzpositionsänderung & " created."
end function
'-------------------------------------------------------------------------------------------------------------
' Ergebnisse registrieren
'-------------------------------------------------------------------------------------------------------------
Function registerResult(ByVal dbNameResult As String, ByVal sResultType)
SetCheckpoint "registerResult: " & dbNameResult
Dim oList As Object
	Set oList = oSC.CreateResultObject(dbNameResult, sResultType, True, 1)
	SmartContext.TestResultFiles.Add oList
	'oList.Extravalues.Add "Alias", dbNameResult
	
	Call SetFlagForTable(dbNameResult, TRUE)
	
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
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
' AS 21.07.2022
' flags database for easy search in idea file explorer
' if the variable for the table name does not include the path for the working direktory the variable bWorkingDirectoryIncluded must be set to FALSE otherweise TRUE
sub SetFlagForTable (byval sTable as string, byval bWorkingDirectoryIncluded as boolean)

	if bWorkingDirectoryIncluded = FALSE then sTable = Client.WorkingDirectory & sTable

	Set task = Client.ProjectManagement
	task.FlagDatabase sTable
	Set task = Nothing
end sub

'-------------------------------------------------------------------------------------
' Title:		SKA-FuR-0028 Er�ffnete und aufgel�ste Hauptbuchkonten
' CIR:		SKA_FuR
' Customer:	Sparkassen
' Created by:	AS
' Created on:	05.11.2020
' Version:		1.00
'-------------------------------------------------------------------------------------
' Decription:	
'-------------------------------------------------------------------------------------
' Files:		Requires 1 Input file(s)
'			- "{OBR Konten " & sAktuelleGJAHR & "}.IMD"
'-------------------------------------------------------------------------------------
' Change History
'-------------------------------------------------------------------------------------
' Changed by:	AS
' Changed on:	16.12.2020
' Requested by:	SK AG, Gothues
' Comment:		corrected filter for date columns
'------------------
' Changed by:	AS
' Changed on:	21.07.2022
' Requested by:	AG
' Comment:		final result are marked with a flag. this should help finding the files,
' 				if an auditer has to look into the idea files but did not perform the audit test and transfer owner ship is not available
'------------------
' Changed by:	AS
' Changed on:	03.08.2022
' Requested by:	AG
' Comment:		added new table for new account after the accountig year
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

' Projekt parameter
Dim sAktuelleGJAHR As String

' Results
dim sEr�ffnungen as string
Dim sAufl�sungen As String
Dim sEr�ffnungenFolgeJahr As String
Dim sAufl�sungenFolgeJahr As String

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

	oLog.LogMessage "Routine Name: " & SmartContext.TestName
	oLog.LogMessage "Routine Version: " & SmartContext.TestVersion
	oLog.LogMessage "Execution Time Start: " & Now()
	
SetCheckpoint "Get Project Parameters"
oLog.LogMessage m_checkpointName
	sInputFile = SmartContext.PrimaryInputFile
	sAktuelleGJAHR = oPara.Get4Project ("sAktuelleGJAHR")

'-----------------------------------------------------------------------------------------
' Funtion Calls
'-----------------------------------------------------------------------------------------
SetCheckpoint "Begin of Functions"
	Call analysis(sInputFile)
	Call registerResult(sEr�ffnungen, FINAL_RESULT)
	call registerResult(sAufl�sungen, FINAL_RESULT)
	'03.08.2022
	Call registerResult(sEr�ffnungenFolgeJahr, FINAL_RESULT)
	Call registerResult(sAufl�sungenFolgeJahr, FINAL_RESULT)
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
	task.AddFieldToInc "BESCHREIBUNG_PRIM�RE_POSITION"
	task.AddFieldToInc "BUCHUNGSKATEGORIE_BV"
	task.AddFieldToInc "POSITION_AKT_JAHR"
	task.AddFieldToInc "POSITION_VORJAHR"
	task.AddFieldToInc "ER�FFNUNG"
	task.AddFieldToInc "AUFL�SUNG"
	task.AddFieldToInc "POSITION_SHORT"
	sEr�ffnungen = oSC.UniqueFileName("Er�ffnungen im aktuellen Bilanzjahr.IMD", FINAL_RESULT)
	task.AddExtraction sEr�ffnungen, "", "ER�FFNUNG >= """ & sAktuelleGJAHR & "0101""  .AND. ER�FFNUNG < """ & sAktuelleGJAHR & "1231""" 'AS 16.12.2020: changed 0101 to 1231
	task.CreateVirtualDatabase = False
	task.PerformTask 1, db.Count
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sEr�ffnungen & " created."
SetCheckpoint "analysis, Checkpoint 2.0"
	Set db = Client.OpenDatabase(sBase)
	Set task = db.Extraction
	task.AddFieldToInc "KONTO"
	task.AddFieldToInc "RAHMENNR"
	task.AddFieldToInc "BEZEICHNUNG"
	task.AddFieldToInc "OBR_SALDO"
	task.AddFieldToInc "BESCHREIBUNG_PRIM�RE_POSITION"
	task.AddFieldToInc "BUCHUNGSKATEGORIE_BV"
	task.AddFieldToInc "POSITION_AKT_JAHR"
	task.AddFieldToInc "POSITION_VORJAHR"
	task.AddFieldToInc "ER�FFNUNG"
	task.AddFieldToInc "AUFL�SUNG"
	task.AddFieldToInc "POSITION_SHORT"
	sAufl�sungen = oSC.UniqueFileName("Aufl�sungen im aktuellen Bilanzjahr.IMD", FINAL_RESULT)
	task.AddExtraction sAufl�sungen, "", "AUFL�SUNG >= """ & sAktuelleGJAHR & "0101""  .AND. AUFL�SUNG < """ & sAktuelleGJAHR & "1231""" 'AS 16.12.2020: changed 0101 to 1231
	task.CreateVirtualDatabase = False
	task.PerformTask 1, db.Count
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sAufl�sungen & " created."
' 03.08.2022
SetCheckpoint "analysis, Checkpoint 3.0"
	Set db = Client.OpenDatabase(sBase)
	Set task = db.Extraction
	task.AddFieldToInc "KONTO"
	task.AddFieldToInc "RAHMENNR"
	task.AddFieldToInc "BEZEICHNUNG"
	task.AddFieldToInc "OBR_SALDO"
	task.AddFieldToInc "BESCHREIBUNG_PRIM�RE_POSITION"
	task.AddFieldToInc "BUCHUNGSKATEGORIE_BV"
	task.AddFieldToInc "POSITION_AKT_JAHR"
	task.AddFieldToInc "POSITION_VORJAHR"
	task.AddFieldToInc "ER�FFNUNG"
	task.AddFieldToInc "AUFL�SUNG"
	task.AddFieldToInc "POSITION_SHORT"
	sEr�ffnungenFolgeJahr = oSC.UniqueFileName("Er�ffnungen nach dem aktuellen Bilanzjahr.IMD", FINAL_RESULT)
	task.AddExtraction sEr�ffnungenFolgeJahr, "", "ER�FFNUNG > """ & sAktuelleGJAHR & "1231"""
	task.CreateVirtualDatabase = False
	task.PerformTask 1, db.Count
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sEr�ffnungenFolgeJahr & " created."
SetCheckpoint "analysis, Checkpoint 4.0"
	Set db = Client.OpenDatabase(sBase)
	Set task = db.Extraction
	task.AddFieldToInc "KONTO"
	task.AddFieldToInc "RAHMENNR"
	task.AddFieldToInc "BEZEICHNUNG"
	task.AddFieldToInc "OBR_SALDO"
	task.AddFieldToInc "BESCHREIBUNG_PRIM�RE_POSITION"
	task.AddFieldToInc "BUCHUNGSKATEGORIE_BV"
	task.AddFieldToInc "POSITION_AKT_JAHR"
	task.AddFieldToInc "POSITION_VORJAHR"
	task.AddFieldToInc "ER�FFNUNG"
	task.AddFieldToInc "AUFL�SUNG"
	task.AddFieldToInc "POSITION_SHORT"
	sAufl�sungenFolgeJahr = oSC.UniqueFileName("Aufl�sungen nach dem aktuellen Bilanzjahr.IMD", FINAL_RESULT)
	task.AddExtraction sAufl�sungenFolgeJahr, "", "AUFL�SUNG > """ & sAktuelleGJAHR & "1231"" .AND. AUFL�SUNG <> ""99991231"""
	task.CreateVirtualDatabase = False
	task.PerformTask 1, db.Count
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sAufl�sungenFolgeJahr & " created."
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
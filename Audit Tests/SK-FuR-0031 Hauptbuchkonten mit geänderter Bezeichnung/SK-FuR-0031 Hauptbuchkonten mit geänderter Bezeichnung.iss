'-------------------------------------------------------------------------------------
' Title:		SKA-FuR-0031 Hauptbuchkonten mit geänderter Bezeichnung
' CIR:		SKA_FuR
' Customer:	Sparkassen
' Created by:	AS
' Created on:	09.11.2020
' Version:		1.00
'-------------------------------------------------------------------------------------
' Decription:	
'-------------------------------------------------------------------------------------
' Files:		Requires 1 Input file(s)
'			- "Vergleich OBR Konten " & sAktuelleGJAHR & " zu " & sVorherigesGJAHR &".IMD"
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
' Changed on:	27.07.2022
' Requested by:	AG
' Comment:		get column names from tags to work with the flexible field names
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
Dim sNamenVergleich As String
Dim sSaldenVergleich As String

' Temp

' ColumnNames
Dim VOBR_KONTO_AKT as string
Dim VOBR_UNR_AKT as string
Dim VOBR_RAHMENNR_AKT as string
Dim VOBR_BEZEICHNUNG_AKT as string
Dim VOBR_WKZ_AKT as string
Dim VOBR_NABU_NR_AKT as string
Dim VOBR_POSITIONEN_AKT as string
Dim VOBR_AZ9_SALDO_AKT as string
Dim VOBR_OBR_SALDO_AKT as string
Dim VOBR_AZ9_SALDO_IN_WAEHR_AKT as string
Dim VOBR_BV_SCHL_AKT as string
Dim VOBR_BESCHREIBUNG_PRIMAERE_POSITION_AKT as string
Dim VOBR_SYSTEMPOSITION_AKT as string
Dim VOBR_ART_AKT as string
Dim VOBR_GUV_MKML_AKT as string
Dim VOBR_STEUERPOS_AKT_JAHR_AKT as string
Dim VOBR_STEUERL_LAT_AKT as string
Dim VOBR_STEUERL_LAT2_AKT as string
Dim VOBR_POSITION_AKT_JAHR_AKT as string
Dim VOBR_POSITION_VORJAHR_AKT as string
Dim VOBR_AENDERUNG_AKT as string
Dim VOBR_EROEFFNUNG_AKT as string
Dim VOBR_AUFLOESUNG_AKT as string
Dim VOBR_POSITION_SHORT_AKT as string
Dim VOBR_BUCHUNGSKATEGORIE_BV_AKT as string
'------------------------------------------------------------------------------
Dim VOBR_KONTO_VORH as string
Dim VOBR_UNR_VORH as string
Dim VOBR_RAHMENNR_VORH as string
Dim VOBR_BEZEICHNUNG_VORH as string
Dim VOBR_WKZ_VORH as string
Dim VOBR_NABU_NR_VORH as string
Dim VOBR_POSITIONEN_VORH as string
Dim VOBR_AZ9_SALDO_VORH as string
Dim VOBR_OBR_SALDO_VORH as string
Dim VOBR_AZ9_SALDO_IN_WAEHR_VORH as string
Dim VOBR_BV_SCHL_VORH as string
Dim VOBR_BESCHREIBUNG_PRIMAERE_POSITION_VORH as string
Dim VOBR_SYSTEMPOSITION_VORH as string
Dim VOBR_ART_VORH as string
Dim VOBR_GUV_MKML_VORH as string
Dim VOBR_STEUERPOS_AKT_JAHR_VORH as string
Dim VOBR_STEUERL_LAT_VORH as string
Dim VOBR_STEUERL_LAT2_VORH as string
Dim VOBR_POSITION_AKT_JAHR_VORH as string
Dim VOBR_POSITION_VORJAHR_VORH as string
Dim VOBR_AENDERUNG_VORH as string
Dim VOBR_EROEFFNUNG_VORH as string
Dim VOBR_AUFLOESUNG_VORH as string
Dim VOBR_POSITION_SHORT_VORH as string
Dim VOBR_BUCHUNGSKATEGORIE_BV_VORH as string

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
	Set oTM = SmartContext.MacroCommands.TagManagement
	Set oPara = SmartContext.MacroCommands.GlobalParameters

	'Set ExecutionStatus (failure at the beginning).
	SmartContext.ExecutionStatus =EXEC_STATUS_FAILED

	oLog.LogMessage "Routine Name: " & SmartContext.TestName
	oLog.LogMessage "Routine Version: " & SmartContext.TestVersion
	oLog.LogMessage "Execution Time Start: " & Now()
	
SetCheckpoint "Get Project Parameters"
oLog.LogMessage m_checkpointName
	sInputFile = SmartContext.PrimaryInputFile
	Call GetTags() ' 27.07.2022

'-----------------------------------------------------------------------------------------
' Funtion Calls
'-----------------------------------------------------------------------------------------
SetCheckpoint "Begin of Functions"
	Call analysis(sInputFile)
	call registerResult(sNamenVergleich, FINAL_RESULT)
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
	Set oTM = Nothing
	
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
	' 27.07.2022
	'task.AddFieldToInc "KONTO"
	'task.AddFieldToInc "UNR"
	'task.AddFieldToInc "RAHMENNR"
	'task.AddFieldToInc "BEZEICHNUNG"
	'task.AddFieldToInc "BEZEICHNUNG1"
	'task.AddFieldToInc "WKZ"
	'task.AddFieldToInc "NABU_NR"
	'task.AddFieldToInc "POSITIONEN"
	'task.AddFieldToInc "AZ9_SALDO"
	'task.AddFieldToInc "OBR_SALDO"
	'task.AddFieldToInc "AZ9_SALDO_IN_WÄHR"
	'task.AddFieldToInc "BV_SCHL"
	'task.AddFieldToInc "BESCHREIBUNG_PRIMÄRE_POSITION"
	'task.AddFieldToInc "SYSTEMPOSITION"
	'task.AddFieldToInc "ART"
	'task.AddFieldToInc "GUV_MKML"
	'task.AddFieldToInc "STEUERPOS_AKT_JAHR"
	'task.AddFieldToInc "STEUERL_LAT"
	'task.AddFieldToInc "STEUERL_LAT2"
	'task.AddFieldToInc "POSITION_AKT_JAHR"
	'task.AddFieldToInc "POSITION_VORJAHR"
	'task.AddFieldToInc "ÄNDERUNG"
	'task.AddFieldToInc "ERÖFFNUNG"
	'task.AddFieldToInc "AUFLÖSUNG"
	''task.AddFieldToInc "KONTO1"
	''task.AddFieldToInc "UNR1"
	''task.AddFieldToInc "RAHMENNR1"
	''task.AddFieldToInc "WKZ1"
	''task.AddFieldToInc "NABU_NR1"
	''task.AddFieldToInc "POSITIONEN1"
	''task.AddFieldToInc "AZ9_SALDO1"
	''task.AddFieldToInc "OBR_SALDO1"
	''task.AddFieldToInc "AZ9_SALDO_IN_WÄHR1"
	''task.AddFieldToInc "BV_SCHL1"
	''task.AddFieldToInc "BESCHREIBUNG_PRIMÄRE_POSITION1"
	''task.AddFieldToInc "SYSTEMPOSITION1"
	''task.AddFieldToInc "ART1"
	''task.AddFieldToInc "GUV_MKML1"
	''task.AddFieldToInc "STEUERPOS_AKT_JAHR1"
	''task.AddFieldToInc "STEUERL_LAT1"
	''task.AddFieldToInc "STEUERL_LAT21"
	''task.AddFieldToInc "POSITION_AKT_JAHR1"
	''task.AddFieldToInc "POSITION_VORJAHR1"
	''task.AddFieldToInc "ÄNDERUNG1"
	''task.AddFieldToInc "ERÖFFNUNG1"
	''task.AddFieldToInc "AUFLÖSUNG1"
	
	task.AddFieldToInc VOBR_KONTO_AKT
	task.AddFieldToInc VOBR_UNR_AKT
	task.AddFieldToInc VOBR_RAHMENNR_AKT
	task.AddFieldToInc VOBR_BEZEICHNUNG_AKT
	task.AddFieldToInc VOBR_BEZEICHNUNG_VORH
	task.AddFieldToInc VOBR_WKZ_AKT
	task.AddFieldToInc VOBR_NABU_NR_AKT
	task.AddFieldToInc VOBR_POSITIONEN_AKT
	task.AddFieldToInc VOBR_AZ9_SALDO_AKT
	task.AddFieldToInc VOBR_OBR_SALDO_AKT
	task.AddFieldToInc VOBR_AZ9_SALDO_IN_WAEHR_AKT
	task.AddFieldToInc VOBR_BV_SCHL_AKT
	task.AddFieldToInc VOBR_BESCHREIBUNG_PRIMAERE_POSITION_AKT
	task.AddFieldToInc VOBR_SYSTEMPOSITION_AKT
	task.AddFieldToInc VOBR_ART_AKT
	task.AddFieldToInc VOBR_GUV_MKML_AKT
	task.AddFieldToInc VOBR_STEUERPOS_AKT_JAHR_AKT
	task.AddFieldToInc VOBR_STEUERL_LAT_AKT
	task.AddFieldToInc VOBR_STEUERL_LAT2_AKT
	task.AddFieldToInc VOBR_POSITION_AKT_JAHR_AKT
	task.AddFieldToInc VOBR_POSITION_VORJAHR_AKT
	task.AddFieldToInc VOBR_AENDERUNG_AKT
	task.AddFieldToInc VOBR_EROEFFNUNG_AKT
	task.AddFieldToInc VOBR_AUFLOESUNG_AKT
	task.AddFieldToInc VOBR_BUCHUNGSKATEGORIE_BV_AKT
	task.AddFieldToInc VOBR_POSITION_SHORT_AKT
	
	sNamenVergleich = oSC.UniqueFileName("Hauptbuchkonten mit geänderter Bezeichnung.IMD", FINAL_RESULT)
	'task.AddExtraction sNamenVergleich, "", "BEZEICHNUNG<>BEZEICHNUNG1 .and. BEZEICHNUNG<>"""" .and. BEZEICHNUNG1<>""""" 27.07.2022
	task.AddExtraction sNamenVergleich, "", VOBR_BEZEICHNUNG_AKT & " <> " & VOBR_BEZEICHNUNG_VORH & " .and. " & VOBR_BEZEICHNUNG_AKT & " <> """" .and. " & VOBR_BEZEICHNUNG_VORH & " <> """""
	task.CreateVirtualDatabase = False
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sSaldenVergleich & " created."
' 27.07.2022 is not needed anymore, column names include the year
'SetCheckpoint "analysis, Checkpoint 1.1"
'	Set db = Client.OpenDatabase(sNamenVergleich)
'	Set task = db.TableManagement
'	Set field = db.TableDef.NewField
'	field.Name = "BEZEICHNUNG_AKTUELLES_JAHR"
'	field.Description = ""
'	field.Type = WI_CHAR_FIELD
'	field.Equation = ""
'	field.Length = 94
'	task.ReplaceField "BEZEICHNUNG", field
'	task.PerformTask
'SetCheckpoint "analysis, Checkpoint 1.2"
'	field.Name = "BEZEICHNUNG_VORJAHR"
'	field.Description = ""
'	field.Type = WI_CHAR_FIELD
'	field.Equation = ""
'	field.Length = 94
'	task.ReplaceField "BEZEICHNUNG1", field
'	task.PerformTask
'	Set task = Nothing
'	Set db = Nothing
'	Set field = Nothing
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
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
' AS 27.07.2022
' gets the columns names from the tags
function GetTags
	Set db = Client.OpenDatabase(sInputFile)
	
	VOBR_KONTO_AKT = oTM.GetFieldForTag(db,"acc!VOBR_KONTO_AKT")
	VOBR_UNR_AKT = oTM.GetFieldForTag(db,"acc!VOBR_UNR_AKT")
	VOBR_RAHMENNR_AKT = oTM.GetFieldForTag(db,"acc!VOBR_RAHMENNR_AKT")
	VOBR_BEZEICHNUNG_AKT = oTM.GetFieldForTag(db,"acc!VOBR_BEZEICHNUNG_AKT")
	VOBR_WKZ_AKT = oTM.GetFieldForTag(db,"acc!VOBR_WKZ_AKT")
	VOBR_NABU_NR_AKT = oTM.GetFieldForTag(db,"acc!VOBR_NABU_NR_AKT")
	VOBR_POSITIONEN_AKT = oTM.GetFieldForTag(db,"acc!VOBR_POSITIONEN_AKT")
	VOBR_AZ9_SALDO_AKT = oTM.GetFieldForTag(db,"acc!VOBR_AZ9_SALDO_AKT")
	VOBR_OBR_SALDO_AKT = oTM.GetFieldForTag(db,"acc!VOBR_OBR_SALDO_AKT")
	VOBR_AZ9_SALDO_IN_WAEHR_AKT = oTM.GetFieldForTag(db,"acc!VOBR_AZ9_SALDO_IN_WAEHR_AKT")
	VOBR_BV_SCHL_AKT = oTM.GetFieldForTag(db,"acc!VOBR_BV_SCHL_AKT")
	VOBR_BESCHREIBUNG_PRIMAERE_POSITION_AKT = oTM.GetFieldForTag(db,"acc!VOBR_BESCHREIBUNG_PRIMAERE_POSITION_AKT")
	VOBR_SYSTEMPOSITION_AKT = oTM.GetFieldForTag(db,"acc!VOBR_SYSTEMPOSITION_AKT")
	VOBR_ART_AKT = oTM.GetFieldForTag(db,"acc!VOBR_ART_AKT")
	VOBR_GUV_MKML_AKT = oTM.GetFieldForTag(db,"acc!VOBR_GUV_MKML_AKT")
	VOBR_STEUERPOS_AKT_JAHR_AKT = oTM.GetFieldForTag(db,"acc!VOBR_STEUERPOS_AKT_JAHR_AKT")
	VOBR_STEUERL_LAT_AKT = oTM.GetFieldForTag(db,"acc!VOBR_STEUERL_LAT_AKT")
	VOBR_STEUERL_LAT2_AKT = oTM.GetFieldForTag(db,"acc!VOBR_STEUERL_LAT2_AKT")
	VOBR_POSITION_AKT_JAHR_AKT = oTM.GetFieldForTag(db,"acc!VOBR_POSITION_AKT_JAHR_AKT")
	VOBR_POSITION_VORJAHR_AKT = oTM.GetFieldForTag(db,"acc!VOBR_POSITION_VORJAHR_AKT")
	VOBR_AENDERUNG_AKT = oTM.GetFieldForTag(db,"acc!VOBR_AENDERUNG_AKT")
	VOBR_EROEFFNUNG_AKT = oTM.GetFieldForTag(db,"acc!VOBR_EROEFFNUNG_AKT")
	VOBR_AUFLOESUNG_AKT = oTM.GetFieldForTag(db,"acc!VOBR_AUFLOESUNG_AKT")
	VOBR_POSITION_SHORT_AKT = oTM.GetFieldForTag(db,"acc!VOBR_POSITION_SHORT_AKT")
	VOBR_BUCHUNGSKATEGORIE_BV_AKT = oTM.GetFieldForTag(db,"acc!VOBR_BUCHUNGSKATEGORIE_BV_AKT")
'------------------------------------------------------------------------------
	VOBR_KONTO_VORH = oTM.GetFieldForTag(db,"acc!VOBR_KONTO_VORH")
	VOBR_UNR_VORH = oTM.GetFieldForTag(db,"acc!VOBR_UNR_VORH")
	VOBR_RAHMENNR_VORH = oTM.GetFieldForTag(db,"acc!VOBR_RAHMENNR_VORH")
	VOBR_BEZEICHNUNG_VORH = oTM.GetFieldForTag(db,"acc!VOBR_BEZEICHNUNG_VORH")
	VOBR_WKZ_VORH = oTM.GetFieldForTag(db,"acc!VOBR_WKZ_VORH")
	VOBR_NABU_NR_VORH = oTM.GetFieldForTag(db,"acc!VOBR_NABU_NR_VORH")
	VOBR_POSITIONEN_VORH = oTM.GetFieldForTag(db,"acc!VOBR_POSITIONEN_VORH")
	VOBR_AZ9_SALDO_VORH = oTM.GetFieldForTag(db,"acc!VOBR_AZ9_SALDO_VORH")
	VOBR_OBR_SALDO_VORH = oTM.GetFieldForTag(db,"acc!VOBR_OBR_SALDO_VORH")
	VOBR_AZ9_SALDO_IN_WAEHR_VORH = oTM.GetFieldForTag(db,"acc!VOBR_AZ9_SALDO_IN_WAEHR_VORH")
	VOBR_BV_SCHL_VORH = oTM.GetFieldForTag(db,"acc!VOBR_BV_SCHL_VORH")
	VOBR_BESCHREIBUNG_PRIMAERE_POSITION_VORH = oTM.GetFieldForTag(db,"acc!VOBR_BESCHREIBUNG_PRIMAERE_POSITION_VORH")
	VOBR_SYSTEMPOSITION_VORH = oTM.GetFieldForTag(db,"acc!VOBR_SYSTEMPOSITION_VORH")
	VOBR_ART_VORH = oTM.GetFieldForTag(db,"acc!VOBR_ART_VORH")
	VOBR_GUV_MKML_VORH = oTM.GetFieldForTag(db,"acc!VOBR_GUV_MKML_VORH")
	VOBR_STEUERPOS_AKT_JAHR_VORH = oTM.GetFieldForTag(db,"acc!VOBR_STEUERPOS_AKT_JAHR_VORH")
	VOBR_STEUERL_LAT_VORH = oTM.GetFieldForTag(db,"acc!VOBR_STEUERL_LAT_VORH")
	VOBR_STEUERL_LAT2_VORH = oTM.GetFieldForTag(db,"acc!VOBR_STEUERL_LAT2_VORH")
	VOBR_POSITION_AKT_JAHR_VORH = oTM.GetFieldForTag(db,"acc!VOBR_POSITION_AKT_JAHR_VORH")
	VOBR_POSITION_VORJAHR_VORH = oTM.GetFieldForTag(db,"acc!VOBR_POSITION_VORJAHR_VORH")
	VOBR_AENDERUNG_VORH = oTM.GetFieldForTag(db,"acc!VOBR_AENDERUNG_VORH")
	VOBR_EROEFFNUNG_VORH = oTM.GetFieldForTag(db,"acc!VOBR_EROEFFNUNG_VORH")
	VOBR_AUFLOESUNG_VORH = oTM.GetFieldForTag(db,"acc!VOBR_AUFLOESUNG_VORH")
	VOBR_POSITION_SHORT_VORH = oTM.GetFieldForTag(db,"acc!VOBR_POSITION_SHORT_VORH")
	VOBR_BUCHUNGSKATEGORIE_BV_VORH = oTM.GetFieldForTag(db,"acc!VOBR_BUCHUNGSKATEGORIE_BV_VORH")
	
	db.Close
	Set db = nothing
end function
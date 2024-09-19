'-------------------------------------------------------------------------------------
' Title:		SKA-FuR-0025 Saldenvergleich GeschÃ¤ftsjahr mit Vorjahr
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
' Changed by:	AS
' Changed on:	17.12.2020
' Requested by:	SK
' Comment:		solved the issue with a zero devision
'------------------
' Changed by:	AS
' Changed on:	10.02.2021
' Requested by:	SK
' Comment:		create new files for special accounts with sub accounts
'------------------
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
'------------------
' Changed by:	AS
' Changed on:	02.08.2022
' Requested by:	AG
' Comment:		added filter option for absolute and percentage deviation
'------------------
' Changed by:	AS
' Changed on:	06.12.2022
' Requested by:	AG
' Comment:		change filter - added option for empty entries
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
Dim oParameters As Object

Dim sInputFile As String

' IDEA standard variables
Dim db As Object
Dim dbName As String
Dim eqn As String
Dim task As Object
Dim field As Object
Dim ProjectManagement As Object

' Results
Dim sSaldenVergleich As String
Dim sSaldenVergleichSchwellenwert As String
Dim sVorhandenInAZNichtInVZ As String
dim sVorhandenInVZNichtInAZ as string

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
Dim VOBR_BUCHUNGSKATEGORIE_BV_AKT	as string
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
Dim VOBR_BUCHUNGSKATEGORIE_BV_VORH	as string

' Dialog
Dim sAbsDiff As String
Dim sPercDiff As String
dim iLogicalConnection as integer
dim bAbsDiffCheckbox as boolean
dim bPercDiffCheckbox as boolean

dim sEqnForDifferences as string
dim sEqnForAbsDiff as string
dim sEqnForPercDiff as string
Dim sLogicalConnection As String

Dim A_Checked As Boolean
Dim P_Checked As Boolean
Dim E_Checked As Boolean
Dim V_Checked As Boolean
dim empty_Checked as boolean

dim bFilterForPosition as boolean

dim sPositionEqn as string

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
	Set oParameters = SmartContext.Parameters

	'Set ExecutionStatus (failure at the beginning).
	SmartContext.ExecutionStatus =EXEC_STATUS_FAILED

	oLog.LogMessage "Routine Name: " & SmartContext.TestName
	oLog.LogMessage "Routine Version: " & SmartContext.TestVersion
	oLog.LogMessage "Execution Time Start: " & Now()
	
SetCheckpoint "Get Project Parameters"
oLog.LogMessage m_checkpointName
	sInputFile = SmartContext.PrimaryInputFile
	Call GetTags() ' 27.07.2022
		' 25.07.2022 AS
	' positon filter, get parameter, TRUE = function is used alone, FALSE = function ist combined with another function -> adds " .AND. (" and ")"
	'---------------------------------------------------------------------------------------
	SetCheckpoint "get Dialog Parameter"
	Call CreateEQNFromDialogParameter(TRUE)
	Call GetDialogParameter() ' 02.08.2022
	'---------------------------------------------------------------------------------------

'-----------------------------------------------------------------------------------------
' Funtion Calls
'-----------------------------------------------------------------------------------------
SetCheckpoint "Begin of Functions"
	Call analysis(sInputFile)
	Call registerResult(sSaldenVergleich, FINAL_RESULT)
	'If sEqnForDifferences <> "" Then Call registerResult(sSaldenVergleichSchwellenwert, FINAL_RESULT)
	Call registerResult(sSaldenVergleichSchwellenwert, FINAL_RESULT)
	call registerResult(sVorhandenInAZNichtInVZ, FINAL_RESULT)
	call registerResult(sVorhandenInVZNichtInAZ, FINAL_RESULT)
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
	Set oParameters = Nothing
	
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
	'27.07.2022
	'task.AddFieldToInc "KONTO"
	'task.AddFieldToInc "UNR"
	'task.AddFieldToInc "RAHMENNR"
	'task.AddFieldToInc "BEZEICHNUNG"
	'task.AddFieldToInc "POSITIONEN"
	'task.AddFieldToInc "OBR_SALDO"
	'task.AddFieldToInc "BESCHREIBUNG_PRIMÄRE_POSITION"
	'task.AddFieldToInc "SYSTEMPOSITION"
	'task.AddFieldToInc "KONTO1"
	'task.AddFieldToInc "UNR1"
	'task.AddFieldToInc "RAHMENNR1"
	'task.AddFieldToInc "BEZEICHNUNG1"
	'task.AddFieldToInc "POSITIONEN1"
	'task.AddFieldToInc "OBR_SALDO1"
	'task.AddFieldToInc "BESCHREIBUNG_PRIMÄRE_POSITION1"
	'task.AddFieldToInc "SYSTEMPOSITION1"
	
	task.AddFieldToInc VOBR_KONTO_AKT
	task.AddFieldToInc VOBR_UNR_AKT
	task.AddFieldToInc VOBR_RAHMENNR_AKT
	task.AddFieldToInc VOBR_BEZEICHNUNG_AKT
	task.AddFieldToInc VOBR_POSITIONEN_AKT
	task.AddFieldToInc VOBR_OBR_SALDO_AKT
	task.AddFieldToInc VOBR_BESCHREIBUNG_PRIMAERE_POSITION_AKT
	task.AddFieldToInc VOBR_SYSTEMPOSITION_AKT
	task.AddFieldToInc VOBR_BUCHUNGSKATEGORIE_BV_AKT
	task.AddFieldToInc VOBR_POSITION_SHORT_AKT
	'---------------------------------------------------------
	task.AddFieldToInc VOBR_KONTO_VORH
	task.AddFieldToInc VOBR_UNR_VORH
	task.AddFieldToInc VOBR_RAHMENNR_VORH
	task.AddFieldToInc VOBR_BEZEICHNUNG_VORH
	task.AddFieldToInc VOBR_POSITIONEN_VORH
	task.AddFieldToInc VOBR_OBR_SALDO_VORH
	task.AddFieldToInc VOBR_BESCHREIBUNG_PRIMAERE_POSITION_VORH
	task.AddFieldToInc VOBR_SYSTEMPOSITION_VORH
	task.AddFieldToInc VOBR_BUCHUNGSKATEGORIE_BV_VORH
	task.AddFieldToInc VOBR_POSITION_SHORT_VORH
	
	sSaldenVergleich = oSC.UniqueFileName("Vergleich Kontensalden.IMD", FINAL_RESULT)
	task.AddExtraction sSaldenVergleich, "", sPositionEqn
	task.CreateVirtualDatabase = False
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sSaldenVergleich & " created."
SetCheckpoint "analysis, Checkpoint 1.1"
	Set db = Client.OpenDatabase(sSaldenVergleich)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "VERÄNDERUNG_SALDO_BERECHNET"
	field.Description = ""
	field.Type = WI_NUM_FIELD
	'field.Equation = "OBR_SALDO - OBR_SALDO1" 27.07.2022
	field.Equation = VOBR_OBR_SALDO_AKT & " - " & VOBR_OBR_SALDO_VORH
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
SetCheckpoint "analysis, Checkpoint 1.2"
	field.Name = "VERÄNDERUNG_SALDO_IN_PROZENT"
	field.Description = ""
	field.Type = WI_NUM_FIELD
	'field.Equation = "@if(OBR_SALDO1 = 0; VERÄNDERUNG_SALDO_BERECHNET / 100; VERÄNDERUNG_SALDO_BERECHNET /  OBR_SALDO1 *100)" ' AS 17.12.2020, 27.07.2022
	field.Equation = "@if(" & VOBR_OBR_SALDO_VORH & " = 0; VERÄNDERUNG_SALDO_BERECHNET / 100; VERÄNDERUNG_SALDO_BERECHNET / " & VOBR_OBR_SALDO_VORH & " *100)"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
' 02.08.2022
SetCheckpoint "analysis, Checkpoint 1.3"
	'If sEqnForDifferences <> "" Then
		Set db = Client.OpenDatabase(sSaldenVergleich)
		Set task = db.Extraction	
		task.AddFieldToInc VOBR_KONTO_AKT
		task.AddFieldToInc VOBR_UNR_AKT
		task.AddFieldToInc VOBR_RAHMENNR_AKT
		task.AddFieldToInc VOBR_BEZEICHNUNG_AKT
		task.AddFieldToInc VOBR_POSITIONEN_AKT
		task.AddFieldToInc VOBR_OBR_SALDO_AKT
		task.AddFieldToInc VOBR_BESCHREIBUNG_PRIMAERE_POSITION_AKT
		task.AddFieldToInc VOBR_SYSTEMPOSITION_AKT
		task.AddFieldToInc VOBR_BUCHUNGSKATEGORIE_BV_AKT
		task.AddFieldToInc VOBR_POSITION_SHORT_AKT
		'---------------------------------------------------------
		task.AddFieldToInc VOBR_KONTO_VORH
		task.AddFieldToInc VOBR_UNR_VORH
		task.AddFieldToInc VOBR_RAHMENNR_VORH
		task.AddFieldToInc VOBR_BEZEICHNUNG_VORH
		task.AddFieldToInc VOBR_POSITIONEN_VORH
		task.AddFieldToInc VOBR_OBR_SALDO_VORH
		task.AddFieldToInc VOBR_BESCHREIBUNG_PRIMAERE_POSITION_VORH
		task.AddFieldToInc VOBR_SYSTEMPOSITION_VORH
		task.AddFieldToInc VOBR_BUCHUNGSKATEGORIE_BV_VORH
		task.AddFieldToInc VOBR_POSITION_SHORT_VORH
		
		task.AddFieldToInc "VERÄNDERUNG_SALDO_BERECHNET"
		task.AddFieldToInc "VERÄNDERUNG_SALDO_IN_PROZENT"
		
		if bAbsDiffCheckbox then
			task.AddKey "VERÄNDERUNG_SALDO_BERECHNET", "D"
		ElseIf bPercDiffCheckbox Then
			task.AddKey "VERÄNDERUNG_SALDO_IN_PROZENT", "D"
		end if
		
		sSaldenVergleichSchwellenwert = oSC.UniqueFileName("Vergleich Kontensalden Veränderung über Schwellenwert.IMD", FINAL_RESULT)
		task.AddExtraction sSaldenVergleichSchwellenwert, "", sEqnForDifferences
		task.CreateVirtualDatabase = False
		task.PerformTask 1, db.Count
		db.Close
		Set task = Nothing
		Set db = Nothing
	'End If
oLog.LogMessage sSaldenVergleichSchwellenwert & " created."
SetCheckpoint "analysis, Checkpoint 2.0"
	Set db = Client.OpenDatabase(sBase)
	Set task = db.Extraction
	'27.07.2022
	'task.AddFieldToInc "KONTO"
	'task.AddFieldToInc "UNR"
	'task.AddFieldToInc "RAHMENNR"
	'task.AddFieldToInc "BEZEICHNUNG"
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
	'task.AddFieldToInc "POSITION_SHORT"
	'task.AddKey "KONTO", "A"
	
	task.AddFieldToInc VOBR_KONTO_AKT
	task.AddFieldToInc VOBR_UNR_AKT
	task.AddFieldToInc VOBR_RAHMENNR_AKT
	task.AddFieldToInc VOBR_BEZEICHNUNG_AKT
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
	task.AddFieldToInc VOBR_POSITION_SHORT_AKT
	task.AddFieldToInc VOBR_BUCHUNGSKATEGORIE_BV_AKT
	task.AddKey VOBR_KONTO_AKT, "A"
	
	sVorhandenInAZNichtInVZ = oSC.UniqueFileName("OBR Konten im aktuellen Zeitraum ohne Konten im Vorzeitraum.IMD", FINAL_RESULT)
	'task.AddExtraction sVorhandenInAZNichtInVZ, "", "KONTO1 == """"" 27.07.2022
	task.AddExtraction sVorhandenInAZNichtInVZ, "", VOBR_KONTO_VORH & " == """""
	task.CreateVirtualDatabase = False
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sVorhandenInAZNichtInVZ & " created."
SetCheckpoint "analysis, Checkpoint 2.1"
	Set db = Client.OpenDatabase(sBase)
	Set task = db.Extraction
	'27.07.2022
	'task.AddFieldToInc "KONTO1"
	'task.AddFieldToInc "UNR1"
	'task.AddFieldToInc "RAHMENNR1"
	'task.AddFieldToInc "BEZEICHNUNG1"
	'task.AddFieldToInc "WKZ1"
	'task.AddFieldToInc "NABU_NR1"
	'task.AddFieldToInc "POSITIONEN1"
	'task.AddFieldToInc "AZ9_SALDO1"
	'task.AddFieldToInc "OBR_SALDO1"
	'task.AddFieldToInc "AZ9_SALDO_IN_WÄHR1"
	'task.AddFieldToInc "BV_SCHL1"
	'task.AddFieldToInc "BESCHREIBUNG_PRIMÄRE_POSITION1"
	'task.AddFieldToInc "SYSTEMPOSITION1"
	'task.AddFieldToInc "ART1"
	'task.AddFieldToInc "GUV_MKML1"
	'task.AddFieldToInc "STEUERPOS_AKT_JAHR1"
	'task.AddFieldToInc "STEUERL_LAT1"
	'task.AddFieldToInc "STEUERL_LAT21"
	'task.AddFieldToInc "POSITION_AKT_JAHR1"
	'task.AddFieldToInc "POSITION_VORJAHR1"
	'task.AddFieldToInc "ÄNDERUNG1"
	'task.AddFieldToInc "ERÖFFNUNG1"
	'task.AddFieldToInc "AUFLÖSUNG1"
	'task.AddFieldToInc "POSITION_SHORT1"
	'task.AddKey "KONTO1", "A"
	
	task.AddFieldToInc VOBR_KONTO_VORH
	task.AddFieldToInc VOBR_UNR_VORH
	task.AddFieldToInc VOBR_RAHMENNR_VORH
	task.AddFieldToInc VOBR_BEZEICHNUNG_VORH
	task.AddFieldToInc VOBR_WKZ_VORH
	task.AddFieldToInc VOBR_NABU_NR_VORH
	task.AddFieldToInc VOBR_POSITIONEN_VORH
	task.AddFieldToInc VOBR_AZ9_SALDO_VORH
	task.AddFieldToInc VOBR_OBR_SALDO_VORH
	task.AddFieldToInc VOBR_AZ9_SALDO_IN_WAEHR_VORH
	task.AddFieldToInc VOBR_BV_SCHL_VORH
	task.AddFieldToInc VOBR_BESCHREIBUNG_PRIMAERE_POSITION_VORH
	task.AddFieldToInc VOBR_SYSTEMPOSITION_VORH
	task.AddFieldToInc VOBR_ART_VORH
	task.AddFieldToInc VOBR_GUV_MKML_VORH
	task.AddFieldToInc VOBR_STEUERPOS_AKT_JAHR_VORH
	task.AddFieldToInc VOBR_STEUERL_LAT_VORH
	task.AddFieldToInc VOBR_STEUERL_LAT2_VORH
	task.AddFieldToInc VOBR_POSITION_AKT_JAHR_VORH
	task.AddFieldToInc VOBR_POSITION_VORJAHR_VORH
	task.AddFieldToInc VOBR_AENDERUNG_VORH
	task.AddFieldToInc VOBR_EROEFFNUNG_VORH
	task.AddFieldToInc VOBR_AUFLOESUNG_VORH
	task.AddFieldToInc VOBR_POSITION_SHORT_VORH
	task.AddFieldToInc VOBR_BUCHUNGSKATEGORIE_BV_VORH
	task.AddKey VOBR_KONTO_VORH, "A"
	
	sVorhandenInVZNichtInAZ = oSC.UniqueFileName("OBR Konten im Vorzeitraum ohne Konten im aktuellen Zeitraum.IMD", FINAL_RESULT)
	'task.AddExtraction sVorhandenInVZNichtInAZ, "", "KONTO == """"" 27.07.2022
	task.AddExtraction sVorhandenInVZNichtInAZ, "", VOBR_KONTO_AKT & " == """""
	task.CreateVirtualDatabase = False
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sVorhandenInVZNichtInAZ & " created."
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
		Set oParameters = Nothing
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
		Set oParameters = Nothing
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
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
' AS 02.08.2022
' gets parameter from dialog and creates filter for extraction
function GetDialogParameter
dim aLogicalConnector(1) as string
aLogicalConnector(0) = " .OR. "
aLogicalConnector(1) = " .AND. "
	' get parameter
	If oParameters.Contains("sTBAbsDiff") Then sAbsDiff = oParameters.Item("sTBAbsDiff").Value
	If oParameters.Contains("sTBPercDiff") Then sPercDiff = oParameters.Item("sTBPercDiff").Value
	if oParameters.Contains("sCBLogicalConnection") then iLogicalConnection = oParameters.Item("sCBLogicalConnection").Selection
	If oParameters.Contains("sCheckBAbsDiff") Then bAbsDiffCheckbox = oParameters.Item("sCheckBAbsDiff").Checked
	If oParameters.Contains("sCheckBPercDiff") Then bPercDiffCheckbox = oParameters.Item("sCheckBPercDiff").Checked
	' create filter
	'If bAbsDiffCheckbox Then sEqnForAbsDiff = "@abs(VERÄNDERUNG_SALDO_BERECHNET) > " & sAbsDiff 06.12.2022
	If bAbsDiffCheckbox Then sEqnForAbsDiff = "@abs(VERÄNDERUNG_SALDO_BERECHNET) > @abs(" & sAbsDiff & ")"
	'If bPercDiffCheckbox Then sEqnForPercDiff = "@abs(VERÄNDERUNG_SALDO_IN_PROZENT) > " & sPercDiff 06.12.2022
	If bPercDiffCheckbox Then sEqnForPercDiff = "@abs(VERÄNDERUNG_SALDO_IN_PROZENT) > @abs(" & sPercDiff & ")"
	if bAbsDiffCheckbox and bPercDiffCheckbox then sLogicalConnection = aLogicalConnector(iLogicalConnection)
	sEqnForDifferences = sEqnForAbsDiff & sLogicalConnection & sEqnForPercDiff
End Function
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
' 25.07.2022 AS
' positon filter, get parameter
Function CreateEQNFromDialogParameter(ByVal bFunctionStandAlone As Boolean)
	If oParameters.Contains("sCB_A") Then A_Checked = oParameters.Item("sCB_A").Checked
	if oParameters.Contains("sCB_P") then P_Checked = oParameters.Item("sCB_P").Checked
	if oParameters.Contains("sCB_E") then E_Checked = oParameters.Item("sCB_E").Checked
	if oParameters.Contains("sCB_V") then V_Checked = oParameters.Item("sCB_V").Checked
	if oParameters.Contains("sCB_empty") then empty_Checked = oParameters.Item("sCB_empty").Checked
	
	SetCheckpoint "create equation"
	
	sPositionEqn = ""
	
	if A_Checked then
		'sPositionEqn = "(@left(" & VOBR_POSITION_SHORT_AKT & "; 1) = ""A"" .OR. @left(" & VOBR_POSITION_SHORT_VORH & "; 1) = ""A"") .OR. " 06.12.2022
		sPositionEqn = "@left(" & VOBR_POSITION_SHORT_AKT & "; 1) = ""A"" .OR. "
		bFilterForPosition = TRUE
	end if
	if P_Checked then
		'sPositionEqn = sPositionEqn & "(@left(" & VOBR_POSITION_SHORT_AKT & "; 1) = ""P"" .OR. @left(" & VOBR_POSITION_SHORT_VORH & "; 1) = ""P"") .OR. " 06.12.2022
		sPositionEqn = sPositionEqn & "@left(" & VOBR_POSITION_SHORT_AKT & "; 1) = ""P"" .OR. "
		bFilterForPosition = TRUE
	end if
	If E_Checked Then
		'sPositionEqn = sPositionEqn & "(@left(" & VOBR_POSITION_SHORT_AKT & "; 1) = ""E"" .OR. @left(" & VOBR_POSITION_SHORT_VORH & "; 1) = ""E"") .OR. " 06.12.2022
		sPositionEqn = sPositionEqn & "@left(" & VOBR_POSITION_SHORT_AKT & "; 1) = ""E"" .OR. "
		bFilterForPosition = TRUE
	end if
	if V_Checked then
		'sPositionEqn = sPositionEqn & "(@left(" & VOBR_POSITION_SHORT_AKT & "; 1) = ""V"" .OR. @left(" & VOBR_POSITION_SHORT_VORH & "; 1) = ""V"")" 06.12.2022
		sPositionEqn = sPositionEqn & "@left(" & VOBR_POSITION_SHORT_AKT & "; 1) = ""V"" .OR. "
		bFilterForPosition = TRUE
	end if
	if empty_Checked then ' 06.12.2022
		sPositionEqn = sPositionEqn & "@left(" & VOBR_POSITION_SHORT_AKT & "; 1) = """""
		bFilterForPosition = TRUE
	end if
	
	If bFilterForPosition Then
		If Right(sPositionEqn, 6) = " .OR. " Then sPositionEqn = Left(sPositionEqn, Len(sPositionEqn) - 6)		
		if bFunctionStandAlone = FALSE then
			sPositionEqn = " .AND. (" & sPositionEqn
			sPositionEqn = sPositionEqn & ")"
		end if
	end if
End Function

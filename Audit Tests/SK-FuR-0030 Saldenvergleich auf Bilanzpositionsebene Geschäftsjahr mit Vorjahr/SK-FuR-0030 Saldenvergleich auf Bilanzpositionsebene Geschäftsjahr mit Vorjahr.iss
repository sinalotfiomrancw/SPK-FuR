'-------------------------------------------------------------------------------------
' Title:		SKA-FuR-0030 Saldenvergleich auf Bilanzpositionsebene Geschäftsjahr mit Vorjahr
' CIR:		SKA_FuR
' Customer:	Sparkassen
' Created by:	AS
' Created on:	09.11.2020
' Version:		1.00
'-------------------------------------------------------------------------------------
' Decription:	
'-------------------------------------------------------------------------------------
' Files:		Requires 1 Input file(s)
'			- "Vergleich Bilanzpositionen inkl Umsetzungen " & sAktuelleGJAHR & " zu " & sVorherigesGJAHR &".IMD"
'-------------------------------------------------------------------------------------
' Change History
'-------------------------------------------------------------------------------------
' Changed by:	AS
' Changed on:	07.12.2020
' Requested by:	SK
' Comment:		solved the issue with a zero devision
'------------------
' Changed by:	AS
' Changed on:	17.12.2020
' Requested by:	SK
' Comment:		changed SYSTEMPOSITION mit POS
'------------------
' Changed by:	AS
' Changed on:	11.02.2021
' Requested by:	SK
' Comment:		excluded special POS from analysis
'------------------
' Changed by:	AS
' Changed on:	18.02.2021
' Requested by:	SK
' Comment:		Importroutine changed field to join to BILANZPOSITION_Year. Change Filter to use that column. Change column for extraction
'------------------
' Changed by:	AS
' Changed on:	18.11.2021
' Requested by:	SK
' Comment:		simplify filter, add filter to delete records not in current year but in previous year, added description columns for BILANZPOSITION
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

Dim sAktuelleGJAHR As String
dim sVorherigesGJAHR as string

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

' Temp
dim sFilterEQN as string 'AS 18.11.2021

'ColumnNames
Dim VBIL_POS_OBR_AKT as string
Dim VBIL_ANZ_POS_OBR_AKT as string
Dim VBIL_OBR_SALDO_SUMME_AKT as string
Dim VBIL_BESCHREIBUNG_PRIMAERE_POSITION_AKT as string
Dim VBIL_POS_UMSETZUNGEN_AKT as string
Dim VBIL_ANZ_POS_UMSETZUNGEN_AKT as string
Dim VBIL_BETRAG_MIT_VORZEICHEN_SUMME_AKT as string
Dim VBIL_BILANZPOSITION_AKT as string
Dim VBIL_OBR_SALDO_UND_UMSETZUNGEN_AKT as string
dim BILANZPOS_BESCHREIBUNG_AKT as string ' is not tagged, will be filled by main function
'--------------------------------------------------------------------------------------------------------------------
Dim VBIL_POS_OBR_VORH as string
Dim VBIL_ANZ_POS_OBR_VORH as string
Dim VBIL_OBR_SALDO_SUMME_VORH as string
Dim VBIL_BESCHREIBUNG_PRIMAERE_POSITION_VORH as string
Dim VBIL_POS_UMSETZUNGEN_VORH as string
Dim VBIL_ANZ_POS_UMSETZUNGEN_VORH as string
Dim VBIL_BETRAG_MIT_VORZEICHEN_SUMME_VORH as string
Dim VBIL_BILANZPOSITION_VORH as string
Dim VBIL_OBR_SALDO_UND_UMSETZUNGEN_VORH as string
dim BILANZPOS_BESCHREIBUNG_VORH as string ' is not tagged, will be filled by main function

' Dialog
Dim sAbsDiff As String
Dim sPercDiff As String
dim iLogicalConnection as integer
dim bAbsDiffCheckbox as boolean
dim bPercDiffCheckbox as boolean

dim sEqnForDifferences as string
dim sEqnForAbsDiff as string
dim sEqnForPercDiff as string
dim sLogicalConnection as string

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
	'sAktuelleGJAHR = oPara.Get4Project ("sAktuelleGJAHR") 27.07.2022
	'sVorherigesGJAHR = oPara.Get4Project ("sVorherigesGJAHR") 27.07.2022
	 ' 27.07.2022
	Call GetTags()
			' 25.07.2022 AS
	' positon filter, get parameter, TRUE = function is used alone, FALSE = function ist combined with another function -> adds " .AND. (" and ")"
	'---------------------------------------------------------------------------------------
	SetCheckpoint "get Dialog Parameter"
	Call CreateEQNFromDialogParameter(FALSE)
	sAktuelleGJAHR = right(VBIL_POS_OBR_AKT, 2)
	sVorherigesGJAHR = right(VBIL_POS_OBR_VORH, 2)
	BILANZPOS_BESCHREIBUNG_AKT = "BILANZPOS_BESCHREIBUNG_" & sAktuelleGJAHR
	BILANZPOS_BESCHREIBUNG_VORH = "BILANZPOS_BESCHREIBUNG_" & sVorherigesGJAHR
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
	Set oTM = nothing
	Set oParameters = Nothing
	
	Exit Sub
ErrorHandler:
	Call LogSmartAnalyzerError("")
End Sub
'-------------------------------------------------------------------------------------------------------------
' Analyse
'-------------------------------------------------------------------------------------------------------------
Function analysis(ByVal sBase As String)
SetCheckpoint "analysis, Checkpoint 1.0" 'AS 18.11.2021
	' 27.07.2022
	'Set db = Client.OpenDatabase(sBase)
	'Set task = db.TableManagement
	'Set field = db.TableDef.NewField
	'field.Name = "BILANZPOS_BESCHREIBUNG"
	'field.Description = ""
	'field.Type = WI_VIRT_CHAR
	'field.Equation = "@compif(@mid(BILANZPOSITION_" & sAktuelleGJAHR & ";2;1) = ""A"";""Aktiva"";@Mid(BILANZPOSITION_" & sAktuelleGJAHR & ";2;1) = ""P"";" & _
	'				"""Passiva"";@Mid(BILANZPOSITION_" & sAktuelleGJAHR & ";2;1) = ""E"";""Ertrag (GuV)"";@Mid(BILANZPOSITION_" & sAktuelleGJAHR & ";2;1) = ""V"";" & _
	'				"""Verlust/Aufwand (GuV)"") + "" "" + @Mid(BILANZPOSITION_" & sAktuelleGJAHR & ";3;2)"
	'field.Length = 25
	'task.AppendField field
	'task.PerformTask
	
	Set db = Client.OpenDatabase(sBase)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = BILANZPOS_BESCHREIBUNG_AKT
	field.Description = ""
	field.Type = WI_CHAR_FIELD
	field.Equation = "@compif(@mid(" & VBIL_BILANZPOSITION_AKT & ";2;1) = ""A"";""Aktiva"";@Mid(" & VBIL_BILANZPOSITION_AKT & ";2;1) = ""P"";" & _
					"""Passiva"";@Mid(" & VBIL_BILANZPOSITION_AKT & ";2;1) = ""E"";""Ertrag (GuV)"";@Mid(" & VBIL_BILANZPOSITION_AKT & ";2;1) = ""V"";" & _
					"""Verlust/Aufwand (GuV)"") + "" "" + @Mid(" & VBIL_BILANZPOSITION_AKT & ";3;2)"
	field.Length = 25
	task.AppendField field
	task.PerformTask
	
SetCheckpoint "analysis, Checkpoint 1.1" 'AS 18.11.2021
	'27.07.2022
	'field.Name = "BILANZPOS_BESCHREIBUNG1"
	'field.Description = ""
	'field.Type = WI_VIRT_CHAR
	'field.Equation = "@compif(@mid(BILANZPOSITION_" & sVorherigesGJAHR & ";2;1) = ""A"";""Aktiva"";@Mid(BILANZPOSITION_" & sVorherigesGJAHR & ";2;1) = ""P"";" & _
	'				"""Passiva"";@Mid(BILANZPOSITION_" & sVorherigesGJAHR & ";2;1) = ""E"";""Ertrag (GuV)"";@Mid(BILANZPOSITION_" & sVorherigesGJAHR & ";2;1) = ""V"";" & _
	'				"""Verlust/Aufwand (GuV)"") + "" "" + @Mid(BILANZPOSITION_" & sVorherigesGJAHR & ";3;2)"
	'field.Length = 25
	'task.AppendField field
	'task.PerformTask
	'Set task = Nothing
	'Set db = Nothing
	'Set field = Nothing
	
	field.Name = BILANZPOS_BESCHREIBUNG_VORH
	field.Description = ""
	field.Type = WI_CHAR_FIELD
	field.Equation = "@compif(@mid(" & VBIL_BILANZPOSITION_VORH & ";2;1) = ""A"";""Aktiva"";@Mid(" & VBIL_BILANZPOSITION_VORH & ";2;1) = ""P"";" & _
					"""Passiva"";@Mid(" & VBIL_BILANZPOSITION_VORH & ";2;1) = ""E"";""Ertrag (GuV)"";@Mid(" & VBIL_BILANZPOSITION_VORH & ";2;1) = ""V"";" & _
					"""Verlust/Aufwand (GuV)"") + "" "" + @Mid(" & VBIL_BILANZPOSITION_VORH & ";3;2)"
	field.Length = 25
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
	
SetCheckpoint "analysis, Checkpoint 2.0"
	'27.07.2022
	'Set db = Client.OpenDatabase(sBase)
	'Set task = db.Extraction
	'task.AddFieldToInc "BILANZPOSITION_" & sAktuelleGJAHR
	'task.AddFieldToInc "BILANZPOS_BESCHREIBUNG"
	'task.AddFieldToInc "POS_OBR_" & sAktuelleGJAHR
	'task.AddFieldToInc "ANZ_POS_OBR_" & sAktuelleGJAHR
	'task.AddFieldToInc "OBR_SALDO_SUMME"
	'task.AddFieldToInc "POS_UMSETZUNGEN_" & sAktuelleGJAHR
	'task.AddFieldToInc "ANZ_POS_UMSETZUNGEN_" & sAktuelleGJAHR
	'task.AddFieldToInc "BETRAG_MIT_VORZEICHEN_SUMME"
	'task.AddFieldToInc "OBR_SALDO_UND_UMSETZUNGEN"
	'task.AddFieldToInc "BILANZPOSITION_" & sVorherigesGJAHR
	'task.AddFieldToInc "BILANZPOS_BESCHREIBUNG1"
	'task.AddFieldToInc "POS_OBR_" & sVorherigesGJAHR
	'task.AddFieldToInc "ANZ_POS_OBR_" & sVorherigesGJAHR
	'task.AddFieldToInc "OBR_SALDO_SUMME1"
	'task.AddFieldToInc "POS_UMSETZUNGEN_" & sVorherigesGJAHR
	'task.AddFieldToInc "ANZ_POS_UMSETZUNGEN_" & sVorherigesGJAHR
	'task.AddFieldToInc "BETRAG_MIT_VORZEICHEN_SUMME1"
	'task.AddFieldToInc "OBR_SALDO_UND_UMSETZUNGEN1"
	'sSaldenVergleich = oSC.UniqueFileName("Vergleich Bilanzpositionssalden.IMD", FINAL_RESULT)
	'' AS 18.02.2021
	''task.AddExtraction sSaldenVergleich, "", "(BILANZPOSITION_" & sAktuelleGJAHR & " <> ""EB00__0000"" .AND. BILANZPOSITION_" & sVorherigesGJAHR & " <> ""EB00__0000"") .AND." & _
	''										"(BILANZPOSITION_" & sAktuelleGJAHR & " <> ""EU00__0000"" .AND. BILANZPOSITION_" & sVorherigesGJAHR & " <> ""EU00__0000"") .AND." & _
	''										"(BILANZPOSITION_" & sAktuelleGJAHR & " <> ""EU99__000000"" .AND. BILANZPOSITION_" & sVorherigesGJAHR & " <> ""EU99__000000"") .AND." & _
	''										"(BILANZPOSITION_" & sAktuelleGJAHR & " <> ""EU99__050000"" .AND. BILANZPOSITION_" & sVorherigesGJAHR & " <> ""EU99__050000"") .AND." & _
	''										"(BILANZPOSITION_" & sAktuelleGJAHR & " <> ""EX99__000000"" .AND. BILANZPOSITION_" & sVorherigesGJAHR & " <> ""EX99__000000"") .AND." & _
	''										"(BILANZPOSITION_" & sAktuelleGJAHR & " <> ""EY99__000000"" .AND. BILANZPOSITION_" & sVorherigesGJAHR & " <> ""EY99__000000"") .AND." & _
	''										"(BILANZPOSITION_" & sAktuelleGJAHR & " <> ""EA90__000000"" .AND. BILANZPOSITION_" & sVorherigesGJAHR & " <> ""EA90__000000"") .AND." & _
	''										"(BILANZPOSITION_" & sAktuelleGJAHR & " <> ""EA90__010000"" .AND. BILANZPOSITION_" & sVorherigesGJAHR & " <> ""EA90__010000"") .AND." & _
	''										"(BILANZPOSITION_" & sAktuelleGJAHR & " <> ""EP15__000000"" .AND. BILANZPOSITION_" & sVorherigesGJAHR & " <> ""EP15__000000"")"
	'' AS 18.11.2021
	'sFilterEQN = ".NOT. @MATCH(BILANZPOSITION_" & sAktuelleGJAHR & ";""EB00__0000"";""EU00__0000"";""EU99__000000"";""EU99__050000"";""EX99__000000"";""EY99__000000"";""EA90__000000"";""EA90__010000"";""EP15__000000"") .AND." & _
	'								".NOT. @MATCH(BILANZPOSITION_" & sVorherigesGJAHR & ";""EB00__0000"";""EU00__0000"";""EU99__000000"";""EU99__050000"";""EX99__000000"";""EY99__000000"";""EA90__000000"";""EA90__010000"";""EP15__000000"") .AND." & _
	'								"(POS_OBR_" & sAktuelleGJAHR & " <> """" .OR. POS_UMSETZUNGEN_" & sAktuelleGJAHR & " <> """") .AND. " & _
	'								".NOT. (OBR_SALDO_UND_UMSETZUNGEN = 0 .AND. OBR_SALDO_UND_UMSETZUNGEN1 = 0)"
	'task.AddExtraction sSaldenVergleich, "", sFilterEQN
	'task.CreateVirtualDatabase = False
	'task.PerformTask 1, db.Count
	'db.Close
	'Set task = Nothing
	'Set db = Nothing
	
	Set db = Client.OpenDatabase(sBase)
	Set task = db.Extraction
	task.AddFieldToInc VBIL_BILANZPOSITION_AKT
	task.AddFieldToInc BILANZPOS_BESCHREIBUNG_AKT
	task.AddFieldToInc VBIL_POS_OBR_AKT
	task.AddFieldToInc VBIL_ANZ_POS_OBR_AKT
	task.AddFieldToInc VBIL_OBR_SALDO_SUMME_AKT
	task.AddFieldToInc VBIL_POS_UMSETZUNGEN_AKT
	task.AddFieldToInc VBIL_ANZ_POS_UMSETZUNGEN_AKT
	task.AddFieldToInc VBIL_BETRAG_MIT_VORZEICHEN_SUMME_AKT
	task.AddFieldToInc VBIL_OBR_SALDO_UND_UMSETZUNGEN_AKT
	'-----------------------------------------------------------------------------
	task.AddFieldToInc VBIL_BILANZPOSITION_VORH
	task.AddFieldToInc BILANZPOS_BESCHREIBUNG_VORH
	task.AddFieldToInc VBIL_POS_OBR_VORH
	task.AddFieldToInc VBIL_ANZ_POS_OBR_VORH
	task.AddFieldToInc VBIL_OBR_SALDO_SUMME_VORH
	task.AddFieldToInc VBIL_POS_UMSETZUNGEN_VORH
	task.AddFieldToInc VBIL_ANZ_POS_UMSETZUNGEN_VORH
	task.AddFieldToInc VBIL_BETRAG_MIT_VORZEICHEN_SUMME_VORH
	task.AddFieldToInc VBIL_OBR_SALDO_UND_UMSETZUNGEN_VORH
	sSaldenVergleich = oSC.UniqueFileName("Vergleich Bilanzpositionssalden.IMD", FINAL_RESULT)
	sFilterEQN = ".NOT. @MATCH(" & VBIL_BILANZPOSITION_AKT & ";""EB00__0000"";""EU00__0000"";""EU99__000000"";""EU99__050000"";""EX99__000000"";""EY99__000000"";""EA90__000000"";""EA90__010000"";""EP15__000000"") .AND." & _
									".NOT. @MATCH(" & VBIL_BILANZPOSITION_VORH & ";""EB00__0000"";""EU00__0000"";""EU99__000000"";""EU99__050000"";""EX99__000000"";""EY99__000000"";""EA90__000000"";""EA90__010000"";""EP15__000000"") .AND." & _
									"(" & VBIL_POS_OBR_AKT & " <> """" .OR. " & VBIL_POS_OBR_VORH & " <> """") .AND. " & _
									".NOT. (" & VBIL_OBR_SALDO_UND_UMSETZUNGEN_AKT & " = 0 .AND. " & VBIL_OBR_SALDO_UND_UMSETZUNGEN_VORH & " = 0)" & _
									sPositionEqn
	task.AddExtraction sSaldenVergleich, "", sFilterEQN
	task.CreateVirtualDatabase = False
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sSaldenVergleich & " created."
SetCheckpoint "analysis, Checkpoint 2.1"
	Set db = Client.OpenDatabase(sSaldenVergleich)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "VERÄNDERUNG_SALDO_BERECHNET"
	field.Description = ""
	field.Type = WI_NUM_FIELD
	field.Equation = VBIL_OBR_SALDO_UND_UMSETZUNGEN_AKT & " - " & VBIL_OBR_SALDO_UND_UMSETZUNGEN_VORH
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
SetCheckpoint "analysis, Checkpoint 2.2"
	field.Name = "VERÄNDERUNG_SALDO_IN_PROZENT"
	field.Description = ""
	field.Type = WI_NUM_FIELD
	field.Equation = "@if(" & VBIL_OBR_SALDO_UND_UMSETZUNGEN_VORH & " = 0; VERÄNDERUNG_SALDO_BERECHNET / 100; VERÄNDERUNG_SALDO_BERECHNET / " & VBIL_OBR_SALDO_UND_UMSETZUNGEN_VORH & " *100)"
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
		
		task.AddFieldToInc VBIL_BILANZPOSITION_AKT
		task.AddFieldToInc BILANZPOS_BESCHREIBUNG_AKT
		task.AddFieldToInc VBIL_POS_OBR_AKT
		task.AddFieldToInc VBIL_ANZ_POS_OBR_AKT
		task.AddFieldToInc VBIL_OBR_SALDO_SUMME_AKT
		task.AddFieldToInc VBIL_POS_UMSETZUNGEN_AKT
		task.AddFieldToInc VBIL_ANZ_POS_UMSETZUNGEN_AKT
		task.AddFieldToInc VBIL_BETRAG_MIT_VORZEICHEN_SUMME_AKT
		task.AddFieldToInc VBIL_OBR_SALDO_UND_UMSETZUNGEN_AKT
		'-----------------------------------------------------------------------------
		task.AddFieldToInc VBIL_BILANZPOSITION_VORH
		task.AddFieldToInc BILANZPOS_BESCHREIBUNG_VORH
		task.AddFieldToInc VBIL_POS_OBR_VORH
		task.AddFieldToInc VBIL_ANZ_POS_OBR_VORH
		task.AddFieldToInc VBIL_OBR_SALDO_SUMME_VORH
		task.AddFieldToInc VBIL_POS_UMSETZUNGEN_VORH
		task.AddFieldToInc VBIL_ANZ_POS_UMSETZUNGEN_VORH
		task.AddFieldToInc VBIL_BETRAG_MIT_VORZEICHEN_SUMME_VORH
		task.AddFieldToInc VBIL_OBR_SALDO_UND_UMSETZUNGEN_VORH
		
		task.AddFieldToInc "VERÄNDERUNG_SALDO_BERECHNET"
		task.AddFieldToInc "VERÄNDERUNG_SALDO_IN_PROZENT"
		
		If bAbsDiffCheckbox Then
			task.AddKey "VERÄNDERUNG_SALDO_BERECHNET", "D"
		ElseIf bPercDiffCheckbox Then
			task.AddKey "VERÄNDERUNG_SALDO_IN_PROZENT", "D"
		End If
		
		sSaldenVergleichSchwellenwert = oSC.UniqueFileName("Vergleich Bilanzpositionssalden Veränderung über Schwellenwert.IMD", FINAL_RESULT)
		task.AddExtraction sSaldenVergleichSchwellenwert, "", sEqnForDifferences
		task.CreateVirtualDatabase = False
		task.PerformTask 1, db.Count
		db.Close
		Set task = Nothing
		Set db = Nothing
	'End If
oLog.LogMessage sSaldenVergleichSchwellenwert & " created."
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
	
	VBIL_POS_OBR_AKT = oTM.GetFieldForTag(db,"acc!VBIL_POS_OBR_AKT")
	VBIL_ANZ_POS_OBR_AKT = oTM.GetFieldForTag(db,"acc!VBIL_ANZ_POS_OBR_AKT")
	VBIL_OBR_SALDO_SUMME_AKT = oTM.GetFieldForTag(db,"acc!VBIL_OBR_SALDO_SUMME_AKT")
	VBIL_BESCHREIBUNG_PRIMAERE_POSITION_AKT = oTM.GetFieldForTag(db,"acc!VBIL_BESCHREIBUNG_PRIMAERE_POSITION_AKT")
	VBIL_POS_UMSETZUNGEN_AKT = oTM.GetFieldForTag(db,"acc!VBIL_POS_UMSETZUNGEN_AKT")
	VBIL_ANZ_POS_UMSETZUNGEN_AKT = oTM.GetFieldForTag(db,"acc!VBIL_ANZ_POS_UMSETZUNGEN_AKT")
	VBIL_BETRAG_MIT_VORZEICHEN_SUMME_AKT = oTM.GetFieldForTag(db,"acc!VBIL_BETRAG_MIT_VORZEICHEN_SUMME_AKT")
	VBIL_BILANZPOSITION_AKT = oTM.GetFieldForTag(db,"acc!VBIL_BILANZPOSITION_AKT")
	VBIL_OBR_SALDO_UND_UMSETZUNGEN_AKT = oTM.GetFieldForTag(db,"acc!VBIL_OBR_SALDO_UND_UMSETZUNGEN_AKT")
	'--------------------------------------------------------------------------------------------------------------------
	VBIL_POS_OBR_VORH = oTM.GetFieldForTag(db,"acc!VBIL_POS_OBR_VORH")
	VBIL_ANZ_POS_OBR_VORH = oTM.GetFieldForTag(db,"acc!VBIL_ANZ_POS_OBR_VORH")
	VBIL_OBR_SALDO_SUMME_VORH = oTM.GetFieldForTag(db,"acc!VBIL_OBR_SALDO_SUMME_VORH")
	VBIL_BESCHREIBUNG_PRIMAERE_POSITION_VORH = oTM.GetFieldForTag(db,"acc!VBIL_BESCHREIBUNG_PRIMAERE_POSITION_VORH")
	VBIL_POS_UMSETZUNGEN_VORH = oTM.GetFieldForTag(db,"acc!VBIL_POS_UMSETZUNGEN_VORH")
	VBIL_ANZ_POS_UMSETZUNGEN_VORH = oTM.GetFieldForTag(db,"acc!VBIL_ANZ_POS_UMSETZUNGEN_VORH")
	VBIL_BETRAG_MIT_VORZEICHEN_SUMME_VORH = oTM.GetFieldForTag(db,"acc!VBIL_BETRAG_MIT_VORZEICHEN_SUMME_VORH")
	VBIL_BILANZPOSITION_VORH = oTM.GetFieldForTag(db,"acc!VBIL_BILANZPOSITION_VORH")
	VBIL_OBR_SALDO_UND_UMSETZUNGEN_VORH = oTM.GetFieldForTag(db,"acc!VBIL_OBR_SALDO_UND_UMSETZUNGEN_VORH")
	
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
		'sPositionEqn = "(@mid(" & VBIL_POS_OBR_AKT & "; 2; 1) = ""A"" .OR. @mid(" & VBIL_POS_OBR_VORH & "; 2; 1) = ""A"") .OR. " 06.12.2022
		sPositionEqn = "@mid(" & VBIL_POS_OBR_AKT & "; 2; 1) = ""A"" .OR. "
		bFilterForPosition = TRUE
	end if
	if P_Checked then
		'sPositionEqn = sPositionEqn & "(@mid(" & VBIL_POS_OBR_AKT & "; 2; 1) = ""P"" .OR. @mid(" & VBIL_POS_OBR_VORH & "; 2; 1) = ""P"") .OR. " 06.12.2022
		sPositionEqn = sPositionEqn & "@mid(" & VBIL_POS_OBR_AKT & "; 2; 1) = ""P"" .OR. "
		bFilterForPosition = TRUE
	end if
	If E_Checked Then
		'sPositionEqn = sPositionEqn & "(@mid(" & VBIL_POS_OBR_AKT & "; 2; 1) = ""E"" .OR. @mid(" & VBIL_POS_OBR_VORH & "; 2; 1) = ""E"") .OR. " 06.12.2022
		sPositionEqn = sPositionEqn & "@mid(" & VBIL_POS_OBR_AKT & "; 2; 1) = ""E"" .OR. "
		bFilterForPosition = TRUE
	end if
	if V_Checked then
		'sPositionEqn = sPositionEqn & "(@mid(" & VBIL_POS_OBR_AKT & "; 2; 1) = ""V"" .OR. @mid(" & VBIL_POS_OBR_VORH & "; 2; 1) = ""V"")" 06.12.2022
		sPositionEqn = sPositionEqn & "@mid(" & VBIL_POS_OBR_AKT & "; 2; 1) = ""V"" .OR. "
		bFilterForPosition = TRUE
	end if
	if empty_Checked then '06.12.2022
		sPositionEqn = sPositionEqn & "@mid(" & VBIL_POS_OBR_AKT & "; 2; 1) = """""
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

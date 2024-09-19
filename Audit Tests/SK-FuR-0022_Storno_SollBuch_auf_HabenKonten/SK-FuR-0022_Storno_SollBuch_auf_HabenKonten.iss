'-------------------------------------------------------------------------------------
' Title:		SKA_022_Storno_SollBuch_auf_Habenkonten_in_EUR
' CIR:		SKA
' Customer:	Sparkassen
' Created by:	KKR
' Created on:	07.07.2019
' Version:		1.00
'-------------------------------------------------------------------------------------
' Decription:	See detail documentation for further description of the audit test
'-------------------------------------------------------------------------------------
' Result files:	Creates 0 Intermediate Result(s)
'			Creates 1 Final Result(s)
'-------------------------------------------------------------------------------------
' Change History
'-------------------------------------------------------------------------------------
' Changed by:	AS
' Changed on:	18.11.2021
' Requested by:	audicon
' Comment:		adjusted to be used with importroutine which uses audit folders
'------------------
' Changed by:	AS
' Changed on:	21.07.2022
' Requested by:	AG
' Comment:		final result are marked with a flag. this should help finding the files,
' 				if an auditer has to look into the idea files but did not perform the audit test and transfer owner ship is not available
'------------------
' Changed by:	AS
' Changed on:	25.07.2022
' Requested by:	AG
' Comment:		added dialog to filter for positions
'------------------
' Changed by:	AS
' Changed on:	14.09.2022
' Requested by:	AG
' Comment:		changed file to compare
'-------------------------------------------------------------------------------------

' Forces to declare all variables and objects
Option Explicit

' SmartAnalyzer standard constants
' Execution status codes
Const EXEC_STATUS_FAILED As Long = 0
Const EXEC_STATUS_SUCCEEDED As Long = 1
Const EXEC_STATUS_CANCELED As Long = 3

' Result file type codes
Const NOT_A_RESULT As Long = 0			' None
Const INPUT_DATABASE As Long = 1		' Source Table
Const INTERMEDIATE_RESULT As Long = 2	' Intermediate Result
Const FINAL_RESULT As Long = 4			' Final Result
Const NO_REGISTRATION As Long = 8		' No Registration

' IDEA standard variables
Dim db As Object
Dim task As Object
Dim field As Object
Dim table As Object
Dim eqn As String

' SmartAnalyzer standard variables
Dim oMC As Object	' Macro Commands Object
Dim oSC As Object	' Simple Commands Object
Dim oTM As Object	' Task Management Object
Dim oProtectIP As Object	' Object for Protecting the Intellectual Property
Dim oLog As Object	' Logging Object zur Protokollierung von Ausführungen und Fehlern
Dim oResultFile As Object	' Object for registration of result files
Dim oGetResourceString As Object	'Get Strings from Resource File
Dim oParameters As Object ' 25.07.2022 Get Paramters from SA-Dialogs

Dim sAuditFolder As String 'AS 18.11.2021

' Dialog 25.07.2022
Dim A_Checked As Boolean
Dim P_Checked As Boolean
Dim E_Checked As Boolean
Dim V_Checked As Boolean

Dim bFilterForPosition As Boolean

Dim sPositionEqn As String

' tables
dim dbStornoSollAufHaben as string
' Specific variables
' m_checkpointName is used for error logging and this variable has to be kept global!
' The value provided by this variable shall give a clue where an error occurred.
' Remarks: It is set in Sub 'SetCheckpoint'
'          And  used in Sub 'LogSmartAnalyzerError'
Dim m_checkpointName As String ' Check Point
Dim dbNameSource As String 'Source File
Dim dbNameSourceAdditional As String

Dim sLS As String ' List Seperator
Dim sFileExtension As String ' Database Extensions
Dim bPrivateMode As Boolean ' Private Mode for deleting History

' BEGIN INPUT
' ###############################################################################
' Declaration of analysis-specific global variables:

' ###############################################################################
' END INPUT


Sub Main
On Error GoTo ErrorHandler

	SetCheckpoint "Begin of Sub Main()"

	' Initializing global objects:
	Set oLog = SmartContext.Log
	Set oMC = SmartContext.MacroCommands
	Set oSC = SmartContext.MacroCommands.SimpleCommands
	Set oTM = SmartContext.MacroCommands.TagManagement
	Set oProtectIP = SmartContext.MacroCommands.ProtectIP
	Set oGetResourceString = SmartContext.Strings
	Set oParameters = SmartContext.Parameters ' 25.07.2022
	
	oLog.LogMessage "Audit Test Name: " & SmartContext.TestName
	oLog.LogMessage "Audit Test Version: " & SmartContext.TestVersion
	oLog.LogMessage "Execution Time Start: " & Now()
'	SmartContext.Log.LogMessage "Runs on server: {0}", SmartContext.IsServerTask
	
	' Set private mode (disable project overview, delete History in standard tables)
	bPrivateMode = FALSE
	
	' Set execution status to failed before execution:
	SmartContext.ExecutionStatus = EXEC_STATUS_FAILED
	
	SmartContext.ScriptProgress 0, 5
	
	' Source file declaration
	dbNameSource = SmartContext.PrimaryInputFile
	sAuditFolder = oSC.GetDirName(dbNameSource)' AS 18.11.2021
	If sAuditFolder = "\" Then sAuditFolder = ""
	
	' Read file extension:
	' Extension is mandatory for Join and Append
	' UniqueFilename does not need an extension!
	sFileExtension = oSC.DatabaseExtension
		
	' Read list seperator and store in string variable sLS:
	sLS = oSC.ListSeparator
	
	' Check if source file is valid:
	If oSC.FileIsValid(dbNameSource) Then
		SetCheckpoint "Begin of Analysis"
		' Disable project overview:
		oProtectIP.ProjectOverviewOff

		' Register primary input file in SmartAnalyzer:
		Set oResultFile = oSC.CreateResultObject(dbNameSource, INPUT_DATABASE, True, 1)
		SmartContext.TestResultFiles.Add oResultFile
		Set oResultFile = Nothing
		' Count history records in source file:
		Dim lNumberOfHistoryCountsSourceFileStart As Long
		lNumberOfHistoryCountsSourceFileStart = oProtectIP.HistoryCount(dbNameSource)
' BEGIN INPUT
' ##############################################################################
		' Call(s) of specific analysis function(s):
		Call Analysis()  'Aus frühenden PS 12
		Call Analysis2() 'Aus frühenden PS 17
' ##############################################################################
' END INPUT
		' Remove history from source file:
		Dim lNumberOfHistoryCountsSourceFileEnd As Long
		lNumberOfHistoryCountsSourceFileEnd = oProtectIP.HistoryCount(dbNameSource)
		
		
		Dim lNumberOfRecordsToBeRemoved As Long
		lNumberOfRecordsToBeRemoved = lNumberOfHistoryCountsSourceFileEnd - lNumberOfHistoryCountsSourceFileStart
		oProtectIP.RemoveHistoryLast dbNameSource, lNumberOfRecordsToBeRemoved
		
		' Enable project overview:
		oProtectIP.ProjectOverviewOn
		
		SetCheckpoint "End of Analysis"

		SmartContext.ScriptProgress 95, 100
		
		' Set execution status to succeeded after successful execution:
		SmartContext.ExecutionStatus = EXEC_STATUS_SUCCEEDED
	Else
		oLog.LogMessage "Primary input file is not valid. Analysis could not be conducted."
		SmartContext.ExecutionStatus = EXEC_STATUS_FAILED
	End If ' FileIsValid

	oLog.LogMessage "Execution Time End: " & Now()

	' Release of objects:
	Set oGetResourceString = Nothing
	Set oProtectIP = Nothing
	Set oTM = Nothing
	Set oSC = Nothing
	Set oMC = Nothing
	Set oLog = Nothing
	Set oParameters = Nothing ' 25.07.2022
	
	' Regular end of script:
	Exit Sub

ErrorHandler:
	Call LogSmartAnalyzerError("")
End Sub


' ###############################################################################
' # PS früher PS 12 jetzt Ergebniss als PS 21 ab v1.04 zusammengefügt 
' # Local Variables
' ###############################################################################
Function Analysis
' Local Variables
Dim dbName As String
Dim sFieldNameOverallCreditLimit As String
Dim lNumberOfHistoryCountsSourceFileStart As Long
Dim dbBuchungenJeKtoRahmen As String

Dim dbBuchungenJeKtoRahmenGes As String
Dim dbStornoSollAufHabenSummiert As String
dim sUmsaetze as string
Dim dbVariables As String
Dim sGJahr As String
Dim iStichprobe As Integer
Dim dNAGrenze As Double
Dim rs As Object
Dim rec As Object

	'dbBuchungenJeKtoRahmen = sAuditFolder & "-SKA00_Anzahl_Buchungen_je_bebuchten_KtoRahmen_mit_SHK.IMD"
	sUmsaetze = sAuditFolder & "{Umsätze_zu_OBR_Gesamt_mit_Buchungskennzeichen}.IMD"
	'dbVariables = "{Variables}.IMD"
	'Set db = Client.OpenDatabase(dbVariables)
	'Set rs = db.RecordSet
	'rs.ToFirst
	'Set rec = rs.ActiveRecord
	'rs.Next
	'sGJahr = rec.GetCharValue("GJAHR")
	'iStichprobe = rec.GetNumValue("STICHPROBE")
	'dNAGrenze = rec.GetNumValue("NAGRENZE")
	'db.Close
	'Set db = Nothing
	'Set rs = Nothing
	'Set rec = Nothing
	
	' 14.09.2022
	'Set db = Client.OpenDatabase(sUmsaetze)
	'Set task = db.Summarization
	'task.AddFieldToSummarize "RAHMENNR_2STELLIG"
	'task.AddFieldToSummarize "SHK"
	'task.AddFieldToTotal "BETRAG"
	'task.Criteria = "RAHMENNR_2STELLIG <> """"" & sPositionEqn
	'dbBuchungenJeKtoRahmen = oSC.UniqueFileName("-SKA0022_Anzahl_Buchungen_je_bebuchten_KtoRahmen_mit_SHK.IMD")
	'task.OutputDBName = dbBuchungenJeKtoRahmen
	'task.CreatePercentField = False
	'task.StatisticsToInclude = SM_SUM
	'task.DisableProgressNotification = True
	'task.PerformTask
	'db.Close
	'Set task = Nothing
	'Set db = Nothing
	
	' 25.07.2022 AS
	' positon filter, get parameter, TRUE = function is used alone, FALSE = function ist combined with another function -> adds " .AND. (" and ")"
	'---------------------------------------------------------------------------------------
	SetCheckpoint "get Dialog Parameter"
	Call CreateEQNFromDialogParameter(TRUE)
	'---------------------------------------------------------------------------------------
	
	Set db = Client.OpenDatabase(sUmsaetze)
	Set task = db.Summarization
	task.AddFieldToSummarize "RAHMENNR_2STELLIG"
	task.AddFieldToTotal "BETRAG"
	task.Criteria = sPositionEqn
	dbBuchungenJeKtoRahmen = oSC.UniqueFileName(sAuditFolder & "-SKA0022_Anzahl_Buchungen_je_KtoRahmen.IMD")
	task.OutputDBName = dbBuchungenJeKtoRahmen
	task.CreatePercentField = False
	task.StatisticsToInclude = SM_SUM
	task.DisableProgressNotification = True
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	SmartContext.ScriptProgress 6, 40
	lNumberOfHistoryCountsSourceFileStart = oProtectIP.HistoryCount(dbNameSource)
'	Set db = Client.OpenDatabase("dbUmsaetzeOBRManuell")
	
	' 25.07.2022 AS
	' positon filter, get parameter, TRUE = function is used alone, FALSE = function ist combined with another function -> adds " .AND. (" and ")"
	'---------------------------------------------------------------------------------------
	SetCheckpoint "get Dialog Parameter"
	Call CreateEQNFromDialogParameter(FALSE)
	'---------------------------------------------------------------------------------------
	
	'dbName = sAuditFolder & "SK-FuR-0022_Storno_SollBuchungen_auf_HabenKonten.IMD"
	dbStornoSollAufHaben = oSC.UniqueFileName(sAuditFolder & "SK-FuR-0022_Storno_SollBuchungen_auf_HabenKonten.IMD")
	Set db = Client.OpenDatabase(dbNameSource)
	Set task = db.Extraction
	task.IncludeAllFields

	'task.AddExtraction dbName, "","AZ9_SALDO > 0,00 .AND. BETRAG <= 0,00 .AND. ( TEXTSCHLÜSSEL == ""25"" .OR. TEXTSCHLÜSSEL == ""68"" .or. @isini(""Storno"";VERWENDUNGSZWECK)  .OR. @isini(""Korrektur"";VERWENDUNGSZWECK)  .OR.  @isini(""Berichtigung"";VERWENDUNGSZWECK))"
	'task.AddExtraction dbName, "","AZ9_SALDO > 0,00 .AND. BETRAG <= 0,00 .AND. ( TEXTSCHLÜSSEL == ""25"" .OR. TEXTSCHLÜSSEL == ""68"" .or. @isini(""Storno"";VERWENDUNGSZWECK)  .OR. @isini(""Korrektur"";VERWENDUNGSZWECK)  .OR.  @isini(""Berichtigung"";VERWENDUNGSZWECK))" & sPositionEqn ' 25.07.2022
	task.AddExtraction dbStornoSollAufHaben, "","AZ9_SALDO > 0,00 .AND. BETRAG <= 0,00 .AND. ( TEXTSCHLÜSSEL == ""25"" .OR. TEXTSCHLÜSSEL == ""68"" .or. @isini(""Storno"";VERWENDUNGSZWECK)  .OR. @isini(""Korrektur"";VERWENDUNGSZWECK)  .OR.  @isini(""Berichtigung"";VERWENDUNGSZWECK))" & sPositionEqn ' 25.07.2022
	task.CreateVirtualDatabase = False
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
	
				' Result file handling
	'Final Result:
'	Set oResultFile = oSC.CreateResultObject(dbName, FINAL_RESULT, True, 1)
	'Set oResultFile = oSC.CreateResultObject(dbName, INTERMEDIATE_RESULT, True, 2)
	Set oResultFile = oSC.CreateResultObject(dbStornoSollAufHaben, INTERMEDIATE_RESULT, True, 2)
' Short Description (optional)
'	oResultFile.ExtraValues.Add "ShortName", oGetResourceString("ResultFileSKA001ShortName")
' Description
'	oResultFile.ExtraValues.Add "Description", oGetResourceString("ResultFileSKA001Description")
' Columns and sequence (optional)
'	oResultFile.ExtraValues.Add "ReportColumns", ""
' Amount of rows which should be shown in the report
	oResultFile.ExtraValues.Add "RowCount", 20
	SmartContext.TestResultFiles.Add oResultFile
	Set oResultFile = Nothing
	
	Call SetFlagForTable(dbStornoSollAufHaben, TRUE)
	
	'Set db = Client.OpenDatabase(dbName)
	Set db = Client.OpenDatabase(dbStornoSollAufHaben)
	Set task = db.Summarization
	task.AddFieldToSummarize "RAHMENNR_2STELLIG"
	task.AddFieldToTotal "BETRAG"
	task.AddFieldToInc "WKZ"
	task.Criteria = "WKZ==""EUR"""

	dbStornoSollAufHabenSummiert = oSC.UniqueFileName(sAuditFolder & "SK-FuR-0022_Storno_SollBuchungen_auf_HabenKonten_in_EUR.IMD")
	task.OutputDBName = dbStornoSollAufHabenSummiert
	task.CreatePercentField = FALSE
	task.StatisticsToInclude = SM_SUM + SM_MAX + SM_MIN + SM_AVERAGE
	task.DisableProgressNotification = True
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
		
	Set db = Client.OpenDatabase(dbStornoSollAufHabenSummiert)
	If db.Count > 0 Then
		' 14.09.2022
		'Set task = db.TableManagement
		'Set field = db.TableDef.NewField
		'field.Name = "SHK"
		'field.Description = ""
		'field.Type = WI_CHAR_FIELD
		'eqn = """H"""
		'field.Equation = eqn
		'field.Length = 1
		'task.AppendField field
		'task.DisableProgressNotification = True
		'task.PerformTask
		'db.Close
		'Set task = Nothing
		'Set db = Nothing
		'Set field = Nothing
	
		Set db = Client.OpenDatabase(dbStornoSollAufHabenSummiert)
		Set task = db.JoinDatabase
		task.FileToJoin dbBuchungenJeKtoRahmen
		task.AddPFieldToInc "RAHMENNR_2STELLIG"
		task.AddPFieldToInc "ANZ_SAETZE"
		task.AddPFieldToInc "BETRAG_SUMME"
		task.AddPFieldToInc "BETRAG_MAX"
		task.AddPFieldToInc "BETRAG_MIN"
		task.AddPFieldToInc "BETRAG_DURCHSCHNITT"
		task.AddSFieldToInc "ANZ_SAETZE"
		task.AddSFieldToInc "BETRAG_SUMME"
		task.AddMatchKey "RAHMENNR_2STELLIG", "RAHMENNR_2STELLIG", "A"
		'task.AddMatchKey "SHK", "SHK", "A" 14.09.2022
		task.CreateVirtualDatabase = False
		task.DisableProgressNotification = True
		dbStornoSollAufHabenSummiert = oSC.UniqueFileName(sAuditFolder & "@SK-FuR-0022_Storno_SollBuchungen_auf_HabenKonten_in_EUR_summiert.IMD")
		task.PerformTask dbStornoSollAufHabenSummiert, "", WI_JOIN_ALL_IN_PRIM
		db.Close
		Set task = Nothing
		Set db = Nothing
		
		Set db = Client.OpenDatabase(dbStornoSollAufHabenSummiert)
		Set task = db.TableManagement
		Set field = db.TableDef.NewField
		field.Name = "ANZ_SAETZE_GEGEN"
		field.Description = "Anzahl der Datensätze, die für diesen Schlüsselwert gefunden wurden"
		field.Type = WI_NUM_FIELD
		field.Equation = ""
		field.Decimals = 0
		task.ReplaceField "ANZ_SAETZE", field
		field.Name = "BETRAG_SUMME_GEGEN"
		field.Description = ""
		field.Type = WI_NUM_FIELD
		field.Equation = ""
		field.Decimals = 2
		task.ReplaceField "BETRAG_SUMME", field
		field.Name = "ANZ_SAETZE_GESAMT"
		field.Description = "Anzahl der Datensätze, die für diesen Schlüsselwert gefunden wurden"
		field.Type = WI_NUM_FIELD
		field.Equation = ""
		field.Decimals = 0
		task.ReplaceField "ANZ_SAETZE1", field
		field.Name = "BETRAG_SUMME_GESAMT"
		field.Description = ""
		field.Type = WI_NUM_FIELD
		field.Equation = ""
		field.Decimals = 2
		task.ReplaceField "BETRAG_SUMME1", field
		task.DisableProgressNotification = True
		task.PerformTask
		db.Close
		Set task = Nothing
		Set db = Nothing
		Set field = Nothing
		
		Set db = Client.OpenDatabase(dbStornoSollAufHabenSummiert)
		Set task = db.TableManagement
		Set field = db.TableDef.NewField
		field.Name = "QUOTE_ANZAHL"
		field.Description = ""
		field.Type = WI_NUM_FIELD
		'field.Equation = "ANZ_SAETZE_GEGEN / ANZ_SAETZE_GESAMT" 14.09.2022
		field.Equation = "@if(ANZ_SAETZE_GESAMT = 0 ; 0;ANZ_SAETZE_GEGEN / ANZ_SAETZE_GESAMT)"
		field.Decimals = 4
		task.AppendField field
		field.Name = "QUOTE_SUMME"
		field.Description = ""
		field.Type = WI_NUM_FIELD
		field.Equation = "@If(BETRAG_SUMME_GESAMT <> 0; BETRAG_SUMME_GEGEN / BETRAG_SUMME_GESAMT; BETRAG_SUMME_GEGEN)"
		field.Decimals = 4
		task.AppendField field
		task.DisableProgressNotification = True
		task.PerformTask
		db.Close
		Set task = Nothing
		Set db = Nothing
		Set field = Nothing	
		
		Call removeActionField(dbStornoSollAufHabenSummiert,"ANZ_SAETZE_GESAMT")	
	Else
		db.Close
		Set db = Nothing
	End If

	' Result file handling
	'Final Result:
'	Set oResultFile = oSC.CreateResultObject(dbName, FINAL_RESULT, True, 1)
	Set oResultFile = oSC.CreateResultObject(dbStornoSollAufHabenSummiert, FINAL_RESULT, True, 2)
' Short Description (optional)
'	oResultFile.ExtraValues.Add "ShortName", oGetResourceString("ResultFileSKA001ShortName")
' Description
'	oResultFile.ExtraValues.Add "Description", oGetResourceString("ResultFileSKA001Description")
' Columns and sequence (optional)
'	oResultFile.ExtraValues.Add "ReportColumns", ""
' Amount of rows which should be shown in the report
 
	oResultFile.ExtraValues.Add "RowCount", 20
	SmartContext.TestResultFiles.Add oResultFile
	Set oResultFile = Nothing
	
	Call SetFlagForTable(dbStornoSollAufHabenSummiert, TRUE)
	
	If bPrivateMode = TRUE Then
		' Remove History in files created by Analysis
		If oSC.FileExists(dbStornoSollAufHabenSummiert, "") Then oProtectIP.RemoveHistory dbStornoSollAufHabenSummiert
	End If
	
End Function
' ##############################################################################
' END INPUT

' ###############################################################################
' # PS früher PS 17 jetzt Ergebniss als PS 21 ab v1.04 zusammengefügt 
' # Local Variables
' ###############################################################################

Function Analysis2
' Local Variables
Dim dbName As String
Dim sFieldNameOverallCreditLimit As String
Dim lNumberOfHistoryCountsSourceFileStart As Long
Dim dbBuchungenJeKtoRahmenGes As String
Dim dbStornoSollAufHabenSummiert As String
Dim dbVariables As String
Dim sGJahr As String
Dim iStichprobe As Integer
Dim dNAGrenze As Double
Dim rs As Object
Dim rec As Object

	dbBuchungenJeKtoRahmenGes = sAuditFolder & "-SKA00_Anzahl_Buchungen_je_KtoRahmen.IMD"
	'dbVariables = "{Variables}.IMD"
	'Set db = Client.OpenDatabase(dbVariables)
	'Set rs = db.RecordSet
	'rs.ToFirst
	'Set rec = rs.ActiveRecord
	'rs.Next
	'sGJahr = rec.GetCharValue("GJAHR")
	'iStichprobe = rec.GetNumValue("STICHPROBE")
	'dNAGrenze = rec.GetNumValue("NAGRENZE")
	'db.Close
	'Set db = Nothing
	'Set rs = Nothing
	'Set rec = Nothing
	
	SmartContext.ScriptProgress 6, 40
	lNumberOfHistoryCountsSourceFileStart = oProtectIP.HistoryCount(dbNameSource)
'	Set db = Client.OpenDatabase("dbUmsaetzeOBRManuell")
	'dbName = sAuditFolder & "SK-FuR-0022_Storno_SollBuchungen_auf_HabenKonten.IMD"
	'Set db = Client.OpenDatabase(dbName)
	Set db = Client.OpenDatabase(dbStornoSollAufHaben)
	Set task = db.Summarization
	task.AddFieldToSummarize "RAHMENNR_2STELLIG1"
	task.AddFieldToTotal "BETRAG"
	task.AddFieldToInc "WKZ"
	'task.Criteria = "WKZ<>""EUR"""
	task.Criteria = "WKZ<>""EUR""" & sPositionEqn ' 25.07.2022
	
	dbStornoSollAufHabenSummiert = oSC.UniqueFileName(sAuditFolder & "@SK-FuR-0022_Storno_SollBuchungen_auf_HabenKonten_nicht_in_EUR.IMD")
	task.OutputDBName = dbStornoSollAufHabenSummiert
	task.CreatePercentField = FALSE
	task.StatisticsToInclude = SM_SUM + SM_MAX + SM_MIN + SM_AVERAGE
	task.DisableProgressNotification = True
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing

	' Result file handling
	'Final Result:
'	Set oResultFile = oSC.CreateResultObject(dbName, FINAL_RESULT, True, 1)
	Set oResultFile = oSC.CreateResultObject(dbStornoSollAufHabenSummiert, FINAL_RESULT, True, 2)
' Short Description (optional)
'	oResultFile.ExtraValues.Add "ShortName", oGetResourceString("ResultFileSKA001ShortName")
' Description
'	oResultFile.ExtraValues.Add "Description", oGetResourceString("ResultFileSKA001Description")
' Columns and sequence (optional)
'	oResultFile.ExtraValues.Add "ReportColumns", ""
' Amount of rows which should be shown in the report
	oResultFile.ExtraValues.Add "RowCount", 20
	SmartContext.TestResultFiles.Add oResultFile
	Set oResultFile = Nothing
	
	Call SetFlagForTable(dbStornoSollAufHabenSummiert, TRUE)
	
	If bPrivateMode = TRUE Then
		' Remove History in files created by Analysis
		If oSC.FileExists(dbStornoSollAufHabenSummiert, "") Then oProtectIP.RemoveHistory dbStornoSollAufHabenSummiert
	End If
	
	SmartContext.ScriptProgress 41, 94
	
End Function


'===============================================================================
' Begin of standard functions, from here no user input necessary

' Sets the value of the global variable "m_checkpointName".
' Checkpoints are identifying a position in the code.
' In case of an error the last passed checkpoint name will be logged. 
Sub SetCheckpoint(ByVal checkpointName As String)
	m_checkpointName = checkpointName
End Sub

' Logs an error and in case the user canceled the execution, it logs the cancel state.
' extraInfo: Only used in case special information shall be logged - usually it is empty.
Sub LogSmartAnalyzerError(ByVal extraInfo As String)
On Error Resume Next
	If SmartContext.IsCancellationRequested Then
		SmartContext.ExecutionStatus = EXEC_STATUS_CANCELED
		
		SmartContext.Log.LogMessage "Excecution was stopped by user."
	Else
		SmartContext.ExecutionStatus = EXEC_STATUS_FAILED
		
		SmartContext.Log.LogError "An error occurred in audit test '{0}'.{1}Error #{2}, Error Description: {3}{1}" + _
		                          "The last passed checkpoint was: {4}", _
		                          SmartContext.TestName, Chr(10), Err.Number, Err.Description, m_checkpointName

		If Len(extraInfo) > 0 Then
			SmartContext.Log.LogError "Additional error information: " & extraInfo
		End If
	End If
End Sub

'*******************************************************
'* Removes an action field
'* Parameters: Filename of file that contains field
'* Field Name that has the action field
'* Removes an action field that has been previously created.
'****************************************************************
'
Function removeActionField(sFile As String, sField As String)
	Set db = Client.OpenDatabase(sFile)
	
	' Get the table definition.
	Set table = db.TableDef
	
	' Get a field from the table.
	Set field = table.GetField(sField)
	
	field.RemoveActionField
End Function
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
' 25.07.2022 AS
' positon filter, get parameter
Function CreateEQNFromDialogParameter(ByVal bFunctionStandAlone As Boolean)
	if oParameters.Contains("sCB_A") then A_Checked = oParameters.Item("sCB_A").Checked
	if oParameters.Contains("sCB_P") then P_Checked = oParameters.Item("sCB_P").Checked
	if oParameters.Contains("sCB_E") then E_Checked = oParameters.Item("sCB_E").Checked
	if oParameters.Contains("sCB_V") then V_Checked = oParameters.Item("sCB_V").Checked
	
	SetCheckpoint "create equation"
	
	sPositionEqn = ""
	
	if A_Checked then
		sPositionEqn = "@left(POSITION_SHORT; 1) = ""A"" .OR. "
		bFilterForPosition = TRUE
	end if
	if P_Checked then
		sPositionEqn = sPositionEqn & "@left(POSITION_SHORT; 1) = ""P"" .OR. "
		bFilterForPosition = TRUE
	end if
	If E_Checked Then
		sPositionEqn = sPositionEqn & "@left(POSITION_SHORT; 1) = ""E"" .OR. "
		bFilterForPosition = TRUE
	end if
	if V_Checked then
		sPositionEqn = sPositionEqn & "@left(POSITION_SHORT; 1) = ""V"""
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

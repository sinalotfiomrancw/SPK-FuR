'-------------------------------------------------------------------------------------
' Title:		SKA_003_Automatische_Buchungen_je_Kontorahmen
' CIR:		SKA
' Customer:	Sparkassen
' Created by:	KKR
' Created on:	06.09.2018
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
' 				for filtering tables from the import routine have to be created in the audit test
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

dim sAuditFolder as string 'AS 18.11.2021

' Dialog 25.07.2022
dim A_Checked as boolean
dim P_Checked as boolean
dim E_Checked as boolean
dim V_Checked as boolean

dim bFilterForPosition as boolean

dim sPositionEqn as string

' Specific variables
' m_checkpointName is used for error logging and this variable has to be kept global!
' The value provided by this variable shall give a clue where an error occurred.
' Remarks: It is set in Sub 'SetCheckpoint'
'          And  used in Sub 'LogSmartAnalyzerError'
Dim m_checkpointName As String ' Check Point
Dim dbNameSource As String 'Source File
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
	
	' 25.07.2022 AS
	' positon filter, get parameter, TRUE = function is used alone, FALSE = function ist combined with another function -> adds " .AND. (" and ")"
	'---------------------------------------------------------------------------------------
	SetCheckpoint "get Dialog Parameter"
	Call CreateEQNFromDialogParameter(TRUE)
	'---------------------------------------------------------------------------------------
	
	' Check if source file is valid:
	If oSC.FileIsValid(dbNameSource) Then
		SetCheckpoint "Begin of Analysis"
		' Disable project overview:
		oProtectIP.ProjectOverviewOff

		' Register primary input file in SmartAnalyzer:
		'Set oResultFile = oSC.CreateResultObject(dbNameSource, INPUT_DATABASE, True, 1)
		'SmartContext.TestResultFiles.Add oResultFile
		'Set oResultFile = Nothing
		' Count history records in source file:
		Dim lNumberOfHistoryCountsSourceFileStart As Long
		lNumberOfHistoryCountsSourceFileStart = oProtectIP.HistoryCount(dbNameSource)
' BEGIN INPUT
' ##############################################################################

		' Call(s) of specific analysis function(s):
		Call Analysis()
	
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


' BEGIN INPUT
' ##############################################################################
Function Analysis
' Local Variables
Dim dbName As String
Dim sFieldNameOverallCreditLimit As String
Dim lNumberOfHistoryCountsSourceFileStart As Long
Dim dbBuchungenJeKtoRahmenGes As String
Dim dbUmsaetzeAutoJeKto As String
dim sUmsaetze as string ' 25.07.2022

	'dbBuchungenJeKtoRahmenGes = sAuditFolder & "-SKA00_Anzahl_Buchungen_je_KtoRahmen.IMD" ' 25.07.2022
	sUmsaetze = sAuditFolder & "{Umsätze_zu_OBR_Gesamt_mit_Buchungskennzeichen}.IMD" ' 25.07.2022
	
	SmartContext.ScriptProgress 6, 10
	lNumberOfHistoryCountsSourceFileStart = oProtectIP.HistoryCount(dbNameSource)
'	Set db = Client.OpenDatabase("dbUmsaetzeOBRManuell")
	' 25.07.2022
	'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	' Create "-SKA00_Anzahl_Buchungen_je_KtoRahmen.IMD"
	' Create "-SKA00_Automatische_Buchungen_je_KtoRahmen.IMD"
	Set db = Client.OpenDatabase(dbNameSource)
	If db.Count > 0 Then
		Set db = Client.OpenDatabase(sUmsaetze)
		Set task = db.Summarization
		task.AddFieldToSummarize "RAHMENNR_2STELLIG"
		task.AddFieldToTotal "BETRAG"
		task.Criteria = sPositionEqn
		dbBuchungenJeKtoRahmenGes = oSC.UniqueFileName("-SKA003_Anzahl_Buchungen_je_KtoRahmen.IMD")
		task.OutputDBName = dbBuchungenJeKtoRahmenGes
		task.CreatePercentField = False
		task.StatisticsToInclude = SM_SUM + SM_MAX + SM_MIN + SM_AVERAGE
		task.DisableProgressNotification = True
		task.PerformTask
		db.Close
		Set task = Nothing
		Set db = Nothing
	SmartContext.ScriptProgress 11, 20	
		Set db = Client.OpenDatabase(dbNameSource)
		Set task = db.Summarization
		task.AddFieldToSummarize "RAHMENNR_2STELLIG"
		task.AddFieldToTotal "BETRAG"
		task.Criteria = sPositionEqn
		dbUmsaetzeAutoJeKto = oSC.UniqueFileName("-SKA003_Automatische_Buchungen_je_KtoRahmen.IMD")
		task.OutputDBName = dbUmsaetzeAutoJeKto
		task.CreatePercentField = False
		task.UseFieldFromFirstOccurrence = True
		task.StatisticsToInclude = SM_SUM + SM_MAX + SM_MIN + SM_AVERAGE
		task.PerformTask
		db.Close
		Set task = Nothing
		Set db = Nothing
	SmartContext.ScriptProgress 21, 25	
		' Register file, was old primary input file
		Set oResultFile = oSC.CreateResultObject(dbUmsaetzeAutoJeKto, INPUT_DATABASE, True, 1)
		SmartContext.TestResultFiles.Add oResultFile
		Set oResultFile = Nothing
		
		If bPrivateMode = TRUE Then
			' Remove History in files created by Analysis
			If oSC.FileExists(dbBuchungenJeKtoRahmenGes, "") Then oProtectIP.RemoveHistory dbBuchungenJeKtoRahmenGes
			If oSC.FileExists(dbUmsaetzeAutoJeKto, "") Then oProtectIP.RemoveHistory dbUmsaetzeAutoJeKto
		End If
	end if
	'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Set db = Client.OpenDatabase(dbUmsaetzeAutoJeKto)
	'Set db = Client.OpenDatabase(dbNameSource) ' 25.07.2022
	If db.Count > 0 Then
		Set task = db.JoinDatabase
		task.FileToJoin dbBuchungenJeKtoRahmenGes
		task.IncludeAllPFields
		task.AddSFieldToInc "ANZ_SAETZE"
		task.AddSFieldToInc "BETRAG_SUMME"
		task.AddMatchKey "RAHMENNR_2STELLIG", "RAHMENNR_2STELLIG", "A"
		task.CreateVirtualDatabase = False
		task.DisableProgressNotification = True
		dbUmsaetzeAutoJeKto = oSC.UniqueFileName(sAuditFolder & "@SK-FuR-0003_Automatische_Buchungen_je_KtoRahmen.IMD")
		task.PerformTask dbUmsaetzeAutoJeKto, "", WI_JOIN_ALL_IN_PRIM
		db.Close
		Set task = Nothing
		Set db = Nothing
	SmartContext.ScriptProgress 26, 45		
		Set db = Client.OpenDatabase(dbUmsaetzeAutoJeKto)
		Set task = db.TableManagement
		Set field = db.TableDef.NewField
		field.Name = "ANZ_SAETZE_AUTO"
		field.Description = "Anzahl der Datensätze, die für diesen Schlüsselwert gefunden wurden"
		field.Type = WI_NUM_FIELD
		field.Equation = ""
		field.Decimals = 0
		task.ReplaceField "ANZ_SAETZE", field
		field.Name = "BETRAG_SUMME_AUTO"
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
	SmartContext.ScriptProgress 46, 55		
		Set db = Client.OpenDatabase(dbUmsaetzeAutoJeKto)
		Set task = db.TableManagement
		Set field = db.TableDef.NewField
		field.Name = "QUOTE_ANZAHL"
		field.Description = ""
		field.Type = WI_NUM_FIELD
		field.Equation = "ANZ_SAETZE_AUTO / ANZ_SAETZE_GESAMT"
		field.Decimals = 4
		task.AppendField field
		field.Name = "QUOTE_SUMME"
		field.Description = ""
		field.Type = WI_NUM_FIELD
		field.Equation = "@If(BETRAG_SUMME_GESAMT <> 0; BETRAG_SUMME_AUTO / BETRAG_SUMME_GESAMT; BETRAG_SUMME_AUTO)"
		field.Decimals = 4
		task.AppendField field
		task.DisableProgressNotification = True
		task.PerformTask
		db.Close
		Set task = Nothing
		Set db = Nothing
		Set field = Nothing
	Else
		db.Close
		Set db = Nothing
	End If

	' Result file handling
	'Final Result:
'	Set oResultFile = oSC.CreateResultObject(dbName, FINAL_RESULT, True, 1)
	Set oResultFile = oSC.CreateResultObject(dbUmsaetzeAutoJeKto, FINAL_RESULT, True, 2)
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
	
	Call SetFlagForTable(dbUmsaetzeAutoJeKto, TRUE)
	
	If bPrivateMode = TRUE Then
		' Remove History in files created by Analysis
		If oSC.FileExists(dbUmsaetzeAutoJeKto, "") Then oProtectIP.RemoveHistory dbUmsaetzeAutoJeKto
	End If
	
	SmartContext.ScriptProgress 55, 94
	
End Function
' ##############################################################################
' END INPUT


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

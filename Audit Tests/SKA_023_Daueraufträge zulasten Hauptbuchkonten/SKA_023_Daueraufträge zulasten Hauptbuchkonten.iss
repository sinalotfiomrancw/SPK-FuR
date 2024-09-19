'-------------------------------------------------------------------------------------
' Title:		
' CIR:			
' Customer:		
' Created by:	
' Created on:	
' Version:		
'-------------------------------------------------------------------------------------
' Decription:	
'-------------------------------------------------------------------------------------
' Result files:	
'-------------------------------------------------------------------------------------
' Change History
'-------------------------------------------------------------------------------------
' Changed by:	AS
' Changed on:	18.11.2021
' Requested by:	audicon
' Comment:		adjusted to be used with import routine which uses audit folders
'------------------
' Changed by:	AS
' Changed on:	25.07.2022
' Requested by:	AG
' Comment:		added dialog to filter for positions
'-------------------------------------------------------------------------------------

Option Explicit

Dim oLog As Object	'Simple Log Object
Dim oMC As Object	'Simple MacroCommands Object
Dim oSC As Object	'Simple Commands Object
Dim oTM As Object	'Tag Management Object
Dim oParameters As Object ' 25.07.2022 Get Paramters from SA-Dialogs

' IDEA standard variables
Dim db As Object
Dim task As Object
Dim field As Object
Dim table As Object
Dim eqn As String
Dim dbName As String

' Constants for result file handling
Const NOT_A_RESULT As Long = 0
Const INPUT_DATABASE As Long = 1
Const INTERMEDIATE_RESULT As Long = 2
Const FINAL_RESULT As Long = 4
Const NO_REGISTRATION As Long = 8

' Constants for execution status
Const EXEC_STATUS_FAILED = 0
Const EXEC_STATUS_SUCCEEDED = 1
Const EXEC_STATUS_CANCELED = 3

Dim dbUmsaetzeZuOBRGesamt As String
Dim dbDauerauftraegeZulastenHK As String

dim sAuditFolder as string 'AS 18.11.2021
dim dbNameSource as string 'AS 18.11.2021

' Dialog 25.07.2022
dim A_Checked as boolean
dim P_Checked as boolean
dim E_Checked as boolean
dim V_Checked as boolean

dim bFilterForPosition as boolean

dim sPositionEqn as string
	

Sub Main
On Error GoTo ErrorHandlerMain

	Set oLog = SmartContext.Log
	Set oMC = SmartContext.MacroCommands
	Set oSC = SmartContext.MacroCommands.SimpleCommands
	Set oTM = SmartContext.MacroCommands.TagManagement
	Set oParameters = SmartContext.Parameters ' 25.07.2022

	'Set ExecutionStatus (failure at the beginning).
	SmartContext.ExecutionStatus =EXEC_STATUS_FAILED

	oLog.LogMessage "Standard SKE_001 Routine Name: " & SmartContext.TestName
	oLog.LogMessage " Standard SKE_001 Routine Version: " & SmartContext.TestVersion
	oLog.LogMessage "Execution Time: " & Now()
	
	dbNameSource = SmartContext.PrimaryInputFile
	sAuditFolder = oSC.GetDirName(dbNameSource)' AS 18.11.2021
	If sAuditFolder = "\" Then sAuditFolder = ""
	
	' 25.07.2022 AS
	' positon filter, get parameter, TRUE = function is used alone, FALSE = function ist combined with another function -> adds " .AND. (" and ")"
	'---------------------------------------------------------------------------------------
	'SetCheckpoint "get Dialog Parameter"
	Call CreateEQNFromDialogParameter(FALSE)
	'---------------------------------------------------------------------------------------
	
	Call PS_018()	
	Call RegisterResult()
	
	oLog.LogMessage "Execution Time End: " & Now()
	
	SmartContext.ExecutionStatus = EXEC_STATUS_SUCCEEDED
	'Set ExecutionStatus (cancel) at user's cancellation request

	If SmartContext.IsCancellationRequested Then
		SmartContext.ExecutionStatus = EXEC_STATUS_CANCELED
		Exit Sub 
	End If 
	
	'Set ExecutionStatus (success at the end).
	SmartContext.ExecutionStatus = EXEC_STATUS_SUCCEEDED

	Set oSC = Nothing
	Set oTM = Nothing
	Set oMC = Nothing
	Set oLog = Nothing
	Set oParameters = Nothing ' 25.07.2022

Exit Sub
ErrorHandlerMain:
	oLog.LogError "An error occurred in the function Main."
	oLog.LogError "Error number: {0}; Error source: {1}; Error description: {2}", _
			Err.Number, Err.Source, Err.Description
	SmartContext.ExecutionStatus = EXEC_STATUS_FAILED
	
End Sub

' Analyse: Felder aufsummieren
Function PS_018

	dbUmsaetzeZuOBRGesamt = sAuditFolder & "{Umsätze_zu_OBR_Gesamt_mit_Buchungskennzeichen}.IMD"
	dbDauerauftraegeZulastenHK = oSC.UniqueFileName(sAuditFolder & "@SK-FuR-0023_Daueraufträge zulastenHauptbuchkonten.IMD")

	Set db = Client.OpenDatabase(dbUmsaetzeZuOBRGesamt)
	Set task = db.Extraction	
	task.IncludeAllFields
	
	task.AddExtraction dbDauerauftraegeZulastenHK, "", "(TEXTSCHLÜSSEL =""12"" .or.  TEXTSCHLÜSSEL =""13"") .and. PN==""7000"" .and. SHK = ""S"" " & sPositionEqn
	task.CreateVirtualDatabase = False

	task.PerformTask 1, db.Count
	db.Close
	
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
	
End Function


Function RegisterResult
	Dim oResultFile As Object
	Set oResultFile = oSC.CreateResultObject(dbDauerauftraegeZulastenHK, FINAL_RESULT, True, 4)
	
	' Specify the short name of the result file for Excel report (Tab-Name)
	oResultFile.ExtraValues.Add "ShortName", "SKA_023_Daueraufträge"
	' Specify the description of the  result file
	oResultFile.ExtraValues.Add "Description", _
		oSC.FormatString("Enthält Liste von Auffälligen Wirtschaftverbünden")
	' Optional: Specify the order of the exported columns (not for Excel)
	oResultFile.ExtraValues.Add "ReportColumns", "KONTO_NR, KONOTBEZEICHNUNG, BUCHUNGSDATUM, WERTSTELLUNG, BETRAG, WKZ,TEXTSCHLÜSSEL, AUFTRAGG_KTO, PN, VERWENDUNGSZWECK, SHK, KONTO"
	' Optional: Specify the maximum number of rows displayed in the report (not Excel)
	oResultFile.ExtraValues.Add "RowCount", 20
	' Add the result to the result collection::
	SmartContext.TestResultFiles.Add oResultFile
	
	Set oResultFile = Nothing
	
	Call SetFlagForTable(dbDauerauftraegeZulastenHK, TRUE)
	
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
	
	'SetCheckpoint "create equation"
	
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
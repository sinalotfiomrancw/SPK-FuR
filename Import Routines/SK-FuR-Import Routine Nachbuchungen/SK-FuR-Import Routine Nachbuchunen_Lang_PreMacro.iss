'-------------------------------------------------------------------------------------
' Title:		SKA_FuR - Import Routine Nachbuchungen
' CIR:		SKA_FuR
' Customer:	Sparkassen
' Created by:	AS
' Created on:	19.04.
' Version:		1.00
'-------------------------------------------------------------------------------------
' Decription:	spezial Import Routine for the App SK_FuR
'-------------------------------------------------------------------------------------
' Files:		Requires 6 Input File(s)
'			- 
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
Const NO_REGISTRATION As Long = 8

' Excecution status constants
Const EXEC_STATUS_FAILED As Long = 0
Const EXEC_STATUS_SUCCEEDED = 1
Const EXEC_STATUS_CANCELED As Long = 3
Const TopDirectoryOnly = 0 
Const AllDirectories = 1 

' Common SmartAnalyzer variables
Dim oSC As Object
Dim oMC As Object
Dim oTM As Object
Dim oLog As Object
Dim oProtectIP As Object
Dim oFiles As Object 
Dim oFile As Object 
Dim fs As Object

Dim sourceFileName As String
Dim sDate	As String

' IDEA standard variables
Dim db As Object
Dim dbName As String
Dim eqn As String
Dim task As Object
Dim field As Object
Dim result As Object
Dim oPara As Object

'Variablen für globale Tabellen
Dim sPathOBR As String
Dim sEquation As String
Dim sEquationDialogNB As String

'Final Tables
Dim sDialogResultCase As String

Dim m_checkpointName As String

Sub Main
On Error GoTo ErrorHandler
SetCheckpoint "Begin of Main"
	'IgnoreWarning (True)
	Set oLog = SmartContext.Log
	Set oMC = SmartContext.MacroCommands
	Set oSC = SmartContext.MacroCommands.SimpleCommands
	Set oPara = SmartContext.MacroCommands.GlobalParameters 
	'Set oTM = SmartContext.MacroCommands.TagManagement

	'Set ExecutionStatus (failure at the beginning).
	SmartContext.ExecutionStatus =EXEC_STATUS_FAILED

	oLog.LogMessage "Standard SK_001 Routine Name: " & SmartContext.TestName
	oLog.LogMessage " Standard SK_001 Routine Version: " & SmartContext.TestVersion
	oLog.LogMessage "Execution Time Start: " & Now()
	
	Call fileANDFilterDIALOG
	'Call RegisterResult
	
	If (result.Outputs.Item("smartCheckBox1").Checked And Len(result.Outputs.Item("smartTextBox2").Value) > 0) Then
		sDialogResultCase = "1"
	
	ElseIf (result.Outputs.Item("smartCheckBox1").Checked And Len(result.Outputs.Item("smartTextBox2").Value) = 0) Then
		sDialogResultCase = "2"
	
	ElseIf ((Not result.Outputs.Item("smartCheckBox1").Checked) And Len(result.Outputs.Item("smartTextBox2").Value) > 0) Then
		sDialogResultCase = "3"
	
	Elseif ((Not result.Outputs.Item("smartCheckBox1").Checked) And Len(result.Outputs.Item("smartTextBox2").Value) = 0) Then
		sDialogResultCase = "4"
	End If
	
	oPara.Set4Project "sNaBuDialogResultCase", sDialogResultCase
	
	Dim CompareResult As Long
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

	If SmartContext.IsCancellationRequested Then
		SmartContext.ExecutionStatus = EXEC_STATUS_CANCELED
		Exit Sub 
	End If 	

	Set oLog = Nothing
	Set oMC = Nothing
	Set oSC = Nothing
	Set oPara = Nothing 
	
	Exit Sub
ErrorHandler:
	Call LogSmartAnalyzerError("")
End Sub

Function fileANDFilterDIALOG
Dim dialogInvoker As Object
Dim sFilePathStandard As String
Dim vAccountChoice As Variant
Dim args As Object
Dim dict As Object
Dim returnedValues As Object
Dim accountValues As Object
' FromToList
Const FromValue = 0
Const ToValue = 1
Dim sAccountFrom As String
Dim sAccountTo As String
Dim bAccountFilter As Boolean
Dim bRahmenFilter As Boolean
Dim vList As Variant
Dim vRow As Variant
Dim vRowneu As Variant
Dim sPath As String

	sFilePathStandard = Client.WorkingDirectory & "Quelldateien.ILB"
	
	Set dialogInvoker = SmartContext.GetServiceById("MacroDialogInvoker")
	If dialogInvoker is Nothing Then
		SmartContext.Log.LogError "Der Dialog für den Pfad der Datei konnte nicht angezeigt werden, da der MacroDialogInvoker Service nicht vorhanden ist."
		Exit Sub
	End If
    
	Set args = dialogInvoker.NewTaskParameters
	Set dict = oSC.CreateHashtable
	dict.Add "FilePathStandard", sFilePathStandard

	args.Inputs.Add "smartDataExchanger1", dict
    
	Set result = dialogInvoker.PerformTask("DateiAuswahl", args)
    
	If result.AllOK Then
		bAccountFilter = result.Outputs.Item("AccountFilter").Checked
		bRahmenFilter = result.Outputs.Item("RahmenFilter").Checked
		
		sPath = result.Outputs.Item("smartTextBox1")
		sPathOBR = result.Outputs.Item("smartTextBox2")
		
		if bAccountFilter then
			Set accountValues = result.Outputs.Item("AccountList")
			vList = accountValues.getList
			For Each vRow In vList
				sAccountFrom = vRow(FromValue)
				sAccountTo = vRow(ToValue)
				If Trim(sAccountTo) = "" Then sAccountTo = sAccountFrom
				sEquation = sEquation & "@Val(KONTO_NR)>=" & sAccountFrom & " .AND. @Val(KONTO_NR)<=" & sAccountTo & " .OR. "
			Next
			Set returnedValues = Nothing
			Set accountValues = Nothing
		end if
		
		If bRahmenFilter Then
			Set accountValues = result.Outputs.Item("RahmenList")
			vList = accountValues.getList
			For Each vRowneu In vList
				sAccountFrom = vRowneu(FromValue)
				sAccountTo = vRowneu(ToValue)
				If Trim(sAccountTo) = "" Then sAccountTo = sAccountFrom
				sEquation = sEquation & "@Val(@left(KTO_RAHMEN;2))>=" & sAccountFrom & " .AND. @Val(@left(KTO_RAHMEN;2))<=" & sAccountTo & " .OR. "
			Next
			Set returnedValues = Nothing
			Set accountValues = Nothing
		End If
	Else
		MsgBox "Die Aufbereitung wurde beendet."
		SmartContext.ExecutionStatus = EXEC_STATUS_CANCELED
		SmartContext.AbortImport = True
		oLog.LogWarning "Vorgang wurde vom Anwender abgebrochen (Dialog: Konten/Rahmenfilter)"
		oLog.LogWarning "Execution Time End: " & Now()
		Stop
	End If
	If Right(sEquation, 5) = ".OR. " Then sEquation = Left(sEquation, Len(sEquation)-6)
	
	oPara.Set4Project "sEquationDialogNB", sEquation
	oPara.Set4Project "sPathNaBu", sPath
	oPara.Set4Project "sPathOBR", sPathOBR
	
End Function

Sub LogSmartAnalyzerError(ByVal extraInfo As String)
On Error Resume Next
	If SmartContext.IsCancellationRequested Then
		SmartContext.ExecutionStatus = EXEC_STATUS_CANCELED
		
		SmartContext.Log.LogMessage "Excecution was stopped by user."
	Else
		SmartContext.ExecutionStatus = EXEC_STATUS_FAILED
		
		SmartContext.Log.LogError "An error occurred in during the data preparation of '{0}'.{1}Error #{2}, Error Description: {3}{1}" + _
		                          "The last passed checkpoint was: {4}", _
		                          SmartContext.TestName, Chr(10), Err.Number, Err.Description, m_checkpointName

		If Len(extraInfo) > 0 Then
			SmartContext.Log.LogError "Additional error information: " & extraInfo
		End If
	End If
End Sub

Sub SetCheckpoint(ByVal checkpointName As String)
	m_checkpointName = checkpointName
End Sub

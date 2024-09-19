'-------------------------------------------------------------------------------------
' Title:		Stichprobenziehung
' CIR:		SK
' Customer:	Sparkassen
' Created by:	Alexander Strubert
' Created on:	24.04.2020
' Version:		beta
'-------------------------------------------------------------------------------------
' Decription:	
'-------------------------------------------------------------------------------------
' Result files:	
'			
'-------------------------------------------------------------------------------------
' Change History
'-------------------------------------------------------------------------------------
' Changed by:	Alexander Strubert
' Changed on:	06.10.2020
' Requested by:	SK-Arbeitskreis
' Comment:		It should be possible to enter a upper and a lower bound for the cut off
'------------------
' Changed by:	Alexander Strubert
' Changed on:	19.11.2020
' Requested by: Audicon/SK-Arbeitskreis
' Comment:		added Connector for cut off, added column choice for cut off in to dialog
'-------------------------------------------------------------------------------------

Option Explicit

Dim db As Object
Dim task As Object
Dim table As Object
Dim field As Object
Dim dbName As String

' Constants for SmartAnalyzer Funtions
Dim oLog As Object	'Simple Log Object
Dim oMC As Object	'Simple MacroCommands Object
Dim oSC As Object	'Simple Commands Object
Dim oTM As Object	'Tag Management Object
Dim oPM As Object	'Parameters Object

' Constants for execution status
Const EXEC_STATUS_FAILED = 0
Const EXEC_STATUS_SUCCEEDED = 1
Const EXEC_STATUS_CANCELED = 3

' Constants for result file handling
Const NOT_A_RESULT As Long = 0
Const INPUT_DATABASE As Long = 1
Const INTERMEDIATE_RESULT As Long = 2
Const FINAL_RESULT As Long = 4
Const NO_REGISTRATION As Long = 8

' Error Logging
Dim m_checkpointName As String

' User specific variables
Dim sInputFile As String
dim oCutOffSpalte as object	' AS 19.11.2020
Dim sCutOffSpalte As String

Dim oCheckBoxZufallsauswahl As Object
Dim bIsCheckedZufallsauswahl As Boolean
Dim oTextBoxZufallsauswahl As Object
Dim iWertZufallsauswahl As Integer

Dim oCheckBoxCutOffObereGrenze As Object ' AS: 06.10.2020 Chanched Name from CheckBoxCutOff to CheckBoxCutOffObereGrenze
Dim bIsCheckedCutOffObereGrenze As Boolean ' AS: 06.10.2020
Dim oTextBoxCutOffObereGrenze As Object ' AS: 06.10.2020
Dim sWertCutOffObereGrenze As String ' AS: 06.10.2020

Dim oCheckBoxCutOffUntereGrenze As Object ' AS: 06.10.2020
Dim bIsCheckedCutOffUntereGrenze As Boolean ' AS: 06.10.2020
Dim oTextBoxCutOffUntereGrenze As Object ' AS: 06.10.2020
Dim sWertCutOffUntereGrenze As String ' AS: 06.10.2020

dim oCutOffConnector as object	' AS 19.11.2020
Dim sCutOffConnector As String	' AS 19.11.2020

dim oTextBoxInputFile as string ' AS 06.12.2020

Sub Main
On Error GoTo ErrorHandlerMain
SetCheckpoint "Begin of Sub Main()"
	Set oLog = SmartContext.Log
	Set oPM = SmartContext.Parameters
	Set oMC = SmartContext.MacroCommands
	Set oSC = SmartContext.MacroCommands.SimpleCommands
	Set oTM = SmartContext.MacroCommands.TagManagement

	'Set ExecutionStatus (failure at the beginning).
	SmartContext.ExecutionStatus =EXEC_STATUS_FAILED

	oLog.LogMessage "Routine Name: " & SmartContext.TestName
	oLog.LogMessage "Routine Version: " & SmartContext.TestVersion
	oLog.LogMessage "Execution Time: " & Now()
	
'--------------------------------------------------------------------------------------------
' Tag Informationen
'--------------------------------------------------------------------------------------------	

'---------------------------------------------------------------------------------------------
' Dialog Parameter
'---------------------------------------------------------------------------------------------
SetCheckpoint "Start of Dialog Parameter()"

	bIsCheckedZufallsauswahl = False
	bIsCheckedCutOffObereGrenze = False ' AS: 06.10.2020
	bIsCheckedCutOffUntereGrenze = False ' AS: 06.10.2020
	
	If oPM.Contains("smartTextBox1") Then		
		Set oTextBoxInputFile = oPM.Item("smartTextBox1")
		sInputFile = oTextBoxInputFile.Value
	End If
	
	If oSC.FileIsValid(sInputFile) = False Then
		oLog.LogWarning "Es wurde keine valide Tabelle als Datenbasis ausgewählt."
		oLog.LogMessage "Execution Time End: " & Now()

		Set oSC = Nothing
		Set oTM = Nothing
		Set oMC = Nothing
		Set oLog = Nothing
		Set oPM = Nothing
		
		Exit Sub
	End If

	If oPM.Contains("smartCheckBox1") Then		
		Set oCheckBoxZufallsauswahl = oPM.Item("smartCheckBox1")
		If oCheckBoxZufallsauswahl.Checked Then
			bIsCheckedZufallsauswahl = True
			If oPM.Contains("smartTextBox2") Then
			Set oTextBoxZufallsauswahl = oPM.Item("smartTextBox2")
				iWertZufallsauswahl = oTextBoxZufallsauswahl.Value
			End If
		End If
	End If
	
	If oPM.Contains("smartCheckBox2") and oPM.Contains("smartCheckBox3") and oPM.Contains("smartComboBox2") and oPM.Contains("smartComboBox1") Then		' AS: 19.11.2020
		Set oCheckBoxCutOffObereGrenze = oPM.Item("smartCheckBox2")
		Set oCheckBoxCutOffUntereGrenze = oPM.Item("smartCheckBox3")
		If oCheckBoxCutOffUntereGrenze.Checked or oCheckBoxCutOffObereGrenze.Checked then
			Set oCutOffSpalte = oPM.Item("smartComboBox1")
			sCutOffSpalte = oCutOffSpalte.Value
		end if
		If oCheckBoxCutOffUntereGrenze.Checked and oCheckBoxCutOffObereGrenze.Checked then
			Set oCutOffConnector = oPM.Item("smartComboBox2")
			sCutOffConnector = oCutOffConnector.Value
			Select Case sCutOffConnector
				Case "ODER"
					sCutOffConnector = ".OR."
				Case "UND"
					sCutOffConnector = ".AND."
			End Select
		end if
	End If
	
	If oPM.Contains("smartCheckBox2") Then
		Set oCheckBoxCutOffObereGrenze = oPM.Item("smartCheckBox2")
		If oCheckBoxCutOffObereGrenze.Checked and sCutOffSpalte <> "" Then
			bIsCheckedCutOffObereGrenze = True
			If oPM.Contains("smartTextBox3") Then
			Set oTextBoxCutOffObereGrenze = oPM.Item("smartTextBox3")
				sWertCutOffObereGrenze = oTextBoxCutOffObereGrenze.Value
			End If
		End If
	End If
	
	If oPM.Contains("smartCheckBox3") Then		' AS: 06.10.2020
		Set oCheckBoxCutOffUntereGrenze = oPM.Item("smartCheckBox3")
		If oCheckBoxCutOffUntereGrenze.Checked And sCutOffSpalte <> "" Then
			bIsCheckedCutOffUntereGrenze = True
			If oPM.Contains("smartTextBox4") Then
			Set oTextBoxCutOffUntereGrenze  = oPM.Item("smartTextBox4")
				sWertCutOffUntereGrenze = oTextBoxCutOffUntereGrenze.Value
			End If
		End If
	End If
	
	set oTextBoxInputFile = nothing 'AS 06.12.2020
	Set oCheckBoxZufallsauswahl = Nothing' AS: 06.10.2020
	Set oTextBoxZufallsauswahl = Nothing
	Set oCheckBoxCutOffObereGrenze = Nothing
	Set oTextBoxCutOffObereGrenze = Nothing
	Set oCheckBoxCutOffUntereGrenze = Nothing
	Set oTextBoxCutOffUntereGrenze = Nothing
	
SetCheckpoint "End of Dialog Parameter()"
'---------------------------------------------------------------------------------------------
'Funktionsaufrufe
'---------------------------------------------------------------------------------------------		
	'IgnoreWarning (True)
SetCheckpoint "Start of Funktions()"

	If bIsCheckedCutOffObereGrenze or bIsCheckedCutOffUntereGrenze Then ' AS: 06.10.2020
		Call CutOff(sInputFile, sCutOffSpalte, sWertCutOffObereGrenze, sWertCutOffUntereGrenze) ' AS: 06.10.2020
	End If
	
	If bIsCheckedZufallsauswahl Then
		Call Zufallsauswahl(sInputFile, iWertZufallsauswahl)
	End If
	
	Call RegisterResult(sInputFile)
	
SetCheckpoint "End of Funktions()"
'---------------------------------------------------------------------------------------------
'Funktionsaufrufe Ende
'---------------------------------------------------------------------------------------------		 
	oLog.LogMessage "Execution Time End: " & Now()
	
	SmartContext.ExecutionStatus = EXEC_STATUS_SUCCEEDED

	Set oSC = Nothing
	Set oTM = Nothing
	Set oMC = Nothing
	Set oLog = Nothing
	Set oPM = Nothing
	
	Client.RefreshFileExplorer
Exit Sub

ErrorHandlerMain:
	Call LogSmartAnalyzerError("")
End Sub

Function CutOff(ByVal sFile As String, ByVal sColumn As String, ByVal sSampleCutOffObereGrenze As String, ByVal sSampleCutOffUntereGrenze As String)
SetCheckpoint "CutOff"
dim eqnCutOff as string
dim eqnConnector as string
'AS: 06.10.2020 Create equation based on dialog values
	if bIsCheckedCutOffObereGrenze then
		eqnCutOff = sCutOffSpalte & " >= " & sSampleCutOffObereGrenze
		eqnConnector = sCutOffConnector ' AS 19.11.2020
	end if
	If bIsCheckedCutOffUntereGrenze Then
		eqnCutOff = eqnCutOff & eqnConnector & sCutOffSpalte & " <= " & sSampleCutOffUntereGrenze
	end if
	
	Set db = Client.OpenDatabase(sFile)
	Set task = db.Extraction
	task.IncludeAllFields
	dbName = oSC.UniqueFileName("CutOff " & sFile, INTERMEDIATE_RESULT)
	task.AddExtraction dbName, "", eqnCutOff
	task.CreateVirtualDatabase = False
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	sInputFile = dbName
End Function

Function Zufallsauswahl(ByVal sFile As String, ByVal lSampleSize As Long)
SetCheckpoint "Zufallsauswahl"
Dim dude As Long
dude = RandomNumber()

Dim FilePrefix As String
FilePrefix = "Zufallsauswahl"
If bIsCheckedCutOffObereGrenze Or bIsCheckedCutOffUntereGrenze Then FilePrefix = "Zufallsauswahl mit CutOff"

	Set db = Client.OpenDatabase(sFile)	
	Set task = db.RandomSample
	task.IncludeAllFields
	dbName = oSC.UniqueFileName(FilePrefix & " " & sFile, INTERMEDIATE_RESULT)
	task.CreateVirtualDatabase = False
	task.PerformTask dbName, "", lSampleSize, 1, db.Count, dude, False
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	sInputFile = dbName
End Function

Function RegisterResult(ByVal sFile As String)
SetCheckpoint "RegisterResult"
Dim oResultFile As String
	Set oResultFile = oSC.CreateResultObject(sFile, FINAL_RESULT, True, 1)
	oResultFile.ExtraValues.Add "ShortName", "Stichprobe"
	oResultFile.ExtraValues.Add "Description", "Je nach Auswahl im Dialog wurde ein Cut Off bzw. eine Zufallsauswahl auf die ausgewählte Tabelle durchgeführt."
	oResultFile.ExtraValues.Add "RowCount", 30
	SmartContext.TestResultFiles.Add oResultFile
	Set oResultFile = Nothing	
End Function

Function RandomNumber() As Long
    Dim d As Double
    Dim d1 As Double

    d = Time 
    d1 = Date
    RandomNumber = (d * d1 * 10000) Mod 10000
End Function


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

Sub SetCheckpoint(ByVal checkpointName As String)
	m_checkpointName = checkpointName
End Sub

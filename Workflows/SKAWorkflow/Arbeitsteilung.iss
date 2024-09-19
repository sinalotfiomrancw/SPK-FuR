Option Explicit


' Common SmartAnalyzer variables
Dim oSC As Object
Dim oMC As Object
Dim oTM As Object
Dim oLog As Object
Dim oProtectIP As Object
Dim oPara As Object
Dim oFM As Object 'field management
Dim txt As String
Dim dialogInvoker As Object
Dim dialogParams As Object
Dim dictionary As Object

' IDEA standard variables
Dim db As Object
Dim dbloop As Object
Dim dbloopsplit As Object
Dim dbName As String
Dim dbNameTemp As String
Dim dbNameTempLoop As String
Dim eqn As String
Dim task As Object
Dim field As Object
Dim ProjectManagement As Object
Dim rs As Object
Dim rec As Object

' Dialog variables
Dim result As Object
Dim sOtherUserGen As String
Dim sOtherUser As String
Dim sPathFolderGen As String
Dim sPathFolder As String
Dim sRahmenNrGen As String
Dim sRahmenNr As String
Dim sBilansTypeGen As String
Dim sBilansType	As String
Dim sBilanzpositionShortGen As String
Dim sBilansCatGen As String
Dim sBilansCat As String
Dim sBilanzpositionShort As String
Dim sBPeqn As String
Dim sCheckBoxGen As String
Dim bExcel_Checked As Boolean

' Report File
Dim sPfadJPM As String
Dim sPfadBe As String
Dim sLogDate As String
Dim sLogFolder As String
Dim sLogPath As String

' Error Logging
Dim lErrorNumber As Long
Dim sErrorDescripton As String
Dim lErrorLine As Long

Dim m_checkpointName As String
Dim sFolderPathStandard As String

' Global Parameters
Dim sAktuelleGJAHR As String
Dim sVorherigesGJAHR As String
Dim sAktuelleGJAHRShort As String ' 27.07.2022
Dim sVorherigesGJAHRShort As String' 27.07.2022

'Const
Dim i As Long
Dim m As Long
Dim dbcounter As Long
Const NO_TYPE_RESULT As Long = 0
Const NO_REGISTRATION As Long = 8
Const INTERMEDIATE_RESULT As Long = 2
Const FINAL_RESULT As Long = 4
Const ANALYSE_BASE_TABLE As Long = 1

'Analyze
Dim sAuditName As String
Dim sEqn As String
Dim sTestName As String
Dim sResulName As String
Dim sInputName As String
Dim sCheckisinIN As Integer
Dim sCheckisinINOBR As Integer
Dim sCheckisinRN As Integer
Dim sMainProjectPath As String
Dim sNewProjectPath As String
Dim sNameFolder As String
Dim stempname As String

Sub Main()
	On Error GoTo ErrHandler
	
	IgnoreWarning (True)
	Set oLog = SmartContext.Log
	Set oMC = SmartContext.MacroCommands
	Set oSC = SmartContext.MacroCommands.SimpleCommands
	Set oTM = SmartContext.MacroCommands.TagManagement
	Set oPara = SmartContext.MacroCommands.GlobalParameters
	
	
	sAktuelleGJAHR = oPara.Get4Project ("sAktuelleGJAHR")
	sAktuelleGJAHRShort = right(sAktuelleGJAHR, 2)
	sVorherigesGJAHR = oPara.Get4Project ("sVorherigesGJAHR")
	sVorherigesGJAHRShort = right(sVorherigesGJAHR, 2)
	Set sMainProjectPath = oPara.Get4Project("sMainProjectPath")
	
	If sMainProjectPath = "" Then
		MsgBox "Das aktuelle Projekt enthält nicht die ausgeführten Importroutinen oder/und Prüfungsschritte. Bitte überprüfen Sie, ob das aktuelle Projekt das passende Projekt für die FuR-App ist."
		Exit Sub
	End If
	
	sLogFolder = sMainProjectPath & "Log\"
	If Not FileOrDirExists(sLogFolder) Then
		MkDir sLogFolder
	End If
	sLogDate = iReplace(Date(),".","")
	sLogPath = sLogFolder  & "Arbeitsteilung_log_" & sLogDate & ".txt"
	
	Call WriteIntoLog("Makro gestartet am " & Date() & " um " & Time())
	Call WriteIntoLog("The Path of Main Project: " & sMainProjectPath)		
	
	Set dialogInvoker = SmartContext.GetServiceById("MacroDialogInvoker")
	If dialogInvoker Is Nothing Then
	MsgBox "The dialog for Work Division cannot be displayed because the MacroDialogInvoker service is missing.", "Arbeitsteilung_Schritt1"
	Exit Sub
	End If
	Set dialogParams = dialogInvoker.NewTaskParameters
	Call WriteIntoLog("Starting the Dialog-Arbeitsteilung_Schritt1")
	Set result = dialogInvoker.PerformTask("Arbeitsteilung_Schritt1", dialogParams)
	Call WriteIntoLog("Performing the Dialog-Arbeitsteilung_Schritt1 was succesfull")
	Set dialogInvoker = Nothing
	Set dialogParams = Nothing
	
	Call WriteIntoLog("Starting the Import of Report.txt")
	Call ImportResultList
	
	Set dictionary = SmartContext.MacroCommands.SimpleCommands.CreateHashtable
	
	' sFolderPathStandard = Client.WorkingDirectory
	
	' Add values to the dictionary
	dictionary.Add "FolderPathStandard", sMainProjectPath
	
	Set dialogInvoker = SmartContext.GetServiceById("MacroDialogInvoker")
	
	If dialogInvoker Is Nothing Then
		MsgBox "The dialog for Work Division cannot be displayed because the MacroDialogInvoker service is missing.", "Dialog_Arbeitsteilung"
		Exit Sub
	End If
	
	Set dialogParams = dialogInvoker.NewTaskParameters
	'smartDataExchanger1 is the name of the dialog's SmartDataExchanger control
	dialogParams.Inputs.Add "smartDataExchanger1", dictionary	

	' GlobalParams is the Embedded Dialog ID of the dialog which shall be called
	Call WriteIntoLog("Starting the Dialog")
	Set result = dialogInvoker.PerformTask("Dialog_Arbeitsteilung", dialogParams)
	Call WriteIntoLog("Performing the Dialog-Task was succesfull")
	
	Set db = Client.OpenDatabase(dbName)
	If db.Count > 0 Then
		If result.AllOK Then
			Call WriteIntoLog( "result is ALLOK")
			'Dim returnValues As Object
			'Set returnValues = result.Outputs.Item("smartDataExchanger1").Value
			' Save the return values
			'globalParams.Set4Project ParamName_xxx, returnValues.Item(""
			For m = 1 To 5
				Call WriteIntoLog( "Starting to process the row: " & m)
				Call ReadParameters(m)
				If Not ( (sOtherUser = "") Or (sPathFolder = "") Or ( sRahmenNrGen = "" And (sBilansCat = "keine Eingabe") And sBilanzpositionShort = "" ) ) Then
					Call WriteIntoLog( "All needed boxes of row: " & m & " were filled")
					
					If Not (sRahmenNr = "") Then
						Call CreateNewProject("RN")
						Call SplitRahmenNr(db)
					End If
					
					If (sBilansType = "Bilanzposition (Kategorie)") AND (Not (sBilansCat = "keine Eingabe")) Then
						If sBilansCat = "Aktiva" Then
							sBPeqn = "A"
						ElseIf sBilansCat = "Passiva" Then
							sBPeqn = "P"
						Elseif sBilansCat = "Ertrag" Then
							sBPeqn = "E"
						Else
							sBPeqn = "V"
						End If
						
						Call CreateNewProject("BPC")
						Call SplitBilansposition(db, sBPeqn)
					End If
					
					If (sBilansType = "Bilanzposition (abgekürzt)") AND (Not (sBilanzpositionShort = "")) Then
						Call CreateNewProject("BPS")
						Call SplitBilanspositionShort(db)
					End If
					Client.RefreshFileExplorer
				End If
			Next
			Call WriteIntoLog("Die Verarbeitung ist abgeschlossen und die aufgeteilten Ergebnisdateien wurden im angegebenen Projektordner erstellt.")
			MsgBox "Die Verarbeitung ist abgeschlossen und die aufgeteilten Ergebnisdateien wurden im angegebenen Projektordner erstellt."
		Else
			Client.RefreshFileExplorer
			Call WriteIntoLog("Die Verarbeitung wurde abgebrochen.")
			MsgBox "Die Verarbeitung wurde abgebrochen."
		End If
	Else
		Call WriteIntoLog("Kein Ergebnis von Prüfungsschritten ist verfügbar. Bitte führen Sie zunächst einige Prüfungsschritte durch und versuchen Sie es erneut.")
		MsgBox "Kein Ergebnis von Prüfungsschritten ist verfügbar. Bitte führen Sie zunächst einige Prüfungsschritte durch und versuchen Sie es erneut."
	End If
	
	db.Close
	Set db = Nothing
	Set dialogInvoker = Nothing
	Set dialogParams = Nothing
	Kill sMainProjectPath & dbName
    Client.RefreshFileExplorer
	Call WriteIntoLog("Makro beendet am " & Date() & " um " & Time())
    Exit Sub
   
    ErrHandler:
    Call WriteIntoLog("Makro mit Fehler beendet am " & Date() & " um " & Time())
    SmartContext.Log.LogError "Error in custom action. Error number {0}. Error description: {1}", _
                             Err.Number, Err.Description
End Sub

Function ImportResultList
	sPfadJPM = oSC.GetKnownLocationPath(11) & "\SK_FuR" & "\Arbeitsteilung.jpm"
	sPfadBe	= oSC.GetKnownLocationPath(11) & "\SK_FuR" & "\report.txt"
	
	dbName = "Liste der Ergebnistabellen.IMD"
	' Datei importieren.
	Client.ImportPrintReport sPfadJPM, sPfadBe, dbName, False
	Set db = Client.OpenDatabase(dbName)
	Call WriteIntoLog( "End of ImportBericht")
	db.Close
	Set db = Nothing

End Function

Function ReadParameters(ByVal Counter As Integer)
	sOtherUserGen = "smartTextBox" & ((Counter-1)*4 + 1)
	sPathFolderGen = "smartTextBox" & ((Counter-1)*4 + 2)
	sRahmenNrGen =  "smartTextBox" & ((Counter-1)*4 + 3)
	sBilansTypeGen = "smartComboBox" & (Counter)
	sBilansCatGen = "smartComboBox" & (Counter + 5)
	sBilanzpositionShortGen =  "smartTextBox" & ((Counter-1)*4 + 4)
	sCheckBoxGen = "smartCheckBox" & m
	Call WriteIntoLog( "Name of Smartboxes: " & sOtherUserGen & " " & sPathFolderGen & " " & sRahmenNrGen & " " & sBilansTypeGen & " " & sBilansCatGen & " " & sBilanzpositionShortGen & " " & sCheckBoxGen)
	sOtherUser = result.Outputs.Item(sOtherUserGen)
	sPathFolder = result.Outputs.Item(sPathFolderGen)
	sRahmenNr = result.Outputs.Item(sRahmenNrGen)
	sBilansType = result.Outputs.Item(sBilansTypeGen)
	sBilansCat = result.Outputs.Item(sBilansCatGen)
	sBilanzpositionShort = result.Outputs.Item(sBilanzpositionShortGen)
	bExcel_Checked = result.Outputs.Item(sCheckBoxGen).Checked
	Call WriteIntoLog( "Input of Smartboxes: " & sOtherUser & " " & sPathFolder & " " & sRahmenNr & " " & sBilansType & " " & sBilansCat & " " & sBilanzpositionShort & " " & bExcel_Checked)
End Function

Function CreateNewProject(ByVal sTypeCriteria As String)
	If sTypeCriteria = "RN" Then
		sNameFolder = "RahmenNr_" & sRahmenNr
	ElseIf sTypeCriteria = "BPC" Then
		sNameFolder = iReplace(sBilansCat,"/"," ")
	Else
		sNameFolder = sBilanzpositionShort
	End If
	sNewProjectPath = sPathFolder & "\" & "Arbeitsteilung" & "-" & sOtherUser & "-" & sNameFolder & "\"
	Call WriteIntoLog( "Creating the name of new project is done: " & sNewProjectPath)
	If Not FileOrDirExists(sNewProjectPath) Then
		Call WriteIntoLog( "the new project-folder doesnt exist, trying to create it:  " & sNewProjectPath)
		MkDir sNewProjectPath
		Call WriteIntoLog( "creating new folder is done.")
	End If
	Call WriteIntoLog( "creating new project and writing default subfolders there.")
	Client.WorkingDirectory = sNewProjectPath
	Client.WorkingDirectory = sMainProjectPath
	Call WriteIntoLog( "setting Client.WorkingDirectory back to the main/original project.")
End Function

Function SplitRahmenNr(ByVal Database As Object)
	Set rs = Database.RecordSet
	rs.ToFirst
	Set rec = rs.ActiveRecord
	For dbcounter=1 To Database.count
		Call WriteIntoLog( "Starting to work on the result file with row number: " & dbcounter)
		rs.Next
		sTestName = rec.GetCharValue("TEST_NAME")
		sResulName = rec.GetCharValue("RESULT_NAME")
		sInputName = rec.GetCharValue("INPUT_PATH")
		
		If FileExists(sResulName) Then
			Call WriteIntoLog( "result file: " & sResulName & " exist.")
			If Not ( (InStr(1, sTestName, "SK-FuR-0024") > 0) OR (InStr(1, sTestName, "SK-FuR-0034") > 0) OR (InStr(1, sTestName, "SK-FuR-0030") > 0) ) Then
				Call WriteIntoLog( "Splitting file: " & sResulName & " base on RN.")
				Set dbloop = Client.OpenDatabase(sResulName)
				Set task = dbloop.Extraction
				task.IncludeAllFields
				stempname = Left(sResulName, Len(sResulName) - 4) & "_" & sRahmenNr  & ".IMD"
				'dbNameTempLoop = oSC.UniqueFileName(stempname, NO_REGISTRATION)
				dbNameTempLoop = stempname
				sCheckisinIN = InStr(1, sInputName, "Vergleich OBR Konten")
				sCheckisinINOBR = InStr(1, sInputName, "OBR_Konten_")
				If sCheckisinIN > 0 Then
					sCheckisinRN = InStr(1, sResulName, "im aktuellen Zeitraum.IMD")
					If sCheckisinRN > 0 Then
						sEqn =  "(" & "@LEFT(" & "RAHMENNR_" & "" & sVorherigesGJAHRShort & "" & "; 2)" & " == " &  """" & sRahmenNr & """" & ")"
					Else
						sEqn =  "(" & "@LEFT(" & "RAHMENNR_" & "" & sAktuelleGJAHRShort & "" & "; 2)" & " == " &  """" & sRahmenNr & """" & ")"
					End If
				ElseIf sCheckisinINOBR Then
					sEqn =  "(" & "@LEFT(RAHMENNR; 2)" & " == " &  """" & sRahmenNr & """" & ")"
				ElseIf ( InStr(1, sTestName, "SK-FuR-0022") > 0 And InStr(1, sResulName, "nicht_in_EUR") > 0 ) Or  ( InStr(1, sTestName, "SK-FuR-0021") > 0 And InStr(1, sResulName, "nicht_in_EUR") > 0 ) Or  ( InStr(1, sTestName, "SK-FuR-0020") > 0 And InStr(1, sResulName, "nicht_in_EUR") > 0 ) Or ( InStr(1, sTestName, "SK-FuR-0019") > 0 And InStr(1, sResulName, "nicht_in_EUR") > 0 )   Then
					sEqn =  "(" & "RAHMENNR_2STELLIG1"  & " == " &  """" & sRahmenNr & """" & ")"
				Else
					sEqn =  "(" & "RAHMENNR_2STELLIG"  & " == " &  """" & sRahmenNr & """" & ")"
				End If
				Call WriteIntoLog( "filter-equation for splitting: " & sEqn)
				task.AddExtraction dbNameTempLoop, "", sEqn
				task.PerformTask 1, dbloop.Count
				dbloop.Close
				Set task = Nothing
				Set dbloop = Nothing
				Dim sWorkingFile As String
				Dim sDestinationFile As String
				sWorkingFile = sMainProjectPath & dbNameTempLoop
				sDestinationFile = sNewProjectPath & sResulName
				Call WriteIntoLog( "sWorkingFile: " & sWorkingFile & " sDestinationFile: " & sDestinationFile)
				FileCopy sWorkingFile, sDestinationFile
				Call WriteIntoLog( "copying the file is done.")
				Kill sMainProjectPath & dbNameTempLoop
				Call WriteIntoLog( "deleting the splitted file in original project is done.")
				
				If bExcel_Checked Then
					stempname = sNewProjectPath & "Exporte.ILB\" & Left(sResulName, Len(sResulName) - 4) & ".XLSX"
					Set dbloopsplit = Client.OpenDatabase(sDestinationFile)
					Set task = dbloopsplit.ExportDatabase
					task.IncludeAllFields
					task.PerformTask stempname, "Datei", "XLSX", 1, dbloopsplit.Count, ""
					dbloopsplit.Close
					Set dbloopsplit = Nothing
					Set task = Nothing
				End If
				
			End If
		End If
	Next
End Function

Function SplitBilanspositionShort(ByVal Database As Object)
	Set rs = Database.RecordSet
	rs.ToFirst
	Set rec = rs.ActiveRecord
	For dbcounter=1 To Database.count
		Call WriteIntoLog( "Starting to work on the result file with row number: " & dbcounter)
		rs.Next
		sTestName = rec.GetCharValue("TEST_NAME")
		sResulName = rec.GetCharValue("RESULT_NAME")
		sInputName = rec.GetCharValue("INPUT_PATH")
		
		If FileExists(sResulName) Then
			Call WriteIntoLog( "result file: " & sResulName & " exist.")
			If Not ( (InStr(1, sTestName, "SK-FuR-0001") > 0) OR (InStr(1, sTestName, "SK-FuR-0003") > 0) OR (InStr(1, sTestName, "SK-FuR-0004") > 0) OR (InStr(1, sTestName, "SK-FuR-0018") > 0 AND InStr(1, sResulName, "summiert") > 0) OR (InStr(1, sTestName, "SK-FuR-0019") > 0 AND InStr(1, sResulName, "je_KtoRahmen") > 0) OR (InStr(1, sTestName, "SK-FuR-0020") > 0 AND InStr(1, sResulName, "je_KtoRahmen") > 0) OR (InStr(1, sTestName, "SK-FuR-0021") > 0 AND InStr(1, sResulName, "in_EUR") > 0) OR (InStr(1, sTestName, "SK-FuR-0022") > 0 AND InStr(1, sResulName, "in_EUR") > 0) OR (InStr(1, sTestName, "SK-FuR-0024") > 0) OR (InStr(1, sTestName, "SK-FuR-0034") > 0) ) Then
				Call WriteIntoLog( "Splitting file: " & sResulName & " base on BPS.")
				Set dbloop = Client.OpenDatabase(sResulName)
				Set task = dbloop.Extraction
				task.IncludeAllFields
				stempname = Left(sResulName, Len(sResulName) - 4) & "_" & sBilanzpositionShort  & ".IMD"
				'dbNameTempLoop = oSC.UniqueFileName(stempname, NO_REGISTRATION)
				dbNameTempLoop = stempname
				sCheckisinIN = InStr(1, sInputName, "Vergleich OBR Konten")
				If sCheckisinIN > 0 Then
					sCheckisinRN = InStr(1, sResulName, "im aktuellen Zeitraum.IMD")
					If sCheckisinRN > 0 Then
						sEqn =  "(@Left(" & "POSITION_SHORT_" & "" & sVorherigesGJAHRShort & ";3)" & "" & " == " &  """" & sBilanzpositionShort & """" & ")"
					Else
						sEqn =  "(@Left(" & "POSITION_SHORT_" & "" & sAktuelleGJAHRShort & ";3)" & "" & " == " &  """" & sBilanzpositionShort & """" & ")"	
					End If
				ElseIf (InStr(1, sTestName, "SK-FuR-0030") > 0) Then
					sEqn =  "(" & "@Mid(" & "BILANZPOSITION_" & "" & sAktuelleGJAHRShort & "" & ";2;3)"  & " == " &  """" & sBilanzpositionShort & """" & ")"
				Else
					sEqn =  "(" & "@Left(POSITION_SHORT;3)"  & " == " &  """" & sBilanzpositionShort & """" & ")"
				End If
				Call WriteIntoLog( "filter-equation for splitting: " & sEqn)
				task.AddExtraction dbNameTempLoop, "", sEqn
				task.PerformTask 1, dbloop.Count
				dbloop.Close
				Set task = Nothing
				Set dbloop = Nothing
				Dim sWorkingFile As String
				Dim sDestinationFile As String
				sWorkingFile = sMainProjectPath & dbNameTempLoop
				sDestinationFile = sNewProjectPath & sResulName
				Call WriteIntoLog( "sWorkingFile: " & sWorkingFile & " sDestinationFile: " & sDestinationFile)
				FileCopy sWorkingFile, sDestinationFile
				Call WriteIntoLog( "copying the file is done.")
				Kill sMainProjectPath & dbNameTempLoop
				Call WriteIntoLog( "deleting the splitted file in original project is done.")
				
				If bExcel_Checked Then
					stempname = sNewProjectPath & "Exporte.ILB\" & Left(sResulName, Len(sResulName) - 4) & ".XLSX"
					Set dbloopsplit = Client.OpenDatabase(sDestinationFile)
					Set task = dbloopsplit.ExportDatabase
					task.IncludeAllFields
					task.PerformTask stempname, "Datei", "XLSX", 1, dbloopsplit.Count, ""
					dbloopsplit.Close
					Set dbloopsplit = Nothing
					Set task = Nothing
				End If
				
			End If
		End If
	Next
	Set rs = Nothing
	Set rec = Nothing
End Function

Function SplitBilansposition(ByVal Database As Object, ByVal BPeqn As String)
	Set rs = Database.RecordSet
	rs.ToFirst
	Set rec = rs.ActiveRecord
	For dbcounter=1 To Database.count
		Call WriteIntoLog( "Starting to work on the result file with row number: " & dbcounter)
		rs.Next
		sTestName = rec.GetCharValue("TEST_NAME")
		sResulName = rec.GetCharValue("RESULT_NAME")
		sInputName = rec.GetCharValue("INPUT_PATH")
		
		If FileExists(sResulName) Then
			Call WriteIntoLog( "result file: " & sResulName & " exist.")
			If Not ( (InStr(1, sTestName, "SK-FuR-0001") > 0) OR (InStr(1, sTestName, "SK-FuR-0003") > 0) OR (InStr(1, sTestName, "SK-FuR-0004") > 0) OR (InStr(1, sTestName, "SK-FuR-0018") > 0 AND InStr(1, sResulName, "summiert") > 0) OR (InStr(1, sTestName, "SK-FuR-0019") > 0 AND InStr(1, sResulName, "je_KtoRahmen") > 0) OR (InStr(1, sTestName, "SK-FuR-0020") > 0 AND InStr(1, sResulName, "je_KtoRahmen") > 0) OR (InStr(1, sTestName, "SK-FuR-0021") > 0 AND InStr(1, sResulName, "in_EUR") > 0) OR (InStr(1, sTestName, "SK-FuR-0022") > 0 AND InStr(1, sResulName, "in_EUR") > 0) OR (InStr(1, sTestName, "SK-FuR-0024") > 0) OR (InStr(1, sTestName, "SK-FuR-0034") > 0) ) Then
				Call WriteIntoLog( "Splitting file: " & sResulName & " base on BPC.")
				Set dbloop = Client.OpenDatabase(sResulName)
				Set task = dbloop.Extraction
				task.IncludeAllFields
				stempname = Left(sResulName, Len(sResulName) - 4) & "_" & BPeqn  & ".IMD"
				'dbNameTempLoop = oSC.UniqueFileName(stempname, NO_REGISTRATION)
				dbNameTempLoop = stempname
				sCheckisinIN = InStr(1, sInputName, "Vergleich OBR Konten")
				If sCheckisinIN > 0 Then
					sCheckisinRN = InStr(1, sResulName, "im aktuellen Zeitraum.IMD")
					If sCheckisinRN > 0 Then
						sEqn =  "(" & "@LEFT(" & "POSITION_SHORT_" & "" & sVorherigesGJAHRShort & "" & ";1)" & " == " &  """" & BPeqn & """" & ")"
					Else
						sEqn =  "(" & "@LEFT(" & "POSITION_SHORT_" & "" & sAktuelleGJAHRShort & "" & ";1)" & " == " &  """" & BPeqn & """" & ")"
					End If
				Elseif (InStr(1, sTestName, "SK-FuR-0030") > 0) Then
					sEqn =  "(" & "@Mid(" & "BILANZPOSITION_" & "" & sAktuelleGJAHRShort & "" & ";2;1)" & " == " &  """" & BPeqn & """" & ")"
				Else
					sEqn =  "(" & "@LEFT(" & "POSITION_SHORT" & ";1)" & " == " &  """" & BPeqn & """" & ")"
				End If
				Call WriteIntoLog( "filter-equation for splitting: " & sEqn)
				task.AddExtraction dbNameTempLoop, "", sEqn
				task.PerformTask 1, dbloop.Count
				dbloop.Close
				Set task = Nothing
				Set dbloop = Nothing
				Dim sWorkingFile As String
				Dim sDestinationFile As String
				sWorkingFile = sMainProjectPath & dbNameTempLoop
				sDestinationFile = sNewProjectPath & sResulName
				Call WriteIntoLog( "sWorkingFile: " & sWorkingFile & " sDestinationFile: " & sDestinationFile)
				FileCopy sWorkingFile, sDestinationFile
				Call WriteIntoLog( "copying the file is done.")
				Kill sMainProjectPath & dbNameTempLoop
				Call WriteIntoLog( "deleting the splitted file in original project is done.")
				
				If bExcel_Checked Then
					stempname = sNewProjectPath & "Exporte.ILB\" & Left(sResulName, Len(sResulName) - 4) & ".XLSX"
					Set dbloopsplit = Client.OpenDatabase(sDestinationFile)
					Set task = dbloopsplit.ExportDatabase
					task.IncludeAllFields
					task.PerformTask stempname, "Datei", "XLSX", 1, dbloopsplit.Count, ""
					dbloopsplit.Close
					Set dbloopsplit = Nothing
					Set task = Nothing
				End If
				
			End If
		End If
	Next
	Set rs = Nothing
	Set rec = Nothing
End Function

Function WriteIntoLog(ByVal sMessage As String)
Dim Filenum As Integer	
	Filenum = FreeFile
	Open sLogPath For Append As Filenum
	Print #Filenum, sMessage
	Close Filenum
End Function

Function FileOrDirExists(PathName As String) As Boolean
        'Macro Purpose: Function returns TRUE if the specified file
    '               or folder exists, false if not.
    'PathName     : Supports Windows mapped drives or UNC
    '             : Supports Macintosh paths
    'File usage   : Provide full file path and extension
    'Folder usage : Provide full folder path
    '               Accepts with/without trailing "\" (Windows)
    '               Accepts with/without trailing ":" (Macintosh)
    
    Dim iTemp As Integer
    
    'Ignore errors to allow for error evaluation
    On Error Resume Next
    iTemp = GetAttr(PathName)
    
    'Check if error exists and set response appropriately
    Select Case Err.Number
        Case Is = 0
            FileOrDirExists = True
        Case Else
            FileOrDirExists = False
    End Select
    Err.Number = 0
    
    'Resume error checking
    On Error GoTo 0
End Function

Function FileExists(ByVal sFileName As String) As Boolean
	
	'Funktion initialisieren
	FileExists = FALSE

	'Objekt definieren und erzeugen
	Dim oFso As Object
	Set oFso = CreateObject("Scripting.FileSystemObject")
	
	'Prüfung ob Datei exisitiert mittels der Methode "FileExists" des Objektes oFso
	'und dem Dateinamen
	If oFso.FileExists(sFileName) = TRUE Then
		FileExists = TRUE	'Rückgabewert der Funktion, wenn Datei vorhanden
	Else
		FileExists = FALSE	'Rückgabewert der Funktion, wenn Datei NICHT vorhanden
	End If
	
	'Objekt zerstören
	Set oFso = Nothing
	
End Function

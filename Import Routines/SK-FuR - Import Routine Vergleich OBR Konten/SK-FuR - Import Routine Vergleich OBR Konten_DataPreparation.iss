'-------------------------------------------------------------------------------------
' Title:		SKA_FuR - Import Routine OBR Vergleich Preparation
' CIR:		SKA_FuR
' Customer:	Sparkassen
' Created by:	AS
' Created on:	28.10.2020
' Version:		1.00
'-------------------------------------------------------------------------------------
' Decription:	Imports a second OBR Konten file and Umsetzungen to compare a previous year the the current year.
'				It is possible to you an existing OBR Konten file from the current or a differen IDEA project
'-------------------------------------------------------------------------------------
' Files:		Requires 4 Input files
'			- OBR Konten current year
'			- OBR Konten previous year
'			- Umsetzungen current year
'			- Umsetzungen previous year
'-------------------------------------------------------------------------------------
' Change History
'-------------------------------------------------------------------------------------
' Changed by:	AS
' Changed on:	16.12.2020
' Requested by:	Audicon/AG
' Comment:		fill account number with leading zeros
'------------------
' Changed by:	AS
' Changed on:	17.12.2020
' Requested by:	Audicon/AG
' Comment:		split SYSTEMPOSITION in multiple columns for adding Umsetzungen, add column POSITION_SHORT
'------------------
' Changed by:	AS
' Changed on:	27.07.2022
' Requested by:	Audicon/AG
' Comment:		rename columns for better interpratation of result files
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
Dim oFM As Object 'field management

Dim sourceFileName As String

' IDEA standard variables
Dim db As Object
Dim dbName As String
Dim eqn As String
Dim task As Object
Dim field As Object
Dim ProjectManagement As Object

' Dialog Output
Dim sAktuelleGJAHR As String
Dim sVorherigesGJAHR As String
Dim sAktuelleGJAHRShort As String ' 27.07.2022
Dim sVorherigesGJAHRShort As String' 27.07.2022
		
Dim bAktuellesGJAHRCSV As Boolean
Dim bAktuellesGJAHRCurrentProject As Boolean
Dim bAktuellesGJAHRDifferentProject As Boolean
Dim bVorherigesGJAHRCSV As Boolean
Dim bVorherigesGJAHRCurrentProject As Boolean
Dim bVorherigesGJAHRDifferentProject As Boolean

Dim sPathCurrentYearOBR As String
Dim sPathPreviousYearOBR As String
Dim sPathCurrentYearUmsetzungen As String
Dim sPathPreviousYearUmsetzungen As String
Dim sPfadBE	As String
Dim sPfadBEDesc As String

' Import
Dim sImportVariantAktuellesGJAHR As String
Dim sImportVariantVorherigesGJAHR As String

Dim sTemplateOBR As String
Dim sTemplateUmsetzungen As String

Dim sFirstOBR As String
Dim sSecondOBR As String
Dim sFirstUmsetzungen As String
Dim sSecondUmsetzungen As String
Dim sFirstBilPos As String
Dim sSecondBilPos As String

Dim ResultMsgBox As Integer

' Analyses
Dim iPosCounter As Integer
Dim iMaxPosLength As Integer
Dim sPosColumn As String

Dim i As Integer
Dim iTableCount As Integer

' Results
dim sVergleichOBRKonten as string
Dim sVergleichBilanzpositionenUmsetzungen As String

' Temp
Dim sSummeOBR As String
Dim sSummeUmsetzungen As String
Dim sSummeOBRUmsetzungen As String
Dim sFirstSummeOBRUmsetzungen As String
Dim sSecondSummeOBRUmsetzungen As String
Dim dbImportOBRTemp As string
Dim dbImportBVS	As String

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
	sAktuelleGJAHR = oPara.Get4Project ("sAktuelleGJAHR")
	sAktuelleGJAHRShort = right(sAktuelleGJAHR, 2)
	sVorherigesGJAHR = oPara.Get4Project ("sVorherigesGJAHR")
	sVorherigesGJAHRShort = right(sVorherigesGJAHR, 2)
	
	bAktuellesGJAHRCSV = oPara.Get4Project ("bAktuellesGJAHRCSV")
	bAktuellesGJAHRCurrentProject = oPara.Get4Project ("bAktuellesGJAHRCurrentProject")
	bAktuellesGJAHRDifferentProject = oPara.Get4Project ("bAktuellesGJAHRDifferentProject")
	bVorherigesGJAHRCSV = oPara.Get4Project ("bVorherigesGJAHRCSV")
	bVorherigesGJAHRCurrentProject = oPara.Get4Project ("bVorherigesGJAHRCurrentProject")
	bVorherigesGJAHRDifferentProject = oPara.Get4Project ("bVorherigesGJAHRDifferentProject")
	
	If bAktuellesGJAHRCSV Then sImportVariantAktuellesGJAHR = "CSV"
	If bAktuellesGJAHRCurrentProject Then sImportVariantAktuellesGJAHR = "Current"
	If bAktuellesGJAHRDifferentProject Then sImportVariantAktuellesGJAHR = "Different"
	If bVorherigesGJAHRCSV Then sImportVariantVorherigesGJAHR = "CSV"
	If bVorherigesGJAHRCurrentProject Then sImportVariantVorherigesGJAHR = "Current"
	If bVorherigesGJAHRDifferentProject Then sImportVariantVorherigesGJAHR = "Different"
	
	
	
	sPathCurrentYearOBR = oPara.Get4Project ("sPathCurrentYearOBR")
	sPathPreviousYearOBR = oPara.Get4Project ("sPathPreviousYearOBR")
	sPathCurrentYearUmsetzungen = oPara.Get4Project ("sPathCurrentYearUmsetzungen")
	sPathPreviousYearUmsetzungen = oPara.Get4Project ("sPathPreviousYearUmsetzungen")
	
	sTemplateOBR = oSC.GetKnownLocationPath(11) & "\SK_FuR" & "\OBR_Konten.RDF"
	sTemplateUmsetzungen = oSC.GetKnownLocationPath(11) & "\SK_FuR" & "\Umsetzungen.RDF"
	sPfadBE	= oSC.GetKnownLocationPath(11) & "\SK_FuR" & "\Betriebsvergleichsschlüssel.csv"
	sPfadBEDesc = oSC.GetKnownLocationPath(11) & "\SK_FuR" & "\Betriebsvergleichsschlüssel.RDF"
'-----------------------------------------------------------------------------------------
' Funtion Calls
'-----------------------------------------------------------------------------------------
SetCheckpoint "Begin of Functions"
	Call ImportBetriebsvergleichsschluessel(sPfadBE, sPfadBEDesc)
	Call ImportFiles
	'Kill Client.WorkingDirectory & dbImportBVS
	Call Preparation
	Client.RefreshFileExplorer
SetCheckpoint "Start Tagging/Register Tables"
oLog.LogMessage "Start Tagging."
	Call registerResult(sFirstOBR, FINAL_RESULT)
	Call registerResult(sVergleichOBRKonten, FINAL_RESULT)
	Call registerResult(sVergleichBilanzpositionenUmsetzungen, FINAL_RESULT)
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
'-----------------------------------------------------------------------------------------
' Import Files
'-----------------------------------------------------------------------------------------
Function ImportFiles
SetCheckpoint "Import aktuelles Geschäftsjahr"
	Select Case sImportVariantAktuellesGJAHR
		Case "CSV"
			sFirstOBR = OBRCSVImport(sPathCurrentYearOBR, sTemplateOBR, sAktuelleGJAHR, "OBR_Konten")
			Call CheckAccountLength(sFirstOBR)
		Case "Current"
			sFirstOBR = CurrentCheck(sPathCurrentYearOBR, sAktuelleGJAHR)
		Case "Different"
			sFirstOBR = DifferentCheck(sPathCurrentYearOBR, sAktuelleGJAHR)
		Case Else
	End Select
SetCheckpoint "Import vorheriges Geschäftsjahr"
	Select Case sImportVariantVorherigesGJAHR
		Case "CSV"
			sSecondOBR = OBRCSVImport(sPathPreviousYearOBR, sTemplateOBR, sVorherigesGJAHR, "OBR_Konten")
			Call CheckAccountLength(sSecondOBR)
		Case "Current"
			sSecondOBR = CurrentCheck(sPathPreviousYearOBR, sVorherigesGJAHR)
		Case "Different"
			sSecondOBR = DifferentCheck(sPathPreviousYearOBR, sVorherigesGJAHR)
		Case Else
	End Select
SetCheckpoint "Import Umsetzungen aktuelles Geschäftsjahr"
	sFirstUmsetzungen = CSVImport(sPathCurrentYearUmsetzungen, sTemplateUmsetzungen, sAktuelleGJAHR, "Umsetzungen")
SetCheckpoint "Import Umsetzungen vorheriges Geschäftsjahr"
	sSecondUmsetzungen = CSVImport(sPathPreviousYearUmsetzungen, sTemplateUmsetzungen, sVorherigesGJAHR, "Umsetzungen")
	
End Function

Function CSVImport(ByVal sFile As String, ByVal sTemplate As String, ByVal sYear As String, ByVal sFileType As String) As String
	dbName = "{" & sFileType & "_" & sYear & "}.IMD"
	Dim headerName As String
	Dim hasHeader As Integer
	headerName = "Dok"
	hasHeader = CheckCSVHeader(sFile, headerName)
oLog.LogMessage "Result of Instr: " & hasHeader	
oLog.LogMessage "Import File " & dbName
	If hasHeader > 0 Then
		Dim sTemplate_new As String
oLog.LogMessage "New Format of Umsetzen "
		sTemplate_new  = oSC.GetKnownLocationPath(11) & "\SK_FuR" & "\Umsetzungen_neu.RDF"
		Client.ImportDelimFile sFile, dbName, FALSE, "", sTemplate_new, TRUE
		CSVImport = dbName
	Else
oLog.LogMessage "Old Format of Umsetzen "
		Client.ImportDelimFile sFile, dbName, FALSE, "", sTemplate, TRUE
		CSVImport = dbName
	End If
oLog.LogMessage "Import File " & dbName & " finished."
End Function

Function OBRCSVImport(ByVal sFile As String, ByVal sTemplate As String, ByVal sYear As String, ByVal sFileType As String) As String
	dbName = "{" & sFileType & "_" & sYear & "}.IMD"
	dbImportOBRTemp = "{OBR_Konten_Temp_" & sYear & "}.IMD"
	dbImportBVS = "{BVS_Gesamt}.IMD"
oLog.LogMessage "Import File " & dbName
	Client.ImportDelimFile sFile, dbImportOBRTemp, FALSE, "", sTemplate, TRUE
	Call AddFieldOBR(dbImportOBRTemp)
	Call JoinOBR2BVS(dbImportOBRTemp, dbImportBVS, dbName)
	OBRCSVImport = dbName
oLog.LogMessage "Import File " & dbName & " finished."
End Function

Function CheckAccountLength (ByVal sFile As String)
' AS 16.12.2020: get the original account number and add zeros at the front until it is ten characters long
' 1. rename original field
' 2. create new field
oLog.LogMessage "check account length"
Dim iMaxAccountLength As Integer
Dim iMinAccountLength As Integer
iMinAccountLength = 0
Dim sNewFieldName As String
	iMaxAccountLength = oSC.GetMaxLength(sFile, "KONTO", iMinAccountLength)
	If iMaxAccountLength < 10 Then
oLog.LogMessage "max account length: " & iMaxAccountLength
oLog.LogMessage "start fill with leading zeros " & Date()
		Set db = Client.OpenDatabase(sFile)
		Set sNewFieldName = oSC.RenField(db, "KONTO", "KONTO_OG")
		db.Close
		Set db = Nothing
		Set oFM = oMC.FieldManagement(sFile)
		oFM.AppendField "KONTO", "KONTO_OG wurde mit führenden Nullen aufgefüllt.", 3, 10, 0, "@Repeat(""0"";10-@Len(KONTO_OG))+KONTO_OG"
		oFM.PerformTask
		Set oFM = Nothing
oLog.LogMessage "end fill with leading zeros " & Date()
	Else
oLog.LogMessage "max account length: " & iMaxAccountLength
	End If
'AS 17.12.2020
	Set oFM = oMC.FieldManagement(sFile)
	oFM.AppendField "POSITION_SHORT", "", 3, 5, 0, "@Mid(POSITIONEN;2;5)"
	oFM.PerformTask
	Set oFM = Nothing
End Function

Function CurrentCheck(ByVal sFile As String, ByVal sYear As String) As String
SetCheckpoint "Begin CurrentCheck"
	Dim sFileNameShort As String
	Dim sNewFileName As String
	sFileNameShort = Right(sFile, 21)
	sNewFileName = "{OBR_Konten_" & sYear & "}.IMD"
	If sFileNameShort <> sNewFileName Then
		ResultMsgBox = MsgBox ("Der Name der ausgewählten Datei " & "- " & sFileNameShort & " - entspricht nicht dem gewählten Format für das Geschäftsjahr - " & sNewFileName & "." & Chr(13) & "Möchten Sie die Datei Umbenennen?", MB_YESNO)
		If ResultMsgBox = IDYES Then
			Set ProjectManagement = client.ProjectManagement
			ProjectManagement.RenameDatabase sFile, "{OBR_Konten_" & sYear & "}.IMD"
			Set ProjectManagement = Nothing
		Else
			SmartContext.ExecutionStatus = EXEC_STATUS_CANCELED
			SmartContext.AbortImport = True
			
			SmartContext.Log.LogMessage "Excecution was stopped by user."
			oLog.LogMessage "Execution Time End: " & Now()

			Set oLog = Nothing
			Set oMC = Nothing
			Set oSC = Nothing
			Set oPara = Nothing
			Stop
		End If
	End If
	CurrentCheck = sFileNameShort
End Function

Function DifferentCheck(ByVal sFile As String, ByVal sYear As String) As String
SetCheckpoint "Beginn DifferentCheck"
	Dim sFileNameShort As String
	Dim sNewFileName As String
	sFileNameShort = Right(sFile, 21)
	sNewFileName = "{OBR_Konten_" & sYear & "}.IMD"
	If sFileNameShort <> sNewFileName Then
		ResultMsgBox = MsgBox ("Der Name der ausgewählten Datei " & "- " & sFileNameShort & " - entspricht nicht dem gewählten Format für das Geschäftsjahr - " & sNewFileName & "." & Chr(13) & "Möchten Sie die Datei Umbenennen?", MB_YESNO)
		If ResultMsgBox = IDYES Then
			FileCopy sFile, Client.WorkingDirectory & sNewFileName
			oLog.LogMessage sNewFileName & " copied."
		Else
			SmartContext.ExecutionStatus = EXEC_STATUS_CANCELED
			SmartContext.AbortImport = True
			
			SmartContext.Log.LogMessage "Excecution was stopped by user."
			oLog.LogMessage "Execution Time End: " & Now()

			Set oLog = Nothing
			Set oMC = Nothing
			Set oSC = Nothing
			Set oPara = Nothing
			Stop
		End If
	Else
		FileCopy sFile, Client.WorkingDirectory & sNewFileName
		oLog.LogMessage sNewFileName & " copied."
	End If
	DifferentCheck = sNewFileName
End Function

function Preparation
'----------------erste Datei-----------------------------------------
SetCheckpoint "Vergleich OBR [first Result], Checkpoint 1.0"
	Set db = Client.OpenDatabase(sFirstOBR)
	Set task = db.JoinDatabase
	task.FileToJoin sSecondOBR
	task.AddPFieldToInc "KONTO"
	task.AddPFieldToInc "UNR"
	task.AddPFieldToInc "RAHMENNR"
	task.AddPFieldToInc "BEZEICHNUNG"
	task.AddPFieldToInc "WKZ"
	task.AddPFieldToInc "NABU_NR"
	task.AddPFieldToInc "POSITIONEN"
	task.AddPFieldToInc "AZ9_SALDO"
	task.AddPFieldToInc "OBR_SALDO"
	task.AddPFieldToInc "AZ9_SALDO_IN_WÄHR"
	task.AddPFieldToInc "BV_SCHL"
	task.AddPFieldToInc "BESCHREIBUNG_PRIMÄRE_POSITION"
	task.AddPFieldToInc "SYSTEMPOSITION"
	task.AddPFieldToInc "ART"
	task.AddPFieldToInc "GUV_MKML"
	task.AddPFieldToInc "STEUERPOS_AKT_JAHR"
	task.AddPFieldToInc "STEUERL_LAT"
	task.AddPFieldToInc "STEUERL_LAT2"
	task.AddPFieldToInc "POSITION_AKT_JAHR"
	task.AddPFieldToInc "POSITION_VORJAHR"
	task.AddPFieldToInc "ÄNDERUNG"
	task.AddPFieldToInc "ERÖFFNUNG"
	task.AddPFieldToInc "AUFLÖSUNG"
	'task.AddPFieldToInc "SHK"
	'task.AddPFieldToInc "RAHMENNR_2STELLIG"
	'task.AddPFieldToInc "RAHMENNR_3STELLIG"
	task.AddPFieldToInc "POSITION_SHORT"
	task.AddPFieldToInc "BUCHUNGSKATEGORIE_BV"
	'task.AddPFieldToInc "KURZBESCHREIBUNG_SVZ"
	'-------------------------------------------------------------
	task.AddSFieldToInc "KONTO"
	task.AddSFieldToInc "UNR"
	task.AddSFieldToInc "RAHMENNR"
	task.AddSFieldToInc "BEZEICHNUNG"
	task.AddSFieldToInc "WKZ"
	task.AddSFieldToInc "NABU_NR"
	task.AddSFieldToInc "POSITIONEN"
	task.AddSFieldToInc "AZ9_SALDO"
	task.AddSFieldToInc "OBR_SALDO"
	task.AddSFieldToInc "AZ9_SALDO_IN_WÄHR"
	task.AddSFieldToInc "BV_SCHL"
	task.AddSFieldToInc "BESCHREIBUNG_PRIMÄRE_POSITION"
	task.AddSFieldToInc "SYSTEMPOSITION"
	task.AddSFieldToInc "ART"
	task.AddSFieldToInc "GUV_MKML"
	task.AddSFieldToInc "STEUERPOS_AKT_JAHR"
	task.AddSFieldToInc "STEUERL_LAT"
	task.AddSFieldToInc "STEUERL_LAT2"
	task.AddSFieldToInc "POSITION_AKT_JAHR"
	task.AddSFieldToInc "POSITION_VORJAHR"
	task.AddSFieldToInc "ÄNDERUNG"
	task.AddSFieldToInc "ERÖFFNUNG"
	task.AddSFieldToInc "AUFLÖSUNG"
	task.AddSFieldToInc "POSITION_SHORT"
	task.AddSFieldToInc "BUCHUNGSKATEGORIE_BV"
	'task.AddSFieldToInc "KURZBESCHREIBUNG_SVZ"
	task.AddMatchKey "KONTO", "KONTO", "A"
	task.AddMatchKey "UNR", "UNR", "A" '----> UNR da ansonsten keine Eindeutige Verbidnung möglich ist.
	task.CreateVirtualDatabase = False
	sVergleichOBRKonten = "Vergleich OBR Konten " & sAktuelleGJAHR & " zu " & sVorherigesGJAHR &".IMD"
	task.PerformTask sVergleichOBRKonten, "", WI_JOIN_ALL_REC
	Set task = Nothing
	Set db = Nothing
	' 27.07.2022
SetCheckpoint "Vergleich OBR [first Result], Checkpoint 2.0"
	Call renameColumnsVergleichOBRKonten
oLog.LogMessage sVergleichOBRKonten & " created."
'-------------zweite Datei-------------------------------------------
SetCheckpoint "Vergleich Bilanzpositionen [second Result], Checkpoint 1.0" ' AS 17.12.2020
	sFirstBilPos = PositionenPrep(sFirstOBR, sAktuelleGJAHR)
	sSecondBilPos = PositionenPrep(sSecondOBR, sVorherigesGJAHR)
SetCheckpoint "Vergleich Bilanzpositionen [second Result], Checkpoint 2.0"	
	sFirstSummeOBRUmsetzungen = JoinOBRUmsetzungen(sFirstBilPos, sFirstUmsetzungen, sAktuelleGJAHRShort)
	sSecondSummeOBRUmsetzungen = JoinOBRUmsetzungen(sSecondBilPos, sSecondUmsetzungen, sVorherigesGJAHRShort)	
SetCheckpoint "Vergleich Bilanzpositionen [second Result], Checkpoint 3.0"
	Set db = Client.OpenDatabase(sFirstSummeOBRUmsetzungen)
	Set task = db.JoinDatabase
	task.FileToJoin sSecondSummeOBRUmsetzungen
	task.IncludeAllPFields
	task.IncludeAllSFields
	task.AddMatchKey "BILANZPOSITION_" & sAktuelleGJAHRShort, "BILANZPOSITION_" & sVorherigesGJAHRShort, "A"
	'task.AddMatchKey "POS", "POS", "A"
	'task.AddMatchKey "POS1", "POS1", "A"
	task.CreateVirtualDatabase = False
	sVergleichBilanzpositionenUmsetzungen = "Vergleich Bilanzpositionen inkl Umsetzungen " & sAktuelleGJAHR & " zu " & sVorherigesGJAHR &".IMD"
	task.PerformTask sVergleichBilanzpositionenUmsetzungen, "", WI_JOIN_ALL_REC
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	'27.07.2022
	Call renameColumnsVergleichBilpoUmsetzungen
	'Set db = Client.OpenDatabase(sVergleichBilanzpositionenUmsetzungen)
	''oSC.RenameField db, "POS", "POS_OBR_" & sAktuelleGJAHR
	'oSC.RenameField db, "ANZ_SAETZE", "ANZ_POS_OBR_" & sAktuelleGJAHR
	''oSC.RenameField db, "POS1", "POS_UMSETZUNGEN_" & sAktuelleGJAHR
	'oSC.RenameField db, "ANZ_SAETZE1", "ANZ_POS_UMSETZUNGEN_" & sAktuelleGJAHR
	''oSC.RenameField db, "POS2", "POS_OBR_" & sVorherigesGJAHR
	'oSC.RenameField db, "ANZ_SAETZE2", "ANZ_POS_OBR_" & sVorherigesGJAHR
	''oSC.RenameField db, "POS11", "POS_UMSETZUNGEN_" & sVorherigesGJAHR
	'oSC.RenameField db, "ANZ_SAETZE11", "ANZ_POS_UMSETZUNGEN_" & sVorherigesGJAHR
	'db.Close
	'set db = nothing
oLog.LogMessage sVergleichBilanzpositionenUmsetzungen  & " created."
End Function

Function PositionenPrep(ByVal sFile As String, ByVal sYear As String) As String
SetCheckpoint "PositionenPrep [second Result] " & sYear & ", Checkpoint 1.0"
' AS 17.12.2020
' POSITIONEN in einzelne Spalten trennen. Dazu wird zusätzlich eine "Rest"-Spalte verwendet. Solange diese nicht leer ist, wird weiter gemacht. 
' Voraussetzung: die einzelnen Positionen sind mit Komma und Leerzeichen getrennt.
	iPosCounter = 1
	iMaxPosLength = oSC.GetMaxLength(sFile, "POSITIONEN")
	While iMaxPosLength <> 0
		If iPosCounter = 1 Then
			sPosColumn = "POSITIONEN"
		Else
			sPosColumn = "POS_" & iPosCounter - 1 & "_REST"
		End If
		Set oFM = oMC.FieldManagement(sFile)
		oFM.AppendField "POS_" & iPosCounter , iPosCounter & "te Position", 3, iMaxPosLength, 0, "@if(@FindOneOf(" & sPosColumn &  ";"","")<>0;@Left(" & sPosColumn &  ";@FindOneOf(" & sPosColumn &  ";"","")-1);" & sPosColumn &  ")"
		oFM.AppendField "POS_" & iPosCounter & "_REST", iPosCounter & "te Position Rest", 3, iMaxPosLength, 0, "@if(@FindOneOf(" & sPosColumn &  ";"","")<>0;@Right(" & sPosColumn &  ";@Len(" & sPosColumn &  ")-@FindOneOf(" & sPosColumn &  ";"","")-1);"""")"
		oFM.PerformTask
		Set oFM = Nothing
		iMaxPosLength = oSC.GetMaxLength(sFile, "POS_" & iPosCounter & "_REST")
		iPosCounter = iPosCounter + 1
	Wend
SetCheckpoint "PositionenPrep [second Result] " & sYear & ", Checkpoint 2.0"
' AS 17.12.2020
' Extraktion der einzelnen Positionsspalten mit dem jeweiligen OBR_BETRAG
	For i = 1 To iPosCounter - 1
		Set db = Client.OpenDatabase(sFile)
		Set task = db.Extraction
		task.AddFieldToInc "KONTO"
		task.AddFieldToInc "UNR"
		task.AddFieldToInc "RAHMENNR"
		task.AddFieldToInc "BEZEICHNUNG"
		task.AddFieldToInc "WKZ"
		task.AddFieldToInc "NABU_NR"
		task.AddFieldToInc "POSITIONEN"
		task.AddFieldToInc "AZ9_SALDO"
		task.AddFieldToInc "OBR_SALDO"
		task.AddFieldToInc "AZ9_SALDO_IN_WÄHR"
		task.AddFieldToInc "BV_SCHL"
		task.AddFieldToInc "BESCHREIBUNG_PRIMÄRE_POSITION"
		task.AddFieldToInc "SYSTEMPOSITION"
		task.AddFieldToInc "ART"
		task.AddFieldToInc "GUV_MKML"
		task.AddFieldToInc "STEUERPOS_AKT_JAHR"
		task.AddFieldToInc "STEUERL_LAT"
		task.AddFieldToInc "STEUERL_LAT2"
		task.AddFieldToInc "POSITION_AKT_JAHR"
		task.AddFieldToInc "POSITION_VORJAHR"
		task.AddFieldToInc "ÄNDERUNG"
		task.AddFieldToInc "ERÖFFNUNG"
		task.AddFieldToInc "AUFLÖSUNG"
		task.AddFieldToInc "POSITION_SHORT"
		task.AddFieldToInc "BUCHUNGSKATEGORIE_BV"
		task.AddFieldToInc "POS_" & i
		dbName = "OBR_" & sYear & "_POS_" & i & ".IMD"
		task.AddExtraction dbName, "", "POS_" & i & "<>"""""
		task.CreateVirtualDatabase = False
		task.PerformTask 1, db.Count
		db.Close
		Set task = Nothing
		Set db = Nothing
		
		iMaxPosLength = oSC.GetMaxLength(dbName, "POS_" & i)
		Set oFM = oMC.FieldManagement(dbName)
		oFM.AppendField "POS", "Enthält die jeweilige Position zum anhängen der Dateien", 3, iMaxPosLength, 0, "POS_" & i
		oFM.PerformTask
		Set oFM = Nothing
	Next
SetCheckpoint "PositionenPrep [second Result] " & sYear & ", Checkpoint 3.0"
' AS 17.12.2020
' Anhängen der einzelnen Positionsdateien.
	If iPosCounter > 2 Then		
		Set db = Client.OpenDatabase("OBR_" & sYear & "_POS_1.IMD")
		Set task = db.AppendDatabase
		For iTableCount = 2 To iPosCounter -1
			task.AddDatabase "OBR_" & sYear & "_POS_" & iTableCount & ".IMD"
		Next
		dbName = "OBR_" & sYear & "_Einzelpositionen.IMD"
		task.PerformTask dbName, ""
		db.Close
		Set task = Nothing
		Set db = Nothing
	Else
		Set ProjectManagement = client.ProjectManagement
		dbName = "OBR_" & sYear & "_Einzelpositionen.IMD"
		ProjectManagement.RenameDatabase "OBR_" & sYear & "_POS_1.IMD", dbName
		Set ProjectManagement = Nothing
	End If
	PositionenPrep = dbName
End Function

Function JoinOBRUmsetzungen(ByVal sOBRFile As String, ByVal sUmsetzungenFile As String, ByVal sYear As String) As String
SetCheckpoint "JoinOBRUmsetzungen [second Result] " & sYear & ", Checkpoint 1.0"
	Set db = Client.OpenDatabase(sOBRFile)
	
	oSC.RenameField db, "POS", "POS_OBR_" & sYear
	
	Set task = db.Summarization
	task.AddFieldToInc "BESCHREIBUNG_PRIMÄRE_POSITION"
	task.AddFieldToSummarize "POS_OBR_" & sYear
	task.AddFieldToTotal "OBR_SALDO"
	sSummeOBR = "{Summierung Bilanzposition " & sYear &"}.IMD"
	task.OutputDBName = sSummeOBR
	task.CreatePercentField = FALSE
	task.StatisticsToInclude = SM_SUM
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sSummeOBR & " created."
SetCheckpoint "JoinOBRUmsetzungen [second Result] " & sYear & ", Checkpoint 2.1"
	Set db = Client.OpenDatabase(sUmsetzungenFile)
	
	oSC.RenameField db, "POS", "POS_UMSETZUNGEN_" & sYear
	
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "BETRAG_MIT_VORZEICHEN"
	field.Description = ""
	field.Type = WI_NUM_FIELD
	field.Equation = "@if(S_H=""S"";-BETRAG;BETRAG)"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
SetCheckpoint "JoinOBRUmsetzungen [second Result] " & sYear & ", Checkpoint 2.2"
	Set db = Client.OpenDatabase(sUmsetzungenFile)
	Set task = db.Summarization
	task.AddFieldToSummarize "POS_UMSETZUNGEN_" & sYear
	task.AddFieldToTotal "BETRAG_MIT_VORZEICHEN"
	sSummeUmsetzungen = "{Umsetzungen summiert pro Bilanzposition " & sYear &"}.IMD"
	task.OutputDBName = sSummeUmsetzungen
	task.CreatePercentField = FALSE
	task.StatisticsToInclude = SM_SUM
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sSummeUmsetzungen  & " created."
SetCheckpoint "JoinOBRUmsetzungen [second Result] " & sYear & ", Checkpoint 2.3"
	Set db = Client.OpenDatabase(sSummeOBR)
	Set task = db.JoinDatabase
	task.FileToJoin sSummeUmsetzungen
	task.IncludeAllPFields
	task.IncludeAllSFields
	task.AddMatchKey "POS_OBR_" & sYear, "POS_UMSETZUNGEN_" & sYear, "A"
	task.CreateVirtualDatabase = False
	sSummeOBRUmsetzungen = "{Summierung Bilanzpositionen und Umsetzung " & sYear & "}.IMD"
	task.PerformTask sSummeOBRUmsetzungen, "", WI_JOIN_ALL_REC
	db.Close
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sSummeOBRUmsetzungen  & " created."
SetCheckpoint "JoinOBRUmsetzungen [second Result] " & sYear & ", Checkpoint 2.4"
	Set db = Client.OpenDatabase(sSummeOBRUmsetzungen)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "BILANZPOSITION_" & sYear
	field.Description = ""
	field.Type = WI_CHAR_FIELD
	field.Equation = "@if(POS_OBR_" & sYear & "="""";POS_UMSETZUNGEN_" & sYear & ";POS_OBR_" & sYear & ")"
	field.Length = 20
	task.AppendField field
	task.PerformTask
	field.Name = "OBR_SALDO_UND_UMSETZUNGEN"
	field.Description = ""
	field.Type = WI_NUM_FIELD
	field.Equation = "OBR_SALDO_SUMME+BETRAG_MIT_VORZEICHEN_SUMME"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
	
	JoinOBRUmsetzungen = sSummeOBRUmsetzungen
End Function

function renameColumnsVergleichOBRKonten
	Set db = Client.OpenDatabase(sVergleichOBRKonten)
	
	oSC.RenameField db, "KONTO","KONTO_" & sAktuelleGJAHRShort
	oSC.RenameField db, "UNR","UNR_" & sAktuelleGJAHRShort
	oSC.RenameField db, "RAHMENNR","RAHMENNR_" & sAktuelleGJAHRShort
	oSC.RenameField db, "BEZEICHNUNG","BEZEICHNUNG_" & sAktuelleGJAHRShort
	oSC.RenameField db, "WKZ","WKZ_" & sAktuelleGJAHRShort
	oSC.RenameField db, "NABU_NR","NABU_NR_" & sAktuelleGJAHRShort
	oSC.RenameField db, "POSITIONEN","POSITIONEN_" & sAktuelleGJAHRShort
	oSC.RenameField db, "AZ9_SALDO","AZ9_SALDO_" & sAktuelleGJAHRShort
	oSC.RenameField db, "OBR_SALDO","OBR_SALDO_" & sAktuelleGJAHRShort
	oSC.RenameField db, "AZ9_SALDO_IN_WÄHR","AZ9_SALDO_IN_WÄHR_" & sAktuelleGJAHRShort
	oSC.RenameField db, "BV_SCHL","BV_SCHL_" & sAktuelleGJAHRShort
	oSC.RenameField db, "BESCHREIBUNG_PRIMÄRE_POSITION","BESCHREIBUNG_PRIMÄRE_POSITION_" & sAktuelleGJAHRShort
	oSC.RenameField db, "SYSTEMPOSITION","SYSTEMPOSITION_" & sAktuelleGJAHRShort
	oSC.RenameField db, "ART","ART_" & sAktuelleGJAHRShort
	oSC.RenameField db, "GUV_MKML","GUV_MKML_" & sAktuelleGJAHRShort
	oSC.RenameField db, "STEUERPOS_AKT_JAHR","STEUERPOS_AKT_JAHR_" & sAktuelleGJAHRShort
	oSC.RenameField db, "STEUERL_LAT","STEUERL_LAT_" & sAktuelleGJAHRShort
	oSC.RenameField db, "STEUERL_LAT2","STEUERL_LAT2_" & sAktuelleGJAHRShort
	oSC.RenameField db, "POSITION_AKT_JAHR","POSITION_AKT_JAHR_" & sAktuelleGJAHRShort
	oSC.RenameField db, "POSITION_VORJAHR","POSITION_VORJAHR_" & sAktuelleGJAHRShort
	oSC.RenameField db, "ÄNDERUNG","ÄNDERUNG_" & sAktuelleGJAHRShort
	oSC.RenameField db, "ERÖFFNUNG","ERÖFFNUNG_" & sAktuelleGJAHRShort
	oSC.RenameField db, "AUFLÖSUNG","AUFLÖSUNG_" & sAktuelleGJAHRShort
	'oSC.RenameField db, "SHK","SHK_" & sAktuelleGJAHRShort
	'oSC.RenameField db, "RAHMENNR_2STELLIG","RAHMENNR_2STELLIG_" & sAktuelleGJAHRShort
	'oSC.RenameField db, "RAHMENNR_3STELLIG","RAHMENNR_3STELLIG_" & sAktuelleGJAHRShort
	oSC.RenameField db, "POSITION_SHORT","POSITION_SHORT_" & sAktuelleGJAHRShort
	oSC.RenameField db, "BUCHUNGSKATEGORIE_BV","BUCHUNGSKATEGORIE_BV_" & sAktuelleGJAHRShort
	'oSC.RenameField db, "KURZBESCHREIBUNG_SVZ","KURZBESCHREIBUNG_SVZ_" & sAktuelleGJAHRShort
	'---------------------------------------------------------------------------------------------------------------------------------
	oSC.RenameField db, "KONTO1","KONTO_" & sVorherigesGJAHRShort
	oSC.RenameField db, "UNR1","UNR_" & sVorherigesGJAHRShort
	oSC.RenameField db, "RAHMENNR1","RAHMENNR_" & sVorherigesGJAHRShort
	oSC.RenameField db, "BEZEICHNUNG1","BEZEICHNUNG_" & sVorherigesGJAHRShort
	oSC.RenameField db, "WKZ1","WKZ_" & sVorherigesGJAHRShort
	oSC.RenameField db, "NABU_NR1","NABU_NR_" & sVorherigesGJAHRShort
	oSC.RenameField db, "POSITIONEN1","POSITIONEN_" & sVorherigesGJAHRShort
	oSC.RenameField db, "AZ9_SALDO1","AZ9_SALDO_" & sVorherigesGJAHRShort
	oSC.RenameField db, "OBR_SALDO1","OBR_SALDO_" & sVorherigesGJAHRShort
	oSC.RenameField db, "AZ9_SALDO_IN_WÄHR1","AZ9_SALDO_IN_WÄHR_" & sVorherigesGJAHRShort
	oSC.RenameField db, "BV_SCHL1","BV_SCHL_" & sVorherigesGJAHRShort
	oSC.RenameField db, "BESCHREIBUNG_PRIMÄRE_POSITION1","BESCHREIBUNG_PRIMÄRE_POSITION_" & sVorherigesGJAHRShort
	oSC.RenameField db, "SYSTEMPOSITION1","SYSTEMPOSITION_" & sVorherigesGJAHRShort
	oSC.RenameField db, "ART1","ART_" & sVorherigesGJAHRShort
	oSC.RenameField db, "GUV_MKML1","GUV_MKML_" & sVorherigesGJAHRShort
	oSC.RenameField db, "STEUERPOS_AKT_JAHR1","STEUERPOS_AKT_JAHR_" & sVorherigesGJAHRShort
	oSC.RenameField db, "STEUERL_LAT1","STEUERL_LAT_" & sVorherigesGJAHRShort
	oSC.RenameField db, "STEUERL_LAT21","STEUERL_LAT2_" & sVorherigesGJAHRShort
	oSC.RenameField db, "POSITION_AKT_JAHR1","POSITION_AKT_JAHR_" & sVorherigesGJAHRShort
	oSC.RenameField db, "POSITION_VORJAHR1","POSITION_VORJAHR_" & sVorherigesGJAHRShort
	oSC.RenameField db, "ÄNDERUNG1","ÄNDERUNG_" & sVorherigesGJAHRShort
	oSC.RenameField db, "ERÖFFNUNG1","ERÖFFNUNG_" & sVorherigesGJAHRShort
	oSC.RenameField db, "AUFLÖSUNG1","AUFLÖSUNG_" & sVorherigesGJAHRShort
	'oSC.RenameField db, "SHK1","SHK_" & sVorherigesGJAHRShort
	'oSC.RenameField db, "RAHMENNR_2STELLIG1","RAHMENNR_2STELLIG_" & sVorherigesGJAHRShort
	'oSC.RenameField db, "RAHMENNR_3STELLIG1","RAHMENNR_3STELLIG_" & sVorherigesGJAHRShort
	oSC.RenameField db, "POSITION_SHORT1","POSITION_SHORT_" & sVorherigesGJAHRShort
	oSC.RenameField db, "BUCHUNGSKATEGORIE_BV1","BUCHUNGSKATEGORIE_BV_" & sVorherigesGJAHRShort
	'oSC.RenameField db, "KURZBESCHREIBUNG_SVZ1","KURZBESCHREIBUNG_SVZ_" & sVorherigesGJAHRShort
	
	db.Close 
	Set db = Nothing
end function

function renameColumnsVergleichBilpoUmsetzungen
	Set db = Client.OpenDatabase(sVergleichBilanzpositionenUmsetzungen)
	
	oSC.RenameField db, "ANZ_SAETZE", "ANZ_POS_OBR_" & sAktuelleGJAHRShort
	oSC.RenameField db, "OBR_SALDO_SUMME","OBR_SALDO_SUMME_" & sAktuelleGJAHRShort
	oSC.RenameField db, "BESCHREIBUNG_PRIMÄRE_POSITION","BESCHREIBUNG_PRIMÄRE_POSITION_" & sAktuelleGJAHRShort
	oSC.RenameField db, "ANZ_SAETZE1", "ANZ_POS_UMSETZUNGEN_" & sAktuelleGJAHRShort
	oSC.RenameField db, "BETRAG_MIT_VORZEICHEN_SUMME","BETRAG_MIT_VORZEICHEN_SUMME_" & sAktuelleGJAHRShort
	oSC.RenameField db, "OBR_SALDO_UND_UMSETZUNGEN","OBR_SALDO_UND_UMSETZUNGEN_" & sAktuelleGJAHRShort
	'---------------------------------------------------------------------------------------------------------------------------------
	oSC.RenameField db, "ANZ_SAETZE2", "ANZ_POS_OBR_" & sVorherigesGJAHRShort
	oSC.RenameField db, "OBR_SALDO_SUMME1","OBR_SALDO_SUMME_" & sVorherigesGJAHRShort
	oSC.RenameField db, "BESCHREIBUNG_PRIMÄRE_POSITION1","BESCHREIBUNG_PRIMÄRE_POSITION_" & sVorherigesGJAHRShort
	oSC.RenameField db, "ANZ_SAETZE11", "ANZ_POS_UMSETZUNGEN_" & sVorherigesGJAHRShort
	oSC.RenameField db, "BETRAG_MIT_VORZEICHEN_SUMME1","BETRAG_MIT_VORZEICHEN_SUMME_" & sVorherigesGJAHRShort
	oSC.RenameField db, "OBR_SALDO_UND_UMSETZUNGEN1","OBR_SALDO_UND_UMSETZUNGEN_" & sVorherigesGJAHRShort
	
	db.Close
	set db = nothing
end function

Function ImportBetriebsvergleichsschluessel(ByVal sFilePath As String, sDescPath As String)
Dim dbImportBVSTemp As String
Dim sBVS As String
Dim sTempDB2Delete As String
oLog.LogMessage "Begin Import Betriebsvergleichsschluessel"

	dbImportBVSTemp = "{BVS_Gesamt_temp}.IMD"
	'Call ImportTable(dbImportBVSTemp, sFilePath, sDescPath, "")
	Client.ImportUTF8DelimFile sFilePath, dbImportBVSTemp, FALSE, "", sDescPath, TRUE
	oLog.LogMessage "End of ImportTable-Betriebsvergleichsschluessel"
oLog.LogMessage "Begining of creating new field"
	Set db = Client.OpenDatabase(dbImportBVSTemp)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "SCHLÜSSELJOIN"
	field.Description = ""
	field.Type = WI_CHAR_FIELD
	field.Equation = "@Repeat(""0"";4-@Len(SCHLÜSSEL))+SCHLÜSSEL"
	' field.Equation = "@Left(@Trim(@Str(@Val(SCHLÜSSEL); 3; 0)); 2)"
	field.Length = 2
	task.AppendField field
	task.DisableProgressNotification = True
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
oLog.LogMessage "End of creating new field"
	
	Call RenameFieldBVS(dbImportBVSTemp,"KURZBESCHREIBUNG","KURZBESCHREIBUNG_SVZ")
	
	sBVS = "{BVS_Gesamt}.IMD"
	
	Set db = Client.OpenDatabase(dbImportBVSTemp)
	Set task = db.Extraction
	task.AddFieldToInc "SCHLÜSSEL"
	task.AddFieldToInc "KURZBESCHREIBUNG_SVZ"
	task.AddFieldToInc "BESCHREIBUNG"
	task.AddFieldToInc "BUCHUNGSKATEGORIE_BV"
	task.AddFieldToInc "SCHLÜSSELJOIN"
	task.AddExtraction sBVS, "", ""
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	sTempDB2Delete = Client.WorkingDirectory & dbImportBVSTemp
	Kill sTempDB2Delete
	Client.RefreshFileExplorer

End Function

Function AddFieldOBR(ByVal sImportFile As String)
' Lokale Variablen
Dim sEquation As String
' AS 11.10.2020: get the original account number and add zeros at the front until it is ten characters long
' 1. rename original field
' 2. create new field
	Set db = Client.OpenDatabase(sImportFile)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "KONTO_OG"
	field.Description = ""
	field.Type = WI_CHAR_FIELD
	field.Equation = ""
	field.Length = 10
	task.ReplaceField "KONTO", field
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
	
	Set db = Client.OpenDatabase(sImportFile)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	' AS 11.10.2020: fill the account number with leading zeros
	field.Name = "KONTO"
	field.Description = ""
	field.Type = WI_CHAR_FIELD
	field.Equation = "@Repeat(""0"";10-@Len(KONTO_OG))+KONTO_OG"
	field.Length = 10
	task.AppendField field
	'-------------------------------------------------------------
	field.Name = "SHK"
	field.Description = ""
	field.Type = WI_CHAR_FIELD
	sEquation = "@If(AZ9_SALDO < 0;""S"";""H"")"
	field.Equation = sEquation
	field.Length = 1
	task.AppendField field
	field.Name = "RAHMENNR_2STELLIG"
	field.Description = ""
	field.Type = WI_CHAR_FIELD
	field.Equation = "@Left(RAHMENNR;2)"
	field.Length = 2
	task.AppendField field
	field.Name = "RAHMENNR_3STELLIG"
	field.Description = ""
	field.Type = WI_CHAR_FIELD
	field.Equation = "@Left(RAHMENNR;3)"
	field.Length = 3
	task.AppendField field
	field.Name = "POSITION_SHORT"
	field.Description = ""
	field.Type = WI_CHAR_FIELD
	field.Equation = "@Mid(POSITIONEN;2;5)"
	field.Length = 5
	task.AppendField field
	field.Name = "BV_SCHL2JOIN"
	field.Description = ""
	field.Type = WI_CHAR_FIELD
	field.Equation = "@Repeat(""0"";4-@Len(BV_SCHL))+BV_SCHL"
	field.Length = 2
	task.AppendField field
	task.DisableProgressNotification = True
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
		
End Function

Function JoinOBR2BVS(ByVal sImportFile As String, ByVal sBVSFile As String, ByVal sOBRFinal As String)

        Set db = Client.OpenDatabase(sImportFile)
        Set task = db.JoinDatabase
        task.FileToJoin sBVSFile
        task.IncludeAllPFields
        task.AddSFieldToInc "BUCHUNGSKATEGORIE_BV"
        'task.AddSFieldToInc "KURZBESCHREIBUNG_SVZ"
        task.AddMatchKey "BV_SCHL2JOIN", "SCHLÜSSELJOIN", "D"
        task.CreateVirtualDatabase = False
        task.DisableProgressNotification = True
        task.PerformTask sOBRFinal, "", WI_JOIN_ALL_IN_PRIM
        db.Close
        Set task = Nothing
        Set db = Nothing
        
        Kill Client.WorkingDirectory & sImportFile
		Client.RefreshFileExplorer
		
End Function

Function RenameFieldBVS(ByVal sImportFile As String, ByVal sOldFieldName As String, ByVal sNewFieldName As String)

	Set db = Client.OpenDatabase(sImportFile)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField

	field.Name = sNewFieldName 
	field.Description = ""
	field.Type = WI_CHAR_FIELD
	field.Equation = ""
	field.Length = 40
	task.ReplaceField sOldFieldName, field
	
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing	

End Function

Function CheckCSVHeader(ByVal filePath As String, ByVal headerName As String) As Integer
	' Read the first line of the CSV file
	Dim Filenum As Integer
	Dim Contents As String
	Dim sContainer As String
	'Dim header As String
oLog.LogMessage "Beginning of CheckCSVHeader-Debug_Filenum as Integer"
	Filenum = FreeFile
oLog.LogMessage "FreeFile Done"
	Open filePath For Input As Filenum
oLog.LogMessage "Openning File Done"
	Line Input #Filenum, Contents
oLog.LogMessage "Reading the first line Done: " & Contents
	sContainer = Contents
	' get first header name and check if it equals to specific header
	'header = Left(Contents, Len(headerName))
'oLog.LogMessage "Getting the first column Done: " & header
	Close Filenum
oLog.LogMessage "Closing the file Done"
oLog.LogMessage "After Closing File first line saved: " & sContainer
oLog.LogMessage "Header name given above: " & headerName
	CheckCSVHeader = InStr(1, sContainer, headerName)
'	' Check if the specified header exists in the array
'	If iIsini(headerName, sContainer) Then
'		CheckCSVHeader = True
'oLog.LogMessage "If condition equals True"
'	Else
'		CheckCSVHeader = False
'oLog.LogMessage "If condition equals False"
'	End If

End Function
'-------------------------------------------------------------------------------------------------------------
' Ergebnisse registrieren
'-------------------------------------------------------------------------------------------------------------
Function registerResult(ByVal dbNameResult As String, ByVal sResultType)
Dim oList As Object
dim helper as object
Dim eqnBuilder As Object
Dim sContentAreaFilter As String
' tagging
	Set helper = oTM.Tagging(Client.WorkingDirectory & dbNameResult)
oLog.LogMessage "Register table " & dbNameResult
	if oSC.FileIsValid(dbNameResult) then
		select case dbNameResult
			Case sVergleichOBRKonten
				'27.07.2022 set new tags, so that the different column names can be handed over to the audit tests
				'helper.SetTag "acc!VKS_KONTO_NR", "KONTO"
				
				helper.SetTag "acc!VOBR_KONTO_AKT", "KONTO_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VOBR_UNR_AKT", "UNR_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VOBR_RAHMENNR_AKT", "RAHMENNR_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VOBR_BEZEICHNUNG_AKT", "BEZEICHNUNG_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VOBR_WKZ_AKT", "WKZ_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VOBR_NABU_NR_AKT", "NABU_NR_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VOBR_POSITIONEN_AKT", "POSITIONEN_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VOBR_AZ9_SALDO_AKT", "AZ9_SALDO_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VOBR_OBR_SALDO_AKT", "OBR_SALDO_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VOBR_AZ9_SALDO_IN_WAEHR_AKT", "AZ9_SALDO_IN_WÄHR_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VOBR_BV_SCHL_AKT", "BV_SCHL_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VOBR_BESCHREIBUNG_PRIMAERE_POSITION_AKT", "BESCHREIBUNG_PRIMÄRE_POSITION_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VOBR_SYSTEMPOSITION_AKT", "SYSTEMPOSITION_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VOBR_ART_AKT", "ART_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VOBR_GUV_MKML_AKT", "GUV_MKML_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VOBR_STEUERPOS_AKT_JAHR_AKT", "STEUERPOS_AKT_JAHR_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VOBR_STEUERL_LAT_AKT", "STEUERL_LAT_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VOBR_STEUERL_LAT2_AKT", "STEUERL_LAT2_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VOBR_POSITION_AKT_JAHR_AKT", "POSITION_AKT_JAHR_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VOBR_POSITION_VORJAHR_AKT", "POSITION_VORJAHR_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VOBR_AENDERUNG_AKT", "ÄNDERUNG_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VOBR_EROEFFNUNG_AKT", "ERÖFFNUNG_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VOBR_AUFLOESUNG_AKT", "AUFLÖSUNG_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VOBR_POSITION_SHORT_AKT", "POSITION_SHORT_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VOBR_BUCHUNGSKATEGORIE_BV_AKT", "BUCHUNGSKATEGORIE_BV_" & sAktuelleGJAHRShort
				'helper.SetTag "acc!VOBR_KURZBESCHREIBUNG_SVZ_AKT", "KURZBESCHREIBUNG_SVZ_" & sAktuelleGJAHRShort
				'---------------------------------------------------------------------------------------------------------------
				helper.SetTag "acc!VOBR_KONTO_VORH", "KONTO_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VOBR_UNR_VORH", "UNR_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VOBR_RAHMENNR_VORH", "RAHMENNR_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VOBR_BEZEICHNUNG_VORH", "BEZEICHNUNG_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VOBR_WKZ_VORH", "WKZ_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VOBR_NABU_NR_VORH", "NABU_NR_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VOBR_POSITIONEN_VORH", "POSITIONEN_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VOBR_AZ9_SALDO_VORH", "AZ9_SALDO_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VOBR_OBR_SALDO_VORH", "OBR_SALDO_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VOBR_AZ9_SALDO_IN_WAEHR_VORH", "AZ9_SALDO_IN_WÄHR_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VOBR_BV_SCHL_VORH", "BV_SCHL_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VOBR_BESCHREIBUNG_PRIMAERE_POSITION_VORH", "BESCHREIBUNG_PRIMÄRE_POSITION_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VOBR_SYSTEMPOSITION_VORH", "SYSTEMPOSITION_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VOBR_ART_VORH", "ART_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VOBR_GUV_MKML_VORH", "GUV_MKML_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VOBR_STEUERPOS_AKT_JAHR_VORH", "STEUERPOS_AKT_JAHR_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VOBR_STEUERL_LAT_VORH", "STEUERL_LAT_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VOBR_STEUERL_LAT2_VORH", "STEUERL_LAT2_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VOBR_POSITION_AKT_JAHR_VORH", "POSITION_AKT_JAHR_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VOBR_POSITION_VORJAHR_VORH", "POSITION_VORJAHR_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VOBR_AENDERUNG_VORH", "ÄNDERUNG_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VOBR_EROEFFNUNG_VORH", "ERÖFFNUNG_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VOBR_AUFLOESUNG_VORH", "AUFLÖSUNG_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VOBR_POSITION_SHORT_VORH", "POSITION_SHORT_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VOBR_BUCHUNGSKATEGORIE_BV_VORH", "BUCHUNGSKATEGORIE_BV_" & sVorherigesGJAHRShort
				'helper.SetTag "acc!VOBR_KURZBESCHREIBUNG_SVZ_VORH", "KURZBESCHREIBUNG_SVZ_" & sVorherigesGJAHRShort
				
				helper.Save
				sContentAreaFilter = "SK_FuR_Vergleich_Kontensalden"
			Case sVergleichBilanzpositionenUmsetzungen
				'27.07.2022 set new tags, so that the different column names can be handed over to the audit tests
				'helper.SetTag "acc!VBP_SYSTEMPOSITION", "POS_OBR_" & sAktuelleGJAHRShort
				
				helper.SetTag "acc!VBIL_POS_OBR_AKT", "POS_OBR_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VBIL_ANZ_POS_OBR_AKT", "ANZ_POS_OBR_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VBIL_OBR_SALDO_SUMME_AKT", "OBR_SALDO_SUMME_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VBIL_BESCHREIBUNG_PRIMAERE_POSITION_AKT", "BESCHREIBUNG_PRIMÄRE_POSITION_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VBIL_POS_UMSETZUNGEN_AKT", "POS_UMSETZUNGEN_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VBIL_ANZ_POS_UMSETZUNGEN_AKT", "ANZ_POS_UMSETZUNGEN_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VBIL_BETRAG_MIT_VORZEICHEN_SUMME_AKT", "BETRAG_MIT_VORZEICHEN_SUMME_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VBIL_BILANZPOSITION_AKT", "BILANZPOSITION_" & sAktuelleGJAHRShort
				helper.SetTag "acc!VBIL_OBR_SALDO_UND_UMSETZUNGEN_AKT", "OBR_SALDO_UND_UMSETZUNGEN_" & sAktuelleGJAHRShort
				'---------------------------------------------------------------------------------------------------------------
				helper.SetTag "acc!VBIL_POS_OBR_VORH", "POS_OBR_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VBIL_ANZ_POS_OBR_VORH", "ANZ_POS_OBR_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VBIL_OBR_SALDO_SUMME_VORH", "OBR_SALDO_SUMME_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VBIL_BESCHREIBUNG_PRIMAERE_POSITION_VORH", "BESCHREIBUNG_PRIMÄRE_POSITION_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VBIL_POS_UMSETZUNGEN_VORH", "POS_UMSETZUNGEN_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VBIL_ANZ_POS_UMSETZUNGEN_VORH", "ANZ_POS_UMSETZUNGEN_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VBIL_BETRAG_MIT_VORZEICHEN_SUMME_VORH", "BETRAG_MIT_VORZEICHEN_SUMME_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VBIL_BILANZPOSITION_VORH", "BILANZPOSITION_" & sVorherigesGJAHRShort
				helper.SetTag "acc!VBIL_OBR_SALDO_UND_UMSETZUNGEN_VORH", "OBR_SALDO_UND_UMSETZUNGEN_" & sVorherigesGJAHRShort
				
				helper.Save
				sContentAreaFilter = "SK_FuR_Vergleich_Bilanzpositionen"
			case sFirstOBR
				helper.SetTag "acc!OBR_KONTO_NR", "KONTO"
				helper.Save
				sContentAreaFilter = "SK_FuR_Prüfung_OBR"
			case else
			oLog.LogError "Could not set tags for table: " & dbNameResult & ". Table was not recognized."
		end select
		set helper = nothing
		' register table
		set eqnBuilder = oMC.ContentEquationBuilder()
		Set oList = oSC.CreateResultObject(dbNameResult, sResultType, True, 1)
		SmartContext.TestResultFiles.Add oList
		oList.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter(sContentAreaFilter)
		'oList.Extravalues.Add "Alias", dbNameResult
oLog.LogMessage dbNameResult & " registered."
		Set oList = Nothing
		set eqnBuilder = nothing
	else
oLog.LogError "Could not register table: " & dbNameResult & ". Table does not exist or has no records."
	set helper = nothing
	end if
End Function
'-----------------------------------------------------------------------------------------
' Standard Funtions - Error Handling
'-----------------------------------------------------------------------------------------
Sub LogSmartAnalyzerError(ByVal extraInfo As String)
On Error Resume Next
	If SmartContext.IsCancellationRequested Then
		SmartContext.ExecutionStatus = EXEC_STATUS_CANCELED
		SmartContext.AbortImport = True
		
		SmartContext.Log.LogMessage "Excecution was stopped by user."
		oLog.LogMessage "Execution Time End: " & Now()

		Set oLog = Nothing
		Set oMC = Nothing
		Set oSC = Nothing
		Set oPara = Nothing
		Stop		
	Else
		SmartContext.ExecutionStatus = EXEC_STATUS_FAILED
		SmartContext.AbortImport = True
		
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
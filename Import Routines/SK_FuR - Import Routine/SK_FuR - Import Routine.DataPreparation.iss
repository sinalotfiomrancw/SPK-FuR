'-------------------------------------------------------------------------------------
' Title:		SK-FuR - Import Routine preparation
' CIR:		SK-FuR - Import Routine
' Customer:	Sparkassen
' Created by:	AS
' Created on:	23.01.2021
' Version:		1.00
'-------------------------------------------------------------------------------------
' Decription:	
'-------------------------------------------------------------------------------------
' Files:		
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
dim oFM as object

Dim mppTaskFactory As Object ' Mehrperiodenaufbereitung
Dim mppTask As Object

Dim sourceFileName As String

' IDEA standard variables
Dim db As Object
Dim dbName As String
Dim eqn As String
Dim task As Object
Dim field As Object

' Input Files
dim sUmsatz_1 as string
dim sUmsatz_2 as string
dim sUmsatz_3 as string
dim sUmsatz_4 as string
dim sUmsatz_5 as string
dim sUmsatz_6 as string
dim sUmsatz_7 as string
dim sUmsatz_8 as string
dim sUmsatz_9 as string
dim sUmsatz_10 as string
dim sUmsatz_11 as string
dim sUmsatz_12 as string
dim sOBRKonten as string
dim sHKKonten as string
dim sPrimanoten as string
dim sPositionsschlüssel as string

dim bUmsatz_1 as boolean
dim bUmsatz_2 as boolean
dim bUmsatz_3 as boolean
dim bUmsatz_4 as boolean
dim bUmsatz_5 as boolean
dim bUmsatz_6 as boolean
dim bUmsatz_7 as boolean
dim bUmsatz_8 as boolean
dim bUmsatz_9 as boolean
dim bUmsatz_10 as boolean
dim bUmsatz_11 as boolean
dim bUmsatz_12 as boolean
dim bOBRKonten as boolean
dim bHKKonten as boolean
dim bPrimanoten as boolean
dim bPositionsschlüssel as boolean

' Aufbereitung
Dim sUmsätzeGesamt As String
Dim sUmsätzeZuOBR As String
Dim sUmsätzeOBRPrimanoten As String
Dim sBuchungenJeKtoRahmen As String
Dim sBuchungenJeKtoRahmenGes As String
Dim sUmsaetzeOBRAuto As String
Dim sUmsaetzeOBRManuell As String
Dim sUmsaetzeAutoJeKto As String
Dim sUmsaetzeManuellJeKto As String
Dim sUmsaetzeOBRinEURManuell As String
Dim sUmsaetzeOBRungleichEURManuell As String
Dim sUmsaetzeOBRinEURAuto As String
Dim sUmsaetzeOBRungleichEURAuto As String
Dim sHabenAufSollOBRinEUR As String
Dim sSollAufHabenOBRinEUR As String
Dim sStornoHabenAufSollOBRinEUR As String
Dim sStornoSollAufHabenOBRinEUR As String

' Tabellennamen
Const NameUmsätzeOBRPrimanoten As String = "{Umsätze_zu_OBR_Gesamt_mit_Buchungskennzeichen}"
Const NameBuchungenJeKtoRahmen As String = "-SKA00_Anzahl_Buchungen_je_bebuchten_KtoRahmen_mit_SHK"
Const NameBuchungenJeKtoRahmenGes As String = "-SKA00_Anzahl_Buchungen_je_KtoRahmen"
Const NameUmsaetzeOBRAuto As String = "-SKA00_Umsätze_zu_OBR_automatisch"
Const NameUmsaetzeOBRManuell As String = "-SKA00_Umsätze_zu_OBR_manuell"
Const NameUmsaetzeAutoJeKto As String = "-SKA00_Automatische_Buchungen_je_KtoRahmen"
Const NameUmsaetzeManuellJeKto As String = "-SKA00_Manuelle_Buchungen_je_KtoRahmen"
Const NameUmsaetzeOBRinEURManuell As String = "-SKA00_Umsätze_zu_OBR_in_EUR_manuell"
Const NameUmsaetzeOBRungleichEURManuell As String = "-SKA00_Umsätze_zu_OBR_nicht_in_EUR_manuell"
Const NameUmsaetzeOBRinEURAuto As String = "-SKA00_Umsätze_zu_OBR_in_EUR_automatisch"
Const NameUmsaetzeOBRungleichEURAuto As String = "-SKA00_Umsätze_zu_OBR_nicht_in_EUR_automatisch"
Const NameHabenAufSollOBRinEUR As String = "-SKA00_HabenBuchungen_auf_SollKonten_zu_OBR_in_EUR"
Const NameSollAufHabenOBRinEUR As String = "-SKA00_SollBuchungen_auf_HabenKonten_zu_OBR_in_EUR"
Const NameStornoHabenAufSollOBRinEUR As String = "-SKA00_Storno_HabenBuchungen_auf_SollKonten_zu_OBR_in_EUR"
Const NameStornoSollAufHabenOBRinEUR As String = "-SKA00_Storno_SollBuchungen_auf_HabenKonten_zu_OBR_in_EUR"
Const NameOBRKonten As String = "OBR_Konten"

' Folder
dim sWorkingfolderPfad as string
dim sWorkingfolderName as string

' Parameter
dim sGeschäftsjahr as string
dim sNichtaufgriffsgrenze as string

' Error Logging
Dim lErrorNumber As Long
Dim sErrorDescripton As String
Dim lErrorLine As Long

Dim m_checkpointName As String

Sub Main
On Error GoTo ErrorHandler
SetCheckpoint "Begin of Main"
	'IgnoreWarning (True)
	Set oLog = SmartContext.Log
	Set oMC = SmartContext.MacroCommands
	Set oSC = SmartContext.MacroCommands.SimpleCommands
	Set oTM = SmartContext.MacroCommands.TagManagement
	Set oPara = SmartContext.MacroCommands.GlobalParameters
	
	Set mppTaskFactory = SmartContext.GetServiceById("RegisterTableForMppTaskFactory")
	If mppTaskFactory is Nothing Then
		SmartContext.Log.LogError "The SA service RegisterTableForMppTaskFactory is missing."
	End If
	
	'Set ExecutionStatus (failure at the beginning).
	SmartContext.ExecutionStatus =EXEC_STATUS_FAILED
	
	oLog.LogMessage "Import Routine Name: " & SmartContext.TestName
	oLog.LogMessage "Import Routine Version: " & SmartContext.TestVersion
	oLog.LogMessage "Execution Time Start: " & Now()
	
SetCheckpoint "Get Imported Files"
oLog.LogMessage m_checkpointName
	sUmsatz_1 = GetImportedDatabaseName("Umsatz_1", bUmsatz_1)
	sUmsatz_2 = GetImportedDatabaseName("Umsatz_2", bUmsatz_2)
	sUmsatz_3 = GetImportedDatabaseName("Umsatz_3", bUmsatz_3)
	sUmsatz_4 = GetImportedDatabaseName("Umsatz_4", bUmsatz_4)
	sUmsatz_5 = GetImportedDatabaseName("Umsatz_5", bUmsatz_5)
	sUmsatz_6 = GetImportedDatabaseName("Umsatz_6", bUmsatz_6)
	sUmsatz_7 = GetImportedDatabaseName("Umsatz_7", bUmsatz_7)
	sUmsatz_8 = GetImportedDatabaseName("Umsatz_8", bUmsatz_8)
	sUmsatz_9 = GetImportedDatabaseName("Umsatz_9", bUmsatz_9)
	sUmsatz_10 = GetImportedDatabaseName("Umsatz_10", bUmsatz_10)
	sUmsatz_11 = GetImportedDatabaseName("Umsatz_11", bUmsatz_11)
	sUmsatz_12 = GetImportedDatabaseName("Umsatz_12", bUmsatz_12)
	sOBRKonten = GetImportedDatabaseName("OBR_Konten", bOBRKonten)
	sHKKonten = GetImportedDatabaseName("HK_Konten", bHKKonten)
	sPrimanoten = GetImportedDatabaseName("Primanotenplan", bPrimanoten)
	sPositionsschlüssel = GetImportedDatabaseName("Positionsschluessel", bPositionsschlüssel)
SetCheckpoint "Get Audit Folder"
oLog.LogMessage m_checkpointName
	if sUmsatz_1 <> "" then
		sWorkingfolderPfad = oSC.GetDirName(sUmsatz_1)
	else
		' ToDo: Ausnahme definieren
	end if
	sWorkingfolderName = sWorkingfolderPfad
	sWorkingfolderName = Left(sWorkingfolderName,Len(sWorkingfolderName)-1)
	While InStr(sWorkingfolderName, "\") > 0 
		sWorkingfolderName = Right(sWorkingfolderName, Len(sWorkingfolderName) - InStr(sWorkingfolderName, "\"))
	Wend
SetCheckpoint "Get Project Parameters"
oLog.LogMessage m_checkpointName
	sGeschäftsjahr = oPara.Get4Project ("sGeschäftsjahr")
	sNichtaufgriffsgrenze = oPara.Get4Project ("sNichtaufgriffsgrenze")
'-----------------------------------------------------------------------------------------
' Funtion Calls
'-----------------------------------------------------------------------------------------
SetCheckpoint "Begin of Functions"
	sUmsätzeGesamt = PrepareUmsätzeGesamt()
	Call PrepareOBRKonten
	Call PrepareSalesData
	Call RegisterTable(sUmsätzeOBRPrimanoten, NameUmsätzeOBRPrimanoten)
	Call RegisterTable(sUmsaetzeOBRAuto, NameUmsaetzeOBRAuto)
	Call RegisterTable(sUmsaetzeAutoJeKto, NameUmsaetzeAutoJeKto)
	Call RegisterTable(sUmsaetzeOBRinEURAuto, NameUmsaetzeOBRinEURAuto)
	Call RegisterTable(sUmsaetzeOBRungleichEURAuto, NameUmsaetzeOBRungleichEURAuto)
	Call RegisterTable(sUmsaetzeOBRManuell, NameUmsaetzeOBRManuell)
	Call RegisterTable(sUmsaetzeManuellJeKto, NameUmsaetzeManuellJeKto)
	Call RegisterTable(sUmsaetzeOBRinEURManuell, NameUmsaetzeOBRinEURManuell)
	Call RegisterTable(sUmsaetzeOBRungleichEURManuell, NameUmsaetzeOBRungleichEURManuell)
	Call RegisterTable(sHabenAufSollOBRinEUR, NameHabenAufSollOBRinEUR)
	Call RegisterTable(sSollAufHabenOBRinEUR, NameSollAufHabenOBRinEUR)
	call RegisterTable(sStornoHabenAufSollOBRinEUR, NameStornoHabenAufSollOBRinEUR)
	Call RegisterTable(sStornoSollAufHabenOBRinEUR, NameStornoSollAufHabenOBRinEUR)
	Call RegisterTable(sOBRKonten, NameOBRKonten)
SetCheckpoint "End of Functions"
'-----------------------------------------------------------------------------------------
' End Funtion Calls
'-----------------------------------------------------------------------------------------
SetCheckpoint "Delete Project Parameters"
oLog.LogMessage m_checkpointName
		'oPara.Delete4Project "sGeschäftsjahr"
		'oPara.Delete4Project "sNichtaufgriffsgrenze"
		'oPara.Delete4Project "sPfadUmsätze"
		'oPara.Delete4Project "sUmsätzeVorlage"
		'oPara.Delete4Project "sPfadOBR"
		'oPara.Delete4Project "sOBRKontenVorlage"
		'oPara.Delete4Project "sPfadHKKonten"
		'oPara.Delete4Project "sHKKontenVorlage"
		'oPara.Delete4Project "sPfadPrimanoten"
		'oPara.Delete4Project "sPrimanotenVorlage"
		'oPara.Delete4Project "sPfadPositionsschlüssel"
		'oPara.Delete4Project "sPositionsschlüsselVorlage"

	oLog.LogMessage "Execution Time End: " & Now()
	
	SmartContext.ExecutionStatus = EXEC_STATUS_SUCCEEDED

	Set oLog = Nothing
	Set oMC = Nothing
	Set oSC = Nothing
	Set oPara = Nothing
	set oTM = nothing
	
	Exit Sub
ErrorHandler:
	Call LogSmartAnalyzerError("")
End Sub
'-----------------------------------------------------------------------------------------
' Preparation - PrepareUmsätzeGesamt
'-----------------------------------------------------------------------------------------
Function PrepareUmsätzeGesamt As String
On Error GoTo ErrorHandler
SetCheckpoint "PrepareUmsätzeGesamt"
oLog.LogMessage m_checkpointName
dim sFinalFile as string

	if bUmsatz_2 = FALSE then
		oLog.LogMessage "Es wurde nur eine Datei importiert."
		Set db = Client.OpenDatabase(sUmsatz_1)
		Set task = db.Extraction
		task.IncludeAllFields
		sFinalFile = oSC.UniqueFileName(sWorkingfolderPfad & "{Umsätze_Gesamt}.IMD")
		task.AddExtraction sFinalFile, "", ""
		task.CreateVirtualDatabase = False
		task.PerformTask 1, db.Count
		db.Close
		Set task = Nothing
		Set db = Nothing
		oLog.LogMessage "{Umsätze_Gesamt} erstellt."
	else
		oLog.LogMessage "Beginn Tabellen anhängen."
		Set db = Client.OpenDatabase(sUmsatz_1)
		Set task = db.AppendDatabase
		if bUmsatz_2 then task.AddDatabase sUmsatz_2
		if bUmsatz_3 then task.AddDatabase sUmsatz_3
		if bUmsatz_4 then task.AddDatabase sUmsatz_4
		if bUmsatz_5 then task.AddDatabase sUmsatz_5
		if bUmsatz_6 then task.AddDatabase sUmsatz_6
		if bUmsatz_7 then task.AddDatabase sUmsatz_7
		if bUmsatz_8 then task.AddDatabase sUmsatz_8
		if bUmsatz_9 then task.AddDatabase sUmsatz_9
		if bUmsatz_10 then task.AddDatabase sUmsatz_10
		if bUmsatz_11 then task.AddDatabase sUmsatz_11
		if bUmsatz_12 then task.AddDatabase sUmsatz_12
		sFinalFile = oSC.UniqueFileName(sWorkingfolderPfad & "{Umsätze_Gesamt}.IMD")
		task.DisableProgressNotification = True
		task.PerformTask sFinalFile, ""
		db.Close
		Set task = Nothing
		Set db = Nothing
		oLog.LogMessage "{Umsätze_Gesamt} erstellt."
	end if
	if oSC.FileIsValid(sFinalFile) then
		oLog.LogMessage "check account length"
		Dim iMaxAccountLength As Integer
		Dim iMinAccountLength As Integer
		iMinAccountLength = 0
		iMaxAccountLength = oSC.GetMaxLength(sFinalFile, "KONTO_NR", iMinAccountLength)
		If iMaxAccountLength < 10 Then
			oLog.LogMessage "Länge Kontonummer: " & iMaxAccountLength
			oLog.LogMessage "Beginne Kontonummer mit führenden Nullen auffüllen." & Date()
			Set db = Client.OpenDatabase(sFinalFile)
			oSC.RenameField db, "KONTO_NR", "KONTO_OG"
			db.Close
			Set db = Nothing
			Set oFM = oMC.FieldManagement(sFinalFile)
			oFM.AppendField "KONTO_NR", "KONTO_OG wurde mit führenden Nullen aufgefüllt.", 3, 10, 0, "@Repeat(""0"";10-@Len(KONTO_OG))+KONTO_OG"
			oFM.PerformTask
			Set oFM = Nothing
			oLog.LogMessage "Beende Kontonummer mit führenden Nullen auffüllen." & Date()
		Else
			oLog.LogMessage "Länge Kontonummer: " & iMaxAccountLength
		End If
		
		oLog.LogMessage "Umsatzdateien werden aufbereitet."
		Set db = Client.OpenDatabase(sFinalFile)
		oSC.RenameField db, "WERTSTELLUNG", "WERTSTELLUNG_ORG", "originale Wertstellung"
		db.Close
		Set db = Nothing
		oLog.LogMessage "WERTSTELLUNG umbenannt."
		
		oLog.LogMessage "Beginne Spalten anhängen."
		Set oFM = oMC.FieldManagement(sFinalFile)
		oFM.AppendField "WERTSTELLUNG", "", 5, 8, 0, "@compif (WERTSTELLUNG_ORG == ""30.02.2018""; @ctod(""28.02.2018"";""DD.MM.YYYY""); WERTSTELLUNG_ORG == """"; @ctod(""00.00.0000"";""DD.MM.YYYY"");1;@ctod(WERTSTELLUNG_ORG ;""DD.MM.YYYY"") )"
		oFM.AppendField "SHK", "", 3, 1, 0, "@If(BETRAG < 0;""S"";""H"")"
		oFM.AppendField "RAHMENNR_2STELLIG", "", 3, 2, 0, "@Left(KTO_RAHMEN;2)"
		oFM.AppendField "RAHMENNR_3STELLIG", "", 3, 3, 0, "@Left(KTO_RAHMEN;3)"
		oFM.AppendField "NICHTAUFGRIFFSGRENZE", "", 4, 8, 2, sNichtaufgriffsgrenze
		oFM.PerformTask
		Set oFM = Nothing
		Set oFM = oMC.FieldManagement(sFinalFile)
		oFM.AppendField "RELEVANT", "", 3, 1, 0, "@If(@Abs(BETRAG) > NICHTAUFGRIFFSGRENZE;""X"";"""")"
		oFM.PerformTask
		Set oFM = Nothing
		oLog.LogMessage "Beendet Spalten anhängen."
	else
		MsgBox("Die importierten Dateien enthalten keine Datensätze. Bitte überprüfen Sie die Original-Dateien oder die entsprechende Konten- oder Rahmennummerauswahl.")
		'Kill sFinalFile
		SmartContext.ExecutionStatus =EXEC_STATUS_CANCELED
		SmartContext.Log.LogWarning ("Die importierten Dateien enthalten keine Datensätze. Bitte überprüfen Sie die Original-Dateien oder die entsprechende Konten- oder Rahmennummerauswahl.")
		SmartContext.AbortImport = True
	end if
	oLog.LogMessage "Lösche Einzelumsätze."
	'if bUmsatz_2 then Kill sUmsatz_2
	'if bUmsatz_3 then Kill sUmsatz_3
	'if bUmsatz_4 then Kill sUmsatz_4
	'if bUmsatz_5 then Kill sUmsatz_5
	'if bUmsatz_6 then Kill sUmsatz_6
	'if bUmsatz_7 then Kill sUmsatz_7
	'if bUmsatz_8 then Kill sUmsatz_8
	'if bUmsatz_9 then Kill sUmsatz_9
	'if bUmsatz_10 then Kill sUmsatz_10
	'if bUmsatz_11 then Kill sUmsatz_11
	'if bUmsatz_12 then Kill sUmsatz_12
	
	PrepareUmsätzeGesamt = sFinalFile
	Exit Sub
	
ErrorHandler:
	Call LogSmartAnalyzerError("")
	Stop
End Function
'-----------------------------------------------------------------------------------------
' Preparation - PrepareOBRKonten
'-----------------------------------------------------------------------------------------
Function PrepareOBRKonten
On Error GoTo ErrorHandler
SetCheckpoint "PrepareOBRKonten"
oLog.LogMessage m_checkpointName
	If oSC.FileIsValid(sOBRKonten) Then
		oLog.LogMessage "check account length"
		Dim iMaxAccountLength As Integer
		Dim iMinAccountLength As Integer
		iMinAccountLength = 0
		iMaxAccountLength = oSC.GetMaxLength(sOBRKonten, "KONTO", iMinAccountLength)
		If iMaxAccountLength < 10 Then
			oLog.LogMessage "Länge Kontonummer: " & iMaxAccountLength
			oLog.LogMessage "Beginne Kontonummer mit führenden Nullen auffüllen." & Date()
			Set db = Client.OpenDatabase(sOBRKonten)
			oSC.RenameField db, "KONTO", "KONTO_OG"
			db.Close
			Set db = Nothing
			Set oFM = oMC.FieldManagement(sOBRKonten)
			oFM.AppendField "KONTO", "KONTO_OG wurde mit führenden Nullen aufgefüllt.", 3, 10, 0, "@Repeat(""0"";10-@Len(KONTO_OG))+KONTO_OG"
			oFM.PerformTask
			Set oFM = Nothing
			oLog.LogMessage "Beende Kontonummer mit führenden Nullen auffüllen." & Date()
		Else
			oLog.LogMessage "Länge Kontonummer: " & iMaxAccountLength
		End If
		Set oFM = oMC.FieldManagement(sOBRKonten)
		oLog.LogMessage "OBR_Konten werden aufbereitet."
		oFM.AppendField "SHK", "", 3, 1, 0, "@If(AZ9_SALDO < 0;""S"";""H"")"
		oFM.AppendField "RAHMENNR_2STELLIG", "", 3, 2, 0, "@Left(RAHMENNR;2)"
		oFM.AppendField "RAHMENNR_3STELLIG", "", 3, 3, 0, "@Left(RAHMENNR;3)"
		oFM.AppendField "POSITION_SHORT", "", 3, 5, 0, "@Mid(POSITIONEN;2;5)"
		oFM.PerformTask
		Set oFM = Nothing
		oLog.LogMessage "Beendet Spalten anhängen."
	else
		MsgBox("Die importierten Dateien enthalten keine Datensätze. Bitte überprüfen Sie die Original-Dateien oder die entsprechende Konten- oder Rahmennummerauswahl.")
		SmartContext.ExecutionStatus =EXEC_STATUS_CANCELED
		SmartContext.Log.LogWarning ("Die importierten Dateien enthalten keine Datensätze. Bitte überprüfen Sie die Original-Dateien oder die entsprechende Konten- oder Rahmennummerauswahl.")
		SmartContext.AbortImport = True
	end if

	Exit Sub
	
ErrorHandler:
	Call LogSmartAnalyzerError("")
	Stop
End Function
'-----------------------------------------------------------------------------------------
' Preparation - PrepareSalesData
'-----------------------------------------------------------------------------------------
Function PrepareSalesData
On Error GoTo ErrorHandler
SetCheckpoint "PrepareSalesData"
oLog.LogMessage m_checkpointName
oLog.LogMessage "Beginn Join Umsatz mit OBR." & Date()
	Set db = Client.OpenDatabase(sUmsätzeGesamt)
	Set task = db.JoinDatabase
	task.FileToJoin sOBRKonten
	task.AddPFieldToInc "KONTO_NR"
	task.AddPFieldToInc "KONTOBEZEICHNUNG"
	task.AddPFieldToInc "BUCHUNGSDATUM"
	task.AddPFieldToInc "WERTSTELLUNG"
	task.AddPFieldToInc "WERTSTELLUNG_ORG"
	task.AddPFieldToInc "BETRAG"
	task.AddPFieldToInc "WKZ"
	task.AddPFieldToInc "TEXTSCHLÜSSEL"
	task.AddPFieldToInc "KTO_RAHMEN"
	task.AddPFieldToInc "AUFTRAGG_KTO"
	task.AddPFieldToInc "PN"
	task.AddPFieldToInc "VERWENDUNGSZWECK"
	task.AddPFieldToInc "SHK"
	task.AddPFieldToInc "RAHMENNR_2STELLIG"
	task.AddPFieldToInc "RAHMENNR_3STELLIG"
	task.AddPFieldToInc "NICHTAUFGRIFFSGRENZE"
	task.AddPFieldToInc "RELEVANT"
	task.AddSFieldToInc "KONTO"
	task.AddSFieldToInc "BEZEICHNUNG"
	task.AddSFieldToInc "AZ9_SALDO"
	task.AddSFieldToInc "SHK"
	task.AddSFieldToInc "RAHMENNR_2STELLIG"
	task.AddSFieldToInc "POSITION_SHORT"
	task.AddSFieldToInc "ERÖFFNUNG"
	task.AddSFieldToInc "AUFLÖSUNG"
	task.AddMatchKey "KONTO_NR", "KONTO", "A"
	task.CreateVirtualDatabase = False
	task.DisableProgressNotification = FALSE
	sUmsätzeZuOBR = oSC.UniqueFileName(sWorkingfolderPfad & "{Umsätze_zu_OBR_Gesamt}.IMD")
	task.PerformTask sUmsätzeZuOBR, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sUmsätzeZuOBR & "erstellt. Beginne Join Primanotenplan." & Date()
	Set db = Client.OpenDatabase(sUmsätzeZuOBR)
	Set task = db.JoinDatabase
	task.FileToJoin sPrimanoten
	task.IncludeAllPFields
	task.AddSFieldToInc "MANUELLE_BUCHUNGEN"
	task.AddMatchKey "PN", "PN_NR", "A"
	task.CreateVirtualDatabase = False
	task.DisableProgressNotification = True
	sUmsätzeOBRPrimanoten = oSC.UniqueFileName(sWorkingfolderPfad & "{Umsätze_zu_OBR_Gesamt_mit_Buchungskennzeichen}.IMD")
	task.PerformTask sUmsätzeOBRPrimanoten, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sUmsätzeOBRPrimanoten & "erstellt. Beginne Summierung RAHMENNR_2STELLIG und SHK." & Date()
	Set db = Client.OpenDatabase(sUmsätzeOBRPrimanoten)
	Set task = db.Summarization
	'task.UseQuickSummarization = TRUE
	task.AddFieldToSummarize "RAHMENNR_2STELLIG"
	task.AddFieldToSummarize "SHK"
	task.AddFieldToTotal "BETRAG"
	task.Criteria = "RAHMENNR_2STELLIG <> """""
	sBuchungenJeKtoRahmen = oSC.UniqueFileName(sWorkingfolderPfad & "-SKA00_Anzahl_Buchungen_je_bebuchten_KtoRahmen_mit_SHK.IMD")
	task.OutputDBName = sBuchungenJeKtoRahmen
	task.CreatePercentField = False
	task.StatisticsToInclude = SM_SUM
	task.DisableProgressNotification = True
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sBuchungenJeKtoRahmen & "erstellt. Beginne Summierung RAHMENNR_2STELLIG." & Date()
	Set db = Client.OpenDatabase(sUmsätzeOBRPrimanoten)
	Set task = db.Summarization
	'task.UseQuickSummarization = TRUE
	task.AddFieldToSummarize "RAHMENNR_2STELLIG"
	task.AddFieldToTotal "BETRAG"
	sBuchungenJeKtoRahmenGes = oSC.UniqueFileName(sWorkingfolderPfad & "-SKA00_Anzahl_Buchungen_je_KtoRahmen.IMD")
	task.OutputDBName = sBuchungenJeKtoRahmenGes
	task.CreatePercentField = False
	task.StatisticsToInclude = SM_SUM + SM_MAX + SM_MIN + SM_AVERAGE
	task.DisableProgressNotification = True
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sBuchungenJeKtoRahmenGes & "erstellt. Beginne Extraktion manuelle und automatische Buchungen." & Date()
	Set db = Client.OpenDatabase(sUmsätzeOBRPrimanoten)
	Set task = db.Extraction
	task.IncludeAllFields
	sUmsaetzeOBRManuell = oSC.UniqueFileName(sWorkingfolderPfad & "-SKA00_Umsätze_zu_OBR_manuell.IMD")
	task.AddExtraction sUmsaetzeOBRManuell, "", "@Isini(""X"";MANUELLE_BUCHUNGEN)"
	sUmsaetzeOBRAuto = oSC.UniqueFileName(sWorkingfolderPfad & "-SKA00_Umsätze_zu_OBR_automatisch.IMD")
	task.AddExtraction sUmsaetzeOBRAuto, "", ".NOT. @Isini(""X"";MANUELLE_BUCHUNGEN)"
	task.CreateVirtualDatabase = False
	task.DisableProgressNotification = True
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sUmsaetzeOBRManuell & " und " & sUmsaetzeOBRAuto & "erstellt. Beginne Spaltenanhängen manuelle Buchungen." & Date()
	Set oFM = oMC.FieldManagement(sUmsaetzeOBRManuell)
	oFM.AppendField "WERTSTELLUNG_JAHR", "", 3, 4, 0, "@Str(@Year(WERTSTELLUNG);4;2)"
	oFM.AppendField "RELEVANTER_BETRAG", "", 3, 1, 0, "@If(BETRAG>999,99;@If(@Right(@Str(BETRAG;20;2);6)==""000,00"";""X"";"""");"""")"
	oFM.PerformTask
	Set oFM = Nothing
oLog.LogMessage "Spalten WERTSTELLUNG_JAHR und RELEVANTER_BETRAG angehangen. Beginne Summierung manuelle Buchungen nach RAHMENNR_2STELLIG." & Date()
	Set db = Client.OpenDatabase(sUmsaetzeOBRManuell)
	Set task = db.Summarization
	'task.UseQuickSummarization = TRUE
	task.AddFieldToSummarize "RAHMENNR_2STELLIG"
	task.AddFieldToTotal "BETRAG"
	sUmsaetzeManuellJeKto = oSC.UniqueFileName(sWorkingfolderPfad & "-SKA00_Manuelle_Buchungen_je_KtoRahmen.IMD")
	task.OutputDBName = sUmsaetzeManuellJeKto
	task.CreatePercentField = False
	task.UseFieldFromFirstOccurrence = True
	task.StatisticsToInclude = SM_SUM + SM_MAX + SM_MIN + SM_AVERAGE
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sUmsaetzeManuellJeKto & "erstellt. Beginne Extraktion manuelle Buchungen in EUR und nicht in EUR." & Date()
	Set db = Client.OpenDatabase(sUmsaetzeOBRManuell)
	Set task = db.Extraction
	task.IncludeAllFields
	sUmsaetzeOBRinEURManuell = oSC.UniqueFileName(sWorkingfolderPfad & "-SKA00_Umsätze_zu_OBR_in_EUR_manuell.IMD")
	task.AddExtraction sUmsaetzeOBRinEURManuell, "", "WKZ == ""EUR"""
	sUmsaetzeOBRungleichEURManuell = oSC.UniqueFileName(sWorkingfolderPfad & "-SKA00_Umsätze_zu_OBR_nicht_in_EUR_manuell.IMD")
	task.AddExtraction sUmsaetzeOBRungleichEURManuell, "", "WKZ <> ""EUR"""
	task.CreateVirtualDatabase = False
	task.DisableProgressNotification = True
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sUmsaetzeOBRinEURManuell & " und " & sUmsaetzeOBRungleichEURManuell & "erstellt. Beginne Extraktion manuelle Buchungen Haben auf Soll, Soll auf Haben, Storne Soll auf Haben und Storno Haben auf Soll." & Date()
	Set db = Client.OpenDatabase(sUmsaetzeOBRinEURManuell)
	Set task = db.Extraction
	task.IncludeAllFields
	sHabenAufSollOBRinEUR = oSC.UniqueFileName(sWorkingfolderPfad & "-SKA00_HabenBuchungen_auf_SollKonten_zu_OBR_in_EUR.IMD")
	task.AddExtraction sHabenAufSollOBRinEUR, "", "AZ9_SALDO <= 0,00 .AND. BETRAG > 0,00 .AND. TEXTSCHLÜSSEL <> ""25"" .AND. TEXTSCHLÜSSEL <> ""68"""
	sSollAufHabenOBRinEUR = oSC.UniqueFileName(sWorkingfolderPfad & "-SKA00_SollBuchungen_auf_HabenKonten_zu_OBR_in_EUR.IMD")
	task.AddExtraction sSollAufHabenOBRinEUR, "", "AZ9_SALDO > 0,00 .AND. BETRAG <= 0,00 .AND. TEXTSCHLÜSSEL <> ""25"" .AND. TEXTSCHLÜSSEL <> ""68"""
	sStornoHabenAufSollOBRinEUR = oSC.UniqueFileName(sWorkingfolderPfad & "-SKA00_Storno_HabenBuchungen_auf_SollKonten_zu_OBR_in_EUR.IMD")
	task.AddExtraction sStornoHabenAufSollOBRinEUR, "", "AZ9_SALDO <= 0,00 .AND. BETRAG > 0,00 .AND. ( TEXTSCHLÜSSEL == ""25"" .OR. TEXTSCHLÜSSEL == ""68"" .or. @isini(""Storno"";VERWENDUNGSZWECK)  .OR. @isini(""Korrektur"";VERWENDUNGSZWECK)  .OR.  @isini(""Berichtigung"";VERWENDUNGSZWECK))"
	sStornoSollAufHabenOBRinEUR = oSC.UniqueFileName(sWorkingfolderPfad & "-SKA00_Storno_SollBuchungen_auf_HabenKonten_zu_OBR_in_EUR.IMD")
	task.AddExtraction sStornoSollAufHabenOBRinEUR, "", "AZ9_SALDO > 0,00 .AND. BETRAG <= 0,00 .AND. ( TEXTSCHLÜSSEL == ""25"" .OR. TEXTSCHLÜSSEL == ""68"" .or. @isini(""Storno"";VERWENDUNGSZWECK)  .OR. @isini(""Korrektur"";VERWENDUNGSZWECK)  .OR.  @isini(""Berichtigung"";VERWENDUNGSZWECK))"
	task.CreateVirtualDatabase = False
	task.DisableProgressNotification = True
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sHabenAufSollOBRinEUR & " und " & sSollAufHabenOBRinEUR & " und " & sStornoHabenAufSollOBRinEUR & " und " & sStornoSollAufHabenOBRinEUR & "erstellt. Beginne Spalten anhängen automatische Buchungen." & Date()
	Set oFM = oMC.FieldManagement(sUmsaetzeOBRAuto)
	oFM.AppendField "WERTSTELLUNG_JAHR", "", 3, 4, 0, "@Str(@Year(WERTSTELLUNG);4;2)"
	oFM.PerformTask
	Set oFM = Nothing
oLog.LogMessage "Spalten WERTSTELLUNG_JAHR angehangen. Beginne Summierung manuelle Buchungen nach RAHMENNR_2STELLIG." & Date()
	Set db = Client.OpenDatabase(sUmsaetzeOBRAuto)
	Set task = db.Summarization
	'task.UseQuickSummarization = TRUE
	task.AddFieldToSummarize "RAHMENNR_2STELLIG"
	task.AddFieldToTotal "BETRAG"
	sUmsaetzeAutoJeKto = oSC.UniqueFileName(sWorkingfolderPfad & "-SKA00_Automatische_Buchungen_je_KtoRahmen.IMD")
	task.OutputDBName = sUmsaetzeAutoJeKto
	task.CreatePercentField = False
	task.UseFieldFromFirstOccurrence = True
	task.StatisticsToInclude = SM_SUM + SM_MAX + SM_MIN + SM_AVERAGE
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sUmsaetzeAutoJeKto & "erstellt. Beginne Extraktion automatische Buchungen in EUR und nicht in EUR." & Date()
	Set db = Client.OpenDatabase(sUmsaetzeOBRAuto)
	Set task = db.Extraction
	task.IncludeAllFields
	sUmsaetzeOBRinEURAuto = oSC.UniqueFileName(sWorkingfolderPfad & "-SKA00_Umsätze_zu_OBR_in_EUR_automatisch.IMD")
	task.AddExtraction sUmsaetzeOBRinEURAuto, "", "WKZ == ""EUR"""
	sUmsaetzeOBRungleichEURAuto = oSC.UniqueFileName(sWorkingfolderPfad & "-SKA00_Umsätze_zu_OBR_nicht_in_EUR_automatisch.IMD")
	task.AddExtraction sUmsaetzeOBRungleichEURAuto, "", "WKZ <> ""EUR"""
	task.CreateVirtualDatabase = False
	task.DisableProgressNotification = True
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
oLog.LogMessage sUmsaetzeOBRinEURManuell & " und " & sUmsaetzeOBRungleichEURManuell & "erstellt." & Date()
	
	Exit Sub
	
ErrorHandler:
	Call LogSmartAnalyzerError("")
	Stop
End Function
'-----------------------------------------------------------------------------------------
' Standard Functions - Register Table
'-----------------------------------------------------------------------------------------
Function RegisterTable(ByVal sTableName As String, ByVal sMMPName As String)
On Error GoTo ErrorHandler
SetCheckpoint "RegisterTables"
oLog.LogMessage m_checkpointName
Dim oTagger As Object
Dim eqnBuilder As Object
Dim resultObject As Object
dim sStandardFilter as string
	Select Case sTableName
		Case sUmsätzeOBRPrimanoten
			sStandardFilter = "SKAUmsatzGesamt"
			Set oTagger = oTM.AssociatingTagging(sTableName)
			oTagger.SetTag "acc!KONTO_NR", "KONTO_NR"
			oTagger.SetTag "acc!KONTO_BEZ", "KONTOBEZEICHNUNG"
			oTagger.SetTag "acc!BUDAT", "BUCHUNGSDATUM"
			oTagger.SetTag "acc!WERTDAT", "WERTSTELLUNG"
			oTagger.SetTag "acc!BETRAG", "BETRAG"
			oTagger.SetTag "acc!WKZ", "WKZ"
			oTagger.SetTag "acc!TEXT", "TEXTSCHLÜSSEL"
			oTagger.SetTag "acc!KTO_RAHMEN", "KTO_RAHMEN"
			oTagger.SetTag "acc!AUFTRAGG_KTO", "AUFTRAGG_KTO"
			oTagger.SetTag "acc!PN", "PN"
			oTagger.SetTag "acc!VERZW", "VERWENDUNGSZWECK"
			oTagger.SetTag "acc!SHK", "SHK"
			oTagger.SetTag "acc!RAHMNR_2", "RAHMENNR_2STELLIG"
			oTagger.SetTag "acc!RAHMNR_3", "RAHMENNR_3STELLIG"
			oTagger.SetTag "acc!NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
			oTagger.SetTag "acc!REL", "RELEVANT"
			oTagger.SetTag "acc!KTO", "KONTO"
			oTagger.SetTag "acc!BEZ", "BEZEICHNUNG"
			oTagger.SetTag "acc!AZ9SALDO", "AZ9_SALDO"
			oTagger.SetTag "acc!SHK_OBR", "SHK1"
			oTagger.SetTag "acc!RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
			oTagger.SetTag "acc!POSSHORT", "POSITION_SHORT"
			oTagger.SetTag "acc!ERDAT", "ERÖFFNUNG"
			oTagger.SetTag "acc!AUFDAT", "AUFLÖSUNG"
			oTagger.SetTag "acc!MANBUCH", "MANUELLE_BUCHUNGEN"
			oTagger.Save
			Set oTagger = Nothing
		
			Set eqnBuilder = SmartContext.MacroCommands.ContentEquationBuilder()
			Set resultObject = SmartContext.MacroCommands.SimpleCommands.CreateResultObject(sTableName, FINAL_RESULT, True, 0)
			' MappedTestIds" muss so bleiben! ContentAreaName -> eigenen Namen nutzen
			resultObject.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter(sStandardFilter)
			
			Set mppTask = mppTaskFactory.NewRegisterTableForMppTask
			mppTask.TableName = resultObject.Name
			mppTask.ResultId = sMMPName
			mppTask.ResultName = sMMPName ' Name der erstellten IDEA Tabelle
			mppTask.ResultDisplayName = sMMPName ' Gruppenname im Workflowschritt Mehrperiodenaufbereitung
			SmartContext.TestResultFiles.Add resultObject
			mppTask.AuditTestsFilter = eqnBuilder.GetStandardTestFilter(sStandardFilter) ' ContentAreaName
			mppTask.PerformTask
			Set mppTask = Nothing
			Set eqnBuilder = Nothing
			Set resultObject = Nothing
		Case sUmsaetzeOBRAuto
			sStandardFilter = "SKAUmsatzAuto"
			Set oTagger = oTM.AssociatingTagging(sTableName)
			oTagger.SetTag "acc!AUTO_KONTO_NR", "KONTO_NR"
			oTagger.SetTag "acc!AUTO_KONTO_BEZ", "KONTOBEZEICHNUNG"
			oTagger.SetTag "acc!AUTO_BUDAT", "BUCHUNGSDATUM"
			oTagger.SetTag "acc!AUTO_WERTDAT", "WERTSTELLUNG"
			oTagger.SetTag "acc!AUTO_BETRAG", "BETRAG"
			oTagger.SetTag "acc!AUTO_WKZ", "WKZ"
			oTagger.SetTag "acc!AUTO_TEXT", "TEXTSCHLÜSSEL"
			oTagger.SetTag "acc!AUTO_KTO_RAHMEN", "KTO_RAHMEN"
			oTagger.SetTag "acc!AUTO_AUFTRAGG_KTO", "AUFTRAGG_KTO"
			oTagger.SetTag "acc!AUTO_PN", "PN"
			oTagger.SetTag "acc!AUTO_VERZW", "VERWENDUNGSZWECK"
			oTagger.SetTag "acc!AUTO_SHK", "SHK"
			oTagger.SetTag "acc!AUTO_RAHMNR_2", "RAHMENNR_2STELLIG"
			oTagger.SetTag "acc!AUTO_RAHMNR_3", "RAHMENNR_3STELLIG"
			oTagger.SetTag "acc!AUTO_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
			oTagger.SetTag "acc!AUTO_REL", "RELEVANT"
			oTagger.SetTag "acc!AUTO_KTO", "KONTO"
			oTagger.SetTag "acc!AUTO_BEZ", "BEZEICHNUNG"
			oTagger.SetTag "acc!AUTO_AZ9SALDO", "AZ9_SALDO"
			oTagger.SetTag "acc!AUTO_SHK_OBR", "SHK1"
			oTagger.SetTag "acc!AUTO_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
			oTagger.SetTag "acc!AUTO_POSSHORT", "POSITION_SHORT"
			oTagger.SetTag "acc!AUTO_ERDAT", "ERÖFFNUNG"
			oTagger.SetTag "acc!AUTO_AUFDAT", "AUFLÖSUNG"
			oTagger.SetTag "acc!AUTO_MANBUCH", "MANUELLE_BUCHUNGEN"
			oTagger.SetTag "acc!AUTO_WERTJAHR", "WERTSTELLUNG_JAHR"
			oTagger.Save
			Set oTagger = Nothing
		
			Set eqnBuilder = SmartContext.MacroCommands.ContentEquationBuilder()
			Set resultObject = SmartContext.MacroCommands.SimpleCommands.CreateResultObject(sTableName, FINAL_RESULT, True, 0)
			' MappedTestIds" muss so bleiben! ContentAreaName -> eigenen Namen nutzen
			resultObject.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter(sStandardFilter)
			
			Set mppTask = mppTaskFactory.NewRegisterTableForMppTask
			mppTask.TableName = resultObject.Name
			mppTask.ResultId = sMMPName
			mppTask.ResultName = sMMPName ' Name der erstellten IDEA Tabelle
			mppTask.ResultDisplayName = sMMPName ' Gruppenname im Workflowschritt Mehrperiodenaufbereitung
			SmartContext.TestResultFiles.Add resultObject
			mppTask.AuditTestsFilter = eqnBuilder.GetStandardTestFilter(sStandardFilter) ' ContentAreaName
			mppTask.PerformTask
			Set mppTask = Nothing
			Set eqnBuilder = Nothing
			Set resultObject = Nothing
		Case sUmsaetzeAutoJeKto
			sStandardFilter = "SKAUmsatzAutoJeKto"
			Set oTagger = oTM.AssociatingTagging(sTableName)
			oTagger.SetTag "acc!AJEKTO_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
			oTagger.SetTag "acc!AJEKTO_ANZAHL", "ANZ_SAETZE"
			oTagger.SetTag "acc!AJEKTO_SUMME", "BETRAG_SUMME"
			oTagger.SetTag "acc!AJEKTO_MAX", "BETRAG_MAX"
			oTagger.SetTag "acc!AJEKTO_MIN", "BETRAG_MIN"
			oTagger.SetTag "acc!AJEKTO_DURCHSCHNITT", "BETRAG_DURCHSCHNITT"
			oTagger.Save
			Set oTagger = Nothing
		
			Set eqnBuilder = SmartContext.MacroCommands.ContentEquationBuilder()
			Set resultObject = SmartContext.MacroCommands.SimpleCommands.CreateResultObject(sTableName, FINAL_RESULT, True, 0)
			' MappedTestIds" muss so bleiben! ContentAreaName -> eigenen Namen nutzen
			resultObject.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter(sStandardFilter)
			
			Set mppTask = mppTaskFactory.NewRegisterTableForMppTask
			mppTask.TableName = resultObject.Name
			mppTask.ResultId = sMMPName
			mppTask.ResultName = sMMPName ' Name der erstellten IDEA Tabelle
			mppTask.ResultDisplayName = sMMPName ' Gruppenname im Workflowschritt Mehrperiodenaufbereitung
			SmartContext.TestResultFiles.Add resultObject
			mppTask.AuditTestsFilter = eqnBuilder.GetStandardTestFilter(sStandardFilter) ' ContentAreaName
			mppTask.PerformTask
			Set mppTask = Nothing
			Set eqnBuilder = Nothing
			Set resultObject = Nothing
		Case sUmsaetzeOBRinEURAuto
			sStandardFilter = "SKAUmsatzAutoInEUR"
			Set oTagger = oTM.AssociatingTagging(sTableName)
			oTagger.SetTag "acc!AOE_KONTO_NR", "KONTO_NR"
			oTagger.SetTag "acc!AOE_KONTO_BEZ", "KONTOBEZEICHNUNG"
			oTagger.SetTag "acc!AOE_BUDAT", "BUCHUNGSDATUM"
			oTagger.SetTag "acc!AOE_WERTDAT", "WERTSTELLUNG"
			oTagger.SetTag "acc!AOE_BETRAG", "BETRAG"
			oTagger.SetTag "acc!AOE_WKZ", "WKZ"
			oTagger.SetTag "acc!AOE_TEXT", "TEXTSCHLÜSSEL"
			oTagger.SetTag "acc!AOE_KTO_RAHMEN", "KTO_RAHMEN"
			oTagger.SetTag "acc!AOE_AUFTRAGG_KTO", "AUFTRAGG_KTO"
			oTagger.SetTag "acc!AOE_PN", "PN"
			oTagger.SetTag "acc!AOE_VERZW", "VERWENDUNGSZWECK"
			oTagger.SetTag "acc!AOE_SHK", "SHK"
			oTagger.SetTag "acc!AOE_RAHMNR_2", "RAHMENNR_2STELLIG"
			oTagger.SetTag "acc!AOE_RAHMNR_3", "RAHMENNR_3STELLIG"
			oTagger.SetTag "acc!AOE_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
			oTagger.SetTag "acc!AOE_REL", "RELEVANT"
			oTagger.SetTag "acc!AOE_KTO", "KONTO"
			oTagger.SetTag "acc!AOE_BEZ", "BEZEICHNUNG"
			oTagger.SetTag "acc!AOE_AZ9SALDO", "AZ9_SALDO"
			oTagger.SetTag "acc!AOE_SHK_OBR", "SHK1"
			oTagger.SetTag "acc!AOE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
			oTagger.SetTag "acc!AOE_POSSHORT", "POSITION_SHORT"
			oTagger.SetTag "acc!AOE_ERDAT", "ERÖFFNUNG"
			oTagger.SetTag "acc!AOE_AUFDAT", "AUFLÖSUNG"
			oTagger.SetTag "acc!AOE_MANBUCH", "MANUELLE_BUCHUNGEN"
			oTagger.SetTag "acc!AOE_WERTJAHR", "WERTSTELLUNG_JAHR"
			oTagger.Save
			Set oTagger = Nothing
		
			Set eqnBuilder = SmartContext.MacroCommands.ContentEquationBuilder()
			Set resultObject = SmartContext.MacroCommands.SimpleCommands.CreateResultObject(sTableName, FINAL_RESULT, True, 0)
			' MappedTestIds" muss so bleiben! ContentAreaName -> eigenen Namen nutzen
			resultObject.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter(sStandardFilter)
			
			Set mppTask = mppTaskFactory.NewRegisterTableForMppTask
			mppTask.TableName = resultObject.Name
			mppTask.ResultId = sMMPName
			mppTask.ResultName = sMMPName ' Name der erstellten IDEA Tabelle
			mppTask.ResultDisplayName = sMMPName ' Gruppenname im Workflowschritt Mehrperiodenaufbereitung
			SmartContext.TestResultFiles.Add resultObject
			mppTask.AuditTestsFilter = eqnBuilder.GetStandardTestFilter(sStandardFilter) ' ContentAreaName
			mppTask.PerformTask
			Set mppTask = Nothing
			Set eqnBuilder = Nothing
			Set resultObject = Nothing
		Case sUmsaetzeOBRungleichEURAuto
			sStandardFilter = "SKAUmsatzAutoNichtEUR"
			Set oTagger = oTM.AssociatingTagging(sTableName)
			oTagger.SetTag "acc!AONE_KONTO_NR", "KONTO_NR"
			oTagger.SetTag "acc!AONE_KONTO_BEZ", "KONTOBEZEICHNUNG"
			oTagger.SetTag "acc!AONE_BUDAT", "BUCHUNGSDATUM"
			oTagger.SetTag "acc!AONE_WERTDAT", "WERTSTELLUNG"
			oTagger.SetTag "acc!AONE_BETRAG", "BETRAG"
			oTagger.SetTag "acc!AONE_WKZ", "WKZ"
			oTagger.SetTag "acc!AONE_TEXT", "TEXTSCHLÜSSEL"
			oTagger.SetTag "acc!AONE_KTO_RAHMEN", "KTO_RAHMEN"
			oTagger.SetTag "acc!AONE_AUFTRAGG_KTO", "AUFTRAGG_KTO"
			oTagger.SetTag "acc!AONE_PN", "PN"
			oTagger.SetTag "acc!AONE_VERZW", "VERWENDUNGSZWECK"
			oTagger.SetTag "acc!AONE_SHK", "SHK"
			oTagger.SetTag "acc!AONE_RAHMNR_2", "RAHMENNR_2STELLIG"
			oTagger.SetTag "acc!AONE_RAHMNR_3", "RAHMENNR_3STELLIG"
			oTagger.SetTag "acc!AONE_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
			oTagger.SetTag "acc!AONE_REL", "RELEVANT"
			oTagger.SetTag "acc!AONE_KTO", "KONTO"
			oTagger.SetTag "acc!AONE_BEZ", "BEZEICHNUNG"
			oTagger.SetTag "acc!AONE_AZ9SALDO", "AZ9_SALDO"
			oTagger.SetTag "acc!AONE_SHK_OBR", "SHK1"
			oTagger.SetTag "acc!AONE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
			oTagger.SetTag "acc!AONE_POSSHORT", "POSITION_SHORT"
			oTagger.SetTag "acc!AONE_ERDAT", "ERÖFFNUNG"
			oTagger.SetTag "acc!AONE_AUFDAT", "AUFLÖSUNG"
			oTagger.SetTag "acc!AONE_MANBUCH", "MANUELLE_BUCHUNGEN"
			oTagger.SetTag "acc!AONE_WERTJAHR", "WERTSTELLUNG_JAHR"
			oTagger.Save
			Set oTagger = Nothing
		
			Set eqnBuilder = SmartContext.MacroCommands.ContentEquationBuilder()
			Set resultObject = SmartContext.MacroCommands.SimpleCommands.CreateResultObject(sTableName, FINAL_RESULT, True, 0)
			' MappedTestIds" muss so bleiben! ContentAreaName -> eigenen Namen nutzen
			resultObject.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter(sStandardFilter)
			
			Set mppTask = mppTaskFactory.NewRegisterTableForMppTask
			mppTask.TableName = resultObject.Name
			mppTask.ResultId = sMMPName
			mppTask.ResultName = sMMPName ' Name der erstellten IDEA Tabelle
			mppTask.ResultDisplayName = sMMPName ' Gruppenname im Workflowschritt Mehrperiodenaufbereitung
			SmartContext.TestResultFiles.Add resultObject
			mppTask.AuditTestsFilter = eqnBuilder.GetStandardTestFilter(sStandardFilter) ' ContentAreaName
			mppTask.PerformTask
			Set mppTask = Nothing
			Set eqnBuilder = Nothing
			Set resultObject = Nothing
		Case sUmsaetzeOBRManuell
			sStandardFilter = "SKAUmsatzManuell"
			Set oTagger = oTM.AssociatingTagging(sTableName)
			oTagger.SetTag "acc!MAN_KONTO_NR", "KONTO_NR"
			oTagger.SetTag "acc!MAN_KONTO_BEZ", "KONTOBEZEICHNUNG"
			oTagger.SetTag "acc!MAN_BUDAT", "BUCHUNGSDATUM"
			oTagger.SetTag "acc!MAN_WERTDAT", "WERTSTELLUNG"
			oTagger.SetTag "acc!MAN_BETRAG", "BETRAG"
			oTagger.SetTag "acc!MAN_WKZ", "WKZ"
			oTagger.SetTag "acc!MAN_TEXT", "TEXTSCHLÜSSEL"
			oTagger.SetTag "acc!MAN_KTO_RAHMEN", "KTO_RAHMEN"
			oTagger.SetTag "acc!MAN_AUFTRAGG_KTO", "AUFTRAGG_KTO"
			oTagger.SetTag "acc!MAN_PN", "PN"
			oTagger.SetTag "acc!MAN_VERZW", "VERWENDUNGSZWECK"
			oTagger.SetTag "acc!MAN_SHK", "SHK"
			oTagger.SetTag "acc!MAN_RAHMNR_2", "RAHMENNR_2STELLIG"
			oTagger.SetTag "acc!MAN_RAHMNR_3", "RAHMENNR_3STELLIG"
			oTagger.SetTag "acc!MAN_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
			oTagger.SetTag "acc!MAN_REL", "RELEVANT"
			oTagger.SetTag "acc!MAN_KTO", "KONTO"
			oTagger.SetTag "acc!MAN_BEZ", "BEZEICHNUNG"
			oTagger.SetTag "acc!MAN_AZ9SALDO", "AZ9_SALDO"
			oTagger.SetTag "acc!MAN_SHK_OBR", "SHK1"
			oTagger.SetTag "acc!MAN_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
			oTagger.SetTag "acc!MAN_POSSHORT", "POSITION_SHORT"
			oTagger.SetTag "acc!MAN_ERDAT", "ERÖFFNUNG"
			oTagger.SetTag "acc!MAN_AUFDAT", "AUFLÖSUNG"
			oTagger.SetTag "acc!MAN_MANBUCH", "MANUELLE_BUCHUNGEN"
			oTagger.SetTag "acc!MAN_WERTJAHR", "WERTSTELLUNG_JAHR"
			oTagger.SetTag "acc!MAN_RELBETRAG", "RELEVANTER_BETRAG"
			oTagger.Save
			Set oTagger = Nothing
		
			Set eqnBuilder = SmartContext.MacroCommands.ContentEquationBuilder()
			Set resultObject = SmartContext.MacroCommands.SimpleCommands.CreateResultObject(sTableName, FINAL_RESULT, True, 0)
			' MappedTestIds" muss so bleiben! ContentAreaName -> eigenen Namen nutzen
			resultObject.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter(sStandardFilter)
			
			Set mppTask = mppTaskFactory.NewRegisterTableForMppTask
			mppTask.TableName = resultObject.Name
			mppTask.ResultId = sMMPName
			mppTask.ResultName = sMMPName ' Name der erstellten IDEA Tabelle
			mppTask.ResultDisplayName = sMMPName ' Gruppenname im Workflowschritt Mehrperiodenaufbereitung
			SmartContext.TestResultFiles.Add resultObject
			mppTask.AuditTestsFilter = eqnBuilder.GetStandardTestFilter(sStandardFilter) ' ContentAreaName
			mppTask.PerformTask
			Set mppTask = Nothing
			Set eqnBuilder = Nothing
			Set resultObject = Nothing
		Case sUmsaetzeManuellJeKto
			sStandardFilter = "SKAUmsatzManuellJeKto"
			Set oTagger = oTM.AssociatingTagging(sTableName)
			oTagger.SetTag "acc!MJEKTO_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
			oTagger.SetTag "acc!MJEKTO_ANZAHL", "ANZ_SAETZE"
			oTagger.SetTag "acc!MJEKTO_SUMME", "BETRAG_SUMME"
			oTagger.SetTag "acc!MJEKTO_MAX", "BETRAG_MAX"
			oTagger.SetTag "acc!MJEKTO_MIN", "BETRAG_MIN"
			oTagger.SetTag "acc!MJEKTO_DURCHSCHNITT", "BETRAG_DURCHSCHNITT"
			oTagger.Save
			Set oTagger = Nothing
		
			Set eqnBuilder = SmartContext.MacroCommands.ContentEquationBuilder()
			Set resultObject = SmartContext.MacroCommands.SimpleCommands.CreateResultObject(sTableName, FINAL_RESULT, True, 0)
			' MappedTestIds" muss so bleiben! ContentAreaName -> eigenen Namen nutzen
			resultObject.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter(sStandardFilter)
			
			Set mppTask = mppTaskFactory.NewRegisterTableForMppTask
			mppTask.TableName = resultObject.Name
			mppTask.ResultId = sMMPName
			mppTask.ResultName = sMMPName ' Name der erstellten IDEA Tabelle
			mppTask.ResultDisplayName = sMMPName ' Gruppenname im Workflowschritt Mehrperiodenaufbereitung
			SmartContext.TestResultFiles.Add resultObject
			mppTask.AuditTestsFilter = eqnBuilder.GetStandardTestFilter(sStandardFilter) ' ContentAreaName
			mppTask.PerformTask
			Set mppTask = Nothing
			Set eqnBuilder = Nothing
			Set resultObject = Nothing
		Case sUmsaetzeOBRinEURManuell
			sStandardFilter = "SKAUmsatzManuellInEUR"
			Set oTagger = oTM.AssociatingTagging(sTableName)
			oTagger.SetTag "acc!MOE_KONTO_NR", "KONTO_NR"
			oTagger.SetTag "acc!MOE_KONTO_BEZ", "KONTOBEZEICHNUNG"
			oTagger.SetTag "acc!MOE_BUDAT", "BUCHUNGSDATUM"
			oTagger.SetTag "acc!MOE_WERTDAT", "WERTSTELLUNG"
			oTagger.SetTag "acc!MOE_BETRAG", "BETRAG"
			oTagger.SetTag "acc!MOE_WKZ", "WKZ"
			oTagger.SetTag "acc!MOE_TEXT", "TEXTSCHLÜSSEL"
			oTagger.SetTag "acc!MOE_KTO_RAHMEN", "KTO_RAHMEN"
			oTagger.SetTag "acc!MOE_AUFTRAGG_KTO", "AUFTRAGG_KTO"
			oTagger.SetTag "acc!MOE_PN", "PN"
			oTagger.SetTag "acc!MOE_VERZW", "VERWENDUNGSZWECK"
			oTagger.SetTag "acc!MOE_SHK", "SHK"
			oTagger.SetTag "acc!MOE_RAHMNR_2", "RAHMENNR_2STELLIG"
			oTagger.SetTag "acc!MOE_RAHMNR_3", "RAHMENNR_3STELLIG"
			oTagger.SetTag "acc!MOE_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
			oTagger.SetTag "acc!MOE_REL", "RELEVANT"
			oTagger.SetTag "acc!MOE_KTO", "KONTO"
			oTagger.SetTag "acc!MOE_BEZ", "BEZEICHNUNG"
			oTagger.SetTag "acc!MOE_AZ9SALDO", "AZ9_SALDO"
			oTagger.SetTag "acc!MOE_SHK_OBR", "SHK1"
			oTagger.SetTag "acc!MOE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
			oTagger.SetTag "acc!MOE_POSSHORT", "POSITION_SHORT"
			oTagger.SetTag "acc!MOE_ERDAT", "ERÖFFNUNG"
			oTagger.SetTag "acc!MOE_AUFDAT", "AUFLÖSUNG"
			oTagger.SetTag "acc!MOE_MANBUCH", "MANUELLE_BUCHUNGEN"
			oTagger.SetTag "acc!MOE_WERTJAHR", "WERTSTELLUNG_JAHR"
			oTagger.SetTag "acc!MOE_RELBETRAG", "RELEVANTER_BETRAG"
			oTagger.Save
			Set oTagger = Nothing
		
			Set eqnBuilder = SmartContext.MacroCommands.ContentEquationBuilder()
			Set resultObject = SmartContext.MacroCommands.SimpleCommands.CreateResultObject(sTableName, FINAL_RESULT, True, 0)
			' MappedTestIds" muss so bleiben! ContentAreaName -> eigenen Namen nutzen
			resultObject.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter(sStandardFilter)
			
			Set mppTask = mppTaskFactory.NewRegisterTableForMppTask
			mppTask.TableName = resultObject.Name
			mppTask.ResultId = sMMPName
			mppTask.ResultName = sMMPName ' Name der erstellten IDEA Tabelle
			mppTask.ResultDisplayName = sMMPName ' Gruppenname im Workflowschritt Mehrperiodenaufbereitung
			SmartContext.TestResultFiles.Add resultObject
			mppTask.AuditTestsFilter = eqnBuilder.GetStandardTestFilter(sStandardFilter) ' ContentAreaName
			mppTask.PerformTask
			Set mppTask = Nothing
			Set eqnBuilder = Nothing
			Set resultObject = Nothing
		Case sUmsaetzeOBRungleichEURManuell
			sStandardFilter = "SKAUmsatzManuellNichtEUR"
			Set oTagger = oTM.AssociatingTagging(sTableName)
			oTagger.SetTag "acc!MONE_KONTO_NR", "KONTO_NR"
			oTagger.SetTag "acc!MONE_KONTO_BEZ", "KONTOBEZEICHNUNG"
			oTagger.SetTag "acc!MONE_BUDAT", "BUCHUNGSDATUM"
			oTagger.SetTag "acc!MONE_WERTDAT", "WERTSTELLUNG"
			oTagger.SetTag "acc!MONE_BETRAG", "BETRAG"
			oTagger.SetTag "acc!MONE_WKZ", "WKZ"
			oTagger.SetTag "acc!MONE_TEXT", "TEXTSCHLÜSSEL"
			oTagger.SetTag "acc!MONE_KTO_RAHMEN", "KTO_RAHMEN"
			oTagger.SetTag "acc!MONE_AUFTRAGG_KTO", "AUFTRAGG_KTO"
			oTagger.SetTag "acc!MONE_PN", "PN"
			oTagger.SetTag "acc!MONE_VERZW", "VERWENDUNGSZWECK"
			oTagger.SetTag "acc!MONE_SHK", "SHK"
			oTagger.SetTag "acc!MONE_RAHMNR_2", "RAHMENNR_2STELLIG"
			oTagger.SetTag "acc!MONE_RAHMNR_3", "RAHMENNR_3STELLIG"
			oTagger.SetTag "acc!MONE_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
			oTagger.SetTag "acc!MONE_REL", "RELEVANT"
			oTagger.SetTag "acc!MONE_KTO", "KONTO"
			oTagger.SetTag "acc!MONE_BEZ", "BEZEICHNUNG"
			oTagger.SetTag "acc!MONE_AZ9SALDO", "AZ9_SALDO"
			oTagger.SetTag "acc!MONE_SHK_OBR", "SHK1"
			oTagger.SetTag "acc!MONE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
			oTagger.SetTag "acc!MONE_POSSHORT", "POSITION_SHORT"
			oTagger.SetTag "acc!MONE_ERDAT", "ERÖFFNUNG"
			oTagger.SetTag "acc!MONE_AUFDAT", "AUFLÖSUNG"
			oTagger.SetTag "acc!MONE_MANBUCH", "MANUELLE_BUCHUNGEN"
			oTagger.SetTag "acc!MONE_WERTJAHR", "WERTSTELLUNG_JAHR"
			oTagger.SetTag "acc!MONE_RELBETRAG", "RELEVANTER_BETRAG"
			oTagger.Save
			Set oTagger = Nothing
		
			Set eqnBuilder = SmartContext.MacroCommands.ContentEquationBuilder()
			Set resultObject = SmartContext.MacroCommands.SimpleCommands.CreateResultObject(sTableName, FINAL_RESULT, True, 0)
			' MappedTestIds" muss so bleiben! ContentAreaName -> eigenen Namen nutzen
			resultObject.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter(sStandardFilter)
			
			Set mppTask = mppTaskFactory.NewRegisterTableForMppTask
			mppTask.TableName = resultObject.Name
			mppTask.ResultId = sMMPName
			mppTask.ResultName = sMMPName ' Name der erstellten IDEA Tabelle
			mppTask.ResultDisplayName = sMMPName ' Gruppenname im Workflowschritt Mehrperiodenaufbereitung
			SmartContext.TestResultFiles.Add resultObject
			mppTask.AuditTestsFilter = eqnBuilder.GetStandardTestFilter(sStandardFilter) ' ContentAreaName
			mppTask.PerformTask
			Set mppTask = Nothing
			Set eqnBuilder = Nothing
			Set resultObject = Nothing
		Case sHabenAufSollOBRinEUR
			sStandardFilter = "SKAHabenAufSollInEUR"
			Set oTagger = oTM.AssociatingTagging(sTableName)
			oTagger.SetTag "acc!HSOE_KONTO_NR", "KONTO_NR"
			oTagger.SetTag "acc!HSOE_KONTO_BEZ", "KONTOBEZEICHNUNG"
			oTagger.SetTag "acc!HSOE_BUDAT", "BUCHUNGSDATUM"
			oTagger.SetTag "acc!HSOE_WERTDAT", "WERTSTELLUNG"
			oTagger.SetTag "acc!HSOE_BETRAG", "BETRAG"
			oTagger.SetTag "acc!HSOE_WKZ", "WKZ"
			oTagger.SetTag "acc!HSOE_TEXT", "TEXTSCHLÜSSEL"
			oTagger.SetTag "acc!HSOE_KTO_RAHMEN", "KTO_RAHMEN"
			oTagger.SetTag "acc!HSOE_AUFTRAGG_KTO", "AUFTRAGG_KTO"
			oTagger.SetTag "acc!HSOE_PN", "PN"
			oTagger.SetTag "acc!HSOE_VERZW", "VERWENDUNGSZWECK"
			oTagger.SetTag "acc!HSOE_SHK", "SHK"
			oTagger.SetTag "acc!HSOE_RAHMNR_2", "RAHMENNR_2STELLIG"
			oTagger.SetTag "acc!HSOE_RAHMNR_3", "RAHMENNR_3STELLIG"
			oTagger.SetTag "acc!HSOE_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
			oTagger.SetTag "acc!HSOE_REL", "RELEVANT"
			oTagger.SetTag "acc!HSOE_KTO", "KONTO"
			oTagger.SetTag "acc!HSOE_BEZ", "BEZEICHNUNG"
			oTagger.SetTag "acc!HSOE_AZ9SALDO", "AZ9_SALDO"
			oTagger.SetTag "acc!HSOE_SHK_OBR", "SHK1"
			oTagger.SetTag "acc!HSOE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
			oTagger.SetTag "acc!HSOE_POSSHORT", "POSITION_SHORT"
			oTagger.SetTag "acc!HSOE_ERDAT", "ERÖFFNUNG"
			oTagger.SetTag "acc!HSOE_AUFDAT", "AUFLÖSUNG"
			oTagger.SetTag "acc!HSOE_MANBUCH", "MANUELLE_BUCHUNGEN"
			oTagger.SetTag "acc!HSOE_WERTJAHR", "WERTSTELLUNG_JAHR"
			oTagger.SetTag "acc!HSOE_RELBETRAG", "RELEVANTER_BETRAG"
			oTagger.Save
			Set oTagger = Nothing
		
			Set eqnBuilder = SmartContext.MacroCommands.ContentEquationBuilder()
			Set resultObject = SmartContext.MacroCommands.SimpleCommands.CreateResultObject(sTableName, FINAL_RESULT, True, 0)
			' MappedTestIds" muss so bleiben! ContentAreaName -> eigenen Namen nutzen
			resultObject.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter(sStandardFilter)
			
			Set mppTask = mppTaskFactory.NewRegisterTableForMppTask
			mppTask.TableName = resultObject.Name
			mppTask.ResultId = sMMPName
			mppTask.ResultName = sMMPName ' Name der erstellten IDEA Tabelle
			mppTask.ResultDisplayName = sMMPName ' Gruppenname im Workflowschritt Mehrperiodenaufbereitung
			SmartContext.TestResultFiles.Add resultObject
			mppTask.AuditTestsFilter = eqnBuilder.GetStandardTestFilter(sStandardFilter) ' ContentAreaName
			mppTask.PerformTask
			Set mppTask = Nothing
			Set eqnBuilder = Nothing
			Set resultObject = Nothing
		Case sSollAufHabenOBRinEUR
			sStandardFilter = "SKASollAufHabenInEUR"
			Set oTagger = oTM.AssociatingTagging(sTableName)
			oTagger.SetTag "acc!SHOE_KONTO_NR", "KONTO_NR"
			oTagger.SetTag "acc!SHOE_KONTO_BEZ", "KONTOBEZEICHNUNG"
			oTagger.SetTag "acc!SHOE_BUDAT", "BUCHUNGSDATUM"
			oTagger.SetTag "acc!SHOE_WERTDAT", "WERTSTELLUNG"
			oTagger.SetTag "acc!SHOE_BETRAG", "BETRAG"
			oTagger.SetTag "acc!SHOE_WKZ", "WKZ"
			oTagger.SetTag "acc!SHOE_TEXT", "TEXTSCHLÜSSEL"
			oTagger.SetTag "acc!SHOE_KTO_RAHMEN", "KTO_RAHMEN"
			oTagger.SetTag "acc!SHOE_AUFTRAGG_KTO", "AUFTRAGG_KTO"
			oTagger.SetTag "acc!SHOE_PN", "PN"
			oTagger.SetTag "acc!SHOE_VERZW", "VERWENDUNGSZWECK"
			oTagger.SetTag "acc!SHOE_SHK", "SHK"
			oTagger.SetTag "acc!SHOE_RAHMNR_2", "RAHMENNR_2STELLIG"
			oTagger.SetTag "acc!SHOE_RAHMNR_3", "RAHMENNR_3STELLIG"
			oTagger.SetTag "acc!SHOE_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
			oTagger.SetTag "acc!SHOE_REL", "RELEVANT"
			oTagger.SetTag "acc!SHOE_KTO", "KONTO"
			oTagger.SetTag "acc!SHOE_BEZ", "BEZEICHNUNG"
			oTagger.SetTag "acc!SHOE_AZ9SALDO", "AZ9_SALDO"
			oTagger.SetTag "acc!SHOE_SHK_OBR", "SHK1"
			oTagger.SetTag "acc!SHOE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
			oTagger.SetTag "acc!SHOE_POSSHORT", "POSITION_SHORT"
			oTagger.SetTag "acc!SHOE_ERDAT", "ERÖFFNUNG"
			oTagger.SetTag "acc!SHOE_AUFDAT", "AUFLÖSUNG"
			oTagger.SetTag "acc!SHOE_MANBUCH", "MANUELLE_BUCHUNGEN"
			oTagger.SetTag "acc!SHOE_WERTJAHR", "WERTSTELLUNG_JAHR"
			oTagger.SetTag "acc!SHOE_RELBETRAG", "RELEVANTER_BETRAG"
			oTagger.Save
			Set oTagger = Nothing
		
			Set eqnBuilder = SmartContext.MacroCommands.ContentEquationBuilder()
			Set resultObject = SmartContext.MacroCommands.SimpleCommands.CreateResultObject(sTableName, FINAL_RESULT, True, 0)
			' MappedTestIds" muss so bleiben! ContentAreaName -> eigenen Namen nutzen
			resultObject.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter(sStandardFilter)
			
			Set mppTask = mppTaskFactory.NewRegisterTableForMppTask
			mppTask.TableName = resultObject.Name
			mppTask.ResultId = sMMPName
			mppTask.ResultName = sMMPName ' Name der erstellten IDEA Tabelle
			mppTask.ResultDisplayName = sMMPName ' Gruppenname im Workflowschritt Mehrperiodenaufbereitung
			SmartContext.TestResultFiles.Add resultObject
			mppTask.AuditTestsFilter = eqnBuilder.GetStandardTestFilter(sStandardFilter) ' ContentAreaName
			mppTask.PerformTask
			Set mppTask = Nothing
			Set eqnBuilder = Nothing
			Set resultObject = Nothing
		Case sStornoHabenAufSollOBRinEUR
			sStandardFilter = "SKAStornoHabenAufSollInEUR"
			Set oTagger = oTM.AssociatingTagging(sTableName)
			oTagger.SetTag "acc!SHSOE_KONTO_NR", "KONTO_NR"
			oTagger.SetTag "acc!SHSOE_KONTO_BEZ", "KONTOBEZEICHNUNG"
			oTagger.SetTag "acc!SHSOE_BUDAT", "BUCHUNGSDATUM"
			oTagger.SetTag "acc!SHSOE_WERTDAT", "WERTSTELLUNG"
			oTagger.SetTag "acc!SHSOE_BETRAG", "BETRAG"
			oTagger.SetTag "acc!SHSOE_WKZ", "WKZ"
			oTagger.SetTag "acc!SHSOE_TEXT", "TEXTSCHLÜSSEL"
			oTagger.SetTag "acc!SHSOE_KTO_RAHMEN", "KTO_RAHMEN"
			oTagger.SetTag "acc!SHSOE_AUFTRAGG_KTO", "AUFTRAGG_KTO"
			oTagger.SetTag "acc!SHSOE_PN", "PN"
			oTagger.SetTag "acc!SHSOE_VERZW", "VERWENDUNGSZWECK"
			oTagger.SetTag "acc!SHSOE_SHK", "SHK"
			oTagger.SetTag "acc!SHSOE_RAHMNR_2", "RAHMENNR_2STELLIG"
			oTagger.SetTag "acc!SHSOE_RAHMNR_3", "RAHMENNR_3STELLIG"
			oTagger.SetTag "acc!SHSOE_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
			oTagger.SetTag "acc!SHSOE_REL", "RELEVANT"
			oTagger.SetTag "acc!SHSOE_KTO", "KONTO"
			oTagger.SetTag "acc!SHSOE_BEZ", "BEZEICHNUNG"
			oTagger.SetTag "acc!SHSOE_AZ9SALDO", "AZ9_SALDO"
			oTagger.SetTag "acc!SHSOE_SHK_OBR", "SHK1"
			oTagger.SetTag "acc!SHSOE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
			oTagger.SetTag "acc!SHSOE_POSSHORT", "POSITION_SHORT"
			oTagger.SetTag "acc!SHSOE_ERDAT", "ERÖFFNUNG"
			oTagger.SetTag "acc!SHSOE_AUFDAT", "AUFLÖSUNG"
			oTagger.SetTag "acc!SHSOE_MANBUCH", "MANUELLE_BUCHUNGEN"
			oTagger.SetTag "acc!SHSOE_WERTJAHR", "WERTSTELLUNG_JAHR"
			oTagger.SetTag "acc!SHSOE_RELBETRAG", "RELEVANTER_BETRAG"
			oTagger.Save
			Set oTagger = Nothing
		
			Set eqnBuilder = SmartContext.MacroCommands.ContentEquationBuilder()
			Set resultObject = SmartContext.MacroCommands.SimpleCommands.CreateResultObject(sTableName, FINAL_RESULT, True, 0)
			' MappedTestIds" muss so bleiben! ContentAreaName -> eigenen Namen nutzen
			resultObject.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter(sStandardFilter)
			
			Set mppTask = mppTaskFactory.NewRegisterTableForMppTask
			mppTask.TableName = resultObject.Name
			mppTask.ResultId = sMMPName
			mppTask.ResultName = sMMPName ' Name der erstellten IDEA Tabelle
			mppTask.ResultDisplayName = sMMPName ' Gruppenname im Workflowschritt Mehrperiodenaufbereitung
			SmartContext.TestResultFiles.Add resultObject
			mppTask.AuditTestsFilter = eqnBuilder.GetStandardTestFilter(sStandardFilter) ' ContentAreaName
			mppTask.PerformTask
			Set mppTask = Nothing
			Set eqnBuilder = Nothing
			Set resultObject = Nothing
		Case sStornoSollAufHabenOBRinEUR
			sStandardFilter = "SKAStornoSollAufHabenInEUR"
			Set oTagger = oTM.AssociatingTagging(sTableName)
			oTagger.SetTag "acc!SSHOE_KONTO_NR", "KONTO_NR"
			oTagger.SetTag "acc!SSHOE_KONTO_BEZ", "KONTOBEZEICHNUNG"
			oTagger.SetTag "acc!SSHOE_BUDAT", "BUCHUNGSDATUM"
			oTagger.SetTag "acc!SSHOE_WERTDAT", "WERTSTELLUNG"
			oTagger.SetTag "acc!SSHOE_BETRAG", "BETRAG"
			oTagger.SetTag "acc!SSHOE_WKZ", "WKZ"
			oTagger.SetTag "acc!SSHOE_TEXT", "TEXTSCHLÜSSEL"
			oTagger.SetTag "acc!SSHOE_KTO_RAHMEN", "KTO_RAHMEN"
			oTagger.SetTag "acc!SSHOE_AUFTRAGG_KTO", "AUFTRAGG_KTO"
			oTagger.SetTag "acc!SSHOE_PN", "PN"
			oTagger.SetTag "acc!SSHOE_VERZW", "VERWENDUNGSZWECK"
			oTagger.SetTag "acc!SSHOE_SHK", "SHK"
			oTagger.SetTag "acc!SSHOE_RAHMNR_2", "RAHMENNR_2STELLIG"
			oTagger.SetTag "acc!SSHOE_RAHMNR_3", "RAHMENNR_3STELLIG"
			oTagger.SetTag "acc!SSHOE_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
			oTagger.SetTag "acc!SSHOE_REL", "RELEVANT"
			oTagger.SetTag "acc!SSHOE_KTO", "KONTO"
			oTagger.SetTag "acc!SSHOE_BEZ", "BEZEICHNUNG"
			oTagger.SetTag "acc!SSHOE_AZ9SALDO", "AZ9_SALDO"
			oTagger.SetTag "acc!SSHOE_SHK_OBR", "SHK1"
			oTagger.SetTag "acc!SSHOE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
			oTagger.SetTag "acc!SSHOE_POSSHORT", "POSITION_SHORT"
			oTagger.SetTag "acc!SSHOE_ERDAT", "ERÖFFNUNG"
			oTagger.SetTag "acc!SSHOE_AUFDAT", "AUFLÖSUNG"
			oTagger.SetTag "acc!SSHOE_MANBUCH", "MANUELLE_BUCHUNGEN"
			oTagger.SetTag "acc!SSHOE_WERTJAHR", "WERTSTELLUNG_JAHR"
			oTagger.SetTag "acc!SSHOE_RELBETRAG", "RELEVANTER_BETRAG"
			oTagger.Save
			Set oTagger = Nothing
		
			Set eqnBuilder = SmartContext.MacroCommands.ContentEquationBuilder()
			Set resultObject = SmartContext.MacroCommands.SimpleCommands.CreateResultObject(sTableName, FINAL_RESULT, True, 0)
			' MappedTestIds" muss so bleiben! ContentAreaName -> eigenen Namen nutzen
			resultObject.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter(sStandardFilter)
			
			Set mppTask = mppTaskFactory.NewRegisterTableForMppTask
			mppTask.TableName = resultObject.Name
			mppTask.ResultId = sMMPName
			mppTask.ResultName = sMMPName ' Name der erstellten IDEA Tabelle
			mppTask.ResultDisplayName = sMMPName ' Gruppenname im Workflowschritt Mehrperiodenaufbereitung
			SmartContext.TestResultFiles.Add resultObject
			mppTask.AuditTestsFilter = eqnBuilder.GetStandardTestFilter(sStandardFilter) ' ContentAreaName
			mppTask.PerformTask
			Set mppTask = Nothing
			Set eqnBuilder = Nothing
			Set resultObject = Nothing
		Case sOBRKonten
			sStandardFilter = "SK_FuR_Prüfung_OBR"
			Set oTagger = oTM.AssociatingTagging(sTableName)
			oTagger.SetTag "acc!OBR_KONTO_NR", "KONTO"
			oTagger.Save
			Set oTagger = Nothing
		
			Set eqnBuilder = SmartContext.MacroCommands.ContentEquationBuilder()
			Set resultObject = SmartContext.MacroCommands.SimpleCommands.CreateResultObject(sTableName, FINAL_RESULT, True, 0)
			' MappedTestIds" muss so bleiben! ContentAreaName -> eigenen Namen nutzen
			resultObject.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter(sStandardFilter)
			
			'Set mppTask = mppTaskFactory.NewRegisterTableForMppTask
			'mppTask.TableName = resultObject.Name
			'mppTask.ResultId = sMMPName
			'mppTask.ResultName = sMMPName ' Name der erstellten IDEA Tabelle
			'mppTask.ResultDisplayName = sMMPName ' Gruppenname im Workflowschritt Mehrperiodenaufbereitung
			'SmartContext.TestResultFiles.Add resultObject
			'mppTask.AuditTestsFilter = eqnBuilder.GetStandardTestFilter(sStandardFilter) ' ContentAreaName
			'mppTask.PerformTask
			'Set mppTask = Nothing
			Set eqnBuilder = Nothing
			Set resultObject = Nothing
		Case Else
	end select

	Exit Sub
	
ErrorHandler:
	Call LogSmartAnalyzerError("")
	Stop
End Function
'-----------------------------------------------------------------------------------------
' Standard Functions - Get Imported Database
'-----------------------------------------------------------------------------------------
Function GetImportedDatabaseName(ByVal logicalName As String, bvalid As Boolean) As String
	Dim databaseName As String
	On Error Resume Next
	databaseName = SmartContext.ImportFiles.Item(logicalName).ImportedFileName
	On Error GoTo ErrorHandler
	If Len(databaseName) Then
		If oSC.FileIsValid(databaseName) Then
			bvalid = true
		Else
			bvalid = false
		End If
	Else
		databaseName = ""
		bvalid = false
        SmartContext.Log.LogWarning "The database " & logicalName & " was not imported." 
	End If	
	GetImportedDatabaseName = databaseName
	Exit Sub
	
ErrorHandler:
	Call LogSmartAnalyzerError("")
	Stop
End Function
'-----------------------------------------------------------------------------------------
' Standard Functions - Error Handling
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
		
		'oPara.Delete4Project "sGeschäftsjahr"
		'oPara.Delete4Project "sNichtaufgriffsgrenze"
		'oPara.Delete4Project "sPfadUmsätze"
		'oPara.Delete4Project "sUmsätzeVorlage"
		'oPara.Delete4Project "sPfadOBR"
		'oPara.Delete4Project "sOBRKontenVorlage"
		'oPara.Delete4Project "sPfadHKKonten"
		'oPara.Delete4Project "sHKKontenVorlage"
		'oPara.Delete4Project "sPfadPrimanoten"
		'oPara.Delete4Project "sPrimanotenVorlage"
		'oPara.Delete4Project "sPfadPositionsschlüssel"
		'oPara.Delete4Project "sPositionsschlüsselVorlage"
		
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

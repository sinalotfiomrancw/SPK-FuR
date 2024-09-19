Begin Dialog Import 50,0,440,219,"Import", .DialogFunction
  OKButton 285,170,55,15, "OK", .OKButton1
  CancelButton 345,170,55,15, "Abbrechen", .CancelButton1
  GroupBox 10,16,410,135, .GroupBox1
  PushButton 10,2,55,18, "Allgemein", .pbGEN
  PushButton 10,5,55,15, "Allgemein", .pbGENSmall
  PushButton 65,2,55,18, "OBR-Konten", .pbOBR
  PushButton 65,5,55,15, "OBR-Konten", .pbOBRSmall
  PushButton 120,2,55,18, "Umsätze", .pbUmsatz
  PushButton 120,5,55,15, "Umsätze", .pbUmsatzSmall
  PushButton 175,2,55,18, "Positionsschlüssel", .pbPOS
  PushButton 175,5,55,15, "Positionsschlüssel", .pbPOSSmall
  PushButton 230,2,55,18, "Primanotenplan", .pbPN
  PushButton 230,5,55,15, "Primanotenplan", .pbPNSmall
  PushButton 285,2,55,18, "HK-Konten", .pbHK
  PushButton 285,5,55,15, "HK-Konten", .pbHKSmall
  ' 0,2,80,18, "Betriebsvergleichsschlüssel", .pbBE
  ' 0,5,80,15, "Betriebsvergleichsschlüssel", .pbBESmall
  ' 0,0,0,0
  Text 20,35,200,15, "Bitte geben Sie an wie viele Stichproben maximal gewählt werden sollen:", .tStichprobe
  TextBox 230,35,85,15, .tbStichprobe
  Text 20,65,200,15, "Bitte geben Sie einen Wert für die Nichtaufgriffsgrenze an (optional): ", .tNichtaufgriff
  TextBox 230,65,85,15, .tbNichtaufgriff
  Text 20,95,200,15, "Bitte geben Sie das zu prüfende Geschäftsjahr an:", .tGJahr
  TextBox 230,95,85,15, .tbGJahr
  ' 0,0,0,0
  Text 20,35,250,15, "Bitte wählen Sie den Pfad zu der Datendatei der OBR-Konten aus:", .tOBRKonten
  Text 20,90,200,15, "Bitte wählen Sie den Pfad zu der Beschreibungsdatei der OBR-Konten aus:", .tOBRBeschreibung
  TextBox 20,60,280,15, .tbPfadOBR
  TextBox 20,115,280,15, .tbPfadOBRDesc
  PushButton 300,60,80,15, "Durchsuchen", .pbOBRFile
  PushButton 300,115,80,15, "Durchsuchen", .pbOBRDesc
  ' 0,0,0,0
  Text 20,35,250,15, "Bitte wählen Sie den Pfad zu der Datendatei der HK-Konten aus:", .tHKKonten
  Text 20,90,200,15, "Bitte wählen Sie den Pfad zu der Beschreibungsdatei der HK-Konten aus:", .tHKBeschreibung
  TextBox 20,60,280,15, .tbPfadHK
  TextBox 20,115,280,15, .tbPfadHKDesc
  PushButton 300,60,80,15, "Durchsuchen", .pbHKFile
  PushButton 300,115,80,15, "Durchsuchen", .pbHKDesc
  ' 0,0,0,0
  Text 20,35,250,15, "Bitte wählen Sie den Pfad zu der Datendatei der Positionsschlüssel aus:", .tPos
  Text 20,90,200,15, "Bitte wählen Sie den Pfad zu der Beschreibungsdatei der Positionsschlüssel aus:", .tPosBeschreibung
  TextBox 20,60,280,15, .tbPfadPos
  TextBox 20,115,280,15, .tbPfadPosDesc
  PushButton 300,60,80,15, "Durchsuchen", .pbPosFile
  PushButton 300,115,80,15, "Durchsuchen", .pbPosDesc
  ' 0,0,0,0
  Text 20,35,250,15, "Bitte wählen Sie den Pfad zu der Datendatei des Primanotenplans aus:", .tPN
  Text 20,90,200,15, "Bitte wählen Sie den Pfad zu der Beschreibungsdatei des Primanotenplans aus:", .tPNBeschreibung
  TextBox 20,60,280,15, .tbPfadPN
  TextBox 20,115,280,15, .tbPfadPNDesc
  PushButton 300,60,80,15, "Durchsuchen", .pbPNFile
  PushButton 300,115,80,15, "Durchsuchen", .pbPNDesc
  ' 0,0,0,0
  Text 20,35,250,15, "Bitte wählen Sie den Pfad zu der Datendatei des Betriebsvergleichsschlüssel aus:", .tBE
  'Text 20,90,200,15, "Bitte wählen Sie den Pfad zu der Beschreibungsdatei des Betriebsvergleichsschlüssel aus:", .tBEBeschreibung
  TextBox 20,60,280,15, .tbPfadBE
  'TextBox 20,115,280,15, .tbPfadBEDesc
  'PushButton 300,60,80,15, "Durchsuchen", .pbBEFile
  'PushButton 300,115,80,15, "Durchsuchen", .pbBEDesc
  ' 0,0,0,0
  Text 20,35,250,15, "Bitte wählen Sie den Pfad zu den Umsatzdaten aus:", .tUms
  Text 20,90,200,15, "Bitte wählen Sie den Pfad zu der Beschreibungsdatei der Umsatzdaten aus:", .tUmsBeschreibung
  TextBox 20,60,280,15, .tbPfadUms
  TextBox 20,115,280,15, .tbPfadUmsDesc
  PushButton 300,60,80,15, "Durchsuchen", .pbUmsFile
  PushButton 300,115,80,15, "Durchsuchen", .pbUmsDesc
End Dialog

Begin Dialog BenutzerModus 50,0,131,128,"Benutzer Modus", .NeueDialogbox4
  OptionGroup .OptionButtonGroup1
  OptionButton 18,14,91,16, "Standard", .cbEasyUser
  OptionButton 18,33,92,14, "Expert Modus", .cbPowerUser
  OKButton 40,67,40,14, "OK", .OKButton1
End Dialog

Begin Dialog ImportDialogbox 50,0,150,150,"ImportDialogbox", .ImportDialogbox
End Dialog

Begin Dialog NeueDialogbox 50,0,150,150,"NeueDialogbox", .NeueDialogbox
End Dialog







































'-------------------------------------------------------------------------------------
' Title:		SKA_FuR - Import Routine
' CIR:		SKA_FuR
' Customer:	Sparkassen
' Created by:	KKR
' Created on:	10.09.2018
' Version:		1.00
'-------------------------------------------------------------------------------------
' Decription:	Import Routine for the App SKA_Fu
'-------------------------------------------------------------------------------------
' Files:		Requires 6 Input File(s)
'			- OBR-Files --> {OBR_Konten_<Prüfungsjahr>}.IMD
'			- HK-File --> {HK_<Prüfungsjahr>}.IMD
'			- Positionsschlüssel --> {Positionsschlüssel_<Prüfungsjahr}.IMD
'			- Primanotenplan --> {Primanotenplan_<Prüfungsjahr}.IMD
'			- Betriebsergebnis --> {Betriebsergebnis_<Prüfungsjahr}.IMD
'			- Umsätze --> {Umsätze_Gesamt_<Prüfungsjahr}.IMD
'			Creates 18 Basic Table(s)
'			- Buchungen je KtoRahmen mit SHK --> SKA00_Anzahl_Buchungen_je_bebuchten_KtoRahmen_mit_SHK.IMD
'			- Buchungen je KtoRahmen --> SKA00_Anzahl_Buchungen_je_KtoRahmen.IMD
'			- Umsätze OBR manuell --> SKA00_Umsätze_zu_OBR_manuell.IMD
'			- Umsätze OBR automatisch --> SKA00_Umsätze_zu_OBR_automatisch.IMD
'			- Automatische Buchungen je KtoRahmen --> SKA00_Automatische_Buchungen_je_KtoRahmen.IMD
'			- Umsätze OBR automatisch in EUR --> SKA00_Umsätze_zu_OBR_in_EUR_auto.IMD
'			- Umsätze OBR automatisch ungleich EUR --> SKA00_Umsätze_zu_OBR_nicht_in_EUR_auto.IMD
'			- Manuelle Buchungen je KtoRahmen --> SKA00_Manuelle_Buchungen_je_KtoRahmen.IMD
'			- Umsätze OBR manuell in EUR --> SKA00_Umsätze_zu_OBR_in_EUR_manuell.IMD
'			- Umsätze OBR manuell ungleich EUR --> SKA00_Umsätze_zu_OBR_nicht_in_EUR_manuell.IMD
'			- Haben auf Soll OBR in EUR --> SKA00_Haben_auf_SollKto_zu_OBR_in_EUR.IMD
'			- Soll auf Haben OBR in EUR --> SKA00_Soll_auf_HabenKto_zu_OBR_in_EUR.IMD
'			- Storno Haben auf Soll OBR in EUR --> SKA00_Storno_Haben_auf_SollKto_zu_OBR_in_EUR.IMD
'			- Storno Soll auf Haben OBR in EUR --> SKA00_Storno_Soll_auf_HabenKto_zu_OBR_in_EUR.IMD
'			- Haben auf Soll OBR ungleich EUR --> SKA00_Haben_auf_SollKto_zu_OBR_nicht_in_EUR.IMD
'			- Soll auf Haben OBR ungleich EUR --> SKA00_Soll_auf_HabenKto_zu_OBR_nicht_in_EUR.IMD
'			- Storno Haben auf Soll OBR ungleich EUR --> SKA00_Storno_Haben_auf_SollKto_zu_OBR_nicht_in_EUR.IMD
'			- Storno Soll auf Haben OBR ungleich EUR --> SKA00_Storno_Soll_auf_HabenKto_zu_OBR_nicht_in_EUR.IMD
'-------------------------------------------------------------------------------------
' Change History
'-------------------------------------------------------------------------------------
' Changed by:	KKR
' Changed on:	25.10.2018
' Requested by:	Sparkassen
' Comment:		Integrate standard imports which are always the same
'------------------
' Changed by:	AS
' Changed on:	28.04.2020
' Requested by:	Sparkassen
' Comment:		integrated account filter during import
'------------------
' Changed by:	AS
' Changed on:	05.11.2020
' Requested by:	Sparkassen Support Fall
' Comment:		fill account number with leading zero (to have a uniform sorting and cutting for account numbers which do not have 10 digits)
'------------------
' Changed by:	AS
' Changed on:	05.11.2020
' Requested by:	Audicon
' Comment:		Set fiscal year for project (gets used in different audit tests)
'------------------
' Changed by:	AS
' Changed on:	18.11.2021
' Requested by:	Audicon
' Comment:		only numerical valus for Nichtaufgriffsgrenze
'------------------
' Changed by:	AS
' Changed on:	23.05.2022
' Requested by:	AG
' Comment:		column BETRAG_RELEVANT will not be used anymore
'				append column REBU_NR for to join with table REBU-Liste
'-------------------------------------------------------------------------------------

Option Explicit

' SmartAnalyzer standard constants
' Constants for execution status
Const EXEC_STATUS_FAILED As Long = 0
Const EXEC_STATUS_SUCCEEDED As Long = 1
Const EXEC_STATUS_CANCELED As Long = 3

' Constants for result file handling
Const NOT_A_RESULT As Long = 0
Const INPUT_DATABASE As Long = 1
Const INTERMEDIATE_RESULT As Long = 2
Const FINAL_RESULT As Long = 4
Const NO_REGISTRATION As Long = 8

' IDEA standard variables
Dim db As Object
Dim task As Object
Dim field As Object
Dim table As Object
Dim eqn As String
Dim dbName As String

' SmartAnalyzer standard variables
Dim oMC As Object	' Macro Commands Object
Dim oSC As Object	' Simple Commands Object
Dim oTM As Object	' Tag Management Object
Dim oProtectIP As Object	' Object for Protecting the Intellectual Property
Dim oLog As Object	' Logging Object zur Protokollierung von Ausführungen und Fehlern
Dim assignTests As Object	' Assign Audit Tests
Dim eqnBuilder As Object		' Equation Builder for assigning Audit Tests
Dim resultObject As Object		' Result Object for assigning Audit Tests
Dim oGetResourceString As Object	' Get Strings from Resource File
Dim oTagging As Object	' Object for associate TagID to fieldname 
Dim oPara As Object
Dim oCDB As Object
Dim PNAE As String

' Specific variables
' m_checkpointName is used for error logging and this variable has to be kept global!
' The value provided by this variable shall give a clue where an error occurred.
' Remarks: It is set in Sub 'SetCheckpoint'
'          And  used in Sub 'LogSmartAnalyzerError'
Dim m_checkpointName As String	' m_checkpointName is used for error logging and this variable has to be kept global
Dim sLS As String ' List Seperator

' Variables for import files
Dim sFile2ImportOBR As String
Dim sFile2ImportHK As String
Dim sFile2ImportPOS As String
Dim sFile2ImportPN As String
Dim sFile2ImportBE As String
Dim sFile2ImportUMS As String

'Prüfung Importiert ja/nein
Dim bTableImportedOBR As Boolean
Dim bTableImportedHK As Boolean
Dim bTableImportedPOS As Boolean
Dim bTableImportedPN As Boolean
Dim bTableImportedBE As Boolean
Dim bTableImportedUMS As Boolean

'Prüfung auf Datensätze
Dim bTableContainsRecordsOBR As Boolean
Dim bTableContainsRecordsHK As Boolean
Dim bTableContainsRecordsPOS As Boolean
Dim bTableContainsRecordsPN As Boolean
Dim bTableContainsRecordsBE As Boolean
Dim bTableContainsRecordsUMS As Boolean

'Prüfung ob alle benötigten Felder vorhanden sind
Dim bContainsAllFieldsOBR As Boolean
Dim bContainsAllFieldsHK As Boolean
Dim bContainsAllFieldsPOS As Boolean
Dim bContainsAllFieldsPN As Boolean
Dim bContainsAllFieldsBE As Boolean
Dim bContainsAllFieldsUMS As Boolean

'Variablen für temporäre Zwischentabellen
Dim dbTempTablePruefungAnalysezeitraum As String

'final tables
Dim dbBuchungenJeKtoRahmen As String
Dim dbBuchungenJeKtoRahmenGes As String
Dim sUmsaetze As String
Dim dbUmsaetzeOBRAuto As String
Dim dbUmsaetzeOBRManuell As String
Dim dbUmsaetzeOBREuro As String
Dim dbUmsaetzeAutoJeKto As String
Dim dbUmsaetzeManuellJeKto As String
Dim dbUmsaetzeOBRinEURManuell As String
Dim dbUmsaetzeOBRungleichEURManuell As String
Dim dbUmsaetzeOBRinEURAuto As String
Dim dbUmsaetzeOBRungleichEURAuto As String
Dim dbHabenAufSollOBRinEUR As String
Dim dbSollAufHabenOBRinEUR As String
Dim dbStornoHabenAufSollOBRinEUR As String
Dim dbStornoSollAufHabenOBRinEUR As String
Dim dbHabenAufSollOBRungleichEUR As String
Dim dbSollAufHabenOBRungleichEUR As String
Dim dbStornoHabenAufSollOBRungleichEUR As String
Dim dbStornoSollAufHabenOBRungleichEUR As String

Dim bBuchungenJeKtoRahmen As String
Dim bBuchungenJeKtoRahmenGes As String
Dim bUmsaetzeOBRAuto As String
Dim bUmsaetzeOBRManuell As String
Dim bUmsaetzeAutoJeKto As String
Dim bUmsaetzeManuellJeKto As String
Dim bUmsaetzeOBRinEURManuell As String
Dim bUmsaetzeOBRungleichEURManuell As String
Dim bUmsaetzeOBRinEURAuto As String
Dim bUmsaetzeOBRungleichEURAuto As String
Dim bHabenAufSollOBRinEUR As String
Dim bSollAufHabenOBRinEUR As String
Dim bStornoHabenAufSollOBRinEUR As String
Dim bStornoSollAufHabenOBRinEUR As String
Dim bHabenAufSollOBRungleichEUR As String
Dim bSollAufHabenOBRungleichEUR As String
Dim bStornoHabenAufSollOBRungleichEUR As String
Dim bStornoSollAufHabenOBRungleichEUR As String

'available columns
Dim bERFDAT As Boolean

'Anwenderdefinierte Variablen
Dim bDebugMode As Boolean
Dim bOriginalFieldnames As Boolean
Dim oSpaltenanzahl As Object
Dim iErwarteteSpalten As Integer
Dim bPrivateMode As Boolean

'Variablen für Dialog
Dim Button As Variant
Dim iAnzahlSpalten As Integer
Dim Dlg1 As Zuweisung
Dim i As Integer
Dim iAnzSaetzeDB As Integer
Dim iAnzSaetzeArray As Integer

'Variablen für Dialog - Neu
Dim iReturnWertDlg As Integer
Dim iReturnWertCb As Integer
Dim sQuellDatei As String
Dim oDialogDateiauswahl As Object
Dim dlgImport As Import
Dim sPfadOBR As String
Dim sPfadOBRDesc As String
Dim sPfadHK As String
Dim sPfadHKDesc As String
Dim sPfadPOS As String
Dim sPfadPOSDesc As String
Dim sPfadPN As String
Dim sPfadPNDesc As String
Dim sPfadBE As String
Dim sPfadBEDesc As String
Dim sPfadUmsatz As String
Dim sPfadUmsatzDesc As String

' Variablen für Kontenfilterdialog
Dim sEquation As String

'Ab Version 1.04 keine Stichprobe
Dim sParaStichprobe As String

Dim sParaNAGrenze As String
Dim sParaGJahr As String
Dim sSelect As String
Dim sMainProjectPath As String

'Variablen für globale Tabellen
Dim dbImportOBR As String
Dim dbImportOBRTemp	As String
Dim dbImportBVS	As String
Dim dbImportHK As String
Dim dbImportPos As String
Dim dbImportPN As String
Dim dbImportBE As String
Dim sVariable As String
Dim dbPNAEName As String
Dim dbPNAENameTemp1 As String

'cbExpertModus
Dim userMode As Integer
Dim sPfadBewData As String
Dim sPfadVorlage As String
'konfig
Dim sNewDBName As String
Dim dbConfigFile As String
Dim dbConfigPath As String
Dim bImportRunning As Boolean
Dim jahrLength As Integer

Sub Main

On Error GoTo ErrorHandler

	SetCheckpoint "Begin of Sub Main()"

	Set oLog = SmartContext.Log
	Set oMC = SmartContext.MacroCommands
	Set oSC = oMC.SimpleCommands
	Set oTM = oMC.TagManagement
	Set oCDB = oMC.CreateDatabase
	Set oProtectIP = SmartContext.MacroCommands.ProtectIP
	Set oGetResourceString = SmartContext.Strings
	Set oPara = SmartContext.MacroCommands.GlobalParameters ' AS 05.11.2020
	Set PNAE = oPara.Get4Project("ac.global.PNAE")
	sMainProjectPath = Client.WorkingDirectory
	oLog.LogMessage "Main Project Path: " & sMainProjectPath
	oPara.Set4Project "sMainProjectPath", sMainProjectPath

	oLog.LogMessage(Chr(10) & " **** Start App Name: " & SmartContext.ProjectName & " **** ")
	oLog.LogMessage "Standard Import Routine Name: " & SmartContext.TestName
	oLog.LogMessage "Standard Import Routine Version: " & SmartContext.TestVersion
	oLog.LogMessage "Execution Time Start: " & Now()
'	SmartContext.Log.LogMessage "Runs on server: {0}", SmartContext.IsServerTask
	
	' Set private mode (disable project overview, delete History in standard tables)
	bPrivateMode = FALSE

	oProtectIP.ProjectOverviewOff
	
	SmartContext.ExecutionStatus = EXEC_STATUS_FAILED
	
	SmartContext.ScriptProgress 0, 1

	' List Seperator auslesen und auf String Variable setzen:
	sLS = oSC.ListSeparator

	' If setting bDebugMode = TRUE temporary tables will not be deleted:
	bDebugMode = FALSE
	
	oLog.LogMessage "Read Values for Dialog"
	SetCheckpoint "Read Values"
	Call ReadParameter()
	
	'Call Dialog
	oLog.LogMessage "Create Dialog - Import"
	SetCheckpoint "Begin Dialog"
	
	userMode = 0
	userMode = GetUserMode()
	'IgnoreWarning(True)

MyDialog:

	iReturnWertDlg = Dialog(dlgImport)
	'oLog.LogMessage "iExpertModus: " & iExpertModus

	Select Case iReturnWertDlg
		Case 13
			sPfadOBR = SelectFile()
			'oLog.LogMessage "iReturnWertDlg" & iReturnWertDlg & sPfadOBR
			GoTo MyDialog
		Case 14
			sPfadOBRDesc = SelectFile()
			GoTo MyDialog
		Case 15
			sPfadHK = SelectFile() 
			GoTo MyDialog
		Case 16
			sPfadHKDesc = SelectFile()
			GoTo MyDialog
		Case 17
			sPfadPos = SelectFile()
			GoTo MyDialog
		Case 18
			sPfadPosDesc = SelectFile()
			GoTo MyDialog
		Case 19
			sPfadPN = SelectFile()
			GoTo MyDialog
		Case 20
			sPfadPNDesc = SelectFile()
			GoTo MyDialog
'		Case 23
'			sPfadBE = SelectFile()
'			GoTo MyDialog
'		Case 24
'			sPfadBEDesc = SelectFile()
'			GoTo MyDialog
		Case 21
			sPfadUmsatz = SelectFolder("Bitte wählen Sie den Ordner aus, in dem die Umsatzdateien liegen.")
			GoTo MyDialog
		Case 22
			sPfadUmsatzDesc = SelectFile()
			GoTo MyDialog
		Case 0
			oLog.LogMessage("Dialog abgebrochen, der Datenimport wird abgebrochen.")

			MsgBox("Sie haben den Dialog abgebrochen." & Chr(13) & "Das Skript wird beendet.")
			SmartContext.ExecutionStatus = EXEC_STATUS_CANCELED
			SmartContext.AbortImport = True
			Exit Sub

			SetCheckpoint "Dialog abgebrochen, der Datenimport wird abgebrochen- - Abbruch durch Benutzer"

			Exit Sub
			
		Case Else
			If (userMode = 0) Then
				jahrLength = iLen(dlgImport.tbGJahr)
				' MsgBox(Year(dlgImport.tbGJahr,"YYYY"))
				
				'v103
				'If (FileExists(sPfadOBR) And FileExists(sPfadOBRDesc)  And FileExists(sPfadUmsatzDesc)  And jahrLength = 4) Then
				If (FileExists(sPfadOBR) And FileExists(sPfadUmsatzDesc)  And jahrLength = 4) Then
					'Ab Version 1.04 keine Stichprobe
					'sParaStichprobe = dlgImport.tbStichprobe
					sParaStichprobe = 0
					sParaNAGrenze = dlgImport.tbNichtAufgriff
					If IsNumeric(sParaNAGrenze) = False Or InStr(1, sParaNAGrenze, ".") <> 0 Then
						MsgBox("Die Nichtaufgriffsgrenze enthält nicht numerische Zeichen. " & _
								 Chr(13) &  "Achten Sie darauf den Wert ohne Dezimal- und Tausendertrennzeichen einzugeben")
						GoTo MyDialog
					End If
					sParaGJahr = dlgImport.tbGJahr
					If IsNumeric(sParaGJahr) = False Or InStr(1, sParaGJahr, ".") <> 0 or CDbl(sParaGJahr) > 2050 or CDbl(sParaGJahr) < 1990 Then
						MsgBox("Die Angabe für das Geschäftsjahr enthält nicht numerische Zeichen oder liegt nicht zwischen 1990 und 2050. " & _
								 Chr(13) &  "Achten Sie darauf den Wert ohne Dezimal- und Tausendertrennzeichen einzugeben")
						GoTo MyDialog
					End If
					oPara.Set4Project "sAktuelleGJAHR", sParaGJahr ' AS 05.11.2020
					 					
					'Check whether Tables are valid
					SetCheckpoint "Begin Import Files"
					
					IgnoreWarning(True)
					'Call ImportFiles
					bImportRunning = false
					'Call FilterDialog	' 28.04.2020 AS
					Call ImportFilesForStandardUser
					If SmartContext.ExecutionStatus = EXEC_STATUS_CANCELED Then GoTo EndOfDialog ' AS 06.10.2020
					bImportRunning = true 
					'IgnoreWarning(false)
	
					SetCheckpoint "End Import Files"
					
					If bTableContainsRecordsUMS = TRUE Then
						SetCheckpoint "Begin Preparation Sales Data"
						Call PrepareSalesData
						SetCheckpoint "End Preparation Sales Data"
					Else
						oLog.LogError "Die ausgewählten Umsatzdateien enthalten keine lesbaren Einträge."
					End If
	'				If bTableCreatedUMS = FALSE Then
	'					oLog.LogWarning "An Error occured. The table sales data could not be created."
	'				End If
					Client.RefreshFileExplorer
				Else 
					MsgBox("Bitte geben Sie alle Informationen zum Starten der Schnittstelle an.")
					GoTo MyDialog
				End If
					
			ElseIf userMode = 1 And bImportRunning = false Then	
				jahrLength = iLen(dlgImport.tbGJahr)

				 If (FileExists(sPfadOBR) And FileExists(sPfadOBRDesc) And FileExists(sPfadHK) And FileExists(sPfadHKDesc) And FileExists(sPfadPOS) And FileExists(sPfadPOSDesc) And FileExists(sPfadPN) And FileExists(sPfadPNDesc) And FileExists(sPfadUmsatzDesc) And jahrLength = 4) Then
					
					'Ab Version 1.04 keine Stichprobe
					'sParaStichprobe = dlgImport.tbStichprobe
					sParaStichprobe = 0
					sParaNAGrenze = dlgImport.tbNichtAufgriff
					If IsNumeric(sParaNAGrenze) = False Or InStr(1, sParaNAGrenze, ".") <> 0 Then
						MsgBox("Die Nichtaufgriffsgrenze enthält nicht numerische Zeichen. " & _
								 Chr(13) &  "Achten Sie darauf den Wert ohne Dezimal- und Tausendertrennzeichen einzugeben")
						GoTo MyDialog
					End If
					sParaGJahr = dlgImport.tbGJahr
					If IsNumeric(sParaGJahr) = False Or InStr(1, sParaGJahr, ".") <> 0 or CDbl(sParaGJahr) > 2050 or CDbl(sParaGJahr) < 1990 Then
						MsgBox("Die Angabe für das Geschäftsjahr enthält nicht numerische Zeichen oder liegt nicht zwischen 1990 und 2050. " & _
								 Chr(13) &  "Achten Sie darauf den Wert ohne Dezimal- und Tausendertrennzeichen einzugeben")
						GoTo MyDialog
					End If
					oPara.Set4Project "sAktuelleGJAHR", sParaGJahr ' AS 05.11.2020
					'Check whether Tables are valid
					
					SetCheckpoint "Begin Import Files."
					IgnoreWarning(True)
					Call FilterDialog	' 28.04.2020 AS
					Call ImportFiles
					If SmartContext.ExecutionStatus = EXEC_STATUS_CANCELED Then GoTo EndOfDialog ' AS 06.10.2020
					'IgnoreWarning(False)
					SetCheckpoint "End Import Files."
					
					If bTableContainsRecordsUMS = TRUE Then
						SetCheckpoint "Begin Preparation Sales Data"
						Call PrepareSalesData
						SetCheckpoint "End Preparation Sales Data"
					Else
						oLog.LogError "Die ausgewählten Umsatzdateien enthalten keine lesbaren Einträge."
					End If
	'				If bTableCreatedUMS = FALSE Then
	'					oLog.LogWarning "An Error occured. The table sales data could not be created."
	'				End If
					Client.RefreshFileExplorer
				Else				
					MsgBox("Bitte geben Sie alle Informationen zum Starten der Schnittstelle an.")
					GoTo MyDialog
					
				End If 		
			End If
			
	End Select	

EndOfDialog:	
		
	SetCheckpoint "End Dialog"


'	SetCheckpoint "Begin Assign Audit Tests"
'	Call AssignAuditAreas
'	SetCheckpoint "End Assign Audit Tests"
'	
'	SetCheckpoint "Begin Delete Temp Files"
'	Call deleteTempFiles()
'	SetCheckpoint "Begin Delete Temp Files"
	
	' Testing Marius
	' SmartContext.BaseFolder = "D:\examples"
	' MsgBox SmartContext.IndexXml
	' SmartContext.IndexXml = "D:\examples\index.xml"
	' SmartContext.ReplaceValues.Add "000"
	' MsgBox SmartContext.ReplaceValues.Count
	
	'Removes History of all created standard tables:
	SetCheckpoint "Begin Remove History"
	Call removeHistory()
	SetCheckpoint "End Remove History"

	oProtectIP.ProjectOverviewOn
	
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
	
	SmartContext.ScriptProgress 95, 100
	SmartContext.ExecutionStatus = EXEC_STATUS_SUCCEEDED
	oLog.LogMessage "Execution Time End: " & Now()
	oLog.LogMessage(Chr(10) & " **** End App Name: " & SmartContext.ProjectName & " **** ")
	
	Set assignTests = Nothing
	Set eqnBuilder = Nothing
	Set oGetResourceString = Nothing
	Set oProtectIP = Nothing
	Set oTM = Nothing
	Set oSC = Nothing
	Set oMC = Nothing
	Set oLog = Nothing
	Set oPara = nothing

	Exit Sub
ErrorHandler:
	Call LogSmartAnalyzerError("")
End Sub

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

Function ReadParameter
' Local Variables
Dim sAppData As String
Dim sPath As String
Dim stammDaten As String
Dim bewegungsDaten As String
Dim baseDir As String

	baseDir = sPath
	' Build  c:\Users\user.name\AppData\Roaming\CaseWare IDEA\SmartAnalyzer\AuxData\
	
	sAppData = GetReg("Volatile Environment", "APPDATA")
	sPath = sAppData & "\CaseWare IDEA\SmartAnalyzer\AuxData\SK_FuR\"

	If userMode = 0 Then
				
		'sPfadBewData = sAppData & "\Bewegungsdaten\"
		'sPfadVorlage = sAppData & "\Stammdaten\"
		
		' v103 - Muss der Beutzer den Pfad bestimmen 
		sPfadOBR = sPfadBewData & "OBR_Konten_{*Jahr*}.csv"
		 
		' v103 - Muss der Beutzer den Pfad bestimmen 
		sPfadUmsatz = sPfadBewData 
		
		' v103 - Diese RDF wird mit der App geliefert
		sPfadOBRDesc = sPath & "OBR_Konten.RDF" 
		
		' v103 -Diese RDF wird mit der App geliefert
		sPfadUmsatzDesc = sPath & "Umsatzliste.RDF" 
		
		' Diese Tabellen und RDF werden mit der App geliefert
		sPfadHK =  sPath & "HK_gesamt.csv"
		sPfadHKDesc = sPath & "HK_gesamt.RDF"

		sPfadPOS = sPath & "Positionsschlüssel.csv"
		sPfadPOSDesc =  sPath & "Positionsschlüssel.RDF"
		
		sPfadPN =  sPath & "Primanotenplan.csv" '14.07.2020 AS (neuer Primanotenplan)
		sPfadPNDesc =sPath & "Primanotenplan.RDF"
		
		sPfadBE = sPath & "Betriebsvergleichsschlüssel.csv"
		sPfadBEDesc = sPath & "Betriebsvergleichsschlüssel.RDF"
			
	Else	
		
		'sPfadOBR = sPath & "OBR_Konten_{*Jahr*}.csv"
		'sPfadOBRDesc = sPath & "OBR_Konten.RDF"
		
		'sPfadHK = sPfadHK & "HK_gesamt.csv"
		'sPfadHKDesc = sPfadHKDesc & "HK_gesamt.RDF"
		'sPfadPOS = sPfadPos & "Positionsschlüssel.csv"
		'sPfadPOSDesc = sPfadPosDesc & "Positionsschlüssel.RDF"
		'sPfadPN = sPfadPN & "Primanotenplan.csv"
		'sPfadPNDesc = sPfadPNDesc & "Primanotenplan.RDF"
			
		sPfadHK = sPath & "HK_gesamt.csv"
		sPfadHKDesc = sPath & "HK_gesamt.RDF"
		sPfadPOS = sPath & "Positionsschlüssel.csv"
		sPfadPOSDesc = sPath & "Positionsschlüssel.RDF"
		sPfadPN = sPath & "Primanotenplan.csv"
		sPfadPNDesc = sPath & "Primanotenplan.RDF"
		
		oLog.LogMessage "Pfad_ " & "HK: " & sPfadHK  
		oLog.LogMessage "Pfad_ " & "HK DESC: " & sPfadHKDesc  
				
		'wird nicht mehr benötigt
		sPfadBE = sPath & "Betriebsvergleichsschlüssel.csv"
		sPfadBEDesc = sPath & "Betriebsvergleichsschlüssel.RDF" 
	End If
	
End Function

Function GetReg(sKeyPath, sKeyValue As String) As String
' Local Variables
Dim oReg As Object
Dim sComputer As String
Dim sReturn As String
' Local Constants
Const HKEY_CURRENT_USER = &H80000001

	sComputer = "."
	Set oReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & _
                          sComputer & "\root\default:StdRegProv")
	oReg.GetStringValue HKEY_CURRENT_USER, sKeyPath, sKeyValue, sReturn
	GetReg = sReturn
	Set oReg = Nothing

End Function

Function SelectFile() As String
' Local Variables
Dim oDialogDateiauswahl As Object
Dim sFileName As String
	
	Set oDialogDateiauswahl = CreateObject("ideaex.saveopendialog")
	oDialogDateiauswahl.DisplayDialog 0
	sFileName = oDialogDateiauswahl.SelectedFile
	SelectFile = sFileName
	Set oDialogDateiauswahl = Nothing

End Function

Function SelectFolder(sText As String) As String
Dim oAppShell As Object
Dim oBrowseDir As Object
Dim sFolderName As String
			
	Set oAppShell = CreateObject("Shell.Application")
	Set oBrowseDir = oAppShell.BrowseForFolder(0, sText, &H10110, 17) 
	On Error Resume Next
	sFolderName = oBrowseDir.items().Item().Path
	SelectFolder = sFolderName & "\"
	Set oAppShell = Nothing
	Set oBrowseDir = Nothing
	On Error GoTo 0
	
End Function

Function ShowGeneral()

	DlgVisible "pbGENSmall", 0
	DlgVisible "pbGEN", 1
	DlgVisible "tStichprobe", 0
	DlgVisible "tbStichprobe", 0
	DlgVisible "tNichtaufgriff", 1
	DlgVisible "tbNichtaufgriff", 1
	DlgVisible "tGJahr", 1
	DlgVisible "tbGJahr", 1
	DlgVisible "pbOBRSmall", 1
	DlgVisible "pbOBR", 0
	DlgVisible "tOBRKonten", 0
	DlgVisible "tOBRBeschreibung", 0
	DlgVisible "tbPfadOBR", 0
	DlgVisible "tbPfadOBRDesc", 0
	DlgVisible "pbOBRFile", 0
	DlgVisible "pbOBRDesc", 0
	DlgVisible "pbHKSmall", 1
	DlgVisible "pbHK", 0
	DlgVisible "tHKKonten", 0
	DlgVisible "tHKBeschreibung", 0
	DlgVisible "tbPfadHK", 0
	DlgVisible "tbPfadHKDesc", 0
	DlgVisible "pbHKFile", 0
	DlgVisible "pbHKDesc", 0
	DlgVisible "pbPOSSmall", 1
	DlgVisible "pbPOS", 0
	DlgVisible "tPos", 0
	DlgVisible "tPosBeschreibung", 0
	DlgVisible "tbPfadPos", 0
	DlgVisible "tbPfadPosDesc", 0
	DlgVisible "pbPosFile", 0
	DlgVisible "pbPosDesc", 0
	DlgVisible "pbPNSmall", 1
	DlgVisible "pbPN", 0
	DlgVisible "tPN", 0
	DlgVisible "tPNBeschreibung", 0
	DlgVisible "tbPfadPN", 0
	DlgVisible "tbPfadPNDesc", 0
	DlgVisible "pbPNFile", 0
	DlgVisible "pbPNDesc", 0
	'DlgVisible "pbBESmall", 1
	'DlgVisible "pbBE", 0
	DlgVisible "tBE", 0
	DlgVisible "tBEBeschreibung", 0
	DlgVisible "tbPfadBE", 0
'	DlgVisible "tbPfadBEDesc", 0
	'DlgVisible "pbBEFile", 0
'	DlgVisible "pbBEDesc", 0
	DlgVisible "pbUmsatzSmall", 1
	DlgVisible "pbUmsatz", 0
	DlgVisible "tUms", 0
	DlgVisible "tUmsBeschreibung", 0
	DlgVisible "tbPfadUms", 0
	DlgVisible "tbPfadUmsDesc", 0
	DlgVisible "pbUmsFile", 0
	DlgVisible "pbUmsDesc", 0
 
End Function

Function ShowOBR()

	DlgVisible "pbGENSmall", 1 
	DlgVisible "pbGEN", 0
	DlgVisible "tStichprobe", 0
	DlgVisible "tbStichprobe", 0
	DlgVisible "tNichtaufgriff", 0
	DlgVisible "tbNichtaufgriff", 0
	DlgVisible "tGJahr", 0
	DlgVisible "tbGJahr", 0
	DlgVisible "pbOBRSmall", 0
	DlgVisible "pbOBR", 1
	DlgVisible "tOBRKonten", 1
	DlgVisible "tOBRBeschreibung", 1
	DlgVisible "tbPfadOBR", 1
	DlgVisible "tbPfadOBRDesc", 1
	DlgVisible "pbOBRFile", 1
	DlgVisible "pbOBRDesc", 1 
	DlgVisible "pbHKSmall", 1
	DlgVisible "pbHK", 0
	DlgVisible "tHKKonten", 0
	DlgVisible "tHKBeschreibung", 0
	DlgVisible "tbPfadHK", 0
	DlgVisible "tbPfadHKDesc", 0
	DlgVisible "pbHKFile", 0
	DlgVisible "pbHKDesc", 0
	DlgVisible "pbPOSSmall", 1
	DlgVisible "pbPOS", 0
	DlgVisible "tPos", 0
	DlgVisible "tPosBeschreibung", 0
	DlgVisible "tbPfadPos", 0
	DlgVisible "tbPfadPosDesc", 0
	DlgVisible "pbPosFile", 0
	DlgVisible "pbPosDesc", 0
	DlgVisible "pbPNSmall", 1
	DlgVisible "pbPN", 0
	DlgVisible "tPN", 0
	DlgVisible "tPNBeschreibung", 0
	DlgVisible "tbPfadPN", 0
	DlgVisible "tbPfadPNDesc", 0
	DlgVisible "pbPNFile", 0
	DlgVisible "pbPNDesc", 0
	'DlgVisible "pbBESmall", 1
	'DlgVisible "pbBE", 0
	DlgVisible "tBE", 0
	DlgVisible "tBEBeschreibung", 0
	DlgVisible "tbPfadBE", 0
'	DlgVisible "tbPfadBEDesc", 0
	'DlgVisible "pbBEFile", 0
'	DlgVisible "pbBEDesc", 0
	DlgVisible "pbUmsatzSmall", 1
	DlgVisible "pbUmsatz", 0
	DlgVisible "tUms", 0
	DlgVisible "tUmsBeschreibung", 0
	DlgVisible "tbPfadUms", 0
	DlgVisible "tbPfadUmsDesc", 0
	DlgVisible "pbUmsFile", 0
	DlgVisible "pbUmsDesc", 0

End Function

Function ShowHK()

	DlgVisible "pbGENSmall", 1
	DlgVisible "pbGEN", 0
	DlgVisible "tStichprobe", 0
	DlgVisible "tbStichprobe", 0
	DlgVisible "tNichtaufgriff", 0
	DlgVisible "tbNichtaufgriff", 0
	DlgVisible "tGJahr", 0
	DlgVisible "tbGJahr", 0
	DlgVisible "pbOBRSmall", 1
	DlgVisible "pbOBR", 0
	DlgVisible "tOBRKonten", 0
	DlgVisible "tOBRBeschreibung", 0
	DlgVisible "tbPfadOBR", 0
	DlgVisible "tbPfadOBRDesc", 0
	DlgVisible "pbOBRFile", 0
	DlgVisible "pbOBRDesc", 0
	DlgVisible "pbHKSmall", 0
	DlgVisible "pbHK", 1
	DlgVisible "tHKKonten", 1
	DlgVisible "tHKBeschreibung", 1
	DlgVisible "tbPfadHK", 1
	DlgVisible "tbPfadHKDesc", 1
	DlgVisible "pbHKFile", 1
	DlgVisible "pbHKDesc", 1
	DlgVisible "pbPOSSmall", 1
	DlgVisible "pbPOS", 0
	DlgVisible "tPos", 0
	DlgVisible "tPosBeschreibung", 0
	DlgVisible "tbPfadPos", 0
	DlgVisible "tbPfadPosDesc", 0
	DlgVisible "pbPosFile", 0
	DlgVisible "pbPosDesc", 0
	DlgVisible "pbPNSmall", 1
	DlgVisible "pbPN", 0
	DlgVisible "tPN", 0
	DlgVisible "tPNBeschreibung", 0
	DlgVisible "tbPfadPN", 0
	DlgVisible "tbPfadPNDesc", 0
	DlgVisible "pbPNFile", 0
	DlgVisible "pbPNDesc", 0
	'DlgVisible "pbBESmall", 1
	'DlgVisible "pbBE", 0
	DlgVisible "tBE", 0
	DlgVisible "tBEBeschreibung", 0
	DlgVisible "tbPfadBE", 0
'	DlgVisible "tbPfadBEDesc", 0
	'DlgVisible "pbBEFile", 0
'	DlgVisible "pbBEDesc", 0
	DlgVisible "pbUmsatzSmall", 1
	DlgVisible "pbUmsatz", 0
	DlgVisible "tUms", 0
	DlgVisible "tUmsBeschreibung", 0
	DlgVisible "tbPfadUms", 0
	DlgVisible "tbPfadUmsDesc", 0
	DlgVisible "pbUmsFile", 0
	DlgVisible "pbUmsDesc", 0

End Function

Function ShowPOS()

	DlgVisible "pbGENSmall", 1
	DlgVisible "pbGEN", 0
	DlgVisible "tStichprobe", 0
	DlgVisible "tbStichprobe", 0
	DlgVisible "tNichtaufgriff", 0
	DlgVisible "tbNichtaufgriff", 0
	DlgVisible "tGJahr", 0
	DlgVisible "tbGJahr", 0
	DlgVisible "pbOBRSmall", 1
	DlgVisible "pbOBR", 0
	DlgVisible "tOBRKonten", 0
	DlgVisible "tOBRBeschreibung", 0
	DlgVisible "tbPfadOBR", 0
	DlgVisible "tbPfadOBRDesc", 0
	DlgVisible "pbOBRFile", 0
	DlgVisible "pbOBRDesc", 0
	DlgVisible "pbHKSmall", 1
	DlgVisible "pbHK", 0
	DlgVisible "tHKKonten", 0
	DlgVisible "tHKBeschreibung", 0
	DlgVisible "tbPfadHK", 0
	DlgVisible "tbPfadHKDesc", 0
	DlgVisible "pbHKFile", 0
	DlgVisible "pbHKDesc", 0
	DlgVisible "pbPOSSmall", 0
	DlgVisible "pbPOS", 1
	DlgVisible "tPos", 1
	DlgVisible "tPosBeschreibung", 1
	DlgVisible "tbPfadPos", 1
	DlgVisible "tbPfadPosDesc", 1
	DlgVisible "pbPosFile", 1
	DlgVisible "pbPosDesc", 1
	DlgVisible "pbPNSmall", 1
	DlgVisible "pbPN", 0
	DlgVisible "tPN", 0
	DlgVisible "tPNBeschreibung", 0
	DlgVisible "tbPfadPN", 0
	DlgVisible "tbPfadPNDesc", 0
	DlgVisible "pbPNFile", 0
	DlgVisible "pbPNDesc", 0
	'DlgVisible "pbBESmall", 1
	'DlgVisible "pbBE", 0
	DlgVisible "tBE", 0
	DlgVisible "tBEBeschreibung", 0
	DlgVisible "tbPfadBE", 0
'	DlgVisible "tbPfadBEDesc", 0
	'DlgVisible "pbBEFile", 0
'	DlgVisible "pbBEDesc", 0
	DlgVisible "pbUmsatzSmall", 1
	DlgVisible "pbUmsatz", 0
	DlgVisible "tUms", 0
	DlgVisible "tUmsBeschreibung", 0
	DlgVisible "tbPfadUms", 0
	DlgVisible "tbPfadUmsDesc", 0
	DlgVisible "pbUmsFile", 0
	DlgVisible "pbUmsDesc", 0

End Function

Function ShowPN()

	DlgVisible "pbGENSmall", 1
	DlgVisible "pbGEN", 0
	DlgVisible "tStichprobe", 0
	DlgVisible "tbStichprobe", 0
	DlgVisible "tNichtaufgriff", 0
	DlgVisible "tbNichtaufgriff", 0
	DlgVisible "tGJahr", 0
	DlgVisible "tbGJahr", 0
	DlgVisible "pbOBRSmall", 1
	DlgVisible "pbOBR", 0
	DlgVisible "tOBRKonten", 0
	DlgVisible "tOBRBeschreibung", 0
	DlgVisible "tbPfadOBR", 0
	DlgVisible "tbPfadOBRDesc", 0
	DlgVisible "pbOBRFile", 0
	DlgVisible "pbOBRDesc", 0
	DlgVisible "pbHKSmall", 1
	DlgVisible "pbHK", 0
	DlgVisible "tHKKonten", 0
	DlgVisible "tHKBeschreibung", 0
	DlgVisible "tbPfadHK", 0
	DlgVisible "tbPfadHKDesc", 0
	DlgVisible "pbHKFile", 0
	DlgVisible "pbHKDesc", 0
	DlgVisible "pbPOSSmall", 1
	DlgVisible "pbPOS", 0
	DlgVisible "tPos", 0
	DlgVisible "tPosBeschreibung", 0
	DlgVisible "tbPfadPos", 0
	DlgVisible "tbPfadPosDesc", 0
	DlgVisible "pbPosFile", 0
	DlgVisible "pbPosDesc", 0
	DlgVisible "pbPNSmall", 0
	DlgVisible "pbPN", 1
	DlgVisible "tPN", 1
	DlgVisible "tPNBeschreibung", 1
	DlgVisible "tbPfadPN", 1
	DlgVisible "tbPfadPNDesc", 1
	DlgVisible "pbPNFile", 1
	DlgVisible "pbPNDesc", 1
	'DlgVisible "pbBESmall", 1
	'DlgVisible "pbBE", 0
	DlgVisible "tBE", 0
	DlgVisible "tBEBeschreibung", 0
	DlgVisible "tbPfadBE", 0
'	DlgVisible "tbPfadBEDesc", 0
	'DlgVisible "pbBEFile", 0
'	DlgVisible "pbBEDesc", 0
	DlgVisible "pbUmsatzSmall", 1
	DlgVisible "pbUmsatz", 0
	DlgVisible "tUms", 0
	DlgVisible "tUmsBeschreibung", 0
	DlgVisible "tbPfadUms", 0
	DlgVisible "tbPfadUmsDesc", 0
	DlgVisible "pbUmsFile", 0
	DlgVisible "pbUmsDesc", 0

End Function

Function ShowBE()

	DlgVisible "pbGENSmall", 1
	DlgVisible "pbGEN", 0
	DlgVisible "tStichprobe", 0
	DlgVisible "tbStichprobe", 0
	DlgVisible "tNichtaufgriff", 0
	DlgVisible "tbNichtaufgriff", 0
	DlgVisible "tGJahr", 0
	DlgVisible "tbGJahr", 0
	DlgVisible "pbOBRSmall", 1
	DlgVisible "pbOBR", 0
	DlgVisible "tOBRKonten", 0
	DlgVisible "tOBRBeschreibung", 0
	DlgVisible "tbPfadOBR", 0
	DlgVisible "tbPfadOBRDesc", 0
	DlgVisible "pbOBRFile", 0
	DlgVisible "pbOBRDesc", 0
	DlgVisible "pbHKSmall", 1
	DlgVisible "pbHK", 0
	DlgVisible "tHKKonten", 0
	DlgVisible "tHKBeschreibung", 0
	DlgVisible "tbPfadHK", 0
	DlgVisible "tbPfadHKDesc", 0
	DlgVisible "pbHKFile", 0
	DlgVisible "pbHKDesc", 0
	DlgVisible "pbPOSSmall", 1
	DlgVisible "pbPOS", 0
	DlgVisible "tPos", 0
	DlgVisible "tPosBeschreibung", 0
	DlgVisible "tbPfadPos", 0
	DlgVisible "tbPfadPosDesc", 0
	DlgVisible "pbPosFile", 0
	DlgVisible "pbPosDesc", 0
	DlgVisible "pbPNSmall", 1
	DlgVisible "pbPN", 0
	DlgVisible "tPN", 0
	DlgVisible "tPNBeschreibung", 0
	DlgVisible "tbPfadPN", 0
	DlgVisible "tbPfadPNDesc", 0
	DlgVisible "pbPNFile", 0
	DlgVisible "pbPNDesc", 0
	'DlgVisible "pbBESmall", 0
	'DlgVisible "pbBE", 1
	DlgVisible "tBE", 1
	DlgVisible "tBEBeschreibung", 1
	DlgVisible "tbPfadBE", 1
'	DlgVisible "tbPfadBEDesc", 1
	'DlgVisible "pbBEFile", 1
'	DlgVisible "pbBEDesc", 1
	DlgVisible "pbUmsatzSmall", 1
	DlgVisible "pbUmsatz", 0
	DlgVisible "tUms", 0
	DlgVisible "tUmsBeschreibung", 0
	DlgVisible "tbPfadUms", 0
	DlgVisible "tbPfadUmsDesc", 0
	DlgVisible "pbUmsFile", 0
	DlgVisible "pbUmsDesc", 0

End Function

Function ShowUmsatz()

	DlgVisible "pbGENSmall", 1
	DlgVisible "pbGEN", 0
	DlgVisible "tStichprobe", 0
	DlgVisible "tbStichprobe", 0
	DlgVisible "tNichtaufgriff", 0
	DlgVisible "tbNichtaufgriff", 0
	DlgVisible "tGJahr", 0
	DlgVisible "tbGJahr", 0
	DlgVisible "pbOBRSmall", 1
	DlgVisible "pbOBR", 0
	DlgVisible "tOBRKonten", 0
	DlgVisible "tOBRBeschreibung", 0
	DlgVisible "tbPfadOBR", 0
	DlgVisible "tbPfadOBRDesc", 0
	DlgVisible "pbOBRFile", 0
	DlgVisible "pbOBRDesc", 0
	DlgVisible "pbHKSmall", 1
	DlgVisible "pbHK", 0
	DlgVisible "tHKKonten", 0
	DlgVisible "tHKBeschreibung", 0
	DlgVisible "tbPfadHK", 0
	DlgVisible "tbPfadHKDesc", 0
	DlgVisible "pbHKFile", 0
	DlgVisible "pbHKDesc", 0
	DlgVisible "pbPOSSmall", 1
	DlgVisible "pbPOS", 0
	DlgVisible "tPos", 0
	DlgVisible "tPosBeschreibung", 0
	DlgVisible "tbPfadPos", 0
	DlgVisible "tbPfadPosDesc", 0
	DlgVisible "pbPosFile", 0
	DlgVisible "pbPosDesc", 0
	DlgVisible "pbPNSmall", 1
	DlgVisible "pbPN", 0
	DlgVisible "tPN", 0
	DlgVisible "tPNBeschreibung", 0
	DlgVisible "tbPfadPN", 0
	DlgVisible "tbPfadPNDesc", 0
	DlgVisible "pbPNFile", 0
	DlgVisible "pbPNDesc", 0
	'DlgVisible "pbBESmall", 1
	'DlgVisible "pbBE", 0
	DlgVisible "tBE", 0
	DlgVisible "tBEBeschreibung", 0
	DlgVisible "tbPfadBE", 0
'	DlgVisible "tbPfadBEDesc", 0
	'DlgVisible "pbBEFile", 0
'	DlgVisible "pbBEDesc", 0
	DlgVisible "pbUmsatzSmall", 0
	DlgVisible "pbUmsatz", 1
	DlgVisible "tUms", 1
	DlgVisible "tUmsBeschreibung", 1
	DlgVisible "tbPfadUms", 1
	DlgVisible "tbPfadUmsDesc", 1
	DlgVisible "pbUmsFile", 1
	DlgVisible "pbUmsDesc", 1

End Function


Function ShowGeneralSimply()

	DlgVisible "pbGENSmall", 0
	DlgVisible "pbGEN", 1
	DlgVisible "tStichprobe", 0
	DlgVisible "tbStichprobe", 0
	DlgVisible "tNichtaufgriff", 1
	DlgVisible "tbNichtaufgriff", 1
	DlgVisible "tGJahr", 1
	DlgVisible "tbGJahr", 1
	DlgVisible "pbOBRSmall", 1
	DlgVisible "pbOBR", 0
	DlgVisible "tOBRKonten", 0
	DlgVisible "tOBRBeschreibung", 0
	DlgVisible "tbPfadOBR", 0
	DlgVisible "tbPfadOBRDesc", 0
	DlgVisible "pbOBRFile", 0
	DlgVisible "pbOBRDesc", 0
	DlgVisible "pbHKSmall", 0
	DlgVisible "pbHK", 0
	DlgVisible "tHKKonten", 0
	DlgVisible "tHKBeschreibung", 0
	DlgVisible "tbPfadHK", 0
	DlgVisible "tbPfadHKDesc", 0
	DlgVisible "pbHKFile", 0
	DlgVisible "pbHKDesc", 0
	DlgVisible "pbPOSSmall", 0
	DlgVisible "pbPOS", 0
	DlgVisible "tPos", 0
	DlgVisible "tPosBeschreibung", 0
	DlgVisible "tbPfadPos", 0
	DlgVisible "tbPfadPosDesc", 0
	DlgVisible "pbPosFile", 0
	DlgVisible "pbPosDesc", 0
	DlgVisible "pbPNSmall", 0
	DlgVisible "pbPN", 0
	DlgVisible "tPN", 0
	DlgVisible "tPNBeschreibung", 0
	DlgVisible "tbPfadPN", 0
	DlgVisible "tbPfadPNDesc", 0
	DlgVisible "pbPNFile", 0
	DlgVisible "pbPNDesc", 0
	'DlgVisible "pbBESmall", 0
	'DlgVisible "pbBE", 0
	DlgVisible "tBE", 0
	DlgVisible "tBEBeschreibung", 0
	DlgVisible "tbPfadBE", 0
'	DlgVisible "tbPfadBEDesc", 0
	'DlgVisible "pbBEFile", 0
'	DlgVisible "pbBEDesc", 0
	DlgVisible "pbUmsatzSmall", 1
	DlgVisible "pbUmsatz", 0
	DlgVisible "tUms", 0
	DlgVisible "tUmsBeschreibung", 0
	DlgVisible "tbPfadUms", 0
	DlgVisible "tbPfadUmsDesc", 0
	DlgVisible "pbUmsFile", 0
	DlgVisible "pbUmsDesc", 0

End Function

Function ShowOBRSimply()

	DlgVisible "pbGENSmall", 1
	DlgVisible "pbGEN", 0
	DlgVisible "tStichprobe", 0
	DlgVisible "tbStichprobe", 0
	DlgVisible "tNichtaufgriff", 0
	DlgVisible "tbNichtaufgriff", 0
	DlgVisible "tGJahr", 0
	DlgVisible "tbGJahr", 0
	DlgVisible "pbOBRSmall", 0
	DlgVisible "pbOBR", 1
	DlgVisible "tOBRKonten", 1
	DlgVisible "tOBRBeschreibung", 0 'md v103
	DlgVisible "tbPfadOBR", 1
	DlgVisible "tbPfadOBRDesc", 0 'md v103
	DlgVisible "pbOBRFile", 1
	DlgVisible "pbOBRDesc", 0 'md v103
	DlgVisible "pbHKSmall", 0
	DlgVisible "pbHK", 0
	DlgVisible "tHKKonten", 0
	DlgVisible "tHKBeschreibung", 0
	DlgVisible "tbPfadHK", 0
	DlgVisible "tbPfadHKDesc", 0
	DlgVisible "pbHKFile", 0
	DlgVisible "pbHKDesc", 0
	DlgVisible "pbPOSSmall", 0
	DlgVisible "pbPOS", 0
	DlgVisible "tPos", 0
	DlgVisible "tPosBeschreibung", 0
	DlgVisible "tbPfadPos", 0
	DlgVisible "tbPfadPosDesc", 0
	DlgVisible "pbPosFile", 0
	DlgVisible "pbPosDesc", 0
	DlgVisible "pbPNSmall", 0
	DlgVisible "pbPN", 0
	DlgVisible "tPN", 0
	DlgVisible "tPNBeschreibung", 0
	DlgVisible "tbPfadPN", 0
	DlgVisible "tbPfadPNDesc", 0
	DlgVisible "pbPNFile", 0
	DlgVisible "pbPNDesc", 0
	'DlgVisible "pbBESmall", 0
	'DlgVisible "pbBE", 0
	DlgVisible "tBE", 0
	DlgVisible "tBEBeschreibung", 0
	DlgVisible "tbPfadBE", 0
'	DlgVisible "tbPfadBEDesc", 0
	'DlgVisible "pbBEFile", 0
'	DlgVisible "pbBEDesc", 0
	DlgVisible "pbUmsatzSmall", 1
	DlgVisible "pbUmsatz", 0
	DlgVisible "tUms", 0
	DlgVisible "tUmsBeschreibung", 0
	DlgVisible "tbPfadUms", 0
	DlgVisible "tbPfadUmsDesc", 0
	DlgVisible "pbUmsFile", 0
	DlgVisible "pbUmsDesc", 0

End Function

Function ShowUmsatzSimply()

	DlgVisible "pbGENSmall", 1
	DlgVisible "pbGEN", 0
	DlgVisible "tStichprobe", 0
	DlgVisible "tbStichprobe", 0
	DlgVisible "tNichtaufgriff", 0
	DlgVisible "tbNichtaufgriff", 0
	DlgVisible "tGJahr", 0
	DlgVisible "tbGJahr", 0
	DlgVisible "pbOBRSmall", 1
	DlgVisible "pbOBR", 0
	DlgVisible "tOBRKonten", 0
	DlgVisible "tOBRBeschreibung", 0
	DlgVisible "tbPfadOBR", 0
	DlgVisible "tbPfadOBRDesc", 0
	DlgVisible "pbOBRFile", 0
	DlgVisible "pbOBRDesc", 0
	DlgVisible "pbHKSmall", 0
	DlgVisible "pbHK", 0
	DlgVisible "tHKKonten", 0
	DlgVisible "tHKBeschreibung", 0
	DlgVisible "tbPfadHK", 0
	DlgVisible "tbPfadHKDesc", 0
	DlgVisible "pbHKFile", 0
	DlgVisible "pbHKDesc", 0
	DlgVisible "pbPOSSmall", 0
	DlgVisible "pbPOS", 0
	DlgVisible "tPos", 0
	DlgVisible "tPosBeschreibung", 0
	DlgVisible "tbPfadPos", 0
	DlgVisible "tbPfadPosDesc", 0
	DlgVisible "pbPosFile", 0
	DlgVisible "pbPosDesc", 0
	DlgVisible "pbPNSmall", 0
	DlgVisible "pbPN", 0
	DlgVisible "tPN", 0
	DlgVisible "tPNBeschreibung", 0
	DlgVisible "tbPfadPN", 0
	DlgVisible "tbPfadPNDesc", 0
	DlgVisible "pbPNFile", 0
	DlgVisible "pbPNDesc", 0
	'DlgVisible "pbBESmall", 0
	'DlgVisible "pbBE", 0
	DlgVisible "tBE", 0
	DlgVisible "tBEBeschreibung", 0
	DlgVisible "tbPfadBE", 0
'	DlgVisible "tbPfadBEDesc", 0
	'DlgVisible "pbBEFile", 0
'	DlgVisible "pbBEDesc", 0
	DlgVisible "pbUmsatzSmall", 0
	DlgVisible "pbUmsatz", 1
	DlgVisible "tUms", 1
	DlgVisible "tUmsBeschreibung", 0 'md v103
	DlgVisible "tbPfadUms", 1
	DlgVisible "tbPfadUmsDesc", 0 'md v103
	DlgVisible "pbUmsFile", 1
	DlgVisible "pbUmsDesc", 0 ''md v103

End Function

Private Sub CancelButton1_Click()
  End
End Sub

Function DialogFunction(ControlID$, Action%, SuppValue%)

' Local Variables
Dim iSumme As Integer
'oLog.Message("Action:" & Action & "Control:" & ControlID & "SupeValue" & SuppValue)

' Bestimmt, welche Aktion ausgeführt werden soll.
	Select Case Action% 
	
' Ein Action-Wert von 1 ist die Standardaktion.
' Action 1 - The value passed before the dialog becomes visible
	
		Case 1
' Gibt dem Textfeld Name einen Standardwert.
			DlgText "tbStichprobe", "25"
			
			DlgText "tbNichtaufgriff", dlgImport.tbNichtaufgriff '"5000" 'tbNichtaufgriff
			DlgText "tbPfadOBR", sPfadOBR
			DlgText "tbPfadOBRDesc", sPfadOBRDesc
			DlgText "tbPfadHK", sPfadHK
			DlgText "tbPfadHKDesc", sPfadHKDesc
			DlgText "tbPfadPOS", sPfadPOS
			DlgText "tbPfadPOSDesc", sPfadPOSDesc
			DlgText "tbPfadPN", sPfadPN
			DlgText "tbPfadPNDesc", sPfadPNDesc
			'DlgText "tbPfadBE", sPfadBE
			'DlgText "tbPfadBEDesc", sPfadBEDesc
			DlgText "tbPfadUms", sPfadUmsatz
			DlgText "tbPfadUmsDesc", sPfadUmsatzDesc
			DlgValue "cbExpertModus", 1
			
'			DlgValue "cbDeleteTemp", iParaDelTemp
'			DlgValue "cbReadControlTab", iParaReadControlTab

' Ein Aktionswert von 2 ist der Klick auf eine Schaltfläche.
' Action 2 - The value passed when an action is taken ( i.e. a button is pushed, checkbox is checked etc...)  
' The controlID$ is the same As the identifier For the control that was chosen
		
		Case 2 
		
' Der Anwender klickt entweder OK oder Cancel,
' um die Dialogbox zu schließen.
			DialogFunction = 0

' Action 3 - Corresponds To a change In a text box Or combo box.  This value is passed when a control loses the focus (For example, 
' when the user presses the TAB key To move To a different control) Or after the user clicks an item In the list of a combo box (an Action value of 2 is passed first).  
' Note that If the contents of the text box Or combo box Do Not change, an Action value of 3 is Not passed.  
' When Action is 3, ControlID$ corresponds To the identifier For the text box Or combo box whose contents were changed.
' Ein Aktionswert von 3 ist der 

		Case 3 
			' ExpertenModus
			If userMode = 1 Then 
				Call ShowGeneral()	

				If sSelect = "pbGENSmall" Or sSelect = "pbGEN" Then				
					Call ShowGeneral()
				ElseIf sSelect = "pbOBRSmall" Or sSelect = "pbOBR" Then
					Call ShowOBR()
				ElseIf sSelect = "pbHKSmall" Or sSelect = "pbHK" Then
					Call ShowHK()
				ElseIf sSelect = "pbPosSmall" Or sSelect = "pbPos" Then
					Call ShowPOS()
				ElseIf sSelect = "pbPNSmall" Or sSelect = "pbPN" Then
					Call ShowPN()
				ElseIf sSelect = "pbHKSmall" Or sSelect = "pbHK" Then
					Call ShowHK()
				'ElseIf sSelect = "pbBESmall" Or sSelect = "pbBE" Then
				'	Call ShowBE()
				ElseIf sSelect = "pbUmsatzSmall" Or sSelect = "pbUmsatz" Then
					Call ShowUmsatz()

 				End If
						
			Else 
			' Easy Modus - Standard 

				Call ShowGeneralSimply()
				If sSelect = "pbOBRSmall" Or sSelect = "pbOBR" Then				
					Call ShowOBRSimply()
				ElseIf sSelect = "pbOBRSmall" Or sSelect = "pbOBR" Then
					Call ShowOBRSimply()
				ElseIf sSelect = "pbUmsatzSmall" Or sSelect = "pbUmsatz" Then
					Call ShowUmsatzSimply()
				End If 
				
			End If 
				
	End Select
	
	' ExpertenModus
	If userMode = 0 Then 
		Select Case ControlID$
		Case "pbGEN"
			sSelect = "pbGEN"
			Call ShowGeneralSimply()
		Case "pbGENSmall"
			sSelect = "pbGENSmall"
			Call ShowGeneralSimply()
		Case "pbOBR"
			sSelect = "pbOBR"
			Call ShowOBRSimply()
		Case "pbOBRSmall"
			sSelect = "pbOBR"
			Call ShowOBRSimply()
		Case "pbUmsatz"
			sSelect = "pbUmsatz"
			Call ShowUmsatzSimply()			
		Case "pbUmsatzSmall"
			sSelect = "pbUmsatz"
			Call ShowUmsatzSimply()
		End Select
	ElseIf userMode = 1 Then
	
		Select Case ControlID$
		Case "pbGEN"
			sSelect = "pbGEN"
			Call ShowGeneral()
		Case "pbGENSmall"
			sSelect = "pbGENSmall"
			Call ShowGeneral()
		Case "pbOBR"
			sSelect = "pbOBR"
			Call ShowOBR()
		Case "pbOBRSmall"
			sSelect = "pbOBR"			
			Call ShowOBR()
		Case "pbHK"
			sSelect = "pbHK"
			Call ShowHK()			
		Case "pbHKSmall"
			sSelect = "pbHK"
			Call ShowHK()			
		Case "pbPOS" 
			sSelect = "pbPOS"
			Call ShowPOS()			
		Case "pbPOSSmall"
			sSelect = "pbPOS"
			Call ShowPOS()
		Case "pbPN"
			sSelect = "pbPNx"
			Call ShowPN()			
		Case "pbPNSmall"
			sSelect = "pbPNx"
			Call ShowPN()	
		'Case "pbBE"
		'	sSelect = "pbBE"
		'	Call ShowBE()	
		'Case "pbBESmall"
		'	sSelect = "pbBE"
		'	Call ShowBE()	
		Case "pbUmsatz"
			sSelect = "pbUmsatz"
			Call ShowUmsatz()			
		Case "pbUmsatzSmall"
			sSelect = "pbUmsatz"
			Call ShowUmsatz()

		End Select
	End If
		

End Function

Function PowerUser
	DlgText "tStatusText", "PowerButton"
End Function


Function ImportFilesForStandardUser	
  'Dim fso
  'Set fso = CreateObject("Scripting.FileSystemObject")
  'Dim sPath As String 
  
  'sPath = fso.GetParentFolderName(sPfadOBRDesc) & "\" 
  'MsgBox fso.GetParentFolderName(sPfadOBRDesc)

	' Import Umsätze-File
	Call ImportUmsaetze(sParaGJahr, sPfadUmsatz, sPfadUmsatzDesc, sEquation) 'AS 06.10.2020: import Umsätze as first Action
	If SmartContext.ExecutionStatus = EXEC_STATUS_CANCELED Then Exit Sub
	
	' Import Betriebsvergleichsschluessel
	Call ImportBetriebsvergleichsschluessel(sPfadBE, sPfadBEDesc)
	
	' Import OBR-Files
	Call ImportOBR(sParaGJahr, sPfadOBR, sPfadOBRDesc, sEquation) ' 28.04.2020 AS: added sEquation
	' MsgBox sParaGJahr & " " & sPfadOBR & " " & sPfadOBRDesc 
	
	' Import HK-File
	' Call ImportHK(sParaGJahr, sPath & sPfadHK, sPath & sPfadHKDesc)
	Call ImportHK(sParaGJahr, sPfadHK, sPfadHKDesc)
	
	' Import Positionsschlüssel-File
	' Call ImportPos(sParaGJahr, sPath & sPfadPOS, sPath & sPfadPOSDesc)
	Call ImportPos(sParaGJahr, sPfadPOS, sPfadPOSDesc)
		
	' Import Primanotenplan-File
	' Call ImportPN(sParaGJahr,sPath & sPfadPN, sPath & sPfadPNDesc)
	Call ImportPN(sParaGJahr, sPfadPN, sPfadPNDesc)

	' Wird nicht mehr benötigt
	' Import Betriebsergebnis-File
	' Call ImportBE(sParaGJahr, sPfadBE, sPfadBEDesc)
	
	' Import Umsätze-File
	'Call ImportUmsaetze(sParaGJahr, sPfadUmsatz, sPfadUmsatzDesc, sEquation) ' 28.04.2020 AS: added sEquation
	
' Create Variable-Table
' Call WriteNewConfig
	Call CreateVariable(sParaGJahr, sParaStichprobe, sParaNAGrenze) ', sParaHK
	
End Function
	
Function ImportFiles
' Import Umsätze-File
	Call ImportUmsaetze(sParaGJahr, sPfadUmsatz, sPfadUmsatzDesc, sEquation) 'AS 06.10.2020: import Umsätze as first Action
	If SmartContext.ExecutionStatus = EXEC_STATUS_CANCELED Then Exit Sub
	
' Import Betriebsvergleichsschluessel
	Call ImportBetriebsvergleichsschluessel(sPfadBE, sPfadBEDesc)
' Import OBR-Files
	Call ImportOBR(sParaGJahr, sPfadOBR, sPfadOBRDesc, sEquation) ' 28.04.2020 AS: added sEquation
' Import HK-File
	Call ImportHK(sParaGJahr, sPfadHK, sPfadHKDesc)
' Import Positionsschlüssel-File
	Call ImportPos(sParaGJahr, sPfadPOS, sPfadPOSDesc)
' Import Primanotenplan-File
	Call ImportPN(sParaGJahr, sPfadPN, sPfadPNDesc)
' Import Betriebsergebnis-File
	' Call ImportBE(sParaGJahr, sPfadBE, sPfadBEDesc)
' Import Umsätze-File
	'Call ImportUmsaetze(sParaGJahr, sPfadUmsatz, sPfadUmsatzDesc, sEquation) ' 28.04.2020 AS: added sEquation
' Create Variable-Table
	Call CreateVariable(sParaGJahr, sParaStichprobe, sParaNAGrenze)

End Function

Function CreateVariable(ByVal sParaGJahr As String, sParaStichprobe As String, sParaNAGrenze As String)
Dim sGJahr As String
Dim lStichprobe As Integer
Dim dNAGrenze As Double
Dim NewTable As Object
Dim AddedField As Object
Dim rs As Object
Dim rec As Object

	sGJahr = sParaGJahr
	'Ab Version 1.04 keine Stichprobe
	'lStichprobe = CInt(sParaStichprobe)
	dNAGrenze = CDbl(sParaNAGrenze)
	
	sVariable = "{Variables}.IMD"

	Set NewTable = Client.NewTableDef
	Set AddedField = NewTable.NewField
	
	AddedField.Name = "GJAHR"
	AddedField.Type = WI_CHAR_FIELD
	AddedField.Length = 4
	NewTable.AppendField AddedField
	
	AddedField.Name = "STICHPROBE"
	AddedField.Type = WI_NUM_FIELD
	AddedField.Decimals = 0
	NewTable.AppendField AddedField
	
	AddedField.Name = "NAGRENZE"
	AddedField.Type = WI_NUM_FIELD
	AddedField.Decimals = 2
	
	'AddedField.Name = "HK_CSV_File"
	'AddedField.Type = WI_CHAR_FIELD
	'AddedField.Length = 400
	
	'AddedField.Name = "HK_RDF_File"
	'AddedField.Type = WI_CHAR_FIELD
	'AddedField.Length = 400
	
	NewTable.AppendField AddedField
	NewTable.Protect = False
	Set db = Client.NewDatabase(sVariable, "", NewTable)
	Set rs = db.RecordSet
	rs.AddKey "GJAHR", "A"
	Set rec = rs.NewRecord
	rec.SetCharValue "GJAHR", sGJahr
	rec.SetNumValue "STICHPROBE", lStichprobe
	rec.SetNumValue "NAGRENZE", dNAGrenze
	'rec.SetNumValue "HK_CSV_File", dNAGrenze
	'rec.SetNumValue "HK_RDF_File", dNAGrenze
	rs.AppendRecord rec
	NewTable.Protect = True
	db.CommitDatabase
	
	Set db = Client.OpenDatabase(sVariable)
	db.Close
	Set db = Nothing
	Set AddedField = Nothing
	Set NewTable = Nothing
	Set rec = Nothing
	Set rs = Nothing

End Function

Function ImportTable(ByVal sTableName As String, ByVal sFilePath As String, ByVal sDescPath As String, ByVal sFilter As String)	' 28.04.2020 AS: added sFilter
' Lokale Variablen
Dim sImportFile As String
Dim sDefinitionFile As String
Dim dbImportName As String
Dim sFilterEQN As String	' 28.04.2020 AS
Dim sFilterTEMP As String

	sImportFile = sFilePath
	sDefinitionFile = sDescPath
	dbImportName = sTableName
	
	sFilterTEMP = iReplace(sFilter,"KONTO_NR","KONTO")
	sFilterEQN = iReplace(sFilterTEMP,"KTO_RAHMEN","RAHMENNR")
	
	oLog.LogMessage "ImportTable-Name: " & sTableName
	oLog.LogMessage "ImportTable-File Path: " & sFilePath 
	oLog.LogMessage "ImportTable-Descrition Path: " & sDescPath 
	 
	Client.ImportDelimFile sImportFile, dbImportName, False, sFilterEQN, sDefinitionFile, True	' 13.07.2020 AS
	Set db = Client.OpenDatabase(dbImportName)
	
	oLog.LogMessage "End of ImportTable"
	
	db.Close
	Set db = Nothing

	
	
End Function

Function ImportOBR(ByVal sJahr As String, ByVal sFilePath As String, ByVal sDescPath As String, ByVal sFilter As String)	' 28.04.2020 AS: added sFilter

	oLog.LogMessage "Begin Import OBR"
	dbImportOBRTemp = "{OBR_Konten_Temp_" & sJahr & "}.IMD"
	dbImportOBR = "{OBR_Konten_" & sJahr & "}.IMD"
	dbImportBVS = "{BVS_Gesamt}.IMD"
	Call ImportTable(dbImportOBRTemp, sFilePath, sDescPath, sFilter)	' 28.04.2020 AS: added sFilter
	Call AddFieldOBR(dbImportOBRTemp)
	Call JoinOBR2BVS(dbImportOBRTemp, dbImportBVS, dbImportOBR)
	oLog.LogMessage "End Import OBR"
		
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

Function ImportHK(ByVal sJahr As String, ByVal sFilePath As String, ByVal sDescPath As String)
	
	oLog.LogMessage "Begin Import HK"
	dbImportHK = "{HK_Konten_" & sJahr & "}.IMD"
	Call ImportTable(dbImportHK, sFilePath, sDescPath, "")	' 28.04.2020 AS: added "" for empty filter
	oLog.LogMessage "End Import HK"
	
End Function

Function ImportPos(ByVal sJahr As String, ByVal sFilePath As String, ByVal sDescPath As String)
	
	oLog.LogMessage "Begin Import Positionsschlüssel"
	dbImportPos = "{Positionsschluessel_" & sJahr & "}.IMD"
	Call ImportTable(dbImportPos, sFilePath, sDescPath, "")	' 28.04.2020 AS: added "" for empty filter
	oLog.LogMessage "End Import Positionsschlüssel"
	
End Function

Function ImportPN(ByVal sJahr As String, ByVal sFilePath As String, ByVal sDescPath As String)
' Lokale Variablen
Dim dbImportName As String
Dim sPfadPNAE As String
Dim sFileName As String
Dim sVersionNr As String

	sVersionNr = "0"
	' v103 -Neue Anfroderung. Name mit VesionNr
	sFileName =  iSplit(sFilePath,".","\",1,1)
	sVersionNr =  iSplit(sFileName,"","_",1,2)

	oLog.LogMessage "Begin Import Primanotenplan"
	' v102
	' dbImportPN = "{Primanotenplan_" & sJahr & "}.IMD"
	' v103
	dbImportPN = "{Primanotenplan_" & sJahr & "_" &sVersionNr &"}.IMD"
	
	Call ImportTable(dbImportPN, sFilePath, sDescPath, "")	' 28.04.2020 AS: added "" for empty filter
	
	If Not (PNAE = "") Then
		Call ModifyPN()
	Else
		sPfadPNAE = Client.WorkingDirectory & "{Änderungen des Primanotenplans}.IMD"
		If FileExists(sPfadPNAE) then
			Kill sPfadPNAE
			Client.RefreshFileExplorer
		End If
	End If

	oLog.LogMessage "End Import Primanotenplan"

End Function
	
Function ModifyPN()
	Dim sdbTemp1 As String
	Dim sdbTemp2 As String
	Dim sTempDB2Delete As String
	Dim iNumberofRows As Integer
	Dim CounterLoop As Integer
	Dim cnt As Integer
	Dim sEachRow As String
	Dim sPNAEContainer As String
	
	dbPNAENameTemp1 = "{Änderungen des Primanotenplans_Temp}.IMD"
	dbPNAEName = "{Änderungen des Primanotenplans}.IMD"
	
	oCDB.FieldDelimiter = "|"
	oCDB.RecordDelimiter = "µ"
	
	oCDB.AddDatabase dbPNAENameTemp1, "Änderungen des Primanotenplans_Temp"
	oCDB.AddField "PN_NR", "", WI_CHAR_FIELD, 8, 0
	oCDB.AddField "BEZEICHNUNG", "", WI_CHAR_FIELD, 146, 0
	oCDB.AddField "MANUELLE_BUCHUNGEN", "", WI_CHAR_FIELD, 1, 0
	oCDB.AddField "AENDERUNG_RELEASE", "", WI_CHAR_FIELD, 21, 0
	oCDB.AppendValues PNAE
	oCDB.PerformTask
	Set oCDB = Nothing
	
	Set db = Client.OpenDatabase(dbPNAENameTemp1)
	Set task = db.JoinDatabase
	task.FileToJoin dbImportPN
	task.IncludeAllPFields
	task.AddMatchKey "PN_NR", "PN_NR", "A"
	task.AddMatchKey "BEZEICHNUNG", "BEZEICHNUNG", "A"
	task.AddMatchKey "MANUELLE_BUCHUNGEN", "MANUELLE_BUCHUNGEN", "A"
	task.PerformTask dbPNAEName, "", WI_JOIN_NOC_SEC_MATCH
	db.Close
	Set task = Nothing
	Set db = Nothing

	
	Set db = Client.OpenDatabase(dbImportPN)
	Set task = db.AppendDatabase
	task.AddDatabase dbPNAEName
	sdbTemp1 = "Temp_PN_Added.IMD"
	task.PerformTask sdbTemp1, ""
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	Set db = Client.OpenDatabase(sdbTemp1)
	Set task = db.Summarization
	task.AddFieldToSummarize "PN_NR"
	task.IncludeAllFields
	sdbTemp2 = "Temp_PN_Merged.IMD"
	task.OutputDBName = sdbTemp2
	task.CreatePercentField = FALSE
	task.UseFieldFromFirstOccurrence = FALSE
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	Set db = Client.OpenDatabase(sdbTemp2)
	Set task = db.Extraction
	task.AddFieldToInc "PN_NR"
	task.AddFieldToInc "BEZEICHNUNG"
	task.AddFieldToInc "MANUELLE_BUCHUNGEN"
	task.AddFieldToInc "AENDERUNG_RELEASE"
	task.AddExtraction dbImportPN, "", ""
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	sTempDB2Delete = Client.WorkingDirectory & sdbTemp1
	Kill sTempDB2Delete
	sTempDB2Delete = Client.WorkingDirectory & sdbTemp2
	Kill sTempDB2Delete
	sTempDB2Delete = Client.WorkingDirectory & dbPNAENameTemp1
	Kill sTempDB2Delete
	
	Client.RefreshFileExplorer
	
	
	Set db = Client.OpenDatabase(dbPNAEName)
	iNumberofRows = db.count
	db.Close
	Set db = Nothing
	
	Set oCDB = oMC.CreateDatabase
	oCDB.Open(dbPNAEName)	
	sPNAEContainer = ""
	
	For CounterLoop = 1 To iNumberofRows
		sEachRow = oCDB.ReadLine(CounterLoop)
		sEachRow = iReplace(sEachRow,";","|")
		If (CounterLoop = 1) Then
			sPNAEContainer =  sEachRow
		Else
			sPNAEContainer = sPNAEContainer & "µ" & sEachRow
		End If

	Next
	'Close the database. 
	oCDB.Close 
	'Release objects. 
	Set oCDB = Nothing
	
	'oLog.LogMessage "What given as PNAE: " & PNAE
	oLog.LogMessage "What PNAE actually is : " & sPNAEContainer
	
	oPara.Set4Project "ac.global.PNAE", sPNAEContainer
	
	Client.RefreshFileExplorer

End Function

Function ImportBE(ByVal sJahr As String, ByVal sFilePath As String, ByVal sDescPath As String)
	
	oLog.LogMessage "Begin Import Betriebsergebnis"
	dbImportBE = "{Betriebsergebnis_" & sJahr & "}.IMD"
	Call ImportTable(dbImportBE, sFilePath, sDescPath, "")	' 28.04.2020 AS: added "" for empty filter
	oLog.LogMessage "End Import Betriebsergebnis"
	
End Function

Function ImportUmsaetze(ByVal sJahr As String, ByVal sQuellverzeichnis As String, ByVal sDescPath As String, ByVal sFilter As String)	' 28.04.2020 AS: added sFilter
' Lokale Variablen
Dim sImportFile As String
Dim sImport As String
Dim sDefinitionFile As String
Dim sFile As String
Dim sMessage As String
Dim iCounter As Integer	' Max 12 - Je Monat eine Datei
Dim iCount As Integer

	oLog.LogMessage "Begin Import Umsätze"
	sImportFile = Dir(sQuellverzeichnis & "*3569_*.csv")
	sDefinitionFile = sDescPath
	If sImportFile = "" Then
		oLog.LogWarning "Im Verzeichnis" & sQuellverzeichnis
		oLog.LogWarning "Keine Umsatzdatei mit *3569_* gefunden. Die Ausführung des Makros wird gestoppt."
		Exit Function
	Else
		iCounter = 0
		While sImportFile <> ""
			sImport = sQuellverzeichnis & sImportFile
			iCounter = iCounter + 1
			sUmsaetze = "Umsatz_" & iCounter & ".IMD"
			Client.ImportDelimFile sImport, sUmsaetze, False, sFilter, sDefinitionFile, True	'13.07.2020 AS
			sImportFile = Dir()		
		Wend
	End If

	If iCounter = 1 Then
		Set task = Client.ProjectManagement
		' Namen der Datei ändern.
		task.RenameDatabase sUmsaetze, "{Umsätze_Gesamt}.IMD"
		sUmsaetze = "{Umsätze_Gesamt}.IMD" ' wird im folgenden für die Aufbereitung benötigt
		Set task = Nothing
	Else
		Set db = Client.OpenDatabase("Umsatz_1.IMD")
		Set task = db.AppendDatabase
		For iCount = 2 To iCounter 
			task.AddDatabase "Umsatz_" & iCount & ".IMD"
		Next iCount
		sUmsaetze = "{Umsätze_Gesamt}.IMD"
		task.DisableProgressNotification = True
		task.PerformTask sUmsaetze, ""
		db.Close
		Set task = Nothing
		Set db = Nothing
		
' Zwischentabellen löschen
		For iCount = 1 To iCounter
			sMessage = "Löschen der Zwischentabelle: " & "Umsatz_" & iCount
			oLog.LogMessage sMessage
			sFile = Client.WorkingDirectory & "Umsatz_" & iCount & ".IMD"
			Kill sFile
		Next iCount
	End If
	
	Set db = Client.OpenDatabase(sUmsaetze)
	If db.Count > 0 Then
		db.Close
		Set db = Nothing
		bTableContainsRecordsUMS = TRUE
		'Ab Ver 1.04 Datum Korrektur 30.02.2019
		'Import als Text. Dazu neue Umsatzvorlage.RDF verwenden 
		'OrginalFeld Umbennen zu WERTSTELLUNG_ORG
		'SpalteWert aus WERTSTELLUNG_ORG anch Formel in WERTSTELLUNG schreiben
		Call RenameField(sUmsaetze,"WERTSTELLUNG","WERTSTELLUNG_ORG")
		Call AddFieldUmsatz(sUmsaetze, sJahr, sQuellverzeichnis)
	Else
		db.Close
		Set db = Nothing
	'AS 06.10.2020: Stop HSS and inform User
		MsgBox("Die importierten Dateien enthalten keine Datensätze. Bitte überprüfen Sie die Original-Dateien oder die entsprechende Konten- oder Rahmennummerauswahl.")
		Kill Client.WorkingDirectory & sUmsaetze
		SmartContext.ExecutionStatus =EXEC_STATUS_CANCELED
		SmartContext.Log.LogWarning ("Die importierten Dateien enthalten keine Datensätze. Bitte überprüfen Sie die Original-Dateien oder die entsprechende Konten- oder Rahmennummerauswahl.")
		SmartContext.AbortImport = True
	End If
End Function

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

Function RenameField(ByVal sImportFile As String, ByVal sOldFieldName As String, ByVal sNewFieldName As String)

	Set db = Client.OpenDatabase(sImportFile)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField

	field.Name = sNewFieldName 
	field.Description = ""
	field.Type = WI_CHAR_FIELD
	field.Equation = ""
	field.Length = 10
	task.ReplaceField sOldFieldName, field
	
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
	
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

Function AddFieldUmsatz(ByVal sImportFile As String, ByVal sJahr As String, ByVal sQuellverzeichnis As String)
' Lokale Variablen
Dim sFieldName As String
Dim sEquation As String
	
' AS 11.10.2020: get the original account number and add zeros at the front until it is ten characters long
' 1. rename original field
' 2. create new field
	Set db = Client.OpenDatabase(sImportFile)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "KONTO_NR_OG"
	field.Description = ""
	field.Type = WI_CHAR_FIELD
	field.Equation = ""
	field.Length = 10
	task.ReplaceField "KONTO_NR", field
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
	
	Set db = Client.OpenDatabase(sImportFile)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	' AS 11.10.2020: fill the account number with leading zeros
	field.Name = "KONTO_NR"
	field.Description = ""
	field.Type = WI_CHAR_FIELD
	field.Equation = "@Repeat(""0"";10-@Len(KONTO_NR_OG))+KONTO_NR_OG"
	field.Length = 10
	task.AppendField field
	'-------------------------------------------------------------
	'Ab Version 1.04
	'Import als Text. Dazu neue Umsatzvorlage.RDF verwenden 
	'OrginalFeld Umbennen zu WERTSTELLUNG_ORG
	'SpalteWert aus WERTSTELLUNG_ORG anch Formel in WERTSTELLUNG schreiben

	field.Name = "WERTSTELLUNG"
	field.Description = ""
	field.Type = WI_DATE_FIELD
	'field.Equation = "@compif (WERTSTELLUNG_ORG == ""30.02.2018""; @ctod(""28.02.2018"";""DD.MM.YYYY""); WERTSTELLUNG_ORG == """"; @ctod(""00.00.0000"";""DD.MM.YYYY"");1;@ctod(WERTSTELLUNG_ORG ;""DD.MM.YYYY"") )"
	'field.Equation = "@compif(@left(WERTSTELLUNG_ORG; 6)=""30.02.""; @ctod(""28.02."" + @right(WERTSTELLUNG_ORG; 4);""DD.MM.YYYY"");@left(WERTSTELLUNG_ORG; 6)=""31.02.""; @ctod(""28.02."" + @right(WERTSTELLUNG_ORG; 4);""DD.MM.YYYY"");WERTSTELLUNG_ORG="""";@ctod(""00.00.0000"";""DD.MM.YYYY"");1;@ctod(WERTSTELLUNG_ORG;""DD.MM.YYYY""))"
	field.Equation = "@if(@len(WERTSTELLUNG_ORG)=10;@compif(@left(WERTSTELLUNG_ORG; 6)=""30.02.""; @ctod(""28.02."" + @right(WERTSTELLUNG_ORG; 4);""DD.MM.YYYY"");@left(WERTSTELLUNG_ORG; 6)=""31.02.""; @ctod(""28.02."" + @right(WERTSTELLUNG_ORG; 4);""DD.MM.YYYY"");WERTSTELLUNG_ORG="""";@ctod(""00.00.0000"";""DD.MM.YYYY"");1;@ctod(WERTSTELLUNG_ORG;""DD.MM.YYYY""));@compif(@left(WERTSTELLUNG_ORG; 6)=""30.02.""; @ctod(""28.02."" + @right(WERTSTELLUNG_ORG; 2);""DD.MM.YY"");@left(WERTSTELLUNG_ORG; 6)=""31.02.""; @ctod(""28.02."" + @right(WERTSTELLUNG_ORG; 2);""DD.MM.YY"");WERTSTELLUNG_ORG="""";@ctod(""00.00.00"";""DD.MM.YY"");1;@ctod(WERTSTELLUNG_ORG;""DD.MM.YY"")))"
	task.AppendField field
	task.PerformTask
	
	field.Name = "SHK"
	field.Description = ""
	field.Type = WI_CHAR_FIELD
	sEquation = "@If(BETRAG < 0;""S"";""H"")"
	field.Equation = sEquation
	field.Length = 1
	task.AppendField field
	
	field.Name = "RAHMENNR_2STELLIG"
	field.Description = ""
	field.Type = WI_CHAR_FIELD
	field.Equation = "@Left(KTO_RAHMEN;2)"
	field.Length = 2
	task.AppendField field
	
	field.Name = "RAHMENNR_3STELLIG"
	field.Description = ""
	field.Type = WI_CHAR_FIELD
	field.Equation = "@Left(KTO_RAHMEN;3)"
	field.Length = 3
	task.AppendField field
	
	'AS 23.05.2022
	field.Name = "REBU_NR"
	field.Description = "Hinzugefügtes Feld"
	field.Type = WI_VIRT_CHAR
	field.Equation = "@if(VERWENDUNGSZWECK=""REBU"";@Repeat(""0"";10-@len(@split(VERWENDUNGSZWECK;""REBU   "";"" "";1;0)))+@split(VERWENDUNGSZWECK;""REBU   "";"" "";1;0);"""")"
	field.Length = 10
	task.AppendField field
	
	field.Name = "NICHTAUFGRIFFSGRENZE"
	field.Description = ""
	field.Type = WI_NUM_FIELD
	sEquation = CDbl(sParaNAGrenze)
	field.Equation = sEquation
	field.Decimals = 2
	task.AppendField field
	
	field.Name = "HABEN_BETRAG"
	field.Description = "Hinzugefügtes Feld"
	field.Type = WI_NUM_FIELD
	field.Equation = "@IF(BETRAG > 0; BETRAG; 0)"
	field.Decimals = 2
	task.AppendField field
	
	field.Name = "SOLL_BETRAG"
	field.Description = "Hinzugefügtes Feld"
	field.Type = WI_NUM_FIELD
	field.Equation = "@IF(BETRAG <= 0; -BETRAG; 0)"
	field.Decimals = 2
	task.AppendField field
	
	'field.Name = "NABU"
	'field.Description = ""
	'field.Type = WI_CHAR_FIELD
	'field.Equation = """0"""
	'field.Length = 8
	'task.AppendField field
	'
	'field.Name = "BM"
	'field.Description = """"""
	'field.Type = WI_CHAR_FIELD
	'field.Equation = """"""
	'field.Length = 8
	'task.AppendField field
	'
	'field.Name = "RUECKBUCHUNG"
	'field.Description = ""
	'field.Type = WI_CHAR_FIELD
	'field.Equation = """"""
	'field.Length = 8
	'task.AppendField field
	
	task.DisableProgressNotification = True
	
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
	
End Function

Function PrepareSalesData
' Local Variables
Dim sTempString As String
Dim sTempDB As String

	oLog.LogMessage "Start der Datenaufbereitung"
	
	sTempString = Now()
	sTempString = iReplace(sTempString,":","_")

	Set db = Client.OpenDatabase(sUmsaetze)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "RELEVANT"
	field.Description = ""
	field.Type = WI_CHAR_FIELD
	field.Equation = "@If(@Abs(BETRAG) > NICHTAUFGRIFFSGRENZE;""X"";"""")"
	field.Length = 1
	task.AppendField field
	task.DisableProgressNotification = True
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
	
	sTempDB = sUmsaetze
	
	Set db = Client.OpenDatabase(sUmsaetze)
	Set task = db.JoinDatabase
	task.FileToJoin dbImportOBR
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
	task.AddPFieldToInc "REBU_NR" ' 23.05.2022
	task.AddPFieldToInc "NICHTAUFGRIFFSGRENZE"
	task.AddPFieldToInc "RELEVANT"
	task.AddPFieldToInc "HABEN_BETRAG"
	task.AddPFieldToInc "SOLL_BETRAG"
	task.AddSFieldToInc "KONTO"
	task.AddSFieldToInc "BEZEICHNUNG"
	task.AddSFieldToInc "AZ9_SALDO"
	task.AddSFieldToInc "SHK"
	task.AddSFieldToInc "RAHMENNR_2STELLIG"
	task.AddSFieldToInc "POSITION_AKT_JAHR"
	task.AddSFieldToInc "POSITION_SHORT"
	task.AddSFieldToInc "ERÖFFNUNG"
	task.AddSFieldToInc "AUFLÖSUNG"
	task.AddSFieldToInc "BUCHUNGSKATEGORIE_BV"
	'task.AddSFieldToInc "KURZBESCHREIBUNG_SVZ"
	'task.AddPFieldToInc "NABU"
	'task.AddPFieldToInc "BM"
	'task.AddPFieldToInc "RUECKBUCHUNG"
	task.AddMatchKey "KONTO_NR", "KONTO", "A"
	task.CreateVirtualDatabase = False
	task.DisableProgressNotification = True
	sUmsaetze = "{Umsätze_zu_OBR_Gesamt}.IMD"
	task.PerformTask sUmsaetze, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	oLog.LogMessage "Löschen der Zwischentabelle: " & sTempDB
	sTempDB = Client.WorkingDirectory & sTempDB
	Kill sTempDB
	
	sTempDB = sUmsaetze
	
	Set db = Client.OpenDatabase(sUmsaetze)
	Set task = db.JoinDatabase
	task.FileToJoin dbImportPN
	task.IncludeAllPFields
	task.AddSFieldToInc "MANUELLE_BUCHUNGEN"
	task.AddMatchKey "PN", "PN_NR", "A"
	task.CreateVirtualDatabase = False
	task.DisableProgressNotification = True
	sUmsaetze = "{Umsätze_zu_OBR_Gesamt_mit_Buchungskennzeichen}.IMD"
	task.PerformTask sUmsaetze, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	oLog.LogMessage "Löschen der Zwischentabelle: " & sTempDB
	sTempDB = Client.WorkingDirectory & sTempDB
	Kill sTempDB
	
	Set db = Client.OpenDatabase(sUmsaetze)
	Set task = db.Summarization
	task.AddFieldToSummarize "RAHMENNR_2STELLIG"
	task.AddFieldToSummarize "SHK"
	task.AddFieldToTotal "BETRAG"
	task.Criteria = "RAHMENNR_2STELLIG <> """""
	dbBuchungenJeKtoRahmen = "-SKA00_Anzahl_Buchungen_je_bebuchten_KtoRahmen_mit_SHK.IMD"
	task.OutputDBName = dbBuchungenJeKtoRahmen
	task.CreatePercentField = False
	task.StatisticsToInclude = SM_SUM
	task.DisableProgressNotification = True
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	' 25.07.2022 the creation of the table was outsourced to audit test 0003 in order to enable an individual filtering
	'Set db = Client.OpenDatabase(sUmsaetze)
	'Set task = db.Summarization
	'task.AddFieldToSummarize "RAHMENNR_2STELLIG"
	'task.AddFieldToTotal "BETRAG"
	'dbBuchungenJeKtoRahmenGes = "-SKA00_Anzahl_Buchungen_je_KtoRahmen.IMD"
	'task.OutputDBName = dbBuchungenJeKtoRahmenGes
	'task.CreatePercentField = False
	'task.StatisticsToInclude = SM_SUM + SM_MAX + SM_MIN + SM_AVERAGE
	'task.DisableProgressNotification = True
	'task.PerformTask
	'db.Close
	'Set task = Nothing
	'Set db = Nothing
	
	Set db = Client.OpenDatabase(sUmsaetze)
	Set task = db.Extraction
	task.IncludeAllFields
	dbUmsaetzeOBRManuell = "-SKA00_Umsätze_zu_OBR_manuell.IMD"
	task.AddExtraction dbUmsaetzeOBRManuell, "", "@Isini(""X"";MANUELLE_BUCHUNGEN)"
	dbUmsaetzeOBRAuto = "-SKA00_Umsätze_zu_OBR_automatisch.IMD"
	task.AddExtraction dbUmsaetzeOBRAuto, "", ".NOT. @Isini(""X"";MANUELLE_BUCHUNGEN)"
	task.CreateVirtualDatabase = False
	task.DisableProgressNotification = True
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	Set db = Client.OpenDatabase(sUmsaetze)
	Set task = db.Extraction
	task.IncludeAllFields
	dbUmsaetzeOBREuro = "-SKA00_Umsätze_zu_OBR_in EUR.IMD"
	task.AddExtraction dbUmsaetzeOBREuro, "", " WKZ  == ""EUR"""
	task.CreateVirtualDatabase = False
	task.DisableProgressNotification = True
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	' AS 23.05.2022
	Set db = Client.OpenDatabase(dbUmsaetzeOBRManuell)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "WERTSTELLUNG_JAHR"
	field.Description = ""
	field.Type = WI_CHAR_FIELD
	field.Equation = "@Str(@Year(WERTSTELLUNG);4;2)"
	field.Length = 4
	task.AppendField field
	'field.Name = "RELEVANTER_BETRAG"
	'field.Description = ""
	'field.Type = WI_CHAR_FIELD
	'field.Equation = "@If(BETRAG>999,99;@If(@Right(@Str(BETRAG;20;2);6)==""000,00"";""X"";"""");"""")"
	'field.Length = 1
	'task.AppendField field
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
		
	Set db = Client.OpenDatabase(dbUmsaetzeOBRAuto)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "WERTSTELLUNG_JAHR"
	field.Description = ""
	field.Type = WI_CHAR_FIELD
	field.Equation = "@Str(@Year(WERTSTELLUNG);4;2)"
	field.Length = 4
	task.AppendField field
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
	
	' 25.07.2022 the creation of the table was outsourced to audit test 0003 in order to enable an individual filtering
	'Set db = Client.OpenDatabase(dbUmsaetzeOBRAuto)
	'Set task = db.Summarization
	'task.AddFieldToSummarize "RAHMENNR_2STELLIG"
	'task.AddFieldToTotal "BETRAG"
	'dbUmsaetzeAutoJeKto = "-SKA00_Automatische_Buchungen_je_KtoRahmen.IMD"
	'task.OutputDBName = dbUmsaetzeAutoJeKto
	'task.CreatePercentField = False
	'task.UseFieldFromFirstOccurrence = True
	'task.StatisticsToInclude = SM_SUM + SM_MAX + SM_MIN + SM_AVERAGE
	'task.PerformTask
	'db.Close
	'Set task = Nothing
	'Set db = Nothing
	
	Set db = Client.OpenDatabase(dbUmsaetzeOBRAuto)
	Set task = db.Extraction
	task.IncludeAllFields
	dbUmsaetzeOBRinEURAuto = "-SKA00_Umsätze_zu_OBR_in_EUR_automatisch.IMD"
	task.AddExtraction dbUmsaetzeOBRinEURAuto, "", "WKZ == ""EUR"""
	dbUmsaetzeOBRungleichEURAuto = "-SKA00_Umsätze_zu_OBR_nicht_in_EUR_automatisch.IMD"
	task.AddExtraction dbUmsaetzeOBRungleichEURAuto, "", "WKZ <> ""EUR"""
	task.CreateVirtualDatabase = False
	task.DisableProgressNotification = True
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	' 25.07.2022 the creation of the table was outsourced to audit test 0004 in order to enable an individual filtering
	'Set db = Client.OpenDatabase(dbUmsaetzeOBRManuell)
	'Set task = db.Summarization
	'task.AddFieldToSummarize "RAHMENNR_2STELLIG"
	'task.AddFieldToTotal "BETRAG"
	'dbUmsaetzeManuellJeKto = "-SKA00_Manuelle_Buchungen_je_KtoRahmen.IMD"
	'task.OutputDBName = dbUmsaetzeManuellJeKto
	'task.CreatePercentField = False
	'task.UseFieldFromFirstOccurrence = True
	'task.StatisticsToInclude = SM_SUM + SM_MAX + SM_MIN + SM_AVERAGE
	'task.PerformTask
	'db.Close
	'Set task = Nothing
	'Set db = Nothing
	
	Set db = Client.OpenDatabase(dbUmsaetzeOBRManuell)
	Set task = db.Extraction
	task.IncludeAllFields
	dbUmsaetzeOBRinEURManuell = "-SKA00_Umsätze_zu_OBR_in_EUR_manuell.IMD"
	task.AddExtraction dbUmsaetzeOBRinEURManuell, "", "WKZ == ""EUR"""
	
	dbUmsaetzeOBRungleichEURManuell = "-SKA00_Umsätze_zu_OBR_nicht_in_EUR_manuell.IMD"
	task.AddExtraction dbUmsaetzeOBRungleichEURManuell, "", "WKZ <> ""EUR"""
	task.CreateVirtualDatabase = False
	task.DisableProgressNotification = True
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	
	'Das kann gegf. gelöscht werden, da es im PS passiert
	'Leider kommte es dann zum Fehler, der Untersucht werden muss.
	'Also wird es erstmal nicht gelöscht werden
	'Wahrscheinlich werden die Tabellen noch gebraucht
	'PS 11,138,6 greifen noch auf diese Tabellen
	
	Set db = Client.OpenDatabase(dbUmsaetzeOBRinEURManuell)
	Set task = db.Extraction
	task.IncludeAllFields

	dbHabenAufSollOBRinEUR = "-SKA00_HabenBuchungen_auf_SollKonten_zu_OBR_in_EUR.IMD"
	task.AddExtraction dbHabenAufSollOBRinEUR, "", "AZ9_SALDO <= 0,00 .AND. BETRAG > 0,00 .AND. TEXTSCHLÜSSEL <> ""25"" .AND. TEXTSCHLÜSSEL <> ""68"""
	
	dbSollAufHabenOBRinEUR = "-SKA00_SollBuchungen_auf_HabenKonten_zu_OBR_in_EUR.IMD"
	task.AddExtraction dbSollAufHabenOBRinEUR, "", "AZ9_SALDO > 0,00 .AND. BETRAG <= 0,00 .AND. TEXTSCHLÜSSEL <> ""25"" .AND. TEXTSCHLÜSSEL <> ""68"""
	
	dbStornoHabenAufSollOBRinEUR = "-SKA00_Storno_HabenBuchungen_auf_SollKonten_zu_OBR_in_EUR.IMD"
	task.AddExtraction dbStornoHabenAufSollOBRinEUR, "", "AZ9_SALDO <= 0,00 .AND. BETRAG > 0,00 .AND. ( TEXTSCHLÜSSEL == ""25"" .OR. TEXTSCHLÜSSEL == ""68"" .or. @isini(""Storno"";VERWENDUNGSZWECK)  .OR. @isini(""Korrektur"";VERWENDUNGSZWECK)  .OR.  @isini(""Berichtigung"";VERWENDUNGSZWECK))"
	
	dbStornoSollAufHabenOBRinEUR = "-SKA00_Storno_SollBuchungen_auf_HabenKonten_zu_OBR_in_EUR.IMD"
	task.AddExtraction dbStornoSollAufHabenOBRinEUR, "", "AZ9_SALDO > 0,00 .AND. BETRAG <= 0,00 .AND. ( TEXTSCHLÜSSEL == ""25"" .OR. TEXTSCHLÜSSEL == ""68"" .or. @isini(""Storno"";VERWENDUNGSZWECK)  .OR. @isini(""Korrektur"";VERWENDUNGSZWECK)  .OR.  @isini(""Berichtigung"";VERWENDUNGSZWECK))"
	
	task.CreateVirtualDatabase = False
	task.DisableProgressNotification = True
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	'Set db = Client.OpenDatabase(dbUmsaetzeOBRungleichEURManuell)
	'Set task = db.Extraction
	'task.IncludeAllFields
	
	'dbHabenAufSollOBRungleichEUR = "-SKA00_HabenBuchungen_auf_SollKonten_zu_OBR_nicht_in_EUR.IMD"
	'task.AddExtraction dbHabenAufSollOBRungleichEUR, "", "AZ9_SALDO <= 0,00 .AND. BETRAG > 0,00 .AND. TEXTSCHLÜSSEL <> ""25"" .AND. TEXTSCHLÜSSEL <> ""68"""
	
	'dbSollAufHabenOBRungleichEUR = "-SKA00_SollBuchungen_auf_HabenKonten_zu_OBR_nicht_in_EUR.IMD"
	'task.AddExtraction dbSollAufHabenOBRungleichEUR, "", "AZ9_SALDO > 0,00 .AND. BETRAG <= 0,00 .AND. TEXTSCHLÜSSEL <> ""25"" .AND. TEXTSCHLÜSSEL <> ""68"""
	
	'dbStornoHabenAufSollOBRungleichEUR = "-SKA00_Storno_HabenBuchungen_auf_SollKonten_zu_OBR_nicht_in_EUR.IMD"
	'task.AddExtraction dbStornoHabenAufSollOBRungleichEUR, "", "AZ9_SALDO <= 0,00 .AND. BETRAG > 0,00 .AND. ( TEXTSCHLÜSSEL == ""25"" .OR. TEXTSCHLÜSSEL == ""68"" )"
	
	'dbStornoSollAufHabenOBRungleichEUR = "-SKA00_Storno_SollBuchungen_auf_HabenKonten_zu_OBR_nicht_in_EUR.IMD"
	'task.AddExtraction dbStornoSollAufHabenOBRungleichEUR, "", "AZ9_SALDO > 0,00 .AND. BETRAG <= 0,00 .AND. ( TEXTSCHLÜSSEL == ""25"" .OR. TEXTSCHLÜSSEL == ""68"" )"
	
	'task.CreateVirtualDatabase = False
	'task.DisableProgressNotification = True
	'task.PerformTask 1, db.Count
	'db.Close
	'Set task = Nothing
	'Set db = Nothing


End Function

Function removeHistory
On Error GoTo ErrorHandler

	If bPrivateMode = TRUE Then
'		If sTableKundenstamm <> "" Then oProtectIP.RemoveHistory sTableKundenstamm
'		If sTableOffenePosten <> "" Then oProtectIP.RemoveHistory sTableOffenePosten
'		If sTableKundenauftraege <> "" Then oProtectIP.RemoveHistory sTableKundenauftraege
'		If sTableFakturen <> "" Then oProtectIP.RemoveHistory sTableFakturen
'		If sTableRechnungen <> "" Then oProtectIP.RemoveHistory sTableRechnungen
'		If sTableGutschriften <> "" Then oProtectIP.RemoveHistory sTableGutschriften
'		If sTableAenderungsprotokoll <> "" Then oProtectIP.RemoveHistory sTableAenderungsprotokoll
	End If
	
	Exit Sub
ErrorHandler:
	Set db = Nothing
	Set table = Nothing
	Set field = Nothing
	Set task = Nothing
	
	Call LogSmartAnalyzerError("")
	oLog.LogWarning "Error in history routine."
End Function

' Logs an error and in case the user canceled the execution, it logs the cancel state.
' extraInfo: Only used in case special information shall be logged - usually it is empty.
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
End Sub ' --------------------------------------------------------------------------

' Sets the value of the global variable "m_checkpointName".
' Checkpoints are identifying a position in the code.
' In case of an error the last passed checkpoint name will be logged. 
Sub SetCheckpoint(ByVal checkpointName As String)
	m_checkpointName = checkpointName
End Sub ' --------------------------------------------------------------------------

Function GetUserMode As Integer

	Dim sgewaehlteDaten As String
	Dim iAntwort
	Dim dlgAbfrage As BenutzerModus

	iAntwort = Dialog(dlgAbfrage) 

	If iAntwort = 0 Then
		'MsgBox "Dies App wird jetzt geschloßen."
		'End
		Exit Sub
	Else 
		sgewaehlteDaten = dlgAbfrage.OptionButtonGroup1
		GetUserMode = sgewaehlteDaten
		
		Select Case sgewaehlteDaten 
			Case 0
				oLog.LogMessage "Selected UserMode: " & " Standard Benutzer (" & sgewaehlteDaten & ")"
			Case 1
				oLog.LogMessage "Selected UserMode: " & " Experten Benutzer (" & sgewaehlteDaten & ")"
		End Select

	End If

End Function

Function WriteNewConfig

	Call createIMD
	Call writeElementInFile

End Function


Function CreateIMD
' Lokale Variablen
Dim oNewDB As Object
Dim oNewTableDef As Object
Dim oNewField As Object

oLog.LogMessage "Create Config File : " & Client.NewTableDef
	'Neue Tabellendefinition erstellen
	Set oNewTableDef = Client.NewTableDef
	'Neue Felder der bestehenden Tabellendefinition hinzufügen
	Set oNewField = oNewTableDef.NewField
	
	oNewField.Name = "GJAHR"
	oNewField.Description = ""
	oNewField.Type = WI_NUM_FIELD
	oNewField.Decimals = 0
	oNewTableDef.AppendField oNewField
	
	oNewField.Name = "STICHPROBE"
	oNewField.Description = ""
	oNewField.Type = WI_NUM_FIELD
	oNewField.Decimals = 0
	oNewTableDef.AppendField oNewField
	
	'oNewField.Name = "NAGRENZE"
	'oNewField.Description = ""
	'oNewField.Type = WI_NUM_FIELD
	'oNewField.Decimals = 0
	'oNewTableDef.AppendField oNewField

	oNewField.Name = "PFAD_OBR"
	oNewField.Description = ""
	oNewField.Type = WI_CHAR_FIELD
	oNewField.Length = 400	
	oNewTableDef.AppendField oNewField
	
	oNewField.Name = "PFAD_OBR_DESC"
	oNewField.Description = ""
	oNewField.Type = WI_CHAR_FIELD
	oNewField.Length = 400
	oNewTableDef.AppendField oNewField
	
	oNewField.Name = "PFAD_UMSATZ"
	oNewField.Description = ""
	oNewField.Type = WI_CHAR_FIELD
	oNewField.Length = 400	
	oNewTableDef.AppendField oNewField
	
	oNewField.Name = "PFAD_UMSATZ_DESC"
	oNewField.Description = ""
	oNewField.Type = WI_CHAR_FIELD
	oNewField.Length = 400
	oNewTableDef.AppendField oNewField	
	
	oNewField.Name = "PFAD_HK"
	oNewField.Description = ""
	oNewField.Type = WI_CHAR_FIELD
	oNewField.Length = 400	
	oNewTableDef.AppendField oNewField
	
	oNewField.Name = "PFAD_HK_DESC"
	oNewField.Description = ""
	oNewField.Type = WI_CHAR_FIELD
	oNewField.Length = 400
	oNewTableDef.AppendField oNewField
	
	oNewField.Name = "PFAD_POS"
	oNewField.Description = ""
	oNewField.Type = WI_CHAR_FIELD
	oNewField.Length = 400	
	oNewTableDef.AppendField oNewField
	
	oNewField.Name = "PFAD_POS_DESC"
	oNewField.Description = ""
	oNewField.Type = WI_CHAR_FIELD
	oNewField.Length = 400
	oNewTableDef.AppendField oNewField	
	
	oNewField.Name = "PFAD_PN"
	oNewField.Description = ""
	oNewField.Type = WI_CHAR_FIELD
	oNewField.Length = 400	
	oNewTableDef.AppendField oNewField
	
	oNewField.Name = "PFAD_PN_DESC"
	oNewField.Description = ""
	oNewField.Type = WI_CHAR_FIELD
	oNewField.Length = 400
	oNewTableDef.AppendField oNewField	

	oNewField.Name = "DELETE_TEMP"
	oNewField.Description = ""
	oNewField.Type = WI_NUM_FIELD
	oNewField.Decimals = 0
	oNewTableDef.AppendField oNewField
	
	Set oNewField = Nothing
	'Datenbank-Objekt für neue Datei erstellen
	'Set db = Client.OpenDatabase(sVariable)

	sNewDBName = Client.UniqueFileName("-ConfigFile")
	Set oNewDB = Client.NewDataBase(sNewDBName, "", oNewTableDef)
	'Schreibschutz für neues Tabellen-Objekt temporär aufheben
	Set oNewTableDef = oNewDB.TableDef
	oNewTableDef.Protect = False
	'Feldschutz wieder setzen
	oNewTableDef.Protect = True
	Set oNewTableDef = Nothing
	oNewDB.CommitDatabase
	Set oNewDB = Nothing
oLog.LogMessage "End of Creating Config File : " 	
End Function

Function writeElementInFile
Dim sGJahr As String
Dim lStichprobe As Integer
Dim dNAGrenze As Double

' Lokalen Variablen
Dim oField1 As Object  	' Bewegungsdaten
Dim oField2 As Object  	' Stammdaten
Dim oField3 As Object  	' Geschäftsjahr
Dim oField4 As Object	' Löschen temporär Dateien
Dim oField5 As Object
Dim oField6 As Object
Dim oField7 As Object
Dim oField8 As Object
Dim oField9 As Object
Dim oField10 As Object
Dim oField11 As Object
Dim oField12 As Object
Dim oField13 As Object

Dim rs As Object
Dim record As Object

	oLog.LogMessage "Write Config File : " & sNewDBName
	Set db = Client.OpenDatabase(sNewDBName)
	Set task = db.TableManagement
	Set table = db.TableDef
	
	Set oField1 = table.GetFieldAt(1)
	Set oField2 = table.GetFieldAt(2)
	Set oField3 = table.GetFieldAt(3)
	Set oField4 = table.GetFieldAt(4)
	Set oField5 = table.GetFieldAt(5)
	Set oField6 = table.GetFieldAt(6)
	Set oField7 = table.GetFieldAt(7)
	Set oField8 = table.GetFieldAt(8)
	Set oField9 = table.GetFieldAt(9)
	Set oField10 = table.GetFieldAt(10)
	Set oField11 = table.GetFieldAt(11)
	Set oField12 = table.GetFieldAt(12)
	Set oField13 = table.GetFieldAt(12)
	
	oField1.Protected = False
	oField2.Protected = False
	oField3.Protected = False
	oField4.Protected = False
	oField5.Protected = False
	oField6.Protected = False
	oField7.Protected = False
	oField8.Protected = False
	oField9.Protected = False
	oField10.Protected = False
	oField11.Protected = False
	oField12.Protected = False
	oField13.Protected = False
	
	Set rs = db.RecordSet
	Set record = rs.NewRecord
	
	'Ab Version 1.04 keine Stichprobe
	'lStichprobe = CInt(sParaStichprobe)
	dNAGrenze = CDbl(sParaNAGrenze)

	' Werte in Tabellenspalten eintragen
	record.SetCharValue oField1.Name, dlgImport.tbGJahr
	
	'Ab Version 1.04 keine Stichprobe
	'record.SetCharValue oField2.Name, lStichprobe 'sParaStichprobe
	
	record.SetCharValue oField3.Name, dNAGrenze
	
	record.SetCharValue oField4.Name, sPfadOBR
	record.SetCharValue oField5.Name, sPfadOBRDesc
	
	record.SetCharValue oField6.Name, sPfadUmsatz
	record.SetCharValue oField7.Name, sPfadUmsatzDesc
	
	record.SetCharValue oField8.Name, sPfadHK 
	record.SetCharValue oField9.Name, sPfadHKDesc
	
	record.SetCharValue oField10.Name, sPfadPOS 
	record.SetCharValue oField11.Name, sPfadPOSDesc
	
	record.SetCharValue oField12.Name, sPfadPN 
	record.SetCharValue oField13.Name, sPfadPNDesc
	
'	record.SetNumValue oField4.Name, dlgImport.cbDeleteTemp
	rs.AppendRecord(record)
	
	oField1.Protected = True
	oField2.Protected = True
	oField3.Protected = True
	oField4.Protected = True 
	oField5.Protected = True
	oField6.Protected = True
	oField7.Protected = True
	oField8.Protected = True 
	oField9.Protected = True
	oField10.Protected = True
	oField11.Protected = True
	oField12.Protected = True
	oField13.Protected = True 
	
	db.CommitDatabase
	db.Close
	Set db = Nothing
	Set rs = Nothing
	Set table = Nothing
	Set task = Nothing
	Set record = Nothing
	Set oField1 = Nothing
	Set oField2 = Nothing
	Set oField3 = Nothing
	Set oField4 = Nothing
	Set oField5 = Nothing
	Set oField6 = Nothing
	Set oField7 = Nothing
	Set oField8 = Nothing
	Set oField9 = Nothing
	Set oField10 = Nothing
	Set oField11 = Nothing
	Set oField12 = Nothing
	Set oField13 = Nothing
	
	oLog.LogMessage "End of Writing Config File : " 	
End Function

Function CheckConfig

	If FileExists(dbConfigFile) Then
		Call UpdateConfig()
	Else
		Call WriteNewConfig()
	End If	
	Client.RefreshFileExplorer
	
End Function

Function UpdateConfig

' Lokale Variablen
Dim iLength As Integer
Dim sTableName As String
Dim dbNewConfig As String
Dim sEquation As String

' Schritt 1: Felder umbenennen
	sTableName = iSplit(dbConfigFile,"","\",1,1)
	Set db = Client.OpenDatabase(sTableName)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "PFAD_BEWEGUNG_OLD"
	field.Description = ""
	field.Type = WI_CHAR_FIELD
	field.Equation = ""
	field.Length = 16
	task.ReplaceField "PFAD_BEWEGUNG", field
	field.Name = "PFAD_STAMM_OLD"
	field.Description = ""
	field.Type = WI_CHAR_FIELD
	field.Equation = ""
	field.Length = 27
	task.ReplaceField "PFAD_STAMM", field
	field.Name = "GJAHR_OLD"
	field.Description = ""
	field.Type = WI_NUM_FIELD
	field.Equation = ""
	field.Decimals = 0
	task.ReplaceField "GJAHR", field
	field.Name = "DELETE_TEMP_OLD"
	field.Description = ""
	field.Type = WI_NUM_FIELD
	field.Equation = ""
	field.Decimals = 0
	task.ReplaceField "DELETE_TEMP", field
	task.PerformTask
	db.Close
	Set db = Nothing
	Set task = Nothing
	Set field = Nothing		
' Schritt 2: Neue Felder anhängen			
	Set db = Client.OpenDatabase(sTableName)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
'	sEquation = """" & dlgMain.tbPfadBewegung & """"
'	iLength = Len(dlgMain.tbPfadBewegung)
	field.Name = "PFAD_BEWEGUNG"
	field.Description = ""
	field.Type = WI_VIRT_CHAR
	field.Equation = sEquation
	field.Length = iLength
	task.AppendField field
'	sEquation = """" & dlgMain.tbPfadStamm & """"
'	iLength = Len(dlgMain.tbPfadStamm)
	field.Name = "PFAD_STAMM"
	field.Description = ""
	field.Type = WI_VIRT_CHAR
	field.Equation = sEquation
	field.Length = iLength
	task.AppendField field
'	sEquation = dlgMain.tbGJahr
	field.Name = "GJAHR"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = sEquation
	field.Decimals = 0
	task.AppendField field
'	sEquation = dlgMain.cbDeleteTemp
	field.Name = "DELETE_TEMP"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = sEquation
	field.Decimals = 0
	task.AppendField field
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
' Schritt 3: Neue Felder extrahieren und in neue IDEA-Tabelle speichern
	Set db = Client.OpenDatabase(sTableName)
	Set task = db.Extraction
	task.AddFieldToInc "PFAD_BEWEGUNG"
	task.AddFieldToInc "PFAD_STAMM"
	task.AddFieldToInc "GJAHR"
	task.AddFieldToInc "DELETE_TEMP"
	dbNewConfig = "-ConfigFile.IMD"
	task.AddExtraction dbNewConfig, "", ""
	task.CreateVirtualDatabase = False
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
' Schritt 4: IDEA-Tabelle als Excel-Datei speichern
	Kill dbConfigPath
	Set db = Client.OpenDatabase(dbNewConfig)
	Set task = db.ExportDatabase
	task.IncludeAllFields
	eqn = ""
	task.PerformTask dbConfigPath,"Database", "XLSX", 1, db.Count, eqn
	db.Close
	Set db = Nothing
	Set task = Nothing	

End Function

'Function ReadConfigParameter
'
'	dbConfigFile = Client.WorkingDirectory + "-ConfigFile.xlsx"
'	dbConfigPath = dbConfigFile
'	If FileExists(dbConfigFile) = True Then
'		Set task = Client.GetImportTask("ImportExcel")
'		task.FileToImport = dbConfigFile
'		task.SheetToImport = "Database"
'		task.OutputFilePrefix = "-ConfigFile"
'		task.FirstRowIsFieldName = "TRUE"
'		task.EmptyNumericFieldAsZero = "FALSE"
'		task.PerformTask
'		dbConfigFile = task.OutputFilePath("Database")
'		Set task = Nothing
'		Set db = Client.OpenDatabase(dbConfigFile)
'		If db.Count > 0 Then
'		' Pointer setzen
'			Set rs = db.RecordSet
'			rs.ToFirst
'			Set record = rs.ActiveRecord
'			rs.Next
'		' Wert aus dem ersten Datensatz auslesen
'			sParaBewegungPath = record.GetCharValue("PFAD_BEWEGUNG")
'			sParaStammPath = record.GetCharValue("PFAD_STAMM")
'			sParaGJahr = CStr(record.GetNumValue("GJAHR"))
'			iParaDelTemp = record.GetNumValue("DELETE_TEMP")
'			
'			Set rs = Nothing
'			Set record = Nothing
'		End If
'		db.Close
'		Set db = Nothing
'	End If
'		
'End Function

Function FilterDialog
SetCheckpoint "Start of FilterDialog"
Dim dialogInvoker As Object
Dim vAccountChoice As Variant
Dim result As Object
Dim args As Object
Dim dict As Object
Dim returnedValues As Object
Dim accountValues As Object
' FromToList
Const FromValue = 0
Const ToValue = 1
Dim sAccountFrom As String
Dim sAccountTo As String 
Dim vList As Variant
Dim vRow As Variant
Dim vRowneu As Variant

Dim bAccountFilter As Boolean
Dim bRahmenFilter As Boolean
	
	Set dialogInvoker = SmartContext.GetServiceById("MacroDialogInvoker")
	If dialogInvoker is Nothing Then
		SmartContext.Log.LogError "Der Dialog für den Pfad der Datei konnte nicht angezeigt werden, da der MacroDialogInvoker Service nicht vorhanden ist."
		Exit Sub
	End If
    
	Set args = dialogInvoker.NewTaskParameters
	Set dict = oSC.CreateHashtable
	'dict.Add "FilePathStandard", sFilePathStandard

	'args.Inputs.Add "smartDataExchanger1", dict
    
	Set result = dialogInvoker.PerformTask("KontenRahmenFilter", args)
    
	If result.AllOK Then
		bAccountFilter = result.Outputs.Item("AccountFilter").Checked
		bRahmenFilter = result.Outputs.Item("RahmenFilter").Checked
		
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
		SmartContext.ExecutionStatus = EXEC_STATUS_FAILED
		oLog.LogWarning "Vorgang wurde vom Anwender abgebrochen (Dialog: Konten/Rahmenfilter)"
		oLog.LogWarning "Execution Time End: " & Now()
		Stop
	End If
	If Right(sEquation, 5) = ".OR. " Then sEquation = Left(sEquation, Len(sEquation)-6)
	
	oLog.LogMessage "DialogEquation: " & sEquation
End Function

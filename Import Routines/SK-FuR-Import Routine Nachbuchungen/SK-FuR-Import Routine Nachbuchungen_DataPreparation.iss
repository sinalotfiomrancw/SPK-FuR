'-------------------------------------------------------------------------------------
' Title:		SKA_FuR - Import Routine Nachbuchungen
' CIR:			SKA_FuR
' Customer:		Sparkassen
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
Dim dbImportOBR As String
Dim dbImportOBRTemp	As String
Dim dbImport As String
Dim dbImportBVS	As String
Dim dbImportPN	As String
Dim dbNachbuchzuOBR As String
Dim sAktuelleOBR As String
Dim sPath As String
dim sPathOBR	As String
Dim sPfadOBRDesc As String
Dim sAktuelleGJAHR As String
Dim sEquation As String
Dim sWorkingDir As String

'Final Tables
Dim dbBuchungenJeKtoRahmen As String
Dim dbBuchungenJeKtoRahmenGes As String
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
Dim sPNPatern	As String
Dim sDialogResultCase As String

Dim m_checkpointName As String

Sub Main
On Error GoTo ErrorHandler
SetCheckpoint "Begin of Main"
	Set oSC = SmartContext.MacroCommands.SimpleCommands
	Set oTM = SmartContext.MacroCommands.TagManagement
	Set oLog = SmartContext.Log
	Set oProtectIP = SmartContext.MacroCommands.ProtectIP
	' AS 18.11.2020: OBR Tagging
	Set oPara = SmartContext.MacroCommands.GlobalParameters ' AS 18.11.2020
oLog.LogMessage "Get Project Parameters"

	IgnoreWarning(True)
	sAktuelleGJAHR = oPara.Get4Project ("sAktuelleGJAHR")
	sDialogResultCase = oPara.Get4Project ("sNaBuDialogResultCase")
	sEquation = oPara.Get4Project ("sEquationDialogNB")
	sPath = oPara.Get4Project ("sPathNaBu")
	
	sPNPatern = "{Primanotenplan_" & sAktuelleGJAHR & "*"
	
	sWorkingDir = Client.WorkingDirectory 
	sWorkingDir =Left(sWorkingDir, Len(sWorkingDir) - 1)
	
	Set fs = SmartContext.MacroCommands.GetFileSystem() 
	
	Set oFiles = fs.GetFilesByRegEx(sWorkingDir, sPNPatern, TopDirectoryOnly) 
	For Each oFile In oFiles 
		dbImportPN = oFile.Name
	Next 
	
	Set oFiles = Nothing
	Set oFile = Nothing
	Set fs = Nothing
	
	'dbImportPN = "{Primanotenplan_2018_Primanotenplan}.IMD" ' "{Primanotenplan_" & sAktuelleGJAHR & "}.IMD"
	sPfadOBRDesc = oSC.GetKnownLocationPath(11) & "\SK_FuR" & "\OBR_Konten.RDF"
	
	Call Import(sPath, sEquation)

	If (sDialogResultCase = "1") Then
		'Call RenameDataName
		sPathOBR = oPara.Get4Project ("sPathOBR")
		Call ImportOBR(sAktuelleGJAHR, sPathOBR, sPfadOBRDesc, sEquation)
		Call RenameField(dbImport,"WERT","WERTSTELLUNG_ORG")
		Call AddFieldUmsatz(dbImport, sAktuelleGJAHR)
		sAktuelleOBR = dbImportOBR
		dbNachbuchzuOBR = PrepareSalesData(dbImport, sAktuelleOBR)
		Call RemoveTags(Client.WorkingDirectory & "{Umsätze_zu_OBR_Gesamt_mit_Buchungskennzeichen}.IMD")
		Call UpdateUmsatzSaldo(sAktuelleOBR)
		Call JoinGesamtUmsatzNachbuchung(dbNachbuchzuOBR, sEquation)
		'SmartContext.TestResultFiles.Clear
		Client.RefreshFileExplorer
		
	ElseIf (sDialogResultCase = "2") Then
		Call RenameField(dbImport,"WERT","WERTSTELLUNG_ORG")
		Call AddFieldUmsatz(dbImport, sAktuelleGJAHR)
		sAktuelleOBR = "{OBR_Konten_" & sAktuelleGJAHR & "}.IMD"
		dbNachbuchzuOBR = PrepareSalesData(dbImport, sAktuelleOBR)
		Call RemoveTags(Client.WorkingDirectory & "{Umsätze_zu_OBR_Gesamt_mit_Buchungskennzeichen}.IMD")
		Call JoinGesamtUmsatzNachbuchung(dbNachbuchzuOBR, sEquation)
		'SmartContext.TestResultFiles.Clear
		Client.RefreshFileExplorer
	
	ElseIf (sDialogResultCase = "3") Then
		'Call RenameDataName
		sPathOBR = oPara.Get4Project ("sPathOBR")
		Call ImportOBR(sAktuelleGJAHR, sPathOBR, sPfadOBRDesc, sEquation)
		Call RenameField(dbImport,"WERT","WERTSTELLUNG_ORG")
		Call AddFieldUmsatz(dbImport, sAktuelleGJAHR)
		sAktuelleOBR = dbImportOBR
		dbNachbuchzuOBR = PrepareSalesData(dbImport, sAktuelleOBR)
		Client.RefreshFileExplorer
	
	ElseIf (sDialogResultCase = "4") Then
		sAktuelleOBR = "{OBR_Konten_" & sAktuelleGJAHR & "}.IMD"
		If oSC.FileExists(sAktuelleOBR, "") Then 
			Call RenameField(dbImport,"WERT","WERTSTELLUNG_ORG")
			Call AddFieldUmsatz(dbImport, sAktuelleGJAHR)
			dbNachbuchzuOBR = PrepareSalesData(dbImport, sAktuelleOBR)
			Client.RefreshFileExplorer
		End If
	End If
	
	If (sDialogResultCase = "1") Then
		oLog.LogMessage "Beginn Tagging"
		' Set tagging for Umsätze zu OBR Gesamt mit Buchungskennzeichen
		Call AssignAnotherTag(dbNachbuchzuOBR)
		Call AssignAnotherTag(Client.WorkingDirectory & "{Umsätze_zu_OBR_Gesamt_mit_Buchungskennzeichen}.IMD")
		Call AssignAnotherTag(Client.WorkingDirectory & "-SKA00_Umsätze_zu_OBR_automatisch.IMD")
		'Call AssignAnotherTag("-SKA00_Automatische_Buchungen_je_KtoRahmen.IMD") ' 25.07.2022 table is not created in the import routine anymore, instead the audit tests are associated with "-SKA00_UmsÃ¤tze_zu_OBR_automatisch.IMD"
		Call AssignAnotherTag(Client.WorkingDirectory & "-SKA00_Umsätze_zu_OBR_in_EUR_automatisch.IMD")
		Call AssignAnotherTag(Client.WorkingDirectory & "-SKA00_Umsätze_zu_OBR_nicht_in_EUR_automatisch.IMD")
		Call AssignAnotherTag(Client.WorkingDirectory & "-SKA00_Umsätze_zu_OBR_manuell.IMD")
		'Call AssignAnotherTag("-SKA00_Manuelle_Buchungen_je_KtoRahmen.IMD") ' 25.07.2022 table is not created in the import routine anymore, instead the audit tests are associated with "-SKA00_UmsÃ¤tze_zu_OBR_manuell.IMD"
		Call AssignAnotherTag(Client.WorkingDirectory  & "-SKA00_Umsätze_zu_OBR_in_EUR_manuell.IMD")
		'Berrechnung und Logi wird zum PS verschoben 
		'Basisdatei "-SKA00_Umsätze_zu_OBR_in_EUR_manuell.IMD"
		Call AssignAnotherTag(Client.WorkingDirectory & "-SKA00_HabenBuchungen_auf_SollKonten_zu_OBR_in_EUR.IMD")
		Call AssignAnotherTag(Client.WorkingDirectory & "-SKA00_SollBuchungen_auf_HabenKonten_zu_OBR_in_EUR.IMD")
		Call AssignAnotherTag(Client.WorkingDirectory & "-SKA00_Storno_HabenBuchungen_auf_SollKonten_zu_OBR_in_EUR.IMD")
		Call AssignAnotherTag(Client.WorkingDirectory & "-SKA00_Storno_SollBuchungen_auf_HabenKonten_zu_OBR_in_EUR.IMD")
		Call AssignAnotherTag(Client.WorkingDirectory & "-SKA00_Umsätze_zu_OBR_nicht_in_EUR_manuell.IMD")
		' AS 18.11.2020: Additional Tagging of {OBR_Konten_YYYY} for additional audit tests App Version 1.2.0
		Call AssignAnotherTag(Client.WorkingDirectory & sAktuelleOBR)
		oLog.LogMessage "Ende der Tagging"
		
	ElseIf (sDialogResultCase = "2") Then
		oLog.LogMessage "Beginn test remove Tagging"
		' Set tagging for Umsätze zu OBR Gesamt mit Buchungskennzeichen
		Call AssignAnotherTag(dbNachbuchzuOBR)
		Call AssignAnotherTag(Client.WorkingDirectory & "{Umsätze_zu_OBR_Gesamt_mit_Buchungskennzeichen}.IMD")
		Call AssignAnotherTag(Client.WorkingDirectory & "-SKA00_Umsätze_zu_OBR_automatisch.IMD")
		'Call AssignAnotherTag("-SKA00_Automatische_Buchungen_je_KtoRahmen.IMD") ' 25.07.2022 table is not created in the import routine anymore, instead the audit tests are associated with "-SKA00_UmsÃ¤tze_zu_OBR_automatisch.IMD"
		Call AssignAnotherTag(Client.WorkingDirectory & "-SKA00_Umsätze_zu_OBR_in_EUR_automatisch.IMD")
		Call AssignAnotherTag(Client.WorkingDirectory & "-SKA00_Umsätze_zu_OBR_nicht_in_EUR_automatisch.IMD")
		Call AssignAnotherTag(Client.WorkingDirectory & "-SKA00_Umsätze_zu_OBR_manuell.IMD")
		'Call AssignAnotherTag("-SKA00_Manuelle_Buchungen_je_KtoRahmen.IMD") ' 25.07.2022 table is not created in the import routine anymore, instead the audit tests are associated with "-SKA00_UmsÃ¤tze_zu_OBR_manuell.IMD"
		Call AssignAnotherTag(Client.WorkingDirectory  & "-SKA00_Umsätze_zu_OBR_in_EUR_manuell.IMD")
		'Berrechnung und Logi wird zum PS verschoben 
		'Basisdatei "-SKA00_Umsätze_zu_OBR_in_EUR_manuell.IMD"
		Call AssignAnotherTag(Client.WorkingDirectory & "-SKA00_HabenBuchungen_auf_SollKonten_zu_OBR_in_EUR.IMD")
		Call AssignAnotherTag(Client.WorkingDirectory & "-SKA00_SollBuchungen_auf_HabenKonten_zu_OBR_in_EUR.IMD")
		Call AssignAnotherTag(Client.WorkingDirectory & "-SKA00_Storno_HabenBuchungen_auf_SollKonten_zu_OBR_in_EUR.IMD")
		Call AssignAnotherTag(Client.WorkingDirectory & "-SKA00_Storno_SollBuchungen_auf_HabenKonten_zu_OBR_in_EUR.IMD")
		Call AssignAnotherTag(Client.WorkingDirectory & "-SKA00_Umsätze_zu_OBR_nicht_in_EUR_manuell.IMD")
		oLog.LogMessage "Ende der test remove Tagging"
	
	ElseIf (sDialogResultCase = "3") Then
		oLog.LogMessage "Beginn Tagging"
		' Set tagging for Umsätze zu OBR Gesamt mit Buchungskennzeichen
		Call AssignAnotherTag(dbNachbuchzuOBR)
		Call AssignAnotherTag(Client.WorkingDirectory & sAktuelleOBR)
		oLog.LogMessage "Ende der Tagging"
	
	Elseif (sDialogResultCase = "4") Then
		If oSC.FileExists(sAktuelleOBR, "") Then 
			oLog.LogMessage "Beginn Tagging"
			' Set tagging for Umsätze zu OBR Gesamt mit Buchungskennzeichen
			Call AssignAnotherTag(dbNachbuchzuOBR)
			oLog.LogMessage "Ende der Tagging"
		Else
			oLog.LogMessage "Beginn Tagging"
			' Set tagging for Umsätze zu OBR Gesamt mit Buchungskennzeichen
			Call AssignAnotherTag(dbImport)
			oLog.LogMessage "Ende der Tagging"
		End If
	End If
	
	Set oSC = Nothing 
	Set oTM = Nothing 
	Set oLog = Nothing 
	Set oProtectIP = Nothing 
	Set oPara = Nothing 
	
	Exit Sub
ErrorHandler:
	Call LogSmartAnalyzerError("")
End Sub

Function RemoveTags(ByVal databaseName As String)

Dim tagger As Object
Dim oDB as Object
	Set oDB = Client.OpenDatabase(databaseName)
	If oSC.TagExists(oDB,"acc!NABU") Then
		oDB.Close
		Set oDB = Nothing
		Set tagger = oTM.Tagging(databaseName)
		tagger.NoSharedTagging = True    ' always do it to avoid server-related operations
		tagger.RemoveTag "acc!KONTO_NR"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!KONTO_NR"
		tagger.RemoveTag "acc!KONTO_BEZ"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!KONTO_BEZ"
		tagger.RemoveTag "acc!BUDAT"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!BUDAT"
		tagger.RemoveTag "acc!WERTDAT"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!WERTDAT"
		tagger.RemoveTag "acc!BETRAG"
		SmartContext.Log.LogMessage "tagID removed: " &  "acc!BETRAG"
		tagger.RemoveTag "acc!WKZ"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!WKZ"
		tagger.RemoveTag "acc!TEXT"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!TEXT"
		tagger.RemoveTag "acc!KTO_RAHMEN"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!KTO_RAHMEN"
		tagger.RemoveTag "acc!AUFTRAGG_KTO"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!AUFTRAGG_KTO"
		tagger.RemoveTag "acc!PN"
		SmartContext.Log.LogMessage "tagID removed: " &  "acc!PN"
		tagger.RemoveTag "acc!VERZW"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!VERZW"
		tagger.RemoveTag "acc!SHK"
		SmartContext.Log.LogMessage "tagID removed: " &  "acc!SHK"
		'tagger.RemoveTag "acc!RAHMNR_2"
		'SmartContext.Log.LogMessage "tagID removed: " & "acc!RAHMNR_2"
		tagger.RemoveTag "acc!RAHMNR_3"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!RAHMNR_3"
		tagger.RemoveTag "acc!NAGGRENZE"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!NAGGRENZE"
		tagger.RemoveTag "acc!REL"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!REL"
		tagger.RemoveTag "acc!KTO"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!KTO"
		tagger.RemoveTag "acc!BEZ"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!BEZ"
		tagger.RemoveTag "acc!AZ9SALDO"
		SmartContext.Log.LogMessage "tagID removed: " &  "acc!AZ9SALDO"
		tagger.RemoveTag "acc!SHK_OBR"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!SHK_OBR"
		tagger.RemoveTag "acc!RAHMNR_2_OBR"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!RAHMNR_2_OBR"
		tagger.RemoveTag "acc!POSITION_AKT_JAHR"
		SmartContext.Log.LogMessage "tagID removed: " &  "acc!POSITION_AKT_JAHR"
		tagger.RemoveTag "acc!POSSHORT"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!POSSHORT"
		tagger.RemoveTag "acc!ERDAT"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!ERDAT"
		tagger.RemoveTag "acc!AUFDAT"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!AUFDAT"
		tagger.RemoveTag "acc!MANBUCH"
		SmartContext.Log.LogMessage "tagID removed: " &  "acc!MANBUCH"
		tagger.RemoveTag "acc!BUCHUNGSKATEGORIE_BV"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!BUCHUNGSKATEGORIE_BV"
		tagger.RemoveTag "acc!NABU"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!NABU"
		tagger.RemoveTag "acc!BM"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!BM"
		tagger.RemoveTag "acc!RUECKBUCHUNG"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!RUECKBUCHUNG"
		tagger.Save
		Set tagger = Nothing  
	Else
		oDB.Close
		Set oDB = Nothing
		Set tagger = oTM.Tagging(databaseName)
		tagger.NoSharedTagging = True    ' always do it to avoid server-related operations
		tagger.RemoveTag "acc!KONTO_NR"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!KONTO_NR"
		tagger.RemoveTag "acc!KONTO_BEZ"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!KONTO_BEZ"
		tagger.RemoveTag "acc!BUDAT"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!BUDAT"
		tagger.RemoveTag "acc!WERTDAT"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!WERTDAT"
		tagger.RemoveTag "acc!BETRAG"
		SmartContext.Log.LogMessage "tagID removed: " &  "acc!BETRAG"
		tagger.RemoveTag "acc!WKZ"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!WKZ"
		tagger.RemoveTag "acc!TEXT"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!TEXT"
		tagger.RemoveTag "acc!KTO_RAHMEN"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!KTO_RAHMEN"
		tagger.RemoveTag "acc!AUFTRAGG_KTO"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!AUFTRAGG_KTO"
		tagger.RemoveTag "acc!PN"
		SmartContext.Log.LogMessage "tagID removed: " &  "acc!PN"
		tagger.RemoveTag "acc!VERZW"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!VERZW"
		tagger.RemoveTag "acc!SHK"
		SmartContext.Log.LogMessage "tagID removed: " &  "acc!SHK"
		'tagger.RemoveTag "acc!RAHMNR_2"
		'SmartContext.Log.LogMessage "tagID removed: " & "acc!RAHMNR_2"
		tagger.RemoveTag "acc!RAHMNR_3"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!RAHMNR_3"
		tagger.RemoveTag "acc!NAGGRENZE"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!NAGGRENZE"
		tagger.RemoveTag "acc!REL"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!REL"
		tagger.RemoveTag "acc!KTO"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!KTO"
		tagger.RemoveTag "acc!BEZ"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!BEZ"
		tagger.RemoveTag "acc!AZ9SALDO"
		SmartContext.Log.LogMessage "tagID removed: " &  "acc!AZ9SALDO"
		tagger.RemoveTag "acc!SHK_OBR"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!SHK_OBR"
		tagger.RemoveTag "acc!RAHMNR_2_OBR"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!RAHMNR_2_OBR"
		tagger.RemoveTag "acc!POSITION_AKT_JAHR"
		SmartContext.Log.LogMessage "tagID removed: " &  "acc!POSITION_AKT_JAHR"
		tagger.RemoveTag "acc!POSSHORT"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!POSSHORT"
		tagger.RemoveTag "acc!ERDAT"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!ERDAT"
		tagger.RemoveTag "acc!AUFDAT"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!AUFDAT"
		tagger.RemoveTag "acc!MANBUCH"
		SmartContext.Log.LogMessage "tagID removed: " &  "acc!MANBUCH"
		tagger.RemoveTag "acc!BUCHUNGSKATEGORIE_BV"
		SmartContext.Log.LogMessage "tagID removed: " & "acc!BUCHUNGSKATEGORIE_BV"
		tagger.Save
		Set tagger = Nothing  
	End If
End Function

Function AssignAnotherTag(ByVal databaseName As String)
Dim oTagger As Object
Dim tagID As String
Dim columnName As String
Dim sStandardFilter As String
Dim eqnBuilder As Object
Dim resultObject As Object
Dim sTaggedTable As String

	If oSC.FileExists(databaseName, "") Then
	Set db = Client.OpenDatabase(databaseName)
	If db.Count > 0 Then
		db.Close
		Set db = Nothing
		Set oTM = SmartContext.MacroCommands.TagManagement
		Select Case databaseName
			Case Client.WorkingDirectory & "{Umsätze_zu_OBR_Gesamt_mit_Buchungskennzeichen}.IMD"
				Set oTagger = oTM.AssociatingTagging(databaseName)
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
				oTagger.SetTag "acc!POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				oTagger.SetTag "acc!POSSHORT", "POSITION_SHORT"
				oTagger.SetTag "acc!ERDAT", "ERÖFFNUNG"
				oTagger.SetTag "acc!AUFDAT", "AUFLÖSUNG"
				oTagger.SetTag "acc!MANBUCH", "MANUELLE_BUCHUNGEN"
				oTagger.SetTag "acc!BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				oTagger.SetTag "acc!NABU", "NABU"
				oTagger.SetTag "acc!BM", "BM"
				oTagger.SetTag "acc!RUECKBUCHUNG", "RUECKBUCHUNG"
				oTagger.Save
				Set oTagger = Nothing
				sStandardFilter = "SKAUmsatzGesamt"
			Case Client.WorkingDirectory & "-SKA00_Umsätze_zu_OBR_automatisch.IMD"
				Set oTagger = oTM.AssociatingTagging(databaseName)
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
				oTagger.SetTag "acc!AUTO_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				oTagger.SetTag "acc!AUTO_POSSHORT", "POSITION_SHORT"
				oTagger.SetTag "acc!AUTO_ERDAT", "ERÖFFNUNG"
				oTagger.SetTag "acc!AUTO_AUFDAT", "AUFLÖSUNG"
				oTagger.SetTag "acc!AUTO_MANBUCH", "MANUELLE_BUCHUNGEN"
				oTagger.SetTag "acc!AUTO_WERTJAHR", "WERTSTELLUNG_JAHR"
				oTagger.SetTag "acc!AUTO_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				oTagger.SetTag "acc!AUTO_NABU", "NABU"
				oTagger.SetTag "acc!AUTO_BM", "BM"
				oTagger.SetTag "acc!AUTO_RUECKBUCHUNG", "RUECKBUCHUNG"
				oTagger.Save
				Set oTagger = Nothing
				sStandardFilter = "SKAUmsatzAuto"
			Case Client.WorkingDirectory & "-SKA00_Automatische_Buchungen_je_KtoRahmen.IMD"
				Set oTagger = oTM.AssociatingTagging(databaseName)
				oTagger.SetTag "acc!AJEKTO_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
				oTagger.SetTag "acc!AJEKTO_ANZAHL", "ANZ_SAETZE"
				oTagger.SetTag "acc!AJEKTO_SUMME", "BETRAG_SUMME"
				oTagger.SetTag "acc!AJEKTO_MAX", "BETRAG_MAX"
				oTagger.SetTag "acc!AJEKTO_MIN", "BETRAG_MIN"
				oTagger.SetTag "acc!AJEKTO_DURCHSCHNITT", "BETRAG_DURCHSCHNITT"
				oTagger.Save
				Set oTagger = Nothing
				sStandardFilter = "SKAUmsatzAutoJeKto"
			Case Client.WorkingDirectory & "-SKA00_Umsätze_zu_OBR_in_EUR_automatisch.IMD"
				Set oTagger = oTM.AssociatingTagging(databaseName)
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
				oTagger.SetTag "acc!AOE_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				oTagger.SetTag "acc!AOE_POSSHORT", "POSITION_SHORT"
				oTagger.SetTag "acc!AOE_ERDAT", "ERÖFFNUNG"
				oTagger.SetTag "acc!AOE_AUFDAT", "AUFLÖSUNG"
				oTagger.SetTag "acc!AOE_MANBUCH", "MANUELLE_BUCHUNGEN"
				oTagger.SetTag "acc!AOE_WERTJAHR", "WERTSTELLUNG_JAHR"
				oTagger.SetTag "acc!AOE_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				oTagger.SetTag "acc!AOE_NABU", "NABU"
				oTagger.SetTag "acc!AOE_BM", "BM"
				oTagger.SetTag "acc!AOE_RUECKBUCHUNG", "RUECKBUCHUNG"
				oTagger.Save
				Set oTagger = Nothing
				sStandardFilter = "SKAUmsatzAutoInEUR"
			Case Client.WorkingDirectory & "-SKA00_Umsätze_zu_OBR_nicht_in_EUR_automatisch.IMD"
				Set oTagger = oTM.AssociatingTagging(databaseName)
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
				oTagger.SetTag "acc!AONE_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				oTagger.SetTag "acc!AONE_POSSHORT", "POSITION_SHORT"
				oTagger.SetTag "acc!AONE_ERDAT", "ERÖFFNUNG"
				oTagger.SetTag "acc!AONE_AUFDAT", "AUFLÖSUNG"
				oTagger.SetTag "acc!AONE_MANBUCH", "MANUELLE_BUCHUNGEN"
				oTagger.SetTag "acc!AONE_WERTJAHR", "WERTSTELLUNG_JAHR"
				oTagger.SetTag "acc!AONE_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				oTagger.SetTag "acc!AONE_NABU", "NABU"
				oTagger.SetTag "acc!AONE_BM", "BM"
				oTagger.SetTag "acc!AONE_RUECKBUCHUNG", "RUECKBUCHUNG"
				oTagger.Save
				Set oTagger = Nothing
				sStandardFilter = "SKAUmsatzAutoNichtEUR"
			Case Client.WorkingDirectory & "-SKA00_Umsätze_zu_OBR_manuell.IMD"
				Set oTagger = oTM.AssociatingTagging(databaseName)
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
				oTagger.SetTag "acc!MAN_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				oTagger.SetTag "acc!MAN_POSSHORT", "POSITION_SHORT"
				oTagger.SetTag "acc!MAN_ERDAT", "ERÖFFNUNG"
				oTagger.SetTag "acc!MAN_AUFDAT", "AUFLÖSUNG"
				oTagger.SetTag "acc!MAN_MANBUCH", "MANUELLE_BUCHUNGEN"
				oTagger.SetTag "acc!MAN_WERTJAHR", "WERTSTELLUNG_JAHR"
				'oTagger.SetTag "acc!MAN_RELBETRAG", "RELEVANTER_BETRAG"
				oTagger.SetTag "acc!MAN_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				oTagger.SetTag "acc!MAN_NABU", "NABU"
				oTagger.SetTag "acc!MAN_BM", "BM"
				oTagger.SetTag "acc!MAN_RUECKBUCHUNG", "RUECKBUCHUNG"
				oTagger.Save
				Set oTagger = Nothing
				sStandardFilter = "SKAUmsatzManuell"
			Case Client.WorkingDirectory & "-SKA00_Manuelle_Buchungen_je_KtoRahmen.IMD"
				Set oTagger = oTM.AssociatingTagging(databaseName)
				oTagger.SetTag "acc!MJEKTO_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
				oTagger.SetTag "acc!MJEKTO_ANZAHL", "ANZ_SAETZE"
				oTagger.SetTag "acc!MJEKTO_SUMME", "BETRAG_SUMME"
				oTagger.SetTag "acc!MJEKTO_MAX", "BETRAG_MAX"
				oTagger.SetTag "acc!MJEKTO_MIN", "BETRAG_MIN"
				oTagger.SetTag "acc!MJEKTO_DURCHSCHNITT", "BETRAG_DURCHSCHNITT"
				oTagger.Save
				Set oTagger = Nothing
				sStandardFilter = "SKAUmsatzManuellJeKto"
			Case Client.WorkingDirectory & "-SKA00_Umsätze_zu_OBR_in_EUR_manuell.IMD"
				Set oTagger = oTM.AssociatingTagging(databaseName)
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
				oTagger.SetTag "acc!MOE_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				oTagger.SetTag "acc!MOE_POSSHORT", "POSITION_SHORT"
				oTagger.SetTag "acc!MOE_ERDAT", "ERÖFFNUNG"
				oTagger.SetTag "acc!MOE_AUFDAT", "AUFLÖSUNG"
				oTagger.SetTag "acc!MOE_MANBUCH", "MANUELLE_BUCHUNGEN"
				oTagger.SetTag "acc!MOE_WERTJAHR", "WERTSTELLUNG_JAHR"
				'oTagger.SetTag "acc!MOE_RELBETRAG", "RELEVANTER_BETRAG"
				oTagger.SetTag "acc!MOE_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				oTagger.SetTag "acc!MOE_NABU", "NABU"
				oTagger.SetTag "acc!MOE_BM", "BM"
				oTagger.SetTag "acc!MOE_RUECKBUCHUNG", "RUECKBUCHUNG"
				oTagger.Save
				Set oTagger = Nothing
				sStandardFilter = "SKAUmsatzManuellInEUR"
			Case Client.WorkingDirectory & "-SKA00_HabenBuchungen_auf_SollKonten_zu_OBR_in_EUR.IMD"
				Set oTagger = oTM.AssociatingTagging(databaseName)
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
				oTagger.SetTag "acc!HSOE_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				oTagger.SetTag "acc!HSOE_POSSHORT", "POSITION_SHORT"
				oTagger.SetTag "acc!HSOE_ERDAT", "ERÖFFNUNG"
				oTagger.SetTag "acc!HSOE_AUFDAT", "AUFLÖSUNG"
				oTagger.SetTag "acc!HSOE_MANBUCH", "MANUELLE_BUCHUNGEN"
				oTagger.SetTag "acc!HSOE_WERTJAHR", "WERTSTELLUNG_JAHR"
				'oTagger.SetTag "acc!HSOE_RELBETRAG", "RELEVANTER_BETRAG"
				oTagger.SetTag "acc!HSOE_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				oTagger.SetTag "acc!HSOE_NABU", "NABU"
				oTagger.SetTag "acc!HSOE_BM", "BM"
				oTagger.SetTag "acc!HSOE_RUECKBUCHUNG", "RUECKBUCHUNG"
				oTagger.Save
				Set oTagger = Nothing
				sStandardFilter = "SKAHabenAufSollInEUR"
			Case Client.WorkingDirectory & "-SKA00_SollBuchungen_auf_HabenKonten_zu_OBR_in_EUR.IMD"
				Set oTagger = oTM.AssociatingTagging(databaseName)
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
				oTagger.SetTag "acc!SHOE_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				oTagger.SetTag "acc!SHOE_POSSHORT", "POSITION_SHORT"
				oTagger.SetTag "acc!SHOE_ERDAT", "ERÖFFNUNG"
				oTagger.SetTag "acc!SHOE_AUFDAT", "AUFLÖSUNG"
				oTagger.SetTag "acc!SHOE_MANBUCH", "MANUELLE_BUCHUNGEN"
				oTagger.SetTag "acc!SHOE_WERTJAHR", "WERTSTELLUNG_JAHR"
				'oTagger.SetTag "acc!SHOE_RELBETRAG", "RELEVANTER_BETRAG"
				oTagger.SetTag "acc!SHOE_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				oTagger.SetTag "acc!SHOE_NABU", "NABU"
				oTagger.SetTag "acc!SHOE_BM", "BM"
				oTagger.SetTag "acc!SHOE_RUECKBUCHUNG", "RUECKBUCHUNG"
				oTagger.Save
				Set oTagger = Nothing
				sStandardFilter = "SKASollAufHabenInEUR"
			Case Client.WorkingDirectory & "-SKA00_Storno_HabenBuchungen_auf_SollKonten_zu_OBR_in_EUR.IMD"
				Set oTagger = oTM.AssociatingTagging(databaseName)
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
				oTagger.SetTag "acc!SHSOE_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				oTagger.SetTag "acc!SHSOE_POSSHORT", "POSITION_SHORT"
				oTagger.SetTag "acc!SHSOE_ERDAT", "ERÖFFNUNG"
				oTagger.SetTag "acc!SHSOE_AUFDAT", "AUFLÖSUNG"
				oTagger.SetTag "acc!SHSOE_MANBUCH", "MANUELLE_BUCHUNGEN"
				oTagger.SetTag "acc!SHSOE_WERTJAHR", "WERTSTELLUNG_JAHR"
				'oTagger.SetTag "acc!SHSOE_RELBETRAG", "RELEVANTER_BETRAG"
				oTagger.SetTag "acc!SHSOE_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				oTagger.SetTag "acc!SHSOE_NABU", "NABU"
				oTagger.SetTag "acc!SHSOE_BM", "BM"
				oTagger.SetTag "acc!SHSOE_RUECKBUCHUNG", "RUECKBUCHUNG"
				oTagger.Save
				Set oTagger = Nothing
				sStandardFilter = "SKAStornoHabenAufSollInEUR"
			Case Client.WorkingDirectory & "-SKA00_Storno_SollBuchungen_auf_HabenKonten_zu_OBR_in_EUR.IMD"
				Set oTagger = oTM.AssociatingTagging(databaseName)
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
				oTagger.SetTag "acc!SSHOE_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				oTagger.SetTag "acc!SSHOE_POSSHORT", "POSITION_SHORT"
				oTagger.SetTag "acc!SSHOE_ERDAT", "ERÖFFNUNG"
				oTagger.SetTag "acc!SSHOE_AUFDAT", "AUFLÖSUNG"
				oTagger.SetTag "acc!SSHOE_MANBUCH", "MANUELLE_BUCHUNGEN"
				oTagger.SetTag "acc!SSHOE_WERTJAHR", "WERTSTELLUNG_JAHR"
				'oTagger.SetTag "acc!SSHOE_RELBETRAG", "RELEVANTER_BETRAG"
				oTagger.SetTag "acc!SSHOE_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				oTagger.SetTag "acc!SSHOE_NABU", "NABU"
				oTagger.SetTag "acc!SSHOE_BM", "BM"
				oTagger.SetTag "acc!SSHOE_RUECKBUCHUNG", "RUECKBUCHUNG"
				oTagger.Save
				Set oTagger = Nothing
				sStandardFilter = "SKAStornoSollAufHabenInEUR"
			Case Client.WorkingDirectory & "-SKA00_Umsätze_zu_OBR_nicht_in_EUR_manuell.IMD"
				Set oTagger = oTM.AssociatingTagging(databaseName)
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
				oTagger.SetTag "acc!MONE_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				oTagger.SetTag "acc!MONE_POSSHORT", "POSITION_SHORT"
				oTagger.SetTag "acc!MONE_ERDAT", "ERÖFFNUNG"
				oTagger.SetTag "acc!MONE_AUFDAT", "AUFLÖSUNG"
				oTagger.SetTag "acc!MONE_MANBUCH", "MANUELLE_BUCHUNGEN"
				oTagger.SetTag "acc!MONE_WERTJAHR", "WERTSTELLUNG_JAHR"
				'oTagger.SetTag "acc!MONE_RELBETRAG", "RELEVANTER_BETRAG"
				oTagger.SetTag "acc!MONE_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				oTagger.SetTag "acc!MONE_NABU", "NABU"
				oTagger.SetTag "acc!MONE_BM", "BM"
				oTagger.SetTag "acc!MONE_RUECKBUCHUNG", "RUECKBUCHUNG"
				oTagger.Save
				Set oTagger = Nothing
				sStandardFilter = "SKAUmsatzManuellNichtEUR"
			Case Client.WorkingDirectory & "-SKA00_HabenBuchungen_auf_SollKonten_zu_OBR_nicht_in_EUR.IMD"
				Set oTagger = oTM.AssociatingTagging(databaseName)
				oTagger.SetTag "acc!HSONE_KONTO_NR", "KONTO_NR"
				oTagger.SetTag "acc!HSONE_KONTO_BEZ", "KONTOBEZEICHNUNG"
				oTagger.SetTag "acc!HSONE_BUDAT", "BUCHUNGSDATUM"
				oTagger.SetTag "acc!HSONE_WERTDAT", "WERTSTELLUNG"
				oTagger.SetTag "acc!HSONE_BETRAG", "BETRAG"
				oTagger.SetTag "acc!HSONE_WKZ", "WKZ"
				oTagger.SetTag "acc!HSONE_TEXT", "TEXTSCHLÜSSEL"
				oTagger.SetTag "acc!HSONE_KTO_RAHMEN", "KTO_RAHMEN"
				oTagger.SetTag "acc!HSONE_AUFTRAGG_KTO", "AUFTRAGG_KTO"
				oTagger.SetTag "acc!HSONE_PN", "PN"
				oTagger.SetTag "acc!HSONE_VERZW", "VERWENDUNGSZWECK"
				oTagger.SetTag "acc!HSONE_SHK", "SHK"
				oTagger.SetTag "acc!HSONE_RAHMNR_2", "RAHMENNR_2STELLIG"
				oTagger.SetTag "acc!HSONE_RAHMNR_3", "RAHMENNR_3STELLIG"
				oTagger.SetTag "acc!HSONE_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
				oTagger.SetTag "acc!HSONE_REL", "RELEVANT"
				oTagger.SetTag "acc!HSONE_KTO", "KONTO"
				oTagger.SetTag "acc!HSONE_BEZ", "BEZEICHNUNG"
				oTagger.SetTag "acc!HSONE_AZ9SALDO", "AZ9_SALDO"
				oTagger.SetTag "acc!HSONE_SHK_OBR", "SHK1"
				oTagger.SetTag "acc!HSONE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
				oTagger.SetTag "acc!HSONE_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				oTagger.SetTag "acc!HSONE_POSSHORT", "POSITION_SHORT"
				oTagger.SetTag "acc!HSONE_ERDAT", "ERÃ–FFNUNG"
				oTagger.SetTag "acc!HSONE_AUFDAT", "AUFLÃ–SUNG"
				oTagger.SetTag "acc!HSONE_MANBUCH", "MANUELLE_BUCHUNGEN"
				oTagger.SetTag "acc!HSONE_WERTJAHR", "WERTSTELLUNG_JAHR"
				'oTagger.SetTag "acc!HSONE_RELBETRAG", "RELEVANTER_BETRAG"
				oTagger.SetTag "acc!HSONE_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				oTagger.SetTag "acc!HSONE_NABU", "NABU"
				oTagger.SetTag "acc!HSONE_BM", "BM"
				oTagger.SetTag "acc!HSONE_RUECKBUCHUNG", "RUECKBUCHUNG"
				oTagger.Save
				Set oTagger = Nothing
				sStandardFilter = "SKAHabenAufSollNichtEUR"
			Case Client.WorkingDirectory & "-SKA00_SollBuchungen_auf_HabenKonten_zu_OBR_nicht_in_EUR.IMD"
				Set oTagger = oTM.AssociatingTagging(databaseName)
				oTagger.SetTag "acc!SHONE_KONTO_NR", "KONTO_NR"
				oTagger.SetTag "acc!SHONE_KONTO_BEZ", "KONTOBEZEICHNUNG"
				oTagger.SetTag "acc!SHONE_BUDAT", "BUCHUNGSDATUM"
				oTagger.SetTag "acc!SHONE_WERTDAT", "WERTSTELLUNG"
				oTagger.SetTag "acc!SHONE_BETRAG", "BETRAG"
				oTagger.SetTag "acc!SHONE_WKZ", "WKZ"
				oTagger.SetTag "acc!SHONE_TEXT", "TEXTSCHLÜSSEL"
				oTagger.SetTag "acc!SHONE_KTO_RAHMEN", "KTO_RAHMEN"
				oTagger.SetTag "acc!SHONE_AUFTRAGG_KTO", "AUFTRAGG_KTO"
				oTagger.SetTag "acc!SHONE_PN", "PN"
				oTagger.SetTag "acc!SHONE_VERZW", "VERWENDUNGSZWECK"
				oTagger.SetTag "acc!SHONE_SHK", "SHK"
				oTagger.SetTag "acc!SHONE_RAHMNR_2", "RAHMENNR_2STELLIG"
				oTagger.SetTag "acc!SHONE_RAHMNR_3", "RAHMENNR_3STELLIG"
				oTagger.SetTag "acc!SHONE_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
				oTagger.SetTag "acc!SHONE_REL", "RELEVANT"
				oTagger.SetTag "acc!SHONE_KTO", "KONTO"
				oTagger.SetTag "acc!SHONE_BEZ", "BEZEICHNUNG"
				oTagger.SetTag "acc!SHONE_AZ9SALDO", "AZ9_SALDO"
				oTagger.SetTag "acc!SHONE_SHK_OBR", "SHK1"
				oTagger.SetTag "acc!SHONE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
				oTagger.SetTag "acc!SHONE_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				oTagger.SetTag "acc!SHONE_POSSHORT", "POSITION_SHORT"
				oTagger.SetTag "acc!SHONE_ERDAT", "ERÖFFNUNG"
				oTagger.SetTag "acc!SHONE_AUFDAT", "AUFLÖSUNG"
				oTagger.SetTag "acc!SHONE_MANBUCH", "MANUELLE_BUCHUNGEN"
				oTagger.SetTag "acc!SHONE_WERTJAHR", "WERTSTELLUNG_JAHR"
				'oTagger.SetTag "acc!SHONE_RELBETRAG", "RELEVANTER_BETRAG"
				oTagger.SetTag "acc!SHONE_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				oTagger.SetTag "acc!SHONE_NABU", "NABU"
				oTagger.SetTag "acc!SHONE_BM", "BM"
				oTagger.SetTag "acc!SHONE_RUECKBUCHUNG", "RUECKBUCHUNG"
				oTagger.Save
				Set oTagger = Nothing
				sStandardFilter = "SKASollAufHabenNichtEUR"
			Case Client.WorkingDirectory & "-SKA00_Storno_HabenBuchungen_auf_SollKonten_zu_OBR_nicht_in_EUR.IMD"
				Set oTagger = oTM.AssociatingTagging(databaseName)
				oTagger.SetTag "acc!SHSONE_KONTO_NR", "KONTO_NR"
				oTagger.SetTag "acc!SHSONE_KONTO_BEZ", "KONTOBEZEICHNUNG"
				oTagger.SetTag "acc!SHSONE_BUDAT", "BUCHUNGSDATUM"
				oTagger.SetTag "acc!SHSONE_WERTDAT", "WERTSTELLUNG"
				oTagger.SetTag "acc!SHSONE_BETRAG", "BETRAG"
				oTagger.SetTag "acc!SHSONE_WKZ", "WKZ"
				oTagger.SetTag "acc!SHSONE_TEXT", "TEXTSCHLÜSSEL"
				oTagger.SetTag "acc!SHSONE_KTO_RAHMEN", "KTO_RAHMEN"
				oTagger.SetTag "acc!SHSONE_AUFTRAGG_KTO", "AUFTRAGG_KTO"
				oTagger.SetTag "acc!SHSONE_PN", "PN"
				oTagger.SetTag "acc!SHSONE_VERZW", "VERWENDUNGSZWECK"
				oTagger.SetTag "acc!SHSONE_SHK", "SHK"
				oTagger.SetTag "acc!SHSONE_RAHMNR_2", "RAHMENNR_2STELLIG"
				oTagger.SetTag "acc!SHSONE_RAHMNR_3", "RAHMENNR_3STELLIG"
				oTagger.SetTag "acc!SHSONE_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
				oTagger.SetTag "acc!SHSONE_REL", "RELEVANT"
				oTagger.SetTag "acc!SHSONE_KTO", "KONTO"
				oTagger.SetTag "acc!SHSONE_BEZ", "BEZEICHNUNG"
				oTagger.SetTag "acc!SHSONE_AZ9SALDO", "AZ9_SALDO"
				oTagger.SetTag "acc!SHSONE_SHK_OBR", "SHK1"
				oTagger.SetTag "acc!SHSONE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
				oTagger.SetTag "acc!SHSONE_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				oTagger.SetTag "acc!SHSONE_POSSHORT", "POSITION_SHORT"
				oTagger.SetTag "acc!SHSONE_ERDAT", "ERÖFFNUNG"
				oTagger.SetTag "acc!SHSONE_AUFDAT", "AUFLÖSUNG"
				oTagger.SetTag "acc!SHSONE_MANBUCH", "MANUELLE_BUCHUNGEN"
				oTagger.SetTag "acc!SHSONE_WERTJAHR", "WERTSTELLUNG_JAHR"
				'oTagger.SetTag "acc!SHSONE_RELBETRAG", "RELEVANTER_BETRAG"
				oTagger.SetTag "acc!SHSONE_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				oTagger.SetTag "acc!SHSONE_NABU", "NABU"
				oTagger.SetTag "acc!SHSONE_BM", "BM"
				oTagger.SetTag "acc!SHSONE_RUECKBUCHUNG", "RUECKBUCHUNG"
				oTagger.Save
				Set oTagger = Nothing
				sStandardFilter = "SKAStornoHabenAufSollNichtEUR"
			Case Client.WorkingDirectory & "-SKA00_Storno_SollBuchungen_auf_HabenKonten_zu_OBR_in_EUR.IMD"
				Set oTagger = oTM.AssociatingTagging(databaseName)
				oTagger.SetTag "acc!SSHONE_KONTO_NR", "KONTO_NR"
				oTagger.SetTag "acc!SSHONE_KONTO_BEZ", "KONTOBEZEICHNUNG"
				oTagger.SetTag "acc!SSHONE_BUDAT", "BUCHUNGSDATUM"
				oTagger.SetTag "acc!SSHONE_WERTDAT", "WERTSTELLUNG"
				oTagger.SetTag "acc!SSHONE_BETRAG", "BETRAG"
				oTagger.SetTag "acc!SSHONE_WKZ", "WKZ"
				oTagger.SetTag "acc!SSHONE_TEXT", "TEXTSCHLÜSSEL"
				oTagger.SetTag "acc!SSHONE_KTO_RAHMEN", "KTO_RAHMEN"
				oTagger.SetTag "acc!SSHONE_AUFTRAGG_KTO", "AUFTRAGG_KTO"
				oTagger.SetTag "acc!SSHONE_PN", "PN"
				oTagger.SetTag "acc!SSHONE_VERZW", "VERWENDUNGSZWECK"
				oTagger.SetTag "acc!SSHONE_SHK", "SHK"
				oTagger.SetTag "acc!SSHONE_RAHMNR_2", "RAHMENNR_2STELLIG"
				oTagger.SetTag "acc!SSHONE_RAHMNR_3", "RAHMENNR_3STELLIG"
				oTagger.SetTag "acc!SSHONE_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
				oTagger.SetTag "acc!SSHONE_REL", "RELEVANT"
				oTagger.SetTag "acc!SSHONE_KTO", "KONTO"
				oTagger.SetTag "acc!SSHONE_BEZ", "BEZEICHNUNG"
				oTagger.SetTag "acc!SSHONE_AZ9SALDO", "AZ9_SALDO"
				oTagger.SetTag "acc!SSHONE_SHK_OBR", "SHK1"
				oTagger.SetTag "acc!SSHONE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
				oTagger.SetTag "acc!SSHONE_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				oTagger.SetTag "acc!SSHONE_POSSHORT", "POSITION_SHORT"
				oTagger.SetTag "acc!SSHONE_ERDAT", "ERÖFFNUNG"
				oTagger.SetTag "acc!SSHONE_AUFDAT", "AUFLÖSUNG"
				oTagger.SetTag "acc!SSHONE_MANBUCH", "MANUELLE_BUCHUNGEN"
				oTagger.SetTag "acc!SSHONE_WERTJAHR", "WERTSTELLUNG_JAHR"
				'oTagger.SetTag "acc!SSHONE_RELBETRAG", "RELEVANTER_BETRAG"
				oTagger.SetTag "acc!SSHONE_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				oTagger.SetTag "acc!SSHONE_NABU", "NABU"
				oTagger.SetTag "acc!SSHONE_BM", "BM"
				oTagger.SetTag "acc!SSHONE_RUECKBUCHUNG", "RUECKBUCHUNG"
				oTagger.Save
				Set oTagger = Nothing
				sStandardFilter = "SKAStornoSollAufHabenNichtEUR"
			Case dbImport
				Set oTagger = oTM.AssociatingTagging(databaseName)
				oTagger.SetTag "acc!SN_KONTO_NR", "KONTO_NR"
				oTagger.SetTag "acc!SN_KONTO_BEZ", "KONTOBEZEICHNUNG"
				oTagger.SetTag "acc!SN_BUDAT", "BUCHUNGSDATUM"
				oTagger.SetTag "acc!SN_BUTAG", "BUCHTAG"
				oTagger.SetTag "acc!SN_WERTDAT", "WERT"
				oTagger.SetTag "acc!SN_BETRAG", "BETRAG"
				oTagger.SetTag "acc!SN_WKZ", "WKZ"
				oTagger.SetTag "acc!SN_TEXT", "TEXTSCHLÜSSEL"
				oTagger.SetTag "acc!SN_KTO_RAHMEN", "KTO_RAHMEN"
				oTagger.SetTag "acc!SN_AUFTRAGG_KTO", "AUFTRAGG_KTO"
				oTagger.SetTag "acc!SN_PN", "PN"
				oTagger.SetTag "acc!SN_VERZW", "VERWENDUNGSZWECK"
				oTagger.SetTag "acc!SN_NABU", "NABU"
				oTagger.SetTag "acc!SN_BM", "BM"
				oTagger.SetTag "acc!SN_RUECKBUCHUNG", "RUECKBUCHUNG"
				oTagger.Save
				Set oTagger = Nothing
				sStandardFilter = "SKASingleNachbuchungen"
			Case dbNachbuchzuOBR
				Set oTagger = oTM.AssociatingTagging(databaseName)
				oTagger.SetTag "acc!NB_KONTO_NR", "KONTO_NR"
				oTagger.SetTag "acc!NB_KONTO_BEZ", "KONTOBEZEICHNUNG"
				oTagger.SetTag "acc!NB_BUDAT", "BUCHUNGSDATUM"
				oTagger.SetTag "acc!NB_WERTDAT", "WERTSTELLUNG"
				oTagger.SetTag "acc!NB_BETRAG", "BETRAG"
				oTagger.SetTag "acc!NB_WKZ", "WKZ"
				oTagger.SetTag "acc!NB_TEXT", "TEXTSCHLÜSSEL"
				oTagger.SetTag "acc!NB_KTO_RAHMEN", "KTO_RAHMEN"
				oTagger.SetTag "acc!NB_AUFTRAGG_KTO", "AUFTRAGG_KTO"
				oTagger.SetTag "acc!NB_PN", "PN"
				oTagger.SetTag "acc!NB_VERZW", "VERWENDUNGSZWECK"
				oTagger.SetTag "acc!NB_SHK", "SHK"
				oTagger.SetTag "acc!NB_RAHMNR_2", "RAHMENNR_2STELLIG"
				oTagger.SetTag "acc!NB_RAHMNR_3", "RAHMENNR_3STELLIG"
				oTagger.SetTag "acc!NB_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
				oTagger.SetTag "acc!NB_REL", "RELEVANT"
				oTagger.SetTag "acc!NB_BEZ", "BEZEICHNUNG"
				oTagger.SetTag "acc!NB_AZ9SALDO", "AZ9_SALDO"
				oTagger.SetTag "acc!NB_SHK_OBR", "SHK1"
				oTagger.SetTag "acc!NB_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
				oTagger.SetTag "acc!NB_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				oTagger.SetTag "acc!NB_POSSHORT", "POSITION_SHORT"
				oTagger.SetTag "acc!NB_ERDAT", "ERÖFFNUNG"
				oTagger.SetTag "acc!NB_AUFDAT", "AUFLÖSUNG"
				oTagger.SetTag "acc!NB_MANBUCH", "MANUELLE_BUCHUNGEN"
				oTagger.SetTag "acc!NB_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				oTagger.SetTag "acc!NB_NABU", "NABU"
				oTagger.SetTag "acc!NB_BM", "BM"
				oTagger.SetTag "acc!NB_RUECKBUCHUNG", "RUECKBUCHUNG"
				'oTagger.SetTag "acc!OBR_KONTO_NR", "KONTO"
				oTagger.Save
				Set oTagger = Nothing
				sStandardFilter = "SKANachbuchungenGesamt"
			' AS 18.11.2020: OBR Tagging
			Case Client.WorkingDirectory & sAktuelleOBR
				Set oTagger = oTM.AssociatingTagging(databaseName)
				oTagger.SetTag "acc!OBR_KONTO_NR", "KONTO"
				oTagger.Save
				Set oTagger = Nothing
				sStandardFilter = "SK_FuR_Prüfung_OBR"
			Case Else
		End Select
		Set oTM = Nothing
		Set eqnBuilder = SmartContext.MacroCommands.ContentEquationBuilder()
		Set resultObject = SmartContext.MacroCommands.SimpleCommands.CreateResultObject(DatabaseName, FINAL_RESULT, True, 0)
		' MappedTestIds" muss so bleiben! ContentAreaName -> eigenen Namen nutzen
		resultObject.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter(sStandardFilter)
		SmartContext.TestResultFiles.Add resultObject
		Set eqnBuilder = Nothing
		Set resultObject = Nothing
	Else
		db.Close
		Set db = Nothing
	End If
	Else
		oLog.LogMessage "diese Datei " & databaseName &  " existiert nicht"
	End If

End Function

Function AssignTag(ByVal helper As Object, ByVal tagID As String, ByVal columnName As String)

	' Assign tagID to ColumnName
	helper.SetTag tagID, columnName
	
	' Log information
	oLog.LogMessage "SetTag succeeded for tag - field: " & tagID & "-" & columnName

End Function

Function Import (ByVal sImportDatei As String, ByVal sEqn As String)
SetCheckpoint "Begin of Import"
Dim sPfadRDF As String
	
	sPfadRDF = oSC.GetKnownLocationPath(11) & "\SK_FuR" & "\Nachbuchungen.RDF"
	
	sDate = Date()

	dbImport = oSC.UniqueFileName(Client.WorkingDirectory & "Nachbuchungen_" & sDate & ".IMD")
	
	Client.ImportDelimFile sImportDatei, dbImport, TRUE, sEqn, sPfadRDF, TRUE
	
	Call ChangeDateField(dbImport)
	
	Client.RefreshFileExplorer
End Function

function ChangeDateField(ByVal sFile as string)
	Set db = Client.OpenDatabase(sFile)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	'field.Name = "BUCHTAG_DATUM" '04.08.2022
	field.Name = "BUCHUNGSDATUM"
	field.Description = ""
	field.Type = WI_DATE_FIELD
	field.Equation = "@compif(@len(BUCHTAG)=10;@ctod(BUCHTAG;""DD.MM.YYYY"");@len(BUCHTAG)=8;@ctod(BUCHTAG;""DD.MM.YY"");1;@ctod(""00.00.00"";""DD.MM.YY""))"
	task.AppendField field
	task.PerformTask

	'Set field = db.TableDef.NewField
	'field.Name = "WERTSTELLUNG"
	'field.Description = ""
	'field.Type = WI_DATE_FIELD
	'field.Equation = "@compif(@len(wert)=10;@ctod(wert;""DD.MM.YYYY"");@len(wert)=8;@ctod(wert;""DD.MM.YY"");1;@ctod(""00.00.00"";""DD.MM.YY""))"
	'field.Equation = "@ctod(@if(@match(@repeat(""0"";2 - @len(@split(wert;"""";""."";1;0))) + @split(wert;"""";""."";1;0) + @repeat(""0"";2 - @len(@split(wert;""."";""."";1;0))) + @split(wert;""."";""."";1;0); ""3002""; ""3102"");" & _
	'				 """2802""; @repeat(""0"";2 - @Len(@split(wert;"""";""."";1;0))) + @split(wert;"""";""."";1;0) + @repeat(""0"";2 - @Len(@split(wert;""."";""."";1;0))) + @split(wert;""."";""."";1;0)) + @If(@Len(@split(wert;""."";"""";2;0)) = 2; @If(@between(@Val(@split(wert;""."";"""";2;0));" & _
	'				 "30; 99); ""19""; ""20""); """") + @split(wert;""."";"""";2;0); ""DDMMYYYY"")"
	'task.AppendField field
	'task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
end function

Function ImportOBR(ByVal sJahr As String, ByVal sFilePath As String, ByVal sDescPath As String, ByVal sFilter As String)	' 28.04.2020 AS: added sFilter

	oLog.LogMessage "Begin Import OBR"
	dbImportOBRTemp = "{OBR_Konten_Temp_" & sJahr & "}.IMD"
	dbImportOBR = "{OBR_Konten_" & sAktuelleGJAHR & "}_" & Date() & ".IMD"
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

Function AddFieldUmsatz(ByVal sImportFile As String, ByVal sJahr As String)
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
	field.Equation = "@if(VERWENDUNGSZWECK=""REBU"";@Repeat(""0"";10-@Len(@split(VERWENDUNGSZWECK;""REBU   "";"" "";1;0)))+@split(VERWENDUNGSZWECK;""REBU   "";"" "";1;0);"""")"
	field.Length = 10
	task.AppendField field
	
	field.Name = "NICHTAUFGRIFFSGRENZE"
	field.Description = ""
	field.Type = WI_NUM_FIELD
	sEquation = "0"
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
	
	task.DisableProgressNotification = True
	
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
	
End Function

Function PrepareSalesData(ByVal sUmsaetze As String, ByVal sCurrentOBR As String)
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
	task.FileToJoin sCurrentOBR
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
	task.AddPFieldToInc "NABU"
	task.AddPFieldToInc "BM"
	task.AddPFieldToInc "RUECKBUCHUNG"
	task.AddMatchKey "KONTO_NR", "KONTO", "A"
	task.CreateVirtualDatabase = False
	task.DisableProgressNotification = True
	sUmsaetze = oSC.UniqueFileName(Client.WorkingDirectory & "{Nachbuchungen_zu_OBR}_" & sDate & ".IMD") 
	task.PerformTask sUmsaetze, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	oLog.LogMessage "Löschen der Zwischentabelle: " & sTempDB
	sTempDB = sTempDB
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
	sUmsaetze = oSC.UniqueFileName(Client.WorkingDirectory & "{Nachbuchungen_zu_OBR_mit_Buchungskennzeichen}_" & sDate & ".IMD")
	task.PerformTask sUmsaetze, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	oLog.LogMessage "Löschen der Zwischentabelle: " & sTempDB
	sTempDB = sTempDB
	Kill sTempDB
	
	PrepareSalesData = sUmsaetze

End Function

Function UpdateUmsatzSaldo(ByVal sOBR As String)
Dim sTempUmsaetze As String
Dim sTempOBR	As String
Dim ThisTable As Object
Dim sTempDB	As String
Dim sNewUmsatz	As String

	sTempUmsaetze = "{Umsätze_zu_OBR_Gesamt_mit_Buchungskennzeichen}.IMD"
	sTempOBR = sOBR
	sNewUmsatz = "{Umsätze_zu_OBR_Gesamt_mit_Buchungskennzeichen_aktualisiert}.IMD"

	Set db = Client.OpenDatabase(sTempUmsaetze)
	Set task = db.JoinDatabase
	task.FileToJoin sTempOBR
	task.IncludeAllPFields
	task.AddSFieldToInc "AZ9_SALDO"
	task.AddMatchKey "KONTO_NR", "KONTO", "A"
	task.CreateVirtualDatabase = False
	task.DisableProgressNotification = True
	task.PerformTask sNewUmsatz, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	sTempDB = sTempUmsaetze
	
	sTempDB = Client.WorkingDirectory & sTempDB
	Kill sTempDB
	
	Set task = Client.ProjectManagement
		' Namen der Datei ändern.
	task.RenameDatabase sNewUmsatz, sTempUmsaetze
	Set task = Nothing
	
	Set db = Client.OpenDatabase(sTempUmsaetze)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "AZ9_SALDO_TEMP"
	field.Description = ""
	field.Type = WI_NUM_FIELD
	field.Decimals = 2
	field.Equation = ""
	field.Length = 8
	task.ReplaceField "AZ9_SALDO", field
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
	
	Set db = Client.OpenDatabase(sTempUmsaetze)
	Set ThisTable = db.TableDef
	ThisTable.Protect = False
	ThisTable.DeleteField("AZ9_SALDO_TEMP")
	ThisTable.Protect = True
	db.Close
	Set ThisTable = Nothing
	Set db = Nothing
	
	Set db = Client.OpenDatabase(sTempUmsaetze)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "AZ9_SALDO"
	field.Description = ""
	field.Type = WI_NUM_FIELD
	field.Decimals = 2
	field.Equation = ""
	field.Length = 8
	task.ReplaceField "AZ9_SALDO1", field
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing


End Function

Function JoinGesamtUmsatzNachbuchung(ByVal sNachzuOBR As String, ByVal sFilter As String)

Dim sGesamtUmsatz	As String
Dim sUmsatzOhneNach	As String
Dim sTempDB	As String
Dim sTempFiltered	As String
Dim sNewNachbuchungen As String
	
	sGesamtUmsatz = "{Umsätze_zu_OBR_Gesamt_mit_Buchungskennzeichen}.IMD"
	sUmsatzOhneNach = "{Umsätze_zu_OBR_Gesamt_mit_Buchungskennzeichen_ohne_Nachbuchungen}.IMD"
	sTempFiltered = "{Umsätze_zu_OBR_Gesamt_mit_Buchungskennzeichen_Filtered}.IMD"
	sNewNachbuchungen = "{Neue_Nachbuchungen_zu_OBR_mit_Buchungskennzeichen}.IMD"
	
	Set db = Client.OpenDatabase(sGesamtUmsatz)
	Set task = db.Extraction
	task.IncludeAllFields
	task.AddExtraction sTempFiltered, "", sFilter
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	Set db = Client.OpenDatabase(sGesamtUmsatz)
	If  oSC.FieldExists(db, "NABU") Then
		db.Close
		Set db = Nothing
		
		Set db = Client.OpenDatabase(sNachzuOBR)
		Set task = db.JoinDatabase
		task.FileToJoin sTempFiltered
		task.IncludeAllPFields
		task.AddMatchKey "KONTO_NR", "KONTO_NR", "A"
		task.AddMatchKey "BUCHUNGSDATUM", "BUCHUNGSDATUM", "A"
		task.AddMatchKey "WERTSTELLUNG", "WERTSTELLUNG", "A"
		'task.AddMatchKey "WKZ", "WKZ", "A"
		task.AddMatchKey "TEXTSCHLÜSSEL", "TEXTSCHLÜSSEL", "A"
		task.AddMatchKey "BETRAG", "BETRAG", "A"
		task.AddMatchKey "AUFTRAGG_KTO", "AUFTRAGG_KTO", "A"
		task.AddMatchKey "VERWENDUNGSZWECK", "VERWENDUNGSZWECK", "A"
		'task.AddMatchKey "PN", "PN", "A"
		task.AddMatchKey "NABU", "NABU", "A"
		'task.AddMatchKey "BM", "BM", "A"
		'task.AddMatchKey "RUECKBUCHUNG", "RUECKBUCHUNG", "A"
		task.PerformTask sNewNachbuchungen, "", WI_JOIN_NOC_SEC_MATCH
		db.Close
		Set task = Nothing
		Set db = Nothing
	Else
		db.Close
		Set db = Nothing
		
		Set db = Client.OpenDatabase(sNachzuOBR)
		Set task = db.Extraction
		task.IncludeAllFields
		task.AddExtraction sNewNachbuchungen, "", ""
		task.PerformTask 1, db.Count
		db.Close
		Set task = Nothing
		Set db = Nothing
	End If
	
	sTempDB = Client.WorkingDirectory & sGesamtUmsatz
	Kill sTempDB
	
	Set db = Client.OpenDatabase(sTempFiltered)
	Set task = db.AppendDatabase
	task.AddDatabase sNewNachbuchungen
	task.DisableProgressNotification = True
	task.PerformTask sGesamtUmsatz, ""
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	sTempDB = Client.WorkingDirectory & sTempFiltered
	Kill sTempDB
	
	sTempDB = Client.WorkingDirectory & sNewNachbuchungen
	Kill sTempDB
	
	
	
	'Set db = Client.OpenDatabase(sGesamtUmsatz)
	'
	'If  oSC.FieldExists(db, "NABU") Then 
	'
	'	Set task = db.Extraction
	'	task.IncludeAllFields
	'	task.AddExtraction sTempFiltered, "", sFilter
	'	task.PerformTask 1, db.Count
	'	db.Close
	'	Set task = Nothing
	'	Set db = Nothing
	'	
	'	Set db = Client.OpenDatabase(sTempFiltered)
	'	Set task = db.Extraction
	'	task.IncludeAllFields
	'	task.AddExtraction sUmsatzOhneNach, "", "NABU  == """""
	'	task.PerformTask 1, db.Count
	'	db.Close
	'	Set task = Nothing
	'	Set db = Nothing
	'	
	'	sTempDB = Client.WorkingDirectory & sTempFiltered
	'	Kill sTempDB
	'	sTempDB = Client.WorkingDirectory & sGesamtUmsatz
	'	Kill sTempDB
	'Else
	'	Set task = db.Extraction
	'	task.IncludeAllFields
	'	task.AddExtraction sUmsatzOhneNach, "", sFilter
	'	task.PerformTask 1, db.Count
	'	db.Close
	'	Set task = Nothing
	'	Set db = Nothing
	'	
	'	sTempDB = Client.WorkingDirectory & sGesamtUmsatz
	'	Kill sTempDB
	'	'Set task = Client.ProjectManagement
	'	' Namen der Datei ändern.
	'	'task.RenameDatabase sGesamtUmsatz, sUmsatzOhneNach
	'	'Set task = Nothing
	'	'Set db = Nothing
	'End If 
	
	'Set db = Client.OpenDatabase(sUmsatzOhneNach)
	'Set task = db.AppendDatabase
	'task.AddDatabase sNachzuOBR
	'task.DisableProgressNotification = True
	'task.PerformTask sGesamtUmsatz, ""
	'db.Close
	'Set task = Nothing
	'Set db = Nothing
	'
	'sTempDB = Client.WorkingDirectory & sUmsatzOhneNach
	'Kill sTempDB
	
	Set db = Client.OpenDatabase(sGesamtUmsatz)
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
	'Set db = Client.OpenDatabase(sGesamtUmsatz)
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
	
	Set db = Client.OpenDatabase(sGesamtUmsatz)
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
	
	Set db = Client.OpenDatabase(sGesamtUmsatz)
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
	
	

End Function

Function RenameDataName

' Datei öffnen.

	Set task = Client.ProjectManagement

' Namen der Datei ändern.

	task.RenameDatabase "{OBR_Konten_" & sAktuelleGJAHR & "}.IMD", "{OBR_Konten_" & sAktuelleGJAHR & "}_" & Date() & ".IMD"

' Speicherplatz freigeben.

	Set task = Nothing

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

Function IsArrayEmpty(Arr As Variant) As Boolean
'This function tests whether the array has actually been allocated.

Dim LB As Long
Dim UB As Long

	Err.Clear

	If IsArray(Arr) = False Then
		' we weren't passed an array, return True
		IsArrayEmpty = True
	End If

	' Attempt to get the UBound of the array. If the array is
	' unallocated, an error will occur.
	UB = UBound(Arr, 1)
	If (Err.Number <> 0) Then
		IsArrayEmpty = True
	Else
		Err.Clear
		LB = LBound(Arr)
		If LB > UB Then
			IsArrayEmpty = True
		Else
			IsArrayEmpty = False
		End If
	End If

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

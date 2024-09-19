'-------------------------------------------------------------------------------------
' Change History
'-------------------------------------------------------------------------------------
' Changed by:	AS
' Changed on:	25.07.2022
' Requested by:	audicon
' Comment:		tables
' 				"-SKA00_Automatische_Buchungen_je_KtoRahmen.IMD"
' 				"-SKA00_Manuelle_Buchungen_je_KtoRahmen.IMD"
' 				are not created in the import routine anymore, instead the audit tests are associated with
' 				"-SKA00_Umsätze_zu_OBR_automatisch.IMD" or
' 				"-SKA00_Umsätze_zu_OBR_manuell.IMD"
'.				the association is change via the sdk mask -> Content Area
' 				and the tags are removed (are not used)
'------------------
' Changed by:	
' Changed on:	
' Requested by:	
' Comment:		
'------------------
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
Dim oTM As Object
Dim oLog As Object
Dim oProtectIP As Object
dim oPara as object

Dim sourceFileName As String
'final tables
Dim dbBuchungenJeKtoRahmen As String
Dim dbBuchungenJeKtoRahmenGes As String
Dim sUmsaetze As String
Dim dbUmsaetzeOBRAuto As String
Dim dbUmsaetzeOBRManuell As String
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
'Dim dbStornoSollAufHabenOBRungleichEUR As String

' IDEA standard variables
Dim db As Object
Dim dbName As String
Dim eqn As String
Dim task As Object

Dim tagManager As Object
Dim helper As Object

' für  GetStandardTestFilter
Dim tableTagging As Object
Dim filter As Object
Dim equationBuilder As Object
Dim ErrUnsupportedPropertyOrMethod As Integer 

Dim mc As Object
Dim tagger As Object
Dim sAlias As String

' OBR Tagging
dim sAktuelleGJAHR as string

Sub Main
	Set oSC = SmartContext.MacroCommands.SimpleCommands
	'Set oTM = SmartContext.MacroCommands.TagManagement
	Set oLog = SmartContext.Log
	Set oProtectIP = SmartContext.MacroCommands.ProtectIP
	' AS 18.11.2020: OBR Tagging
	Set oPara = SmartContext.MacroCommands.GlobalParameters ' AS 18.11.2020
oLog.LogMessage "Get Project Parameters"
	sAktuelleGJAHR = oPara.Get4Project ("sAktuelleGJAHR")
oLog.LogMessage "Beginn Tagging"
	' Set tagging for Umsätze zu OBR Gesamt mit Buchungskennzeichen
	Call AssignAnotherTag("{Umsätze_zu_OBR_Gesamt_mit_Buchungskennzeichen}.IMD")
	Call AssignAnotherTag("-SKA00_Umsätze_zu_OBR_automatisch.IMD")
	'Call AssignAnotherTag("-SKA00_Automatische_Buchungen_je_KtoRahmen.IMD") ' 25.07.2022 table is not created in the import routine anymore, instead the audit tests are associated with "-SKA00_Umsätze_zu_OBR_automatisch.IMD"
	Call AssignAnotherTag("-SKA00_Umsätze_zu_OBR_in_EUR_automatisch.IMD")
	Call AssignAnotherTag("-SKA00_Umsätze_zu_OBR_nicht_in_EUR_automatisch.IMD")
	Call AssignAnotherTag("-SKA00_Umsätze_zu_OBR_manuell.IMD")
	'Call AssignAnotherTag("-SKA00_Manuelle_Buchungen_je_KtoRahmen.IMD") ' 25.07.2022 table is not created in the import routine anymore, instead the audit tests are associated with "-SKA00_Umsätze_zu_OBR_manuell.IMD"
	Call AssignAnotherTag("-SKA00_Umsätze_zu_OBR_in_EUR_manuell.IMD")
	
	'v1.04 Zusammenführung der PS 
	'Berrechnung und Logi wird zum PS verschoben 
	'Basisdatei "-SKA00_Umsätze_zu_OBR_in_EUR_manuell.IMD"
	
	Call AssignAnotherTag("-SKA00_HabenBuchungen_auf_SollKonten_zu_OBR_in_EUR.IMD")
	Call AssignAnotherTag("-SKA00_SollBuchungen_auf_HabenKonten_zu_OBR_in_EUR.IMD")
	Call AssignAnotherTag("-SKA00_Storno_HabenBuchungen_auf_SollKonten_zu_OBR_in_EUR.IMD")
	Call AssignAnotherTag("-SKA00_Storno_SollBuchungen_auf_HabenKonten_zu_OBR_in_EUR.IMD")
	
	Call AssignAnotherTag("-SKA00_Umsätze_zu_OBR_nicht_in_EUR_manuell.IMD")
	
	' AS 18.11.2020: Additional Tagging of {OBR_Konten_YYYY} for additional audit tests App Version 1.2.0
	Call AssignAnotherTag("{OBR_Konten_" & sAktuelleGJAHR & "}.IMD")
	
	'v1.04 Zusammenführung der PS 
	'Berrechnung und Logi wird zum PS verschoben 
	'Basisdatei "-SKA00_Umsätze_zu_OBR_in_EUR_manuell.IMD"
	
	'Call AssignAnotherTag("-SKA00_HabenBuchungen_auf_SollKonten_zu_OBR_nicht_in_EUR.IMD")
	'Call AssignAnotherTag("-SKA00_SollBuchungen_auf_HabenKonten_zu_OBR_nicht_in_EUR.IMD")
	'Call AssignAnotherTag("-SKA00_Storno_HabenBuchungen_auf_SollKonten_zu_OBR_nicht_in_EUR.IMD")
	'Call AssignAnotherTag("-SKA00_Storno_SollBuchungen_auf_HabenKonten_zu_OBR_nicht_in_EUR.IMD")
	
	'Tagging AdditionalFile
	'Leider funktioniert nicht
	'Bitte nicht löschen  
'Opt 1	
	'Set tagMgm = SmartContext.MacroCommands.TagManagement()
	'Set helper = tagMgm.Tagging(oSC.GetFullFileName("-SKA00_Storno_HabenBuchungen_auf_Sollkonten_zu_OBR_nicht_in_EUR"))
	
	'Set equationBuilder = SmartContext.MacroCommands.ContentEquationBuilder()
	'Set filter = equationBuilder.GetStandardTestFilter("SKAStornoHabenAufSollNichtEUR")
	'SaveTagging helper, filter
'Opt 2	
	'Set equationBuilder = SmartContext.MacroCommands.ContentEquationBuilder()
	'Set filter = equationBuilder.GetStandardTestFilter("SKAStornoHabenAufSollNichtEUR")           
	'Set tableTagging = SmartContext.MacroCommands.TagManagement.Tagging(Client.WorkingDirectory & "-SKA00_Storno_SollBuchungen_auf_HabenKonten_zu_OBR_nicht_in_EUR.IMD")
	'tableTagging.SetTag "acc!SHSONE_BETRAG", "BETRAG"
	'tableTagging.SetTag "acc!SHSONE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
	'tableTagging.SaveWithTestFilter filter
'Opt 3	
	'Set tagManager = SmartContext.MacroCommands.TagManagement()
	'Set equationBuilder = SmartContext.MacroCommands.ContentEquationBuilder()
	
	'Set filter = equationBuilder.GetTestFilter("ContentArea","SKAStornoHabenAufSollNichtEUR")  'Alias SKAStornoHabenAufSollNichtEUR
	'Set tableTagging = tagManager.AssociatingTagging("-SKA00_Storno_HabenBuchungen_auf_Sollkonten_zu_OBR_nicht_in_EUR.IMD")
	
	'tableTagging.SetTag "acc!SHSONE_BETRAG", "BETRAG"
	'tableTagging.SetTag "acc!SHSONE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
	'tableTagging.Save
	'tableTagging.AssociateSecondary filter, "second"
	Set oSC = Nothing ' AS 18.11.2020
	'Set oTM = Nothing ' AS 18.11.2020
	Set oLog = Nothing ' AS 18.11.2020
	Set oProtectIP = Nothing ' AS 18.11.2020
	Set oPara = Nothing ' AS 18.11.2020
End Sub

Function AssignTag(ByVal helper As Object, ByVal tagID As String, ByVal columnName As String)

	' Assign tagID to ColumnName
	helper.SetTag tagID, columnName
	
	' Log information
	oLog.LogMessage "SetTag succeeded for tag - field: " & tagID & "-" & columnName

End Function

'Für automatische Registrierung von Additional Files
'als 1. Parameter das Objekt der Datei übergeben, die du als „zusätzliche Datei“ einem PS zuweisen willst.
'als 2. Parameter die „Content Area“, die du ja als Alias eingetragen hast. Wirklich brauchen wirst du nur
'tableTagging.SaveWithTestFilter testFilter. Der Rest ist mehr oder weniger Fehlerbehandlung. 


Sub SaveTagging(ByVal tableTagging As Object, ByVal testFilter As Object)
On Error Resume Next
    
    Dim ec As Long
    Dim ed As String
    Dim es As String
    
    tableTagging.SaveWithTestFilter testFilter
    If err.Number <> 0 Then
        If err.Number = ErrUnsupportedPropertyOrMethod Then
            On Error GoTo 0
            tableTagging.Save
            Exit Sub
        End If
        
        ec = err.Number
        es = err.Source
        ed = err.Description
        'On Error GoTo 0
        'err.Raise ec, es, ed
        SmartContext.Log.LogError ec  & ed & es
       Err.Clear        
    End If
End Sub

Function AssignAnotherTag(ByVal databaseName As String)
Dim helper As Object
Dim tagID As String
Dim columnName As String
Dim sStandardFilter As String
Dim eqnBuilder As Object
Dim resultObject As Object
Dim sTaggedTable As String

'	Set oTM = oMC.TagManagement
	Set oTM = SmartContext.MacroCommands.TagManagement
	Set helper = oTM.Tagging(Client.WorkingDirectory & databaseName)
	Set db = Client.OpenDatabase(Client.WorkingDirectory & DatabaseName)
	If db.Count > 0 Then
		db.Close
		Set db = Nothing
		Select Case databaseName
			Case "{Umsätze_zu_OBR_Gesamt_mit_Buchungskennzeichen}.IMD"
				AssignTag helper, "acc!KONTO_NR", "KONTO_NR"
				AssignTag helper, "acc!KONTO_BEZ", "KONTOBEZEICHNUNG"
				AssignTag helper, "acc!BUDAT", "BUCHUNGSDATUM"
				AssignTag helper, "acc!WERTDAT", "WERTSTELLUNG"
				AssignTag helper, "acc!BETRAG", "BETRAG"
				AssignTag helper, "acc!WKZ", "WKZ"
				AssignTag helper, "acc!TEXT", "TEXTSCHLÜSSEL"
				AssignTag helper, "acc!KTO_RAHMEN", "KTO_RAHMEN"
				AssignTag helper, "acc!AUFTRAGG_KTO", "AUFTRAGG_KTO"
				AssignTag helper, "acc!PN", "PN"
				AssignTag helper, "acc!VERZW", "VERWENDUNGSZWECK"
				AssignTag helper, "acc!SHK", "SHK"
				AssignTag helper, "acc!RAHMNR_2", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!RAHMNR_3", "RAHMENNR_3STELLIG"
				AssignTag helper, "acc!NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
				AssignTag helper, "acc!REL", "RELEVANT"
				AssignTag helper, "acc!KTO", "KONTO"
				AssignTag helper, "acc!BEZ", "BEZEICHNUNG"
				AssignTag helper, "acc!AZ9SALDO", "AZ9_SALDO"
				AssignTag helper, "acc!SHK_OBR", "SHK1"
				AssignTag helper, "acc!RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				AssignTag helper, "acc!POSSHORT", "POSITION_SHORT"
				AssignTag helper, "acc!ERDAT", "ERÖFFNUNG"
				AssignTag helper, "acc!AUFDAT", "AUFLÖSUNG"
				AssignTag helper, "acc!MANBUCH", "MANUELLE_BUCHUNGEN"
				AssignTag helper, "acc!BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				'AssignTag helper, "acc!NABU", "NABU"
				'AssignTag helper, "acc!BM", "BM"
				'AssignTag helper, "acc!RUECKBUCHUNG", "RUECKBUCHUNG"
				helper.Save
				sStandardFilter = "SKAUmsatzGesamt"
			Case "-SKA00_Umsätze_zu_OBR_automatisch.IMD"
				AssignTag helper, "acc!AUTO_KONTO_NR", "KONTO_NR"
				AssignTag helper, "acc!AUTO_KONTO_BEZ", "KONTOBEZEICHNUNG"
				AssignTag helper, "acc!AUTO_BUDAT", "BUCHUNGSDATUM"
				AssignTag helper, "acc!AUTO_WERTDAT", "WERTSTELLUNG"
				AssignTag helper, "acc!AUTO_BETRAG", "BETRAG"
				AssignTag helper, "acc!AUTO_WKZ", "WKZ"
				AssignTag helper, "acc!AUTO_TEXT", "TEXTSCHLÜSSEL"
				AssignTag helper, "acc!AUTO_KTO_RAHMEN", "KTO_RAHMEN"
				AssignTag helper, "acc!AUTO_AUFTRAGG_KTO", "AUFTRAGG_KTO"
				AssignTag helper, "acc!AUTO_PN", "PN"
				AssignTag helper, "acc!AUTO_VERZW", "VERWENDUNGSZWECK"
				AssignTag helper, "acc!AUTO_SHK", "SHK"
				AssignTag helper, "acc!AUTO_RAHMNR_2", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!AUTO_RAHMNR_3", "RAHMENNR_3STELLIG"
				AssignTag helper, "acc!AUTO_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
				AssignTag helper, "acc!AUTO_REL", "RELEVANT"
				AssignTag helper, "acc!AUTO_KTO", "KONTO"
				AssignTag helper, "acc!AUTO_BEZ", "BEZEICHNUNG"
				AssignTag helper, "acc!AUTO_AZ9SALDO", "AZ9_SALDO"
				AssignTag helper, "acc!AUTO_SHK_OBR", "SHK1"
				AssignTag helper, "acc!AUTO_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!AUTO_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				AssignTag helper, "acc!AUTO_POSSHORT", "POSITION_SHORT"
				AssignTag helper, "acc!AUTO_ERDAT", "ERÖFFNUNG"
				AssignTag helper, "acc!AUTO_AUFDAT", "AUFLÖSUNG"
				AssignTag helper, "acc!AUTO_MANBUCH", "MANUELLE_BUCHUNGEN"
				AssignTag helper, "acc!AUTO_WERTJAHR", "WERTSTELLUNG_JAHR"
				AssignTag helper, "acc!AUTO_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				'AssignTag helper, "acc!AUTO_NABU", "NABU"
				'AssignTag helper, "acc!AUTO_BM", "BM"
				'AssignTag helper, "acc!AUTO_RUECKBUCHUNG", "RUECKBUCHUNG"
				helper.Save
				sStandardFilter = "SKAUmsatzAuto"
			Case "-SKA00_Automatische_Buchungen_je_KtoRahmen.IMD"
				AssignTag helper, "acc!AJEKTO_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!AJEKTO_ANZAHL", "ANZ_SAETZE"
				AssignTag helper, "acc!AJEKTO_SUMME", "BETRAG_SUMME"
				AssignTag helper, "acc!AJEKTO_MAX", "BETRAG_MAX"
				AssignTag helper, "acc!AJEKTO_MIN", "BETRAG_MIN"
				AssignTag helper, "acc!AJEKTO_DURCHSCHNITT", "BETRAG_DURCHSCHNITT"
				helper.save
				sStandardFilter = "SKAUmsatzAutoJeKto"
			Case "-SKA00_Umsätze_zu_OBR_in_EUR_automatisch.IMD"
				AssignTag helper, "acc!AOE_KONTO_NR", "KONTO_NR"
				AssignTag helper, "acc!AOE_KONTO_BEZ", "KONTOBEZEICHNUNG"
				AssignTag helper, "acc!AOE_BUDAT", "BUCHUNGSDATUM"
				AssignTag helper, "acc!AOE_WERTDAT", "WERTSTELLUNG"
				AssignTag helper, "acc!AOE_BETRAG", "BETRAG"
				AssignTag helper, "acc!AOE_WKZ", "WKZ"
				AssignTag helper, "acc!AOE_TEXT", "TEXTSCHLÜSSEL"
				AssignTag helper, "acc!AOE_KTO_RAHMEN", "KTO_RAHMEN"
				AssignTag helper, "acc!AOE_AUFTRAGG_KTO", "AUFTRAGG_KTO"
				AssignTag helper, "acc!AOE_PN", "PN"
				AssignTag helper, "acc!AOE_VERZW", "VERWENDUNGSZWECK"
				AssignTag helper, "acc!AOE_SHK", "SHK"
				AssignTag helper, "acc!AOE_RAHMNR_2", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!AOE_RAHMNR_3", "RAHMENNR_3STELLIG"
				AssignTag helper, "acc!AOE_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
				AssignTag helper, "acc!AOE_REL", "RELEVANT"
				AssignTag helper, "acc!AOE_KTO", "KONTO"
				AssignTag helper, "acc!AOE_BEZ", "BEZEICHNUNG"
				AssignTag helper, "acc!AOE_AZ9SALDO", "AZ9_SALDO"
				AssignTag helper, "acc!AOE_SHK_OBR", "SHK1"
				AssignTag helper, "acc!AOE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!AOE_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				AssignTag helper, "acc!AOE_POSSHORT", "POSITION_SHORT"
				AssignTag helper, "acc!AOE_ERDAT", "ERÖFFNUNG"
				AssignTag helper, "acc!AOE_AUFDAT", "AUFLÖSUNG"
				AssignTag helper, "acc!AOE_MANBUCH", "MANUELLE_BUCHUNGEN"
				AssignTag helper, "acc!AOE_WERTJAHR", "WERTSTELLUNG_JAHR"
				AssignTag helper, "acc!AOE_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				'AssignTag helper, "acc!AOE_NABU", "NABU"
				'AssignTag helper, "acc!AOE_BM", "BM"
				'AssignTag helper, "acc!AOE_RUECKBUCHUNG", "RUECKBUCHUNG"
				helper.Save
				sStandardFilter = "SKAUmsatzAutoInEUR"
			Case "-SKA00_Umsätze_zu_OBR_nicht_in_EUR_automatisch.IMD"
				AssignTag helper, "acc!AONE_KONTO_NR", "KONTO_NR"
				AssignTag helper, "acc!AONE_KONTO_BEZ", "KONTOBEZEICHNUNG"
				AssignTag helper, "acc!AONE_BUDAT", "BUCHUNGSDATUM"
				AssignTag helper, "acc!AONE_WERTDAT", "WERTSTELLUNG"
				AssignTag helper, "acc!AONE_BETRAG", "BETRAG"
				AssignTag helper, "acc!AONE_WKZ", "WKZ"
				AssignTag helper, "acc!AONE_TEXT", "TEXTSCHLÜSSEL"
				AssignTag helper, "acc!AONE_KTO_RAHMEN", "KTO_RAHMEN"
				AssignTag helper, "acc!AONE_AUFTRAGG_KTO", "AUFTRAGG_KTO"
				AssignTag helper, "acc!AONE_PN", "PN"
				AssignTag helper, "acc!AONE_VERZW", "VERWENDUNGSZWECK"
				AssignTag helper, "acc!AONE_SHK", "SHK"
				AssignTag helper, "acc!AONE_RAHMNR_2", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!AONE_RAHMNR_3", "RAHMENNR_3STELLIG"
				AssignTag helper, "acc!AONE_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
				AssignTag helper, "acc!AONE_REL", "RELEVANT"
				AssignTag helper, "acc!AONE_KTO", "KONTO"
				AssignTag helper, "acc!AONE_BEZ", "BEZEICHNUNG"
				AssignTag helper, "acc!AONE_AZ9SALDO", "AZ9_SALDO"
				AssignTag helper, "acc!AONE_SHK_OBR", "SHK1"
				AssignTag helper, "acc!AONE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!AONE_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				AssignTag helper, "acc!AONE_POSSHORT", "POSITION_SHORT"
				AssignTag helper, "acc!AONE_ERDAT", "ERÖFFNUNG"
				AssignTag helper, "acc!AONE_AUFDAT", "AUFLÖSUNG"
				AssignTag helper, "acc!AONE_MANBUCH", "MANUELLE_BUCHUNGEN"
				AssignTag helper, "acc!AONE_WERTJAHR", "WERTSTELLUNG_JAHR"
				AssignTag helper, "acc!AONE_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				'AssignTag helper, "acc!AONE_NABU", "NABU"
				'AssignTag helper, "acc!AONE_BM", "BM"
				'AssignTag helper, "acc!AONE_RUECKBUCHUNG", "RUECKBUCHUNG"
				helper.Save
				sStandardFilter = "SKAUmsatzAutoNichtEUR"
			Case "-SKA00_Umsätze_zu_OBR_manuell.IMD"
				AssignTag helper, "acc!MAN_KONTO_NR", "KONTO_NR"
				AssignTag helper, "acc!MAN_KONTO_BEZ", "KONTOBEZEICHNUNG"
				AssignTag helper, "acc!MAN_BUDAT", "BUCHUNGSDATUM"
				AssignTag helper, "acc!MAN_WERTDAT", "WERTSTELLUNG"
				AssignTag helper, "acc!MAN_BETRAG", "BETRAG"
				AssignTag helper, "acc!MAN_WKZ", "WKZ"
				AssignTag helper, "acc!MAN_TEXT", "TEXTSCHLÜSSEL"
				AssignTag helper, "acc!MAN_KTO_RAHMEN", "KTO_RAHMEN"
				AssignTag helper, "acc!MAN_AUFTRAGG_KTO", "AUFTRAGG_KTO"
				AssignTag helper, "acc!MAN_PN", "PN"
				AssignTag helper, "acc!MAN_VERZW", "VERWENDUNGSZWECK"
				AssignTag helper, "acc!MAN_SHK", "SHK"
				AssignTag helper, "acc!MAN_RAHMNR_2", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!MAN_RAHMNR_3", "RAHMENNR_3STELLIG"
				AssignTag helper, "acc!MAN_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
				AssignTag helper, "acc!MAN_REL", "RELEVANT"
				AssignTag helper, "acc!MAN_KTO", "KONTO"
				AssignTag helper, "acc!MAN_BEZ", "BEZEICHNUNG"
				AssignTag helper, "acc!MAN_AZ9SALDO", "AZ9_SALDO"
				AssignTag helper, "acc!MAN_SHK_OBR", "SHK1"
				AssignTag helper, "acc!MAN_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!MAN_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				AssignTag helper, "acc!MAN_POSSHORT", "POSITION_SHORT"
				AssignTag helper, "acc!MAN_ERDAT", "ERÖFFNUNG"
				AssignTag helper, "acc!MAN_AUFDAT", "AUFLÖSUNG"
				AssignTag helper, "acc!MAN_MANBUCH", "MANUELLE_BUCHUNGEN"
				AssignTag helper, "acc!MAN_WERTJAHR", "WERTSTELLUNG_JAHR"
				'AssignTag helper, "acc!MAN_RELBETRAG", "RELEVANTER_BETRAG"
				AssignTag helper, "acc!MAN_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				'AssignTag helper, "acc!MAN_NABU", "NABU"
				'AssignTag helper, "acc!MAN_BM", "BM"
				'AssignTag helper, "acc!MAN_RUECKBUCHUNG", "RUECKBUCHUNG"
				helper.Save
				sStandardFilter = "SKAUmsatzManuell"
			Case "-SKA00_Manuelle_Buchungen_je_KtoRahmen.IMD"
				AssignTag helper, "acc!MJEKTO_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!MJEKTO_ANZAHL", "ANZ_SAETZE"
				AssignTag helper, "acc!MJEKTO_SUMME", "BETRAG_SUMME"
				AssignTag helper, "acc!MJEKTO_MAX", "BETRAG_MAX"
				AssignTag helper, "acc!MJEKTO_MIN", "BETRAG_MIN"
				AssignTag helper, "acc!MJEKTO_DURCHSCHNITT", "BETRAG_DURCHSCHNITT"
				helper.save
				sStandardFilter = "SKAUmsatzManuellJeKto"
			Case "-SKA00_Umsätze_zu_OBR_in_EUR_manuell.IMD"
				AssignTag helper, "acc!MOE_KONTO_NR", "KONTO_NR"
				AssignTag helper, "acc!MOE_KONTO_BEZ", "KONTOBEZEICHNUNG"
				AssignTag helper, "acc!MOE_BUDAT", "BUCHUNGSDATUM"
				AssignTag helper, "acc!MOE_WERTDAT", "WERTSTELLUNG"
				AssignTag helper, "acc!MOE_BETRAG", "BETRAG"
				AssignTag helper, "acc!MOE_WKZ", "WKZ"
				AssignTag helper, "acc!MOE_TEXT", "TEXTSCHLÜSSEL"
				AssignTag helper, "acc!MOE_KTO_RAHMEN", "KTO_RAHMEN"
				AssignTag helper, "acc!MOE_AUFTRAGG_KTO", "AUFTRAGG_KTO"
				AssignTag helper, "acc!MOE_PN", "PN"
				AssignTag helper, "acc!MOE_VERZW", "VERWENDUNGSZWECK"
				AssignTag helper, "acc!MOE_SHK", "SHK"
				AssignTag helper, "acc!MOE_RAHMNR_2", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!MOE_RAHMNR_3", "RAHMENNR_3STELLIG"
				AssignTag helper, "acc!MOE_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
				AssignTag helper, "acc!MOE_REL", "RELEVANT"
				AssignTag helper, "acc!MOE_KTO", "KONTO"
				AssignTag helper, "acc!MOE_BEZ", "BEZEICHNUNG"
				AssignTag helper, "acc!MOE_AZ9SALDO", "AZ9_SALDO"
				AssignTag helper, "acc!MOE_SHK_OBR", "SHK1"
				AssignTag helper, "acc!MOE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!MOE_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				AssignTag helper, "acc!MOE_POSSHORT", "POSITION_SHORT"
				AssignTag helper, "acc!MOE_ERDAT", "ERÖFFNUNG"
				AssignTag helper, "acc!MOE_AUFDAT", "AUFLÖSUNG"
				AssignTag helper, "acc!MOE_MANBUCH", "MANUELLE_BUCHUNGEN"
				AssignTag helper, "acc!MOE_WERTJAHR", "WERTSTELLUNG_JAHR"
				'AssignTag helper, "acc!MOE_RELBETRAG", "RELEVANTER_BETRAG"
				AssignTag helper, "acc!MOE_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				'AssignTag helper, "acc!MOE_NABU", "NABU"
				'AssignTag helper, "acc!MOE_BM", "BM"
				'AssignTag helper, "acc!MOE_RUECKBUCHUNG", "RUECKBUCHUNG"
				helper.Save
				sStandardFilter = "SKAUmsatzManuellInEUR"
			Case "-SKA00_HabenBuchungen_auf_SollKonten_zu_OBR_in_EUR.IMD"
				AssignTag helper, "acc!HSOE_KONTO_NR", "KONTO_NR"
				AssignTag helper, "acc!HSOE_KONTO_BEZ", "KONTOBEZEICHNUNG"
				AssignTag helper, "acc!HSOE_BUDAT", "BUCHUNGSDATUM"
				AssignTag helper, "acc!HSOE_WERTDAT", "WERTSTELLUNG"
				AssignTag helper, "acc!HSOE_BETRAG", "BETRAG"
				AssignTag helper, "acc!HSOE_WKZ", "WKZ"
				AssignTag helper, "acc!HSOE_TEXT", "TEXTSCHLÜSSEL"
				AssignTag helper, "acc!HSOE_KTO_RAHMEN", "KTO_RAHMEN"
				AssignTag helper, "acc!HSOE_AUFTRAGG_KTO", "AUFTRAGG_KTO"
				AssignTag helper, "acc!HSOE_PN", "PN"
				AssignTag helper, "acc!HSOE_VERZW", "VERWENDUNGSZWECK"
				AssignTag helper, "acc!HSOE_SHK", "SHK"
				AssignTag helper, "acc!HSOE_RAHMNR_2", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!HSOE_RAHMNR_3", "RAHMENNR_3STELLIG"
				AssignTag helper, "acc!HSOE_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
				AssignTag helper, "acc!HSOE_REL", "RELEVANT"
				AssignTag helper, "acc!HSOE_KTO", "KONTO"
				AssignTag helper, "acc!HSOE_BEZ", "BEZEICHNUNG"
				AssignTag helper, "acc!HSOE_AZ9SALDO", "AZ9_SALDO"
				AssignTag helper, "acc!HSOE_SHK_OBR", "SHK1"
				AssignTag helper, "acc!HSOE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!HSOE_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				AssignTag helper, "acc!HSOE_POSSHORT", "POSITION_SHORT"
				AssignTag helper, "acc!HSOE_ERDAT", "ERÖFFNUNG"
				AssignTag helper, "acc!HSOE_AUFDAT", "AUFLÖSUNG"
				AssignTag helper, "acc!HSOE_MANBUCH", "MANUELLE_BUCHUNGEN"
				AssignTag helper, "acc!HSOE_WERTJAHR", "WERTSTELLUNG_JAHR"
				'AssignTag helper, "acc!HSOE_RELBETRAG", "RELEVANTER_BETRAG"
				AssignTag helper, "acc!HSOE_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				'AssignTag helper, "acc!HSOE_NABU", "NABU"
				'AssignTag helper, "acc!HSOE_BM", "BM"
				'AssignTag helper, "acc!HSOE_RUECKBUCHUNG", "RUECKBUCHUNG"
				helper.Save
				sStandardFilter = "SKAHabenAufSollInEUR"
			Case "-SKA00_SollBuchungen_auf_HabenKonten_zu_OBR_in_EUR.IMD"
				AssignTag helper, "acc!SHOE_KONTO_NR", "KONTO_NR"
				AssignTag helper, "acc!SHOE_KONTO_BEZ", "KONTOBEZEICHNUNG"
				AssignTag helper, "acc!SHOE_BUDAT", "BUCHUNGSDATUM"
				AssignTag helper, "acc!SHOE_WERTDAT", "WERTSTELLUNG"
				AssignTag helper, "acc!SHOE_BETRAG", "BETRAG"
				AssignTag helper, "acc!SHOE_WKZ", "WKZ"
				AssignTag helper, "acc!SHOE_TEXT", "TEXTSCHLÜSSEL"
				AssignTag helper, "acc!SHOE_KTO_RAHMEN", "KTO_RAHMEN"
				AssignTag helper, "acc!SHOE_AUFTRAGG_KTO", "AUFTRAGG_KTO"
				AssignTag helper, "acc!SHOE_PN", "PN"
				AssignTag helper, "acc!SHOE_VERZW", "VERWENDUNGSZWECK"
				AssignTag helper, "acc!SHOE_SHK", "SHK"
				AssignTag helper, "acc!SHOE_RAHMNR_2", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!SHOE_RAHMNR_3", "RAHMENNR_3STELLIG"
				AssignTag helper, "acc!SHOE_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
				AssignTag helper, "acc!SHOE_REL", "RELEVANT"
				AssignTag helper, "acc!SHOE_KTO", "KONTO"
				AssignTag helper, "acc!SHOE_BEZ", "BEZEICHNUNG"
				AssignTag helper, "acc!SHOE_AZ9SALDO", "AZ9_SALDO"
				AssignTag helper, "acc!SHOE_SHK_OBR", "SHK1"
				AssignTag helper, "acc!SHOE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!SHOE_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				AssignTag helper, "acc!SHOE_POSSHORT", "POSITION_SHORT"
				AssignTag helper, "acc!SHOE_ERDAT", "ERÖFFNUNG"
				AssignTag helper, "acc!SHOE_AUFDAT", "AUFLÖSUNG"
				AssignTag helper, "acc!SHOE_MANBUCH", "MANUELLE_BUCHUNGEN"
				AssignTag helper, "acc!SHOE_WERTJAHR", "WERTSTELLUNG_JAHR"
				'AssignTag helper, "acc!SHOE_RELBETRAG", "RELEVANTER_BETRAG"
				AssignTag helper, "acc!SHOE_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				'AssignTag helper, "acc!SHOE_NABU", "NABU"
				'AssignTag helper, "acc!SHOE_BM", "BM"
				'AssignTag helper, "acc!SHOE_RUECKBUCHUNG", "RUECKBUCHUNG"
				helper.Save
				sStandardFilter = "SKASollAufHabenInEUR"
			Case "-SKA00_Storno_HabenBuchungen_auf_SollKonten_zu_OBR_in_EUR.IMD"
				AssignTag helper, "acc!SHSOE_KONTO_NR", "KONTO_NR"
				AssignTag helper, "acc!SHSOE_KONTO_BEZ", "KONTOBEZEICHNUNG"
				AssignTag helper, "acc!SHSOE_BUDAT", "BUCHUNGSDATUM"
				AssignTag helper, "acc!SHSOE_WERTDAT", "WERTSTELLUNG"
				AssignTag helper, "acc!SHSOE_BETRAG", "BETRAG"
				AssignTag helper, "acc!SHSOE_WKZ", "WKZ"
				AssignTag helper, "acc!SHSOE_TEXT", "TEXTSCHLÜSSEL"
				AssignTag helper, "acc!SHSOE_KTO_RAHMEN", "KTO_RAHMEN"
				AssignTag helper, "acc!SHSOE_AUFTRAGG_KTO", "AUFTRAGG_KTO"
				AssignTag helper, "acc!SHSOE_PN", "PN"
				AssignTag helper, "acc!SHSOE_VERZW", "VERWENDUNGSZWECK"
				AssignTag helper, "acc!SHSOE_SHK", "SHK"
				AssignTag helper, "acc!SHSOE_RAHMNR_2", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!SHSOE_RAHMNR_3", "RAHMENNR_3STELLIG"
				AssignTag helper, "acc!SHSOE_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
				AssignTag helper, "acc!SHSOE_REL", "RELEVANT"
				AssignTag helper, "acc!SHSOE_KTO", "KONTO"
				AssignTag helper, "acc!SHSOE_BEZ", "BEZEICHNUNG"
				AssignTag helper, "acc!SHSOE_AZ9SALDO", "AZ9_SALDO"
				AssignTag helper, "acc!SHSOE_SHK_OBR", "SHK1"
				AssignTag helper, "acc!SHSOE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!SHSOE_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				AssignTag helper, "acc!SHSOE_POSSHORT", "POSITION_SHORT"
				AssignTag helper, "acc!SHSOE_ERDAT", "ERÖFFNUNG"
				AssignTag helper, "acc!SHSOE_AUFDAT", "AUFLÖSUNG"
				AssignTag helper, "acc!SHSOE_MANBUCH", "MANUELLE_BUCHUNGEN"
				AssignTag helper, "acc!SHSOE_WERTJAHR", "WERTSTELLUNG_JAHR"
				'AssignTag helper, "acc!SHSOE_RELBETRAG", "RELEVANTER_BETRAG"
				AssignTag helper, "acc!SHSOE_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				'AssignTag helper, "acc!SHSOE_NABU", "NABU"
				'AssignTag helper, "acc!SHSOE_BM", "BM"
				'AssignTag helper, "acc!SHSOE_RUECKBUCHUNG", "RUECKBUCHUNG"
				helper.Save
				sStandardFilter = "SKAStornoHabenAufSollInEUR"
			Case "-SKA00_Storno_SollBuchungen_auf_HabenKonten_zu_OBR_in_EUR.IMD"
				AssignTag helper, "acc!SSHOE_KONTO_NR", "KONTO_NR"
				AssignTag helper, "acc!SSHOE_KONTO_BEZ", "KONTOBEZEICHNUNG"
				AssignTag helper, "acc!SSHOE_BUDAT", "BUCHUNGSDATUM"
				AssignTag helper, "acc!SSHOE_WERTDAT", "WERTSTELLUNG"
				AssignTag helper, "acc!SSHOE_BETRAG", "BETRAG"
				AssignTag helper, "acc!SSHOE_WKZ", "WKZ"
				AssignTag helper, "acc!SSHOE_TEXT", "TEXTSCHLÜSSEL"
				AssignTag helper, "acc!SSHOE_KTO_RAHMEN", "KTO_RAHMEN"
				AssignTag helper, "acc!SSHOE_AUFTRAGG_KTO", "AUFTRAGG_KTO"
				AssignTag helper, "acc!SSHOE_PN", "PN"
				AssignTag helper, "acc!SSHOE_VERZW", "VERWENDUNGSZWECK"
				AssignTag helper, "acc!SSHOE_SHK", "SHK"
				AssignTag helper, "acc!SSHOE_RAHMNR_2", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!SSHOE_RAHMNR_3", "RAHMENNR_3STELLIG"
				AssignTag helper, "acc!SSHOE_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
				AssignTag helper, "acc!SSHOE_REL", "RELEVANT"
				AssignTag helper, "acc!SSHOE_KTO", "KONTO"
				AssignTag helper, "acc!SSHOE_BEZ", "BEZEICHNUNG"
				AssignTag helper, "acc!SSHOE_AZ9SALDO", "AZ9_SALDO"
				AssignTag helper, "acc!SSHOE_SHK_OBR", "SHK1"
				AssignTag helper, "acc!SSHOE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!SSHOE_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				AssignTag helper, "acc!SSHOE_POSSHORT", "POSITION_SHORT"
				AssignTag helper, "acc!SSHOE_ERDAT", "ERÖFFNUNG"
				AssignTag helper, "acc!SSHOE_AUFDAT", "AUFLÖSUNG"
				AssignTag helper, "acc!SSHOE_MANBUCH", "MANUELLE_BUCHUNGEN"
				AssignTag helper, "acc!SSHOE_WERTJAHR", "WERTSTELLUNG_JAHR"
				'AssignTag helper, "acc!SSHOE_RELBETRAG", "RELEVANTER_BETRAG"
				AssignTag helper, "acc!SSHOE_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				'AssignTag helper, "acc!SSHOE_NABU", "NABU"
				'AssignTag helper, "acc!SSHOE_BM", "BM"
				'AssignTag helper, "acc!SSHOE_RUECKBUCHUNG", "RUECKBUCHUNG"
				helper.Save
				sStandardFilter = "SKAStornoSollAufHabenInEUR"
			Case "-SKA00_Umsätze_zu_OBR_nicht_in_EUR_manuell.IMD"
				AssignTag helper, "acc!MONE_KONTO_NR", "KONTO_NR"
				AssignTag helper, "acc!MONE_KONTO_BEZ", "KONTOBEZEICHNUNG"
				AssignTag helper, "acc!MONE_BUDAT", "BUCHUNGSDATUM"
				AssignTag helper, "acc!MONE_WERTDAT", "WERTSTELLUNG"
				AssignTag helper, "acc!MONE_BETRAG", "BETRAG"
				AssignTag helper, "acc!MONE_WKZ", "WKZ"
				AssignTag helper, "acc!MONE_TEXT", "TEXTSCHLÜSSEL"
				AssignTag helper, "acc!MONE_KTO_RAHMEN", "KTO_RAHMEN"
				AssignTag helper, "acc!MONE_AUFTRAGG_KTO", "AUFTRAGG_KTO"
				AssignTag helper, "acc!MONE_PN", "PN"
				AssignTag helper, "acc!MONE_VERZW", "VERWENDUNGSZWECK"
				AssignTag helper, "acc!MONE_SHK", "SHK"
				AssignTag helper, "acc!MONE_RAHMNR_2", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!MONE_RAHMNR_3", "RAHMENNR_3STELLIG"
				AssignTag helper, "acc!MONE_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
				AssignTag helper, "acc!MONE_REL", "RELEVANT"
				AssignTag helper, "acc!MONE_KTO", "KONTO"
				AssignTag helper, "acc!MONE_BEZ", "BEZEICHNUNG"
				AssignTag helper, "acc!MONE_AZ9SALDO", "AZ9_SALDO"
				AssignTag helper, "acc!MONE_SHK_OBR", "SHK1"
				AssignTag helper, "acc!MONE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!MONE_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				AssignTag helper, "acc!MONE_POSSHORT", "POSITION_SHORT"
				AssignTag helper, "acc!MONE_ERDAT", "ERÖFFNUNG"
				AssignTag helper, "acc!MONE_AUFDAT", "AUFLÖSUNG"
				AssignTag helper, "acc!MONE_MANBUCH", "MANUELLE_BUCHUNGEN"
				AssignTag helper, "acc!MONE_WERTJAHR", "WERTSTELLUNG_JAHR"
				'AssignTag helper, "acc!MONE_RELBETRAG", "RELEVANTER_BETRAG"
				AssignTag helper, "acc!MONE_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				'AssignTag helper, "acc!MONE_NABU", "NABU"
				'AssignTag helper, "acc!MONE_BM", "BM"
				'AssignTag helper, "acc!MONE_RUECKBUCHUNG", "RUECKBUCHUNG"
				helper.Save
				sStandardFilter = "SKAUmsatzManuellNichtEUR"
			Case "-SKA00_HabenBuchungen_auf_SollKonten_zu_OBR_nicht_in_EUR.IMD"
				AssignTag helper, "acc!HSONE_KONTO_NR", "KONTO_NR"
				AssignTag helper, "acc!HSONE_KONTO_BEZ", "KONTOBEZEICHNUNG"
				AssignTag helper, "acc!HSONE_BUDAT", "BUCHUNGSDATUM"
				AssignTag helper, "acc!HSONE_WERTDAT", "WERTSTELLUNG"
				AssignTag helper, "acc!HSONE_BETRAG", "BETRAG"
				AssignTag helper, "acc!HSONE_WKZ", "WKZ"
				AssignTag helper, "acc!HSONE_TEXT", "TEXTSCHLÜSSEL"
				AssignTag helper, "acc!HSONE_KTO_RAHMEN", "KTO_RAHMEN"
				AssignTag helper, "acc!HSONE_AUFTRAGG_KTO", "AUFTRAGG_KTO"
				AssignTag helper, "acc!HSONE_PN", "PN"
				AssignTag helper, "acc!HSONE_VERZW", "VERWENDUNGSZWECK"
				AssignTag helper, "acc!HSONE_SHK", "SHK"
				AssignTag helper, "acc!HSONE_RAHMNR_2", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!HSONE_RAHMNR_3", "RAHMENNR_3STELLIG"
				AssignTag helper, "acc!HSONE_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
				AssignTag helper, "acc!HSONE_REL", "RELEVANT"
				AssignTag helper, "acc!HSONE_KTO", "KONTO"
				AssignTag helper, "acc!HSONE_BEZ", "BEZEICHNUNG"
				AssignTag helper, "acc!HSONE_AZ9SALDO", "AZ9_SALDO"
				AssignTag helper, "acc!HSONE_SHK_OBR", "SHK1"
				AssignTag helper, "acc!HSONE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!HSONE_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				AssignTag helper, "acc!HSONE_POSSHORT", "POSITION_SHORT"
				AssignTag helper, "acc!HSONE_ERDAT", "ERÖFFNUNG"
				AssignTag helper, "acc!HSONE_AUFDAT", "AUFLÖSUNG"
				AssignTag helper, "acc!HSONE_MANBUCH", "MANUELLE_BUCHUNGEN"
				AssignTag helper, "acc!HSONE_WERTJAHR", "WERTSTELLUNG_JAHR"
				'AssignTag helper, "acc!HSONE_RELBETRAG", "RELEVANTER_BETRAG"
				AssignTag helper, "acc!HSONE_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				'AssignTag helper, "acc!HSONE_NABU", "NABU"
				'AssignTag helper, "acc!HSONE_BM", "BM"
				'AssignTag helper, "acc!HSONE_RUECKBUCHUNG", "RUECKBUCHUNG"
				helper.Save
				sStandardFilter = "SKAHabenAufSollNichtEUR"
			Case "-SKA00_SollBuchungen_auf_HabenKonten_zu_OBR_nicht_in_EUR.IMD"
				AssignTag helper, "acc!SHONE_KONTO_NR", "KONTO_NR"
				AssignTag helper, "acc!SHONE_KONTO_BEZ", "KONTOBEZEICHNUNG"
				AssignTag helper, "acc!SHONE_BUDAT", "BUCHUNGSDATUM"
				AssignTag helper, "acc!SHONE_WERTDAT", "WERTSTELLUNG"
				AssignTag helper, "acc!SHONE_BETRAG", "BETRAG"
				AssignTag helper, "acc!SHONE_WKZ", "WKZ"
				AssignTag helper, "acc!SHONE_TEXT", "TEXTSCHLÜSSEL"
				AssignTag helper, "acc!SHONE_KTO_RAHMEN", "KTO_RAHMEN"
				AssignTag helper, "acc!SHONE_AUFTRAGG_KTO", "AUFTRAGG_KTO"
				AssignTag helper, "acc!SHONE_PN", "PN"
				AssignTag helper, "acc!SHONE_VERZW", "VERWENDUNGSZWECK"
				AssignTag helper, "acc!SHONE_SHK", "SHK"
				AssignTag helper, "acc!SHONE_RAHMNR_2", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!SHONE_RAHMNR_3", "RAHMENNR_3STELLIG"
				AssignTag helper, "acc!SHONE_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
				AssignTag helper, "acc!SHONE_REL", "RELEVANT"
				AssignTag helper, "acc!SHONE_KTO", "KONTO"
				AssignTag helper, "acc!SHONE_BEZ", "BEZEICHNUNG"
				AssignTag helper, "acc!SHONE_AZ9SALDO", "AZ9_SALDO"
				AssignTag helper, "acc!SHONE_SHK_OBR", "SHK1"
				AssignTag helper, "acc!SHONE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!SHONE_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				AssignTag helper, "acc!SHONE_POSSHORT", "POSITION_SHORT"
				AssignTag helper, "acc!SHONE_ERDAT", "ERÖFFNUNG"
				AssignTag helper, "acc!SHONE_AUFDAT", "AUFLÖSUNG"
				AssignTag helper, "acc!SHONE_MANBUCH", "MANUELLE_BUCHUNGEN"
				AssignTag helper, "acc!SHONE_WERTJAHR", "WERTSTELLUNG_JAHR"
				'AssignTag helper, "acc!SHONE_RELBETRAG", "RELEVANTER_BETRAG"
				AssignTag helper, "acc!SHONE_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				'AssignTag helper, "acc!SHONE_NABU", "NABU"
				'AssignTag helper, "acc!SHONE_BM", "BM"
				'AssignTag helper, "acc!SHONE_RUECKBUCHUNG", "RUECKBUCHUNG"
				helper.Save
				sStandardFilter = "SKASollAufHabenNichtEUR"
			Case "-SKA00_Storno_HabenBuchungen_auf_SollKonten_zu_OBR_nicht_in_EUR.IMD"
				AssignTag helper, "acc!SHSONE_KONTO_NR", "KONTO_NR"
				AssignTag helper, "acc!SHSONE_KONTO_BEZ", "KONTOBEZEICHNUNG"
				AssignTag helper, "acc!SHSONE_BUDAT", "BUCHUNGSDATUM"
				AssignTag helper, "acc!SHSONE_WERTDAT", "WERTSTELLUNG"
				AssignTag helper, "acc!SHSONE_BETRAG", "BETRAG"
				AssignTag helper, "acc!SHSONE_WKZ", "WKZ"
				AssignTag helper, "acc!SHSONE_TEXT", "TEXTSCHLÜSSEL"
				AssignTag helper, "acc!SHSONE_KTO_RAHMEN", "KTO_RAHMEN"
				AssignTag helper, "acc!SHSONE_AUFTRAGG_KTO", "AUFTRAGG_KTO"
				AssignTag helper, "acc!SHSONE_PN", "PN"
				AssignTag helper, "acc!SHSONE_VERZW", "VERWENDUNGSZWECK"
				AssignTag helper, "acc!SHSONE_SHK", "SHK"
				AssignTag helper, "acc!SHSONE_RAHMNR_2", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!SHSONE_RAHMNR_3", "RAHMENNR_3STELLIG"
				AssignTag helper, "acc!SHSONE_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
				AssignTag helper, "acc!SHSONE_REL", "RELEVANT"
				AssignTag helper, "acc!SHSONE_KTO", "KONTO"
				AssignTag helper, "acc!SHSONE_BEZ", "BEZEICHNUNG"
				AssignTag helper, "acc!SHSONE_AZ9SALDO", "AZ9_SALDO"
				AssignTag helper, "acc!SHSONE_SHK_OBR", "SHK1"
				AssignTag helper, "acc!SHSONE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!SHSONE_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				AssignTag helper, "acc!SHSONE_POSSHORT", "POSITION_SHORT"
				AssignTag helper, "acc!SHSONE_ERDAT", "ERÖFFNUNG"
				AssignTag helper, "acc!SHSONE_AUFDAT", "AUFLÖSUNG"
				AssignTag helper, "acc!SHSONE_MANBUCH", "MANUELLE_BUCHUNGEN"
				AssignTag helper, "acc!SHSONE_WERTJAHR", "WERTSTELLUNG_JAHR"
				'AssignTag helper, "acc!SHSONE_RELBETRAG", "RELEVANTER_BETRAG"
				AssignTag helper, "acc!SHSONE_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				'AssignTag helper, "acc!SHSONE_NABU", "NABU"
				'AssignTag helper, "acc!SHSONE_BM", "BM"
				'AssignTag helper, "acc!SHSONE_RUECKBUCHUNG", "RUECKBUCHUNG"
				helper.Save
				sStandardFilter = "SKAStornoHabenAufSollNichtEUR"
			Case "-SKA00_Storno_SollBuchungen_auf_HabenKonten_zu_OBR_in_EUR.IMD"
				AssignTag helper, "acc!SSHONE_KONTO_NR", "KONTO_NR"
				AssignTag helper, "acc!SSHONE_KONTO_BEZ", "KONTOBEZEICHNUNG"
				AssignTag helper, "acc!SSHONE_BUDAT", "BUCHUNGSDATUM"
				AssignTag helper, "acc!SSHONE_WERTDAT", "WERTSTELLUNG"
				AssignTag helper, "acc!SSHONE_BETRAG", "BETRAG"
				AssignTag helper, "acc!SSHONE_WKZ", "WKZ"
				AssignTag helper, "acc!SSHONE_TEXT", "TEXTSCHLÜSSEL"
				AssignTag helper, "acc!SSHONE_KTO_RAHMEN", "KTO_RAHMEN"
				AssignTag helper, "acc!SSHONE_AUFTRAGG_KTO", "AUFTRAGG_KTO"
				AssignTag helper, "acc!SSHONE_PN", "PN"
				AssignTag helper, "acc!SSHONE_VERZW", "VERWENDUNGSZWECK"
				AssignTag helper, "acc!SSHONE_SHK", "SHK"
				AssignTag helper, "acc!SSHONE_RAHMNR_2", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!SSHONE_RAHMNR_3", "RAHMENNR_3STELLIG"
				AssignTag helper, "acc!SSHONE_NAGGRENZE", "NICHTAUFGRIFFSGRENZE"
				AssignTag helper, "acc!SSHONE_REL", "RELEVANT"
				AssignTag helper, "acc!SSHONE_KTO", "KONTO"
				AssignTag helper, "acc!SSHONE_BEZ", "BEZEICHNUNG"
				AssignTag helper, "acc!SSHONE_AZ9SALDO", "AZ9_SALDO"
				AssignTag helper, "acc!SSHONE_SHK_OBR", "SHK1"
				AssignTag helper, "acc!SSHONE_RAHMNR_2_OBR", "RAHMENNR_2STELLIG"
				AssignTag helper, "acc!SSHONE_POSITION_AKT_JAHR", "POSITION_AKT_JAHR"
				AssignTag helper, "acc!SSHONE_POSSHORT", "POSITION_SHORT"
				AssignTag helper, "acc!SSHONE_ERDAT", "ERÖFFNUNG"
				AssignTag helper, "acc!SSHONE_AUFDAT", "AUFLÖSUNG"
				AssignTag helper, "acc!SSHONE_MANBUCH", "MANUELLE_BUCHUNGEN"
				AssignTag helper, "acc!SSHONE_WERTJAHR", "WERTSTELLUNG_JAHR"
				'AssignTag helper, "acc!SSHONE_RELBETRAG", "RELEVANTER_BETRAG"
				AssignTag helper, "acc!SSHONE_BUCHUNGSKATEGORIE_BV", "BUCHUNGSKATEGORIE_BV"
				'AssignTag helper, "acc!SSHONE_NABU", "NABU"
				'AssignTag helper, "acc!SSHONE_BM", "BM"
				'AssignTag helper, "acc!SSHONE_RUECKBUCHUNG", "RUECKBUCHUNG"
				helper.Save
				sStandardFilter = "SKAStornoSollAufHabenNichtEUR"
			' AS 18.11.2020: OBR Tagging
			Case "{OBR_Konten_" & sAktuelleGJAHR & "}.IMD"
				AssignTag helper, "acc!OBR_KONTO_NR", "KONTO"
				helper.Save
				sStandardFilter = "SK_FuR_Prüfung_OBR"
			Case Else
		End Select
		Set helper = Nothing
		Set oTM = Nothing
		Set eqnBuilder = SmartContext.MacroCommands.ContentEquationBuilder()
		Set resultObject = SmartContext.MacroCommands.SimpleCommands.CreateResultObject(DatabaseName, FINAL_RESULT, True, 0)
		' MappedTestIds" muss so bleiben! ContentAreaName -> eigenen Namen nutzen
		resultObject.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter(sStandardFilter)
		SmartContext.TestResultFiles.Add resultObject
		Set eqnBuilder = Nothing
		Set resultObject = Nothing
	Else
		Set helper = Nothing
		Set oTM = Nothing
		db.Close
		Set db = Nothing
	End If

End Function

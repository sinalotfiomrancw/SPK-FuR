'-------------------------------------------------------------------------------------
' Title:		SK-FuR - Import Routine.Import_Select_Folder
' CIR:		SK-FuR - Import Routine
' Customer:	SK
' Created by:	AS
' Created on:	22.01.2021
' Version:		1.0.0
'-------------------------------------------------------------------------------------
' Decription:	
'-------------------------------------------------------------------------------------
' Result files:	
'			
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

Const DebugMode = 0

' Constants for UniqueFileName and CreateResultObject functions
Const INPUT_DATABASE As Long = 1
Const INTERMEDIATE_RESULT As Long = 2
Const FINAL_RESULT As Long = 4

' Excecution status constants
Const EXEC_STATUS_FAILED As Long = 0
Const EXEC_STATUS_SUCCEEDED = 1
Const EXEC_STATUS_CANCELED As Long = 3

' Common SmartAnalyzer variables
Dim oMC As Object
Dim oSC As Object
Dim oTM As Object
Dim oLog As Object
'Dim oProtectIP As Object
Dim oPara As Object

' Files
Dim sAuxData As String

dim sUms�tze as string ' Ordnerpfad
dim sUms�tzeVorlage as string
Dim sOBRKonten as string
Dim sOBRKontenVorlage as string
Dim sOBRKontenName as string
Dim sOBRKontenAlias as string
dim sHKKonten as string
dim sHKKontenVorlage as string
Dim sHKKontenName as string
Dim sHKKontenAlias as string
dim sPrimanoten as string
dim sPrimanotenVorlage as string
Dim sPrimanotenName as string
Dim sPrimanotenAlias as string
dim sVersionNr as string
dim sPositionsschl�ssel as string
dim sPositionsschl�sselVorlage as string
Dim sPositionsschl�sselName as string
Dim sPositionsschl�sselAlias as string

dim sUmsatz_1 as string
dim bUmsatz_1 as boolean

' Folder
dim sWorkingfolderPfad as string
dim sWorkingfolderName as string

' Parameters
Dim bParametersSet As Boolean

dim sGesch�ftsjahr as string
dim sNichtaufgriffsgrenze as string

' IDEA standard variables
Dim db As Object
Dim dbName As String
Dim eqn As String
Dim task As Object
Dim field As Object
Dim table As Object

' Error Handling
Dim FunctionName              As String
Dim PreviousFunctionName      As String
Dim ErrHandler_CheckPointID   As String
Dim ErrHandler_ErrDescription As String
Dim ErrHandler_ErrorMsg       As String
Dim ErrHandler_ErrNumber      As Long

Dim m_checkpointName As String

' Select Folder
Dim oPageSettingsService As Object
Dim oSelectAuditFolderPageSettings As Object

' Import Ums�tze
Dim sImportFile As String
dim sImportFileFullPath as string
dim iCounterUms�tze as integer
dim sUms�tzeFileName as string

' Import CSV
dim sFileNameShort as string

Sub Main
FunctionName = "Main"
PreviousFunctionName = FunctionName
On Error GoTo errorhandlerMain
If DebugMode Then SmartContext.Log.LogMessage "START " & FunctionName

	Set oMc = SmartContext.MacroCommands
	Set oSC = SmartContext.MacroCommands.SimpleCommands
	Set oTM = SmartContext.MacroCommands.TagManagement
	Set oLog = SmartContext.Log
	'Set oProtectIP = SmartContext.MacroCommands.ProtectIP
	Set oPara = SmartContext.MacroCommands.GlobalParameters
	
	SmartContext.ExecutionStatus = EXEC_STATUS_FAILED

	oLog.LogMessage "Import Routine Name: " & SmartContext.TestName
	oLog.LogMessage "Import Routine Version: " & SmartContext.TestVersion
	oLog.LogMessage "Execution Time Start: " & Now()
	
SetCheckpoint "Get Project Parameters"
oLog.LogMessage m_checkpointName
	sAuxData = oSC.GetKnownLocationPath(11)
	sGesch�ftsjahr = oPara.Get4Project ("sGesch�ftsjahr")
	sNichtaufgriffsgrenze = oPara.Get4Project ("sNichtausgriffsgrenze")
	'------------------------------------------------------------------------------------
	sUms�tze = oPara.Get4Project ("sPfadUms�tze")
	sUms�tzeVorlage = oPara.Get4Project ("sUms�tzeVorlage")
	if sUms�tzeVorlage = "" then sUms�tzeVorlage = sAuxData & "\Umsatzliste.RDF"
	'------------------------------------------------------------------------------------
	sOBRKonten = oPara.Get4Project ("sPfadOBR")
	sOBRKontenVorlage = oPara.Get4Project ("sOBRKontenVorlage")
	if sOBRKontenVorlage = "" then sOBRKontenVorlage = sAuxData & "\OBR_Konten.RDF"
	sOBRKontenName = oSC.UniqueFileName("{OBR_Konten_" & sGesch�ftsjahr & "}.IMD")
	sOBRKontenAlias = "OBR_Konten"
	'------------------------------------------------------------------------------------
	sHKKonten = oPara.Get4Project ("sPfadHKKonten")
	if sHKKonten = "" then sHKKonten = sAuxData & "\HK_gesamt.csv"
	sHKKontenVorlage = oPara.Get4Project ("sHKKontenVorlage")
	if sHKKontenVorlage = "" then sHKKontenVorlage = sAuxData & "\HK_gesamt.RDF"
	sHKKontenName = oSC.UniqueFileName("{HK_Konten_" & sGesch�ftsjahr & "}.IMD")
	sHKKontenAlias = "HK_Konten"
	'------------------------------------------------------------------------------------
	sPrimanoten = oPara.Get4Project ("sPfadPrimanoten")
	if sPrimanoten = "" then sPrimanoten = sAuxData & "\Primanotenplan_19.1.csv"
	sPrimanotenVorlage = oPara.Get4Project ("sPrimanotenVorlage")
	if sPrimanotenVorlage = "" then sPrimanotenVorlage = sAuxData & "\Primanotenplan.RDF"
	sVersionNr = iSplit(sPrimanoten, ".", "_", 1, 2)
	sPrimanotenName = oSC.UniqueFileName("{Primanotenplan_" & sGesch�ftsjahr & "_" & sVersionNr &"}.IMD")
	sPrimanotenAlias = "Primanotenplan"
	'------------------------------------------------------------------------------------
	sPositionsschl�ssel = oPara.Get4Project ("sPfadPositionsschl�ssel")
	if sPositionsschl�ssel = "" then sPositionsschl�ssel = sAuxData & "\Positionsschl�ssel.csv"
	sPositionsschl�sselVorlage = oPara.Get4Project ("sPositionsschl�sselVorlage")
	if sPositionsschl�sselVorlage = "" then sPositionsschl�sselVorlage = sAuxData & "\Positionsschl�ssel.RDF"
	sPositionsschl�sselName = oSC.UniqueFileName("{Positionsschluessel_" & sGesch�ftsjahr & "}.IMD")
	sPositionsschl�sselAlias = "Positionsschluessel"
	'------------------------------------------------------------------------------------
	bParametersSet = false
'-----------------------------------------------------------------------
' Funktionsaufrufe
'-----------------------------------------------------------------------
SetCheckpoint "1.0.0"
	Call ImportUms�tze(sUms�tze, sUms�tzeVorlage, "")
	Call ImportCSV(sOBRKonten, sOBRKontenName, sOBRKontenAlias, sOBRKontenVorlage, "")
	Call ImportCSV(sHKKonten, sHKKontenName, sHKKontenAlias, sHKKontenVorlage, "")
	Call ImportCSV(sPrimanoten, sPrimanotenName, sPrimanotenAlias, sPrimanotenVorlage, "")
	Call ImportCSV(sPositionsschl�ssel, sPositionsschl�sselName, sPositionsschl�sselAlias, sPositionsschl�sselVorlage, "")
SetCheckpoint "1.1.0"
	Set oPageSettingsService = SmartContext.GetServiceById("CirWizardPageSettingsService")
	Set oSelectAuditFolderPageSettings = oPageSettingsService.GetCirWizardPageSettings("SelectAuditFolder")	
	
	If oSelectAuditFolderPageSettings is Nothing Then
		SmartContext.Log.LogWarning "The settings object for the page SelectAuditFolder was not found."        
	Else	
		oSelectAuditFolderPageSettings.Enabled = true		
		'oSelectAuditFolderPageSettings.Inputs.Add "PeriodStart", ""
		'oSelectAuditFolderPageSettings.Inputs.Add "PeriodEnd", ""
	End If
	set oSelectAuditFolderPageSettings = Nothing   
	set oPageSettingsService = Nothing
'-----------------------------------------------------------------------

	oLog.LogMessage "Execution Time End: " & Now()
	
	SmartContext.ExecutionStatus = EXEC_STATUS_SUCCEEDED

	If SmartContext.IsCancellationRequested Then
		SmartContext.ExecutionStatus = EXEC_STATUS_CANCELED
		Exit Sub 
	End If

	'clear objects
	Set oMC		= Nothing
	Set oSC        	= Nothing
	'Set oProtectIP 	= Nothing
	Set oTM		= Nothing
	Set oLog		= Nothing
	Set oPara		= Nothing
	'Set oStrings   = Nothing
	'Set oFM        = Nothing
Exit Sub
errorhandlerMain:
	Call LogSmartAnalyzerError("")		
End Sub
'-------------------------------------------------------------------------------------------------------------
' Import Ums�tze
'-------------------------------------------------------------------------------------------------------------
Function ImportUms�tze(ByVal sFolderPath As String, ByVal sTemplate As String, ByVal sFilter As String)
On Error GoTo ErrorHandler
PreviousFunctionName = FunctionName
FunctionName = "Import Ums�tze"

If DebugMode Then SmartContext.Log.LogMessage "START " & FunctionName

SetCheckpoint "1.0.0"
oLog.LogMessage "Begin Import Ums�tze"
	sImportFile = Dir(sFolderPath & "\*3569_*.csv")
	If sImportFile = "" Then
		oLog.LogWarning "Im Verzeichnis" & sFolderPath
		oLog.LogWarning "Keine Umsatzdatei mit Kennzeichen *3569_* gefunden. Die Ausf�hrung des Makros wird gestoppt."
		SmartContext.AbortImport = True
		stop
	Else
		iCounterUms�tze = 0
		While sImportFile <> ""
			sImportFileFullPath = sFolderPath & "\" & sImportFile
			iCounterUms�tze = iCounterUms�tze + 1
			sUms�tzeFileName = oSC.UniqueFileName("Umsatz_" & iCounterUms�tze & ".IMD")
			Client.ImportDelimFile sImportFileFullPath, sUms�tzeFileName, FALSE, sFilter, sTemplate, TRUE
			If Not SmartContext.ImportFiles.Contains("Umsatz_" & iCounterUms�tze) Then SmartContext.RegisterDatabase sUms�tzeFileName, "Umsatz_" & iCounterUms�tze
			sImportFile = Dir()
		Wend
	End If
oLog.LogMessage "End Import Ums�tze"
Exit Sub
		
errorhandler:
	Call LogSmartAnalyzerError("")	
	Stop
end function
'-------------------------------------------------------------------------------------------------------------
' Import CSV
'-------------------------------------------------------------------------------------------------------------
Function ImportCSV(ByVal sFilePath As String, ByVal sFileName As String, ByVal sFileAlias As String,ByVal sTemplate As String, ByVal sFilter As String)
On Error GoTo ErrorHandler
PreviousFunctionName = FunctionName
FunctionName = "Import CSV"

If DebugMode Then SmartContext.Log.LogMessage "START " & FunctionName

SetCheckpoint "1.0.0"
oLog.LogMessage "Begin Import CSV"
	sFileNameShort = iSplit(sFileName, "{", "}", 1, 0)
	Client.ImportDelimFile sFilePath, sFileName, FALSE, sFilter, sTemplate, TRUE
	If Not SmartContext.ImportFiles.Contains(sFileAlias) Then SmartContext.RegisterDatabase sFileName, sFileAlias
oLog.LogMessage "End Import CSV"
Exit Sub
		
errorhandler:
	Call LogSmartAnalyzerError("")	
	Stop
End Function
'-----------------------------------------------------------------------------------------
' Standard Funtions - Get Importes Database
'-----------------------------------------------------------------------------------------
Function GetImportedDatabaseName(ByVal logicalName As String, bvalid As Boolean) As String
	Dim databaseName As String
	On Error Resume Next
	databaseName = SmartContext.ImportFiles.Item(logicalName).ImportedFileName
	On Error GoTo errorhandler
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
	
errorhandler:
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
		
		'oPara.Delete4Project "sGesch�ftsjahr"
		'oPara.Delete4Project "sNichtaufgriffsgrenze"
		oPara.Delete4Project "sPfadUms�tze"
		oPara.Delete4Project "sUms�tzeVorlage"
		oPara.Delete4Project "sPfadOBR"
		oPara.Delete4Project "sOBRKontenVorlage"
		oPara.Delete4Project "sPfadHKKonten"
		oPara.Delete4Project "sHKKontenVorlage"
		oPara.Delete4Project "sPfadPrimanoten"
		oPara.Delete4Project "sPrimanotenVorlage"
		oPara.Delete4Project "sPfadPositionsschl�ssel"
		oPara.Delete4Project "sPositionsschl�sselVorlage"
		
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

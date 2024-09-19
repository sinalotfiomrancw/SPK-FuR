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
Dim oProtectIP As Object
Dim oPara As Object
Dim oParameter As Object

Dim sourceFileName As String

' IDEA standard variables
Dim db As Object
Dim dbName As String
Dim eqn As String
Dim task As Object

' Error Handling
Dim FunctionName              As String
Dim PreviousFunctionName      As String
Dim ErrHandler_CheckPointID   As String
Dim ErrHandler_ErrDescription As String
Dim ErrHandler_ErrorMsg       As String
Dim ErrHandler_ErrNumber      As Long

' Specific Function Variables
Dim sPath As String
Dim sLibraryPath As String

Sub Main
FunctionName = "Main"
PreviousFunctionName = FunctionName
On Error GoTo ErrorHandler
If DebugMode Then SmartContext.Log.LogMessage "START " & FunctionName

	Set oMc = SmartContext.MacroCommands
	Set oSC = SmartContext.MacroCommands.SimpleCommands
	Set oTM = SmartContext.MacroCommands.TagManagement
	Set oLog = SmartContext.Log
	Set oProtectIP = SmartContext.MacroCommands.ProtectIP
	Set oPara = SmartContext.MacroCommands.GlobalParameters
	Set oParameter = SmartContext.Parameters
	
	SmartContext.ExecutionStatus =EXEC_STATUS_FAILED

	oLog.LogMessage "Import Routine Name: " & SmartContext.TestName
	oLog.LogMessage "Import Routine Version: " & SmartContext.TestVersion
	oLog.LogMessage "Execution Time Start: " & Now()
	
	' should be used instead of client.workingdirectory because
	' it changes after an audit test runs on a table from a sub folder
	
	
'-----------------------------------------------------------------------
' Funktionsaufrufe
'-----------------------------------------------------------------------
	
	Call OpenDialog
	
	If SmartContext.IsCancellationRequested Then
		SmartContext.ExecutionStatus = EXEC_STATUS_CANCELED
		GoTo ErrorHandler 
	End If	
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
	Set oProtectIP 	= Nothing
	Set oTM		= Nothing
	Set oLog		= Nothing
	Set oPara		= Nothing
	'Set oStrings   = Nothing
	'Set oFM        = Nothing
Exit Sub

ErrorHandler:
	Dim ec As Long
	ec = err.Number

	Dim ed As String
	ed = err.Description

	Dim es As String
	es = err.Source
	
	SmartContext.ExecutionStatus = EXEC_STATUS_FAILED
	SmartContext.Log.LogError ec  & ed & es
	Err.Clear

	'clear objects
	'Set oMC        = Nothing
	Set oSC        	= Nothing
	Set oProtectIP 	= Nothing
	Set oTM		= Nothing
	Set oLog		= Nothing
	Set oPara		= Nothing
	'Set oStrings   = Nothing
	'Set oFM        = Nothing		
End Sub

Function OpenDialog
On Error GoTo ErrorHandler
PreviousFunctionName = FunctionName
FunctionName = "OpenDialog"

If DebugMode Then SmartContext.Log.LogMessage "START " & FunctionName

ErrHandler_CheckPointID = "1.0.0 Open Dialog"

Dim dialogInvoker As Object
Dim result As Object
Dim args As Object
Dim dict As Object
Dim returnedValues As Object
	
	Set dialogInvoker = SmartContext.GetServiceById("MacroDialogInvoker")
	If dialogInvoker is Nothing Then
		SmartContext.Log.LogError "Der Dialog für den Pfad der Datei konnte nicht angezeigt werden, da der MacroDialogInvoker Service nicht vorhanden ist."
	End If
	
	Set args = dialogInvoker.NewTaskParameters
	Set dict = oSC.CreateHashtable
	dict.Add "SmartContextKey", SmartContext
	
	args.Inputs.Add "smartDataExchanger", dict
	
	oLog.LogMessage "Starting the Dialog"
	
	Set result = dialogInvoker.PerformTask("Modify_PN", args)
	
	oLog.LogMessage "performing Dialog-Task was succesfull"
	
	Set dialogInvoker = Nothing
	Set args = Nothing
	Set dict = Nothing
Exit Sub
		
errorhandler:
	ErrHandler_ErrNumber = Err.Number
	ErrHandler_ErrDescription = Err.Description
	Call MainErrorHandler()
End Function

Sub MainErrorHandler()
    ErrHandler_ErrorMsg = "Error number: " & ErrHandler_ErrNumber & " has occurred in Function: " + FunctionName + " at chkpoint " & _
                           ErrHandler_CheckPointID + ", with Error Message: [" & ErrHandler_ErrDescription & "]"
    SmartContext.Log.LogError ErrHandler_ErrorMsg
    Err.Clear    
End Sub

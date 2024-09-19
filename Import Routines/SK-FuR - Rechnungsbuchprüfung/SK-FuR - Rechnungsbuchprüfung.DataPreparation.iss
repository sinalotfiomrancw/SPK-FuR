Option Explicit

'#Region - SmartAnalyzer standard constants
' Execution status codes
Const EXEC_STATUS_FAILED    As Long = 0
Const EXEC_STATUS_SUCCEEDED As Long = 1
Const EXEC_STATUS_CANCELED  As Long = 3

' Result file type codes
' Used for UniqueFileName and CreateResultObject functions
Const NOT_A_RESULT          As Long = 0
Const INPUT_DATABASE        As Long = 1
Const INTERMEDIATE_RESULT   As Long = 2
Const FINAL_RESULT          As Long = 4
Const NO_REGISTRATION       As Long = 8
'#End Region

'#Region - SmartAnalyzer standard variables
' m_checkpointName is used for error logging and this variable has to be kept global!
' The value provided by this variable shall give a clue where an error occurred.
' Remarks: It is set in Sub 'SetCheckpoint'
'          And  used in Sub 'LogSmartAnalyzerError'
Dim m_checkpointName As String

' The following variables are defined globally because they might be used in several sub routines.
' If this is not the case, please remove the variables from here!
Dim oMC As Object 	' Macro Commands Object
Dim oSC As Object 	' Simple Commands Object
Dim oTM As Object 	' Task Management Object
Dim oPip As Object	' Object for Protecting the Intellectual Property
dim oPara as object
'#End Region

'#Region - IDEA standard variables
' These variables are only globally defined because "Option Explicit"
' is used and IDEA is not recording them anymore.
' Defining these variables narrow to the place where they are used would be much better.
Dim db As Object
Dim task As Object
Dim field As Object
Dim table As Object
Dim eqn As String
Dim dbName As String
'#End Region

'#Region - Files
Dim sInputFile as string
dim sRebu_Rdf as string
dim sRebu_FileName as string
'#End Region

'#Region - Importdefinitions

'#End Region

'#Region - Files Alias
Const sRebu_FileAlias as string = "Rebu"
'#End Region
Sub Main()
	On Error GoTo ErrHandler:
	
	SetCheckpoint "Begin of Sub Main()"
	
	SmartContext.Log.LogMessage "Preparation-Macro of Import Routine '{0}'", SmartContext.TestName
	SmartContext.Log.LogMessage "Import Routine Version = {0}", SmartContext.TestVersion
	SmartContext.Log.LogMessage "Starting Time: {0}", Format(Now(), "yyyy-MM-dd hh:mm:ss")
	
	' Please check whether the variables below are really needed.
	' Remove all unnecessary variables and this comment too
	Set oMC = SmartContext.MacroCommands
	Set oSC = oMC.SimpleCommands
	Set oTM = oMC.TagManagement
	Set oPip = oMC.ProtectIP
	Set oPara = oMC.GlobalParameters
	
	' **** Add your code below this line
	Call GetParameters
	Call Import
	Call Preparation
	Call RegisterResult(sRebu_FileName, FINAL_RESULT)
	' **** End of the user specific code
	
	SmartContext.ExecutionStatus = EXEC_STATUS_SUCCEEDED
	
	SetCheckpoint "End of Sub Main()"
	
	Set oMC = nothing
	Set oSC = nothing
	Set oTM = nothing
	Set oPip = nothing
	Set oPara = nothing
	
	SmartContext.Log.LogMessage "The special routine ends at: {0}", Format(Now(), "yyyy-MM-dd hh:mm:ss")
	
	Exit Sub
	
ErrHandler:
	Call LogSmartAnalyzerError("")
	
	If SmartContext.ExecutionStatus = EXEC_STATUS_FAILED Or _
	          SmartContext.ExecutionStatus = EXEC_STATUS_CANCELED Then
		SmartContext.AbortImport = True
	End If
	
	Call EndSequenze
End Sub
' --------------------------------------------------------------------------

' Gets the Parameter from the pre routine.
' Checks whether the files exist should be implemented. 17.10.2022
function GetParameters
SetCheckpoint "GetParameters 1.0 - get project parameter"
	sInputFile = oPara.Get4Project("FolderPath")
SetCheckpoint "GetParameters 2.0 - get parameter from appdata"
	sRebu_Rdf = oSC.GetKnownLocationPath(11) & "\Rechnungsbuch.rdf"
	if FileExists(sRebu_Rdf) = false then
		Err.Raise Number:= 1001, Description:= "Rdf-File could not be found: '" & sRebu_Rdf & "'"
	end if
	SmartContext.Log.LogMessage "Verwendete Importvorlage: " & sRebu_Rdf
end function
' --------------------------------------------------------------------------

' gets the file extension
function GetFileExtension(byval sFilePath as string) as string
dim fso as object
SetCheckpoint "GetFileExtension 1.0 - get extension for " & sFilePath
	Set fso = CreateObject("Scripting.FileSystemObject")
	GetFileExtension = UCase(fso.GetExtensionName(sFilePath))
	Set fso = nothing
end function
' --------------------------------------------------------------------------

' Start the import of the chosen file.
function Import
SetCheckpoint "Import 1.0 - create file name"
	sRebu_FileName = oSC.UniqueFileName("Rechnungsbuch.IMD")
SetCheckpoint "Import 1.1 - import file"
	Client.ImportDelimFile sInputFile, sRebu_FileName, FALSE, "", sRebu_Rdf, TRUE
SetCheckpoint "Import 1.2 - add imported file to ImportFiles"
	'If Not SmartContext.ImportFiles.Contains(sRebu_FileAlias) Then SmartContext.RegisterDatabase sRebu_FileName, sRebu_FileAlias
end function
' --------------------------------------------------------------------------

' preparation
function Preparation
SetCheckpoint "Preparation 1.0 - ..."

end function
' --------------------------------------------------------------------------

' Registers final tables and sets tags.
function registerResult(sResultFile as string, iResultType as integer)
dim helper as object
dim eqnBuilder as object
Dim oList As Object
Dim mppTask As Object
SetCheckpoint "registerResult 1.0 - set objects"
	set eqnBuilder = oMC.ContentEquationBuilder()
SetCheckpoint "registerResult 2.0 - set tags for " & sResultFile
	Select Case sResultFile
		Case sRebu_FileName
			Set helper = oTM.Tagging(sResultFile)
			'helper.SetTag "acc!ID", "ID"
			helper.Save
			
			Set oList = oSC.CreateResultObject(sResultFile, iResultType, True, 1)
			SmartContext.TestResultFiles.Add oList
			oList.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter("Rebu")
		case else
	end select
	
	Set helper = Nothing
	Set eqnBuilder = nothing
	Set oList = nothing
end function
' --------------------------------------------------------------------------

' checks whether a give file can be found
Function FileExists(ByVal sFileName As String) As Boolean
Dim oFso As Object
	FileExists = FALSE
	Set oFso = CreateObject("Scripting.FileSystemObject")
	If oFso.FileExists(sFileName) = TRUE Then
		FileExists = TRUE
	Else
		FileExists = FALSE
	End If
	Set oFso = Nothing
End Function
' --------------------------------------------------------------------------

' Sets the value of the global variable "m_checkpointName".
' Checkpoints are identifying a position in the code.
' In case of an error the last passed checkpoint name will be logged. 
Sub SetCheckpoint(ByVal checkpointName As String)
	m_checkpointName = checkpointName
End Sub
' --------------------------------------------------------------------------

' Logs an error and in case the user canceled the execution, it logs the cancel state.
' extraInfo: Only used in case special information shall be logged - usually it is empty.
Sub LogSmartAnalyzerError(ByVal extraInfo As String)
On Error Resume Next
	If SmartContext.IsCancellationRequested Then
		SmartContext.ExecutionStatus = EXEC_STATUS_CANCELED
		
		SmartContext.Log.LogMessage "Excecution was stopped by user."
	Else
		SmartContext.ExecutionStatus = EXEC_STATUS_FAILED
		
		SmartContext.Log.LogError "An error occurred in a special routine of '{0}'.{1}Error #{2}, Error Description: {3}{1}" + _
		                          "The last passed checkpoint was: {4}", _
		                          SmartContext.TestName, Chr(10), Err.Number, Err.Description, m_checkpointName

		If Len(extraInfo) > 0 Then
			SmartContext.Log.LogError "Additional error information: " & extraInfo
		End If
	End If
	
	Call EndSequenze
End Sub
' --------------------------------------------------------------------------

' cleans the memory and ends the script
Function EndSequenze
	Set oMC = Nothing
	Set oSC = Nothing
	Set oTM = Nothing
	Set oPip = Nothing
	Set oPara = Nothing
	
	stop
End Function

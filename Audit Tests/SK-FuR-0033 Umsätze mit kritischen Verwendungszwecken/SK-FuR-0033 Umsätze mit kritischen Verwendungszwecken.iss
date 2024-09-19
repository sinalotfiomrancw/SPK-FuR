'SK-FuR-0033 macro

'Constants - parameters in ATs generation
Const SHORTNAME = "0033"    'audit test shortname; name: "SK-FuR-0033 Umsätze mit kritischen Verwendungszwecken"

Option Explicit

Const DebugMode =  0     '0 means NOT in debug mode

'The purpose of this Audit Test is to analyse the description of transactions regarding critical \
'texts and – optional - short texts.
'Results: 1 result
	
'Creation Date: 26.09.2023 Sina Lotfiomran


'Constants for CreateResultObject (Type of Result)
'SourceTable = 1
'IntermediateResult = 2
'FinalResult = 4
'Combinations are allowed
'ERR constants
Const ERR_MACRO_DEV As Integer = 9999   'error number for macro errors raised by developer

'ATs name
Const LOG_HEADER = "SK-FuR-0033 Umsätze mit kritischen Verwendungszwecken"     'macros name

'Constants for uniqueFileName function - correlated with Constants for CreateResultObject
Const NO_TYPE_RESULT As Long = 0
Const NO_REGISTRATION As Long = 8
Const INTERMEDIATE_RESULT As Long = 2
Const FINAL_RESULT As Long = 4
Const ANALYSE_BASE_TABLE As Long = 1

'Constants for executions status
Const EXECUTION_FAIL = 0
Const EXECUTION_SUCCESS = 1
Const EXECUTION_CANCELED = 3

'Constants for indexed extraction
Const WI_IE_NUMFLD  = 1
Const WI_IE_CHARFLD = 2
Const WI_IE_TIMEFLD = 3

'Constant for equation length
Const MAX_EQUATION_LENGTH = 10000

'________________________________________________________________________

'10.3 Columns name corresponding to tags
Dim snRelevant   			As String
Dim snKontoNummer			As String
Dim snBuchungsDatum			As String
Dim snWertstellung			As String
Dim snKontobezeichnung		As String
Dim snPN					As String
Dim snRahmennr2stellig		As String
Dim snPositionShort			As String
Dim snNichtaufgriffsgrenze	As String
Dim snVerwendungsZweck    	As String
Dim snBetrag				As String
Dim snManuelleBuchungen		As String
Dim snBuchungSVZ			As String
Dim snAuftragKonto			As String

Dim s_Temp0 As String
Dim sResultDescription_1 As String

Dim bTemp0_IsOpen As Boolean

'10.4	Placeholders and Strings

Dim sID_Result_1 			As String
Dim sID_ResultDescription_1_A 		As String
Dim sID_ResultDescription_1_B		As String
Dim sID_ResultDescription_1_C		As String
Dim sID_ResultExcelExport_1		As String
Dim sID_Fieldname_CriticalText		As String
Dim sID_Fieldname_Existing_CriticalText As String
Dim sID_Fielddescription_CriticalText_A	As String
Dim sID_Fielddescription_CriticalText_B	As String
Dim sID_Fielddescription_Existing_CriticalText_A	As String
Dim sID_Fielddescription_Existing_CriticalText_B	As String
Dim sFielddescription_CriticalText		As String
Dim sFielddescription_Existing_CriticalText		As String
Dim sID_Fieldname_ShortText		As String
Dim sID_Fielddescription_ShortText	As String

Dim bID_Result_1 As Boolean

'Common variables
Dim sWorkDir As String
Dim sExecutionOn As String
Dim sExecutedOn As String
Dim sdbname As String
Dim s As String
Dim sTemp1 As String
Dim sTemp2 As String
Dim aFiles() As String
Dim aTempFiles() As String
Dim iNumberOfFiles As Integer
Dim iNumberOfTempFiles As Integer
Dim sIndexes As String
Dim iNrOfIndeces As Integer
Dim iCrtNrOfIndeces As Integer
Dim sErrNumber As String
Dim sErrDescription As String
Dim subFunctionName As String
Dim subCheckPointID As String
Dim bPreparationFlag  As Boolean
Dim bExistFinalResults As Boolean'error result handler
Dim bExistsResult As Boolean'error result handler
Dim bErrInResult As Boolean'error result handler


'common objects
Dim oDB As Object
Dim oDB2 As Object
Dim oTable As Object
Dim oTable2 As Object
Dim oRS As Object
Dim oRS2 As Object
Dim oRec As Object
Dim nRowNr As Integer
Dim aFYE() As String
Dim oTableMgmt As Object
Dim oTask As Object
Dim oField As Object
Dim oFieldTB As Object
Dim oPM As Object
Dim oFieldStats As Object
Dim oTag As Object
Dim oTags As Object
Dim oIndexCleaner As Object

'strings from oStrings
Dim strResultName 	As String
Dim strResultShortName 	As String
Dim strNumberOfRecords As String
Dim strExecutionStatus 	As String
Dim strAuditTest       	As String
Dim sTestName          	As String

Dim nHistoryCount As Integer

'Error Handler
Dim ErrHandler_FunctionName	 As String
Dim FunctionName		As String
Dim ErrHandler_CheckPointID	As String
Dim ErrHandler_ErrDescription	As String
Dim ErrHandler_ErrorMsg		As String

Dim bMacroClearObjects 		As Boolean

'config
Dim sDBExtension  As String
Dim sLS           As String
Dim sDateMask     As String
Dim i As Long
Dim j As Long
Dim sName As String
Dim sDescription As String
Dim aTagTypes(32) As String
'context
Dim oParameters   As Object
Dim oResultFile   As Object
Dim sSourceName   As String
Dim bIsServerTask As Boolean

'dialog 
'checkbox
Dim chkAccountEnh	As Boolean
Dim chkUser			As Boolean
Dim chkVat			As Boolean
Dim chkCurrency		As Boolean
Dim chkSystem		As Boolean
Dim chkOrg			As Boolean
Dim chkWordSearch	As Boolean
Dim chkShortText	As Boolean
Dim chkShortHead	As Boolean
Dim chkCriticalText	As Boolean

Dim A_Checked As Boolean
Dim P_Checked As Boolean
Dim E_Checked As Boolean
Dim V_Checked As Boolean

'smartsinglelist
Dim sCriticalText		As String
Dim sCriticalText_1		As String
Dim sCriticalText_Existing As String
Dim sCriticalText_Existing_1 As String
Dim bSmartSingleList1	As Boolean
'Dim bSmartSingleList2	As Boolean


'smartfromtolist1
Dim sAccounts 				As String
Dim vTempColumnNames() 		As String
Dim sTempColumnName 		As String
Dim bToDeleteTempColumns	As Boolean
Dim bIsSourceTable 			As Boolean
Dim lngReservedLength 		As Long
Dim sEqnReserved 			As String

'smartfromtolist2
Dim sRahmennr 				As String

'smarttextbox 
Dim sdatefrom 		As String
Dim sdateto			As String
Dim sMinVal 		As String
Dim sShortText 		As String
Dim sShortHead 		As String

Dim oMC As Object
Dim oSC As Object
Dim oTM As Object
Dim oFM As Object

Dim oStrings   As Object
Dim oProtectIP As Object
Dim oMinMax    As Object


Dim oValues As Object
Dim vList As Variant
Dim vList2	As Variant
Dim vValue As Variant
Dim sValue As String
Dim sTempValue As String

Dim aList() As String
Dim bFilterForPosition as Boolean
Dim sPositionEqn as String

'enum VBFieldType
'Const WI_VIRT_CHAR = 0
'Const WI_VIRT_NUM = 1
'Const WI_VIRT_DATE = 2
'Const WI_CHAR_FIELD = 3
'Const WI_NUM_FIELD = 4
'Const WI_DATE_FIELD = 5
'Const WI_EDIT_NUM = 6
'Const WI_EDIT_CHAR = 7
'Const WI_EDIT_DATE = 8
'Const WI_MULTISTATE = 9
'Const WI_TRISTATE = 9
'Const WI_BOOL = 10
'Const WI_TIME_FIELD = 11
'Const WI_EDIT_TIME = 12
'Const WI_VIRT_TIME = 13

Sub Main

On Error GoTo ErrHnd
ErrHandler_FunctionName = "Main; "
ErrHandler_CheckPointID = "0.0"
	
	bMacroClearObjects = False
   Set oStrings      = SmartContext.Strings
   Set oMC           = SmartContext.MacroCommands
   Set oSC           = oMC.SimpleCommands
   Set oProtectIP    = oMC.ProtectIP

   strAuditTest = oStrings("AuditTest")
   sTestName = SmartContext.TestName
   
   'set ExecutionStatus (failure at the begin)
   strExecutionStatus = oStrings("ExecutionStatus")
   SmartContext.ExecutionStatus = EXECUTION_FAIL

   'get IsServerTask and Working Directory
   bIsServerTask = SmartContext.IsServerTask
   s = "bIsServerTask=" & bIsServerTask & "; ExecutionStatus: " & SmartContext.ExecutionStatus & " (FAIL)"
   Call Scrambling(s,false,true)

   If bIsServerTask Then
      sExecutionOn = oStrings("ExecutionOnServer")
      sExecutedOn = oStrings("ExecutedOnServer")
   Else
      sExecutionOn = oStrings("ExecutionOnClient")
      sExecutedOn = oStrings("ExecutedOnClient")
      sWorkDir = Client.WorkingDirectory
   End If
   
   Call Scrambling("SK-FuR-0033; sWorkDir on Client: " & sWorkDir,false,true)

   s = strAuditTest & sTestName  & "; " & oStrings("AuditTestVersion") & SmartContext.TestVersion
   SmartContext.Log.LogMessage s
   s = LOG_HEADER & "; Audit Test Version: " & SmartContext.TestVersion
   Call Scrambling(s,false,true)

   s = oStrings("StartDateAndTime") & Now() & "; " & sExecutionOn
   SmartContext.Log.LogMessage s
   Call Scrambling("START Date And Time: " & Now() ,false,true)
   
      If MacroSettings() Then

      If MacroValidation() Then

         If Preparation() Then

            If AddResults() Then 'error result handler

            'Set ExecutionStatus (success)
            SmartContext.ExecutionStatus = EXECUTION_SUCCESS
				
				End If 'error result handler
				
         End If

      End If

   End If

	If (SmartContext.ExecutionStatus = EXECUTION_FAIL) Then
		Call MacroRollback("Main")
	Else
		Call MacroClear("Main; ")
	End If

   Exit Sub

ErrHnd:
   sErrNumber = err.Number
   sErrDescription = err.Description
	If SmartContext.IsCancellationRequested Then	
		ErrHandler_ErrDescription = oStrings("ErrDescrAuditTestCanceledByUser")	
	Else	
		ErrHandler_ErrDescription = oStrings("ErrorNumber") & serrNumber & "; " & _ 
		oStrings("ErrorDescription") & serrDescription
	End If   
   SmartContext.Log.LogError ErrHandler_ErrDescription
   s = ErrHandler_FunctionName & "; " & ErrHandler_CheckPointID & "; " & sErrNumber & "; " & sErrDescription
   Call Scrambling(s, false, true)

   Call MacroRollback("ErrHnd_" & ErrHandler_FunctionName & "; ")

End Sub 'Main

'------------------------------------------------------------------------------------------------------
Function Preparation As Boolean
ErrHandler_FunctionName = "Preparation; "
ErrHandler_CheckPointID = "PR_1"
bPreparationFlag = True

	Dim sEqn_0 As String
	Dim sEqn_1 As String
	Dim sEqn_2 As String
	Dim sEqn_3 As String
	Dim sEqn_4 As String
	Dim sEqn_5 As String
	Dim sEqn_6 As String
	Dim sEqn_7 As String
	
	bID_Result_1 	= false 'error result handler
	bTemp0_IsOpen 	= False

SmartContext.ScriptProgress 10, 20

ErrHandler_CheckPointID = "Equation for Extraction Temp0"

	sEqn_0 = ""
	sEqn_3 = ""
	
	
	'//Date
	sEqn_0 = "1"
	
		
	If Len(sdatefrom) > 0 Then  
	
		sEqn_0 = "(" & snBuchungsDatum & " >= @ctod(""" & sdatefrom & """" & sLS & """YYYYMMDD""))" 
		
	End If

	If Len(sdateto) > 0 Then  
		
		sEqn_0 = sEqn_0 & " .AND. (" & snBuchungsDatum & " <= @ctod(""" & sdateto & """" & sLS & """YYYYMMDD""))"
	
	End If
	
	'//Value
	sEqn_0 = sEqn_0 & " .AND. " & "(@abs(" & snBetrag & ") >= " & sMinVal & ")"
	
	
	'//Accounts	
	sEqnReserved = ""
	sAccounts = ""
	sEqnReserved = sEqn_0 
	lngReservedLength = Len(sEqnReserved) + 7 + 2
	
	Set oParameters = SmartContext.Parameters
	If oParameters.Contains("smartFromToList1") Then
		bIsSourceTable = True
		sAccounts = BuildEquation_FromToList(sSourceName, bIsSourceTable, lngReservedLength)
	End If
	Set oParameters = Nothing		
	
	If Len(sAccounts) > 0 Then 
	sEqn_0 = sEqnReserved & " .AND. (" & sAccounts & ")"
	End If
	
	s = ErrHandler_CheckPointID & ": " 
	Call Scrambling(s,false,true)		
	s = "Reserved equation: " & sEqnReserved & ", reservedlength: " & lngReservedLength
	Call Scrambling(s,false,true)	
	s = "Built equation(sAccounts) : " & sAccounts	
	Call Scrambling(s,false,true)
	s = "Final equation: " & sEqn_0
	Call Scrambling(s,false,true)
	
	'//Rahmennr
	sEqnReserved = ""
	sRahmennr = ""
	sEqnReserved = sEqn_0
	lngReservedLength = Len(sEqnReserved) + 7 + 2
	
	Set oParameters = SmartContext.Parameters
	If oParameters.Contains("smartFromToList2") Then
		bIsSourceTable = True
		sRahmennr = BuildEquation_FromToList2(sSourceName, bIsSourceTable, lngReservedLength)
	End If
	Set oParameters = Nothing		
	
	If Len(sRahmennr) > 0 Then 
	sEqn_0 = sEqnReserved & " .AND. (" & sRahmennr & ")"
	End If
	
	s = ErrHandler_CheckPointID & ": " 
	Call Scrambling(s,false,true)		
	s = "Reserved equation: " & sEqnReserved & ", reservedlength: " & lngReservedLength
	Call Scrambling(s,false,true)	
	s = "Built equation(snRahmennr) : " & sRahmennr	
	Call Scrambling(s,false,true)
	s = "Final equation: " & sEqn_0
	Call Scrambling(s,false,true)
	
	'//Bilanzposition
	sEqnReserved = ""
	sEqnReserved = sEqn_0
	lngReservedLength = Len(sEqnReserved) + 7 + 2
	
	Set oParameters = SmartContext.Parameters
	Call CreateEQNFromDialogParameter(True)
	Set oParameters = Nothing	
	
	If Len(sPositionEqn) > 0 Then 
	sEqn_0 = sEqnReserved & " .AND. (" & sPositionEqn & ")"
	End If
	
	s = ErrHandler_CheckPointID & ": " 
	Call Scrambling(s,false,true)		
	s = "Reserved equation: " & sEqnReserved & ", reservedlength: " & lngReservedLength
	Call Scrambling(s,false,true)	
	s = "Built equation(snPositionShort) : " & sPositionEqn	
	Call Scrambling(s,false,true)
	s = "Final equation: " & sEqn_0
	Call Scrambling(s,false,true)
    
    sEqn_0 = oSC.Replace(sEqn_0,"YYYYMMDD",sDateMask)
    Call Scrambling(ErrHandler_CheckPointID & ", eqn: " & sEqn_0,false,true)        
	
ErrHandler_CheckPointID = "11.2	Extraction Temp0"

	s_Temp0 = oSC.UniqueFileName("Temp0", NO_REGISTRATION)
	sdbname = sSourceName
	Set oDB = Client.OpenDatabase(sdbname)
	Set oTask = oDB.Extraction
	oTask.IncludeAllFields
	
	'oTask.AddFieldToInc snRelevant		
	'oTask.AddFieldToInc snKontoNummer
	'oTask.AddFieldToInc snBuchungsDatum
	'oTask.AddFieldToInc snBetrag
	'oTask.AddFieldToInc snVerwendungsZweck
	'oTask.AddFieldToInc snWertstellung
	'oTask.AddFieldToInc snKontobezeichnung
	'oTask.AddFieldToInc snPN
	'oTask.AddFieldToInc snAuftragKonto
	'oTask.AddFieldToInc snRahmennr2stellig
	'oTask.AddFieldToInc snPositionShort
	'oTask.AddFieldToInc snBuchungSVZ
	'oTask.AddFieldToInc snManuelleBuchungen
	'oTask.AddFieldToInc snNichtaufgriffsgrenze
	
	'oTask.AddKey snBuchungsDatum, "A"
	'oTask.AddKey snRelevant, "A"
	'OTask.AddKey snKontoNummer, "A"
	'OTask.AddKey snVerwendungsZweck, "A"
	'OTask.AddKey snBetrag, "A"
	
	oTask.CreateVirtualDatabase = False	
	oTask.AddExtraction s_Temp0, "", sEqn_0 '"1 = 1"
	oTask.PerformTask 1, oDB.Count
	
	Set oTask = Nothing
	Call CloseDB()
	'used for temp files deletion
	Call AddTempFilesName(s_Temp0)
	'used for cancellation
	Call AddFilesName(s_Temp0)
	
	Call Scrambling(ErrHandler_CheckPointID & ", created: " & s_Temp0,false,true)  
	'ErrHandler_CheckPointID = "delete temporary columns (if) created by Equation builder"
	'DeleteTempColumns(bToDeleteTempColumns)	

	
	If Not oSC.FileIsValid(s_Temp0) Then 
ErrHandler_CheckPointID = "11.3.1 Extraction ID_Result_1"		
		sID_Result_1 = oSC.UniqueFileName(sID_Result_1, FINAL_RESULT)
		bID_Result_1 = true 
		sResultDescription_1 = sID_ResultDescription_1_B   
		
		sdbname = sSourceName 
		Set oDB = Client.OpenDatabase(sdbname)
		Set oTask = oDB.Extraction
		oTask.IncludeAllFields
		'oTask.AddFieldToInc snKontoNummer
		'oTask.AddFieldToInc snRelevant		
		'oTask.AddFieldToInc snBuchungsDatum
		'oTask.AddFieldToInc snBetrag
		'oTask.AddFieldToInc snVerwendungsZweck
		'oTask.AddFieldToInc snWertstellung	
		'oTask.AddFieldToInc snKontobezeichnung	
		'oTask.AddFieldToInc snPN
		'oTask.AddFieldToInc snAuftragKonto		
		'oTask.AddFieldToInc snRahmennr2stellig	
		'oTask.AddFieldToInc snPositionShort
		'oTask.AddFieldToInc snBuchungSVZ
		'oTask.AddFieldToInc snManuelleBuchungen
		'oTask.AddFieldToInc snNichtaufgriffsgrenze
		oTask.CreateVirtualDatabase = False
	ErrHandler_CheckPointID = "PR_4"
		oTask.AddExtraction sID_Result_1, "", "1 = 0"
		oTask.PerformTask 1, oDB.Count

		Set oTask = Nothing
		Call CloseDB()

		'used for cancellation
		Call AddFilesName(sID_Result_1)
		Call Scrambling(ErrHandler_CheckPointID & ", created: " & sID_Result_1,false,true)  
		
		Preparation = True
		
		Exit Function 

	End If		' for "If Not oSC.FileIsValid(s_Temp0)"	

	

ErrHandler_CheckPointID = "11.4.1.1.1/11.4.1.2.1 New Field ID_Fieldname_CriticalText"

	If chkCriticalText Then 'ok2
	
		sCriticalText = ""
		
'		If UBound(vList) > UBound(vList)	'vList is not empty 	???trebuie pusa aceasta conditie??
			
			If chkWordSearch Then
			
				i = 0
				For Each vValue In vList

					sValue = CStr(vValue)
					sTempValue = "\b" & sValue & "\b"
					If Right(sValue,1) = Chr(9) Then sValue = Left(sValue,Len(sValue)-1)

					i = i + 1
					If i = 1 Then 
						sCriticalText = "\b" & sValue & "\b"
						sEqn_3 = oSC.FormatString("@RegExpr(@lower({0}){1}@lower(""{2}""))", snVerwendungsZweck, sLS, sTempValue)
					Else 
						sCriticalText = sCriticalText & "|\b" & sValue & "\b"
						sEqn_3 = sEqn_3  & " + " & " "" "" " & " + "  & oSC.FormatString("@RegExpr(@lower({0}){1}@lower(""{2}""))", snVerwendungsZweck, sLS, sTempValue)
					End If
					
				Next
				Call Scrambling(ErrHandler_CheckPointID & ", eqn3: " & sEqn_3,false,true)
				
ErrHandler_CheckPointID = "equations for New Field ID_Fieldname_CriticalText/CriticalHead"

				'sEqn_1 = "@RegExpr( @lower(" & snVerwendungsZweck & ")" & sLS & "@lower(" & """" & sCriticalText & """" & ") ) "'???
				sEqn_1 = oSC.FormatString("@RegExpr(@lower({0}){1}@lower(""{2}""))", snVerwendungsZweck, sLS, sCriticalText)
				'sEqn_1 = "@If (@len(" & sEqn_1  & ") > 0" & sLS & """X""" & sLS & """"")"
				sEqn_1 = oSC.FormatString("@If (@len({0}) > 0{1}""X""{1}"""")",sEqn_1, sLS)
				'sEqn_3 = oSC.FormatString("@Proper(@AllTrim({0}))", sEqn_3)
				sEqn_3 = oSC.FormatString("@AllTrim({0})", sEqn_3)
				Call Scrambling(ErrHandler_CheckPointID & ", eqn1: " & sEqn_1,false,true)
				Call Scrambling(ErrHandler_CheckPointID & ", eqn3: " & sEqn_3,false,true) 				
				
				sFielddescription_CriticalText = sID_Fielddescription_CriticalText_B
				sFielddescription_Existing_CriticalText = sID_Fielddescription_Existing_CriticalText_B
				Call Scrambling(sFielddescription_Existing_CriticalText,false,true)
				Call Scrambling(sFielddescription_Existing_CriticalText,false,true)
						
			Else 'not chkWordSearch
			ErrHandler_CheckPointID = "not chkWordSearch equations for New Field ID_Fieldname_CriticalText/CriticalHead"
					
				ReDim aList(UBound(vList))
				
				i = 0
				For Each vValue In vList
					sValue = CStr(vValue)				
					If Right(sValue,1) = Chr(9) Then sValue = Left(sValue,Len(sValue)-1)
					aList(i) = sValue
					i = i + 1
					
				Next
				
				For i = 0 To UBound(vList)
				
					If i = 0 Then
						'sCriticalText_1 = "@isini(""" & aList(i) & """" & sLS & snVerwendungsZweck & ")"
						sCriticalText_1 = oSC.FormatString("@isini(""{0}""{1} {2})", aList(i), sLS, snVerwendungsZweck)
						sEqn_3 = oSC.FormatString("@if(@RegExpr(@lower({0}){1}@lower(""{2}"")) == """"; """"; @RegExpr(@lower({0}){1}@lower(""{2}"")) + "" "")", snVerwendungsZweck, sLS, aList(i))
						
					Else
						'sCriticalText_1 = sCriticalText_1 & " .OR. " & "@isini(""" & aList(i) & """" & sLS & snVerwendungsZweck & ")"	
						sCriticalText_1 = sCriticalText_1 & " .OR. " & oSC.FormatString("@isini(""{0}""{1}{2})", aList(i), sLS, snVerwendungsZweck)
						sEqn_3 = sEqn_3 & " + " & oSC.FormatString("@if(@RegExpr(@lower({0}){1}@lower(""{2}"")) == """"; """"; @RegExpr(@lower({0}){1}@lower(""{2}"")) + "" "")", snVerwendungsZweck, sLS, aList(i))
						
					End If
							
				Next
				Call Scrambling(ErrHandler_CheckPointID & ", eqn3: " & sEqn_3,false,true) 
				
				
ErrHandler_CheckPointID = "equations for New Field ID_Fieldname_CriticalText/CriticalHead"

				'sEqn_1 = "@if(" & sCriticalText_1 & sLS & """X""" & sLS & """"")"
				sEqn_1 = oSc.FormatString("@if({0}{1}""X""{1}"""")", sCriticalText_1, sLS)
				'sEqn_3 = oSC.FormatString("@Proper(@AllTrim({0}))", sEqn_3)
				sEqn_3 = oSC.FormatString("@AllTrim({0})", sEqn_3)
				Call Scrambling(ErrHandler_CheckPointID & ", eqn1: " & sEqn_1,false,true)
				Call Scrambling(ErrHandler_CheckPointID & ", eqn3: " & sEqn_3,false,true) 
				
				sFielddescription_CriticalText = sID_Fielddescription_CriticalText_A
				sFielddescription_Existing_CriticalText = sID_Fielddescription_Existing_CriticalText_A
				Call Scrambling(sFielddescription_CriticalText,false,true)
				Call Scrambling(sFielddescription_Existing_CriticalText,false,true)
							
									
			End If		' for "If chkWordSearch"			
						

						'check length of the equation
			
			If (Len(sEqn_3) > MAX_EQUATION_LENGTH) Then
			
				SmartContext.Log.LogMessageWithID "LengthOfCriticalText", Len(sEqn_3)
				
				err.Raise ERR_MACRO_DEV, "SK-FuR-0033", oStrings("ErrDescrCriticalTexTooLongForFieldEquation")
			End if
			
			'check length of the equation
			If (Len(sEqn_1) > MAX_EQUATION_LENGTH) Then
			
				SmartContext.Log.LogMessageWithID "LengthOfCriticalText", Len(sEqn_1)
				
				err.Raise ERR_MACRO_DEV, "SK-FuR-0033", oStrings("ErrDescrCriticalTexTooLongForFieldEquation")
				
			Else
			
ErrHandler_CheckPointID = "New Field ID_Fieldname_CriticalText"
				Call Scrambling(ErrHandler_CheckPointID,false,true)
				'sdbname = s_Temp0
				'Set oDB = Client.OpenDatabase(sdbname)
				'bTemp0_IsOpen = True
				'Set oFM = oMC.FieldManagement(oDB)	
				Call CheckOpen_Temp0	
				oFM.AppendField sID_Fieldname_CriticalText, sFielddescription_CriticalText, WI_CHAR_FIELD, 1, 0, sEqn_1	'0
				oFM.AppendField sID_Fieldname_Existing_CriticalText, sFielddescription_Existing_CriticalText, WI_CHAR_FIELD, 245, 0, sEqn_3	 '0
				
				'oFM.PerformTask
				'Set oFM = Nothing
					
			End If		' for "If Len(sEqn_1) > MAX_EQUATION_LENGTH"
			
'		End If		' for "If Not IsEmpty(vList)"
		
	End If		' for "If chkCriticalText"
	
		
	If chkShortText Then
			
ErrHandler_CheckPointID = "11.4.2.1	New Field ID_Fieldname_ShortText"
		Call Scrambling(ErrHandler_CheckPointID,false,true)
			
		'sEqn_2 = "@If(@Len(" & snVerwendungsZweck & ") <= " & sShortText & sLS & """X""" & sLS & """"")"
		sEqn_2 = oSC.FormatString("@If(@Len({0}) <= {1}{2}""X""{2}"""")", snVerwendungsZweck, sShortText, sLS)

		
		Call CheckOpen_Temp0
		oFM.AppendField sID_Fieldname_ShortText, sID_Fielddescription_ShortText, WI_CHAR_FIELD, 1, 0, sEqn_2	'0 
		
		'oFM.PerformTask
		'Set oFM = Nothing
					
	End If		' for "If chkShortText"
		


ErrHandler_CheckPointID = "11.4.5 Extraction ID_Result_1"
	Call Scrambling(ErrHandler_CheckPointID,false,true)
	If bTemp0_IsOpen Then
		oFM.PerformTask
		Set oFM = Nothing
	Else
		Set oDB = Client.OpenDatabase(s_Temp0)
		bTemp0_IsOpen = True
	End If
			
	'sdbname = s_Temp0
	sID_Result_1 = oSC.UniqueFileName(sID_Result_1, FINAL_RESULT)
	'Set oDB = Client.OpenDatabase(s_Temp0)	-> already open at line 912	
	Set oTask = oDB.Extraction
	oTask.IncludeAllFields
	
	'If chkCriticalText Then	oTask.AddFieldToInc sID_Fieldname_CriticalText
	'End If
	'If chkCriticalText Then	oTask.AddFieldToInc sID_Fieldname_Existing_CriticalText
	'End If
	'If chkShortText Then oTask.AddFieldToInc sID_Fieldname_ShortText
	'End IF
	
	sEqn_7 = ""
	If chkCriticalText Then
		sEqn_7 = sID_Fieldname_CriticalText & " == " & """X"""

	End If
	
	If chkShortText Then
		If Len(seqn_7) > 0 Then 
			sEqn_7 = sEqn_7 & " .OR. " & sID_Fieldname_ShortText  & " == " & """X"""
		Else
			sEqn_7 =  sID_Fieldname_ShortText  & " == " & """X"""
		End If

	End If
	Call Scrambling(ErrHandler_CheckPointID & ", eqn7: " & sEqn_7,false,true)
	'oTask.AddKey snBuchungsDatum, "A"
	'oTask.AddKey snRelevant, "A"
	'OTask.AddKey snKontoNummer, "A"
	'OTask.AddKey snVerwendungsZweck, "A"
	'OTask.AddKey snBetrag, "A"
	
	oTask.CreateVirtualDatabase = False
	oTask.AddExtraction sID_Result_1, "", sEqn_7
	oTask.PerformTask 1, oDB.Count
	Set oTask = Nothing
	Call Scrambling(ErrHandler_CheckPointID & ", Created: " & sID_Result_1,false,true)
	Call CloseDB()
	
	Call AddFilesName(sID_Result_1)
ErrHandler_CheckPointID = "11.5 Checking If ID_Result_1 is valid"
	bID_Result_1 = true
	If oSC.FileIsValid(sID_Result_1) Then 
		sResultDescription_1 = sID_ResultDescription_1_A
		Call Scrambling(ErrHandler_CheckPointID & ", FileIsValid: " & sID_Result_1,false,true)
	Else
		sResultDescription_1 = sID_ResultDescription_1_C
		Call Scrambling(ErrHandler_CheckPointID & ", FileIsNotValid: " & sID_Result_1,false,true)		
	End If	
			
	
		
Preparation = True	
	
End Function 'Preparation


'------------------------------------------------------------------------------------------------------
Sub CheckOpen_Temp0
'to be called before appendfield
	If bTemp0_IsOpen = False Then
		Set oDB = Client.OpenDatabase(s_Temp0)		
		bTemp0_IsOpen = True
		Set oFM = oMC.FieldManagement(oDB)
	End If
End Sub	'CheckOpen_Temp0		

'------------------------------------------------------------------------------------------------------
Function MacroSettings As Boolean

ErrHandler_FunctionName = "MacroSettings; "

   SmartContext.ScriptProgress 0, 5
   
   'settings

   oProtectIP.ProjectOverviewOff

   strResultName = oStrings("ResultName")
   strResultShortName = oStrings("ResultShortName")
   strNumberOfRecords = oStrings("NumberOfRecords")
ErrHandler_CheckPointID = "MS_1"

	snKontoNummer = ""
	'snRelevant = ""
	snBetrag = ""
	snBuchungsDatum = ""  
  	snVerwendungsZweck = ""
	snWertstellung	= ""
	snKontobezeichnung	= ""
	snPN	= ""
	snRahmennr2stellig	= ""
	snPositionShort	= ""
	snNichtaufgriffsgrenze = ""
	snManuelleBuchungen = ""
	snBuchungSVZ = ""
	snAuftragKonto = ""
	
   iNumberOfFiles = 0
   iNumberOfTempFiles = -1
   ReDim aFiles(2)		
   ReDim aTempFiles(1) 

ErrHandler_CheckPointID = "MS_2"
   'get DBextension
   sDBExtension = oSC.DatabaseExtension

ErrHandler_CheckPointID = "MS_2a"    
    'get DateMask
    sDateMask = oSC.DateMask
    SmartContext.Log.LogMessage oStrings("DateMask") & sDateMask
    Call Scrambling(" === sDateMask: " & sDateMask, false, true)   

ErrHandler_CheckPointID = "MS_3"
   'get ListSeparator
   sLS = oSC.ListSeparator
   SmartContext.Log.LogMessage oStrings("ListSeparator") & sLS
   Call Scrambling("sDBExtension: " & sDBExtension & "; ListSeparator: " & sLS, false, true)
   
   SmartContext.Log.LogMessage oStrings("MAX_EQUATION_LENGTH"), MAX_EQUATION_LENGTH
   Call Scrambling("MAX_EQUATION_LENGTH: " & MAX_EQUATION_LENGTH, false, true)
	


ErrHandler_CheckPointID = "MS_5"  

	
	MacroSettings = True
   
End Function      'MacroSettings


'------------------------------------------------------------------------------------------------------
Function MacroValidation As Boolean
ErrHandler_FunctionName = "MacroValidation; "

   SmartContext.ScriptProgress 5, 10
   
   Set oTM = oMC.TagManagement

ErrHandler_CheckPointID = "MV_1"
   'Checking for the existence of a correct source file
   sSourceName = SmartContext.PrimaryInputFile
   SmartContext.Log.LogMessage oStrings("BaseTable") & sSourceName

   If sSourceName = "" Then
      err.Raise ERR_MACRO_DEV, "SK-FuR-0033", oStrings("ErrDescrNoSourceTables")
   End If

ErrHandler_CheckPointID = "MV_2"
   'Checking for validity of source table
   If Not oSC.FileIsValid(sSourceName) Then
      s = oStrings("BaseTable") & sSourceName & "; " & oStrings("ErrDescrEmptySourceTable")
      err.Raise ERR_MACRO_DEV, sTestName, s
   End If

ErrHandler_CheckPointID = "2.2.1"	
	nHistoryCount = oProtectIP.HistoryCount(sSourceName)	' number of entries in Primarys history when macro starts
	Call Scrambling("number of entries in Primarys history when macro starts: " & nHistoryCount,false,true)
   
ErrHandler_CheckPointID = "MV_3"
   sdbname = sSourceName
   Set oDB = Client.OpenDatabase(sSourceName)
ErrHandler_CheckPointID = "MV_4"

	If oSC.TagExists(oDB,"acc!KONTO_NR") Then
		snKontoNummer = oTM.GetFieldForTag(oDB, "acc!KONTO_NR")
	Else
		SmartContext.Log.LogMessage "Tagging failed. Macro stopped."
		Exit Sub
	End If
	
	If oSC.TagExists(oDB,"acc!KONTO_BEZ") Then
		snKontobezeichnung = oTM.GetFieldForTag(oDB, "acc!KONTO_BEZ")
	Else
		SmartContext.Log.LogMessage "Tagging failed. Macro stopped."
		Exit Sub
	End If
	
	If oSC.TagExists(oDB,"acc!BUDAT") Then
		snBuchungsDatum = oTM.GetFieldForTag(oDB, "acc!BUDAT")
	Else
		SmartContext.Log.LogMessage "Tagging failed. Macro stopped."
		Exit Sub
	End If
	
	If oSC.TagExists(oDB,"acc!BETRAG") Then
		snBetrag = oTM.GetFieldForTag(oDB, "acc!BETRAG")
	Else
		SmartContext.Log.LogMessage "Tagging failed. Macro stopped."
		Exit Sub
	End If
	
	If oSC.TagExists(oDB,"acc!VERZW") Then
		snVerwendungsZweck = oTM.GetFieldForTag(oDB, "acc!VERZW")
	Else
		SmartContext.Log.LogMessage "Tagging failed. Macro stopped."
		Exit Sub
	End If
	
	If oSC.TagExists(oDB,"acc!WERTDAT") Then
		snWertstellung = oTM.GetFieldForTag(oDB, "acc!WERTDAT")
	Else
		SmartContext.Log.LogMessage "Tagging failed. Macro stopped."
		Exit Sub
	End If
	
	If oSC.TagExists(oDB,"acc!PN") Then
		snPN = oTM.GetFieldForTag(oDB, "acc!PN")
	Else
		SmartContext.Log.LogMessage "Tagging failed. Macro stopped."
		Exit Sub
	End If
	
	If oSC.TagExists(oDB,"acc!RAHMNR_2") Then
		snRahmennr2stellig = oTM.GetFieldForTag(oDB, "acc!RAHMNR_2")
	Else
		SmartContext.Log.LogMessage "Tagging failed. Macro stopped."
		Exit Sub
	End If
	
	If oSC.TagExists(oDB,"acc!POSSHORT") Then
		snPositionShort = oTM.GetFieldForTag(oDB, "acc!POSSHORT")
	Else
		SmartContext.Log.LogMessage "Tagging failed. Macro stopped."
		Exit Sub
	End If
	
	If oSC.TagExists(oDB,"acc!NAGGRENZE") Then
		snNichtaufgriffsgrenze = oTM.GetFieldForTag(oDB, "acc!NAGGRENZE")
	Else
		SmartContext.Log.LogMessage "Tagging failed. Macro stopped."
		Exit Sub
	End If
	
	If oSC.TagExists(oDB,"acc!MANBUCH") Then
		snManuelleBuchungen = oTM.GetFieldForTag(oDB, "acc!MANBUCH")
	Else
		SmartContext.Log.LogMessage "Tagging failed. Macro stopped."
		Exit Sub
	End If
	
	If oSC.TagExists(oDB,"acc!BUCHUNGSKATEGORIE_BV") Then
		snBuchungSVZ = oTM.GetFieldForTag(oDB, "acc!BUCHUNGSKATEGORIE_BV")
	Else
		SmartContext.Log.LogMessage "Tagging failed. Macro stopped."
		Exit Sub
	End If
	
	If oSC.TagExists(oDB,"acc!AUFTRAGG_KTO") Then
		snAuftragKonto = oTM.GetFieldForTag(oDB, "acc!AUFTRAGG_KTO")
	Else
		SmartContext.Log.LogMessage "Tagging failed. Macro stopped."
		Exit Sub
	End If
 
   ErrHandler_CheckPointID = "MV_5"

   ErrHandler_CheckPointID = "MV_6"
   
   ErrHandler_CheckPointID = "MV_7"
   'set initial number of indices from the Base table
   iNrOfIndeces = NumberOfIndeces(sSourceName)
   Call Scrambling("MacroValidation; Initial number of indices on source table: " & iNrOfIndeces, false, true)
	
   ErrHandler_CheckPointID = "MV_8"	
	
	sID_Result_1 							= oStrings("ID_Result_1")
    sID_ResultDescription_1_A				= oStrings("ID_ResultDescription_1_A")
    sID_ResultDescription_1_B				= oStrings("ID_ResultDescription_1_B")
    sID_ResultDescription_1_C				= oStrings("ID_ResultDescription_1_C")
    sID_ResultExcelExport_1					= oStrings("ID_ResultExcelExport_1")
    sID_Fieldname_CriticalText				= oStrings("ID_Fieldname_CriticalText")
    sID_Fieldname_Existing_CriticalText		= oStrings("ID_Fieldname_Existing_CriticalText")
    sID_Fielddescription_CriticalText_A		= oSC.FormatString(oStrings("ID_Fielddescription_CriticalText_A"), snVerwendungsZweck)
    sID_Fielddescription_CriticalText_B		= oSC.FormatString(oStrings("ID_Fielddescription_CriticalText_B"), snVerwendungsZweck)
    sID_Fielddescription_Existing_CriticalText_A		= oSC.FormatString(oStrings("ID_Fielddescription_Existing_CriticalText_A"), snVerwendungsZweck)
	sID_Fielddescription_Existing_CriticalText_B		= oSC.FormatString(oStrings("ID_Fielddescription_Existing_CriticalText_B"), snVerwendungsZweck)

    '-------------------------------moved from macrosettings
     
    
    Set oParameters = SmartContext.Parameters

	sdatefrom = ""
	If Len(oParameters.Item("smartTextBox1").Value) > 0 Then	sdatefrom = Format(DateValue(oParameters.Item("smartTextBox1").Value), "yyyymmdd")
	sdateto = ""
	If Len(oParameters.Item("smartTextBox2").Value) > 0 Then	sdateto = Format(DateValue(oParameters.Item("smartTextBox2").Value), "yyyymmdd")
	
	sMinVal = oParameters.Item("SmartTextBox3").Value 'only textbox which is not optional, maybe something else must be added because of this
	
	sShortText = oParameters.Item("SmartTextBox4").Value
	
	chkAccountEnh = False
    chkShortText = False
	If oParameters.Contains("smartCheckBox8") Then
		chkShortText = oParameters.Item("smartCheckBox8").Checked
	End If	
    chkShortHead = False
    chkCriticalText = False
	chkWordSearch = False
'mutat mai jos	bSmartSingleList1 = False
	If oParameters.Contains("smartCheckBox10") Then
		chkCriticalText = oParameters.Item("smartCheckBox10").Checked	
		
		If chkCriticalText And oParameters.Contains("smartCheckBox7") Then 		'smarcheckbox7 setting is relevant only when chkCriticalText is true
			chkWordSearch = oParameters.Item("smartCheckBox7").Checked
		End If	
		
			
	End If			

	bSmartSingleList1 = False	
'MOVED here from Preparation_BEGIN
'Set oParameters = SmartContext.Parameters
If oParameters.Contains("SmartSingleList1") Then 'okk
	bSmartSingleList1 = True

ErrHandler_CheckPointID = "SmartSingleList"
	Set oValues = oParameters.Item("smartSingleList1")
	vList = oValues.getList
	Set oValues =  Nothing
End If

'	bSmartSingleList2 = False	
'	If oParameters.Contains("SmartSingleList2") Then 'okk
'	bSmartSingleList2 = True
'
'ErrHandler_CheckPointID = "SmartSingleList2"
'	Set oValues = oParameters.Item("smartSingleList2")
'	vList2 = oValues.getList
'	Set oValues =  Nothing
'End If

'Set oParameters = Nothing

'MOVED here from Preparation_END	
					
	Set oParameters = Nothing		'DECOMENTAT
	
	sID_Fieldname_ShortText					= oSC.FormatString(oStrings("ID_Fieldname_ShortText"), sShortText)
    sID_Fielddescription_ShortText			= oSC.FormatString(oStrings("ID_Fielddescription_ShortText"), snVerwendungsZweck, sShortText)
	
'----------------------------------------------------------------------------

   
   MacroValidation = True

End Function      'MacroValidation


'------------------------------------------------------------------------------------------------------
Function AddFilesName (FileName As String)
ErrHandler_CheckPointID = "AFN_0"

   iNumberOfFiles = iNumberOfFiles + 1
   aFiles(iNumberOfFiles) = FileName
   Call Scrambling("aFiles(" & iNumberOfFiles & "): " & FileName,false,true)

End Function


'------------------------------------------------------------------------------------------------------
Function AddTempFilesName(FileName As String)
ErrHandler_CheckPointID = "ATFN_0"

   iNumberOfTempFiles = iNumberOfTempFiles + 1
   aTempFiles(iNumberOfTempFiles) = FileName
   Call Scrambling("aTempFiles(" & iNumberOfTempFiles & "): " & FileName,false,true)

End Function


'------------------------------------------------------------------------------------------------------
Function AddResults() As Boolean 'error result handler
On Error GoTo ERrHnd_Ars

ErrHandler_CheckPointID = "ARs_0"

   SmartContext.ScriptProgress 80, 92
   
	AddResults = False 'error result handler
	bExistFinalResults = False 'error result handler
	bErrInResult = False 'error result handler
	
   'Create result for PrimaryInputFile
   Set oResultFile = oSC.CreateResultObject(sSourceName,1,true,1)
   SmartContext.TestResultFiles.Add oResultFile

   s = "result(sSourceName): id=" & oResultFile.Id & "; parentid=" & oResultFile.ParentID & "Result Name: " & _
       oResultFile.Name & "; " & "Number Of Records: " & oResultFile.RecordCount
   Call Scrambling(s, false, true)

   Set oResultFile = Nothing
	'Create result for created tables
	'ID_Result_1
ErrHandler_CheckPointID = "ARs_1"
	If bID_Result_1 Then
		Call AddResult(sID_Result_1, 4, True, 3, sID_ResultExcelExport_1, sResultDescription_1)
		If bExistsResult Then Call Scrambling("added sResult_1", false, true)'error result handler
	End If		
   'Check for existing at least 1 result other than the source tables result
   If bErrInResult Then 
      err.Raise ERR_MACRO_DEV, "SK-FuR-0033", oStrings("ErrDescrErrCreatingResult")
	  Exit Function
   ElseIf Not bExistFinalResults Then 
	  err.Raise ERR_MACRO_DEV, "SK-FuR-0033", oStrings("ErrDescrNoResultsFailsAT")
	  Exit Function
   Else
      AddResults = True   
   End If	  

   
   Exit Function

ErrHnd_ARs:
   sErrNumber = err.Number
   sErrDescription = err.Description
   ErrHandler_ErrDescription = oStrings("ErrorNumber") & serrNumber & "; " & oStrings("ErrorDescription") & serrDescription
   SmartContext.Log.LogError ErrHandler_ErrDescription
   s = "AddResults; " & ErrHandler_CheckPointID & "; " & serrNumber & "; " & serrDescription
   Call Scrambling(s, false, true)
   'Resume Next 'error result handler

End Function      'AddResults



'------------------------------------------------------------------------------------------------------
Function AddResult(Result As String, ByVal ResType As Integer, ByVal Vis As Boolean, ByVal Seq As Integer, ByVal ShortName As String, ByVal Description As String)
On Error GoTo ErrHnd_AR

ErrHandler_CheckPointID = "AR_1"
	
	bExistsResult = True 'error result handler

   Set oResultFile = oSC.CreateResultObject(Result,ResType,Vis,Seq)
ErrHandler_CheckPointID = "AR_2"
   oResultFile.ExtraValues.Add "ShortName", ShortName
   oResultFile.ExtraValues.Add "Description", Description
   SmartContext.TestResultFiles.Add oResultFile
   	Call SetFlagForTable(Result, TRUE)
	
	bExistFinalResults = bExistFinalResults Or bExistsResult 'error result handler

   s = "result: id=" & oResultFile.Id & "; parentid=" & oResultFile.ParentID & "; Result Name: " & oResultFile.Name
   Call Scrambling(s, false, true)
   s = "result: ShortName=" & oResultFile.ExtraValues.Item("ShortName")
   Call Scrambling(s, false, false)

   SmartContext.Log.LogMessage StrResultName & oResultFile.Name & "; " & StrNumberOfRecords & oResultFile.RecordCount
   SmartContext.Log.LogMessage StrResultShortName & oResultFile.ExtraValues.Item("ShortName")
   Set oResultFile = Nothing

   Exit Function

ErrHnd_AR:

	bExistsResult = False 'error result handler
   bErrInResult = True 'error result handler

   sErrNumber = err.Number
   sErrDescription = err.Description
   ErrHandler_ErrDescription = oStrings("ErrorNumber") & serrNumber & "; " & oStrings("ErrorDescription") & serrDescription
   SmartContext.Log.LogError ErrHandler_ErrDescription
   s = "AddResult; " & ErrHandler_CheckPointID & "; " & serrNumber & "; " & serrDescription
   Call Scrambling(s, false, true)
   'Resume Next 'error result handler

End Function      'AddResult

'------------------------------------------------------------------------------------------------------
Function DeleteTempFiles(ByVal NumOfTempFiles As Integer)
On Error GoTo ErrHnd_DF

ErrHandler_FunctionName = "DeleteTempFiles; "
ErrHandler_CheckPointID = "DTF_00"

   For i = 0 To NumOfTempFiles
ErrHandler_CheckPointID = "DTF_" & CStr(i)
		 sName = aTempFiles(i)
         oSC.GetRidOf(sName)
         Call Scrambling(ErrHandler_FunctionName & "temp file deleted(" & CStr(i) & "): " & sName,false,true)
   Next
   Exit Function

ErrHnd_DF:
   sErrNumber = err.Number
   sErrDescription = err.Description
   s = "DeleteTempFiles; file not deleted: " & sName & "; " & ErrHandler_CheckPointID & "; " & serrNumber & "; " & serrDescription
   Call Scrambling(s, false, true)
   Resume Next

End Function      'DeleteTempFiles

'------------------------------------------------------------------------------------------------------
Function MacroDeleteHistory(ByVal NumberOfFiles As Integer)
On Error GoTo ErrHnd_MDH
subFunctionName = "MacroDeleteHistory"
subCheckPointID = "MDH_00"

   If NumberOfFiles > 0 Then
 
      For i = 1 To NumberOfFiles
           
         sName = aFiles(i)
subCheckPointID = "MDH_" & CStr(i)
			If nHistoryCount = 0 Then
				oProtectIP.RemoveHistory aFiles(i)				' the Export to Excel will not work for Idea 9.2 and earlier because of empty history
			Else
				oProtectIP.RemoveHistoryKeep aFiles(i), nHistoryCount		' initial entries left in history
			End If
         Call Scrambling("MacroDeleteHistory; " & "history deleted(" & CStr(i) & "): " & aFiles(i), false, true)
      Next

   End If

   'delete Base Tables History
   sName = sSourceName
   'oProtectIP.RemoveHistory sSourceName
	oProtectIP.RemoveHistoryKeep sSourceName, nHistoryCount	' entries left in history from macros start
   Call Scrambling("MacroDeleteHistory; " & "base Tables history deleted: " & sSourceName,false,true)

   Exit Function

ErrHnd_MDH:
   sErrNumber = err.Number
   sErrDescription = err.Description
   s = "MacroDeleteHistory: history not deleted for table: " & sName & "; " & subCheckPointID & "; " & serrNumber & "; " & serrDescription 
   Call Scrambling(s, false, true)
   Resume Next 

End Function      'MacroDeleteHistory


'------------------------------------------------------------------------------------------------------
Function Scrambling(Text As String,scrambled As Boolean,logging As Boolean)
On Error GoTo ErrHnd

    Text = "***" & Text
    If DebugMode = 0 Then
      If logging Then
         If scrambled Then
            Text = oSC.Scramble(Text)
         End If
         SmartContext.Log.LogMessage(Text)
      End If
   Else
      SmartContext.Log.LogMessage(Text)
    End If

   Exit Function

ErrHnd:
   sErrNumber = err.Number - 321
   sErrDescription = sErrNumber & err.Description & oStrings("ErrDescrUnknownError_S")
   SmartContext.Log.LogError sErrDescription
   Resume Next
End Function      'Scrambling


'------------------------------------------------------------------------------------------------------
Function MacroRollback(FunctionName As String)
On Error Resume Next

   If bPreparationFlag Then
   
      subFunctionName = "MacroRollback"

	  If ((serrNumber = 9094) Or (serrNumber = 1550)) Then      'errNumber for unable to open database because is locked by..
	     SmartContext.Log.LogErrorWithID "ErrDescrFileLocked" ,sdbname
	  End If

	  If SmartContext.IsCancellationRequested Then
		 'set execution status ("cancel")
		 SmartContext.ExecutionStatus = EXECUTION_CANCELED
	  End If
	   
	  Call MacroClear("MacroRollback")
	  
	End If
   
End Function      'MacroRollback


'------------------------------------------------------------------------------------------------------
Function MacroClear(FunctionName As String) 
On Error Resume Next

ErrHandler_FunctionName = FunctionName    'set for message of CloseDB

   SmartContext.ScriptProgress 92, 97

ErrHandler_CheckPointID = "MC_1"
   'delete indexes

	sIndexes = snBuchungsDatum & ",A," & snKontoNummer & ",A"  


   Call Scrambling("Indices to be deleted on sSourceName(" & sSourceName & ") : " & sIndexes ,false,true)
   sdbname = sSourceName
   'oIndexCleaner.DeleteIndex sSourceName , sIndexes
   Call MacroDeleteIndexes(sSourceName,sIndexes)
   Call Scrambling("Indices deleted!", false,true)
   'delete tables history
   Call MacroDeleteHistory(iNumberOfFiles)

   If SmartContext.ExecutionStatus = EXECUTION_SUCCESS Then
	  Call Scrambling("Number Of Temp Files: " & iNumberOfTempFiles+1,false,true)	
      Call DeleteTempFiles(iNumberOfTempFiles)
		 
      Call Scrambling("Execution status: " & SmartContext.ExecutionStatus & "(SUCCESS)",false,true)
      Call Scrambling(LOG_HEADER & "; END Date And Time: " & Now(),false, true)
      s = strAuditTest & sTestName & "; " & strExecutionStatus & oStrings("Success")
      SmartContext.Log.LogMessage s

   Else
      'Call CloseDB()
      
      'copied from MacroRollback function:
      
      'clear result
      SmartContext.TestResultFiles.clear
      Call Scrambling(FunctionName & " Clear results executed",false,true)
      Call Scrambling(FunctionName & " iNumberOfFiles:" & iNumberOfFiles+1,false,true)

      'delete created files
      If iNumberOfFiles > 0 Then
         'delete from ultimate created file
         i = iNumberOfFiles
         For j = 1 To iNumberOfFiles
            sName = aFiles(i)
            oSC.GetRidOf(sName)
            Call Scrambling(FunctionName & " file deleted(" & CStr(i) & "): " & sName,false,true)
            i = i-1
         Next
      End If   ' for "If iNumberOfFiles > 0 "

      Call Scrambling(FunctionName & " END of ROLLBACK",false,true)

   End If   ' for "if SmartContext.ExecutionStatus = EXECUTION_SUCCESS"

   If SmartContext.ExecutionStatus = EXECUTION_FAIL Then
      Call Scrambling(FunctionName & "Execution status: " & SmartContext.ExecutionStatus & "(FAIL)",false,true)
      Call Scrambling(LOG_HEADER & "; END Date And Time: " & Now(),true, true)
      s = strAuditTest & sTestName & "; " & strExecutionStatus & oStrings("Fail")
      SmartContext.Log.LogMessage s
   End If

   SmartContext.ScriptProgress 97, 100
   
   If SmartContext.ExecutionStatus = EXECUTION_CANCELED Then
      Call Scrambling(FunctionName & "Audit Test Canceled By User, Execution status: " & SmartContext.ExecutionStatus & "(CANCEL)",false,true)
      Call Scrambling(LOG_HEADER & "; END Date And Time: " & Now(),false, true)
      SmartContext.Log.LogMessage strAuditTest & sTestName & "; " & strExecutionStatus & oStrings("Cancel")
      SmartContext.Log.LogError oStrings("ErrDescrAuditTestCanceledByUser")
   End If

   SmartContext.Log.LogMessage oStrings("EndDateAndTime") & Now() & "; " & sExecutedOn

	oProtectIP.ProjectOverviewOn

	If Not bMacroClearObjects Then Call MacroClearObjects()

   MacroClear = true
   subFunctionName = ""

End Function      'MacroClear

'------------------------------------------------------------------------------------------------------
Function MacroClearObjects()
	bMacroClearObjects = True
	'table
	If Not (oTask Is Nothing) 			Then Set oTask = Nothing
	If Not (oTableMgmt Is Nothing) 		Then Set oTableMgmt = Nothing
	If Not (oTable Is Nothing) 			Then Set oTable = Nothing
	If Not (oDB Is Nothing) 			Then Set oDB = Nothing
	'tagging
	If Not (oTag Is Nothing)			Then Set oTag = Nothing
	If Not (oTags Is Nothing)			Then Set oTags = Nothing
	If Not (oTM Is Nothing) 			Then Set oTM = Nothing
	'dialog
	If Not (oParameters Is Nothing) 	Then Set oParameters = Nothing
	'general
	If Not (oSC Is Nothing) 			Then Set oSC = Nothing
	If Not (oMC Is Nothing) 			Then Set oMC = Nothing
	If Not (oProtectIP Is Nothing)		Then Set oProtectIP = Nothing
	If Not (oIndexCleaner Is Nothing)   Then Set oIndexCleaner = Nothing
	If Not (oResultFile Is Nothing)		Then Set oResultFile = Nothing
	If Not (oStrings Is Nothing)		Then Set oStrings = Nothing
	If Not (oMinMax Is Nothing)			Then Set oMinMax = Nothing

End Function
'------------------------------------------------------------------------------------------------------
Function NumberOfIndeces(sFileName As String) As Integer
ErrHandler_CheckPointID = "NI_0"

    Dim oImd As Object
    Dim sNumberOfIndeces As String
    Dim FileName As String
    Dim p As Integer

	FileName = oSC.GetFullFileName(sFileName)
	Set oImd = CreateObject("Idea.IdeaMergedDocument")
   ErrHandler_CheckPointID = "NI_1"
   Call Scrambling(ErrHandler_CheckPointID & "; FileName: " & FileName, false, true)
	oImd.OpenIMD(FileName)
	sNumberOfIndeces = oImd.numberOfIndeces

    For p = 1 To Len(sNumberOfIndeces)
       If IsNumeric(Left(Trim(sNumberOfIndeces),p)) Then
          NumberOfIndeces = Val(Left(Trim(sNumberOfIndeces),p))
       Else
          p = 1 + Len(sNumberOfIndeces)
       End If
    Next
    Call Scrambling("NumberOfIndices: " & NumberOfIndeces, false, true)
    ErrHandler_CheckPointID = "NI_2"
    oImd.CloseIMD
    Set oImd = Nothing
    Call Scrambling("Number of indices on table: " & FileName & "; NumberOfIndeces: " & NumberOfIndeces, false, true)

End Function

'------------------------------------------------------------------------------------------------------
Function MacroDeleteIndexes(dbName As String, Indexes As String)
On Error GoTo ErrHnd_MDI

ErrHandler_CheckPointID = "MDI_00"

Dim Key1 As String
Dim Key2 As String

   'set current number of indices
   iCrtNrOfIndeces =  NumberOfIndeces(dbName)		'sSourceName
ErrHandler_CheckPointID = "MDI_1"
   s = "MacroDeleteIndexes; " & ErrHandler_CheckPointID & "; iNrOfIndeces: " & iNrOfIndeces & "; iCrtNrOfIndeces: " & iCrtNrOfIndeces
   Call Scrambling(s, false, true)

   If (iCrtNrOfIndeces <= iNrOfIndeces) Then
      Exit Function
   End If

   sdbname = dbName
   Set oDB = Client.OpenDatabase(dbName)
   Set oTask = oDB.Index


   Do While Len(Indexes) > 0
ErrHandler_CheckPointID = "MDI_1"
      Key1 = NextElem(Indexes)
      Key2 = NextElem(Indexes)
      Call Scrambling("index to delete (Key1, Key2): " & Key1 & ", " & Key2, false, true)
      oTask.AddKey Key1, Key2
      Key1 = Indexes 'verbose line to skip "Resume next" bug (if this line is missing, "Resume next" goes after "Loop"
   Loop
ErrHandler_CheckPointID = "MDI_3"
   oTask.DeleteIndex
   Set oTask = Nothing

   Call CloseDB()

   Call Scrambling("indices deleted", false, true)

ErrHandler_CheckPointID = "MDI_4"
   'display final number of indices from the Base table
   iCrtNrOfIndeces =  NumberOfIndeces(dbName)		'sSourceName
   Call Scrambling("Number of indices on source table after index delete: " & iCrtNrOfIndeces, false, true)

   Exit Function

ErrHnd_MDI:
   sErrNumber = err.Number
   sErrDescription = err.Description
   s = "MacroDeleteIndexes; " & ErrHandler_CheckPointID & "; " & serrNumber & "; " & serrDescription
   Call Scrambling(s, false, false)
   Resume Next

End Function   'MacroDeleteIndexes

'------------------------------------------------------------------------------------------------------
Function NextElem(sA As String) As String
    Dim posNext As Integer

    posNext = InStr(1, sA, ",")
    If posNext <> 0 Then
        NextElem = Trim(Mid(sA, 1, posNext - 1))
        sA = Trim(Mid(sA, posNext + 1))
        Exit Function
    End If
    NextElem = sA
    sA = ""
End Function  'NextElem

'------------------------------------------------------------------------------------------------------
Function GetRealFieldName(ByVal pos As Integer) As String
ErrHandler_CheckPointID = "GetRealFieldName"
	'pos is the relative position to the end of the table
	Set oTable = oDB.TableDef
	Set oField = oTable.GetFieldAt(oTable.Count - pos)
	GetRealFieldName = oField.Name
	Set oField = Nothing
	Set oTable = Nothing
End Function

'------------------------------------------------------------------------------------------------------
Function GetRealFieldNameAt(ByVal pos As Integer) As String
ErrHandler_CheckPointID = "GetRealFieldName"
	'pos is the relative position to the end of the table
	Set oTable = oDB.TableDef
	Set oField = oTable.GetFieldAt(pos)
	GetRealFieldNameAt = oField.Name
	Set oField = Nothing
	Set oTable = Nothing
End Function

'------------------------------------------------------------------------------------------------------
Function BuildEquation_FromToList(ByVal dbName As String, ByVal IsSourceTable As Boolean, ByVal ReservedLength As Long) As String
ErrHandler_CheckPointID = "BuildEquation_FromToList_0"

	BuildEquation_FromToList = ""
	bToDeleteTempColumns = False		' will be true if result = 0,len(dbname)>0 and IsSourceTable=true
			
	Dim accountNumberName As String
	accountNumberName = snKontoNummer
	
	Dim accountNumberRanges As Object
	Set accountNumberRanges = oParameters.Item("smartFromToList1")

	' Create a new column filter builder
	Dim filterBuilder As Object
	Set filterBuilder = oMC.NewColumnFilterBuilder
	
	' Initialize its properties 
	
	' Note: The database property is optional. 
	' The builder uses this information only in case the 'regular' filter expression exceeds 
	' IDEA's max. equation length to append helper columns on which the filter expression will be constructed.
	' The database can be specified by using its path or the result of Client.OpenDatabase
	filterBuilder.Database = dbName
	filterBuilder.ColumnName = accountNumberName
	filterBuilder.ReservedLength = ReservedLength
	
	' Initialize the Values object
	' Valid types: ContentOfSingleList and ContentOfFromToList
	' Note: The builder assumes that the element type of the list of values matches the type of the specified column.
	filterBuilder.Values = accountNumberRanges
	
	'filterBuilder.IgnoreCase = oParameters.Item("IgnoreCaseOption").Checked
	filterBuilder.IgnoreCase = True
	'filterBuilder.GetMatchingRecords = not oParameters.Item("SelectNonMatchingRowsOption").Checked
	filterBuilder.GetMatchingRecords = True
	
	' Execute the task of creating an equation based on the accountNumberName column and 
	' the list of account number ranges accountNumberRanges
	Dim result As Long
	result = filterBuilder.PerformTask
	
	' Examine the result
	Dim filterExpression As String
	filterExpression = ""
	If result = 1 Then
ErrHandler_CheckPointID = "BuildEquation_FromToList_1"	
		' A filter expression is available in Equation
		filterExpression = filterBuilder.Equation
		SmartContext.Log.LogMessage "Filter = {0}", filterExpression
	
		BuildEquation_FromToList = filterExpression
				
	ElseIf result > 0 Then
ErrHandler_CheckPointID = "BuildEquation_FromToList_2"	
		' The filter expression exceeded the max. allowed length -> result contains the length of the expression
		' Note: In this case the Equation property of the builder is empty!
		Dim ErrorMessageFilterLength As String
		ErrorMessageFilterLength = oStrings("ErrorMessFilterExpressionTooLong")
		SmartContext.Log.LogMessageWithID "LengthOfFilterExpression", result
		err.Raise 16, "SK-FuR-0033", ErrorMessageFilterLength
	
	ElseIf result = 0 Then
ErrHandler_CheckPointID = "BuildEquation_FromToList_3"	
		' PerformTask returns 0 in case the 'regular' expression exceeded IDEA's max. equation length.
		' A filter expression was constructed, however helper columns were added to the source database.
		' The names of these columns are available in the builder's array TempColumnNames.
		' Note: To enable this behavior, the builder must be initialzed with the source database (path or database object)
		' A filter expression is available in Equation
		filterExpression = filterBuilder.Equation
		SmartContext.Log.LogMessage "Filter = {0}", filterExpression
		BuildEquation_FromToList = filterExpression
		If IsSourceTable Then
			bToDeleteTempColumns = true
			vTempColumnNames = filterBuilder.TempColumnNames
		End If	
		' TODO: Create the result database and delete the temporary helper columns from the source						

	End If
		
End Function

'------------------------------------------------------------------------------------------------------
Function BuildEquation_FromToList2(ByVal dbName As String, ByVal IsSourceTable As Boolean, ByVal ReservedLength As Long) As String
ErrHandler_CheckPointID = "BuildEquation_FromToList2_0"

	BuildEquation_FromToList2 = ""
	bToDeleteTempColumns = False		' will be true if result = 0,len(dbname)>0 and IsSourceTable=true
			
	Dim accountNumberName As String
	accountNumberName = snRahmennr2stellig
	
	Dim accountNumberRanges As Object
	Set accountNumberRanges = oParameters.Item("smartFromToList2")

	' Create a new column filter builder
	Dim filterBuilder As Object
	Set filterBuilder = oMC.NewColumnFilterBuilder
	
	' Initialize its properties 
	
	' Note: The database property is optional. 
	' The builder uses this information only in case the 'regular' filter expression exceeds 
	' IDEA's max. equation length to append helper columns on which the filter expression will be constructed.
	' The database can be specified by using its path or the result of Client.OpenDatabase
	filterBuilder.Database = dbName
	filterBuilder.ColumnName = accountNumberName
	filterBuilder.ReservedLength = ReservedLength
	
	' Initialize the Values object
	' Valid types: ContentOfSingleList and ContentOfFromToList
	' Note: The builder assumes that the element type of the list of values matches the type of the specified column.
	filterBuilder.Values = accountNumberRanges
	
	'filterBuilder.IgnoreCase = oParameters.Item("IgnoreCaseOption").Checked
	filterBuilder.IgnoreCase = True
	'filterBuilder.GetMatchingRecords = not oParameters.Item("SelectNonMatchingRowsOption").Checked
	filterBuilder.GetMatchingRecords = True
	
	' Execute the task of creating an equation based on the accountNumberName column and 
	' the list of account number ranges accountNumberRanges
	Dim result As Long
	result = filterBuilder.PerformTask
	
	' Examine the result
	Dim filterExpression As String
	filterExpression = ""
	If result = 1 Then
ErrHandler_CheckPointID = "BuildEquation_FromToList2_1"	
		' A filter expression is available in Equation
		filterExpression = filterBuilder.Equation
		SmartContext.Log.LogMessage "Filter = {0}", filterExpression
	
		BuildEquation_FromToList2 = filterExpression
				
	ElseIf result > 0 Then
ErrHandler_CheckPointID = "BuildEquation_FromToList2_2"	
		' The filter expression exceeded the max. allowed length -> result contains the length of the expression
		' Note: In this case the Equation property of the builder is empty!
		Dim ErrorMessageFilterLength As String
		ErrorMessageFilterLength = oStrings("ErrorMessFilterExpressionTooLong")
		SmartContext.Log.LogMessageWithID "LengthOfFilterExpression", result
		err.Raise 16, "SK-FuR-0033", ErrorMessageFilterLength
	
	ElseIf result = 0 Then
ErrHandler_CheckPointID = "BuildEquation_FromToList2_3"	
		' PerformTask returns 0 in case the 'regular' expression exceeded IDEA's max. equation length.
		' A filter expression was constructed, however helper columns were added to the source database.
		' The names of these columns are available in the builder's array TempColumnNames.
		' Note: To enable this behavior, the builder must be initialzed with the source database (path or database object)
		' A filter expression is available in Equation
		filterExpression = filterBuilder.Equation
		SmartContext.Log.LogMessage "Filter = {0}", filterExpression
		BuildEquation_FromToList2 = filterExpression
		If IsSourceTable Then
			bToDeleteTempColumns = true
			vTempColumnNames = filterBuilder.TempColumnNames
		End If	
		' TODO: Create the result database and delete the temporary helper columns from the source						

	End If
		
End Function

'------------------------------------------------------------------------------------------------------
Sub DeleteTempColumns(ToDeleteTempColumns)
ErrHandler_CheckPointID = "DeleteTempColumns_0"

	Dim l As Integer
	If ToDeleteTempColumns Then
		If Not IsArrayEmpty(vTempColumnNames) Then
ErrHandler_CheckPointID = "DeleteTempColumns_1"		
			If UBound(vTempColumnNames) > LBound(vTempColumnNames) Then		'vTempColumnNames has at least 1 element
ErrHandler_CheckPointID = "DeleteTempColumns_2"			
				'delete from source database the temporary added columns during building the equation
				sdbname = sSourceName 
				Set oDB = Client.OpenDatabase(sdbname) 
				For l = LBound(vTempColumnNames) To UBound(vTempColumnNames)
					s = "Temporary column name to be deleted from the source table: " & vTempColumnNames(l)
					Call Scrambling(s, false, true)
					oSC.DeleteField oDB, vTempColumnNames(l)
					s = "Temporary column name deleted from the source table: " & vTempColumnNames(l)
					Call Scrambling(s, false, true)					
				Next
				Call CloseDB()
			End If
		Else
			SmartContext.Log.LogWarning oStrings("MessTempColumns")
		End If
	End If	
	
End Sub		'DeleteTempColumns

'------------------------------------------------------------------------------------------------------
Function IsArrayEmpty(Arr As Variant) As Boolean
'This function tests whether the array has actually been allocated.
ErrHandler_CheckPointID = "IsArrayEmpty_0"

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

'-------------------------------------------------------------------------------------------------------
Function CloseDB()

	If Not (oDB Is Nothing) Then
      s = ErrHandler_FunctionName & "CloseDB for sdbname: " & sdbname
      Call Scrambling(s, false, true)
      oDB.Close
      Set oDB = Nothing
    End If

End Function      'CloseDB

'-------------------------------------------------------------------------------------------------------
Function SetFlagForTable (byval sTable as string, byval bWorkingDirectoryIncluded as boolean)

	if bWorkingDirectoryIncluded = FALSE then sTable = Client.WorkingDirectory & sTable

	Set oTask = Client.ProjectManagement
	oTask.FlagDatabase sTable
	Set oTask = Nothing
End Function
'-------------------------------------------------------------------------------------------------------
Function CreateEQNFromDialogParameter(ByVal bFunctionStandAlone As Boolean)
	If oParameters.Contains("smartCheckBox1") Then A_Checked = oParameters.Item("smartCheckBox1").Checked
	if oParameters.Contains("smartCheckBox2") then P_Checked = oParameters.Item("smartCheckBox2").Checked
	if oParameters.Contains("smartCheckBox3") then E_Checked = oParameters.Item("smartCheckBox3").Checked
	if oParameters.Contains("smartCheckBox4") then V_Checked = oParameters.Item("smartCheckBox4").Checked
	
	sPositionEqn = ""
	
	if A_Checked then
		sPositionEqn = "@left(POSITION_SHORT; 1) = ""A"" .OR. "
		bFilterForPosition = TRUE
	end if
	if P_Checked then
		sPositionEqn = sPositionEqn & "@left(POSITION_SHORT; 1) = ""P"" .OR. "
		bFilterForPosition = TRUE
	end if
	If E_Checked Then
		sPositionEqn = sPositionEqn & "@left(POSITION_SHORT; 1) = ""E"" .OR. "
		bFilterForPosition = TRUE
	end if
	if V_Checked then
		sPositionEqn = sPositionEqn & "@left(POSITION_SHORT; 1) = ""V"""
		bFilterForPosition = TRUE
	end if
	
	If bFilterForPosition Then
		If Right(sPositionEqn, 6) = " .OR. " Then sPositionEqn = Left(sPositionEqn, Len(sPositionEqn) - 6)		
		if bFunctionStandAlone = FALSE then
			sPositionEqn = " .AND. (" & sPositionEqn
			sPositionEqn = sPositionEqn & ")"
		end if
	end if
End Function


'-------------------------------------------------------------------------------
'-- VBS script file
'-- Created on 04/04/2018
'-- Author: Alejandro Valverde
'-- Comment: Script downsamples chosen channels and export these to csv file for fatigue analysis
'-- Modifications:
'-- 16.03.2018: Alejandro Valverde / Addition of loops for groups and variables.
'-------------------------------------------------------------------------------
' Option Explicit  'Forces the explicit declaration of all the variables in a script.

' filesNamesDataInput = Array("testsInitData\HousingP2.vbs", "testsInitData\oldHousingP3.vbs", "testsInitData\newHousingP3.vbs")
' filesNamesDataInput = Array("testsInitData\oldHousingP3.vbs", "testsInitData\newHousingP3.vbs")
' filesNamesDataInput = Array("testsInitData\steelLinksFatigue.vbs")
' filesNamesDataInput = Array("testsInitData\TRbladeholderFatigue.vbs")
' filterFreqs = Array(0.5, 1.0, 2.0, 3.0)

Include(CurrentScriptPath&"testToImport.vbs")

' ' -------------------------------------------
' ' Re-sampling frequency
' newFreq = 100 'Hz'
' filterFreq = 0.001 'Hz'

' ' Where to save the csv files exported
' ' dirSave="L:\MSH-Project Management Files\Functional Engineering\Test Division\Test_Daten\J17-03-Bench Tests\P3-J17-03-BT0168\01_TDMS_data_Set-complete\02_STEPS\csv_data\" 'Outer Catch data'
' ' dirSave="L:\MSH-Project Management Files\Functional Engineering\Test Division\Test_Daten\J17-03-Bench Tests\P3-J17-03-BT0173\01_TDMS_data_Set-complete\02_STEPS\csv_data\" 'TR spider data'
' ' dirSave="L:\MSH-Project Management Files\Functional Engineering\Test Division\Test_Daten\J17-03-Bench Tests\P3-J17-03-BT0164\01_TDMS_data_Set-complete\02_STEPS\csv_data\" 'Steel pitch links data'
' ' dirSave="L:\MSH-Project Management Files\Functional Engineering\Test Division\Test_Daten\J17-03-Bench Tests\P3-J17-03-BT0169\01_TDMS_data_Set-complete\02_STEPS\csv_data\" 'TR blade holder'
' ' dirSave="L:\MSH-Project Management Files\Functional Engineering\Test Division\Test_Daten\J17-03-Bench Tests\P3-J17-03-BT0174\01_TDMS_data_Set-complete\01_RAW\Fatigue test\STG data\2018-03-22_125217\csv_data\" 'BT 0174'
' ' dirSave="L:\MSH-Project Management Files\Functional Engineering\Test Division\Test_Daten\J17-03-Bench Tests\P3-J17-03-BT0182\01_TDMS_data_Set-complete\01_RAW\Fatigue test\csv_data\" 'BT 0182'
' ' dirSave="D:\Working-Directory\alejandro\workfolder\"
' ' dirSave="L:\MSH-Project Management Files\Functional Engineering\Test Division\Test_Daten\J17-03-Bench Tests\P3-J17-03-BT0115 Booster P3\1200-1031112-AE SN2\Step 3.1\csv_data\" 'MRA Performance old data'
' dirSave="L:\MSH-Project Management Files\Functional Engineering\Test Division\Test_Daten\J17-03-Bench Tests\P3-J17-03-BT0115 Booster P3\1200-1031112-AE SN2\Step 3.1 (New housing)\csv_data\" 'MRA Performance data'

' ' Enter range of groups to be re-sampled
' ' indexArray = Array(9)
' indexArray = Array(1, 2, 3, 4, 5, 6, 7, 8, 9)
' ' indexArray = Array(14, 15)

' ' Enter variables in groups to be be resampled
' ' ------------------------------------------------
' 'Pitch link fatigue test data
' 'variables = Array("Pitch link main [N]_Mean", "Inner pitch link [N]_Mean")
' 'variablesToSave = Array("PitchLinkMain", "InnerPitchLink")

' 'Outer catch data
' 'variables = Array("Tension [N]", "Bending [N]")
' 'variablesToSave = Array("Tension", "Bending")

' 'TR spider data
' 'variables = Array("Force TR Pitch Link SN27 [N]", "Force TR Pitch Link SN28 [N]")
' 'variablesToSave = Array("Force-SN27", "Force-SN28")

' 'TR blade holder
' ' variables = Array("Distance Sensor w\o offset (mm)_Mean", "Centrifugal force w\o offset (N)_Mean", "Bending moment (Loadcell) w\o offset (Nm)_Mean", "My_STG_Blade w\o offset (Nm)_Mean", "My_STG_loadcell (Nm)_Mean", "Mz_STG_Blade w\o offset (Nm)_Mean") 'TR blade holder'
' ' variablesToSave = Array("DistanceSensor", "CF", "BendingMoment", "MyBlade", "MyLoadcell", "MzBlade")

' 'MRA retainer fatigue test - BT 0174'
' ' variables = Array("S01 [mm\m]", "S02 [mm\m]")
' ' variablesToSave = Array("STG1", "STG2")

' 'TRA retainer fatigue test - BT 0182'
' ' variables = Array("S01 [mm\m]")
' ' variablesToSave = Array("STG1")

' ' Endurance Actuator
' variables = Array("Druck HP_1 [bar]", "Druck HP_2 [bar]", "Durchfluss HP_1 [l\min]", "Durchfluss HP_2 [l\min]", "Force Piston Eye HP1 [N]", "Force Piston Eye HP2 [N]", "Input force [N]", "Laser Piston [mm]", "Laser Steuerventilhebel [mm]", "Output force [N]", "Temperatur HP_1 [°C]", "Temperatur HP_2 [°C]")
' variablesToSave = Array("DruckHP1","DruckHP2","DurchflussHP1","DurchflussHP2","ForcePistonEyeHP1","ForcePistonEyeHP2","InputForce","LaserPiston","LaserSteuerventilhebel","OutputForce","TemperaturHP1","TemperaturHP2")

' --------------------------------------------------
' Define constant options
' This options shall be defined in the input file
' --------------------------------------------------
'Digital filtering of the signal
FlagFilteredData = True ' True to proceed with the filtering operation

filterFreq = 0.1 'Cut-off freq. for both the high-pass and low-pass filters, in Hz'

FlagHighPass = False 'Define True for high-pass filter and False for low-pass'
saveFlagFilteredData = True 'True to save the filtered signals as csv files in the folder defined in "csvFolder", possible values: True or False

' The lines below shall not be modified, they exist for developing purposes only
importDataFlag = True

FlagFTTData = False

FlagMaxMinMeanData = False

saveFlagMaxMinMean = False 'possible values: True or False

fileNameWithoutIterator_pre = "resampled"
fileNameWithoutIterator_post = "__"&newFreq&"Hz__step" '+iterator 
fileFormatImport = ".TDM" 

' -----------------------------------------------------------
' -----------------------------------------------------------

For Each fileNameDataInput in filesNamesDataInput

  Include(CurrentScriptPath&fileNameDataInput) 'Old housing P3

  For Each iterator in iterators
    
    ' ------------------- Load Data -----------------------------
    If importDataFlag Then

      ' Delete all the previous groups
      Call Data.Root.Clear()

      Call DataFileLoad(workingFolder&fileNameWithoutIterator_pre&dictVaDiadem(var)&fileNameWithoutIterator_post&iterator&fileFormatImport,"") 'Each new variable is loaded and it is stored alone in a new group'
    End If
    
    ' ------------------- Filtered data --------------------------------------
    If FlagFilteredData Then
      
      id_reFilterGroup = Data.Root.ChannelGroups.Count + 1
      
      If FlagHighPass Then
        Call GroupCreate("HighPass Filtered; "&filterFreq&"Hz",id_reFilterGroup)
      Else
        Call GroupCreate("Low Pass Filtered; "&filterFreq&"Hz",id_reFilterGroup)
      End If
      Call Data.Root.ChannelGroups(id_reFilterGroup).Activate()

      '  add downsampled channels to this group
      For Each originalChannel in Data.Root.ChannelGroups(1).Channels
        variableNameSplit = Split(originalChannel.Name,"__")

        If Ubound(Filter(dictVaDiadem.Keys, variableNameSplit(0))) > -1 Then 'If current variable exists in the choice of variables'
          ' originalChannel = "[" & id &"]/"&var
          newChannel = "/"&variableNameSplit(0)&"__"&newFreq&"Hz__"&iterator

          If FlagHighPass Then
            Call ChnFiltCalc("",originalChannel,newChannel,"IIR","Bessel","High pass",2,filterFreq,0,0,1.2,25,"Hamming",0,0)
          Else
            Call ChnFiltCalc("",originalChannel,newChannel,"IIR","Bessel","Low pass",2,filterFreq,0,0,1.2,25,"Hamming",0,0)
          End If

          ' export operation to csv
          If saveFlagFilteredData Then
            If FlagHighPass Then
              fileName = "hp__"&dictVaDiadem(variableNameSplit(0))&"__"&newFreq&"Hz__"&filterFreq&"Hz__"&iterator&".csv"
            Else
              fileName = "lp__"&dictVaDiadem(variableNameSplit(0))&"__"&newFreq&"Hz__"&filterFreq&"Hz__"&iterator&".csv"
            End If
            Call DataFileSaveSel(csvFolder & fileName,"CSV",newChannel)
          End If

        End If

      Next
      
      'When the inner loop has finished
      'Delete both folders for the group, the one that contains resampled data and the one with the original data
      ' Only when new data has been loaded and not when data has been already there
      If importDataFlag Then
        Call Data.Root.ChannelGroups.Remove(1)
        If FlagFilteredData Then
          Call Data.Root.ChannelGroups.Remove(1)
        End If
      End If


    End If

    ' ------------------------ Fast Fourier Transform -------------------------

    ' Call WfChnToChn("[9]/Druck HP_2 [bar]",1,"WfXRelative") Creates numeric variable in the same group as the original variable

    If FlagFTTData Then
      
      id_FTTGroup = Data.Root.ChannelGroups.Count + 1
      
      Call GroupCreate("Low Pass Filtered; "&filterFreq&"Hz",id_FTTGroup)
      Call Data.Root.ChannelGroups(id_FTTGroup).Activate()

      For Each id in indexArray

        '  add downsampled channels to this group
        counter_b = 0
        For Each var in variables
          originalChannel = "[" & id &"]/"&var
          newChannel = "/"&var&"_FTT_"&id

          ' Call ChnFiltCalc("",originalChannel,newChannel,"IIR","Bessel","Low pass",2,filterFreq,0,0,1.2,25,"Hamming",0,0)

          ' ' export operation to csv
          ' If saveFlagFilteredData Then
          '   If FlagHighPass Then
          '     fileName = "hp_"&variablesToSave(counter_b)&"_"&newFreq&"Hz_"&id&".csv"
          '   Else
          '     fileName = "lp_"&variablesToSave(counter_b)&"_"&newFreq&"Hz_"&id&".csv"
          '   End If
          '   Call DataFileSaveSel(dirSave & fileName,"CSV",newChannel)
          ' End If

          counter_b = counter_b + 1

        Next
       
      Next

    End If

    ' ------------------- obtainMaxMinsAndMeans signals ----------------------, needs to be updated
    If FlagMaxMinMeanData Then
      Call Data.Root.ChannelGroups(id_reSampleGroup).Activate() 'Go to re-sampleed group'

      counter_b = 0
      idMaxGroup = id_reSampleGroup
      idMinGroup = id_reSampleGroup + 1
      idMeanGroup = id_reSampleGroup + 2
      For Each var in variables
        
        idMaxGroup = idMaxGroup + 1
        idMinGroup = idMinGroup + 1
        idMeanGroup = idMeanGroup + 1

        Call GroupCreate("Maxs,"&var&"; "&newFreq&"Hz",idMaxGroup)
        Call GroupCreate("Mins,"&var&"; "&newFreq&"Hz",idMinGroup)
        Call GroupCreate("Means,"&var&"; "&newFreq&"Hz",idMeanGroup)
        For Each id in indexArray
          ' Channel:
          originalChannel = "/"&var&"_"&newFreq&"Hz_"&id

          maxChannel = "[" & idMaxGroup &"]/"&var&"_"&newFreq&"Hz_"&id&"_max"
          x_maxChannel = "[" & idMaxGroup &"]/"&"xVal_"&var&"_"&newFreq&"Hz_"&id&"_max"

          minChannel = "[" & idMinGroup &"]/"&var&"_"&newFreq&"Hz_"&id&"_min"
          x_minChannel = "[" & idMinGroup &"]/"&"xVal_"&var&"_"&newFreq&"Hz_"&id&"_min"

          meanChannel = "[" & idMeanGroup &"]/"&var&"_"&newFreq&"Hz_"&id&"_mean"
          x_meanChannel = "[" & idMeanGroup &"]/"&"xVal_"&var&"_"&newFreq&"Hz_"&id&"_mean"

          Call ChnPeakFind("",originalChannel,x_maxChannel,maxChannel,PeakNoMax,"Max.Peaks","Time")
          Call ChnPeakFind("",originalChannel,x_minChannel,minChannel,PeakNoMax,"Min.Peaks","Time")
          ' Set ChnResult = ChnAverage("'[12]/Pitch link main [N]_Mean_100Hz_1_max', '[16]/Pitch link main [N]_Mean_100Hz_1_min'","/Mean")
          ' Call Calculate("ch(""["&idMeanGroup&"]/"&var&"_"&newFreq&"Hz_"&id&"_mean"&""")=(ch(""["&idMaxGroup&"]/"&var&"_"&newFreq&"Hz_"&id&"_max"&""")+ch(""["&idMinGroup&"]/"&var&"_"&newFreq&"Hz_"&id&"_min"&"""))/2")
          Call ChnAverage("'"&maxChannel&"', '"&minChannel&"'",meanChannel)
          Call ChnAverage("'"&x_maxChannel&"', '"&x_minChannel&"'",x_meanChannel)

          ' Save Data
          If saveFlagMaxMinMean Then
            channelsToSave = Array(maxChannel, minChannel, meanChannel)
            MagnitudesNamesToSave = Array("max", "min", "mean")
            counter_a = 0
            For Each cha in channelsToSave
              fileName = MagnitudesNamesToSave(counter_a)&"_"&variablesToSave(counter_b)&"_"&newFreq&"Hz_"&id&".csv"
              Call DataFileSaveSel(dirSave & fileName,"CSV",cha)
              counter_a = counter_a + 1
            Next
          End If

        Next
        counter_b = counter_b + 1
      Next

    End If

  Next

Next

call MsgBox ("Execution finished")

' SubFunctions

Sub Include(sInstFile)
  Dim f, s, oFSO
  Set oFSO = CreateObject("Scripting.FileSystemObject")
  On Error Resume Next
  If oFSO.FileExists(sInstFile) Then
    Set f = oFSO.OpenTextFile(sInstFile)
    s = f.ReadAll
    f.Close
    ExecuteGlobal s
  End If
  On Error Goto 0
  Set f = Nothing
  Set oFSO = Nothing
End Sub
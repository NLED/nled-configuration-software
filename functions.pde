
//===================================================================================================  

void SetConfirmBox(int passedVal)
{
  ConfirmBoxIDNum = passedVal;
}

//============================================================================================

void ShowNotification(int passedVal)
{
  println("ShowNotification() with "+passedVal);

  switch(passedVal)
  {
  case 0: //null

    break;
  case 1:
    DisplayMessageStr = "Connection and Definition Loading Successful.";
    break;
  case 2:
    DisplayMessageStr = "Available Serial Ports Have Updated.";
    break;    
  case 3:
    DisplayMessageStr = "Port Opened Successfully. Attempting Connection, please wait.";
    break; 
  case 4:
    DisplayMessageStr = "Configurations uploaded, waiting for acknowledge.";
    break;    
  case 5:
    DisplayMessageStr = "Configurations Successfully Uploaded";
    break;    
  case 6:
    DisplayMessageStr = "Command timed out. Device did not respond. Disconnecting from port.";
    break; 
  case 7:
    DisplayMessageStr = "This device does not respond, and may not actually be connected. See activity LED and datasheet for details.";
    break; 
   case 16:
    DisplayMessageStr = "Could not load device file, firmware may be outdated or not compatible. See www.NLEDshop.com/deviceupdates";
    break;   
  case 22:
    DisplayMessageStr = "Port Can Not Be Opened.";
    break;
    
  }//end switch
}

//============================================================================================

void TransmissionTimerThread()
{
  int myStart = millis();

  while ((millis() - myStart) < CMDTimeOutVal)
  {
    delay(1);  //Required or would only work a few times, then stops working
    if (SentCmdRequest == false && RecievedOpenAck == false) { 
      return;
    } //force out by mouse click after min time
  }

  CloseCommunicationPort();

  ShowNotification(6); //display notification

  WaitForAckFlag = false;
  UploadInProgress = false;
  RecievedOpenAck = false;  
  SentCmdRequest = false;  

  println("Command Timed Out "+(millis() - myStart));
  redraw();
} //end NotificationTimerThread()

void EnableTransmissionTimeOut()
{
  println("EnableTransmissionTimeOut()");
  redraw();
  thread("TransmissionTimerThread");
} //end func

//================================= START CONFIGURATION MODULES GUI ELEMENTS=================================================================

boolean CheckModuleElements()
{
  //==================================================================================================
  if (InputModule[2].Enabled == true && HardwareColSwapDD.over()) return true; 
  //==================================================================================================
  if (InputModule[3].Enabled == true && PixelChipsetDD.over()) { FuncRecommendColorShift(); return true; }
  //==================================================================================================  
  if (InputModule[9].Enabled == true && LEDIndicatorModeADD.over()) return true;
  //==================================================================================================  
  if (InputModule[1].Enabled == true && LEDIndicatorModeBDD.over()) return true;
  //==================================================================================================  
  if (InputModule[10].Enabled == true && DisplayModeDD.over()) return true;  
  //==================================================================================================  
  if (InputModule[7].Enabled == true && MasterModeDD.over()) return true;  
  //==================================================================================================  
  if (InputModule[11].Enabled == true && AutoDetectDD.over()) return true;
  //==================================================================================================  
  if (InputModule[22].Enabled == true && PWMProfileADD.over()) return true;
  //==================================================================================================  
  if (InputModule[23].Enabled == true && IRRemoteModeDD.over()) return true;
  //==================================================================================================  
  if (InputModule[8].Enabled == true && BaudRateDD.over()) return true;
  //==================================================================================================  
  if (InputModule[6].Enabled == true && DMXModesDD.over()) return true;
  //==================================================================================================  
  if (InputModule[14].Enabled == true && AccMeterAutoDetectDD.over()) return true;
  //==================================================================================================  
  if (InputModule[14].Enabled == true && AccMeterAutoDetectModeDD.over()) return true;
  //==================================================================================================  
  if ( InputModule[15].Enabled == true && AccMeterTapDD.over()) return true;
  //=================================================================================================  
  if (InputModule[16].Enabled == true && PowerDownTimeOutDD.over()) return true;
  //==================================================================================================    
  if (InputModule[20].Enabled == true && PWMFreqADD.over()) return true;
  //==================================================================================================    
  if (InputModule[21].Enabled == true && StandAloneADD.over()) return true;   
  //==================================================================================================    
  if (InputModule[31].Enabled == true && DMXAutoReleaseDD.over()) return true;
  //==================================================================================================    


  if (InputModule[32].Enabled == true && AutoReleaseLegacyDD.over()) return true;
  //==================================================================================================    
  if (InputModule[33].Enabled == true && ReceptionModeLegacyDD.over()) return true;
  //==================================================================================================    



  if (HardwareCheckBox[0].over() && InputModule[8].Enabled == true) return true;//16-bit serial checkbox, not always enabled via Status
  if (HardwareCheckBox[1].over() && InputModule[19].Enabled == true) return true; //Dual Communication Mode

  //==================================================================================================

  if (HardwareButtons[0].over() && InputModule[0].Enabled == true) return true;//Enable/Disable RS485

  if (HardwareButtons[1].over() && InputModule[1].Enabled == true) return true;  //16 or 8 bit DMX Transmission

  if (HardwareButtons[2].over() && InputModule[4].Enabled == true) return true;

  if (HardwareButtons[3].over() && InputModule[12].Enabled == true) return true;  //gamma   

  if (HardwareButtons[4].over() && InputModule[14].Enabled == true) return true;    

  //==================================================================================================  

  if (TextFields[2].over() && InputModule[5].Enabled == true) { 
    TextFields[2].SelectField(); 
    return true;
  }//DMX Address
  if (TextFields[13].over() && InputModule[21].Enabled == true) { 
    TextFields[13].SelectField(); 
    return true;
  }//StandAlone Field A    

  //==================================================================================================  

  //added for configuration software  

  if (HardwareCheckBox[2].over() && InputModule[25].Enabled == true) return true;  //enable activity LED

  if (HardwareCheckBox[3].over() && InputModule[27].Enabled == true) return true;  //Enable Serial Color Swap:

  if (TextFields[4].over() && InputModule[24].Enabled == true) { 
    TextFields[4].SelectField(); 
    return true;
  }//DMX pixel amount

  if (TextFields[3].over() && InputModule[29].Enabled == true) { 
    TextFields[3].SelectField(); 
    return true;
  }//End of Frame Timer
  
    //==================================================================================================  
  if (InputModule[26].Enabled == true && DMXDecoderModeDD.over()) return true;
      //==================================================================================================  
  if (InputModule[28].Enabled == true && HardwareColSwapMicroDD.over()) return true;
        //==================================================================================================  
  if (InputModule[30].Enabled == true && BaudRateMiniV4DD.over()) return true;
  
  //==================================================================================================  

  return false;
} //end func


//===================================================================================================

void FuncRecommendColorShift()
{  
  //String[] PixelChipsetStrings = {"WS2801", "WS2811", "WS2812", "WS2812B", "LPD1886", "LPD6803", "LPD8806", "TM1803", "TM1814", "APA102", "APA104", "SK6812"};

  try
  {
    for (int i=0; i<=PixelChipsetDD.numStrs+1; i++)
    {
      if (PixelChipsetDD.labels[PixelChipsetDD.selStr].indexOf(cPixelChipsetStrings[i])>=0)
      {
        InputModule[3].Label = "Select The Pixel Chipset:\n\n\nRecommended Color: "+cPixelChipsetColorID[i];
        return; //return if something is found
      }
    } //end for()
  }
  catch(Exception e)
  {
    //nothing
  }
  //otherwise uses default
  InputModule[3].Label = "Select The Pixel Chipset:\n\n\nRecommended Color: Unknown / Test";
} //end FuncRecommendColorShift

//===================================================================================================

void LoadDeviceFile()
{
  //Called when device responds to a Connection Request
  //Loads a TXT file with the device specific defines and variables, loads into the device object
 
  if(device.HardwareID == 0)
  {
    //Null
    device.Name = "No Device";
    return;
  }
  
  String BuildString = "devices"+File.separator+""+device.HardwareID+"-nled-contr-revs.txt";   //loads file with current firmware rev info

  String[] lines = loadStrings(BuildString); 
  String[] WorkString = new String[30]; //may need to up this  
  
  BuildString = "";  
  
  for(int i = 0; i != lines.length;i++)
  {
    WorkString = split(lines[i], '\t');
    println(int(WorkString[0])+" : "+int(WorkString[1]));    
    
    if(int(WorkString[0]) == device.FirmwareVersion)//version
    {

      if(int(WorkString[1]) < device.FirmwareRevision && i == 0)//version
      {
        println("Revison higher than local "+device.FirmwareRevision);
        BuildString = "devices"+File.separator+""+device.HardwareID+"-"+int(WorkString[0])+"-"+int(WorkString[1])+"-nled-contr.txt";
        break;
      } //end [1] if
      

      if(int(WorkString[1]) == device.FirmwareRevision)//version
      {
        println("REVISION FOUND with "+i);
        BuildString = "devices"+File.separator+""+device.HardwareID+"-"+int(WorkString[0])+"-"+int(WorkString[1])+"-nled-contr.txt";
        break;
      } //end [1] if

    } //end [0] if
  }//end for()

  //detects if a revID is lower than what is found, use the highest
  if(BuildString.equals(""))
  {
    println("Device File For V. & Rev. Not Found - Using Most Recent Version");  
    lines = loadStrings("devices"+File.separator+""+device.HardwareID+"-nled-contr-revs.txt"); 
    WorkString = split(lines[0], '\t');
    BuildString = "devices"+File.separator+""+device.HardwareID+"-"+int(WorkString[0])+"-"+int(WorkString[1])+"-nled-contr.txt";  
  }

  println("LoadDeviceFile() - "+BuildString);  

  lines = loadStrings(BuildString); 
  int LinePointer = 1;
  
  //WorkString[0] is HardwareID, already checked....
  WorkString = split(lines[LinePointer++], '\t');
  device.Name = WorkString[1]; //String Name
  
  WorkString = split(lines[LinePointer++], '\t');
  device.WebpageURL = WorkString[1];    //String URL


  WorkString = split(lines[LinePointer++], '\t');
  if(device.FirmwareVersion < int(WorkString[1]))
  {
    println("FIRMWARE OUTDATED "+int(WorkString[1])+" vs "+device.FirmwareVersion);
    if(devConnected == true) //if no device is connected don't show the message
    {  
    //  ConfirmBoxIDNum = 8;
    }
  }
  
  WorkString = split(lines[LinePointer++], '\t');
  if(device.FirmwareRevision < int(WorkString[1]))
  {
    println("FIRMWARE REVISION OUTDATED "+int(WorkString[1])+" vs "+device.FirmwareRevision);
    if(devConnected == true) //if no device is connected don't show the message
    {
     // ConfirmBoxIDNum = 8;
    }
  }  

  //device.HardwareVersion = int(WorkString[1]);
  LinePointer++;  //for hardwareversion which is not read

  WorkString = split(lines[LinePointer++], '\t');
  device.Channels = int(WorkString[1]);   
  
  WorkString = split(lines[LinePointer++], '\t');
  device.LockChannelAmt = boolean(WorkString[1]);   
  
  WorkString = split(lines[LinePointer++], '\t');
  device.DataSpace = int(WorkString[1]);   
  
  WorkString = split(lines[LinePointer++], '\t');
  device.IndexBlockSize = int(WorkString[1]);
  try {   
    device.HPVBlockSize = int(WorkString[2]);   
    device.SeqMemoryBlockSize = int(WorkString[3]);   
  }
  catch(Exception e) 
  {
    println("Error loading block sizes, using single value");
    device.CurrentBlockSize  = device.IndexBlockSize;
    device.HPVBlockSize = device.CurrentBlockSize;   
    device.SeqMemoryBlockSize = device.CurrentBlockSize;    
  }
  
  WorkString = split(lines[LinePointer++], '\t');
  device.EraseBlockSize = int(WorkString[1]);  
  
  WorkString = split(lines[LinePointer++], '\t');
  device.HWPVSpace = int(WorkString[1]);    

  WorkString = split(lines[LinePointer++], '\t');
  device.MaxIndexedSequences = int(WorkString[1]);  
  
  WorkString = split(lines[LinePointer++], '\t');
  device.IndexMemoryModel = int(WorkString[1]);      
  
  WorkString = split(lines[LinePointer++], '\t');
  device.FillUpperData = boolean(WorkString[1]); 

  WorkString = split(lines[LinePointer++], '\t');
  device.Bit16Processor = boolean(WorkString[1]);    

  WorkString = split(lines[LinePointer++], '\t');
  device.Bit16Mode = boolean(WorkString[1]);    

  WorkString = split(lines[LinePointer++], '\t');
  device.BasicVersion = int(WorkString[1]);      
  
  WorkString = split(lines[LinePointer++], '\t');
  device.LinkedSupport = boolean(WorkString[1]);   
  
  WorkString = split(lines[LinePointer++], '\t');
  device.GammaCorrection = int(WorkString[1]);  //0=none, 1=8-bit gamma table, 2=16-bit calculation

  WorkString = split(lines[LinePointer++], '\t');
  device.AccelerometerMode = int(WorkString[1]);

  WorkString = split(lines[LinePointer++], '\t');
  device.MaxSpeed = int(WorkString[1]);    

  WorkString = split(lines[LinePointer++], '\t');
  device.MaxFrames = int(WorkString[1]);     //Max Frames for sequences that use DataFrameVar[] on device
  device.MaxFramesGlobal = int(WorkString[2]);  //max frames for POVs currently and anything that uses GlobalFrameVar
  
  WorkString = split(lines[LinePointer++], '\t');
  device.ConfigFlagsStr = WorkString[1];    

  WorkString = split(lines[LinePointer++], '\t');
  device.ConfigBytesStr = WorkString[1];    

  WorkString = split(lines[LinePointer++], '\t');
  device.DMXModeLabels = new String[16];
  device.DMXModeLabels = split(WorkString[1], ',');

  //println("DMXLables: "+device.DMXModeLabels.length+"    "+device.DMXModeLabels[0]+" "+device.DMXModeLabels[1]);

  device.DMXModeAmt = device.DMXModeLabels.length;     
  
  //Init GUI Elements
  DMXModesDD.labels = device.DMXModeLabels;   //drop down
  DMXModesDD.numStrs = device.DMXModeAmt;   //drop down
  
  //Pixel Type Modes if applicable
  WorkString = split(lines[LinePointer++], '\t');
  device.ListedChipsets = int( WorkString[1]);   
  
  if(device.ListedChipsets > 0)
  {  
    String[] tempPixLables = new String[16];

    tempPixLables = new String[device.ListedChipsets]; //use same array as DMX  
    PixelChipsetID = new int[device.ListedChipsets];
    
    //pixel Type Compatibility
    for (int i = LinePointer; i != (LinePointer+device.ListedChipsets);i++)
    {
      WorkString = split(lines[i], '\t');
      tempPixLables[i-LinePointer] = WorkString[1];
      PixelChipsetID[i-LinePointer] = int(WorkString[2]);
    }

    PixelChipsetDD.labels = tempPixLables;
    PixelChipsetDD.numStrs = device.ListedChipsets;  
  }  //end if()

  //added v.2c for linked double duty variables
  device.ArrayCastSize = device.Channels; //cSoftwareMaxFrames
  if(device.MaxFrames > device.Channels) device.ArrayCastSize = device.MaxFrames;
      
  // =================   END DATA LOAD  =========================================================
  
  if(device.BasicVersion > 0)
  {
    switch(device.BasicVersion)
    {
    case 1: //4chanDMX
      device.BasicMaxSequences = 8;
      device.BasicSeqLength = (device.BasicMaxSequences*4)+(device.BasicMaxSequences * (device.Channels*2))+device.DataSpace+(device.DataSpace/device.Channels);
      //Misc+(startvals+framevars)+dataspace
      
      println("============"+device.BasicSeqLength+"================");
      
      AutoDetectDD.labels = cDDAutoDetectModesT2;
      AutoDetectDD.numStrs = cDDAutoDetectModesT2.length;
      break;
    case 2: //octo
    case 3: //four chan
      device.BasicMaxSequences = 32;
      //device.BasicSeqLength = (device.BasicMaxSequences*4)+(device.BasicMaxSequences * (device.Channels*2))+device.DataSpace+(device.DataSpace/device.Channels);
      //Misc+(startvals+framevars)+dataspace
      
      AutoDetectDD.labels = cDDAutoDetectModesT3;
      AutoDetectDD.numStrs = cDDAutoDetectModesT3.length;
      break;    
    }
  }//end if
  
  //set Memory/DataSpace label
  if(device.DataSpace > 1000000) device.MemorySpaceString = nf((((float)device.DataSpace/1048576)),1,2)+"MB";
  else device.MemorySpaceString = nf((((float)device.DataSpace/1024)),1,2)+"KB";  
  
  //Prevents UserChannelAmt from being reset when reconnecting
 // if(holdHardwareID != device.HardwareID)  UserChannelAmt = device.Channels;

  println("Device File Successfully Loaded - Starting Configuration Modules");
  
  //================  init Hardware Usage Modules  ============================================
  
  modulePosX = cModueOffsetX; //constants
  modulePosY = cModueOffsetY;
  
  moduleHoldX = 0;
  moduleHoldY = 0;
  moduleHoldSz = 0;
  
  for (int i = 0; i != InputModule.length;i++) InputModule[i].Enabled = false; //reset all modules to disabled
  
  //  device.ConfigFlagsStr = "fDisModeMSBa,fDisModeLSBa,fLEDModeMSBa,fLEDModeLSBa,fAutoDetectID,fAutoDetect,f8or16Bit,fRS485Enable,fMasterEnable,fMasterFullPkts,fMaster16Bit,fAccMeterAutoShutOff,fAccMeterMovement,fAccMeterDoubleTap,fDualModeCom,none";
  //  device.ConfigBytesStr = "bDMXAdrMSB,bDMXAdrLSB,bDMXModeID,bBaudRateID,bGlobalColorShift,bPixelChipset,bAccmeterTimeoutVal,bAccmeterDoubleTapVal";

  ConfigFlags = 0; //reset flags here.....
  DevStrArray = split(device.ConfigFlagsStr, ',');
  String[] ModuleString = new String[16];  //reset
  String[] ByteStrArray = new String[16];
  ByteStrArray = split(device.ConfigBytesStr, ',');  
  //Now single delimenated string is an array, the pointer is the bit number in ConfigFlags  
  
  
  //First handle prioritized tiles ====================================================================================
  
  //z counts from high to low, and checks for tiles that are not yet placed and are above that number
  for(int z = 260; z > 0; z-=10)
  {  
    for(int y = 0; y != InputModule.length;y++)
    {  
      if(InputModule[y].Enabled == false && InputModule[y].Priority >= z)
      {
        ModuleString = split(InputModule[y].ModuleFlagStr, ','); //fill with bit string

        for(int q = 0; q != ModuleString.length; q++)
        {  
          for(int i = 0; i != DevStrArray.length; i++)
          {  
            if(DevStrArray[i].equals(ModuleString[q]) == true) //if string matches
            {
              if(InputModule[y].Enabled == false) 
              {
                //println("Bit tile placed priority "+z);
                //println("Module Priority: "+InputModule[y].Priority);              
                InputModule[y].PlaceTile();
              }
            }
          } //end i for()
        } //end q for()  
        
        //==============================================================
        
        ModuleString = split(InputModule[y].ModuleByteStr, ','); //refill with byte string
        
        for(int q = 0; q != ModuleString.length; q++)
        {  
          for(int i = 0; i != ByteStrArray.length; i++)
          {  
            if(ByteStrArray[i].equals(ModuleString[q]) == true) //if string matches
            {
              if(InputModule[y].Enabled == false) 
              {
                //println("Byte tile placed priority "+z);
                //println(InputModule[y].Priority);              
                InputModule[y].PlaceTile();
              }
            }
          } //end i for()
        } //end q for()          
      }
    } //end y for()
  }  //end z for()
  

  ///Now place all unprioritized not yet enabled tiles
  for(int y = 0; y != InputModule.length;y++)
  {  
    if(InputModule[y].Enabled == false)
    {
      ModuleString = split(InputModule[y].ModuleFlagStr, ',');

      for(int q = 0; q != ModuleString.length; q++)
      {  
        for(int i = 0; i != DevStrArray.length; i++)
        {  
          if(DevStrArray[i].equals(ModuleString[q]) == true) //if string matches
          {
            if(InputModule[y].Enabled == false) 
            {            
              InputModule[y].PlaceTile();
            }
          }
        } //end i for()
      } //end q for()  
      
      //==============================================================
      
      ModuleString = split(InputModule[y].ModuleByteStr, ',');
      
      for(int q = 0; q != ModuleString.length; q++)
      {  
        for(int i = 0; i != ByteStrArray.length; i++)
        {  
          if(ByteStrArray[i].equals(ModuleString[q]) == true) //if string matches
          {
            if(InputModule[y].Enabled == false) 
            {          
              InputModule[y].PlaceTile();
            }
          }
        } //end i for()
      } //end q for()        
      
    }
  } //end y for()
  //Modules placed and prioritized

  // ================   Set additional define flags that require configurations to be loaded ==============

  //if 16-bit data mode or has 16-bit pack function for serial, live control would also be 16-bit capable
  if(device.Bit16Mode == true || IsOnConfigFlags("f8or16Bit"))   device.Bit16LiveMode = true;

  // ================   grey out unavailable GUI elements ==============


  if(device.BasicVersion > 0)
  {
    if(device.BasicVersion == 1) 
    {
   //   SequenceModeDD.Labels = cDDSequenceModeBasic1;
  //    SequenceModeDD.numStrs = cDDSequenceModeBasic1.length;
    }
    //update sequence type options
    if(device.LinkedSupport == true)
    {
   //   SequenceModeDD.Labels = cDDSequenceModeBasic2;
   //   SequenceModeDD.numStrs = cDDSequenceModeBasic2.length;
    }  
  } //end basicVersion if()

  ShowNotification(1);
  println("Configuration Modules Successfully Loaded - end LoadDeviceFile()");
}//end func()

//==================================================================================================================================================  

boolean IsOnConfigFlags(String passedStr)
{
  for(int i = 0; i != DevStrArray.length; i++)
  {  
    if(DevStrArray[i].equals(passedStr) == true) //if string matches
    {
      println("IsOnConfigFlags() found "+passedStr);
      return true;
    }
  } //end i for()
  return false;
}//end func  

//==================================================================================================================================================

void bitSet(int pointer)
{
  ConfigFlags |= (1 << pointer); 
  //println("BitSet "+pointer+"    "+ConfigFlags);  
} //end func

//==================================================================================================================================================

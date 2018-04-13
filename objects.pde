
//============================================================================================

public class DeviceObj
{
  int HardwareID; //unique hardware ID number
  String Name;  //Stores the readable name for the controller as string
  int HardwareVersion;
  int FirmwareVersion;
  int FirmwareRevision;
  int BootloaderVersion;

  //Sequence defines
  int Channels; //maximum amount of channels
  int MaxSpeed;  
  int MaxIndexedSequences;
  int IndexMemoryModel;
  int MaxFrames;
  int MaxFramesGlobal;
  
  //Memory defines
  int DataSpace;
  int HWPVSpace;
  int HPVBlockSize;
  int SeqMemoryBlockSize; 
  int IndexBlockSize; 
  int CurrentBlockSize;
  int EraseBlockSize;

  boolean LockChannelAmt; //disallow per sequence data size, only device.channels
  int GammaCorrection;
  boolean LinkedSupport;  
  boolean Bit16Mode;  //flag to set 16-bit data mode
  boolean FillUpperData;
  boolean Bit16Processor;
  boolean Bit16LiveMode;
  
  int BasicVersion;
  int BasicMaxSequences; 
  int BasicSeqLength;
  int AccelerometerMode;

  int ArrayCastSize; //can't always use device channels, because of double duty for linked variables
  
//How are these loaded differently???????????????  
  int DMXModeAmt;
  String[] DMXModeLabels;
  int ListedChipsets;

  //Not loaded from Device Files
  int UserConfiguredIDNum; //set by user saved in firwmare  
  int UserIdleSequence;  //Held is save file, sent with index
  
  //scratch
  String ConfigFlagsStr;
  String ConfigBytesStr;
  
  String WebpageURL;
  String MemorySpaceString; //stores byte to kb/mb conversion string

  DeviceObj(String iName)
  {
    HardwareID = 0;
    Name = iName;
    HardwareVersion = 0;
    FirmwareVersion = 0;
    FirmwareRevision = 0;  
    Channels = 0;
    DataSpace = 0;
    BootloaderVersion = 0;
    UserConfiguredIDNum = 0;
    UserIdleSequence = 0;

    MaxFrames = 0;
    MaxFramesGlobal = 0;
  
    MaxIndexedSequences = 8; //default, will get set when device file is loaded
    
    EraseBlockSize = 0;
    HWPVSpace = 0;
    DMXModeAmt = 0;
    GammaCorrection = 0;
    LinkedSupport = false;
    Bit16Mode = false;
    DMXModeLabels = new String[1];   
  }
} //end object

//============================================================================

class SoftwareObj
{
  int frameRate;

  int GUIWidth;
  int GUIHeight;

  boolean mouseOverEnabled;

  //--------------------------------------------------------------------------

  SoftwareObj()
  {
    mouseOverEnabled = false;
  }
  //--------------------------------------------------------------------------
} //end object

//=================================================================================

public class GUIObj
{
  color windowBackground;
    color windowStroke;
  color layerBackground;
  color textColor;
  color textMenuColor;

  color buttonColor;
  color buttonHighlightColor;
  color menuBackground;

  color textFieldHighlight;
  color textFieldBG;
  
 
  //--------------------------------------------------------------------------

  GUIObj()
  {
    windowBackground = color(65, 65, 65);
    windowStroke  = color(255);
    layerBackground = color(100, 100, 100);
    textColor = color(255);
    buttonColor = color(0, 0, 100);
    buttonHighlightColor = color(100, 0, 100);
    
    menuBackground  = color(200);
    textMenuColor = color(0);
    
    textFieldBG = color(255); //white
    textFieldHighlight = color(200, 40, 40);
  }
} //end gui class

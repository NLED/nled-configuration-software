/* //<>//
 MIT License
 
 Copyright (c) 2017 Northern Lights Electronic Design, LLC
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 Original Author: Jeffrey Nygaard
 Company: Northern Lights Electronic Design, LLC
 Contact: JNygaard@NLEDShop.com
 Date Updated: April 13, 2018
 Software Version:  2a
 Webpage: www.NLEDShop.com/nledconfig
 Written in Processing v3.3.7  - www.Processing.org
 
 //============================================================================================================
 
 Supported Devices: 
 
 NLED Pixel Controller Mini - version 4 firmware
 NLED Pixel Controller Micro
 NLED Pixel Controller Ion
 NLED Pixel Controller Electron
 
 NLED 16-Bit RGBW Lamp Controller
 NLED 30 Channel High Current LED Controller
 NLED Quasar
 
*/


/*
 To Do:
 
 
 
 Notes:
 
 - Mini 9600 baud
 - 4 Chan DMX at 19200
 - Octo at 19200
 
 new modules vs Aurora:
 maybe SPBRG, but probably just drop that for simplicity
 Disable notificaiton LED - fActivityLEDEnable
 DMX pixel amount - pix mini - bUserPixelAmountLSB, bUserPixelAmountMSB
 Firmware version - pix mini - fuck it, version 4 only
 End of Frame timing 1 - 255, default at 25 - convert to miliseconds - bUserTimerValue
 
 DMX Deconder Force Full Packets & DMX Decoder Mode - fDMXDecoderModeFull, fDMXDecoderModeEnable
 Enable Serial Color Swap - fEnableSerialColorSwap
 color order: GRB, GRBW, BGR, BRG
 
 Future Revisions:
 - TCP stack
 - merge with bootloader maybe...
 - Add presets like 30 chan DMX, or infinity mirrors  
 - have it read back configurations and test them against what was sent
 
 
 */

// IMPORT Libraries
import processing.serial.*;

//============ Software Constants ================

final int cModueOffsetX = 20;
final int cModueOffsetY = 150;

//============ Application Constants ================

/*
final String cDeviceSelectionList[] = {"null","30 Channel High Current LED Controller", "NLED Four Channel Controller Mini","NLED 4 Channel DMX Wash Controller","Pixel Controller Mini", "Pixel Controller Micro",
 "NLED 16-Bit RGBW Lamp Controller", "NLED OctoSequencer Controller" , "NLED 16 Channel High Current Controller","Pixel Controller Ion", "Pixel Controller Electron" };
 final int cDeviceSelectionListIDNum[] = {0,30,43,44,60,61,104,108,116,148,160}; //stores aurora id numbers for the above strings
 */

final String cDeviceSelectionList[] = {"Select Device From List(Default)", "Pixel Controller Mini(v4)", "Pixel Controller Micro(all)" };
final int cDeviceSelectionListIDNum[] = {0, 60, 61}; //stores aurora id numbers for the above strings

final String[] cPixelChipsetStrings = {"DEFAULT", "WS2801", "WS2811", "WS2812", "WS2812B", "LPD1886", "LPD6803", "LPD8806", "TM1803", "TM1814", "APA102", "APA104", "SK6812", "DMX-512", "APA106"};
final String[] cPixelChipsetColorID = {"varies / unknown", "varies / R>G>B", "varies", "G>R>B", "G>R>B", "TEST", "TEST", "TEST", "varies / G>B>R", "TEST", "B>G>R", "TEST", "G>R>B>W", "R>G>B", "R>G>B"};
final String cModeString[] = {"Stall", "Fade", "Gradient", "Instant", "Technical", "POV", "File Play", "Linked", "DMX", "Serial", "USB"};
final String cPixelIDStr[] = {"Single", "RGB", "RGBW"};
final String cNoneStr[] = {"None"};
final String cColorSwapStr[] = {"None", "B>R>G", "G>B>R", "R>B>G", "B>G>R", "G>R>B"};
final String cGlobalColSwapStr[] = {"R>G>B(>W)", "B>R>G", "G>B>R", "R>B>G", "B>G>R", "G>R>B", "G>R>B>W"};
final String cDDBaudstring[] = {"9600", "19200", "38400", "57600", "115200", "230400", "250000", "460800", "500000", "1Mbit"}; //fix these, there is no 250k without custom FTDI driver, but maybe make one for 500k and 1Mb and 250k
final String cDDLEDMstring[] = {"Both", "Stand-Alone", "RX", "Disabled"};
final String cDDPOVModeString[] = {"Normal Mode", "Mode 1mS", "Mode 2mS", "Mode 3mS", "Mode 4mS", "Mode 5mS", "Mode 6mS", "Mode 8mS", "Mode 16mS"};
final int cDDPOVModeValues[] = {0, 1, 2, 3, 4, 5, 6, 8, 16};
final String cRevisionIDstr[] = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"};
final String cDDAutoDetectModesT1[] = {"None/Disabled", "Auto-Detect DMX", "Auto-Detect Serial"};
final String cDDAutoDetectModesT2[] = {"None/Disabled", "Auto-Detect DMX"};
final String cDDAutoDetectModesT3[] = {"None/Disabled", "Auto-Detect"};
final String cDDMasterModes8Bit[] = {"None/Slave", "Master Full Pkts", "Master Partial Pkts"};
final String cDDMasterModesMultiBit[] = {"None/Slave", "Master Full Pkts 8-Bit", "Master Full Pkts 16-Bit", "Master Partial Pkts 8-Bit", "Master Partial Pkts 16-Bit"};
final String cDDDisplayModes[] = {"Always On", "Countdown", "Dim", "Countdown+Dim"};
final String cDDShapeOptions[] = {"Round", "Square", "Spiral", "Line", "Pixel Map", "Manual"};
final String cDDAccMeterShutOff[] = {"Disabled", "5 Sec.", "10 Sec.", "20 Sec.", "30 Sec", "40 Sec.", "60 Sec.", "80 Sec."};
final String cDDAccMeterShutOffMode[] = {"Blank", "Idle Sequence"};
final int cAccMeterShutOffVals[] = {0, 16, 32, 64, 96, 128, 192, 250};
final String cDDPowerTimeOut[] = {"Disabled", "5 Min.", "10 Min.", "15 Min."};
final String cDDAccMeterTapMode[] = {"Disabled", "Sensitive", "Normal", "Strong"};
final String cDDPWMFreqA[] = {"31 KHz", "7.8 KHz", "1.95 KHz", "488 Hz"};
final String cDDPWMProfileA[] = {"16-Bit, 244Hz", "12-Bit, 3.9KHz", "12-Bit, 478Hz", "8-Bit, 62.5Khz", "8-Bit, 976Hz"};
final String cDDIRRemote[] = {"Disabled", "Enabled, 19200 baud", "Enabled 250k baud"};
final String cDDStandAloneA[] = {"Hold", "Blank", "Fade Out", "Stand-Alone"};

final String cDDColorSwapPixMicro[] = {"None/RGB", "G>R>B", "G>R>B>W", "B>G>R", "B>R>G"};
final String cDDBaudstringMiniV4[] = {"9600", "19200", "57600", "115200", "230400", "500000", "1Mbit"}; 

final String cDDPortBaudstring[] = {"USB/None", "9600", "19200", "38400", "57600", "115200", "230400", "250000", "460800", "500000", "1000000"};

final String cDDMicroDMXDecoderMode[] = {"Disabled", "Full Packets", "Force Mode", "Force Mode, Full Packets"};

final String cConfirmBoxText[] = {"null", "Uploading Configurations will overwrite the current settings. Continue?"};


//============ Variables ================

int mouseXS, mouseYS; //scaled mouse values for resizing
float SF = 1; //scale factor for GUI resizing

int OverlayMenuID = 0;

int modulePosX = 90;
int modulePosY = 380;
int moduleHoldX = 0;
int moduleHoldY = 0;
int moduleHoldSz = 0;
int[] PixelChipsetID  = new int[2];

boolean GlobalDDOpen = false;
boolean GlobalDragging = false;
boolean TextFieldActive = false;
boolean NumberInputFieldActive = false;

String GlobalLabelStore = "";  //used for text fields

//String DisplayStatusStr = "Starting"; 
String DisplayMessageStr = "Starting"; 

String[] DevStrArray = new String[16];
int ConfigFlags = 0;  
int holdHardwareID = 0;

int RXByte1 = -1;    // Incoming serial data
int RXByte2 = 0;
int RXByte3 = 0;
int RXByte4 = 0;
int RXByte5 = 0;

int SendCounter = 0;
int SendCounterB = 0;
int USBpacketCount = 0;

byte[] USBPacket = new byte[64];
int PacketPointer = 0;

boolean devConnected = false;
boolean RecievedOpenAck = false;
boolean SentCmdRequest = false;
boolean SentOpenRequest = false;
boolean SentConfigRequest = false;
boolean LiveControlEnabled = false;
boolean UploadInProgress = false;
boolean WaitForAckFlag = false;  
boolean TerminateUpload = false;

boolean ConfigUploadSent = false; //new

int ExpectedRecieved = 0;
int ReceiveCounter = 0;
int cmdFlags = 0;
int cmdByte = 4; //open connection default
int cmdData[] = {0, 0, 0, 0};

int RecievedDeviceConfigsMSB = 0;
int RecievedDeviceConfigsLSB = 0;


int CommunicationMode = 0; //0 = serial port, 1 = TCP Client
int ProgramBaudRate = 19200; 

int CMDTimeOutVal = 3000; //time in miliseconds default
boolean CmdIssued = false;

String portName = "None";


String ConfirmBoxCallBack = "";
int ConfirmBoxIDNum = 0;

//============ Aurora Command ID#s ================

int cmdOpen = 4;
int cmdUploadConfigurations = 101;
int cmdRequestConfigurations = 120;

//============ General Objects ================

GUIObj gui; //gui object, holds colors and such
SoftwareObj software;
DeviceObj device;


DropDown DropDownPointer;
SliderBar SliderPointer;
TextField textFieldPtr;
guiNumberInputField numberInputFieldPtr;

OverlayMenu[] guiOverlayMenus;


Serial serialPort;

SpecHWModules[] InputModule;  //Configuration Modules

//============ GUI Objects ================

Button menuCloseButton, ConfirmButtonYes, ConfirmButtonNo;

Button comAutoScanButton, comConnectButton, comUploadConfigurations, comDefaultConfigurations;

DropDown comSerialPortDD, comManualDeviceSelectDD, comSerialBaudRateDD;

//============ Module GUI Objects ================

DropDown DMXModesDD, PixelChipsetDD, AutoDetectDD, MasterModeDD, HardwareColSwapDD;
DropDown BaudRateDD, LEDIndicatorModeADD, LEDIndicatorModeBDD;
DropDown StandAloneDD, DisplayModeDD, DisplayModeBDD, ShapeOptionsDD;
DropDown AccMeterAutoDetectDD, AccMeterAutoDetectModeDD, AccMeterTapDD, PowerDownTimeOutDD;
DropDown PWMProfileADD, IRRemoteModeDD, StandAloneADD, PWMFreqADD;

//added
DropDown BaudRateMiniV4DD, HardwareColSwapMicroDD, DMXDecoderModeDD;

TextField[] TextFields;

Button[] HardwareButtons;
CheckBox[] HardwareCheckBox;

//================================== ArrayList for GUI MouseOver Elements ====================================================

//ArrayList<SourceContentTile> SourceContentTileList; //makes list to make it easier to mouseover
//SourceContentTile ContentTilePtr;

ArrayList<Button> ButtonList; //makes list to make it easier to mouseover
Button PointerButton;

ArrayList<TextField> TextFieldList;
TextField TextFieldListPointer;

ArrayList<CheckBox> CheckBoxList;
CheckBox CheckBoxListPointer;

ArrayList<DropDown> DropDownList; //makes list to make it easier to mouseover
int DropDownMouseOverID = 0;

PFont font;

//========================= END OBJECT DECLARTION ==============================

void setup() 
{

  // Initial window size
  size(800, 600); 
  surface.setResizable(true);   // Needed for resizing the window to the sender size
  surface.setLocation(100, 100);
  colorMode(RGB);
  frameRate(30);

  font = createFont("Arial", 48);
  textFont(font);

  PImage titlebaricon = loadImage("favicon.gif");
  surface.setIcon(titlebaricon);

  //==================== Init ArrayList for objects ======================

  ButtonList = new ArrayList<Button>();  
  DropDownList = new ArrayList<DropDown>();  
  TextFieldList = new ArrayList<TextField>();  
  CheckBoxList = new ArrayList<CheckBox>();  

  //====================== Init General Objects ==========================

  gui = new GUIObj(); //init graphic user interface from XML file
  software = new SoftwareObj();
  device = new DeviceObj("No Device");

  BuildCOMDropDown();//comSerialPortDD = new DropDown(serialPort.list(), serialPort.list().length, 0, 10, 10, 110, 25, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");
  comManualDeviceSelectDD = new DropDown(cDeviceSelectionList, cDeviceSelectionList.length, 0, 400, 25, 300, 25, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "ManualDeviceDDCallBack");
  comSerialBaudRateDD = new DropDown(cDDPortBaudstring, cDDPortBaudstring.length, 0, 220, 45, 120, 25, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");

  ConfirmButtonYes = new Button("Yes", 325, 325, 60, 25, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, false, true);
  ConfirmButtonNo = new Button("No", 415, 325, 60, 25, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, false, true);
  comAutoScanButton = new Button("Auto-Scan Ports", 220, 10, 120, 25, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, false, true);
  comConnectButton = new Button("Connect", 120, 10, 90, 25, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, false, true);
  comUploadConfigurations  = new Button("Upload Configurations", 20, 110, 160, 25, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, false, true);
  comDefaultConfigurations  = new Button("Set To Default", 625, 110, 140, 25, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, false, true);

  comDefaultConfigurations.status = 1; //disable for now, no function
  comAutoScanButton.status  = 1;//disable for now, no function

  //====================== Start GUI objects Definition ==========================

  AccMeterAutoDetectDD = new DropDown(cDDAccMeterShutOff, cDDAccMeterShutOff.length, 0, 420, 180, 100, 20, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");
  AccMeterAutoDetectModeDD = new DropDown(cDDAccMeterShutOffMode, cDDAccMeterShutOffMode.length, 0, 420, 180, 100, 20, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");
  AccMeterTapDD  = new DropDown(cDDAccMeterTapMode, cDDAccMeterTapMode.length, 0, 420, 180, 100, 20, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");
  LEDIndicatorModeADD = new DropDown(cDDLEDMstring, cDDLEDMstring.length, 0, 420, 180, 100, 20, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");
  LEDIndicatorModeBDD = new DropDown(cDDLEDMstring, cDDLEDMstring.length, 0, 420, 180, 100, 20, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");
  DMXModesDD = new DropDown(cNoneStr, 1, 0, 85, 280, 170, 20, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");
  BaudRateDD = new DropDown(cDDBaudstring, cDDBaudstring.length, 0, 260, 215, 100, 20, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");
  DisplayModeDD = new DropDown(cDDDisplayModes, cDDDisplayModes.length, 0, 415, 240, 120, 20, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");    
  DisplayModeBDD = new DropDown(cDDDisplayModes, cDDDisplayModes.length, 0, 415, 240, 120, 20, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");    
  MasterModeDD = new DropDown(cDDMasterModes8Bit, cDDMasterModes8Bit.length, 0, 90, 340, 140, 20, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");  
  AutoDetectDD = new DropDown(cDDAutoDetectModesT1, cDDAutoDetectModesT1.length, 0, 405, 300, 120, 20, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");  
  HardwareColSwapDD = new DropDown(cGlobalColSwapStr, cGlobalColSwapStr.length, 0, 480, 470, 100, 20, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");
  PixelChipsetDD = new DropDown(cNoneStr, cNoneStr.length, 0, 350, 470, 140, 20, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack"); 
  ShapeOptionsDD = new DropDown(cDDShapeOptions, cDDShapeOptions.length, 0, 290, 425, 100, 25, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");
  PowerDownTimeOutDD = new DropDown(cDDPowerTimeOut, cDDPowerTimeOut.length, 0, 405, 300, 120, 20, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");  
  PWMProfileADD = new DropDown(cDDPWMProfileA, cDDPWMProfileA.length, 0, 405, 300, 140, 20, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");  
  IRRemoteModeDD = new DropDown(cDDIRRemote, cDDIRRemote.length, 0, 405, 300, 140, 20, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");  
  PWMFreqADD = new DropDown(cDDPWMFreqA, cDDPWMFreqA.length, 0, 5, 160, 100, 25, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");   
  StandAloneADD = new DropDown(cDDStandAloneA, cDDStandAloneA.length, 0, 5, 160, 110, 25, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");  
  StandAloneDD = new DropDown(cColorSwapStr, cColorSwapStr.length, 0, 215, 60, 120, 25, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");

  //Added
  BaudRateMiniV4DD = new DropDown(cDDBaudstringMiniV4, cDDBaudstringMiniV4.length, 0, 260, 215, 100, 20, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");
  HardwareColSwapMicroDD = new DropDown(cDDColorSwapPixMicro, cDDColorSwapPixMicro.length, 0, 480, 470, 100, 20, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");
  DMXDecoderModeDD = new DropDown(cDDMicroDMXDecoderMode, cDDMicroDMXDecoderMode.length, 0, 480, 470, 140, 20, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");

  //=====================================================================================================================================

  TextFields = new TextField[15];

  //TextFields[0] = new TextField("Enter#", 35, 510, 50, 25, color(255), color(200, 40, 40), 1, 0, 255, true, false, "txtHandleSlideValue"); //Slide Value
  //don't have to do this TextFields[0].Status = 1; //start greyed out
  TextFields[1] = new TextField("Enter#", 225, 470, 50, 20, color(255), color(200, 40, 40), 1, 0, 100, true, false, "txtHandleGenericNumber"); //whats this for now? 
  TextFields[2] = new TextField("1", 120, 195, 80, 20, color(255), color(200, 40, 40), 1, 1, 512, true, false, "txtHandleGenericNumber"); //DMX Adr Config

  TextFields[3] = new TextField("5", 120, 195, 80, 20, color(255), color(200, 40, 40), 1, 5, 32, true, false, "txtHandleGenericNumber");  // CONVERTED - End-Of-Frame Timer
  TextFields[4] = new TextField("170", 120, 195, 80, 20, color(255), color(200, 40, 40), 1, 1, 170, true, false, "txtHandleGenericNumber");  // CONVERTED - Pixel Amount

  TextFields[13] = new TextField("1", 20, 265, 25, 25, color(255), color(200, 40, 40), 1, 1, 32, true, false, "txtHandleGenericNumber");  //Stand-Alone Module ID field


  textFieldPtr =  TextFields[1]; //default it so it doesn't NullPointerException

  //=====================================================================================================================================

  HardwareButtons = new Button[6];
  HardwareButtons[0] = new Button("Enabled", 125, 470, 80, 25, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, true, false, true);
  HardwareButtons[1] = new Button("Enabled", 300, 470, 80, 25, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, true, false, true);
  HardwareButtons[2] = new Button("Enabled", 300, 470, 80, 25, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, true, false, true);
  HardwareButtons[3] = new Button("Enabled", 255, 330, 80, 25, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, true, false, true);
  HardwareButtons[4] = new Button("Enabled", 300, 470, 80, 25, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, true, false, true);  

  HardwareCheckBox = new CheckBox[4];
  HardwareCheckBox[0] = new CheckBox(255, 285, 20, 20, color(255), color(0), color(0), false);
  HardwareCheckBox[1] = new CheckBox(255, 285, 20, 20, color(255), color(0), color(0), false);

  //added
  HardwareCheckBox[2] = new CheckBox(255, 285, 20, 20, color(255), color(0), color(0), true); //enable activity LED
  HardwareCheckBox[3] = new CheckBox(255, 285, 20, 20, color(255), color(0), color(0), false); //enable serial color swap - pixmicro


  //====================== Start Module Definition ==========================

  InputModule = new SpecHWModules[31];
  InputModule[0] = new SpecHWModules(0, "Serial RS-485 Enable:\n(Disable for TTL Serial)", 0, 0, 140, 90, "fRS485Enable", "BYTE", 0);
  InputModule[1] = new SpecHWModules(1, "Second Activity\nLED Mode:", 0, 0, 130, 90, "fLEDModeMSBb,fLEDModeLSBb", "BYTE", 0);
  InputModule[2] = new SpecHWModules(2, "Select Correct Color Order For Chipset:", 0, 0, 120, 90, "CONFIG", "bGlobalColorShift", 210);
  InputModule[3] = new SpecHWModules(3, "Select The Pixel Chipset:\n\n\nRecommended Color: varies / R>G>B", 0, 0, 160, 90, "CONFIG", "bPixelChipset", 250);
  InputModule[4] = new SpecHWModules(4, "Enable Serial Reception Instead of DMX reception. Auto-Detect is disabled during serial reception.", 0, 0, 200, 90, "CONFIG", "BYTE", 0);
  InputModule[5] = new SpecHWModules(5, "DMX Address:\n(Enter Number)\n\n\n(1-512)", 0, 0, 120, 90, "CONFIG", "bDMXAdrMSB,bDMXAdrLSB", 0);
  InputModule[6] = new SpecHWModules(6, "DMX Reception\nMode - ID Number: "+DMXModesDD.selStr, 0, 0, 180, 90, "CONFIG", "bDMXModeID", 190); 
  InputModule[7] = new SpecHWModules(7, "DMX Master Mode:\n(Not all listed options are valid)", 0, 0, 160, 90, "fMasterEnable,fMasterFullPkts,fMaster16Bit", "BYTE", 190); 
  InputModule[8] = new SpecHWModules(8, "Serial Baud Rate:\nID Number: "+BaudRateDD.selStr, 0, 0, 120, 90, "f8or16Bit", "bBaudRateID", 200); 
  InputModule[9] = new SpecHWModules(9, "Activity\nLED Mode:", 0, 0, 120, 90, "fLEDModeMSBa,fLEDModeLSBa", "BYTE", 0); 
  InputModule[10] = new SpecHWModules(10, "External\nLED Display Mode:", 0, 0, 140, 90, "fDisModeMSBa,fDisModeLSBa", "BYTE", 190); 
  InputModule[11] = new SpecHWModules(11, "Auto-Detect Data Control Reception:", 0, 0, 140, 90, "fAutoDetectID,fAutoDetect", "BYTE", 180); 
  InputModule[12] = new SpecHWModules(12, "Enable Gamma\nCorrection:\n(See Connection tab)", 0, 0, 140, 90, "fGammaCorrectionEnabled", "CONFIG", 0); 
  InputModule[13] = new SpecHWModules(13, "Accelerometer Movement Detection:", 0, 0, 140, 90, "fAccMeterAutoShutOff,fAccMeterAutoShutOffMode", "bAccmeterTimeoutVal", 210); 
  InputModule[14] = new SpecHWModules(14, "Enable Accelerometer Speed Adjustment", 0, 0, 140, 90, "fAccMeterMovement", "BYTE", 0); 
  InputModule[15] = new SpecHWModules(15, "Enable Accelerometer Double Tap Button Press", 0, 0, 140, 90, "fAccMeterDoubleTap", "bAccmeterDoubleTapVal", 200); 
  InputModule[16] = new SpecHWModules(16, "Power Down\nTime Out", 0, 0, 140, 90, "fTimeOutEnabledMSB,fTimeOutEnabledLSB", "BYTE", 0); 
  InputModule[17] = new SpecHWModules(17, "Pixel Data Packet Cloning:\n(0 is Disabled)", 0, 0, 120, 90, "DELETE", "DELETE", 0); 
  InputModule[18] = new SpecHWModules(18, "Sequence Fade Transition:\n(0 is Disabled)", 0, 0, 120, 90, "DELETE", "DELETE", 0); 
  InputModule[19] = new SpecHWModules(19, "Dual Communication Mode (Serial\n/WiFi/Bluetooth)", 0, 0, 120, 90, "fDualModeCom", "BYTE", 0); 
  InputModule[20] = new SpecHWModules(20, "PWM Frequency:", 0, 0, 120, 90, "CONFIG", "BYTE", 180); 
  InputModule[21] = new SpecHWModules(21, "Stand-Alone Mode\n& Signal Loss Mode:", 0, 0, 160, 90, "CONFIG", "BYTE", 160);
  InputModule[22] = new SpecHWModules(22, "PWM Profile\nResolution & Frequency:", 0, 0, 160, 90, "CONFIG", "bPWMMode", 160);
  InputModule[23] = new SpecHWModules(23, "Enable I.R. Remote Control:\n(Addon Card)", 0, 0, 160, 90, "fIRCardEnable,fIRCardEnableSpeed", "BYTE", 160);

  //added for configuration software  
  InputModule[24] = new SpecHWModules(24, "DMX Pixel Amount:\n(Enter Number)\n\n\n(1-170)", 0, 0, 120, 90, "CONFIG", "bUserPixelAmountMSB,bUserPixelAmountLSB", 0); //textfield
  InputModule[25] = new SpecHWModules(25, "Enable Activity LED:", 0, 0, 120, 90, "fActivityLEDEnable", "BYTE", 0); //checkbox
  InputModule[26] = new SpecHWModules(26, "DMX Decoder Mode:", 0, 0, 160, 90, "fDMXDecoderModeFull,fDMXDecoderModeEnable", "BYTE", 0); //Drop down
  InputModule[27] = new SpecHWModules(27, "Enable Serial Color Swap:", 0, 0, 120, 90, "fEnableSerialColorSwap", "BYTE", 0); //checkbox
  InputModule[28] = new SpecHWModules(28, "Select Color Order For Chipset:", 0, 0, 120, 90, "fColorOrderGRB,fColorOrderGRBW,fColorOrderBGR,fColorOrderBRG", "BYTE", 210); //drop down
  InputModule[29] = new SpecHWModules(29, "End-Of-Frame Timer:\n(in miliseconds):", 0, 0, 120, 90, "CONFIG", "bUserTimerValue", 0); //textfield
  InputModule[30] = new SpecHWModules(30, "Serial Baud Rate:\nID Number: "+BaudRateDD.selStr, 0, 0, 120, 90, "CONFIG", "bBaudRateIDMiniV4", 200); //Drop down


  //cDDBaudstringMiniV4
  //fColorOrderGRB,fColorOrderGRBW,fColorOrderBGR,fColorOrderBRG,


  DisplayMessageStr = "Software Ready"; //rather than call show notificaiton...
  /*
device.HardwareID = 30;
   device.FirmwareVersion = 2;
   device.FirmwareRevision = 0;
   
   LoadDeviceFile();
   */
} //end setup()

//======================================================================================================

void BuildCOMDropDown()
{
  //store and reselect value, say COM 6, and COM4 is added teh selStr is wrong, find the proper value again
  //String holdCOM = 

  if (devConnected == false) ShowNotification(2);

  comSerialPortDD = new DropDown(serialPort.list(), serialPort.list().length, 0, 10, 10, 100, 25, gui.buttonColor, gui.buttonHighlightColor, gui.textColor, false, "genericDDCallBack");
}

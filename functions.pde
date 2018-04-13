

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
  if ( InputModule[21].Enabled == true && StandAloneADD.over()) return true;   
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

//======================================================================================================================

void deselectTextField()
{
  if (TextFieldActive == true)
  {
    if (textFieldPtr.selected == true) 
    {
      textFieldPtr.selected = false; 
      textFieldPtr.label = GlobalLabelStore; //restore
    }
    TextFieldActive = false;
  }

  //---------------------------------------------------------

  if (NumberInputFieldActive == true)
  {
    if (numberInputFieldPtr.selected > 0) 
    {
      numberInputFieldPtr.selected = 0; 
      numberInputFieldPtr.label = GlobalLabelStore; //restore
    }

    NumberInputFieldActive = false;
  }
} //end mousePressedHandleTextFields

//======================================================================================================================

void mousePressed() 
{
  mouseXS = round((float)mouseX / SF);
  mouseYS = round((float)mouseY / SF);

  if (mouseButton == RIGHT) 

  {
    println("X: "+mouseX+"   Y: "+mouseY);

    //---------------------------------------------------------

    //---------------------------------------------------------
  } //end right click
  else     
  {
    //regular left click
    //---------------------------------------------------------

    if (ConfirmBoxIDNum > 0)
    {

      if (ConfirmButtonYes.over())
      {
        switch(ConfirmBoxIDNum)
        {
        case 0: //null
          break;
        case 1: //Upload Configurations      
          if(device.HardwareID == 60 || device.HardwareID == 61)   SendConfigurationsNonAurora();
          else if (device.BasicVersion == 2) RequestConfigurationUploadType2();
          else RequestConfigurationUpload(); //1 & 2
          
          ShowNotification(4);
          break;
        } //end switch

        ConfirmBoxIDNum = 0; //close
      } //end confirm yes

      if (ConfirmButtonNo.over()) ConfirmBoxIDNum = 0; //close

      return;
    } //end confirm box if

    //---------------------------------------------------------

    //If a drop down is open handle first, to prevent click-throughs to other elements
    if (GlobalDDOpen == true)   
    {
      //handle before anything
      if (DropDownPointer.overOpen())
      {
        println("Pressed Open DropDown "+DropDownPointer.selStr);
        method(DropDownPointer.callBack);
      } else
      {
        //else a click was detected that wasn't on the open drop down, close it and leave
        DropDownPointer.selected = false;  
        GlobalDDOpen = false;
      }
      return; //whether it was a click on the open drop down, or somewhere not on the drop down, leave now, no other clicks should be detected
    }

    //---------------------------------------------------------

    if (OverlayMenuID > 0)
    {
      if (guiOverlayMenus[OverlayMenuID].mousePressed()) return; //no need to check over()
      //  if (menuCloseButton.over())  CloseOverLayMenu(); //close the open menu

      deselectTextField(); //handle deselecting previous field if applicable();

      if (guiOverlayMenus[OverlayMenuID].forceOverride == 0) return;
    }

    //---------------------------------------------------------

    if (comSerialPortDD.over()) return;

    if (devConnected == false) 
    {
      if (comManualDeviceSelectDD.over()) return;
      if (comSerialBaudRateDD.over()) return;
    }

    if (comAutoScanButton.over()) return;

    if (comConnectButton.over()) 
    {
      //setup baud rate based on user selections

      if (comSerialBaudRateDD.selStr == 0) ProgramBaudRate = 0;//USB/None selected, use any baud rate, doesn't matter
      else 
      {
        //A baud rate is selected
        ProgramBaudRate = int(comSerialBaudRateDD.labels[comSerialBaudRateDD.selStr]);
      }

      if (devConnected == false) OpenCOMPort(serialPort.list()[comSerialPortDD.selStr]); 
      else CloseCOMPort();
      return;
    }

    if (comUploadConfigurations.over())
    {
      SetConfirmBox(1);
    }

    if (CheckModuleElements() == true) return;
  } //end left click else
} //end mousePressed

//======================================================================================================================

void mouseReleased()
{
  //Update scaled mouse everytime before the values are used
  mouseXS = round((float)mouseX / SF);
  mouseYS = round((float)mouseY / SF);

  GlobalDragging = false; //incase a slider is being dragged
} //end mouseReleased

//======================================================================================================================

void mouseDragged()
{
  //The mouseDragged() function is called once every time the mouse moves while a mouse button is pressed. (If a button is not being pressed, mouseMoved() is called instead.) 
  //println("MouseDragging");
  //  if(GlobalDragging == true) redraw();
}

//======================================================================================================================

void mouseMoved()
{
  mouseXS = round((float)mouseX / SF);
  mouseYS = round((float)mouseY / SF);

  //---------------------------------------------------------

  if (software.mouseOverEnabled == true)
  {
    //Mouse Over Functions
    // Fairly ineffiecent, it will detect any object, even those not shown, so it will always redraw on mouse moved

    for (int i = 0; i != DropDownList.size(); i++) 
    { 
      if (DropDownList.get(i).mouseOver()) return; //no other way to highlight, have to redraw
      if (DropDownList.get(i).mouseOverOpen()) return; //no other way to highlight, have to redraw
    } //end for

    //---------------------------------------------------------

    if (GlobalDDOpen == true)   return; //if a drop down is open, don't bother mousing over any other elements, just leave

    //---------------------------------------------------------

    for (int i = 0; i != ButtonList.size(); i++) 
    { 
      // An ArrayList doesn't know what it is storing so we have to cast the object coming out
      PointerButton = ButtonList.get(i);  
      if (PointerButton.mouseOver()) return;
    } //end for

    //---------------------------------------------------------
  } //end sEnableMouseOver if()
} //end mouseMoved

//======================================================================================================================

void mouseWheel()
{
  println("mouseWheel()");
}

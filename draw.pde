void draw() {
  //update in case of slider or other gui features
  mouseXS = round((float)mouseX / SF);
  mouseYS = round((float)mouseY / SF);

  background(gui.windowBackground);

strokeWeight(2);
stroke(gui.windowStroke);
  line(0, 100, 800, 100);

fill(gui.textColor);
textSize(14);
textAlign(LEFT);


if(devConnected == true) 
{
text("Device Connected",10,75);
text("Serial Port: "+portName+" at "+ProgramBaudRate+" baud",10,60);
}
else  
{
text("Device Not Connected",10,75);
text("Serial Port: "+portName,10,60);
}

text("Status: "+DisplayMessageStr,10,90);
textSize(16);
text("NLED Configuration Software v.1a",400,20);

if(devConnected == true)
{
text("Device: "+device.Name,400,40);
text("Firmware Version: "+(device.FirmwareVersion)+(char(device.FirmwareRevision+97)),400,60);
//if(comManualDeviceSelectDD.selStr > 0) text("This device does not respond, and may not actually be connected",400,80);
}


//======= Handle GUI elements ======================
//could be done in a better way but this is quicker and less debugging

//if(portName.equals("None")) comAutoScanButton.status  = 0;
//else comAutoScanButton.status  = 1;

if(devConnected == false) 
{
text("Some Devices Require Manual Selection", 400, 70);
comUploadConfigurations.status = 1;
//comDefaultConfigurations.status  = 1;
comConnectButton.Label = "Connect";
}
else
{
comUploadConfigurations.status = 0;
//comDefaultConfigurations.status  = 0;
comConnectButton.Label = "Disconnect";
}
//=================== END =========================

for (int i =0; i != InputModule.length; i++) InputModule[i].display();

comAutoScanButton.display();
comConnectButton.display();

comUploadConfigurations.display();
comDefaultConfigurations.display();

comSerialPortDD.display();

if(devConnected == false) 
{
comManualDeviceSelectDD.display();
comSerialBaudRateDD.display();
}


if(serialPort.list().length != comSerialPortDD.numStrs) BuildCOMDropDown(); //updates drop down


if (GlobalDDOpen == true) DropDownPointer.display(); //if a drop down is open, display() it again to ensure it overlays all other drawing


//------------------------------

  if(ConfirmBoxIDNum > 0)
  {
    fill(gui.windowBackground, 128);
    rect(0,0,width,height);
    
    fill(gui.windowStroke);
    stroke(255,0,0);
    strokeWeight(3);
    rect((800/2)-120,(600/2)-60, 240, 120, 20);
    fill(0);
    textSize(14);
    textAlign(CENTER);
   text(cConfirmBoxText[ConfirmBoxIDNum], (800/2)-110, (600/2)-50, 220, 100);
    textAlign(LEFT);
    
    ConfirmButtonYes.display();
    ConfirmButtonNo.display();
  }  

//------------------------------
} //end draw()


//===================================================================================================  

void SendConfigurations()
{
  println("SendConfigurations()"); 

  String[] ModuleString = new String[16];  
  int[] TransmitByteArray = new int[16];  
  DevStrArray = split(device.ConfigFlagsStr, ',');
  //Now single delimenated string is an array, the pointer is the bit number in ConfigFlags  

  //Module0 with matching string ex:   "fDisModeMSBa,fDisModeLSBa"
  //Module1 with matching string ex:   "fAutoDetectID,fAutoDetect"
  //Loop goes through enabled modules, checks the string to the DevStr array  
  //  If a module string matches the list build ConfigFlags

  ConfigFlags = 0; //reset flags here.....

  for(int y = 0; y != InputModule.length;y++)
  {  
    if(InputModule[y].Enabled == true)
    {
      ModuleString = split(InputModule[y].ModuleFlagStr, ',');
      
      for(int q = 0; q != ModuleString.length; q++)
      {  
        for(int i = 0; i != DevStrArray.length; i++)
        {  
          if(DevStrArray[i].equals(ModuleString[q]) == true) //if string matches
          {
            //println("String Matches "+ModuleString[q]+" on Bit ID# "+i+"   StrID: "+q);
            
            if(InputModule[y].GetBitValues(q) == 1) bitSet(i); //this pretty much does it gotta setup modules
          }
        } //end i for()
      } //end q for()  
    } //end if
  } //end y for()

  println("ConfigFlags: "+binary(ConfigFlags,16));
  
  for(int i = 0; i != TransmitByteArray.length;i++) TransmitByteArray[i] = 0; //clear array first
  TransmitByteArray[0] = (ConfigFlags >> 8); //MSB first
  TransmitByteArray[1] = ConfigFlags & 0xFF;  //LSB second
  ///NOW RUN CONFIGURATION BYTES  

  DevStrArray = split(device.ConfigBytesStr, ',');  //load device config byte string
  
  for(int y = 0; y != InputModule.length;y++)
  {    
    if(InputModule[y].Enabled == true)
    {
      ModuleString = split(InputModule[y].ModuleByteStr, ',');

      for(int q = 0; q != ModuleString.length; q++)
      {  
        for(int i = 0; i != DevStrArray.length; i++)
        {  
          if(DevStrArray[i].equals(ModuleString[q]) == true) //if string matches
          {
            //println("Set Byte - String Matches "+ModuleString[q]+" on BYTE# "+(i+2));
            TransmitByteArray[i+2] = InputModule[y].GetByteValues(q);
          }
        } //end i for()
      } //end q for()  
    } //end if
  } //end y for()
  
  printArray(TransmitByteArray);


if(device.BasicVersion == 0)
{
  //Now Send TransmitByteArray
  for(int i = 0; i != (DevStrArray.length+2); i++)  SendSingleDataByte(TransmitByteArray[i]); //+2 for 2x config bytes
}
else if(device.BasicVersion == 3)
{
   println("Sending legacy configurations, rearranging"); 
    //Puts DMX address first, dumps the config MSB, 
  TransmitByteArray[15] = TransmitByteArray[1]; //store first byte in temp - store CONFIG LSB
  TransmitByteArray[0] = TransmitByteArray[2]; //move DMXMSB
  TransmitByteArray[1] = TransmitByteArray[3]; //move DMXLSB
  TransmitByteArray[2] = TransmitByteArray[15]; //restore saved config flags lsb
  TransmitByteArray[3] = TransmitByteArray[4];
  TransmitByteArray[4] = TransmitByteArray[5];
  TransmitByteArray[5] = TransmitByteArray[6];
  TransmitByteArray[6] = TransmitByteArray[7];  
  TransmitByteArray[7] = 0;
  //printArray(TransmitByteArray);
  //Now Send TransmitByteArray
  for(int i = 0; i != 7; i++)  SendSingleDataByte(TransmitByteArray[i]); //magic number
}
  println("SendConfigurations() finished");  
} //end SendConfigurations()  


//=============================================================================================================================================  

 //mini order
 //unlock sequence -> PixelChipsetID(0) -> AdrLSB -> AdrMSB - > UserPixLo -> UserPixHi -> BaudRateID -> custom SPBRG value -> User PR2 Value -> ConfigFlags(8)
 
 // micro
 //unlock sequence -> Chipset ID# -> User Pixel Amount -> ConfigFlags
  
void SendConfigurationsNonAurora()
{
  println("SendConfigurationsNonAurora()"); 

  String[] ModuleString = new String[16];  
  int[] TransmitByteArray = new int[16];  
  DevStrArray = split(device.ConfigFlagsStr, ',');
  //Now single delimenated string is an array, the pointer is the bit number in ConfigFlags  

  //Module0 with matching string ex:   "fDisModeMSBa,fDisModeLSBa"
  //Module1 with matching string ex:   "fAutoDetectID,fAutoDetect"
  //Loop goes through enabled modules, checks the string to the DevStr array  
  //  If a module string matches the list build ConfigFlags

  ConfigFlags = 0; //reset flags here.....

  for(int y = 0; y != InputModule.length;y++)
  {  
    if(InputModule[y].Enabled == true)
    {
      ModuleString = split(InputModule[y].ModuleFlagStr, ',');
      
      for(int q = 0; q != ModuleString.length; q++)
      {  
        for(int i = 0; i != DevStrArray.length; i++)
        {  
          if(DevStrArray[i].equals(ModuleString[q]) == true) //if string matches
          {
            //println("String Matches "+ModuleString[q]+" on Bit ID# "+i+"   StrID: "+q);
            
            if(InputModule[y].GetBitValues(q) == 1) bitSet(i); //this pretty much does it gotta setup modules
          }
        } //end i for()
      } //end q for()  
    } //end if
  } //end y for()

  println("ConfigFlags: "+binary(ConfigFlags,16));
  
  for(int i = 0; i != TransmitByteArray.length;i++) TransmitByteArray[i] = 0; //clear array first
  
  
//  TransmitByteArray[0] = (ConfigFlags >> 8); //MSB first
 // TransmitByteArray[1] = ConfigFlags & 0xFF;  //LSB second
  ///NOW RUN CONFIGURATION BYTES  

  DevStrArray = split(device.ConfigBytesStr, ',');  //load device config byte string

  
  for(int y = 0; y != InputModule.length;y++)
  {    
    if(InputModule[y].Enabled == true)
    {
      ModuleString = split(InputModule[y].ModuleByteStr, ',');

      for(int q = 0; q != ModuleString.length; q++)
      {  
        for(int i = 0; i != DevStrArray.length; i++)
        {  
          if(DevStrArray[i].equals(ModuleString[q]) == true) //if string matches
          {
            //println("Set Byte - String Matches "+ModuleString[q]+" on BYTE# "+(i+2));
            TransmitByteArray[i] = InputModule[y].GetByteValues(q);
          }     
        } //end i for()
      } //end q for()  
    } //end if
  } //end y for()
  
  //now add config flags
  
  TransmitByteArray[DevStrArray.length] = ConfigFlags & 0xFF;  //LSB second
  
  println("Configs placed in ["+(DevStrArray.length)+"]    Sending "+(DevStrArray.length+1)+" bytes");
  printArray(TransmitByteArray);

  //Send Unlock sequence - 123 -> 253 -> 82 -> 7
  SendSingleDataByte(123);
  SendSingleDataByte(253);
  SendSingleDataByte(82);
  SendSingleDataByte(7);

  //Now Send TransmitByteArray
  for(int i = 0; i != (DevStrArray.length+1); i++)  SendSingleDataByte(TransmitByteArray[i]);

  println("SendConfigurationsNonAurora() finished");  
 // ShowNotification(28);
} //end SendConfigurations()  

//==================================================================================================================================================

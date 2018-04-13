
//======================================================================================================

void ManualDeviceDDCallBack()
{
  switch(comManualDeviceSelectDD.selStr)
  {
  case 0:
    comSerialBaudRateDD.selStr = 0; //set to "USB/None"
    comSerialBaudRateDD.status = 0; //show
    break;
  case 1: //pixel mini
    comSerialBaudRateDD.selStr = 1; //set to 9600
    comSerialBaudRateDD.status = 1; //grey
    break;
  case 2:
    comSerialBaudRateDD.selStr = 2; //set to 19200
    comSerialBaudRateDD.status = 1; //grey
    break;
  }
}

//======================================================================================================

void txtHandleGenericNumber()
{
  if (textFieldPtr.inputMethod > 0)
  {
    if (int(textFieldPtr.label) > textFieldPtr.maxValue) textFieldPtr.label = ""+textFieldPtr.maxValue;
    else if (int(textFieldPtr.label) < textFieldPtr.minValue)  textFieldPtr.label = ""+textFieldPtr.minValue;
  }
  textFieldPtr.selected = false;
}


//======================================================================================================

void genericDDCallBack()
{
  //do nothing
}

//======================================================================================================

void genericHandlerTextField()
{
  textFieldPtr.selected = false;
}

//======================================================================================================

void genericNumberInputFieldFloats()
{
  println("generatedTextSize() with "+numberInputFieldPtr.selected);

  switch(numberInputFieldPtr.selected)
  {
  case 0:
    break;
  case 1: //decrement
    if (numberInputFieldPtr.value > numberInputFieldPtr.minValue)   numberInputFieldPtr.value-=0.1;
    break;
  case 2: //increment
    if (numberInputFieldPtr.value < numberInputFieldPtr.maxValue)   numberInputFieldPtr.value+=0.1;
    break; 
  case 3: //typed in selection
    numberInputFieldPtr.selected = 0; //clear selection

    numberInputFieldPtr.value = float(numberInputFieldPtr.label); //covert string to float
    if (numberInputFieldPtr.value < numberInputFieldPtr.minValue)  numberInputFieldPtr.value = numberInputFieldPtr.minValue;
    else if (numberInputFieldPtr.value > numberInputFieldPtr.maxValue)   numberInputFieldPtr.value = numberInputFieldPtr.maxValue;
    break;
  } //end switch

  numberInputFieldPtr.label = str(numberInputFieldPtr.value);
  println("value: "+numberInputFieldPtr.value);
} //end func()

//======================================================================================================

void genericNumberInputField()
{
  println("generatedTextSize() with "+numberInputFieldPtr.selected);

  switch(numberInputFieldPtr.selected)
  {
  case 0:
    break;
  case 1: //decrement
    if (numberInputFieldPtr.value > numberInputFieldPtr.minValue)   numberInputFieldPtr.value--;
    break;
  case 2: //increment
    if (numberInputFieldPtr.value < numberInputFieldPtr.maxValue)   numberInputFieldPtr.value++;
    break; 
  case 3:
    numberInputFieldPtr.selected = 0; //clear selection

    numberInputFieldPtr.value = int(numberInputFieldPtr.label); //covert string to int
    if (numberInputFieldPtr.value < numberInputFieldPtr.minValue)  numberInputFieldPtr.value = numberInputFieldPtr.minValue;
    else if (numberInputFieldPtr.value > numberInputFieldPtr.maxValue)   numberInputFieldPtr.value = numberInputFieldPtr.maxValue;
    break;
  } //end switch

  numberInputFieldPtr.label = str(numberInputFieldPtr.value);
  println("value: "+numberInputFieldPtr.value);
} //end func()

//======================================================================================================

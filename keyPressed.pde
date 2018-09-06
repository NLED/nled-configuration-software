
//===================================================================================================  

void keyPressed()
{
  
  //------------------------------------------------------------------------------------------------
  
  if (NumberInputFieldActive == true)
  {

    if (key == ENTER || key == RETURN)
    {
      NumberInputFieldActive = false;
      method(numberInputFieldPtr.callBack);
      return;
    } //end enter/return if
    else if (key == BACKSPACE)
    {
      try {
        println("Trying");
        numberInputFieldPtr.label = numberInputFieldPtr.label.substring(0, numberInputFieldPtr.label.length()-1);
      }
      catch(Exception e) {
      }  
      return;
    }   


    if (numberInputFieldPtr.inputMethod == 0)
    {
      if (numberInputFieldPtr.label.length() > numberInputFieldPtr.maxValue) return;
      //Makes sure its a valid character otherwise it will be stored(but not seen) in .label as well
      if ((byte)key > 0 && (byte)key < 127) numberInputFieldPtr.label =  ""+numberInputFieldPtr.label + char(key);
      else println("KEY IGNORED"); //DEBUG
      return;
    } else
    {
      if (key=='1' || key== '2' || key=='3' || key=='4' || key=='5' || key=='6' || key=='7' || key=='8' || key=='9' || key=='0' || key=='-' || (key =='.' && numberInputFieldPtr.inputMethod == 3))
      {
        numberInputFieldPtr.label =  ""+numberInputFieldPtr.label + char(key);
        return;
      }
    }
    return;
  }  //end NumberInputFieldActive if()

  //------------------------------------------------------------------------------------------------


  if (TextFieldActive == true)
  {
    if (key == ENTER || key == RETURN)
    {
      TextFieldActive = false;
      method(textFieldPtr.callBack);
      return;
    } //end enter/return if
    else if (key == BACKSPACE)
    {
      try {
        println("Trying");
        textFieldPtr.label = textFieldPtr.label.substring(0, textFieldPtr.label.length()-1);
      }
      catch(Exception e) {
      }  
      return;
    }  


    if (textFieldPtr.inputMethod == 0)
    {
      if (textFieldPtr.label.length() > textFieldPtr.maxValue) return;
      //Makes sure its a valid character otherwise it will be stored(but not seen) in .label as well
      if ((byte)key > 0 && (byte)key < 127) textFieldPtr.label =  ""+textFieldPtr.label + char(key);
      else println("KEY IGNORED"); //DEBUG
      return;
    } else
    {
      if (key=='1' || key== '2' || key=='3' || key=='4' || key=='5' || key=='6' || key=='7' || key=='8' || key=='9' || key=='0' || key=='-' || (key =='.' && textFieldPtr.inputMethod == 3))
      {
        textFieldPtr.label =  ""+textFieldPtr.label + char(key);
        return;
      }
    }


    if (key == ENTER || key == RETURN)
    {
      TextFieldActive = false;
      method(textFieldPtr.callBack);
    } //end enter/return if
    return;
  }  //end NumberInputFieldActive if()


  //------------------------------------------------------------------------------------------------

 // if (key == 'x')  PrintDebugMessages = !PrintDebugMessages;



  if (key == 'i') 
  {
  }


  if (key == ESC) 
  {
    key = 0; //have to alter it or if it gets to the end of the function with key=escape it closes the application
   // CloseOverLayMenu();
    return; //double up preventing escape for closing application
  }

  if (key == CODED) 
  {
    switch(keyCode)
    {
    case UP:
      if(DropDownPointer.selStr > 0) DropDownPointer.selStr--;
      break;

    case DOWN:
      if(DropDownPointer.selStr < (DropDownPointer.numStrs-1) ) DropDownPointer.selStr++;
      break;
    case RIGHT:

      break;

    case LEFT:

      break;
    }
  }
}//end keyPressed()


//=====================================================================================================

class guiNumberInputField
{
  int xpos; 
  int ypos; 
  int size;
  int fieldWidth;

  int minValue;
  int maxValue;

  int inputMethod; //0 = characters only, 1 = numbers only , 2 = numbers only with trailing %, 3 = floats

  String callBack;

  float value;
  String label;
  int status; //0=show, 1=grey out, 2=hide

  int action; //0 = enter, 1 = decrement, 2 = increment

  int selected; //0 = no selection, 1 = decrement, 2 = textfield, 3 = increment
  boolean MouseOverFlag;

  color colTxtBG;
  color colTxtHL;
  color colTxtStroke;
  color colButtonBG;
  color colButtonStroke;

  guiNumberInputField(int ixpos, int iypos, int isize, int ifieldWidth, int iminValue, int imaxValue, int iinputMethod, String icallBack)
  {
    xpos = ixpos;
    ypos = iypos;   
    size = isize;
    fieldWidth = ifieldWidth;
    minValue = iminValue;
    maxValue = imaxValue;
    inputMethod = iinputMethod;
    callBack = icallBack;

    selected = 0;
    MouseOverFlag = false;

    value = minValue;
    label = ""+value;

    colTxtBG = gui.textFieldBG;
    colTxtHL = gui.textFieldHighlight;
    colTxtStroke = gui.buttonColor;

    colButtonBG = gui.buttonColor;
    colButtonStroke = gui.textColor;
  } //end constructor


  //--------------------------------------------------------------------------

  void handleStatus()
  {
    noStroke();

    if (status == 1) //grey out
    {
      strokeWeight(2);
      stroke(gui.windowBackground, 200); //grey out button
      fill(gui.windowBackground, 200); //grey out button
  //    rect(xpos, ypos, fieldWidth+(size/2)+(size*2), size);  
  
  rect(xpos+size+(size/4), ypos, fieldWidth, size);
      rect(xpos, ypos, size, size, size/4);  //rounded corners
    rect(xpos+(size*1.5)+fieldWidth, ypos, size, size, size/4);  
  
      noStroke();
    }
  }

  //--------------------------------------------------------------------------

  void selectField()
  {
    try {
      deselectTextField(); //handle deselecting previous field if applicable
    }
    catch(Exception e) {
    }

    numberInputFieldPtr = this;
    GlobalLabelStore = label;
    label = "";
    NumberInputFieldActive = true;
  }


  //--------------------------------------------------------------------------

  void display()
  {
    if (status == 2) return; //element is hidden, do not draw
    pushStyle();

    strokeWeight(1);
    stroke(colTxtStroke);

    /*
    if (selected == true) 
     {  
     fill(colHL);
     
     if (status == 0 && MouseOverFlag == true) 
     {
     fill(colHL, 128);
     }
     } else  
     {  
     fill(colBG);
     
     if (status == 0 && MouseOverFlag == true) 
     {
     fill(colBG, 64);
     }
     }
     */

    strokeWeight(2);
    fill(colTxtBG);

    if (selected == 3)
    {
      stroke(colTxtHL);
    } else       
    {
      stroke(gui.buttonColor);
      if (status == 0 && MouseOverFlag == true) 
      {
        stroke(colTxtHL, 128);
        fill(colTxtBG, 192);
      }
    }
    rect(xpos+size+(size/4), ypos, fieldWidth, size);

    //adjust stroke to on higligh and invert text color
    noStroke();
    fill(0);
    textSize((size/1.5));
    textAlign(CENTER);

    if (inputMethod == 0 || inputMethod == 3) text(label, xpos+(size*1.25), ypos+((size-(textAscent()+textDescent()))/1.5), fieldWidth, size);
    else if (inputMethod == 1) text(""+int(label), xpos+(size*1.25), ypos+((size-(textAscent()+textDescent()))/1.5), fieldWidth, size); 
    else  if (inputMethod == 2)  text(int(label)+"%", xpos+(size*1.25), ypos+((size-(textAscent()+textDescent()))/1.5), fieldWidth, size);

    strokeWeight(1);
    stroke(colButtonStroke);


    if (selected == 1) fill(colTxtHL);
    else fill(colButtonBG);
    rect(xpos, ypos, size, size, size/4);  //rounded corners

    if (selected == 2) fill(colTxtHL);
    else fill(colButtonBG);
    rect(xpos+(size*1.5)+fieldWidth, ypos, size, size, size/4);  

    //adjust stroke to on higlight and invert text color
    fill(colButtonStroke);

    textSize((size/1.75));
    text("-", xpos+(size/2), ypos+(size/1.5));
    text("+", xpos+(size*2)+fieldWidth, ypos+(size/1.5));

    handleStatus();

    if (selected !=3) selected = 0; //buttons do not stay highlighted but text field does
    popStyle();
  }


  boolean over() 
  {
    if (status != 0) return false;

    //check decrement button    
    if (mouseXS >= xpos && mouseXS <= xpos+size && mouseYS >= ypos && mouseYS <= ypos+size)
    {     

      selectField();
            selected = 1; //decrement
      method(callBack);
      return true;
    } 

    //check decrement button    
    if (mouseXS >= xpos+(size*1.5)+fieldWidth && mouseXS <= xpos+(size*2.5)+fieldWidth && mouseYS >= ypos && mouseYS <= ypos+size)
    {     

      selectField();
            selected = 2; //increment
      method(callBack);
      return true;
    } 

    //check text field    
    if (mouseXS >= xpos+(size*1.25) && mouseXS <= xpos+(size*1.25)+fieldWidth && mouseYS >= ypos && mouseYS <= ypos+size)
    {     
      selectField();
     selected = 3; //text field
      return true;
    } 

    return false;
  } //end 0ver()
} //end class

//=====================================================================================================

class CheckBox
{
  int xpos; // rect xposition  
  int ypos; // rect yposition
  int bWidth;
  int bHeight;
  color colBG;
  color colHL;
  color colOut;  
  boolean selected;
  int status = 0; //0=show, 1=grey out, 2=hide

  boolean MouseOverFlag;

  CheckBox(int ixpos, int iypos, int ibWidth, int ibHeight, color iColBG, color iColHL, color iColOut, boolean iSelected)
  {
    xpos = ixpos;
    ypos = iypos;  
    bWidth = ibWidth;
    bHeight = ibHeight;
    colBG = iColBG;
    colHL = iColHL;
    colOut = iColOut;
    selected = iSelected;

    CheckBoxList.add(this);
    MouseOverFlag = false;
  }

  void display()
  {
    strokeWeight(1);
    stroke(colOut);
    fill(colBG);

    if (selected==true) 
    {  
      fill(colBG);

      if (status == 0 && MouseOverFlag == true) 
      {
        fill(colBG, 128);
      }
    } else  
    {  
      fill(colBG);

      if (status == 0 && MouseOverFlag == true) 
      {
        fill(colBG, 64);
      }
    }    
    rect(xpos, ypos, bWidth, bHeight);  


    if (selected==true)
    {
      line(xpos, ypos, xpos+bWidth, ypos+bHeight);
      line(xpos+bWidth, ypos, xpos, ypos+bHeight);
    }

    handleStatus();
  }//end display()


  void handleStatus()
  {
    noStroke();

    if (status == 1) 
    {
      strokeWeight(2);
      stroke(gui.windowBackground, 200); //grey out button
      fill(gui.windowBackground, 200); //grey out button
      rect(xpos, ypos, bWidth, bHeight);  
      noStroke();
    }
  }

  boolean over() 
  {
    if ( mouseXS >= xpos && mouseXS <= xpos+bWidth && mouseYS >= ypos && mouseYS <= ypos+bHeight && status == 0)
    {     
      selected =! selected;  
      return true;
    } else {
      return false;
    }
  }


  boolean mouseOver() 
  {
    if ( mouseXS >= xpos && mouseXS <= xpos+bWidth && mouseYS >= ypos && mouseYS <= ypos+bHeight && status == 0)
    {     
      MouseOverFlag = true;  
      return true;
    } else {
      MouseOverFlag = false;
      return false;
    }
  }
}//end class

//======================================================================================

class DropDown
{
  //use one over() for detecting the button click and if it is open, then use a different over() with the full tab page size
  String[] labels;
  int numStrs;
  int selStr;
  int xpos; // rect xposition  
  int ypos ; // rect yposition
  int bWidth;
  int bHeight;
  color colBG;
  color colHL;
  color colOut;  
  boolean selected;
  int status; //0=show, 1=grey out, 2=hide

  boolean dirMode; //false = down, true = up

String callBack;

  boolean MouseOverFlag;

  //--------------------------------------------------------------------------

  DropDown(String[] iLabels, int inumStrs, int iSelStr, int ixpos, int iypos, int ibWidth, int ibHeight, color iColBG, color iColHL, color iColOut, boolean iDirMode, String icallBack)
  {
    labels = iLabels; 
    numStrs = inumStrs;
    selStr = iSelStr;
    xpos = ixpos;
    ypos = iypos;  
    bWidth = ibWidth;
    bHeight = ibHeight;
    colBG = iColBG;
    colHL = iColHL;
    colOut = iColOut;
    selected = false;
    dirMode = iDirMode;
    status = 0; //normal
    callBack = icallBack;

    DropDownList.add(this);
  }

  //--------------------------------------------------------------------------

  void handleStatus()
  {
    noStroke();

    if (status == 1) 
    {
      strokeWeight(2);
      stroke(gui.windowBackground, 200); //grey out button
      fill(gui.windowBackground, 200); //grey out button
      rect(xpos, ypos, bWidth, bHeight);  
      noStroke();
    }
  }  

  //--------------------------------------------------------------------------

  void displayNormal()
  {
    strokeWeight(1);
    stroke(colOut);

    //    if (Selected==true) fill(ColHL);
    //    else fill(ColBG);

    if (selected==true) 
    {  
      fill(colHL);

      if (status == 0 && MouseOverFlag == true) 
      {
        fill(colHL, 128);
      }
    } else  
    {  
      fill(colBG);

      if (status == 0 && MouseOverFlag == true) 
      {
        fill(colBG, 64);
      }
    }

    rect(xpos, ypos, bWidth, bHeight);  
    //adjust stroke to on higlight and invert text color
    textAlign(LEFT);
    fill(colOut);
    textSize((bHeight/1.75));
    text(labels[selStr], xpos+(bWidth/20), ypos+((bHeight-(textAscent()+textDescent()))/1.5), bWidth, bHeight);

    fill(255);
    int tempSize = (bWidth/4);
    if (tempSize >  (bHeight/4)) tempSize = (bHeight);

    //   triangle(xpos+(bWidth-(bWidth/4)), ypos+(bHeight/4), xpos+(bWidth-(bWidth/4))+(bHeight/2), ypos+(bHeight/4), xpos+(bWidth-(bWidth/4))+(bHeight/4), ypos+(bHeight/4)+(bHeight/2));
    triangle(xpos+(bWidth-tempSize), ypos+(bHeight/4), xpos+(bWidth-tempSize)+(bHeight/2), ypos+(bHeight/4), xpos+(bWidth-tempSize)+(bHeight/4), ypos+(bHeight/4)+(bHeight/2));
    noStroke();
  }

  //--------------------------------------------------------------------------

  void selectDD()
  {
    selected =! selected;  //toggle selected state

    if (selected == true)
    {  
      DropDownPointer = this;
      GlobalDDOpen = true;
      DropDownMouseOverID = selStr;
    } else
    {
      GlobalDDOpen = false; //clear in case
    }
  }

  //--------------------------------------------------------------------------

  void display()
  {
    if (status == 2) return; //do not display if status = 2 = hide

    pushStyle();

    if (selected == false)
    {
      displayNormal();
    } else
    {
      if (dirMode == false)  
      {  
        //down mode
        fill(colBG);
        displayNormal();
        strokeWeight(1);
        stroke(colOut);  

        for (int i = 0; i != numStrs; i++)
        {
          fill(colBG);
          rect(5+xpos, ypos+(bHeight*(i+1)), bWidth-5, bHeight);
          if (i == selStr) fill(colHL);
          else fill(colBG);
          //drop down drawn

          if (DropDownMouseOverID > 0 && DropDownMouseOverID == (i+1) && MouseOverFlag == true)
          {
            if (i == selStr) fill(colHL, 128);
            else fill(0, 0, 0, 64);//fill(ColBG,64);
          }

          rect(5+xpos, ypos+(bHeight*(i+1)), bWidth-5, bHeight);

          fill(colOut);
          textSize((bHeight/1.75));
          text(labels[i], 5+xpos+((bWidth - textWidth(labels[i]))/2), ypos+((bHeight-(textAscent()+textDescent()))/1.5)+(bHeight*(i+1)), bWidth, bHeight);
        }   //end for 
        noStroke();
      } else
      {            
        //Menu upwards
        displayNormal(); //display the button part
        strokeWeight(1);
        stroke(colOut);  

        for (int i = 0; i != numStrs; i++)
        {
          fill(colBG);
          rect(5+xpos, ypos+(bHeight*(i-numStrs)), bWidth-5, bHeight); //draw background first
          if (((numStrs-1)-i) == selStr) fill(colHL);
          else fill(colBG);
          //drop down drawn

          if (DropDownMouseOverID > 0 && DropDownMouseOverID == (i+1) && MouseOverFlag == true)
          {
            if (((numStrs-1)-i) == selStr) fill(colHL, 128);
            else fill(0, 0, 0, 64);//fill(ColBG,64);
          }
          rect(5+xpos, ypos+(bHeight*(i-numStrs)), bWidth-5, bHeight);
        } //end for

        for (int i = 0; i != numStrs; i++)
        {
          fill(colOut);
          textSize((bHeight/1.75));
          text(labels[i], 5+xpos+((bWidth - textWidth(labels[i]))/2), ypos+((bHeight-(textAscent()+textDescent()))/1.5)-(bHeight*(i+1)), bWidth, bHeight);
        }   //end for 
        noStroke();
      }
    }

    handleStatus();
    popStyle();
  } //end display()

  //--------------------------------------------------------------------------

  boolean overOpen()
  {
    if (dirMode == false)  
    {    
      //Down Mode
      if (selected == false)
      {
        return false;
      } else
      {
        for (int i = 0; i != numStrs; i++)
        {
          if (mouseXS >= xpos && mouseXS <= xpos+bWidth && mouseYS >= ypos+(bHeight*(i+1)) && mouseYS <= ypos+bHeight+(bHeight*(i+1)) && status == 0)
          {    
            selected = false;
            selStr = i;  
            GlobalDDOpen = false;        
            return true;
          }
        }
        selected = false;
        return false;
      }
    } else
    {  
      if (selected == false)
      {
        return false;
      } else
      {
        for (int i = 0; i != numStrs; i++)
        {
          if (mouseXS >= xpos && mouseXS <= xpos+bWidth && mouseYS >= ypos-(bHeight*(i+1)) && mouseYS <= ypos+bHeight-(bHeight*(i-1)) && status == 0)
          {    
            selected = false;
            selStr = i;  
            GlobalDDOpen = false;        
            return true;
          }
        }
        selected = false;
        return false;
      }
    }
  } //end overNew()

  //--------------------------------------------------------------------------

  boolean over() ///over the icon to open
  {
    if ( mouseXS >= xpos && mouseXS <= xpos+bWidth && mouseYS >= ypos && mouseYS <= ypos+bHeight  && status == 0) 
    {    
      if (GlobalDDOpen == true) return false; //if drop down already open, don't let it open another

      selectDD();
      return true;
    } else {
      return false;
    }
  }

  //--------------------------------------------------------------------------

  boolean mouseOver() ///over the icon to open
  {
    if ( mouseXS >= xpos && mouseXS <= xpos+bWidth && mouseYS >= ypos && mouseYS <= ypos+bHeight  && status == 0)   
    {      
      MouseOverFlag = true;  
      return true;
    } else {
      MouseOverFlag = false;
      return false;
    }
  }

  //--------------------------------------------------------------------------

  boolean mouseOverOpen()
  {
    if (dirMode == false)  
    {    
      //Down Mode
      if (selected == false)
      {
        return false;
      } else
      {
        for (int i = 0; i != numStrs; i++)
        {
          if (mouseXS >= xpos && mouseXS <= xpos+bWidth && mouseYS >= ypos+(bHeight*(i+1)) && mouseYS <= ypos+bHeight+(bHeight*(i+1)) && status == 0)
          {    
            MouseOverFlag = true;
            DropDownMouseOverID = i+1;        
            return true;
          }
        }
        DropDownMouseOverID = 0;
        MouseOverFlag = false;
        return false;
      }
    } else
    {  
      if (selected == false)
      {
        return false;
      } else
      {
        for (int i = 0; i != numStrs; i++)
        {
          if (mouseXS >= xpos && mouseXS <= xpos+bWidth && mouseYS >= ypos-(bHeight*(i+1)) && mouseYS <= ypos+bHeight-(bHeight*(i-1)) && status == 0)
          {    
            MouseOverFlag = true;
            DropDownMouseOverID = (numStrs-i);        
            return true;
          }
        }
        DropDownMouseOverID = 0;
        MouseOverFlag = false;
        return false;
      }
    }
  } //end overNew()
} //end dropdown class

//======================================================================================

class Button
{
  String Label;
  int xpos; // rect xposition  
  int ypos ; // rect yposition
  int bWidth;
  int bHeight;
  color colBG;
  color colHL;
  color colOut;  
  boolean toggle;
  boolean selected;
  int status; //0=show, 1=grey out, 2=hide

  boolean MouseOverFlag;

  //--------------------------------------------------------------------------

  Button(String iLabel, int ixpos, int iypos, int ibWidth, int ibHeight, color iColBG, color iColHL, color iColOut, boolean iToggle, boolean iSelected, boolean iAllowMouseOver)
  {
    Label = iLabel; 
    xpos = ixpos;
    ypos = iypos;  
    bWidth = ibWidth;
    bHeight = ibHeight;
    colBG = iColBG;
    colHL = iColHL;
    colOut = iColOut;
    toggle = iToggle;
    selected = iSelected;
    status = 0; //init at 0

    //Setup mouse over list
    if (iAllowMouseOver == true) ButtonList.add(this);
    MouseOverFlag = false;
  }

  //--------------------------------------------------------------------------

  void handleStatus()
  {
    noStroke();

    if (status == 1) 
    {
      strokeWeight(2);
      stroke(gui.windowBackground, 200); //grey out button
      fill(gui.windowBackground, 200); //grey out button
      rect(xpos, ypos, bWidth, bHeight);  
      noStroke();
    }
  }

  //--------------------------------------------------------------------------

  void displayOutline()
  {
    strokeWeight(3);
    stroke(colOut);

    fill(255, 255, 255, 0); //transparent fill
    rect(xpos, ypos, bWidth, bHeight, bHeight/4);
  }

  //--------------------------------------------------------------------------

  void display()
  {
    if (status == 2) return; //element is hidden, do not draw
    pushStyle();
    strokeWeight(1);
    stroke(colOut);

    if (selected==true) 
    {  
      fill(colHL);

      if (status == 0 && MouseOverFlag == true) 
      {
        fill(colHL, 128);
      }
    } else  
    {  
      fill(colBG);

      if (status == 0 && MouseOverFlag == true) 
      {
        fill(colBG, 64);
      }
    }

    textAlign(LEFT);
    rect(xpos, ypos, bWidth, bHeight, bHeight/4);  
    //adjust stroke to on higlight and invert text color
    fill(colOut);
    textSize((bHeight/1.75));
    text(Label, xpos+((bWidth - textWidth(Label))/2), ypos+((bHeight-(textAscent()+textDescent()))/1.5), bWidth, bHeight);

    handleStatus();

    if (toggle==false) selected = false;
    popStyle();
  }

  //--------------------------------------------------------------------------

  boolean over() 
  {
    if (mouseXS >= xpos && mouseXS <= xpos+bWidth && mouseYS >= ypos && mouseYS <= ypos+bHeight && status == 0) 
    {      
      selected =! selected;  
      return true;
    } else {
      return false;
    }
  } //end over()

  //--------------------------------------------------------------------------

  boolean mouseOver() //does not toggle selected
  {
    if (mouseXS >= xpos && mouseXS <= xpos+bWidth && mouseYS >= ypos && mouseYS <= ypos+bHeight && status == 0) 
    {      
      MouseOverFlag = true;  
      return true;
    } else {
      MouseOverFlag = false;
      return false;
    }
  } //end over()
} //end class

//======================================================================================

class SliderBar
{
  int  SetNumber;
  int xpos; // rect xposition  
  int ypos ; // rect yposition
  int slWidth; // single bar slWidthth
  int slHeight; // rect height
  int Value; 
  int Minimum; 
  int Maximum;
  color BgColor;
  color slHandleColor;
  color slSelectColor; 
  color slStrokeColor;
  boolean CircleHandle;  //ture circle, false rectangle
  boolean HorizVertToggle;
  boolean ScrollBarToggle;
  boolean GraphicDisplay;

  String methodStr;

  int status;

  //gotta move the int variables into float variables
  float temp1=slWidth;
  float temp2=Maximum;
  float temp3=Value;
  float temp4=Minimum;
  float MathVar=0;

  SliderBar(int iSetNumber, int ixp, int iyp, int iw, int ih, int iValue, int iMin, int iMax, color iBgColor, color islHandleColor, color islSelectColor, color islStrokeColor, boolean iCircleHandle, boolean iHorizVertToggle, boolean iScrollBarToggle, boolean iGraphicDisplay, String imethodStr) 
  {   
    xpos = ixp;
    ypos = iyp;  
    slWidth = iw;
    slHeight = ih;
    Value=iValue;
    Maximum=iMax;
    Minimum=iMin;
    BgColor=iBgColor;
    slHandleColor=islHandleColor;
    slSelectColor=islSelectColor;
    slStrokeColor=islStrokeColor;
    CircleHandle=iCircleHandle;      //false is rectangle, true is circle
    HorizVertToggle=iHorizVertToggle; //false is horiz, true is vert
    ScrollBarToggle=iScrollBarToggle; //false is normal, true is scrollbar style
    GraphicDisplay = iGraphicDisplay;
    methodStr =imethodStr;
    SetNumber = iSetNumber;

    status = 0;  //0=show, 1=grey out, 2=hide
  }

  void setValue(int passedVal)
  {
    if (passedVal > Maximum) { //check so it doesn't drag off the end
      passedVal = Maximum;
    }
    if (passedVal < Minimum) { //check so it doesn't drag off the end
      passedVal = Minimum;
    }
    Value = passedVal;
  }//end setValue() 


  int getUnsignedChar()
  {
    //returns 8 bit unsigned number 0 - 255, based on float 
    return int(255*getFloat());
  }


  float getFloat()
  {
    return ((float)Value / (float)Maximum);
  }


  int getValue()
  {
    if (Value > Maximum) { //check so it doesn't drag off the end
      Value = Maximum;
    }
    if (Value < Minimum) { //check so it doesn't drag off the end
      Value = Minimum;
    }  

    return Value;
  }

  void runMethod()
  {
    move(mouseXS, mouseYS);
    try {
      method(methodStr); //run function that is called everytime the slider is adjusted
    }
    catch(Exception e) { 
      println("Slider Method not found");
    }
  }



  void move(int uX, int uY) 
  {
    //uX = round((float)uX / SF);
    //uY = round((float)uY / SF);    
    if (ScrollBarToggle == true)
    {
      //scrollbar mode
      if (HorizVertToggle == false) //horizontal
      {
        //this function handles position of the slider's handle for Verticle
        temp1 = slWidth - (slHeight * 2);   
        temp3 = Value;

        MathVar = ((((uX-xpos)-slHeight) / temp1)-1) *-1; //creates a scale factor based on mouse position 
        MathVar = Maximum - (MathVar*(Maximum-Minimum));   

        if (MathVar > Maximum) { //check so it doesn't drag off the end
          MathVar=Maximum;
        }
        if (MathVar < Minimum) { //check so it doesn't drag off the end
          MathVar=Minimum;
        }    

        Value=int(MathVar); //set the value based on mouse movement
      }//end if
      else
      {
        //this function handles position of the slider's handle for Verticle
        temp1 = slHeight - (slWidth * 2);   
        temp3 = Value;

        MathVar = ((((uY-ypos)-slWidth) / temp1)-1) *-1; //creates a scale factor based on mouse position  
        MathVar = Maximum - (MathVar*(Maximum-Minimum));   

        if (MathVar > Maximum) { //check so it doesn't drag off the end
          MathVar=Maximum;
        }
        if (MathVar < Minimum) { //check so it doesn't drag off the end
          MathVar=Minimum;
        }  
        Value=int(MathVar); //set the value based on mouse movement
      }
    } else
    {
      //regular usage
      if (HorizVertToggle == false) //horizontal
      {
        //this function handles position of the slider's handle
        temp1 = slWidth;   
        temp3 = Value;
        temp4 = Minimum;

        MathVar = (((uX-xpos) / temp1)-1) *-1; //creates a scale factor based on mouse position 
        //relative to slider position
        MathVar = Maximum - (MathVar*(Maximum-Minimum));   

        if (MathVar > Maximum) { //check so it doesn't drag off the end
          MathVar=Maximum;
        }

        if (MathVar < Minimum) { //check so it doesn't drag off the end
          MathVar=Minimum;
        }  

        Value = int(MathVar); //set the value based on mouse movement
      }//end if
      else
      {
        println("NO SLIDER MOVE() HANDLER");
      }
    }
  } //end move()


  void display() 
  {   
    if (status == 2) return; //element is hidden, do not draw

    pushStyle();

    if (ScrollBarToggle == true)//ScrollBarToggle places buttons at either end, if false it has no end space
    {
      if (HorizVertToggle == false) //horizontal
      { 
        stroke(slStrokeColor);
        strokeWeight(1);

        //circle handles are displayed differently so there are if/else statements to set it correctly
        fill(BgColor); //covers up the old slider with a blank rectangle, BgColor set in declaration
        rect(xpos, ypos, slWidth, slHeight);   //main rect

        fill(200); 
        rect(xpos+(slHeight/10)+slHeight, ypos+(slHeight/10), slWidth-(slHeight/5)-(slHeight*2), (slHeight-(slHeight/5)));   //middle    
        rect(xpos+(slHeight/10), ypos+(slHeight/10), slHeight-(slHeight/5), slHeight-(slHeight/5)); //left rect  
        rect(xpos+(slHeight/10)+(slWidth-slHeight), ypos+(slHeight/10), slHeight-(slHeight/5), slHeight-(slHeight/5));  //right rect 

        stroke(slStrokeColor);
        fill(slHandleColor);
        strokeWeight(1);
        //top
        triangle(xpos+slHeight-(slHeight/5), ypos+(slHeight/5), xpos+slHeight-(slHeight/5), ypos+(slHeight-(slHeight/5)), xpos+(slHeight/5), ypos+(slHeight/2));  
        //right
        triangle(xpos+slWidth-slHeight+(slHeight/5), ypos+(slHeight/5), xpos+slWidth-slHeight+(slHeight/5), ypos+(slHeight-(slHeight/5)), xpos+slWidth-slHeight+slHeight-(slHeight/5), ypos+(slHeight/2));
        //Handle

        temp1 = (slWidth - (slHeight*3));
        temp2 = Maximum;  //move variables into float
        temp3 = Value;    //or do they don't compute correctly
        temp4 = Minimum;      
        float MathVar;

        MathVar = temp1 / (temp2 - temp4) * (temp3-temp4) + slHeight/2+slHeight;

        fill(slHandleColor); //places the slider handle
        ellipse(xpos+MathVar, ypos+(slHeight/2), slHeight-2, slHeight-2); //Circle instead of rectangle
      } else
      {
        stroke(slStrokeColor);
        strokeWeight(1);

        //circle handles are displayed differently so there are if/else statements to set it correctly
        fill(BgColor); //covers up the old slider with a blank rectangle, BgColor set in declaration
        rect(xpos, ypos, slWidth, slHeight);  

        fill(200); 
        rect(xpos+(slWidth/10), ypos+(slWidth/10)+slWidth, slWidth-(slWidth/5), (slHeight-(slWidth/5))-(slWidth*2));   
        rect(xpos+(slWidth/10), ypos+(slWidth/10), slWidth-(slWidth/5), slWidth-(slWidth/5));   
        rect(xpos+(slWidth/10), ypos+(slWidth/10)+slHeight-slWidth, slWidth-(slWidth/5), slWidth-(slWidth/5));   

        stroke(slStrokeColor);
        fill(slHandleColor);
        strokeWeight(1);
        //top
        triangle(xpos+(slWidth/5), ypos+(slWidth/4)+(slWidth/2), xpos+(slWidth/2), ypos+(slWidth/5), (xpos+slWidth) - (slWidth/5), ypos+(slWidth/4)+(slWidth/2));
        //bottom
        triangle(xpos+(slWidth/5), ypos+(slWidth/4)+slHeight-slWidth, xpos+(slWidth/2), ypos+slHeight-(slWidth/5), (xpos+slWidth) - (slWidth/5), ypos+(slWidth/4)+slHeight-slWidth);

        temp1 = (slHeight - (slWidth*3));
        temp2 = Maximum;  //move variables into float
        temp3 = Value;    //or do they don't compute correctly
        temp4 = Minimum;

        //println(temp1+" : "+temp2+" : "+temp3+" : "+temp4);

        //Handle
        float MathVar;
        MathVar = temp1 / (temp2 - temp4) * (temp3-temp4) + slWidth/2+slWidth;
        fill(slHandleColor); //places the slider handle
        ellipse(xpos+(slWidth/2), ypos+MathVar, slWidth-2, slWidth-2); //Circle instead of rectangle

        // rect(xpos, ypos+MathVar, slWidth, slWidth); //and comment this line for circle
        noStroke();
      }
    } else
    {
      stroke(slStrokeColor);
      strokeWeight(1);

      //circle handles are displayed differently so there are if/else statements to set it correctly
      fill(BgColor); //covers up the old slider with a blank rectangle, BgColor set in declaration
      rect(xpos, ypos, slWidth, slHeight);   

      if (CircleHandle==true) temp1 = slWidth - slHeight;
      else temp1=slWidth-(slWidth/20);

      temp2=Maximum;  //move variables into float
      temp3=Value;    //or do they don't compute correctly
      temp4 = Minimum;

      float MathVar;

      if (CircleHandle==true)
        MathVar = temp1 / (temp2 - temp4) * (temp3-temp4) + slHeight/2;
      else  
      MathVar = temp1 / (temp2 - temp4) * (temp3-temp4); 

      fill(color(slSelectColor)); //draws the Selcolor over the selected area
      rect(xpos, ypos, MathVar, slHeight);

      fill(slHandleColor); //places the slider handle
      if (CircleHandle==true)   ellipse(xpos+MathVar, ypos+(slHeight/2), slHeight-1, slHeight-1); //Circle instead of rectangle
      else   rect((xpos+MathVar), ypos, slWidth/20, slHeight); //and comment this line for circle
    }
    popStyle();
  }//end display()

  void selectSlider()
  {
    SliderPointer = this;
    GlobalDragging = true;
  }//end selectSlider

  boolean over() 
  {
    if (mouseXS >= xpos && mouseXS <= xpos+slWidth && mouseYS >= ypos && mouseYS <= ypos+slHeight) 
    {          
      return true;
    } else {
      return false;
    }
  }
}

//=====================================================================================

class TextField
{
  String label;
  int xpos; // rect xposition  
  int ypos ; // rect yposition
  int bWidth;
  int bHeight;
  color colBG;
  color colHL;

  int inputMethod; //0 = characters only, 1 = numbers only , 2 = numbers only with trailing %, 3 = floats
  int minValue; //either min number, or minim characters
  int maxValue; //either max number, or maximum characters
  boolean toggle;
  boolean selected;
  String callBack;

  int status; //0=show, 1=grey out, 2=hide

  boolean MouseOverFlag;

  TextField(String iLabel, int ixpos, int iypos, int ibWidth, int ibHeight, color iColBG, color iColHL, int iInputMethod, int iminValue, int imaxValue, boolean iToggle, boolean iSelected, String itxtfCallback)
  {
    label = iLabel; 
    xpos = ixpos;
    ypos = iypos;  
    bWidth = ibWidth;
    bHeight = ibHeight;
    colBG = iColBG;
    colHL = iColHL;
    toggle = iToggle;
    selected = iSelected;
    inputMethod = iInputMethod;
    minValue = iminValue; 
    maxValue = imaxValue; 
    callBack = itxtfCallback;
    status = 0; //init at show

    //if(sEnableMouseOver == 1) 
    TextFieldList.add(this);
    MouseOverFlag = false;
  }

  void handleStatus()
  {
    noStroke();

    if (status == 1) 
    {
      strokeWeight(2);
      stroke(gui.windowBackground, 200); //grey out button
      fill(gui.windowBackground, 200); //grey out button
      rect(xpos, ypos, bWidth, bHeight);  
      noStroke();
    }
  }  

  void display()
  {
    if (status == 2) return; //element is hidden, do not draw

    //translate(0, 0);
    strokeWeight(2);
    fill(colBG);

    if (selected==true)
    {
      stroke(colHL);
    } else       
    {
      stroke(gui.buttonColor);
      if (status == 0 && MouseOverFlag == true) 
      {
        stroke(colHL, 128);
        fill(colBG, 192);
      }
    }
    rect(xpos, ypos, bWidth, bHeight);

    //adjust stroke to on higligh and invert text color
    noStroke();
    fill(0);
    textSize((bHeight/1.75));

    textAlign(LEFT);
    if (inputMethod != 2) text(label, xpos+((bWidth - textWidth(label))/2), ypos+((bHeight-(textAscent()+textDescent()))/1.5), bWidth, bHeight);
    else  text(label+"%", xpos+((bWidth - textWidth(label+1))/2), ypos+((bHeight-(textAscent()+textDescent()))/1.5), bWidth, bHeight);

    handleStatus();

    if (toggle==false) selected = false;
  }


  void SelectField()
  {
    try {
      //textFieldPtr.selected = false; //was commented out
      deselectTextField(); //handle deselecting previous field if applicable
    }
    catch(Exception e) {
    }

    textFieldPtr = this;
    GlobalLabelStore = label;
    label = "";
    selected = true; 

    TextFieldActive = true;
  }


  boolean over() 
  {
    if (mouseXS >= xpos && mouseXS <= xpos+bWidth && mouseYS >= ypos && mouseYS <= ypos+bHeight && status == 0) 
    {     
      selected =! selected;    
      return true;
    } else {
      return false;
    }
  }

  boolean mouseOver() //does not toggle selected
  {
    if (mouseXS >= xpos && mouseXS <= xpos+bWidth && mouseYS >= ypos && mouseYS <= ypos+bHeight && status == 0) 
    {     
      MouseOverFlag = true;    
      return true;
    } else {
      MouseOverFlag = false;
      return false;
    }
  } //end over()
} 

//============================================================================================

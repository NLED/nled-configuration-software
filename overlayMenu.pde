
//=======================================================================================================================  

class OverlayMenu
{
  int ObjID;
  int xpos;
  int ypos;
  int Height;
  int Width;

  int autoPosition; //0 = use xpos & ypos, 1 = center X & Y, 2 = center Y alight right, 3 = center Y align left
  int forceOverride; //0 = only menu elements can be clicked, 1 = any exposed elements can be clicked

  int xOffset, yOffset;

  //constructor
  OverlayMenu(int iObjID, int ixpos, int iypos, int ibWidth, int ibHeight)
  {
    ObjID = iObjID;
    xpos = ixpos;
    ypos = iypos;  
    Width = ibWidth;
    Height = ibHeight;

    autoPosition = 1; //set as default
    forceOverride = 0;
  } //end constructor

  //-----------------------------------------------------------------------------------------------

  void display()
  {
    pushStyle();
    fill(gui.menuBackground);
    stroke(0);
    strokeWeight(4);


    //draws background of menu
    switch(autoPosition) 
    {
    case 0:
    default:
      rect(xpos, ypos, Width, Height, 20);
      break;
    case 1:
      rect((width-Width)/2, (height-Height)/2, Width, Height, 20);
      break;
    }//end switch

    //========================================

    switch(ObjID)
    {
    case 1: 

      break;
    } //end ObjID switch

    menuCloseButton.xpos = xOffset+(Width-100);
    menuCloseButton.ypos = yOffset+20;
    menuCloseButton.display();

    popStyle();
  } //end display()

  //-----------------------------------------------------------------------------------------------

  void initMenu()
  {

    //=======================
    switch(autoPosition) 
    {
    case 0:
    default:
      xOffset = xpos;
      yOffset = ypos;
      break;
    case 1: //= center X&Y
      xOffset = (width-Width)/2;
      yOffset = (height-Height)/2;
      break;
    }//end switch   
    //====================

    switch(ObjID)
    {
    case 1:
    
       break;
    } //end ObjID switch
  } //end display()

  //-----------------------------------------------------------------------------------------------

  boolean over() 
  {
    if (mouseXS >= xpos && mouseXS <= xpos+Width && mouseYS >= ypos && mouseYS <= ypos+Height) 
    {      
      return true;
    } else {
      return false;
    }
  } //end over()

  //-----------------------------------------------------------------------------------------------

  boolean overEllipse() 
  {
    if (mouseXS >= xpos-(Width/2) && mouseXS <= xpos+(Width/2) && mouseYS >= ypos-(Height/2) && mouseYS <= ypos+(Height/2)) 
    {      
      return true;
    } 
    else {
      return false;
    }
  } //end over()  

  //-----------------------------------------------------------------------------------------------

  boolean mousePressed()
  {

    switch(ObjID)
    {
    case 1:
      break;  
    } //end switch
    return false;
  } //end mouse pressed
} //end overlayMenu class

MIT License

Copyright (c) 2018 Northern Lights Electronic Design, LLC
 
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
 Date Updated: September 5, 2018
 Software Version:  2b
 Webpage: www.NLEDShop.com/nledconfig
 Written in Processing v3.3.7  - www.Processing.org
 
 //============================================================================================================
 
 The most recent firmware updates can be found at http://www.nledshop.com/deviceupdates/

 Supported Devices: 
	 NLED Pixel Controller Mini - version 4 firmware
	 NLED Pixel Controller Micro
	 
	 NLED Pixel Controller Ion
	 NLED Pixel Controller Electron
	 
	 NLED 16-Bit RGBW Lamp Controller
	 NLED 30 Channel High Current LED Controller
	 NLED Quasar
	 
	 Legacy Supported Devices: Note, if not working correctly use NLED Aurora Control Version 1
 	 NLED Four Channel Controller Mini
	 NLED 4 Channel DMX Wash Controller
 
 
 Unsupported Devices, Use NLED Configuration Software v.1c
	 NLED OctoSequencer Controller
 

 Unsupported Devices, Use NLED Aurora Control Version 2
	 None
  
  //============================================================================================================
 
 Instructions:
	1. Start software, use the distrubtion for your operating system
	2. Open the manual selection drop down, if your device is listed, select it.
	3. Select the COM port assigned to the device or the USB to serial adpater from the drop down.
	4. If you are using a USB to serial adapter, select the baud rate if available. If drop down is greyed-out, the baud was automatically selected
	5. Click the "Connect" button.
	6. Wait for device to be connected, watch the status messages for details.
	7. Once connected, the software will load the device specific configuration modules.
	8. Use the module drop downs, buttons, check boxes, and text fields and adjust the values to your requirements.
	9. Once all the configurations have been adjusted. Click the "Upload Configurations" button, and confirm.
	10. The status message will indicate if it was succesful. Some devices do not indicate success, see the device datasheet for details.
	11. Check if your device is functioning as required then close the software.
	
Possible Issues:
	1. If your COM port does not show up, or the software has crashed or closed unexpectily. Close the software, power cycle the device, and restart the software.
		If the issue persists, open Task Manager and make sure no "java.exe" or "javaw.exe" tasks are running, if they are end them.
 
 
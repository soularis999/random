// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : text.cpp
// Date           : February 2008
//
// Description    : Refer to description in corresponding header.
//
// ///////////////////////////////////////////////////////////////////////////


// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include "text.h"
#include <stdarg.h>

// ///////////////////////////////////////////////////////////////////////////
// STATIC INITIALIZATION
// ///////////////////////////////////////////////////////////////////////////
std::vector<CText*> CText::allText;
LPDIRECT3DDEVICE9   CText::pD3DDevice = NULL;
char                CText::fontName[30];


// ///////////////////////////////////////////////////////////////////////////
// CONSTRUCTORS AND DESTRUCTORS
// ///////////////////////////////////////////////////////////////////////////
CText::CText(int xVal, int yVal, int wVal, int hVal, char* str, int size, int weight, bool italics, int alignVal, int colorVal) {
   // Add instance to the static allText member
   allText.push_back(this);

   // Copy parameter values into private members
   x = xVal;
   y = yVal;
   w = wVal;
   h = hVal;
   alignment = alignVal;
   color = colorVal;

   // Unhide text by default
   isHidden = false;

   // Copy initial string into text
   // NOTE:  For more complex string assignments (ie. variable arguments),
   //        use SetText()
   strcpy_s(text,MAX_TEXT_LEN,str);
   text[MAX_TEXT_LEN-1] = 0;

   // Create font using provided parameters
   D3DXCreateFontA(pD3DDevice,size,0,weight,0,italics,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,
                  DEFAULT_QUALITY,DEFAULT_PITCH|FF_DONTCARE,fontName,&pFont);
}

CText::~CText() {
   // Delete font
   pFont->Release();

   // Remove text from static vector
   std::vector<CText*>::iterator t;
   for (t = allText.begin(); t != allText.end(); t++) {
      if ((*t) == this) {
         allText.erase(t);
         break;
      }
   }
}

// ///////////////////////////////////////////////////////////////////////////
// PROTECTED/PRIVATE METHODS
// ///////////////////////////////////////////////////////////////////////////
void CText::render() {
   // Define rectangle around text using x/y/w/h parameters
   RECT rct;
   rct.left = x;
   rct.top = y;
   rct.right = x + w;
   rct.bottom = y + h;

   // Render rectangle around text
   pFont->DrawTextA(NULL,text,-1,&rct,alignment,color);
}


// ///////////////////////////////////////////////////////////////////////////
// PUBLIC METHODS
// ///////////////////////////////////////////////////////////////////////////
void CText::Move(int xVal, int yVal) {
   x = xVal;
   y = yVal;
}

void CText::SetText(char* str, ...) {
   // Copy string with optional arguments into 'text' member
   va_list argp;
   va_start(argp, str);
   vsprintf_s(text,MAX_TEXT_LEN,str,argp);
   va_end(argp);

   // Force terminating character at end of text[] in case overrun
   text[MAX_TEXT_LEN-1] = 0;
}

void CText::Hide() { isHidden = true; }
void CText::Unhide() { isHidden = false; }


// ///////////////////////////////////////////////////////////////////////////
// STATIC METHODS
// ///////////////////////////////////////////////////////////////////////////
void CText::Init(LPDIRECT3DDEVICE9 d3ddev, char* font) {
   Log("Initializing CText...\n");
   // Reference device pointer
   pD3DDevice = d3ddev;

   // Copy specified font name
   strcpy_s(fontName,30,font);
}

void CText::RenderAll() {
   // Loop through all text instances and Render() if not hidden
   std::vector<CText*>::iterator t;
   for (t = allText.begin(); t != allText.end(); t++) {
      if (!(*t)->isHidden) (*t)->render();
   }
}

void CText::ReacquireDevice() {
   // When application loses focus and main DX device is lost, sub-devices
   // must be reacquired before the main device can be reset.
   Log("CText()  Lost D3DXFONT device.  Reacquiring...\n");
   // Loop through all text instances and require them
   std::vector<CText*>::iterator t;
   for (t = allText.begin(); t != allText.end(); t++) {
      (*t)->pFont->OnLostDevice();
   }
}

void CText::ResetDevice() {
   // When application loses focus and main DX device is lost, sub-devices
   // must be reset after the main device is reset.
   Log("CText()  Lost D3DXFONT device.  Reseting...\n");
   // Loop through all text instances and require them
   std::vector<CText*>::iterator t;
   for (t = allText.begin(); t != allText.end(); t++) {
      (*t)->pFont->OnResetDevice();
   }
}

// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////

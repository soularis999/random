// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : input.h
// Date           : February 2008
//
// Description    : This file defines the CInput class used to handle all mouse
//                  and keyboard input via DirectInput.
//
//                  Init() must be called at the beginning of the main program
//                  to ensure the keyboard and mouse inputs are setup properly.
//
// ///////////////////////////////////////////////////////////////////////////
#pragma once


// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include <d3d9.h>
#include <d3dx9.h>

// DIRECTINPUT_VERSION should be defined before dinput.h included
// to prevent "Undefined version" warning. 
#define DIRECTINPUT_VERSION      0x0800
#include <dinput.h>

#include "global.h"
#include "sprite.h"
#include "text.h"

// ///////////////////////////////////////////////////////////////////////////
// CONSTANTS (#define)
// ///////////////////////////////////////////////////////////////////////////
#define DIM_LB       0
#define DIM_RB       1
#define DIM_MB       2
#define DIM_4B       3
#define DIM_5B       4
#define DIM_6B       5
#define DIM_7B       6
#define DIM_8B       7


// ///////////////////////////////////////////////////////////////////////////
// CLASS DEFINITION
// ///////////////////////////////////////////////////////////////////////////
class CInput {

   // ////////////////////////////////////////////////////////////////////////
   // PROTECTED/PRIVATE METHODS
   // ////////////////////////////////////////////////////////////////////////
   protected:
      // /////////////////////////////////////////////////////////////////////
      // STATIC COMPONENTS
      static LPDIRECTINPUT8    pDInput;
      static LPDIRECTINPUTDEVICE8 pDIKeyboard;
      static LPDIRECTINPUTDEVICE8 pDIMouse;

      static char keyCurrState[256];
      static char keyPrevState[256];
      static bool anyKeyPressed;

      static DIMOUSESTATE2 mouseCurrState;
      static DIMOUSESTATE2 mousePrevState;
      static int mouseX;
      static int mouseY;

      static CSprite* pPointer;
      static CText*   pLocation;


   // ////////////////////////////////////////////////////////////////////////
   // PUBLIC METHODS
   // ////////////////////////////////////////////////////////////////////////
   public:
      // /////////////////////////////////////////////////////////////////////
      // CONSTRUCTORS/DESTRUCTORS
      CInput();
      ~CInput();

      // /////////////////////////////////////////////////////////////////////
      // STATIC METHODS
      static void Init(HWND hWnd);
      static void Release();

      static void Update();
      static bool KeyPressed(int key);
      static bool KeyDown(int key);
      static bool AnyKeyPressed();
      static bool MouseButtonPressed(int button);
      static bool MouseButtonDown(int button);

      static int  MouseX();
      static int  MouseY();
      static void SetMouseBoundaries();
};

// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : input.cpp
// Date           : February 2008
//
// Description    : Refer to description in corresponding header.
//
// ///////////////////////////////////////////////////////////////////////////


// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include "input.h"
#pragma comment(lib,"dinput8.lib")
#pragma comment(lib,"dxguid.lib")

// ///////////////////////////////////////////////////////////////////////////
// CONSTANTS (#define)
// ///////////////////////////////////////////////////////////////////////////
LPDIRECTINPUT8       CInput::pDInput = NULL;
LPDIRECTINPUTDEVICE8 CInput::pDIKeyboard = NULL;
LPDIRECTINPUTDEVICE8 CInput::pDIMouse = NULL;
char                 CInput::keyCurrState[256];
char                 CInput::keyPrevState[256];
bool                 CInput::anyKeyPressed;
DIMOUSESTATE2        CInput::mouseCurrState;
DIMOUSESTATE2        CInput::mousePrevState;
int                  CInput::mouseX = 0;
int                  CInput::mouseY = 0;
CSprite*             CInput::pPointer;
CText*               CInput::pLocation;

// ///////////////////////////////////////////////////////////////////////////
// STATIC INITIALIZATION
// ///////////////////////////////////////////////////////////////////////////


// ///////////////////////////////////////////////////////////////////////////
// CONSTRUCTORS AND DESTRUCTORS
// ///////////////////////////////////////////////////////////////////////////
CInput::CInput() {
}

CInput::~CInput() {
}


// ///////////////////////////////////////////////////////////////////////////
// STATIC METHODS
// ///////////////////////////////////////////////////////////////////////////
void CInput::Init(HWND hWnd) {
   Log("Initializing static members of CInput...\n");

   // Create LPDIRECTINPUT8 device
   HRESULT hr = DirectInput8Create(GetModuleHandle(NULL),
                                   DIRECTINPUT_VERSION,
                                   IID_IDirectInput8,
                                   (void**)&pDInput,
                                   NULL);

   // Create LPDIRECTINPUTDEVICE8 for keyboard control
   // NOTE: Set to FOREGROUND to only use keyboard when application currently
   //       has the focus.
   pDInput->CreateDevice(GUID_SysKeyboard,
                         &pDIKeyboard,
                         NULL);
   pDIKeyboard->SetDataFormat(&c_dfDIKeyboard);
   pDIKeyboard->SetCooperativeLevel(hWnd,DISCL_FOREGROUND|DISCL_NONEXCLUSIVE|DISCL_NOWINKEY);
   pDIKeyboard->Acquire();

   // Create LPDIRECTINPUTDEVICE8 for mouse control
   // NOTE: Set to FOREGROUND to only use mouse when application currently
   //       has the focus.
   pDInput->CreateDevice(GUID_SysMouse,
                         &pDIMouse,
                         NULL);
   pDIMouse->SetDataFormat(&c_dfDIMouse2);
   pDIMouse->SetCooperativeLevel(hWnd,DISCL_FOREGROUND|DISCL_NONEXCLUSIVE|DISCL_NOWINKEY);
   pDIMouse->Acquire();

   // Restrict mouse movement to confines of the screen boundaries
   SetMouseBoundaries();

   // Create sprite for the mouse pointer
   pPointer = new CSprite(0,0,SPRITE_TYPE_MOUSE);
   pPointer->AddImage("mouse.png");
   pPointer->Unhide();

   // Hide Windows mouse pointer
   ShowCursor(false);

   // Create CText for current mouse location (used for debugging)
   pLocation = new CText(600,570,SCREEN_WIDTH,30,"",20,FW_BOLD,false,DT_LEFT,0xff000000);

   // Clear input states
   ZeroMemory(keyCurrState,sizeof(keyCurrState));
   ZeroMemory(keyPrevState,sizeof(keyPrevState));
   ZeroMemory(&mouseCurrState,sizeof(mouseCurrState));
   ZeroMemory(&mousePrevState,sizeof(mousePrevState));
   anyKeyPressed = false;
}

void CInput::Release() {
   Log("Releasing CInput...\n");

   // Release DirectInput device
   if (pDInput != NULL) {
      pDInput->Release();
      pDInput = NULL;
   }

   // Unacquire and release keyboard device, if defined
   if (pDIKeyboard != NULL) {
      pDIKeyboard->Unacquire();
      pDIKeyboard->Release();
      pDIKeyboard = NULL;
   }

   // Unacquire and release mouse device, if defined
   if (pDIMouse != NULL) {
      pDIMouse->Unacquire();
      pDIMouse->Release();
      pDIMouse = NULL;
   }

   // Delete pointer sprite
   delete pPointer;

   // Delete mouse location text
   delete pLocation;
}

void CInput::Update() {
   HRESULT hr;

   // Reset flag to indicate if *any* key is pressed
   anyKeyPressed = false;

   // Copy current state into previous state to easily determine if
   // state has changed since the last Update().
   for (int i=0; i<256; i++) {

      // Check if any key has just been pressed
      if (!anyKeyPressed && KeyPressed(i)) anyKeyPressed = true;

      // Backup keyboard current state
      keyPrevState[i] = keyCurrState[i];
   }

   // Backup mouse current state
   mousePrevState = mouseCurrState;

   // Update current keyboard state
   hr = pDIKeyboard->GetDeviceState(sizeof(keyCurrState),(LPVOID)&keyCurrState);

   // If DI_OK is not returned, then keyboard device has probably been
   // lost due to a focus change and must be re-acquired.
   if (hr != DI_OK) pDIKeyboard->Acquire();

   // Update current mouse state
   hr = pDIMouse->GetDeviceState(sizeof(mouseCurrState),(LPVOID)&mouseCurrState);

   // If DI_OK is not returned, then mouse device has probably been
   // lost due to a focus change and must be re-acquired.
   if (hr != DI_OK) pDIMouse->Acquire();

   // Update mouseX by incremental X returned from device update
   mouseX += mouseCurrState.lX;

   // Update mouseY by incremental Y returned from device update
   mouseY += mouseCurrState.lY;

   // Ensure mouseX/Y remain within the screen boundaries of
   // x=[0,SCREEN_WIDTH] and y=[0,SCREEN_HEIGHT]
   mouseX = max(0,min(SCREEN_WIDTH-1,mouseX));
   mouseY = max(0,min(SCREEN_HEIGHT-1,mouseY));

   // Move mouse sprite
   pPointer->Move(mouseX,mouseY);

#if USE_DEBUG == 1
   // Update mouse location debug text (if USE_DEBUG asserted)
   pLocation->SetText("Mouse (%i,%i)  d(%i,%i)",mouseX,mouseY,mouseCurrState.lX,mouseCurrState.lY);
#endif

}

void CInput::SetMouseBoundaries() {
   // Use ClipCursor() to ensure the mouse does not travel outside of the
   // application boundaries (SCREEN_WIDTH x SCREEN_HEIGHT)
   RECT boundaries;
   boundaries.left = 0;
   boundaries.right = SCREEN_WIDTH - 1;
   boundaries.top = 0;
   boundaries.bottom = SCREEN_HEIGHT - 1;
   ClipCursor(&boundaries);
}

bool CInput::KeyDown(int key) {
   // Check if key is current held down
   return ((keyCurrState[key] & 0x80) != 0);
}

bool CInput::KeyPressed(int key) {
   // Check if key has just been pressed (since the last frame)
   return (((keyPrevState[key] & 0x80) == 0)
               && ((keyCurrState[key] & 0x80) != 0));
}

bool CInput::AnyKeyPressed() {
   // Check if any key has just been pressed (since last frame)
   return anyKeyPressed;
}

bool CInput::MouseButtonDown(int button) {
   // Check if mouse button is current held down
   return ((mouseCurrState.rgbButtons[button] & 0x80) != 0);
}

bool CInput::MouseButtonPressed(int button) {
   // Check if mouse button has just been pressed (since the last frame)
   return (((mousePrevState.rgbButtons[button] & 0x80) == 0)
               && ((mouseCurrState.rgbButtons[button] & 0x80) != 0));
}

int CInput::MouseX() { return mouseX; }
int CInput::MouseY() { return mouseY; }

// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////
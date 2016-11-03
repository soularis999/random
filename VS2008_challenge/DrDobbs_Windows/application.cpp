// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : application.cpp
// Date           : February 2008
//
// Description    : Refer to description in corresponding header.
//
// ///////////////////////////////////////////////////////////////////////////


// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include "application.h"


// ///////////////////////////////////////////////////////////////////////////
// CONSTANTS (#define)
// ///////////////////////////////////////////////////////////////////////////
// define the screen resolution and keyboard macrosq
#define WINDOWED_MODE   FALSE
#define WINDOW_STYLE    (WS_EX_TOPMOST | WS_POPUP)
#define WINDOW_X        0
#define WINDOW_Y        0

#define GUI_INTRO       0
#define GUI_MENU        1
#define GUI_GAME        2

// ///////////////////////////////////////////////////////////////////////////
// CONSTRUCTORS AND DESTRUCTORS
// ///////////////////////////////////////////////////////////////////////////
CApplication::CApplication() {
   // Initialize log file
   InitLog();
   Log("CApplication()  Creating CApplication...\n");

   // Seed random number generator
   srand((unsigned)time(NULL));

   // Create and initialize struct for window information
   WNDCLASSEX wc;
   ZeroMemory(&wc,sizeof(WNDCLASSEX));

   // Populate with window information
   wc.cbSize = sizeof(WNDCLASSEX);
   wc.style = CS_HREDRAW | CS_VREDRAW;
   wc.lpfnWndProc = (WNDPROC)WindowProc;
   wc.hInstance = GetModuleHandle(NULL);
   wc.hCursor = LoadCursor(NULL,IDC_ARROW);
   wc.lpszClassName = L"WindowClass";

   // Register window class
   Log("CApplication()  Registering window class...\n");
   RegisterClassEx(&wc);

   // Create window
   Log("CApplication()  Creating window...\n");
   hWnd = CreateWindowEx(NULL,
                         L"WindowClass",    // name of the window class
                         L"Dr. Dobb's Challenges",   // title of the window
                         WINDOW_STYLE,    // window style
                         WINDOW_X,    // x-position of the window
                         WINDOW_Y,    // y-position of the window
                         SCREEN_WIDTH,    // width of the window
                         SCREEN_HEIGHT,    // height of the window
                         NULL,    // we have no parent window, NULL
                         NULL,    // we aren't using menus, NULL
                         GetModuleHandle(NULL),    // application handle
                         NULL);    // used with multiple windows, NULL

   // Display window
   Log("CApplication()  Displaying window...\n");
   ShowWindow(hWnd,SW_SHOWNORMAL);

   // Create Direct3D interface
   Log("CApplication()  Initializing Direct3D...\n");
   pD3D = Direct3DCreate9(D3D_SDK_VERSION);

   // Init and create Direct3D parameters (for new device)
   ZeroMemory(&d3dParam, sizeof(d3dParam));
   d3dParam.Windowed = WINDOWED_MODE;           // Set windowed mode
   d3dParam.hDeviceWindow = hWnd;               // Set to the current window
   d3dParam.SwapEffect = D3DSWAPEFFECT_DISCARD; // Discard previous buffer after swap
   d3dParam.BackBufferFormat = D3DFMT_X8R8G8B8; // Set backbuffer format to 32-bit
   d3dParam.BackBufferWidth = SCREEN_WIDTH;     // Set the width of buffer
   d3dParam.BackBufferHeight = SCREEN_HEIGHT;   // Set the height of buffer

   // Create Direct3D interface
   pD3D->CreateDevice(D3DADAPTER_DEFAULT,
                     D3DDEVTYPE_HAL,
                     hWnd,
                     D3DCREATE_SOFTWARE_VERTEXPROCESSING,
                     &d3dParam,
                     &pD3DDevice);

   // Initialize remaining members
   isRunning   = true;
   gui         = GUI_INTRO;
   pGuiIntro   = NULL;
   pGuiMenu    = NULL;
   pGuiGame    = NULL;
}

CApplication::~CApplication() {
   Log("CApplication()  Releasing CApplication...\n");

   // Release Direct3D device
   pD3DDevice->Release();

   // Release Direct3D interface
   pD3D->Release();
}

// ///////////////////////////////////////////////////////////////////////////
// PUBLIC METHODS
// ///////////////////////////////////////////////////////////////////////////
void CApplication::Init() {
   // Initialize core components
   // NOTE:  This is not included in the constructor because it requires
   //        access to static members, which causes problems when done
   //        outside of WinMain().
   Log("CApplication()  Initializing core...\n");
   CText::Init(pD3DDevice, "Arial");
   CSprite::Init(pD3D,pD3DDevice);
   CInput::Init(hWnd);
   CSound::Init(hWnd);
   CLevel::Init();

   Log("CApplication()  Loading Introduction and Main Menu GUIs...\n");
   pGuiIntro = new CIntro();
}

void CApplication::Release() {
   // Release GUI screens, if it hasn't already been done
   Log("CApplication()  Releasing GUI...\n");
   if (pGuiIntro != NULL) delete pGuiIntro;
   if (pGuiMenu  != NULL) delete pGuiMenu;
   if (pGuiGame  != NULL) delete pGuiGame;

   // Release core components
   // NOTE:  This is not included in the destructor because it requires
   //        access to static members, which causes problems when done
   //        outside of WinMain().
   Log("CApplication()  Releasing core...\n");
   CLevel::Release();
   CInput::Release();
   CSound::Release();
   CSprite::Release();
}

void CApplication::Update() {
   // Update CInput for any changes to keyboard and mouse state
   CInput::Update();

   switch(gui) {
      case GUI_GAME:
         // Update GAME GUI
         pGuiGame->Update();

         // Check if GAME GUI has been exited
         if (pGuiGame->Stop()) {

            // Update score if level completed
            if (pGuiGame->Victory()) {
               CLevel::GetLevel(pGuiMenu->GetLevel())->UpdateScore(pGuiGame->GetScore());
            }

            // Delete GAME GUI
            delete pGuiGame;
            pGuiGame = NULL;

            // Switch to MAINMENU GUI
            gui = GUI_MENU;
            pGuiMenu->Unhide();
         }
         break;

      case GUI_MENU:
         // Update MAINMENU GUI
         pGuiMenu->Update();

         // Check if level has been selected
         if (pGuiMenu->Start()) {
            // Create new GAME GUI
            pGuiGame = new CGame(CLevel::GetLevel(pGuiMenu->GetLevel()),pGuiMenu->GetPlayer());

            // Switch to GAME GUI
            gui = GUI_GAME;
            pGuiMenu->Hide();
         }
         break;

      case GUI_INTRO:
         // Update INTRO GUI
         pGuiIntro->Update();

         // Check if intro closed
         if (pGuiIntro->Close()) {
            // Create new MAINMENU GUI
            pGuiMenu  = new CMainMenu();

            // Switch to MAINMENU GUI
            gui = GUI_MENU;

            // Delete INTRO GUI
            delete pGuiIntro;
            pGuiIntro = NULL;
         }
         break;
   }

   // Check for QUIT button
   if ((pGuiMenu != NULL) && pGuiMenu->Quit()) PostMessage(hWnd, WM_DESTROY, 0, 0);

   // Handle debug exit from any screen
   if (CInput::KeyPressed(DIK_BACKSPACE)) PostMessage(hWnd, WM_DESTROY, 0, 0);

}

void CApplication::Render() {
   // Begin 3D scene
   pD3DDevice->BeginScene();

   // Render all visible sprites
   CSprite::RenderAll();

   // Render all visible text
   CText::RenderAll();

   // Re-render mouse sprite
   // NOTE: This is done to force drawing the mouse atop of all other sprites
   //       and text.  The alternative would be to universally define a z-value
   //       for each CSprite and CText, then render each sprite with an
   //       individual Begin() and End().  This is necessary because text
   //       doesn't seem to get rendered if DrawText() is called between the
   //       D3DXSPRITE Begin() and End().
   CSprite::RenderMouse();

   // End 3D scene
   pD3DDevice->EndScene();

   // Swap buffers to display the created frame on the screen
   pD3DDevice->Present(NULL,NULL,NULL,NULL);
}


void CApplication::Destroy() {
   // Set isRunning flag to FALSE
   isRunning = false;
}

void CApplication::Activate() {
   // Ignore activate if pD3DDev has not yet been defined
   if (pD3DDevice == NULL) return;

   // When DX applications are reset, some DX devices are lost and need to be
   // re-acquired and reset.  The return value from TestCooperativeLevel()
   // will indicate if this is necessary.
   HRESULT hr = pD3DDevice->TestCooperativeLevel();

   // If flagged as not reset, then main DX device can be reset
   if (hr == D3DERR_DEVICENOTRESET) {
      Log("CApplication()  Reseting Direct3D device...\n");

      // First volatile resources must be re-acquired
      CSprite::ReacquireDevice();
      CText::ReacquireDevice();

      // Direct3D device can then be reset properly
      pD3DDevice->Reset(&d3dParam);

      // Once the main device is reset, the subdevices can also be reset
      CSprite::ResetDevice();
      CText::ResetDevice();

      // Mouse boundaries must be reset
      CInput::SetMouseBoundaries();

   // If flagged as lost, the device is not ready to be reset yet.
   } else if (hr == D3DERR_DEVICELOST) {
      Log("CApplication()  Direct3D device has been lost.  Waiting to reset...\n");

   // If TestCooperativeLevel() returns something other than DEVICENOTRESET,
   // D3DERR_DEVICELOST or OK, then it is an unhandled error and the
   // application should be exited.
   } else if (hr != D3D_OK) {
      Log("CApplication()  Error (%x) from TestCooperativeLevel()\n", hr);
      isRunning = false;
   }
}

bool CApplication::IsRunning() { return isRunning; }

// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////

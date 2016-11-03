// /////////////////////////////////////////////////////////////////////////////
// DR DOBB'S CHALLENGES
//
// Filename       : main.cpp
// Date           : February 2008
//
// Description    : This file defines the main program.  It is primarily
//                  responsible for instantiating the game application
//                  (CApplication) and then constantly updating/rendering
//                  it within a loop until the application is exited.
//
//                  WindowProc() callback method is also defined in this file
//                  to handle all messages on the queue.  The messages of
//                  primary interest are WM_DESTROY (when the application
//                  is exited and window destroyed) and WM_ACTIVATE (when
//                  the application regains window focus).
//
// ///////////////////////////////////////////////////////////////////////////


// ///////////////////////////////////////////////////////////////////////////
// HEADERS (#include)
// ///////////////////////////////////////////////////////////////////////////
#include "application.h"


// ///////////////////////////////////////////////////////////////////////////
// GLOBALS
// ///////////////////////////////////////////////////////////////////////////
CApplication g_app;


// ///////////////////////////////////////////////////////////////////////////
// MAIN PROGRAM
// ///////////////////////////////////////////////////////////////////////////
int WINAPI WinMain(HINSTANCE hCurrInst,
                   HINSTANCE hPrevInst,
                   LPSTR pCmdline,
                   int modeDisplay) {

   // Create message struct
   MSG msg;

   // Initialize static members of application
   g_app.Init();

   // Main game loop based on isRunning status from application
   while(g_app.IsRunning()) {

      // Obtain current tick count at beginning of each loop
      DWORD startTick = GetTickCount();

      // Check if any messages are on the queue
      if (PeekMessage(&msg,NULL,0,0,PM_REMOVE)) {
         // Translate and dispatch to WindowProc if not WM_QUIT
         TranslateMessage(&msg);
         DispatchMessage(&msg);
      }

      // Update application
      g_app.Update();

      // Render application
      g_app.Render();

      // Wait until MS_PER_FRAME ticks have elapsed
      while ((GetTickCount() - startTick) < MS_PER_FRAME);
   }

   // Release static members of application
   g_app.Release();

   // Return WM_QUIT message to Windows
   return msg.wParam;
}


// ///////////////////////////////////////////////////////////////////////////
// MESSAGE HANDLER
// ///////////////////////////////////////////////////////////////////////////
LRESULT CALLBACK WindowProc(HWND hWnd,
                            UINT message,
                            WPARAM wParam,
                            LPARAM lParam) {

   // Check for handled messages
   switch(message) {

      // WM_DESTROY.  Window closed
      case WM_DESTROY:
         Log("WindowProc()  Received WM_DESTROY message.\n");
         g_app.Destroy();
         return 0;

      // WM_ACTIVATEAPP.  Window regained focus
      case WM_ACTIVATEAPP:
         Log("WindowProc()  Received WM_ACTIVATEAPP message.\n");
         g_app.Activate();
         return 0;
   }

   // Handle any messages the switch statement didn't
   return DefWindowProc(hWnd, message, wParam, lParam);
}

// ///////////////////////////////////////////////////////////////////////////
// END OF CODE
// ///////////////////////////////////////////////////////////////////////////
